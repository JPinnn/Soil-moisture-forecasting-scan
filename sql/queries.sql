

SELECT
    station,
    month(ts)     AS mon,
    AVG(sm2)      AS sm2,
    AVG(sm8)      AS sm8,
    AVG(sm20)     AS sm20,
    SUM((sm8 < 10)::INT) AS dry_hours
FROM sc
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT
    CASE
        WHEN r24 > 10 THEN 'heavy'
        WHEN r24 > 0  THEN 'light'
        ELSE 'none'
    END AS rain24,
    AVG(sm2 - sm2_lag24) AS dsm2
FROM (
    SELECT
        *,
        SUM(prcp) OVER (
            PARTITION BY station
            ORDER BY ts
            ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
        ) AS r24,
        LAG(sm2, 24) OVER (PARTITION BY station ORDER BY ts) AS sm2_lag24
    FROM sc
)
GROUP BY 1;


CREATE OR REPLACE TABLE feat AS
SELECT
    station,
    ts,
    sm2, sm4, sm8, sm20, st2, prcp, tair, ws,
    hour(ts)  AS hr,
    month(ts) AS mon,

    -- Lag features (quá khứ)
    LAG(sm8, 24)  OVER w AS sm8_lag24,
    LAG(sm8, 168) OVER w AS sm8_lag7d,
    LAG(sm8, 1)   OVER w AS sm8_lag1,
    LAG(sm8, 6)   OVER w AS sm8_lag6,

    -- Delta features (rate of change gần đây)
    sm8 - LAG(sm8, 24)  OVER w AS sm8_delta24,
    sm8 - LAG(sm8, 6)   OVER w AS sm8_delta6,

    -- Rolling sum/avg (quá khứ)
    SUM(prcp) OVER (w ROWS BETWEEN 23  PRECEDING AND CURRENT ROW) AS r24,
    SUM(prcp) OVER (w ROWS BETWEEN 167 PRECEDING AND CURRENT ROW) AS r7d,
    AVG(tair) OVER (w ROWS BETWEEN 71  PRECEDING AND CURRENT ROW) AS t3d,

    -- Target (tương lai)
    LEAD(sm8, 24) OVER w AS y_24h,
    LEAD(sm8, 72) OVER w AS y_72h

FROM sc
WINDOW w AS (PARTITION BY station ORDER BY ts);

SELECT
    COUNT(*)     AS n,
    COUNT(y_72h) AS n72
FROM feat;
