package crud.database;

import crud.model.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {
    public List<Usuario> listarUsuarios() {
        List<Usuario> usuarios = new ArrayList<>();
        try (Connection conn = ConexionDB.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM usuarios")) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setEmail(rs.getString("email"));
                u.setContrasena(rs.getString("contrasena"));
                u.setTipoUsuario(rs.getString("tipo_usuario"));
                u.setEmailVerificado(rs.getBoolean("email_verificado"));
                u.setFechaRegistro(rs.getString("fecha_registro"));
                u.setUltimoLogin(rs.getString("ultimo_login"));
                usuarios.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuarios;
    }
    // Métodos para agregar, editar y eliminar usuarios pueden agregarse aquí
} 