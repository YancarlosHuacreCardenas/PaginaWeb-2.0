-- Estructura completa para tienda de cosméticos (MySQL)

-- TABLAS PRINCIPALES

CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

DROP TABLE IF EXISTS productos;
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    precio_original DECIMAL(10,2),
    descuento INT,
    stock INT NOT NULL,
    imagen VARCHAR(100),
    categoria_id INT,
    destacado BOOLEAN DEFAULT FALSE,
    tipo VARCHAR(50),
    acabado VARCHAR(50),
    material VARCHAR(50),
    genero VARCHAR(20),
    fecha_lanzamiento DATE,
    peso DECIMAL(10,2),
    dimensiones VARCHAR(50)
);

DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    tipo_usuario ENUM('cliente','admin') DEFAULT 'cliente',
    email_verificado BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    avatar_url VARCHAR(255),
    ultimo_login DATETIME
);

DROP TABLE IF EXISTS carrito;
CREATE TABLE IF NOT EXISTS carrito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

DROP TABLE IF EXISTS pedidos;
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    puntos_ganados INT DEFAULT 0,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

DROP TABLE IF EXISTS pedido_detalles;
CREATE TABLE pedido_detalles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE IF NOT EXISTS favoritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    producto_id INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_fav (usuario_id, producto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    producto_id INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_wishlist (usuario_id, producto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS suscriptores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(150) NOT NULL UNIQUE,
    fecha_suscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS comentarios_blog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    blog_id INT NOT NULL,
    correo_suscriptor VARCHAR(150) NOT NULL,
    comentario TEXT NOT NULL,
    puntuacion INT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cupones_usados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    cupon VARCHAR(50) NOT NULL,
    fecha_uso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_coupon (usuario_id, cupon),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tarjetas_credito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    titular VARCHAR(100) NOT NULL,
    numero VARCHAR(25) NOT NULL,
    vencimiento VARCHAR(7) NOT NULL, -- MM/AAAA
    cvv VARCHAR(5) NOT NULL,
    marca VARCHAR(20),
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS direcciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    departamento VARCHAR(100),
    pais VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20),
    telefono VARCHAR(20),
    tipo ENUM('envio','facturacion') DEFAULT 'envio',
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS contactos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    asunto VARCHAR(200) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLAS PARA SISTEMA DE ENVÍOS

CREATE TABLE IF NOT EXISTS zonas_envio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    provincia VARCHAR(100),
    distrito VARCHAR(100),
    codigo_postal VARCHAR(20),
    costo_base DECIMAL(10,2) NOT NULL,
    tiempo_entrega_min INT NOT NULL, -- días
    tiempo_entrega_max INT NOT NULL, -- días
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS metodos_envio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    costo_base DECIMAL(10,2) NOT NULL,
    costo_por_kg DECIMAL(10,2) DEFAULT 0.00,
    tiempo_entrega_min INT NOT NULL, -- días
    tiempo_entrega_max INT NOT NULL, -- días
    activo BOOLEAN DEFAULT TRUE,
    prioridad INT DEFAULT 0 -- Para ordenar opciones
);

CREATE TABLE IF NOT EXISTS tarifas_envio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zona_id INT NOT NULL,
    metodo_id INT NOT NULL,
    peso_min DECIMAL(8,2) NOT NULL, -- en gramos
    peso_max DECIMAL(8,2) NOT NULL, -- en gramos
    costo DECIMAL(10,2) NOT NULL,
    tiempo_entrega_min INT NOT NULL,
    tiempo_entrega_max INT NOT NULL,
    FOREIGN KEY (zona_id) REFERENCES zonas_envio(id),
    FOREIGN KEY (metodo_id) REFERENCES metodos_envio(id)
);

-- TABLA DE PUNTOS DE USUARIO
CREATE TABLE IF NOT EXISTS puntos_usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    puntos_totales INT DEFAULT 0,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Insertar datos de ejemplo

INSERT INTO categorias (nombre, descripcion) VALUES
('sets', 'Conjuntos y kits de productos de belleza'),
('maquillaje', 'Productos para maquillaje facial, ojos y labios'),
('joyeria', 'Joyas y accesorios elegantes'),
('perfumes', 'Fragancias y perfumes de alta calidad'),
('pintalabios', 'Labiales y productos para los labios'),
('cuidado de la piel', 'Productos para el cuidado facial y corporal'),
('accesorios', 'Accesorios de belleza y moda');

INSERT INTO usuarios (nombre, email, contrasena, direccion, telefono, tipo_usuario) VALUES
('Admin', 'admin@bycint.com', 'admin123', 'Calle Principal 123', '010-420-0340', 'admin'),
('María López', 'maria@example.com', 'maria123', 'Av. Belleza 456', '010-111-2233', 'cliente');

-- ===== DATOS DE ENVÍO =====

-- Métodos de envío
INSERT INTO metodos_envio (nombre, descripcion, costo_base, costo_por_kg, tiempo_entrega_min, tiempo_entrega_max, activo, prioridad) VALUES
('Envío Estándar', 'Entrega en 3-5 días hábiles', 8.00, 2.00, 3, 5, TRUE, 1),
('Envío Express', 'Entrega en 1-2 días hábiles', 15.00, 3.50, 1, 2, TRUE, 2),
('Envío Gratis', 'Gratis en compras mayores a S/ 100', 0.00, 0.00, 5, 7, TRUE, 0),
('Retiro en Tienda', 'Recoge en nuestro local', 0.00, 0.00, 0, 0, TRUE, 3);

