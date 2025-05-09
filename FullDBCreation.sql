use RedNegocios;


CREATE TABLE Negocio (
    negocioId INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único del negocio
    nombre VARCHAR(255) ,               -- Nombre del negocio
    descripcion VARCHAR(MAX),                   -- Descripción del negocio
    -- Columnas de gobernanza de registros
    ---creado_por VARCHAR(100) NOT NULL,           -- Usuario que creó el registro
    fechaCreacion DATETIME DEFAULT GETDATE(),  -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),  -- Fecha de la última modificación
    activo BIT DEFAULT 1,              -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                 -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME                  -- Fecha de eliminación lógica del registro
);

CREATE TABLE Beneficio (
    beneficioId INT PRIMARY KEY IDENTITY(1,1),       -- Identificador único del beneficio
    negocioNegocioId INT NOT NULL,                  -- Identificador de la relación entre negocios
    descripcion VARCHAR(255) NOT NULL,             -- Descripción del beneficio
    valor NUMERIC(18,2) NULL,                      -- Valor asociado al beneficio (ej. porcentaje de descuento)
	visibleSoloAdmin BIT DEFAULT 1,                 -- bandera para saber si el beneficio es solo para admin
    tipoBeneficio VARCHAR(100) NOT NULL,           -- Tipo del beneficio (ej. 'Descuento', 'Acceso Preferente', etc.)
    condiciones VARCHAR(MAX) NULL,                 -- Detalles o condiciones del beneficio

    -- Columnas de gobernanza de registros
    creadoPor VARCHAR(100) NOT NULL,               -- Usuario que creó el registro
    fechaCreacion DATETIME DEFAULT GETDATE(),      -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                    -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),  -- Fecha de la última modificación
    activo BIT DEFAULT 1,                          -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                     -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME,                     -- Fecha de eliminación lógica del registro

    -- Restricciones de claves foráneas
    FOREIGN KEY (negocioNegocioId) REFERENCES NegocioNegocio(negocioNegocioId)  -- Clave foránea con la tabla NegocioNegocio
);


CREATE TABLE Usuario (
    usuarioId INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único del usuario
    username VARCHAR(50) UNIQUE,     -- Nombre de usuario, debe ser único
    email VARCHAR(100) UNIQUE,       -- Correo electrónico único
    password VARCHAR(255) ,           -- Contraseña encriptada
    habilitado BIT  DEFAULT 1,        -- Indicador si el usuario está activo
    cuentaNoExpirada BIT  DEFAULT 1,  -- Indicador si la cuenta está expirada
    credencialesNoExpiradas BIT  DEFAULT 1,  -- Indicador si las credenciales han expirado
    cuentaNoBloqueada BIT  DEFAULT 1, -- Indicador si la cuenta está bloqueada
    -- Columnas de gobernanza de registros
    creadoPor VARCHAR(100) ,          -- Usuario que creó el registro
    fechaCreacion DATETIME  DEFAULT GETDATE(),  -- Fecha de creación del registro
    modificadoPor VARCHAR(100),               -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),       -- Fecha de la última modificación
    activo BIT  DEFAULT 1,            -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME                 -- Fecha de eliminación lógica del registro
);

CREATE TABLE Autoridad (
    autoridadId INT PRIMARY KEY IDENTITY(1,1), -- Identificador único de la autoridad
    usuarioId INT,                             -- Identificador del usuario asociado
    autoridad VARCHAR(50) ,            -- Rol o autoridad (ej. ROLE_USER, ROLE_ADMIN)
    -- Columnas de gobernanza de registros
    creadoPor VARCHAR(100) ,           -- Usuario que creó el registro
    fechaCreacion DATETIME  DEFAULT GETDATE(),  -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),       -- Fecha de la última modificación
    activo BIT DEFAULT 1,             -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                 -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME,                 -- Fecha de eliminación lógica del registro
    FOREIGN KEY (usuarioId) REFERENCES Usuario(usuarioId)  -- Clave foránea con la tabla Usuario
);

CREATE TABLE UsuarioToken (
    tokenId INT PRIMARY KEY IDENTITY(1,1),      -- Identificador único del token
    usuarioId INT NOT NULL,                     -- Relación con la tabla Usuario
    token VARCHAR(255) NOT NULL,               -- El token generado (por ejemplo, JWT)
    fechaExpiracion DATETIME NOT NULL,          -- Fecha de expiración del token
    habilitado BIT DEFAULT 1,                   -- Indicador si el token está activo
    -- Columnas de gobernanza de registros
    creadoPor VARCHAR(100),                     -- Usuario que creó el registro
    fechaCreacion DATETIME DEFAULT GETDATE(),   -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                 -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(), -- Fecha de la última modificación
    activo BIT DEFAULT 1,                       -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                  -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME,                  -- Fecha de eliminación lógica del registro
    FOREIGN KEY (usuarioId) REFERENCES Usuario(usuarioId) -- Clave foránea con la tabla Usuario
);


