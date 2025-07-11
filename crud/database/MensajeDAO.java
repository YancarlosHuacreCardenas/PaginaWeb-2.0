package crud.database;

import crud.model.Mensaje;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MensajeDAO {
    public List<Mensaje> listarMensajes() {
        List<Mensaje> mensajes = new ArrayList<>();
        try (Connection conn = ConexionDB.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM contactos")) {
            while (rs.next()) {
                Mensaje m = new Mensaje();
                m.setId(rs.getInt("id"));
                m.setNombre(rs.getString("nombre"));
                m.setApellido(rs.getString("apellido"));
                m.setEmail(rs.getString("email"));
                m.setAsunto(rs.getString("asunto"));
                m.setMensaje(rs.getString("mensaje"));
                m.setFecha(rs.getString("fecha"));
                m.setLeido(false); // Puedes agregar lógica para marcar como leído
                mensajes.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return mensajes;
    }
    // Métodos para agregar, editar y eliminar mensajes pueden agregarse aquí
} 