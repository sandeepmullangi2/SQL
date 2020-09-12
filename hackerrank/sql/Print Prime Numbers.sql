WITH tab AS (
  SELECT * FROM generate_series( 2, 1000 ) col
),
tab1 as (
SELECT x.col
FROM tab x
WHERE NOT EXISTS (
  SELECT 1 FROM tab y
  WHERE x.col > y.col AND x.col % y.col = 0
)
)
SELECT string_agg(col ::Text, '&') AS col1 from tab1
;