CREATE TABLE UsuarioNegocio (
    usuarioNegocioId INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único del registro de relación
    usuarioId INT  ,                          -- Identificador del usuario
    negocioId INT  ,                          -- Identificador del negocio
    -- Columnas de gobernanza de registros
    creadoPor VARCHAR(100)  ,                 -- Usuario que creó el registro
    fechaCreacion DATETIME   DEFAULT GETDATE(),  -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                      -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),    -- Fecha de la última modificación
    activo BIT   DEFAULT 1,                   -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                       -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME,                       -- Fecha de eliminación lógica del registro
    -- Restricciones de claves foráneas
    FOREIGN KEY (usuarioId) REFERENCES Usuario(usuarioId),  -- Clave foránea que conecta con la tabla Usuario
    FOREIGN KEY (negocioId) REFERENCES Negocio(negocioId)   -- Clave foránea que conecta con la tabla Negocio
);

CREATE TABLE TipoRelacionNegocioNegocio (
    tipoRelacionId INT PRIMARY KEY IDENTITY(1,1), -- Identificador único del tipo de relación
    descripcion VARCHAR(100)              -- Descripción del tipo de relación (ej. 'Proveedor', 'Cliente', 'Asociado')
);

-- Tabla NegocioNegocio para la relación entre dos negocios
CREATE TABLE NegocioNegocio (
    negocioNegocioId INT PRIMARY KEY IDENTITY(1,1),   -- Identificador único del registro de relación entre negocios
    negocioId1 INT  ,                          -- Identificador del primer negocio
    negocioId2 INT  ,                          -- Identificador del segundo negocio
    tipoRelacionId INT  ,                      -- Identificador del tipo de relación
    -- Columnas de gobernanza de registros
    creadoPor VARCHAR(100)  ,                  -- Usuario que creó el registro
    fechaCreacion DATETIME   DEFAULT GETDATE(), -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                       -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),     -- Fecha de la última modificación
    activo BIT   DEFAULT 1,                    -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                        -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME,                        -- Fecha de eliminación lógica del registro
    -- Restricciones de claves foráneas
    FOREIGN KEY (negocioId1) REFERENCES Negocio(negocioId),  -- Clave foránea con la tabla Negocio
    FOREIGN KEY (negocioId2) REFERENCES Negocio(negocioId),  -- Clave foránea con la tabla Negocio
    FOREIGN KEY (tipoRelacionId) REFERENCES TipoRelacionNegocioNegocio(tipoRelacionId)  -- Clave foránea con la tabla TipoRelacionNegocioNegocio
);


CREATE TABLE Orden (
    ordenId INT PRIMARY KEY IDENTITY(1,1),     -- Identificador único de la orden
    negocioId INT  ,                    -- Identificador del negocio asociado
    numeroOrden VARCHAR(50)  ,          -- Número de la orden
    fechaOrden DATETIME  ,              -- Fecha en la que se realizó la orden
    montoTotal DECIMAL(18, 2)  ,        -- Monto total de la orden
    estado VARCHAR(50)  ,               -- Estado de la orden (ej. 'Pendiente', 'Completada', etc.)
    fechaCreacion DATETIME   DEFAULT GETDATE(),  -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),  -- Fecha de la última modificación
    activo BIT   DEFAULT 1,              -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                 -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME,                 -- Fecha de eliminación lógica del registro
    FOREIGN KEY (negocioId) REFERENCES Negocio(negocioId)  -- Llave foránea para la relación con Negocio
);

CREATE TABLE Producto (
    productoId INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único del producto
    nombre VARCHAR(255)  ,               -- Nombre del producto
    descripcion VARCHAR(MAX),                   -- Descripción del producto
    precio DECIMAL(18, 2)  ,             -- Precio del producto en promedio o algun precio este precio no es el importante
    fechaCreacion DATETIME   DEFAULT GETDATE(),  -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),  -- Fecha de la última modificación
    activo BIT   DEFAULT 1,              -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                 -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME                  -- Fecha de eliminación lógica del registro
);