-- Zonas de envío (Lima y principales ciudades)
INSERT INTO zonas_envio (nombre, departamento, provincia, distrito, codigo_postal, costo_base, tiempo_entrega_min, tiempo_entrega_max, activo) VALUES
('Lima Centro', 'Lima', 'Lima', 'Lima', '15001', 5.00, 1, 2, TRUE),
('Lima Norte', 'Lima', 'Lima', 'San Martín de Porres', '15301', 6.00, 1, 3, TRUE),
('Lima Sur', 'Lima', 'Lima', 'Chorrillos', '15063', 6.00, 1, 3, TRUE),
('Lima Este', 'Lima', 'Lima', 'Ate', '15003', 7.00, 2, 3, TRUE),
('Callao', 'Callao', 'Callao', 'Callao', '07001', 8.00, 2, 3, TRUE),
('Arequipa', 'Arequipa', 'Arequipa', 'Arequipa', '04001', 12.00, 3, 5, TRUE),
('Trujillo', 'La Libertad', 'Trujillo', 'Trujillo', '13001', 12.00, 3, 5, TRUE),
('Piura', 'Piura', 'Piura', 'Piura', '20001', 15.00, 4, 6, TRUE),
('Chiclayo', 'Lambayeque', 'Chiclayo', 'Chiclayo', '14001', 14.00, 4, 6, TRUE),
('Cusco', 'Cusco', 'Cusco', 'Cusco', '08001', 18.00, 5, 7, TRUE);

-- Tarifas de envío (ejemplos para Lima Centro)
INSERT INTO tarifas_envio (zona_id, metodo_id, peso_min, peso_max, costo, tiempo_entrega_min, tiempo_entrega_max) VALUES
-- Lima Centro - Estándar
(1, 1, 0, 500, 5.00, 1, 2),
(1, 1, 500, 1000, 7.00, 1, 2),
(1, 1, 1000, 2000, 9.00, 1, 2),
-- Lima Centro - Express
(1, 2, 0, 500, 15.00, 1, 1),
(1, 2, 500, 1000, 18.00, 1, 1),
(1, 2, 1000, 2000, 22.00, 1, 1),
-- Lima Centro - Gratis (solo para compras > S/ 100)
(1, 3, 0, 2000, 0.00, 3, 5);

-- ===== PRODUCTOS DE EJEMPLO (30 por categoría) =====

-- 30 productos para SETS (categoria_id = 1)
INSERT INTO productos (nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado) VALUES
('Set Especial 1', 'Set de productos de belleza edición especial.', 49.90, 59.90, 17, 50, 'producto_destacado.png', 1, FALSE),
('Set Especial 2', 'Set de productos de belleza edición especial.', 50.90, 60.90, 16, 40, 'producto_destacado.png', 1, FALSE),
('Set Especial 3', 'Set de productos de belleza edición especial.', 51.90, 61.90, 16, 35, 'producto_destacado.png', 1, FALSE),
('Set Especial 4', 'Set de productos de belleza edición especial.', 52.90, 62.90, 16, 60, 'producto_destacado.png', 1, FALSE),
('Set Especial 5', 'Set de productos de belleza edición especial.', 53.90, 63.90, 16, 45, 'producto_destacado.png', 1, FALSE),
('Set Especial 6', 'Set de productos de belleza edición especial.', 54.90, 64.90, 15, 55, 'producto_destacado.png', 1, FALSE),
('Set Especial 7', 'Set de productos de belleza edición especial.', 55.90, 65.90, 15, 38, 'producto_destacado.png', 1, FALSE),
('Set Especial 8', 'Set de productos de belleza edición especial.', 56.90, 66.90, 15, 42, 'producto_destacado.png', 1, FALSE),
('Set Especial 9', 'Set de productos de belleza edición especial.', 57.90, 67.90, 15, 47, 'producto_destacado.png', 1, FALSE),
('Set Especial 10', 'Set de productos de belleza edición especial.', 58.90, 68.90, 15, 53, 'producto_destacado.png', 1, FALSE),
('Set Especial 11', 'Set de productos de belleza edición especial.', 59.90, 69.90, 14, 50, 'producto_destacado.png', 1, FALSE),
('Set Especial 12', 'Set de productos de belleza edición especial.', 60.90, 70.90, 14, 40, 'producto_destacado.png', 1, FALSE),
('Set Especial 13', 'Set de productos de belleza edición especial.', 61.90, 71.90, 14, 35, 'producto_destacado.png', 1, FALSE),
('Set Especial 14', 'Set de productos de belleza edición especial.', 62.90, 72.90, 14, 60, 'producto_destacado.png', 1, FALSE),
('Set Especial 15', 'Set de productos de belleza edición especial.', 63.90, 73.90, 14, 45, 'producto_destacado.png', 1, FALSE),
('Set Especial 16', 'Set de productos de belleza edición especial.', 64.90, 74.90, 13, 55, 'producto_destacado.png', 1, FALSE),
('Set Especial 17', 'Set de productos de belleza edición especial.', 65.90, 75.90, 13, 38, 'producto_destacado.png', 1, FALSE),
('Set Especial 18', 'Set de productos de belleza edición especial.', 66.90, 76.90, 13, 42, 'producto_destacado.png', 1, FALSE),
('Set Especial 19', 'Set de productos de belleza edición especial.', 67.90, 77.90, 13, 47, 'producto_destacado.png', 1, FALSE),
('Set Especial 20', 'Set de productos de belleza edición especial.', 68.90, 78.90, 13, 53, 'producto_destacado.png', 1, FALSE),
('Set Especial 21', 'Set de productos de belleza edición especial.', 69.90, 79.90, 13, 50, 'producto_destacado.png', 1, FALSE),
('Set Especial 22', 'Set de productos de belleza edición especial.', 70.90, 80.90, 12, 40, 'producto_destacado.png', 1, FALSE),
('Set Especial 23', 'Set de productos de belleza edición especial.', 71.90, 81.90, 12, 35, 'producto_destacado.png', 1, FALSE),
('Set Especial 24', 'Set de productos de belleza edición especial.', 72.90, 82.90, 12, 60, 'producto_destacado.png', 1, FALSE),
('Set Especial 25', 'Set de productos de belleza edición especial.', 73.90, 83.90, 12, 45, 'producto_destacado.png', 1, FALSE),
('Set Especial 26', 'Set de productos de belleza edición especial.', 74.90, 84.90, 12, 55, 'producto_destacado.png', 1, FALSE),
('Set Especial 27', 'Set de productos de belleza edición especial.', 75.90, 85.90, 12, 38, 'producto_destacado.png', 1, FALSE),
('Set Especial 28', 'Set de productos de belleza edición especial.', 76.90, 86.90, 11, 42, 'producto_destacado.png', 1, FALSE),
('Set Especial 29', 'Set de productos de belleza edición especial.', 77.90, 87.90, 11, 47, 'producto_destacado.png', 1, FALSE),
('Set Especial 30', 'Set de productos de belleza edición especial.', 78.90, 88.90, 11, 53, 'producto_destacado.png', 1, FALSE);

