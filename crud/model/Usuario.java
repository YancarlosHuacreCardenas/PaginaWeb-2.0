package crud.model;

public class Usuario {
    private int id;
    private String nombre;
    private String email;
    private String contrasena;
    private String tipoUsuario;
    private boolean emailVerificado;
    private String fechaRegistro;
    private String ultimoLogin;

    // Getters y setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getContrasena() { return contrasena; }
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }
    public String getTipoUsuario() { return tipoUsuario; }
    public void setTipoUsuario(String tipoUsuario) { this.tipoUsuario = tipoUsuario; }
    public boolean isEmailVerificado() { return emailVerificado; }
    public void setEmailVerificado(boolean emailVerificado) { this.emailVerificado = emailVerificado; }
    public String getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(String fechaRegistro) { this.fechaRegistro = fechaRegistro; }
    public String getUltimoLogin() { return ultimoLogin; }
    public void setUltimoLogin(String ultimoLogin) { this.ultimoLogin = ultimoLogin; }
} 