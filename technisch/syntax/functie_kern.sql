create or replace function geboorte (
	kennisgevingsdatum_begin timestamp without time zone,
	kennisgevingsdatum_eind timestamp without time zone,
	geldigheidsdatum_begin timestamp without time zone,
	geldigheidsdatum_eind timestamp without time zone
)
returns table (
	persoon_id bigint,
	bs_nummer bigint,
	a_nummer bigint,
	datum timestamp without time zone,
	kennisgegeven_op timestamp without time zone
) as $$

select
	a.persoon_id,
	d.bs_nummer,
	c.a_nummer,
	a.datum,
	a.kennisgegeven_op
from
	--
	-- Selecteer alle records waarvan de
	-- geboortedatum in het tijdvak liggen
	--
	(select
		*
	from
		--
		-- Selecteer alle geboorterecords
		-- in het tijdvak en voor de
		-- peildatum
		--
		(select
			distinct on(persoon_id)
			persoon_id,
			datum,
			geldig_op,
			kennisgegeven_op
		from
			persoon.geboorte
		where
			(case when kennisgevingsdatum_begin is null and kennisgevingsdatum_eind is null then
				true
			when kennisgevingsdatum_begin is null and kennisgevingsdatum_eind is not null then
				kennisgegeven_op < kennisgevingsdatum_eind
			when kennisgevingsdatum_begin is not null and kennisgevingsdatum_eind is null then
				kennisgegeven_op >= kennisgevingsdatum_begin
			when kennisgevingsdatum_begin is not null and kennisgevingsdatum_eind is not null then
				(kennisgegeven_op >= kennisgevingsdatum_begin and kennisgegeven_op < kennisgevingsdatum_eind)
			end)
		order by
			persoon_id, geldig_op desc, kennisgegeven_op desc, id desc
		) as a
	where
		(case when geldigheidsdatum_begin is null and geldigheidsdatum_eind is null then
			true
		when geldigheidsdatum_begin is null and geldigheidsdatum_eind is not null then
			datum < geldigheidsdatum_eind
		when geldigheidsdatum_begin is not null and geldigheidsdatum_eind is null then
			datum >= geldigheidsdatum_begin
		when geldigheidsdatum_begin is not null and geldigheidsdatum_eind is not null then
			(datum >= geldigheidsdatum_begin and datum < geldigheidsdatum_eind)
		end)
	) as a
