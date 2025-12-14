CREATE TABLE endereco
(
    id     UUID PRIMARY KEY,
    rua    VARCHAR(255) NOT NULL,
    numero varchar(10)  NOT NULL,
    bairro VARCHAR(255) NOT NULL,
    cep    VARCHAR(20)  NOT NULL,
    cidade VARCHAR(255) NOT NULL,
    uf     VARCHAR(2)   NOT NULL
);

CREATE TABLE cliente
(
    id          UUID PRIMARY KEY,
    nome        VARCHAR(255)       NOT NULL,
    sobrenome   VARCHAR(255)       NOT NULL,
    cpf_cnpj     VARCHAR(14) UNIQUE NOT NULL,
    email       VARCHAR(255),
    telefone    VARCHAR(20),
    endereco_id UUID UNIQUE,
    CONSTRAINT fk_endereco
        FOREIGN KEY (endereco_id)
            REFERENCES endereco (id)
            ON DELETE CASCADE
);

CREATE TABLE veiculo
(
    id         UUID PRIMARY KEY,
    placa      VARCHAR(8) UNIQUE NOT NULL,
    cor        VARCHAR(30) NOT NULL,
    ano        VARCHAR(4) NOT NULL,
    marca      VARCHAR(50)  NOT NULL,
    modelo     VARCHAR(50)  NOT NULL,
    cliente_id UUID NOT NULL,
    CONSTRAINT fk_cliente
        FOREIGN KEY (cliente_id)
            REFERENCES cliente (id)
            ON DELETE CASCADE
);

CREATE TABLE peca_insumo (
    id UUID PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    codigo_fabricante VARCHAR(200),
    sku VARCHAR(200) UNIQUE,
    marca VARCHAR(200),
    modelos_compativeis TEXT,
    quantidade_estoque INTEGER,
    preco_custo NUMERIC(12, 2),
    preco_venda NUMERIC(12, 2),
    categoria VARCHAR(200),
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP,
    data_atualizacao TIMESTAMP
);

CREATE TABLE servico (
    id UUID PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    preco NUMERIC(10,2) NOT NULL,
    duracao_estimada INTEGER,
    categoria VARCHAR(50),
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP NOT NULL,
    data_atualizacao TIMESTAMP
);

CREATE TABLE orcamento (
    id UUID PRIMARY KEY,
    cliente_id UUID NOT NULL,
    veiculo_id UUID NOT NULL,
    status VARCHAR(50),
    valor_total NUMERIC(12, 2) NOT NULL,
    valor_total_em_servicos NUMERIC(12, 2) NOT NULL,
    valor_total_em_pecas NUMERIC(12, 2) NOT NULL,
    CONSTRAINT fk_orcamento_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id),
    CONSTRAINT fk_veiculo_id FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE item_peca_orcamento (
    id UUID PRIMARY KEY,
    orcamento_id UUID NOT NULL,
    peca_id UUID NOT NULL,
    nome VARCHAR(50) NOT NULL,
    preco NUMERIC(12,2) NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    descricao VARCHAR(200) NOT NULL,

    CONSTRAINT fk_item_orcamento
        FOREIGN KEY (orcamento_id)
            REFERENCES orcamento (id)
            ON DELETE CASCADE,

    CONSTRAINT fk_item_peca
        FOREIGN KEY (peca_id)
            REFERENCES peca_insumo (id)
            ON DELETE CASCADE,

    CONSTRAINT uk_orcamento_peca UNIQUE (orcamento_id, peca_id)
);

CREATE TABLE orcamento_servico (
    id UUID PRIMARY KEY,
    orcamento_id UUID NOT NULL,
    servico_id UUID NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    preco NUMERIC(12,2) NOT NULL,
    CONSTRAINT fk_os_orcamento FOREIGN KEY (orcamento_id) REFERENCES orcamento(id) ON DELETE CASCADE,
    CONSTRAINT fk_os_servico FOREIGN KEY (servico_id) REFERENCES servico(id) ON DELETE CASCADE
);

CREATE TABLE ordem_servico (
    id UUID PRIMARY KEY,
    cliente_id UUID NOT NULL,
    veiculo_id UUID NOT NULL,
    status VARCHAR(50),
    data_criacao TIMESTAMP WITHOUT TIME ZONE,
    data_inicio_da_execucao TIMESTAMP WITHOUT TIME ZONE,
    data_finalizacao TIMESTAMP WITHOUT TIME ZONE,
    data_entrega TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_os_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id),
    CONSTRAINT fk_os_veiculo FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE item_peca_ordem_servico (
    id UUID PRIMARY KEY,
    ordem_servico_id UUID NOT NULL,
    peca_id UUID NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario NUMERIC(12, 2) NOT NULL,
    nome VARCHAR (50) NOT NULL,
    descricao VARCHAR (100) NOT NULL,
    CONSTRAINT fk_ipos_ordem_servico FOREIGN KEY (ordem_servico_id) REFERENCES ordem_servico(id) ON DELETE CASCADE,
    CONSTRAINT fk_ipos_peca FOREIGN KEY (peca_id) REFERENCES peca_insumo(id)
);

CREATE TABLE item_servico_ordem_servico (
    id UUID PRIMARY KEY,
    nome varchar(50) NOT NULL,
    descricao varchar(200) NOT NULL,
    ordem_servico_id UUID NOT NULL,
    servico_id UUID NOT NULL,
    preco_unitario NUMERIC(12, 2) NOT NULL,
    CONSTRAINT fk_isos_ordem_servico FOREIGN KEY (ordem_servico_id) REFERENCES ordem_servico(id) ON DELETE CASCADE,
    CONSTRAINT fk_isos_servico FOREIGN KEY (servico_id) REFERENCES servico(id) ON DELETE CASCADE
);

CREATE TABLE usuarios (
    id UUID PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);