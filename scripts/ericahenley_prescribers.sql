-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

-- SELECT MAX(prescription.total_claim_count) AS most_claims, prescriber.nppes_provider_last_org_name, prescription.npi, prescriber.npi
-- FROM prescription
-- INNER JOIN prescriber
-- ON prescription.npi = prescriber.npi
-- 	GROUP BY prescriber.nppes_provider_last_org_name, prescription.npi, prescriber.npi
-- 	ORDER BY most_claims desc
-- LIMIT 1;


-- COFFEY, 1912011792, 4538 claims


--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

-- SELECT MAX(prescription.total_claim_count) AS most_claims, prescriber.nppes_provider_last_org_name, prescription.npi, prescriber.npi, prescriber.nppes_provider_first_name, prescriber.specialty_description
-- FROM prescription
-- INNER JOIN prescriber
-- ON prescription.npi = prescriber.npi
-- GROUP BY prescriber.nppes_provider_last_org_name, prescription.npi, prescriber.npi, prescriber.nppes_provider_first_name, prescriber.specialty_description
-- ORDER BY most_claims desc
-- 	LIMIT 1;

-- DAVID COFFEY, Family Practice, 1912011792, 4538 claims

-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

-- SELECT prescriber.specialty_description, max(prescription.total_claim_count) AS most_claims
-- FROM prescriber
-- INNER JOIN prescription
-- ON prescriber.npi = prescription.npi
-- GROUP BY prescriber.specialty_description
-- ORDER BY most_claims desc
-- LIMIT 1;

-- Family Practice, 4538 claims

--     b. Which specialty had the most total number of claims for opioids?

-- SELECT prescriber.specialty_description, MAX(drug.opioid_drug_flag) AS opioids
-- FROM prescriber
-- LEFT JOIN drug
-- ON prescriber.specialty_description = drug.opioid_drug_flag
-- GROUP BY prescriber.specialty_description 
-- ORDER BY prescriber.specialty_description desc
-- LIMIT 1;


-- ?? null value

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

-- SELECT npi
-- 	FROM prescriber
-- 	WHERE npi NOT IN 
-- 	(SELECT npi
-- 	from prescription)
-- 	EXCEPT
-- 	SELECT specialty_description
-- 	FROM prescriber
	

-- use except here


--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?

-- SELECT drug.generic_name, ROUND(MAX(prescription.total_drug_cost),2) AS highest_cost
-- FROM drug
-- INNER JOIN prescription
-- ON drug.drug_name = prescription.drug_name
-- GROUP BY drug.generic_name
-- ORDER BY highest_cost desc
-- LIMIT 1;

-- Pirfenidone, 2829174.3

--     b. Which drug (generic_name) has the hightest total cost per day? 
-- **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

-- SELECT drug.generic_name, ROUND(MAX(prescription.total_drug_cost)/prescription.total_day_supply,2) AS highest_cost
-- FROM drug
-- INNER JOIN prescription
-- ON drug.drug_name = prescription.drug_name
-- GROUP BY drug.generic_name, prescription.total_day_supply
-- ORDER BY highest_cost desc
-- LIMIT 1;

-- "IMMUN GLOB G(IGG)/GLY/IGA OV50", 7141.11

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' 
-- for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', 
-- 	and says 'neither' for all other drugs.
-- **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/ 

-- SELECT drug_name, opioid_drug_flag, antibiotic_drug_flag,
-- CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- ELSE 'neither'
-- END drug_type,
-- CASE WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- ELSE 'neither'
-- END drug_type
-- FROM drug;


--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. 
-- Hint: Format the total costs as MONEY for easier comparision.


-- select sum(prescription.total_drug_cost)::MONEY as pre, opioid_drug_flag, antibiotic_drug_flag
-- from prescription
-- inner join drug
-- using(drug_name)
-- group by opioid_drug_flag, antibiotic_drug_flag
-- order by pre desc
	
-- ??? not sure if correct


-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

