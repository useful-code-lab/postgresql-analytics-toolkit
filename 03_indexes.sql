-- GIN-индекс для быстрого поиска внутри JSONB (характеристики товаров)
CREATE INDEX idx_products_metadata ON products USING GIN (metadata);

-- Индекс на дату заказа для быстрой фильтрации отчетов
CREATE INDEX idx_orders_created_at ON orders (created_at DESC);

-- Частичный индекс (только для активных заказов) — экономит место на диске
CREATE INDEX idx_orders_pending ON orders (status) WHERE status = 'pending';
