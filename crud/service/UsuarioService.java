package crud.service;

import crud.database.UsuarioDAO;
import crud.model.Usuario;
import java.util.List;

public class UsuarioService {
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    public List<Usuario> obtenerTodos() {
        return usuarioDAO.listarUsuarios();
    }
    // Métodos para agregar, editar y eliminar usuarios pueden agregarse aquí
} 