-- SELECT COUNT(cbsa.cbsa) as cbsa_count, fips_county.state
-- FROM cbsa
-- LEFT JOIN fips_county
-- USING(fipscounty)
-- WHERE cbsa.cbsaname LIKE '%TN'
-- AND fips_county.state LIKE '%TN'
-- GROUP BY fips_county.state

--33

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

-- SELECT cbsa.cbsa, cbsa.cbsaname, fips_county.state, MAX(population.population) AS pop
-- FROM cbsa
-- LEFT JOIN fips_county
-- USING(fipscounty)
-- LEFT JOIN population
-- USING(fipscounty)
-- WHERE cbsa.cbsaname LIKE '%TN'
-- AND fips_county.state LIKE '%TN'
-- GROUP BY fips_county.state, cbsa.cbsa, cbsa.cbsaname
-- ORDER BY pop desc
-- LIMIT 1;

-- Largest population: "Nashville-Davidson--Murfreesboro--Franklin, TN", 678322


-- SELECT cbsa.cbsa, cbsa.cbsaname, fips_county.state, MIN(population.population) AS pop
-- FROM cbsa
-- LEFT JOIN fips_county
-- USING(fipscounty)
-- LEFT JOIN population
-- USING(fipscounty)
-- WHERE cbsa.cbsaname LIKE '%TN'
-- AND fips_county.state LIKE '%TN'
-- GROUP BY fips_county.state, cbsa.cbsa, cbsa.cbsaname
-- ORDER BY pop desc
-- LIMIT 1;

-- Smallest population: "Morristown, TN", 52887

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- SELECT cbsa.cbsa, cbsa.fipscounty, population.fipscounty, MAX(population.population) AS pop
-- FROM cbsa
-- LEFT JOIN population
-- USING(fipscounty)
-- WHERE pop NOT IN cbsa.cbsa
-- GROUP BY cbsa.cbsa, cbsa.fipscounty, population.fipscounty
-- ORDER BY pop desc
-- LIMIT 1

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

-- select drug_name, total_claim_count
-- FROM prescription
-- 	WHERE total_claim_count >= 3000

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
	
-- select prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag
-- FROM prescription
-- LEFT JOIN drug
-- ON drug.drug_name = prescription.drug_name
-- WHERE prescription.total_claim_count >= 3000


--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- select prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag, prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name
-- FROM prescription
-- LEFT JOIN drug
-- ON drug.drug_name = prescription.drug_name
-- LEFT JOIN prescriber
-- ON prescriber.npi = prescription.npi
-- WHERE prescription.total_claim_count >= 3000

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. 
-- **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists 
-- (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'),
-- where the drug is an opioid (opiod_drug_flag = 'Y'). 
-- **Warning:** Double-check your query before running it. 
-- 	You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

-- SELECT npi, drug_name, specialty_description, nppes_provider_city, opioid_drug_flag
-- FROM drug
-- CROSS JOIN prescriber
-- WHERE specialty_description = 'Pain Management'
-- AND nppes_provider_city = 'NASHVILLE'
-- AND opioid_drug_flag = 'Y'

--    b. Next, report the number of claims per drug per prescriber. 
-- Be sure to include all combinations, whether or not the prescriber had any claims. 
-- 	You should report the npi, the drug name, and the number of claims (total_claim_count).


-- SELECT prescriber.npi, drug.drug_name, prescription.total_claim_count
-- FROM prescriber
-- cross JOIN prescription
-- cross JOIN drug
-- WHERE specialty_description = 'Pain Management'
-- AND nppes_provider_city = 'NASHVILLE'
-- AND opioid_drug_flag = 'Y'


-- --     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. 
-- Hint - Google the COALESCE function.

-- SELECT prescriber.npi, drug.drug_name, specialty_description, nppes_provider_city, opioid_drug_flag, total_claim_count
-- FROM prescriber
-- 	LEFT JOIN prescription
-- 	USING(npi)
-- cross JOIN drug
-- WHERE specialty_description = 'Pain Management'
-- AND nppes_provider_city = 'NASHVILLE'
-- AND opioid_drug_flag = 'Y'