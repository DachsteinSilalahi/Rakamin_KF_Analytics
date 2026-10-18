CREATE OR REPLACE TABLE `rakamin-kf-analytics-512003.kimia_farma.tabel_analisa` AS
SELECT 
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    p.price AS actual_price,
    t.discount_percentage,
    
    -- Menentukan persentase gross laba berdasarkan rentang harga
    CASE 
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
        ELSE 0
    END AS persentase_gross_laba,
    
    -- Menghitung nett sales (harga dikurangi diskon)
    (p.price - (p.price * t.discount_percentage / 100)) AS nett_sales,
    
    -- Menghitung nett profit (nett sales dikali persentase gross laba)
    ((p.price - (p.price * t.discount_percentage / 100)) * 
    CASE 
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
        ELSE 0
    END) AS nett_profit,
    
    t.rating AS rating_transaksi

FROM 
    `rakamin-kf-analytics-512003.kimia_farma.kf_final_transaction` AS t
LEFT JOIN 
    `rakamin-kf-analytics-512003.kimia_farma.kf_kantor_cabang` AS c 
    ON t.branch_id = c.branch_id
LEFT JOIN 
    `rakamin-kf-analytics-512003.kimia_farma.kf_product` AS p 
    ON t.product_id = p.product_id;