-- 30 productos para MAQUILLAJE (categoria_id = 2)
INSERT INTO productos (nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado) VALUES
('Maquillaje Pro 1', 'Producto de maquillaje profesional.', 19.90, 24.90, 20, 50, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 2', 'Producto de maquillaje profesional.', 20.90, 25.90, 19, 40, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 3', 'Producto de maquillaje profesional.', 21.90, 26.90, 19, 35, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 4', 'Producto de maquillaje profesional.', 22.90, 27.90, 18, 60, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 5', 'Producto de maquillaje profesional.', 23.90, 28.90, 17, 45, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 6', 'Producto de maquillaje profesional.', 24.90, 29.90, 17, 55, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 7', 'Producto de maquillaje profesional.', 25.90, 30.90, 16, 38, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 8', 'Producto de maquillaje profesional.', 26.90, 31.90, 16, 42, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 9', 'Producto de maquillaje profesional.', 27.90, 32.90, 15, 47, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 10', 'Producto de maquillaje profesional.', 28.90, 33.90, 15, 53, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 11', 'Producto de maquillaje profesional.', 29.90, 34.90, 14, 50, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 12', 'Producto de maquillaje profesional.', 30.90, 35.90, 14, 40, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 13', 'Producto de maquillaje profesional.', 31.90, 36.90, 14, 35, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 14', 'Producto de maquillaje profesional.', 32.90, 37.90, 13, 60, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 15', 'Producto de maquillaje profesional.', 33.90, 38.90, 13, 45, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 16', 'Producto de maquillaje profesional.', 34.90, 39.90, 13, 55, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 17', 'Producto de maquillaje profesional.', 35.90, 40.90, 12, 38, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 18', 'Producto de maquillaje profesional.', 36.90, 41.90, 12, 42, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 19', 'Producto de maquillaje profesional.', 37.90, 42.90, 12, 47, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 20', 'Producto de maquillaje profesional.', 38.90, 43.90, 11, 53, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 21', 'Producto de maquillaje profesional.', 39.90, 44.90, 11, 50, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 22', 'Producto de maquillaje profesional.', 40.90, 45.90, 11, 40, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 23', 'Producto de maquillaje profesional.', 41.90, 46.90, 10, 35, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 24', 'Producto de maquillaje profesional.', 42.90, 47.90, 10, 60, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 25', 'Producto de maquillaje profesional.', 43.90, 48.90, 10, 45, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 26', 'Producto de maquillaje profesional.', 44.90, 49.90, 10, 55, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 27', 'Producto de maquillaje profesional.', 45.90, 50.90, 9, 38, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 28', 'Producto de maquillaje profesional.', 46.90, 51.90, 9, 42, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 29', 'Producto de maquillaje profesional.', 47.90, 52.90, 9, 47, 'producto_destacado.png', 2, FALSE),
('Maquillaje Pro 30', 'Producto de maquillaje profesional.', 48.90, 53.90, 9, 53, 'producto_destacado.png', 2, FALSE);

-- 30 productos para JOYERÍA (categoria_id = 3)
INSERT INTO productos (nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado) VALUES
('Joya Elegante 1', 'Joya de alta calidad y diseño exclusivo.', 35.90, 45.90, 22, 50, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 2', 'Joya de alta calidad y diseño exclusivo.', 36.90, 46.90, 21, 40, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 3', 'Joya de alta calidad y diseño exclusivo.', 37.90, 47.90, 21, 35, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 4', 'Joya de alta calidad y diseño exclusivo.', 38.90, 48.90, 20, 60, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 5', 'Joya de alta calidad y diseño exclusivo.', 39.90, 49.90, 20, 45, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 6', 'Joya de alta calidad y diseño exclusivo.', 40.90, 50.90, 19, 55, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 7', 'Joya de alta calidad y diseño exclusivo.', 41.90, 51.90, 19, 38, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 8', 'Joya de alta calidad y diseño exclusivo.', 42.90, 52.90, 18, 42, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 9', 'Joya de alta calidad y diseño exclusivo.', 43.90, 53.90, 18, 47, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 10', 'Joya de alta calidad y diseño exclusivo.', 44.90, 54.90, 18, 53, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 11', 'Joya de alta calidad y diseño exclusivo.', 45.90, 55.90, 17, 50, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 12', 'Joya de alta calidad y diseño exclusivo.', 46.90, 56.90, 17, 40, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 13', 'Joya de alta calidad y diseño exclusivo.', 47.90, 57.90, 17, 35, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 14', 'Joya de alta calidad y diseño exclusivo.', 48.90, 58.90, 16, 60, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 15', 'Joya de alta calidad y diseño exclusivo.', 49.90, 59.90, 16, 45, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 16', 'Joya de alta calidad y diseño exclusivo.', 50.90, 60.90, 16, 55, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 17', 'Joya de alta calidad y diseño exclusivo.', 51.90, 61.90, 15, 38, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 18', 'Joya de alta calidad y diseño exclusivo.', 52.90, 62.90, 15, 42, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 19', 'Joya de alta calidad y diseño exclusivo.', 53.90, 63.90, 15, 47, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 20', 'Joya de alta calidad y diseño exclusivo.', 54.90, 64.90, 14, 53, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 21', 'Joya de alta calidad y diseño exclusivo.', 55.90, 65.90, 14, 50, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 22', 'Joya de alta calidad y diseño exclusivo.', 56.90, 66.90, 14, 40, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 23', 'Joya de alta calidad y diseño exclusivo.', 57.90, 67.90, 13, 35, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 24', 'Joya de alta calidad y diseño exclusivo.', 58.90, 68.90, 13, 60, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 25', 'Joya de alta calidad y diseño exclusivo.', 59.90, 69.90, 13, 45, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 26', 'Joya de alta calidad y diseño exclusivo.', 60.90, 70.90, 13, 55, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 27', 'Joya de alta calidad y diseño exclusivo.', 61.90, 71.90, 12, 38, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 28', 'Joya de alta calidad y diseño exclusivo.', 62.90, 72.90, 12, 42, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 29', 'Joya de alta calidad y diseño exclusivo.', 63.90, 73.90, 12, 47, 'producto_destacado.png', 3, FALSE),
('Joya Elegante 30', 'Joya de alta calidad y diseño exclusivo.', 64.90, 74.90, 12, 53, 'producto_destacado.png', 3, FALSE);