CREATE TABLE NegocioProducto (
	negocioProductoId INT PRIMARY KEY IDENTITY(1,1),
    negocioId INT  ,                    -- Identificador del negocio
    productoId INT  ,                   -- Identificador del producto
	precioDeVenta DECIMAL(18, 2),        -- precio al cual el negocio esta vendiendo el producto
    -- Llaves foráneas para la relación
    FOREIGN KEY (negocioId) REFERENCES Negocio(negocioId),
    FOREIGN KEY (productoId) REFERENCES Producto(productoId)
);

CREATE TABLE Persona (
    personaId INT PRIMARY KEY IDENTITY(1,1),        -- Identificador único de la persona
    nombre VARCHAR(255)  ,                    -- Nombre de la persona
    apellido VARCHAR(255)  ,                  -- Apellido de la persona
    email VARCHAR(255)  ,                     -- Correo electrónico de la persona
    telefono VARCHAR(20),                            -- Teléfono de la persona
    fechaCreacion DATETIME   DEFAULT GETDATE(), -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                      -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),    -- Fecha de la última modificación
    activo BIT   DEFAULT 1,                   -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                       -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME                        -- Fecha de eliminación lógica del registro
);

-- Tabla LineaOrden para la relación muchos a muchos entre Orden y Producto
CREATE TABLE LineaOrden (
	lineaOrdenId INT PRIMARY KEY IDENTITY(1,1),
    ordenId INT  ,                      -- Identificador de la orden
    negocioProductoId INT  ,                   -- Identificador del producto
    cantidad INT  ,                     -- Cantidad del producto en la orden
    precioUnitario DECIMAL(18, 2)  ,    -- Precio unitario del producto en el momento de la orden
    -- Llaves foráneas para la relación
    FOREIGN KEY (ordenId) REFERENCES Orden(ordenId),
    FOREIGN KEY (negocioProductoId) REFERENCES NegocioProducto(negocioProductoId)
);

CREATE TABLE TipoRelacionNegocioPersona (
    tipoRelacionPersonaId INT PRIMARY KEY IDENTITY(1,1), -- Identificador único del tipo de relación
    descripcion VARCHAR(100)                      -- Descripción del tipo de relación (ej. 'Empleado', 'Gerente', 'Consultor')
);

-- Tabla NegocioPersona para la relación muchos a muchos entre Negocio y Persona
CREATE TABLE NegocioPersona (
    negocioPersonaId INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único del registro de relación entre negocio y persona
    negocioId INT  ,                          -- Identificador del negocio
    personaId INT  ,                          -- Identificador de la persona
    tipoRelacionPersonaId INT  ,              -- Identificador del tipo de relación
    -- Columnas de gobernanza de registros
    creadoPor VARCHAR(100)  ,                 -- Usuario que creó el registro
    fechaCreacion DATETIME   DEFAULT GETDATE(), -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                      -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),    -- Fecha de la última modificación
    activo BIT   DEFAULT 1,                   -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                       -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME,                       -- Fecha de eliminación lógica del registro
    -- Restricciones de claves foráneas
    FOREIGN KEY (negocioId) REFERENCES Negocio(negocioId),   -- Clave foránea con la tabla Negocio
    FOREIGN KEY (personaId) REFERENCES Persona(personaId),   -- Clave foránea con la tabla Persona
    FOREIGN KEY (tipoRelacionPersonaId) REFERENCES TipoRelacionNegocioPersona(tipoRelacionPersonaId)  -- Clave foránea con la tabla TipoRelacionNegocioPersona
);

CREATE TABLE Direccion (
    direccionId INT PRIMARY KEY IDENTITY(1,1),        -- Identificador único de la dirección
    calle VARCHAR(255)  ,                      -- Calle de la dirección
    numero VARCHAR(50)  ,                      -- Número de la dirección
    ciudad VARCHAR(100)  ,                     -- Ciudad de la dirección
    estado VARCHAR(100)  ,                     -- Estado de la dirección
    codigoPostal VARCHAR(20)  ,                -- Código postal de la dirección
    pais VARCHAR(100)  ,                       -- País de la dirección
    fechaCreacion DATETIME   DEFAULT GETDATE(), -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                       -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),     -- Fecha de la última modificación
    activo BIT   DEFAULT 1,                    -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                        -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME                         -- Fecha de eliminación lógica del registro
);

-- Tabla TipoRelacionNegocioDireccion para catalogar los tipos de relación entre negocios y direcciones
CREATE TABLE TipoRelacionNegocioDireccion (
    tipoRelacionDireccionId INT PRIMARY KEY IDENTITY(1,1), -- Identificador único del tipo de relación
    descripcion VARCHAR(100)                        -- Descripción del tipo de relación (ej. 'Oficina', 'Almacén', 'Sucursal')
);

