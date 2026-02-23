-- ============================================================
-- RFM Analysis + Customer Features + Churn Labels
-- ============================================================

CREATE OR ALTER PROCEDURE report_customer_rfm
    @AsOfDate DATE = '2024-12-29',
    @ChurnThresholdDays INT = 180,
    @AtRiskThresholdDays INT = 90
AS
BEGIN
    SET NOCOUNT ON;

    -- Aggregate order data
    ;WITH CustomerAggregates AS
    (
        SELECT
            soh.CustomerID,
            COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
            SUM(sod.OrderQty) AS TotalQuantity,
            SUM(sod.LineTotal) AS TotalAmount,
            SUM(soh.TaxAmt) AS TotalTaxAmount,
            AVG(sod.OrderQty) AS AvgOrderQuantity,
            AVG(soh.TaxAmt) AS AvgTaxAmount,
            MIN(soh.OrderDate) AS FirstOrderDate,
            MAX(soh.OrderDate) AS LastOrderDate
        FROM Sales.SalesOrderHeader soh
        JOIN Sales.SalesOrderDetail sod
            ON soh.SalesOrderID = sod.SalesOrderID
        WHERE soh.CustomerID IS NOT NULL
        GROUP BY soh.CustomerID
    ),

    CustomerFeatures AS
    (
        SELECT
            CustomerID,
            OrderCount,
            TotalQuantity,
            TotalAmount,
            TotalTaxAmount,
            AvgOrderQuantity,
            AvgTaxAmount,
            FirstOrderDate,
            LastOrderDate,

            -- RFM Calculations
            DATEDIFF(DAY, LastOrderDate, @AsOfDate) AS RecencyDays,
            DATEDIFF(DAY, FirstOrderDate, LastOrderDate) AS CustomerLifetimeDays,

            -- RFM Scores (Quintiles)
            NTILE(5) OVER (ORDER BY DATEDIFF(DAY, LastOrderDate, @AsOfDate) ASC) AS RecencyScore,
            NTILE(5) OVER (ORDER BY OrderCount DESC) AS FrequencyScore,
            NTILE(5) OVER (ORDER BY TotalAmount DESC) AS MonetaryScore

        FROM CustomerAggregates
    )

    SELECT
        CustomerID,
        LastOrderDate,
        FirstOrderDate,
        RecencyDays,
        CustomerLifetimeDays,
        OrderCount,
        TotalQuantity,
        TotalAmount,
        TotalTaxAmount,
        AvgOrderQuantity,
        AvgTaxAmount,
        RecencyScore,
        FrequencyScore,
        MonetaryScore,

        -- Total RFM Score
        (RecencyScore + FrequencyScore + MonetaryScore) AS TotalRFMScore,

        -- Churn / At-Risk / Active Label
        CASE 
            WHEN DATEDIFF(DAY, LastOrderDate, @AsOfDate) >= @ChurnThresholdDays THEN 'Churned'
            WHEN DATEDIFF(DAY, LastOrderDate, @AsOfDate) >= @AtRiskThresholdDays THEN 'At Risk'
            ELSE 'Active'
        END AS CustomerStatus

    FROM CustomerFeatures
    ORDER BY TotalRFMScore DESC, RecencyDays ASC;

END;
