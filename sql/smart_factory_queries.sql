-- 1. Total planned and actual production
SELECT
    SUM(planned_quantity) AS total_planned_quantity,
    SUM(actual_quantity) AS total_actual_quantity
FROM production_orders;

-- 2. Production efficiency by order
SELECT
    order_id,
    product_id,
    machine_id,
    shift,
    planned_quantity,
    actual_quantity,
    ROUND((actual_quantity * 100.0) / planned_quantity, 2) AS production_efficiency_percent
FROM production_orders;

-- 3. Planned vs actual production by product
SELECT
    product_id,
    SUM(planned_quantity) AS planned_quantity,
    SUM(actual_quantity) AS actual_quantity,
    ROUND((SUM(actual_quantity) * 100.0) / SUM(planned_quantity), 2) AS efficiency_percent
FROM production_orders
GROUP BY product_id;

-- 4. Total downtime by machine
SELECT
    machine_id,
    SUM(downtime_minutes) AS total_downtime_minutes,
    ROUND(SUM(downtime_minutes) / 60.0, 2) AS total_downtime_hours
FROM downtime_events
GROUP BY machine_id
ORDER BY total_downtime_minutes DESC;

-- 5. Top downtime reasons
SELECT
    downtime_reason,
    COUNT(*) AS event_count,
    SUM(downtime_minutes) AS total_downtime_minutes
FROM downtime_events
GROUP BY downtime_reason
ORDER BY total_downtime_minutes DESC;

-- 6. Defect rate by product
SELECT
    p.product_id,
    SUM(q.defects_found) AS total_defects,
    SUM(p.actual_quantity) AS total_actual_quantity,
    ROUND((SUM(q.defects_found) * 100.0) / SUM(p.actual_quantity), 2) AS defect_rate_percent
FROM production_orders p
JOIN quality_inspections q
    ON p.order_id = q.order_id
GROUP BY p.product_id
ORDER BY defect_rate_percent DESC;

-- 7. Shift-wise production performance
SELECT
    shift,
    SUM(planned_quantity) AS planned_quantity,
    SUM(actual_quantity) AS actual_quantity,
    ROUND((SUM(actual_quantity) * 100.0) / SUM(planned_quantity), 2) AS efficiency_percent
FROM production_orders
GROUP BY shift;

-- 8. Pass vs fail count
SELECT
    inspection_result,
    COUNT(*) AS inspection_count,
    SUM(defects_found) AS total_defects
FROM quality_inspections
GROUP BY inspection_result;

-- 9. Daily production trend
SELECT
    date,
    SUM(planned_quantity) AS planned_quantity,
    SUM(actual_quantity) AS actual_quantity
FROM production_orders
GROUP BY date
ORDER BY date;

-- 10. Machine details with downtime
SELECT
    m.machine_id,
    m.machine_name,
    m.line,
    m.machine_type,
    SUM(d.downtime_minutes) AS total_downtime_minutes
FROM machines m
JOIN downtime_events d
    ON m.machine_id = d.machine_id
GROUP BY m.machine_id, m.machine_name, m.line, m.machine_type
ORDER BY total_downtime_minutes DESC;
