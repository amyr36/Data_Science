WITH OrderBase AS (
    SELECT
        c.CustomerID,
        COUNT(soh.SalesOrderID) AS TotalOrders,
        SUM(soh.TotalDue) AS TotalRevenue,
        AVG(soh.TotalDue) AS AvgOrderValue,
        MIN(soh.OrderDate) AS FirstOrderDate,
        MAX(soh.OrderDate) AS LastOrderDate
    FROM Sales.Customer AS c
    JOIN Sales.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
),

-- Find the last order date in the dataset as reference
MaxOrderDate AS (
    SELECT MAX(OrderDate) AS MaxDate
    FROM Sales.SalesOrderHeader
),

CustomerFeatures AS (
    SELECT
        ob.CustomerID,
        TotalOrders,
        TotalRevenue,
        AvgOrderValue,
        FirstOrderDate,
        LastOrderDate,
        -- RecencyDays: distance from last order to dataset's last order
        DATEDIFF(DAY, LastOrderDate, md.MaxDate) AS RecencyDays,
        DATEDIFF(MONTH, FirstOrderDate, LastOrderDate) AS CustomerLifetimeMonths
    FROM OrderBase ob
    CROSS JOIN MaxOrderDate md
),

CustomerSegmentation AS (
    SELECT
        CustomerID,
        TotalOrders,
        TotalRevenue,
        AvgOrderValue,
        CustomerLifetimeMonths,
        RecencyDays,
        -- Activity segmentation
        CASE
            WHEN RecencyDays <= 90 THEN 'Active'
            WHEN RecencyDays BETWEEN 91 AND 180 THEN 'AtRisk'
            WHEN RecencyDays BETWEEN 181 AND 365 THEN 'Inactive'
            ELSE 'Churned'
        END AS ActivitySegment,
        -- Target for ML
        CASE
            WHEN RecencyDays > 180 THEN 1
            ELSE 0
        END AS IsInactive
    FROM CustomerFeatures
)

SELECT *
FROM CustomerSegmentation
ORDER BY RecencyDays DESC;