-- 30 productos para PERFUMES (categoria_id = 4)
INSERT INTO productos (nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado) VALUES
('Perfume Deluxe 1', 'Perfume de alta calidad y fragancia duradera.', 59.90, 69.90, 14, 50, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 2', 'Perfume de alta calidad y fragancia duradera.', 60.90, 70.90, 14, 40, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 3', 'Perfume de alta calidad y fragancia duradera.', 61.90, 71.90, 14, 35, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 4', 'Perfume de alta calidad y fragancia duradera.', 62.90, 72.90, 14, 60, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 5', 'Perfume de alta calidad y fragancia duradera.', 63.90, 73.90, 13, 45, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 6', 'Perfume de alta calidad y fragancia duradera.', 64.90, 74.90, 13, 55, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 7', 'Perfume de alta calidad y fragancia duradera.', 65.90, 75.90, 13, 38, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 8', 'Perfume de alta calidad y fragancia duradera.', 66.90, 76.90, 13, 42, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 9', 'Perfume de alta calidad y fragancia duradera.', 67.90, 77.90, 13, 47, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 10', 'Perfume de alta calidad y fragancia duradera.', 68.90, 78.90, 13, 53, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 11', 'Perfume de alta calidad y fragancia duradera.', 69.90, 79.90, 12, 50, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 12', 'Perfume de alta calidad y fragancia duradera.', 70.90, 80.90, 12, 40, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 13', 'Perfume de alta calidad y fragancia duradera.', 71.90, 81.90, 12, 35, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 14', 'Perfume de alta calidad y fragancia duradera.', 72.90, 82.90, 12, 60, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 15', 'Perfume de alta calidad y fragancia duradera.', 73.90, 83.90, 12, 45, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 16', 'Perfume de alta calidad y fragancia duradera.', 74.90, 84.90, 12, 55, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 17', 'Perfume de alta calidad y fragancia duradera.', 75.90, 85.90, 11, 38, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 18', 'Perfume de alta calidad y fragancia duradera.', 76.90, 86.90, 11, 42, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 19', 'Perfume de alta calidad y fragancia duradera.', 77.90, 87.90, 11, 47, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 20', 'Perfume de alta calidad y fragancia duradera.', 78.90, 88.90, 11, 53, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 21', 'Perfume de alta calidad y fragancia duradera.', 79.90, 89.90, 10, 50, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 22', 'Perfume de alta calidad y fragancia duradera.', 80.90, 90.90, 10, 40, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 23', 'Perfume de alta calidad y fragancia duradera.', 81.90, 91.90, 10, 35, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 24', 'Perfume de alta calidad y fragancia duradera.', 82.90, 92.90, 9, 60, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 25', 'Perfume de alta calidad y fragancia duradera.', 83.90, 93.90, 9, 45, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 26', 'Perfume de alta calidad y fragancia duradera.', 84.90, 94.90, 9, 55, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 27', 'Perfume de alta calidad y fragancia duradera.', 85.90, 95.90, 8, 38, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 28', 'Perfume de alta calidad y fragancia duradera.', 86.90, 96.90, 8, 42, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 29', 'Perfume de alta calidad y fragancia duradera.', 87.90, 97.90, 8, 47, 'producto_destacado.png', 4, FALSE),
('Perfume Deluxe 30', 'Perfume de alta calidad y fragancia duradera.', 88.90, 98.90, 8, 53, 'producto_destacado.png', 4, FALSE);

