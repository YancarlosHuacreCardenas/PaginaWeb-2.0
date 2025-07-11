package crud.database;

import crud.model.Categoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {
    public List<Categoria> listarCategorias() {
        List<Categoria> categorias = new ArrayList<>();
        try (Connection conn = ConexionDB.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM categorias")) {
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                categorias.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categorias;
    }
    // Métodos para agregar, editar y eliminar categorías pueden agregarse aquí
} 