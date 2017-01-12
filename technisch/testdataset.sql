--
-- Test 1: Geboren in 2015 en op dezelfde datum ingeschreven in Amsterdam.
--
insert into persoon.persoon ( id ) values ( 1 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 1, 1, 474223401, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum,  kennisgegeven_op ) values ( 1, '2015-01-12', '2015-01-31' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op,  kennisgegeven_op ) values ( 1, 363, '2015-01-12', '2015-01-31' );

--
-- Test 2: Geboorte in 2015 en op dezelfde datum ingeschreven in Zaandam.
--
insert into persoon.persoon ( id ) values ( 2 );
insert into persoon.persoon_id ( persoon_id, type_id, code,  kennisgegeven_op ) values ( 2, 1, 534733852, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum,  kennisgegeven_op ) values ( 2, '2015-02-02', '2015-02-26' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 2, 471, '2015-02-02', '2015-02-26' );

--
-- Test 3: Geboren in 2015, maar later ingeschreven in Amsterdam
--
insert into persoon.persoon ( id ) values ( 3 );
insert into persoon.persoon_id ( persoon_id, type_id, code,  kennisgegeven_op ) values ( 3, 1, 651097794, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum,  kennisgegeven_op ) values ( 3, '2015-01-15', '2015-07-01' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op,  kennisgegeven_op ) values ( 3, 363, '2015-03-23', '2015-07-01' );

--
-- Test 4: Geboortedatum voor 1e peildatum gecorrigeerd naar hetzelfde tijdvak
--
insert into persoon.persoon ( id ) values ( 4 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 4, 1, 609717078, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 4, '2016-01-23', '2015-01-24' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 4, '2015-01-23', '2015-07-01' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op,  kennisgegeven_op ) values ( 4, 363, '2015-01-23', '2015-07-01' );

--
-- Test 5: Geboren in Amsterdam, inschrijvingsdatum correctie, vertrokken naar Zaandam, en weer teruggekomen
--
insert into persoon.persoon ( id ) values ( 5 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 5, 1, 38525252, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 5, '2015-04-22', '2015-04-22' );
-- Persoon 4 woont in Amsterdam bij zijn geboorte. Inschrijvingsdatum is ouder dan geboortedatum.
-- Deze inschrijvingsdatum wordt gecorrigeerd naar geboortedatum op dezelfde kennisgegeven_op.
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 5, 363, '2015-04-21', '2015-04-22' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 5, 363, '2015-04-22', '2015-04-22' );
-- Persoon 4 vertrekt naar Zaandam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 5, 471, '2015-05-14', '2015-05-15' );
-- Persoon 4 komt terug uit Zaandam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 5, 363, '2015-06-16', '2015-07-01' );
-- Persoon 4 vertrekt weer naar Zaandam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 5, 471, '2015-06-30', '2015-07-03' );
-- Persoon 4 komt weer terug uit Zaandam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 5, 363, '2015-07-28', '2015-10-01' );

--
-- Test 6: Geboortedatum na 1e peildatum gecorrigeerd, naar volgend tijdvak
--
insert into persoon.persoon ( id ) values ( 6 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 6, 1, 458698957, '1900-01-01' );
-- Persoon 6 is geboren in 2015
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 6, '2015-08-06', '2016-01-20' );
-- Persoon 6 wordt gecorrigeerd naar niet geboren in 2015, maar hetzelfde als inschrijvingsdatum
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 6, '2016-01-18', '2016-01-24' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 6, 363, '2016-01-18', '2016-01-21' );

--
-- Test 7: Geboortedatum na 1e peildatum gecorrigeerd naar hetzelfde tijdvak
--
insert into persoon.persoon ( id ) values ( 7 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 7, 1, 181982948, '1900-01-01' );
-- Persoon 7 is geboren in 2016
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 7, '2016-01-15', '2016-01-18' );
-- Persoon 7 wordt gecorrigeerd naar hetzelfde als inschrijvingsdatum, maar na peildatum gecommuniceerd.
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 7, '2015-12-12', '2016-02-24' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 7, 363, '2015-12-12', '2016-01-18' );

