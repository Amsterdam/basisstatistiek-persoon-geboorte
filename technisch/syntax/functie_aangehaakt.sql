create or replace function geboorte_aangehaakt()
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
	strkod bigint,
	tydber int
) as $$

select
	distinct on(a.a_nummer, a.bs_nummer)
	a.a_nummer as anummr,
	a.bs_nummer as bsnumm,
	c.unicod,
	to_char(a.datum, 'YYYYMMDD')::int as gbdtb8,
	(select coalesce("O_geslachtsaanduiding", "N_geslachtsaanduiding") from bron.brp_stuf_csv as z where "O_bsn" = a.bs_nummer or "N_bsn" = a.bs_nummer order by "Tijdstip bericht" desc limit 1) as gslcha,
	c.lndgbb,
	c.gebpla,
	c.bevcbs,
	c.etncbs,
	c.natiob,
	c.uniou1,
	c.uniou2,
	d.gslcha as gslou1,
	e.gslcha as gslou2,
	d.lndgbb as gblou1,
	e.lndgbb as gblou2,
	d.gbdtb8 as gbdou1,
	e.gbdtb8 as gbdou2,
	-- Leeftijd bij geboorte kind
	extract('years' from age(a.datum, to_timestamp(d.gbdtb8::char(8), 'YYYYMMDD')::timestamp without time zone)) as lftou1,
	extract('years' from age(a.datum, to_timestamp(e.gbdtb8::char(8), 'YYYYMMDD')::timestamp without time zone)) as lftou2,
	case when d.gslcha = 'V' or e.gslcha != 'V' then
			extract('years' from age(a.datum, to_timestamp(d.gbdtb8::char(8), 'YYYYMMDD')::timestamp without time zone))
	else
			extract('years' from age(a.datum, to_timestamp(e.gbdtb8::char(8), 'YYYYMMDD')::timestamp without time zone))
	end as leefmd,
	-- Herkomst en modelclassificatie herkomstgroepering ouders toegevoegd--V2
	d.bevcbs as bevou1,
	e.bevcbs as bevou2,
	d.etncbs as etnou1,
	e.etncbs as etnou2,
	g.huisnummer as huisnr,
	g.huisletter as huislt,
	g.huisnummertoevoeging as hstoev,
	(g.postcode4::char(4) || g.postcode2)::char(6) as pttkod,
	g.straat_id as strkod,
	to_char(a.kennisgegeven_op, 'YYYYMMDD')::int as tydber
from
	persoon.geboorte_kern as a
left join lateral
	(select
		distinct on(a_nummer, bs_nummer)
		*
	from
		(
			select '201701' as kwartaal, unicod, anummr, bsnumm, lndgbb, gebpla, bevcbs, etncbs, natiob, uniou1, uniou2 from bron.kw20171 as z where (a.a_nummer = z.anummr or a.bs_nummer = z.bsnumm)
		union all
			select '201704' as kwartaal, unicod, anummr, bsnumm, lndgbb, gebpla, bevcbs, etncbs, natiob, uniou1, uniou2 from bron.kw20172 as y where (a.a_nummer = y.anummr or a.bs_nummer = y.bsnumm)
		union all
			select '201707' as kwartaal, unicod, anummr, bsnumm, lndgbb, gebpla, bevcbs, etncbs, natiob, uniou1, uniou2 from bron.kw20173 as x where (a.a_nummer = x.anummr or a.bs_nummer = x.bsnumm)
		union all
			select '201710' as kwartaal, unicod, anummr, bsnumm, lndgbb, gebpla, bevcbs, etncbs, natiob, uniou1, uniou2 from bron.kw20174 as w where (a.a_nummer = w.anummr or a.bs_nummer = w.bsnumm)
		union all
			select '201801' as kwartaal, unicod, anummr, bsnumm, lndgbb, gebpla, bevcbs, etncbs, natiob, uniou1, uniou2 from bron.kw20181 as v where (a.a_nummer = v.anummr or a.bs_nummer = v.bsnumm)
		) as b
	order by
		a_nummer, bs_nummer, abs(extract(day from a.datum - to_timestamp(kwartaal::char(6), 'YYYYMM')::timestamp without time zone))
	) as c
on
	(
		a.a_nummer = c.anummr
or
		a.bs_nummer = c.bsnumm
	)
left join lateral
	(select
		distinct on(unicod)
		*
	from
		(
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20181 as z where (z.unicod = c.uniou1)
		union all
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20174 as y where (y.unicod = c.uniou1)
		union all
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20173 as x where (x.unicod = c.uniou1)
		union all
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20172 as w where (w.unicod = c.uniou1)
		union all
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20171 as v where (v.unicod = c.uniou1)
		) as b
	order by
		unicod, peildt desc
	) as d
on
	d.unicod = c.uniou1
left join lateral
	(select
		distinct on(unicod)
		*
	from
		(
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20181 as z where (z.unicod = c.uniou2)
		union all
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20174 as y where (y.unicod = c.uniou2)
		union all
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20173 as x where (x.unicod = c.uniou2)
		union all
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20172 as w where (w.unicod = c.uniou2)
		union all
			select peildt, unicod, anummr, bsnumm, gslcha, gbdtb8, lndgbb, bevcbs, etncbs from bron.kw20171 as v where (v.unicod = c.uniou2)
		) as b
	order by
		unicod, peildt desc
	) as e
on
	e.unicod = c.uniou2
left join
	persoon.adres as g
on
	g.persoon_id = a.persoon_id
and
	g.geldig_op <= a.datum
order by
	a.a_nummer, a.bs_nummer, g.geldig_op desc, g.kennisgegeven_op desc, g.id desc;

$$ language sql;