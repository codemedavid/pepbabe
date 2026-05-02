-- Align checkout J&T Express rates with the published shipping schedule.

INSERT INTO public.shipping_locations (id, name, fee, is_active, order_index) VALUES
  ('JNT_LUZON', 'J&T - Luzon', 120.00, true, 4),
  ('JNT_VISAYAS', 'J&T - Visayas', 150.00, true, 5),
  ('JNT_MINDANAO', 'J&T - Mindanao', 200.00, true, 6)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  fee = EXCLUDED.fee,
  is_active = EXCLUDED.is_active,
  order_index = EXCLUDED.order_index,
  updated_at = now();

UPDATE public.shipping_locations
SET is_active = false,
    updated_at = now()
WHERE id IN ('JNT_METRO_MANILA', 'JNT_PROVINCIAL');