-- 30 productos para PINTALABIOS (categoria_id = 5)
INSERT INTO productos (nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado) VALUES
('Pintalabios Glam 1', 'Pintalabios de larga duración y color intenso.', 12.90, 15.90, 19, 50, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 2', 'Pintalabios de larga duración y color intenso.', 13.90, 16.90, 18, 40, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 3', 'Pintalabios de larga duración y color intenso.', 14.90, 17.90, 17, 35, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 4', 'Pintalabios de larga duración y color intenso.', 15.90, 18.90, 16, 60, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 5', 'Pintalabios de larga duración y color intenso.', 16.90, 19.90, 15, 45, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 6', 'Pintalabios de larga duración y color intenso.', 17.90, 20.90, 15, 55, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 7', 'Pintalabios de larga duración y color intenso.', 18.90, 21.90, 14, 38, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 8', 'Pintalabios de larga duración y color intenso.', 19.90, 22.90, 14, 42, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 9', 'Pintalabios de larga duración y color intenso.', 20.90, 23.90, 13, 47, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 10', 'Pintalabios de larga duración y color intenso.', 21.90, 24.90, 13, 53, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 11', 'Pintalabios de larga duración y color intenso.', 22.90, 25.90, 12, 50, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 12', 'Pintalabios de larga duración y color intenso.', 23.90, 26.90, 12, 40, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 13', 'Pintalabios de larga duración y color intenso.', 24.90, 27.90, 12, 35, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 14', 'Pintalabios de larga duración y color intenso.', 25.90, 28.90, 11, 60, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 15', 'Pintalabios de larga duración y color intenso.', 26.90, 29.90, 11, 45, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 16', 'Pintalabios de larga duración y color intenso.', 27.90, 30.90, 11, 55, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 17', 'Pintalabios de larga duración y color intenso.', 28.90, 31.90, 10, 38, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 18', 'Pintalabios de larga duración y color intenso.', 29.90, 32.90, 10, 42, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 19', 'Pintalabios de larga duración y color intenso.', 30.90, 33.90, 10, 47, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 20', 'Pintalabios de larga duración y color intenso.', 31.90, 34.90, 9, 53, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 21', 'Pintalabios de larga duración y color intenso.', 32.90, 35.90, 9, 50, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 22', 'Pintalabios de larga duración y color intenso.', 33.90, 36.90, 9, 40, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 23', 'Pintalabios de larga duración y color intenso.', 34.90, 37.90, 8, 35, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 24', 'Pintalabios de larga duración y color intenso.', 35.90, 38.90, 8, 60, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 25', 'Pintalabios de larga duración y color intenso.', 36.90, 39.90, 8, 45, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 26', 'Pintalabios de larga duración y color intenso.', 37.90, 40.90, 8, 55, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 27', 'Pintalabios de larga duración y color intenso.', 38.90, 41.90, 7, 38, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 28', 'Pintalabios de larga duración y color intenso.', 39.90, 42.90, 7, 42, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 29', 'Pintalabios de larga duración y color intenso.', 40.90, 43.90, 7, 47, 'producto_destacado.png', 5, FALSE),
('Pintalabios Glam 30', 'Pintalabios de larga duración y color intenso.', 41.90, 44.90, 7, 53, 'producto_destacado.png', 5, FALSE);

-- Poblar la tabla 'productos' con ejemplos reales de Ésika
DELETE FROM productos;
INSERT INTO productos (nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado, tipo, acabado, material, genero, fecha_lanzamiento, peso, dimensiones)
VALUES
('Perfume Ésika Magnat', 'Fragancia masculina de larga duración, notas amaderadas.', 89.90, 120.00, 25, 50, 'perfume_magnat.png', 1, TRUE, 'Perfume', 'Amaderado', NULL, 'hombre', '2024-05-01', 200, '5x5x15'),
('Labial Líquido Colorfix', 'Labial líquido de alta duración, color rojo intenso.', 29.90, 39.90, 25, 100, 'labial_colorfix.png', 2, FALSE, 'Labial', 'Mate', NULL, 'mujer', '2024-04-15', 30, '2x2x10'),
('Crema Facial Hydra', 'Crema hidratante facial para todo tipo de piel.', 49.90, NULL, NULL, 80, 'crema_hydra.png', 3, TRUE, 'Cuidado facial', NULL, NULL, 'unisex', '2024-03-10', 100, '6x6x6'),
('Set de Brochas Pro', 'Set de 5 brochas profesionales para maquillaje.', 59.90, 79.90, 25, 30, 'set_brochas.png', 4, FALSE, 'Accesorio', NULL, 'Sintético', 'mujer', '2024-02-20', 120, '20x5x5'),
('Perfume Ésika Femme', 'Fragancia femenina floral, ideal para el día.', 99.90, NULL, NULL, 40, 'perfume_femme.png', 1, TRUE, 'Perfume', 'Floral', NULL, 'mujer', '2024-05-10', 200, '5x5x15'),
('Delineador Pro Liner', 'Delineador líquido resistente al agua, color negro.', 24.90, 29.90, 17, 60, 'delineador_pro.png', 2, FALSE, 'Delineador', 'Líquido', NULL, 'mujer', '2024-04-01', 20, '1x1x12'),
('Base Líquida Ultra', 'Base líquida de cobertura total, acabado natural.', 54.90, 69.90, 21, 70, 'base_liquida_ultra.png', 3, TRUE, 'Base', 'Natural', NULL, 'mujer', '2024-03-25', 50, '3x3x10'),
('Paleta de Sombras Glam', 'Paleta de 12 sombras con tonos nude y brillantes.', 79.90, 99.90, 20, 25, 'paleta_glam.png', 2, TRUE, 'Sombras', 'Brillante', NULL, 'mujer', '2024-05-05', 80, '10x8x1'),
('Crema de Manos Nutritiva', 'Crema para manos secas, rápida absorción.', 19.90, NULL, NULL, 90, 'crema_manos.png', 3, FALSE, 'Cuidado corporal', NULL, NULL, 'unisex', '2024-02-28', 50, '4x2x10'),
('Perfume Ésika Urban', 'Fragancia juvenil, fresca y moderna.', 79.90, 99.90, 20, 35, 'perfume_urban.png', 1, FALSE, 'Perfume', 'Fresco', NULL, 'unisex', '2024-05-15', 200, '5x5x15'),
('Labial Hidratante Kiss', 'Labial hidratante con vitamina E, color rosa claro.', 22.90, NULL, NULL, 110, 'labial_kiss.png', 2, TRUE, 'Labial', 'Cremoso', NULL, 'mujer', '2024-04-20', 25, '2x2x10'),
('Set Promoción Maquillaje', 'Set especial de promoción: labial + delineador + base.', 69.90, 109.70, 36, 20, 'set_promocion.png', 2, FALSE, 'Set', NULL, NULL, 'mujer', '2024-05-20', 100, '15x10x5');

