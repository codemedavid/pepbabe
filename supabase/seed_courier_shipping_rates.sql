-- ============================================
-- SEED COURIER-SPECIFIC SHIPPING RATES
-- Run this in Supabase SQL Editor
-- ============================================

-- 1. Clean up old generic locations that don't match our new system
-- We delete them to avoid confusion, or you can keep them if needed.
DELETE FROM shipping_locations 
WHERE id IN ('NCR', 'LUZON', 'VISAYAS_MINDANAO');

-- 2. Insert LBC Express Rates
INSERT INTO shipping_locations (id, name, fee, is_active, order_index) VALUES
('LBC_METRO_MANILA', 'LBC - Metro Manila', 150.00, true, 1),
('LBC_LUZON',        'LBC - Luzon (Provincial)', 200.00, true, 2),
('LBC_VISMIN',       'LBC - Visayas & Mindanao', 250.00, true, 3)
ON CONFLICT (id) DO UPDATE SET 
name = EXCLUDED.name, fee = EXCLUDED.fee;

-- 3. Insert J&T Express Rates
INSERT INTO shipping_locations (id, name, fee, is_active, order_index) VALUES
('JNT_LUZON',    'J&T - Luzon',    120.00, true, 4),
('JNT_VISAYAS',  'J&T - Visayas',  150.00, true, 5),
('JNT_MINDANAO', 'J&T - Mindanao', 200.00, true, 6)
ON CONFLICT (id) DO UPDATE SET 
name = EXCLUDED.name, fee = EXCLUDED.fee;

UPDATE shipping_locations
SET is_active = false
WHERE id IN ('JNT_METRO_MANILA', 'JNT_PROVINCIAL');

-- 4. Insert Same-Day / Motor Couriers
-- Rates are usually 0 (book yourself) or a flat booking fee
INSERT INTO shipping_locations (id, name, fee, is_active, order_index) VALUES
('LALAMOVE_STANDARD', 'Lalamove (Book Yourself / Rider)', 0.00, true, 7),
('MAXIM_STANDARD',    'Maxim (Book Yourself / Rider)', 0.00, true, 8)
ON CONFLICT (id) DO UPDATE SET 
name = EXCLUDED.name, fee = EXCLUDED.fee;

-- 5. Verify Entires
SELECT * FROM shipping_locations ORDER BY order_index;
