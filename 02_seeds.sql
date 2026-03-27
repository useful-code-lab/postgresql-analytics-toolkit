INSERT INTO categories (name, parent_id) VALUES 
('Electronics', NULL), 
('Laptops', 1), 
('Smartphones', 1);

INSERT INTO products (category_id, title, price, metadata) VALUES 
(2, 'MacBook Pro 14', 1999.00, '{"cpu": "M3", "ram": "16GB", "color": "Space Gray"}'),
(2, 'ThinkPad X1', 1500.00, '{"cpu": "i7", "ram": "32GB", "color": "Black"}'),
(3, 'iPhone 15', 999.00, '{"storage": "128GB", "color": "Blue"}');

INSERT INTO orders (customer_email, items, total_amount, status, created_at)
SELECT 
    'user' || i || '@example.com',
    '[{"p_id": "...", "qty": 1}]'::jsonb,
    random() * 1000 + 100,
    'paid',
    NOW() - (random() * INTERVAL '30 days')
FROM generate_series(1, 100) s(i);
