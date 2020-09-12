SELECT MIN(CASE WHEN Occupation = 'Doctor' THEN Name ELSE NULL END) AS Doctor,
MIN(CASE WHEN Occupation = 'Professor' THEN Name ELSE NULL END) AS Professor, 
MIN(CASE WHEN Occupation = 'Singer' THEN Name ELSE NULL END) AS Singer, 
MIN(CASE WHEN Occupation = 'Actor' THEN Name ELSE NULL END) AS Actor 
FROM 
( 
SELECT a.Occupation, a.Name, DENSE_RANK() OVER (PARTITION BY a.Occupation ORDER BY a.Name) rank FROM occupations a 
) c 
GROUP BY c.rank ORDER BY c.rank; 