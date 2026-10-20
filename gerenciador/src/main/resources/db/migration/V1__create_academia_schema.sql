CREATE TABLE alunos(
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE,
    sexo VARCHAR(1) CHECK (sexo IN ('M', 'F')),
    TELEFONE VARCHAR(30),
    CELULAR VARCHAR(30),
    email VARCHAR(150),
    observacao TEXT,
    endereco VARCHAR(150),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    cep VARCHAR(20),
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP
);

CREATE TABLE modalidades(
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE,
    ativa BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE graduacoes(
    id BIGSERIAL PRIMARY KEY,
    modalidade_id BIGINT NOT NULL REFERENCES modalidades(id),
    nome VARCHAR(150) NOT NULL,
    UNIQUE (modalidade_id, nome)
 );

CREATE TABLE planos(
    id BIGSERIAL PRIMARY KEY,
    modalidade_id BIGINT NOT NULL REFERENCES modalidades(id),
    nome VARCHAR(150) NOT NULL,
    valor_mensal NUMERIC(10,2) NOT NULL CHECK (valor_mensal >= 0),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE(modalidade_id, nome)
);

CREATE TABLE matriculas(
    id BIGSERIAL PRIMARY KEY,
    aluno_id BIGINT NOT NULL REFERENCES alunos(id),
    data_matricula DATE NOT NULL DEFAULT CURRENT_DATE,
    dia_vencimento INTEGER NOT NULL CHECK (dia_vencimento BETWEEN 1 AND 31),
    data_encerramento DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVO',
    CHECK (status IN ('ATIVO', 'INATIVO', 'CANCELADO'))
);

CREATE TABLE matriculas_modalidades(
    id BIGSERIAL PRIMARY KEY,
    matricula_id BIGINT NOT NULL REFERENCES matriculas(id),
    modalidade_id BIGINT NOT NULL REFERENCES modalidades(id),
    graduacao_id BIGINT NOT NULL REFERENCES graduacoes(id),
    plano_id BIGINT NOT NULL REFERENCES planos(id),
    data_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fim DATE,
    UNIQUE (matricula_id, modalidade_id)
);

CREATE TABLE faturas_matriculas(
    id BIGSERIAL PRIMARY KEY,
    matricula_id BIGINT NOT NULL REFERENCES matriculas(id),
    data_vencimento DATE NOT NULL,
    valor NUMERIC(10,2) NOT NULL CHECK (valor >= 0),
    data_pagamento TIMESTAMP,
    data_cancelamento DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'ABERTA',
    CHECK (status IN ('ABERTA', 'PAGA', 'CANCELADA', 'VENCIDA')),
    UNIQUE (matricula_id, data_vencimento)
);

CREATE TABLE assuidade(
    id BIGSERIAL PRIMARY KEY,
    matricula_id BIGINT NOT NULL REFERENCES matriculas(id),
    data_entrada TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_saida TIMESTAMP
);