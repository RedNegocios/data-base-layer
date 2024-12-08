-- Crear el usuario administrador
INSERT INTO Usuario (username, email, password, habilitado, cuentaNoExpirada, credencialesNoExpiradas, cuentaNoBloqueada, creadoPor, fechaCreacion, activo)
VALUES ('admin', 'admin@example.com', '$2a$10$D1ZQ9UVl/QxsHIXuOnNKaORFs0.cuy5VBoIDaA/K3/mqIF5D8/TzO', 1, 1, 1, 1, 'system', GETDATE(), 1);

-- La contraseña encriptada corresponde a 'admin123'. Se generó con BCrypt.

-- Obtener el ID del usuario creado
DECLARE @AdminUsuarioId INT;
SET @AdminUsuarioId = (SELECT usuarioId FROM Usuario WHERE username = 'admin');

-- Crear el rol ADMIN
INSERT INTO Autoridad (usuarioId, autoridad, creadoPor, fechaCreacion, activo)
VALUES (@AdminUsuarioId, 'ROLE_ADMIN', 'system', GETDATE(), 1);

-- Crear el rol USER (opcional)
INSERT INTO Autoridad (usuarioId, autoridad, creadoPor, fechaCreacion, activo)
VALUES (@AdminUsuarioId, 'ROLE_USER', 'system', GETDATE(), 1);