package crud.service;

import crud.database.MensajeDAO;
import crud.model.Mensaje;
import java.util.List;

public class MensajeService {
    private MensajeDAO mensajeDAO = new MensajeDAO();

    public List<Mensaje> obtenerTodos() {
        return mensajeDAO.listarMensajes();
    }
    // Métodos para agregar, editar y eliminar mensajes pueden agregarse aquí
} 