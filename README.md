# Pagina Web 2.0

## Instalación de dependencias

- Python (Flask):
  ```bash
  pip install flask
  ```
- Node.js (Tailwind CSS, PostCSS, Font Awesome):
  ```bash
  npm install -D tailwindcss postcss
  npm install --save @fortawesome/fontawesome-free
  npm install -g tailwindcss
  ```

## Estructura recomendada
- static/
  - css/
  - icons/
  - img/
  - js/
- templates/
- app.py
- ...

## Uso de Tailwind CSS
Puedes compilar los estilos con:
```bash
tailwindcss -i ./static/css/input.css -o ./static/css/output.css --watch
```

## Uso de Font Awesome
Incluye en tu HTML:
```html
<link rel="stylesheet" href="/node_modules/@fortawesome/fontawesome-free/css/all.min.css">
``` 
# Sistema de Autenticación - bycint Cosméticos

## Características Implementadas

### ✅ Funcionalidades Completadas

1. **Registro con Email**
   - Validación de email
   - Validación de contraseña (mínimo 8 caracteres, letra y número)
   - Confirmación de contraseña
   - Registro automático de fecha y estado de verificación

2. **Inicio de Sesión con Email**
   - Autenticación segura con hash de contraseñas
   - Validación de credenciales
   - Registro de último acceso
   - Opción "Recordarme"

3. **Gestión de Sesiones**
   - Sesiones seguras con Flask
   - Cerrar sesión
   - Protección de rutas con decorador `@login_required`

4. **Perfil de Usuario**
   - Vista de información personal
   - Estado de verificación de email
   - Historial de accesos
   - Tipo de cuenta (cliente/admin)

5. **Recuperación de Contraseña**
   - Formulario de recuperación por email
   - Validación de email existente

6. **Navegación Dinámica**
   - Menú que cambia según el estado de autenticación
   - Dropdown para usuarios logueados
   - Enlaces a login/registro para usuarios no autenticados

### 🔄 Funcionalidades Preparadas (OAuth)

1. **Facebook Login/Register**
   - Rutas preparadas
   - Estructura de base de datos lista
   - Placeholder para implementación OAuth

2. **Google Login/Register**
   - Rutas preparadas
   - Estructura de base de datos lista
   - Placeholder para implementación OAuth

## Estructura de Base de Datos

La tabla `usuarios` incluye los siguientes campos:

```sql
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255),  -- Nullable para usuarios OAuth
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    tipo_usuario ENUM('cliente','admin') DEFAULT 'cliente',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Campos para login social
    facebook_id VARCHAR(100) UNIQUE,
    google_id VARCHAR(100) UNIQUE,
    avatar_url VARCHAR(255),
    email_verificado BOOLEAN DEFAULT FALSE,
    ultimo_login TIMESTAMP NULL
);
```

## Instalación y Configuración

### 1. Instalar Dependencias

```bash
pip install -r requirements.txt
```

### 2. Actualizar Base de Datos

```bash
python update_database.py
```

### 3. Configurar Variables de Entorno (Opcional)

Para OAuth en producción, crear un archivo `.env`:

```env
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

### 4. Ejecutar la Aplicación

```bash
python app.py
```

## Rutas Disponibles

### Autenticación
- `GET/POST /login` - Inicio de sesión
- `GET/POST /register` - Registro de usuario
- `GET /logout` - Cerrar sesión
- `GET/POST /forgot-password` - Recuperar contraseña

### Perfil
- `GET /profile` - Perfil del usuario (requiere login)

### OAuth (Placeholder)
- `GET /facebook-login` - Login con Facebook
- `GET /google-login` - Login con Google
- `GET /facebook-register` - Registro con Facebook
- `GET /google-register` - Registro con Google

## Validaciones Implementadas

### Email
- Formato válido de email
- Verificación de unicidad en la base de datos

### Contraseña
- Mínimo 8 caracteres
- Al menos una letra
- Al menos un número
- Confirmación de contraseña

### Seguridad
- Hash de contraseñas con Werkzeug
- Sesiones seguras
- Protección CSRF (preparado)
- Validación de entrada

## Próximos Pasos para OAuth

### Facebook OAuth
1. Crear aplicación en Facebook Developers
2. Obtener App ID y App Secret
3. Configurar URLs de redirección
4. Implementar flujo OAuth completo

### Google OAuth
1. Crear proyecto en Google Cloud Console
2. Habilitar Google+ API
3. Obtener Client ID y Client Secret
4. Implementar flujo OAuth completo

## Archivos Creados/Modificados

### Nuevos Archivos
- `templates/Auth/login.html` - Página de inicio de sesión
- `templates/Auth/register.html` - Página de registro
- `templates/profile.html` - Página de perfil
- `templates/forgot_password.html` - Recuperación de contraseña
- `update_database.py` - Script de actualización de BD
- `AUTH_README.md` - Este archivo

### Archivos Modificados
- `app.py` - Sistema completo de autenticación
- `templates/base.html` - Navegación dinámica
- `templates/index.html` - Simplificado
- `database.sql` - Estructura actualizada
- `requirements.txt` - Dependencias actualizadas

## Notas de Seguridad

1. **Contraseñas**: Se almacenan con hash bcrypt
2. **Sesiones**: Usan secret key aleatorio
3. **Validación**: Input sanitizado y validado
4. **SQL Injection**: Protegido con parámetros preparados
5. **CSRF**: Preparado para implementación

## Testing

Para probar el sistema:

1. Registra un nuevo usuario en `/register`
2. Inicia sesión en `/login`
3. Verifica el perfil en `/profile`
4. Prueba cerrar sesión en `/logout`
5. Prueba recuperar contraseña en `/forgot-password`

## Usuarios de Prueba

El sistema incluye usuarios de prueba en la base de datos:
- Admin: `admin@bycint.com` / `admin123`
- Cliente: `maria@example.com` / `maria123`

## Uso del entorno virtual (venv) y configuración segura

1. **Activa el entorno virtual antes de cualquier comando:**
   - En Windows:
     ```
     venv\Scripts\activate
     ```
   - En Linux/Mac:
     ```
     source venv/bin/activate
     ```

2. **Instala las dependencias:**
   ```
   pip install -r requirements.txt
   ```

3. **Configura tus variables de entorno en un archivo `.env` en la raíz del proyecto:**
   - Ejemplo:
     ```
     SECRET_KEY=pon_aqui_una_clave_larga_y_secreta
     MAIL_USERNAME=tu_email@gmail.com
     MAIL_PASSWORD=tu_password
     ```

4. **Ejecuta el servidor SIEMPRE dentro del entorno venv:**
   ```
   python app.py
   # o
   flask run
   ```

5. **Notas de seguridad:**
   - Nunca subas tu archivo `.env` a repositorios públicos.
   - Cambia la SECRET_KEY para producción.
   - Si cambias la SECRET_KEY, todas las sesiones se invalidan (esto es seguro).

6. **¿Problemas con la sesión?**
   - Si tras reiniciar el servidor sigues logueado, revisa que la SECRET_KEY no cambie automáticamente.
   - Si quieres máxima seguridad, deja que la SECRET_KEY cambie en cada reinicio (no la pongas en el .env). 