inner join
	(select
		distinct on(persoon_id)
		persoon_id,
		ingeschreven_op
	from
		(select
			*
		from
			persoon.inschrijving
		where
			(case when kennisgevingsdatum_eind is null then
				true
			when kennisgevingsdatum_eind is not null then
				kennisgegeven_op < kennisgevingsdatum_eind
			end)
		order by
			persoon_id, geldig_op desc, kennisgegeven_op desc, id desc
		) as w
	where
		not exists (
			-- Kijk of deze persoon ook ergens anders dan in Amsterdam heeft gewoond?
			-- Zo niet, dan is de laatste inschrijfdatum over deze persoon in Amsterdam
			-- waarschijnlijk de laatst geldige inschrijfdatum welke we willen
			-- vergelijken met de geboortedatum.
			select
				1
			from
				--
				-- Zorg ervoor dat mogelijke correcties op de gemeente
				-- van inschrijving voorrang krijgen op voorgaande waarden.
				--
				(select
					distinct on(y.ingeschreven_op)
					*
				from
					--
					-- Selecteer eerst de laatst geldige waarde op een
					-- bepaalde kennisgevingsdatum.
					--
					(select
						distinct on(z.geldig_op, z.kennisgegeven_op)
						*
					from
						persoon.inschrijving as z
					where
						(case when kennisgevingsdatum_eind is null then
							true
						when kennisgevingsdatum_eind is not null then
							z.kennisgegeven_op < kennisgevingsdatum_eind
						end)
					and
						z.persoon_id = w.persoon_id
					order by
						z.geldig_op, z.kennisgegeven_op desc, id desc
					) as y
				order by
					y.ingeschreven_op asc
				) as y
			where
				--
				-- We kijken of deze persoon ergens anders heeft gewoond dan
				-- in Amsterdam door de gemeente_id te vergelijken met Amsterdam
				-- of door te kijken naar een lege gemeente_id waarde. Dat laatste kan
				-- voorkomen wanneer iemand bijvoorbeeld naar het buitenland verhuist
				-- en we in het betreffende record alleen een land_id hebben
				--
				y.gemeente_id != 363 or gemeente_id is null
			)
		or
			coalesce(
			-- Als deze persoon wel ergens anders dan in Amsterdam heeft gewoond,
			-- dan kijken we naar de eerstvolgende buitengemeentelijke
			-- inschrijfdatum. Alles wat voor die inschrijfdatum ligt, moet gaan
			-- over de eerste woonplek sinds de geboorte, en daar de laatste
			-- datum van is waarschijnlijk de meest geldige datum welke we willen
			-- vergelijken met de geboortedatum.
			(select
				distinct on (x.persoon_id)
				x.ingeschreven_op
			from
				--
				-- Zorg ervoor dat mogelijke correcties op de gemeente
				-- van inschrijving voorrang krijgen op voorgaande waarden.
				--
				(select
					distinct on(y.ingeschreven_op)
					*
				from
					--
					-- Selecteer eerst de laatst geldige waarde op een
					-- bepaalde kennisgevingsdatum.
					--
					(select
						distinct on(z.geldig_op, z.kennisgegeven_op)
						*
					from
						persoon.inschrijving as z
					where
						(case when kennisgevingsdatum_eind is null then
							true
						when kennisgevingsdatum_eind is not null then
							z.kennisgegeven_op < kennisgevingsdatum_eind
						end)
					and
						z.persoon_id = w.persoon_id
					order by
						z.geldig_op, z.kennisgegeven_op desc, z.id desc
					) as y
				order by
					y.ingeschreven_op asc
				) as x
			where
				--
				-- We kijken of deze persoon ergens anders heeft gewoond dan
				-- in Amsterdam door de gemeente_id te vergelijken met Amsterdam
				-- of door te kijken naar een lege gemeente_id waarde. Dat laatste kan
				-- voorkomen wanneer iemand bijvoorbeeld naar het buitenland verhuist
				-- en we in het betreffende record alleen een land_id hebben
				--
				x.gemeente_id != 363 or x.gemeente_id is null
			order by
				x.persoon_id asc, x.ingeschreven_op asc
			--
			-- Uit het vorige where statement weten we dat deze persoon ergens
			-- anders heeft gewoond dan in Amsterdam. Wanneer we hier echter een
			-- onbekende waarde terugkrijgen, dan betekent dat, dat we de
			-- inschrijvingsdatum van die andere woonplaats niet hebben kunnen
			-- vaststellen. Als we als gevolg hiervan de bekende Amsterdamse
			-- inschrijving niet selecteren, dan weten we zeker dat we gegevens
			-- gemist hebben. Als omweg kiezen we dan toch de laatste
			-- bekende inschrijvingsdatum in Amsterdam.
			--
			), (select
				distinct on(y.persoon_id)
				y.ingeschreven_op
			from
				--
				-- Selecteer eerst de laatst geldige waarde op een
				-- bepaalde kennisgevingsdatum.
				--
				(select
					distinct on(z.geldig_op, z.kennisgegeven_op)
					*
				from
					persoon.inschrijving as z
				where
					(case when kennisgevingsdatum_eind is null then
						true
					when kennisgevingsdatum_eind is not null then
						z.kennisgegeven_op < kennisgevingsdatum_eind
					end)
				and
					z.persoon_id = w.persoon_id
				order by
					z.geldig_op, z.kennisgegeven_op desc, z.id desc
				) as y
			where
				gemeente_id = 363
			order by
				y.persoon_id asc, ingeschreven_op asc
			) + '1 second') > w.ingeschreven_op
	order by
		w.persoon_id asc, w.geldig_op asc, w.kennisgegeven_op desc
	) as b
on
	a.persoon_id = b.persoon_id
left join
	(select
		distinct on(persoon_id)
		persoon_id,
		code as a_nummer
	from
		persoon.persoon_id
	where
		type_id = (select id from persoon.persoon_id_type where afkorting = 'AN')
	and
		(case when kennisgevingsdatum_eind is null then
			true
		when kennisgevingsdatum_eind is not null then
			kennisgegeven_op < kennisgevingsdatum_eind
		end)
	order by
		persoon_id
	) as c
on
	a.persoon_id = c.persoon_id
left join
	(select
		distinct on(persoon_id)
		persoon_id,
		code as bs_nummer
	from
		persoon.persoon_id
	where
		type_id = (select id from persoon.persoon_id_type where afkorting = 'BSN')
	and
		(case when kennisgevingsdatum_eind is null then
			true
		when kennisgevingsdatum_eind is not null then
			kennisgegeven_op < kennisgevingsdatum_eind
		end)
	order by
		persoon_id
	) as d
on
	a.persoon_id = d.persoon_id
where
	a.datum = b.ingeschreven_op
and
	(case when geldigheidsdatum_begin < kennisgevingsdatum_begin then
		d.bs_nummer not in (select bsnumm from bron.kw20171)
	else
		true
	end)
order by
	persoon_id;

$$ language sql;