-- Marcar algunos como nuevos, otros en oferta, otros promoción (ver campos descuento, precio_original, fecha_lanzamiento, destacado)

-- CATEGORÍAS PRINCIPALES
INSERT INTO categorias (id, nombre, descripcion) VALUES
(1, 'Sets', 'Sets de productos combinados para regalo o uso personal'),
(2, 'Maquillaje', 'Productos de maquillaje facial, ojos y labios'),
(3, 'Joyería', 'Accesorios de joyería y bisutería'),
(4, 'Perfume', 'Fragancias para hombre y mujer'),
(5, 'Pintalabios', 'Labiales y gloss'),
(6, 'Cuidado de la piel', 'Cremas, serums y productos para el cuidado facial y corporal'),
(7, 'Accesorios', 'Brochas, neceseres y otros accesorios de belleza')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), descripcion=VALUES(descripcion);

-- USUARIO ADMIN DE EJEMPLO
INSERT INTO usuarios (nombre, apellido, email, contrasena, tipo_usuario, email_verificado)
VALUES ('Admin', 'Principal', 'admin@esika.com', '$2b$12$eImiTXuWVxfM37uY4JANjQ==', 'admin', TRUE)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);
-- (Reemplaza la contraseña por un hash real en producción)

-- PRODUCTOS DE ÉSIKA
INSERT INTO productos (nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado, tipo, acabado, material, genero, fecha_lanzamiento, peso, dimensiones) VALUES
-- SETS
('Set Glam Total', 'Set de maquillaje completo: base, labial, delineador y sombras. Ideal para regalo.', 129.90, 179.90, 28, 20, 'set_glam_total.png', 1, TRUE, 'Set', NULL, NULL, 'mujer', '2024-05-01', 350, '20x15x6'),
('Set Promoción Belleza', 'Incluye perfume, crema facial y labial en promoción especial.', 99.90, 149.90, 33, 15, 'set_promocion_belleza.png', 1, FALSE, 'Set', NULL, NULL, 'mujer', '2024-04-20', 300, '18x12x5'),
-- MAQUILLAJE
('Base Líquida Ultra', 'Base líquida de cobertura total, acabado natural y larga duración.', 54.90, 69.90, 21, 70, 'base_liquida_ultra.png', 2, TRUE, 'Base', 'Natural', NULL, 'mujer', '2024-03-25', 50, '3x3x10'),
('Paleta de Sombras Glam', 'Paleta de 12 sombras con tonos nude y brillantes.', 79.90, 99.90, 20, 25, 'paleta_glam.png', 2, TRUE, 'Sombras', 'Brillante', NULL, 'mujer', '2024-05-05', 80, '10x8x1'),
('Delineador Pro Liner', 'Delineador líquido resistente al agua, color negro.', 24.90, 29.90, 17, 60, 'delineador_pro.png', 2, FALSE, 'Delineador', 'Líquido', NULL, 'mujer', '2024-04-01', 20, '1x1x12'),
-- JOYERÍA
('Collar Elegance', 'Collar de plata 925 con dije de corazón, ideal para ocasiones especiales.', 119.90, 149.90, 20, 10, 'collar_elegance.png', 3, TRUE, 'Collar', NULL, 'Plata', 'mujer', '2024-05-10', 30, '5x5x1'),
('Pulsera Brillante', 'Pulsera ajustable con cristales Swarovski.', 89.90, NULL, NULL, 15, 'pulsera_brilante.png', 3, FALSE, 'Pulsera', NULL, 'Acero', 'mujer', '2024-04-15', 15, '6x6x1'),
-- PERFUME
('Perfume Ésika Magnat', 'Fragancia masculina de larga duración, notas amaderadas.', 89.90, 120.00, 25, 50, 'perfume_magnat.png', 4, TRUE, 'Perfume', 'Amaderado', NULL, 'hombre', '2024-05-01', 200, '5x5x15'),
('Perfume Ésika Femme', 'Fragancia femenina floral, ideal para el día.', 99.90, NULL, NULL, 40, 'perfume_femme.png', 4, TRUE, 'Perfume', 'Floral', NULL, 'mujer', '2024-05-10', 200, '5x5x15'),
('Perfume Ésika Urban', 'Fragancia juvenil, fresca y moderna.', 79.90, 99.90, 20, 35, 'perfume_urban.png', 4, FALSE, 'Perfume', 'Fresco', NULL, 'unisex', '2024-05-15', 200, '5x5x15'),
-- PINTALABIOS
('Labial Líquido Colorfix', 'Labial líquido de alta duración, color rojo intenso.', 29.90, 39.90, 25, 100, 'labial_colorfix.png', 5, FALSE, 'Labial', 'Mate', NULL, 'mujer', '2024-04-15', 30, '2x2x10'),
('Labial Hidratante Kiss', 'Labial hidratante con vitamina E, color rosa claro.', 22.90, NULL, NULL, 110, 'labial_kiss.png', 5, TRUE, 'Labial', 'Cremoso', NULL, 'mujer', '2024-04-20', 25, '2x2x10'),
-- CUIDADO DE LA PIEL
('Crema Facial Hydra', 'Crema hidratante facial para todo tipo de piel.', 49.90, NULL, NULL, 80, 'crema_hydra.png', 6, TRUE, 'Cuidado facial', NULL, NULL, 'unisex', '2024-03-10', 100, '6x6x6'),
('Serum Antiedad', 'Serum facial con ácido hialurónico y colágeno.', 69.90, 89.90, 22, 60, 'serum_antiedad.png', 6, FALSE, 'Serum', NULL, NULL, 'mujer', '2024-04-05', 30, '3x3x10'),
('Crema de Manos Nutritiva', 'Crema para manos secas, rápida absorción.', 19.90, NULL, NULL, 90, 'crema_manos.png', 6, FALSE, 'Cuidado corporal', NULL, NULL, 'unisex', '2024-02-28', 50, '4x2x10'),
-- ACCESORIOS
('Set de Brochas Pro', 'Set de 5 brochas profesionales para maquillaje.', 59.90, 79.90, 25, 30, 'set_brochas.png', 7, FALSE, 'Accesorio', NULL, 'Sintético', 'mujer', '2024-02-20', 120, '20x5x5'),
('Neceser Rosa', 'Neceser compacto para llevar tus cosméticos a todas partes.', 34.90, NULL, NULL, 40, 'neceser_rosa.png', 7, TRUE, 'Neceser', NULL, 'Tela', 'mujer', '2024-03-15', 80, '18x10x8');

