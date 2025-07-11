-- Script para cambiar el rol de un usuario de cliente a admin
-- Reemplaza 'email_del_usuario@ejemplo.com' con el email real del usuario

-- Opción 1: Cambiar por email
UPDATE usuarios 
SET tipo_usuario = 'admin' 
WHERE email = 'email_del_usuario@ejemplo.com';

-- Opción 2: Cambiar por ID (reemplaza 123 con el ID real)
-- UPDATE usuarios 
-- SET tipo_usuario = 'admin' 
-- WHERE id = 123;

-- Verificar el cambio
SELECT id, nombre, email, tipo_usuario 
FROM usuarios 
WHERE email = 'email_del_usuario@ejemplo.com';

-- Mostrar todos los administradores
SELECT id, nombre, email, tipo_usuario, fecha_registro 
FROM usuarios 
WHERE tipo_usuario = 'admin' 
ORDER BY fecha_registro DESC; 