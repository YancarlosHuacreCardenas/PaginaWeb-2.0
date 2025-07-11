package crud.service;

import crud.database.CategoriaDAO;
import crud.model.Categoria;
import java.util.List;

public class CategoriaService {
    private CategoriaDAO categoriaDAO = new CategoriaDAO();

    public List<Categoria> obtenerTodos() {
        return categoriaDAO.listarCategorias();
    }
    // Métodos para agregar, editar y eliminar categorías pueden agregarse aquí
} 