-- USUARIOS DE EJEMPLO (incluye admin y clientes)
INSERT INTO usuarios (id, nombre, apellido, email, contrasena, tipo_usuario, email_verificado) VALUES
(1, 'Admin', 'Principal', 'admin@esika.com', '$2b$12$hashadmin', 'admin', 1),
(2, 'Diego', 'Centeno', 'diego@cliente.com', '$2b$12$hashcliente', 'cliente', 1),
(3, 'Maria', 'Lopez', 'maria@cliente.com', '$2b$12$hashcliente2', 'cliente', 1)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- CATEGORÍAS (ya insertadas previamente)

-- PRODUCTOS DE EJEMPLO
INSERT INTO productos (id, nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado, tipo, acabado, material, genero, fecha_lanzamiento, peso, dimensiones)
VALUES
(1, 'Set de Maquillaje', 'Set completo de maquillaje Ésika', 110.50, 150.00, 26, 20, 'set_maquillaje.png', 1, 1, 'Set', 'Mate', NULL, 'Unisex', '2024-01-10', 0.5, '20x15x5'),
(2, 'Perfume Floral', 'Perfume floral de larga duración', 50.00, 70.00, 29, 50, 'perfume_mujer.png', 4, 1, 'Perfume', NULL, NULL, 'Mujer', '2024-02-15', 0.2, '10x5x3'),
(3, 'Set de Brochas', 'Set de brochas profesionales', 95.00, 120.00, 21, 30, 'set_brochas.png', 7, 1, 'Set', NULL, 'Sintético', 'Unisex', '2024-03-01', 0.3, '18x8x4'),
(6, 'Pintalabios Líquido', 'Labial líquido de larga duración color intenso.', 29.90, 39.90, 25, 30, 'labial_liquido.png', 5, 1, 'Pintalabios', 'Mate', NULL, 'Mujer', '2024-04-10', 0.05, '10x2x2'),
(7, 'Crema Facial Hidratante', 'Crema hidratante para el cuidado diario de la piel.', 49.90, 59.90, 17, 30, 'crema_dia.png', 6, 1, 'Cuidado de la piel', NULL, NULL, 'Unisex', '2024-04-15', 0.1, '8x8x5')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), stock=VALUES(stock);

-- PEDIDOS DE EJEMPLO
INSERT INTO pedidos (id, usuario_id, fecha, total, estado, puntos_ganados) VALUES
(101, 2, '2024-06-26', 210.50, 'Enviado', 10),
(102, 2, '2024-06-20', 95.00, 'Entregado', 0)
ON DUPLICATE KEY UPDATE total=VALUES(total);

-- DETALLES DE PEDIDO
INSERT INTO pedido_detalles (pedido_id, producto_id, cantidad, subtotal) VALUES
(101, 1, 1, 110.50),
(101, 2, 2, 100.00),
(102, 3, 1, 95.00)
ON DUPLICATE KEY UPDATE subtotal=VALUES(subtotal);

-- PUNTOS DE USUARIO
INSERT INTO puntos_usuario (usuario_id, puntos_totales) VALUES
(2, 10)
ON DUPLICATE KEY UPDATE puntos_totales=VALUES(puntos_totales);

-- Ahora la base de datos tiene usuarios, productos, pedidos y puntos listos para operar y probar en producción. 

-- Producto id 6: Pintalabios Líquido
INSERT INTO productos (id, nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado, tipo, acabado, material, genero, fecha_lanzamiento, peso, dimensiones)
VALUES (6, 'Pintalabios Líquido', 'Labial líquido de larga duración color intenso.', 29.90, 39.90, 25, 30, 'labial_liquido.png', 5, 1, 'Pintalabios', 'Mate', NULL, 'Mujer', '2024-04-10', 0.05, '10x2x2')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), stock=VALUES(stock);

-- Producto id 7: Crema Facial Hidratante
INSERT INTO productos (id, nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado, tipo, acabado, material, genero, fecha_lanzamiento, peso, dimensiones)
VALUES (7, 'Crema Facial Hidratante', 'Crema hidratante para el cuidado diario de la piel.', 49.90, 59.90, 17, 30, 'crema_dia.png', 6, 1, 'Cuidado de la piel', NULL, NULL, 'Unisex', '2024-04-15', 0.1, '8x8x5')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), stock=VALUES(stock);

-- DATOS DE EJEMPLO PARA OPERACIÓN Y PRUEBAS

-- CATEGORÍAS
INSERT INTO categorias (id, nombre, descripcion) VALUES
(1, 'Sets', 'Sets de productos combinados para regalo o uso personal'),
(2, 'Maquillaje', 'Productos de maquillaje facial, ojos y labios'),
(3, 'Joyería', 'Accesorios de joyería y bisutería'),
(4, 'Perfume', 'Fragancias para hombre y mujer'),
(5, 'Pintalabios', 'Labiales y gloss'),
(6, 'Cuidado de la piel', 'Cremas, serums y productos para el cuidado facial y corporal'),
(7, 'Accesorios', 'Brochas, neceseres y otros accesorios de belleza')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), descripcion=VALUES(descripcion);