-- Tabla NegocioDireccion para la relación muchos a muchos entre Negocio y Direccion
CREATE TABLE NegocioDireccion (
    negocioDireccionId INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único del registro de relación entre negocio y dirección
    negocioId INT  ,                            -- Identificador del negocio
    direccionId INT  ,                          -- Identificador de la dirección
    tipoRelacionDireccionId INT  ,              -- Identificador del tipo de relación
    -- Columnas de gobernanza de registros
    creadoPor VARCHAR(100)  ,                   -- Usuario que creó el registro
    fechaCreacion DATETIME   DEFAULT GETDATE(), -- Fecha de creación del registro
    modificadoPor VARCHAR(100),                        -- Usuario que modificó el registro
    fechaModificacion DATETIME DEFAULT GETDATE(),      -- Fecha de la última modificación
    activo BIT   DEFAULT 1,                     -- Indicador de si el registro está activo
    eliminadoPor VARCHAR(100),                         -- Usuario que eliminó (lógicamente) el registro
    fechaEliminacion DATETIME,                         -- Fecha de eliminación lógica del registro
    -- Restricciones de claves foráneas
    FOREIGN KEY (negocioId) REFERENCES Negocio(negocioId),   -- Clave foránea con la tabla Negocio
    FOREIGN KEY (direccionId) REFERENCES Direccion(direccionId), -- Clave foránea con la tabla Direccion
    FOREIGN KEY (tipoRelacionDireccionId) REFERENCES TipoRelacionNegocioDireccion(tipoRelacionDireccionId)  -- Clave foránea con la tabla TipoRelacionNegocioDireccion
);

CREATE TABLE CatalogoEstados (
    estatusId INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único del estado
    nombre VARCHAR(50) NOT NULL,              -- Nombre del estado
    descripcion VARCHAR(255),                 -- Descripción opcional del estado
    fechaCreacion DATETIME DEFAULT GETDATE()  -- Fecha de creación del registro
);

-- Insertar registros iniciales
INSERT INTO CatalogoEstados (nombre, descripcion)
VALUES 
    ('Pendiente de Aprobar', 'La relación está pendiente de ser aprobada'),
    ('Aprobado', 'La relación ha sido aprobada'),
    ('Rechazado', 'La relación ha sido rechazada');

--- alteracion de tabla NegocioUsuario para que tenga la bandera que indique si esta pendiente de aprobacion o si esta o no aprobada.

ALTER TABLE UsuarioNegocio
ADD estatusId INT;  -- Nueva columna para el estatus de la relación

-- Definir la clave foránea para la columna estatusId
ALTER TABLE UsuarioNegocio
ADD CONSTRAINT FK_Estatus_CatalogoEstados
FOREIGN KEY (estatusId) REFERENCES CatalogoEstados(estatusId);


--- Creamos la tabla de mensajes y transacciones de mensajes

CREATE TABLE MensajeOrden (
    mensajeOrdenId INT PRIMARY KEY IDENTITY(1,1),  -- ID único del mensaje
    ordenId INT NOT NULL,                          -- Relacionado con la orden
    emisorUsuarioId INT NULL,                      -- Si fue enviado por un usuario
    emisorNegocioId INT NULL,                      -- Si fue enviado por el negocio
    contenido TEXT NOT NULL,                       -- Mensaje como tal
    fechaEnvio DATETIME DEFAULT GETDATE(),         -- Fecha de envío
    leido BIT DEFAULT 0,                           -- Si fue leído por el receptor

    -- Columnas de gobernanza
    creadoPor VARCHAR(100),                        
    fechaCreacion DATETIME DEFAULT GETDATE(),
    modificadoPor VARCHAR(100),
    fechaModificacion DATETIME DEFAULT GETDATE(),
    activo BIT DEFAULT 1,
    eliminadoPor VARCHAR(100),
    fechaEliminacion DATETIME,

    -- Restricciones
    FOREIGN KEY (ordenId) REFERENCES Orden(ordenId),
    FOREIGN KEY (emisorUsuarioId) REFERENCES Usuario(usuarioId),
    FOREIGN KEY (emisorNegocioId) REFERENCES Negocio(negocioId),
    CHECK (
        (emisorUsuarioId IS NOT NULL AND emisorNegocioId IS NULL) OR
        (emisorUsuarioId IS NULL AND emisorNegocioId IS NOT NULL)
    )  -- Solo puede haber un emisor: usuario o negocio, no ambos
);


