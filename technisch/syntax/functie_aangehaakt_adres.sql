create or replace function geboorte_aangehaakt_adres()
returns table (
	anummr bigint,
	bsnumm bigint,
	unicod bigint,
	gbdtb8 int,
	gslcha char,
	lndgbb bigint,
	gebpla char,
	bevcbs bigint,
	etncbs bigint,
	natiob bigint,
	uniou1 bigint,
	uniou2 bigint,
	gslou1 char,
	gslou2 char,
	gblou1 bigint,
	gblou2 bigint,
	gbdou1 bigint,
	gbdou2 bigint,
	lftou1 double precision,
	lftou2 double precision,
	leefmd double precision,
	bevou1 bigint,
	bevou2 bigint,
	etnou1 bigint,
	etnou2 bigint,
	huisnr int,
	huislt char,
	hstoev char,
	pttkod char,
	adrs15 text,
	strkod bigint,
	bagids bigint,
	numids bigint,
	brtk15 text,
	bctk15 text,
	stad15 text,
	i22geb character varying,
	i27geb character varying,
	altbrt15 character varying,
	rayon15 character varying,
	brtk10 character varying,
	tydber int
) as $$

select
	distinct on(anummr, bsnumm)
	a.anummr,
	a.bsnumm,
	a.unicod,
	a.gbdtb8,
	a.gslcha,
	a.lndgbb,
	a.gebpla,
	a.bevcbs,
	a.etncbs,
	a.natiob,
	a.uniou1,
	a.uniou2,
	a.gslou1,
	a.gslou2,
	a.gblou1,
	a.gblou2,
	a.gbdou1,
	a.gbdou2,
	a.lftou1,
	a.lftou2,
	a.leefmd,
	a.bevou1,
	a.bevou2,
	a.etnou1,
	a.etnou2,
	a.huisnr,
	a.huislt,
	a.hstoev,
	case when a.pttkod is null and b.postcode is not null then
		b.postcode
	else
		a.pttkod
	end as pttkod,
	case when a.strkod is null then
		lpad(coalesce(b.straatcode::char(5), '00000'), 5, '0') || lpad(coalesce(a.huisnr::char(5), '00000'), 5, '0') || lpad(coalesce(a.huislt::char(1), ' '), 1, ' ') || rpad(coalesce(a.hstoev::char(4), '    '), 4, ' ')
	else
		lpad(coalesce(a.strkod::char(5), '00000'), 5, '0') || lpad(coalesce(a.huisnr::char(5), '00000'), 5, '0') || lpad(coalesce(a.huislt::char(1), ' '), 1, ' ') || rpad(coalesce(a.hstoev::char(4), '    '), 4, ' ')
	end as adrs15,
	case when a.strkod is null then
		b.straatcode
	else
		a.strkod
	end as strkod,
	b.object_id as bagids,
	b.nummer_id as numids,
	b.buurtcode as brtk15,
	substring(b.buurtcode, 1, 3) as bctk15,
	substring(b.buurtcode, 1, 1) as stad15,
	(select i22geb from bron.kwadrs where brtk15 = b.buurtcode and i22geb is not null order by kwartaal desc limit 1) as i22geb,
	(select i27geb from bron.kwadrs where brtk15 = b.buurtcode and i27geb is not null order by kwartaal desc limit 1) as i27geb,
	(select altbrt15 from bron.kwadrs where brtk15 = b.buurtcode and altbrt15 is not null order by kwartaal desc limit 1) as altbrt15,
	(select rayon15 from bron.kwadrs where brtk15 = b.buurtcode and rayon15 is not null order by kwartaal desc limit 1) as rayon15,
	(select brtk10 from bron.kwadrs as k where k.pttkod = a.pttkod and k.huisnr = a.huisnr and coalesce(k.huislt, '-') = coalesce(a.huislt, '-') and k.brtk10 is not null order by k.kwartaal desc limit 1) as brtk10,
	a.tydber
from
	persoon.geboorte_aangehaakt as a
left join lateral
	(select
		*
	from
		geef_bag_informatie_voor_adres(a.pttkod, a.strkod, a.huisnr, a.huislt, a.hstoev, a.gbdtb8::char(8)::timestamp without time zone)
	) as b
on true
where
	--
	-- Validatiecriteria
	--
	coalesce(substr(a.pttkod, 1, 4)::int, 0000) >= 1000 and coalesce(substr(a.pttkod, 1, 4)::int, 0000) <= 1109
order by
	a.anummr, a.bsnumm;

$$ language sql;