-- USUARIOS (hashes de ejemplo, reemplaza por reales en producción)
INSERT INTO usuarios (id, nombre, apellido, email, contrasena, tipo_usuario, email_verificado, direccion, telefono)
VALUES
(1, 'Admin', 'Principal', 'admin@esika.com', '$2b$12$hashadmin', 'admin', 1, 'Calle Principal 123', '010-420-0340'),
(2, 'Maria', 'Lopez', 'maria@example.com', '$2b$12$hashmaria', 'cliente', 1, 'Av. Belleza 456', '010-111-2233'),
(3, 'Diego', 'Centeno', 'diego@cliente.com', '$2b$12$hashdiego', 'cliente', 1, 'Las Palmas', '943-667-412')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- PRODUCTOS
INSERT INTO productos (id, nombre, descripcion, precio, precio_original, descuento, stock, imagen, categoria_id, destacado, tipo, acabado, material, genero, fecha_lanzamiento, peso, dimensiones)
VALUES
(1, 'Set de Maquillaje', 'Set completo de maquillaje Ésika', 110.50, 150.00, 26, 20, 'set_maquillaje.png', 1, 1, 'Set', 'Mate', NULL, 'Unisex', '2024-01-10', 0.5, '20x15x5'),
(2, 'Perfume Floral', 'Perfume floral de larga duración', 50.00, 70.00, 29, 50, 'perfume_mujer.png', 4, 1, 'Perfume', NULL, NULL, 'Mujer', '2024-02-15', 0.2, '10x5x3'),
(3, 'Set de Brochas', 'Set de brochas profesionales', 95.00, 120.00, 21, 30, 'set_brochas.png', 7, 1, 'Set', NULL, 'Sintético', 'Unisex', '2024-03-01', 0.3, '18x8x4'),
(6, 'Pintalabios Líquido', 'Labial líquido de larga duración color intenso.', 29.90, 39.90, 25, 30, 'labial_liquido.png', 5, 1, 'Pintalabios', 'Mate', NULL, 'Mujer', '2024-04-10', 0.05, '10x2x2'),
(7, 'Crema Facial Hidratante', 'Crema hidratante para el cuidado diario de la piel.', 49.90, 59.90, 17, 30, 'crema_dia.png', 6, 1, 'Cuidado de la piel', NULL, NULL, 'Unisex', '2024-04-15', 0.1, '8x8x5')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), stock=VALUES(stock);

-- PEDIDOS
INSERT INTO pedidos (id, usuario_id, fecha, total, estado, puntos_ganados) VALUES
(101, 2, '2024-06-26', 210.50, 'Enviado', 10),
(102, 2, '2024-06-20', 95.00, 'Entregado', 0)
ON DUPLICATE KEY UPDATE total=VALUES(total);

-- DETALLES DE PEDIDO
INSERT INTO pedido_detalles (pedido_id, producto_id, cantidad, subtotal) VALUES
(101, 1, 1, 110.50),
(101, 2, 2, 100.00),
(102, 3, 1, 95.00)
ON DUPLICATE KEY UPDATE subtotal=VALUES(subtotal);

-- CARRITO
INSERT INTO carrito (usuario_id, producto_id, cantidad) VALUES
(2, 1, 1),
(2, 2, 2)
ON DUPLICATE KEY UPDATE cantidad=VALUES(cantidad);

-- FAVORITOS
INSERT INTO favoritos (usuario_id, producto_id) VALUES
(2, 1),
(2, 3)
ON DUPLICATE KEY UPDATE producto_id=VALUES(producto_id);

-- WISHLIST
INSERT INTO wishlist (usuario_id, producto_id) VALUES
(2, 6),
(2, 7)
ON DUPLICATE KEY UPDATE producto_id=VALUES(producto_id);

-- DIRECCIONES
INSERT INTO direcciones (usuario_id, nombre, direccion, ciudad, departamento, pais, codigo_postal, telefono, tipo)
VALUES
(2, 'Casa', 'Av. Belleza 456', 'Lima', 'Lima', 'Perú', '15001', '010-111-2233', 'envio')
ON DUPLICATE KEY UPDATE direccion=VALUES(direccion);

-- MÉTODOS DE ENVÍO
INSERT INTO metodos_envio (nombre, descripcion, costo_base, costo_por_kg, tiempo_entrega_min, tiempo_entrega_max, activo, prioridad) VALUES
('Envío Estándar', 'Entrega en 3-5 días hábiles', 8.00, 2.00, 3, 5, TRUE, 1)
ON DUPLICATE KEY UPDATE descripcion=VALUES(descripcion);

-- ZONAS DE ENVÍO
INSERT INTO zonas_envio (nombre, departamento, provincia, distrito, codigo_postal, costo_base, tiempo_entrega_min, tiempo_entrega_max, activo) VALUES
('Lima Centro', 'Lima', 'Lima', 'Lima', '15001', 5.00, 1, 2, TRUE)
ON DUPLICATE KEY UPDATE costo_base=VALUES(costo_base);

-- TARIFAS DE ENVÍO
INSERT INTO tarifas_envio (zona_id, metodo_id, peso_min, peso_max, costo, tiempo_entrega_min, tiempo_entrega_max) VALUES
(1, 1, 0, 500, 5.00, 1, 2)
ON DUPLICATE KEY UPDATE costo=VALUES(costo);

-- SUSCRIPTORES
INSERT INTO suscriptores (correo) VALUES
('maria@example.com')
ON DUPLICATE KEY UPDATE correo=VALUES(correo);

-- CUPONES USADOS
INSERT INTO cupones_usados (usuario_id, cupon) VALUES
(2, 'DESCUENTO10')
ON DUPLICATE KEY UPDATE cupon=VALUES(cupon);

-- TARJETAS DE CRÉDITO
INSERT INTO tarjetas_credito (usuario_id, titular, numero, vencimiento, cvv, marca)
VALUES (2, 'Maria Lopez', '4111111111111111', '12/2026', '123', 'Visa')
ON DUPLICATE KEY UPDATE numero=VALUES(numero); 