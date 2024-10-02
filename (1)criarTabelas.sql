CREATE TABLE Empresa (
    nro SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(32) NOT NULL,
    nome_fantasia VARCHAR(255)
);

CREATE TABLE Plataforma (
    nro SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(32) NOT NULL,
    qtd_users INTEGER,
    empresa_fund INTEGER,
    empresa_respo INTEGER,
    data_fund DATE,
    FOREIGN KEY (empresa_fund) REFERENCES Empresa(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (empresa_respo) REFERENCES Empresa(nro) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Conversao (
    id_conversao SERIAL PRIMARY KEY NOT NULL,
    moeda VARCHAR(3) UNIQUE NOT NULL,
    nome_conversao VARCHAR(32) NOT NULL,
    fator_conver DECIMAL(10, 6) NOT NULL
);

CREATE TABLE Pais (
    id_pais SERIAL PRIMARY KEY NOT NULL,
    DDI INTEGER,
    nome_pais VARCHAR(32) NOT NULL,
    id_conversao INTEGER,
    FOREIGN KEY (id_conversao) REFERENCES Conversao(id_conversao) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY NOT NULL,
    nick VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20),
    endereco_postal VARCHAR(255),
    pais_residencia INTEGER,
    FOREIGN KEY (pais_residencia) REFERENCES Pais(id_pais) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PlataformaUsuario (
    nro_plataforma INTEGER,
    id_usuario INTEGER,
    nro_usuario INTEGER,
    PRIMARY KEY (nro_plataforma, id_usuario),
    FOREIGN KEY (nro_plataforma) REFERENCES Plataforma(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE StreamerPais (
    id_usuario INTEGER,
    id_pais INTEGER,
    nro_passaporte INTEGER,
    PRIMARY KEY (id_usuario, id_pais),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE EmpresaPais (
    nro_empresa INTEGER,
    id_pais INTEGER,
    id_nacional INTEGER,
    PRIMARY KEY (nro_empresa, id_pais),
    FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Canal (
    id_canal SERIAL PRIMARY KEY NOT NULL,
    nome_canal VARCHAR(32) UNIQUE NOT NULL,
    tipo VARCHAR(20) CHECK (tipo IN ('privado', 'público', 'misto')),
    data_registro DATE NOT NULL,
    descricao_canal VARCHAR(255),
    qtd_visualizacoes INTEGER DEFAULT 0,
    id_usuario INTEGER,
    nro_plataforma INTEGER,
    FOREIGN KEY (nro_plataforma) REFERENCES Plataforma(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Patrocinio (
    nro_empresa INTEGER,
    id_canal INTEGER,
    valor DECIMAL(10, 2) CHECK (valor > 0),
    PRIMARY KEY (nro_empresa, id_canal),
    FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_canal) REFERENCES Canal(id_canal) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE NivelCanal (
    id_canal INTEGER,
    nivel VARCHAR(32),
    valor DECIMAL(10, 2),
    gif VARCHAR(255),
    PRIMARY KEY (id_canal, nivel),
    FOREIGN KEY (id_canal) REFERENCES Canal(id_canal) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Inscricao (
    id_canal INTEGER,
    id_usuario INTEGER,
    nivel VARCHAR(32),
    PRIMARY KEY (id_canal, id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_canal, nivel) REFERENCES NivelCanal(id_canal, nivel) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Video (
    id_video SERIAL PRIMARY KEY NOT NULL,
    id_canal INTEGER,
    titulo_video VARCHAR(255),
    data_registro DATE,
    tema_video VARCHAR(255),
    duracao_video INTEGER,
    visu_simul_video INTEGER DEFAULT 0,
    visu_total_video INTEGER DEFAULT 0,
    FOREIGN KEY (id_canal) REFERENCES Canal(id_canal) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Participa (
    id_video INTEGER,
    id_usuario INTEGER,
    PRIMARY KEY (id_video, id_usuario),
    FOREIGN KEY (id_video) REFERENCES Video(id_video) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Comentario (
    id_comentario SERIAL PRIMARY KEY NOT NULL,
    id_video INTEGER,
    id_usuario INTEGER,
    texto_comentario VARCHAR(255),
    data_registro_comentario DATE,
    coment_on BOOLEAN,
    FOREIGN KEY (id_video) REFERENCES Video(id_video) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Doacao (
    id_pagamento SERIAL PRIMARY KEY NOT NULL,
    id_comentario INTEGER,
    valor DECIMAL(10, 2),
    status VARCHAR(20) CHECK (status IN ('recusado', 'recebido', 'lido')),
    FOREIGN KEY (id_comentario) REFERENCES Comentario(id_comentario) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE BitCoin (
    id_doa_bit INTEGER,
    TxID VARCHAR(255),
    PRIMARY KEY (id_doa_bit),
    FOREIGN KEY (id_doa_bit) REFERENCES Doacao(id_pagamento) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PayPal (
    id_doa_paypal INTEGER,
    IdPayPal VARCHAR(255),
    PRIMARY KEY (id_doa_paypal),
    FOREIGN KEY (id_doa_paypal) REFERENCES Doacao(id_pagamento) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE CartaoCredito (
    id_doa_cartcredito INTEGER,
    nro_cartao VARCHAR(20),
    bandeira_cartao VARCHAR(255),
    PRIMARY KEY (id_doa_cartcredito),
    FOREIGN KEY (id_doa_cartcredito) REFERENCES Doacao(id_pagamento) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE MecanismoPlat (
    id_mecplat INTEGER,
    seq_plataforma INTEGER,
    PRIMARY KEY (id_mecplat, seq_plataforma),
    FOREIGN KEY (id_mecplat) REFERENCES Doacao(id_pagamento) ON UPDATE CASCADE ON DELETE CASCADE
);