--
-- Test 8: Inschrijvingsplaats gecorrigeerd, naar hetzelfde tijdvak woonachtig in Amsterdam en voor peildatum gecommuniceerd
--
insert into persoon.persoon ( id ) values ( 8 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 8, 1, 692053062, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 8, '2015-09-28', '2015-09-30' );
-- Persoon 8 woont in Zaandam bij zijn geboorte
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 8, 471, '2015-09-28', '2015-09-30' );
-- Persoon 8 wordt gecorrigeerd naar Amsterdam, maar na peildatum
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 8, 363, '2015-09-28', '2016-01-25' );

--
-- Test 9: Inschrijvingsdatum correctie, naar anders dan geboortedatum
--
insert into persoon.persoon ( id ) values ( 9 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 9, 1, 271495649, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 9, '2015-11-08', '2015-11-19' );
-- Persoon 9 is geregistreerd in Amsterdam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 9, 363, '2015-11-08', '2015-11-19' );
-- Persoon 9 wordt gecorrigeerd naar een andere inschrijvingsdatum dan geboortedatum
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 9, 363, '2015-12-04', '2015-12-08' );

--
-- Test 10: Inschrijvingsdatum correctie, naar hetzelfde als geboortedatum
--
insert into persoon.persoon ( id ) values ( 10 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 10, 1, 78219462, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 10, '2015-03-07', '2015-03-23' );
-- Persoon 10 is geregistreerd in Amsterdam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 10, 363, '2015-03-09', '2015-03-23' );
-- Persoon 10 wordt gecorrigeerd naar dezelfde inschrijvingsdatum als geboortedatum
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 10, 363, '2015-03-07', '2015-12-08' );

--
-- Test 11: Inschrijvingsdatum correctie, naar anders dan geboortedatum, maar na peildatum gecommuniceerd
--
insert into persoon.persoon ( id ) values ( 11 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 11, 1, 402494362, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 11, '2015-05-01', '2015-06-01' );
-- Persoon 11 is geregistreerd in Amsterdam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 11, 363, '2015-05-01', '2015-06-01' );
-- Persoon 11 wordt gecorrigeerd naar een andere inschrijvingsdatum dan geboortedatum, maar na peildatum
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 11, 363, '2015-05-02', '2016-03-01' );

--
-- Test 12: Inschrijvingsdatum correctie, naar anders dan geboortedatum, maar na peildatum gecommuniceerd
--
insert into persoon.persoon ( id ) values ( 12 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 12, 1, 528247761, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 12, '2015-08-04', '2015-08-11' );
-- Persoon 12 is geregistreerd in Amsterdam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 12, 363, '2015-08-11', '2015-08-11' );
-- Persoon 12 wordt gecorrigeerd naar dezelfde inschrijvingsdatum als geboortedatum, maar na peildatum
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 12, 363, '2015-08-04', '2016-08-05' );

--
-- Test 13: Geboorte en inschrijving op 31 december in tijdvak
--
insert into persoon.persoon ( id ) values ( 13 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 13, 1, 644660624, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 13, '2015-12-31', '2016-01-01' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 13, 363, '2015-12-31', '2016-01-01' );

--
-- Test 14: Geboorte en inschrijving op 1 januari in tijdvak
--
insert into persoon.persoon ( id ) values ( 14 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 14, 1, 398478429, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 14, '2015-01-01', '2015-01-05' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 14, 363, '2015-01-01', '2015-01-05' );

--
-- Test 15: Geboren en ingeschreven voor tijdvak (31-12-2014), maar in tijdvak gecommuniceerd
--
insert into persoon.persoon ( id ) values ( 15 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 15, 1, 602641627, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 15, '2014-12-31', '2015-01-05' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 15, 363, '2014-12-30', '2015-01-05' );

