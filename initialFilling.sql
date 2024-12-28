use RedNegocios;

-- Crear el usuario administrador
INSERT INTO Usuario (username, email, password, habilitado, cuentaNoExpirada, credencialesNoExpiradas, cuentaNoBloqueada, creadoPor, fechaCreacion, activo)
VALUES ('admin', 'admin@example.com', '$2b$12$sc968Z4Urt9Hm3vnp03PveifmAiGiiAl2eXrVIwD6TbydmMqauafi', 1, 1, 1, 1, 'system', GETDATE(), 1);

-- La contraseña encriptada corresponde a 'admin123'. Se generó con BCrypt.

-- Obtener el ID del usuario creado
DECLARE @AdminUsuarioId INT;
SET @AdminUsuarioId = (SELECT usuarioId FROM Usuario WHERE username = 'admin');

-- Crear el rol ADMIN
INSERT INTO Autoridad (usuarioId, autoridad, creadoPor, fechaCreacion, activo)
VALUES (@AdminUsuarioId, 'ROLE_ADMIN', 'system', GETDATE(), 1);

-- Crear el rol ADMIN
INSERT INTO Autoridad (usuarioId, autoridad, creadoPor, fechaCreacion, activo)
VALUES (@AdminUsuarioId, 'ROLE_ADMIN_NEGOCIO', 'system', GETDATE(), 1);

-- Crear el rol USER (opcional)
INSERT INTO Autoridad (usuarioId, autoridad, creadoPor, fechaCreacion, activo)
VALUES (@AdminUsuarioId, 'ROLE_USER', 'system', GETDATE(), 1);


select * from Usuario;

select * from Autoridad;

select * from UsuarioToken;

delete from Autoridad where autoridadId = 5;

delete from Negocio;

delete from UsuarioNegocio;

delete from Usuario;

drop table LineaOrden;

drop table NegocioProducto;



ALTER TABLE Beneficio
ADD visibleSoloAdmin BIT DEFAULT 1;