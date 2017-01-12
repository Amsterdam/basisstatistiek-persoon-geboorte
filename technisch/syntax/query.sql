--
-- stap 1
--
create materialized view persoon.geboorte_kern as
select * from geboorte('2017-01-01', '2018-02-01', '2017-01-01', '2018-01-01');

--
-- stap 2
--
create index geboorte_kern_a_nummer_idx on persoon.geboorte_kern(a_nummer);
create index geboorte_kern_bs_nummer_idx on persoon.geboorte_kern(bs_nummer);

create materialized view persoon.geboorte_aangehaakt as
select * from geboorte_aangehaakt();

--
-- stap 3
--
create index geboorte_aangehaakt_anummr_idx on persoon.geboorte_aangehaakt(anummr);
create index geboorte_aangehaakt_bsnumm_idx on persoon.geboorte_aangehaakt(bsnumm);
create index geboorte_aangehaakt_huisnr_idx on persoon.geboorte_aangehaakt(coalesce(huisnr, -999));
create index geboorte_aangehaakt_huislt_idx on persoon.geboorte_aangehaakt(coalesce(huislt, '-'));
create index geboorte_aangehaakt_hstoev_idx on persoon.geboorte_aangehaakt(coalesce(hstoev, '-'));
create index geboorte_aangehaakt_pttkod4_idx on persoon.geboorte_aangehaakt(coalesce(substr(pttkod, 1, 4)::int, 0000));
create index geboorte_aangehaakt_pttkod2_idx on persoon.geboorte_aangehaakt(coalesce(substr(pttkod, 5, 2), '-'));

create materialized view persoon.geboorte_aangehaakt_adres as
select * from geboorte_aangehaakt_adres();

grant all on persoon.geboorte_aangehaakt_adres to maurice;
grant all on persoon.geboorte_aangehaakt_adres to hans;
grant all on persoon.geboorte_aangehaakt_adres to aafke;