USE Rfam;

-- checking various table samples for overall understanding
SELECT * FROM taxonomy LIMIT 5;
SELECT * FROM rfamseq LIMIT 5;
SELECT * FROM family LIMIT 5;
SELECT * FROM full_region LIMIT 5;

-- 1. Types of Acacia plants found in the taxonomy table
-- Count the distinct species names that start with 'Acacia' using the LIKE 'Acacia %' condition.
SELECT
    COUNT(DISTINCT species) AS total_acacia_types
FROM taxonomy
WHERE species LIKE 'Acacia %';

-- 2. Type of wheat with the longest DNA sequence
-- Joined the taxonomy and rfamseq tables using their common ncbi_id column.
-- Used the LIKE 'Triticum %' condition to filter wheat species.
-- Triticum is the genus to which wheat belongs.
-- Sorted by length DESC to find the longest sequence, followed by rfamseq_acc ASC as a tiebreaker.
-- Used LIMIT 1 to return the wheat species with the longest sequence.
SELECT
    t.species AS wheat_type,
    r.rfamseq_acc AS sequence_id,
    r.length AS sequence_length
FROM taxonomy AS t
JOIN rfamseq AS r
    ON t.ncbi_id = r.ncbi_id
WHERE t.species LIKE 'Triticum %'
ORDER BY
    r.length DESC,
    r.rfamseq_acc ASC
LIMIT 1;

-- 3. Family sequence lengths, returning page 9 (15 results per page)
-- Joined the family, full_region, and rfamseq tables using their respective keys.
-- Grouped records by family accession and family name.
-- Used MAX(length) to find the longest associated sequence for each family.
-- Applied HAVING MAX(length) > 1000000 to filter the grouped results.
-- Sorted by maximum sequence length in descending order.
-- Used LIMIT 15 OFFSET 120 to return the 9th page, skipping the first 120 results.
SELECT
    f.rfam_acc AS family_accession,
    f.rfam_id AS family_name,
    MAX(r.length) AS max_sequence_length
FROM family AS f
JOIN full_region AS fr
    ON f.rfam_acc = fr.rfam_acc
JOIN rfamseq AS r
    ON fr.rfamseq_acc = r.rfamseq_acc
GROUP BY
    f.rfam_acc,
    f.rfam_id
HAVING MAX(r.length) > 1000000
ORDER BY
    max_sequence_length DESC,
    f.rfam_acc ASC
LIMIT 15 OFFSET 120;
