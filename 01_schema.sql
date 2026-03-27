-- Создаем перечисление для статусов, чтобы избежать мусора в данных
CREATE TYPE order_status AS ENUM ('pending', 'paid', 'shipped', 'cancelled');

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES categories(id),
    name TEXT NOT NULL
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id INTEGER REFERENCES categories(id),
    title TEXT NOT NULL,
    metadata JSONB DEFAULT '{}', -- Характеристики (цвет, размер)
    price NUMERIC(12, 2) CHECK (price > 0),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_email TEXT NOT NULL,
    items JSONB NOT NULL, -- Список id товаров и цен на момент покупки
    total_amount NUMERIC(12, 2),
    status order_status DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