--
-- Test 16: Geboortedatum wijziging met dezelfde kennisgevingsdatum in tijdvak
--
insert into persoon.persoon ( id ) values ( 16 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 16, 1, 471002471, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 16, '2015-06-03', '2015-06-04' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 16, '2015-06-04', '2015-06-04' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 16, 363, '2015-06-04', '2015-06-04' );

--
-- Test 17: Geboortedatum in tijdvak waarna voor de 1e peildatum de Geboortedatum wordt gecorrigeerd naar een andere datum in tijdvak, maar met dezelfde kennisgevingsdatum. Ingeschreven in Amsterdam.
--
insert into persoon.persoon ( id ) values ( 17 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 17, 1, 013495264, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 17, '2015-11-26', '2015-11-26' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 17, '2015-11-25', '2015-11-26' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 17, 363, '2015-11-26', '2015-11-26' );

--
-- Test 18: Geboren in 2015 en op dezelfde datum ingeschreven in Amsterdam. Later in 2015 verhuisd naar Zaandam, maar met een onbekende vestigingsdatum.
--
insert into persoon.persoon ( id ) values ( 18 );
insert into persoon.persoon_id ( persoon_id, type_id, code,  kennisgegeven_op ) values ( 18, 1, 484489768, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum,  kennisgegeven_op ) values ( 18, '2015-02-02', '2015-02-26' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 18, 363, '2015-02-02', '2015-02-26' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 18, 471, NULL, '2015-09-02' );

--
-- Test 19: Geboren in 2015 en op dezelfde datum ingeschreven in Amsterdam. Later in 2015 verhuisd naar een onbekende gemeente, met een bekende inschrijvingsdatum in 2015.
--
insert into persoon.persoon ( id ) values ( 19 );
insert into persoon.persoon_id ( persoon_id, type_id, code,  kennisgegeven_op ) values ( 19, 1, 693247629, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum,  kennisgegeven_op ) values ( 19, '2015-02-02', '2015-02-26' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 19, 363, '2015-02-02', '2015-02-26' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 19, NULL, '2015-09-02', '2015-09-02' );

--
-- Test 20: Geboren in Amsterdam, inschrijvingsdatum correctie, vertrokken naar Zaandam, en weer teruggekomen, maar met onbekende Zaandamse inschrijvingsdata.
--
insert into persoon.persoon ( id ) values ( 20 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 20, 1, 201256381, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 20, '2015-04-22', '2015-04-22' );
-- Persoon 4 woont in Amsterdam bij zijn geboorte. Inschrijvingsdatum is ouder dan geboortedatum.
-- Deze inschrijvingsdatum wordt gecorrigeerd naar geboortedatum op dezelfde kennisgegeven_op.
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 20, 363, '2015-04-21', '2015-04-22' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 20, 363, '2015-04-22', '2015-04-22' );
-- Persoon 4 vertrekt naar Zaandam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 20, 471, NULL, '2015-05-15' );
-- Persoon 4 komt terug uit Zaandam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 20, 363, '2015-06-16', '2015-07-01' );
-- Persoon 4 vertrekt weer naar Zaandam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 20, 471, NULL, '2015-07-03' );
-- Persoon 4 komt weer terug uit Zaandam
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 20, 363, '2015-07-28', '2015-10-01' );

--
-- Test 21: Geboren en ingeschreven in 2015 in Amsterdam, na 1e peildatum kennisgegeven
--
insert into persoon.persoon ( id ) values ( 21 );
insert into persoon.persoon_id ( persoon_id, type_id, code, kennisgegeven_op ) values ( 21, 1, 320240186, '1900-01-01' );
insert into persoon.geboorte ( persoon_id, datum, kennisgegeven_op ) values ( 21, '2015-12-31', '2016-02-04' );
insert into persoon.inschrijving ( persoon_id, gemeente_id, ingeschreven_op, kennisgegeven_op ) values ( 21, 363, '2015-12-31', '2016-02-04' );