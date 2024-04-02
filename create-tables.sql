
CREATE TABLE Usuario(
	Id INT PRIMARY KEY IDENTITY,
	IdProfessor INT,
	Nome VARCHAR(45) NOT NULL,
	Sobrenome VARCHAR(100) NOT NULL,
	NomeCompleto VARCHAR(160),
	CPF VARCHAR(14) UNIQUE NOT NULL,
	Email VARCHAR(100) UNIQUE NOT NULL,
	Senha VARCHAR(20) NOT NULL,
	FOREIGN KEY (IdProfessor) REFERENCES Usuario(Id)
	)

CREATE TABLE Contato(
	Id INT PRIMARY KEY IDENTITY,
	IdUsuario INT NOT NULL,
	DDD SMALLINT NOT NULL,
	TelefoneFixo BIGINT NOT NULL,
	TelefoneCelular BIGINT NOT NULL,
	Operadora VARCHAR(20) NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
	)

CREATE TABLE UF(
	Id INT PRIMARY KEY IDENTITY,
	NomeUF VARCHAR(45) NOT NULL,
	Sigla CHAR(2) NOT NULL
	)

CREATE TABLE Cidade(
	Id INT PRIMARY KEY IDENTITY,
	IdUF INT NOT NULL,
	NomeCidade VARCHAR(60) NOT NULL,
	NomeCidadeUF VARCHAR(60),
	FOREIGN KEY (IdUF) REFERENCES UF(Id)
	)

CREATE TABLE Endereco(
	Id INT PRIMARY KEY IDENTITY,
	IdCidade INT NOT NULL,
	IdUsuario INT NOT NULL,
	NomeRua VARCHAR(100) NOT NULL,
	Numero SMALLINT NOT NULL,
	Bairro VARCHAR(45) NOT NULL,
	Cep VARCHAR(9) NOT NULL,
	Complemento VARCHAR(45),
	FOREIGN KEY (IdCidade) REFERENCES Cidade(Id),
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
	)

CREATE TABLE Autenticacao(
	Id INT PRIMARY KEY IDENTITY,
	IdUsuario INT NOT NULL,
	HorarioInicial TIME NOT NULL,
	HorarioFinal TIME,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
	)

CREATE TABLE ControlePagamento(
	Id INT PRIMARY KEY IDENTITY,
	IdUsuario INT NOT NULL,
	TotalParcelas SMALLINT NOT NULL,
	QtdParcelas SMALLINT NOT NULL,
	DataAtualizacao DATE NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
	)

CREATE TABLE Curso(
	Id TINYINT PRIMARY KEY IDENTITY,
	IdTipoCurso TINYINT NOT NULL,
	IdUsuario INT NOT NULL,
	Nome VARCHAR(45) NOT NULL,
	DataInicial DATE NOT NULL,
	DataFinal DATE,
	Duracao SMALLINT NOT NULL,
	FOREIGN KEY (IdTipoCurso) REFERENCES TipoCurso(Id),
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
	)

CREATE TABLE Dicionario(
	Id INT PRIMARY KEY IDENTITY,
	IdCurso TINYINT NOT NULL,
	Nome VARCHAR(60) NOT NULL,
	Descricao VARCHAR(100) NOT NULL,
	FOREIGN KEY (IdCurso) REFERENCES Curso(Id)
	)

CREATE TABLE Forum(
	Id INT PRIMARY KEY IDENTITY,
	IdCurso TINYINT NOT NULL,
	DescricaoCurso VARCHAR(45) NOT NULL,
	FOREIGN KEY (IdCurso) REFERENCES Curso(Id)
	)

CREATE TABLE Mensagem(
	Id INT PRIMARY KEY IDENTITY,
	IdForum INT NOT NULL,
	IdUsuarioEntrada INT NOT NULL,
	IdUsuarioSaida INT NOT NULL,
	Descricao VARCHAR(200) NOT NULL,
	DataHora DATETIME NOT NULL,
	FOREIGN KEY (IdForum) REFERENCES Forum(Id),
	FOREIGN KEY (IdUsuarioEntrada) REFERENCES Usuario(Id),
	FOREIGN KEY (IdUsuarioSaida) REFERENCES Usuario(Id)
	)

CREATE TABLE TipoCurso(
	Id TINYINT PRIMARY KEY IDENTITY,
	Nome VARCHAR(45) NOT NULL
	)

CREATE TABLE Turma(
	Id INT PRIMARY KEY IDENTITY,
	IdCurso TINYINT NOT NULL,
	Quantidade SMALLINT,
	NumeroSala SMALLINT NOT NULL,
	Presencial BIT NOT NULL,
	FOREIGN KEY (IdCurso) REFERENCES Curso(Id)
	)

CREATE TABLE Dificuldade(
	Id TINYINT PRIMARY KEY IDENTITY,
	Nivel VARCHAR(45) NOT NULL
	)

CREATE TABLE Modulo(
	Id TINYINT PRIMARY KEY IDENTITY,
	IdDificuldade TINYINT NOT NULL,
	IdCurso TINYINT NOT NULL,
	Nome VARCHAR(45) NOT NULL,
	FOREIGN KEY (IdDificuldade) REFERENCES Dificuldade(Id),
	FOREIGN KEY (IdCurso) REFERENCES Curso(Id)
	)

CREATE TABLE Progresso(
	Id INT PRIMARY KEY IDENTITY,
	IdModulo TINYINT NOT NULL,
	IdUsuario INT NOT NULL,
	Media DECIMAL(2,1) NOT NULL,
	Feedback VARCHAR(200) NOT NULL,
	FOREIGN KEY (IdModulo) REFERENCES Modulo(Id),
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
	)

CREATE TABLE Licao(
	Id INT PRIMARY KEY IDENTITY,
	IdDificuldade TINYINT NOT NULL,
	Nome VARCHAR(45) NOT NULL,
	FOREIGN KEY (IdDificuldade) REFERENCES Dificuldade(Id)
	)

CREATE TABLE Enunciado(
	Id INT PRIMARY KEY IDENTITY,
	IdLicao INT NOT NULL,
	Descricao VARCHAR(500) NOT NULL,
	FOREIGN KEY (IdLicao) REFERENCES Licao(Id) 
	)

CREATE TABLE Notas(
	Id INT PRIMARY KEY IDENTITY,
	IdUsuario INT NOT NULL,
	IdLicao INT NOT NULL,
	Nota DECIMAL(2,1) NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id),
	FOREIGN KEY (IdLicao) REFERENCES Licao(Id) 
	)

CREATE TABLE Cartao(
	Id SMALLINT PRIMARY KEY IDENTITY,
	Bandeira VARCHAR(45) NOT NULL,
	Numero BIGINT NOT NULL,
	Validade VARCHAR(45) NOT NULL,
	CVC SMALLINT NOT NULL
	)

CREATE TABLE TipoPagamento(
	Id SMALLINT PRIMARY KEY IDENTITY,
	Nome VARCHAR(20) NOT NULL
	)

CREATE TABLE Pagamento(
	Id INT PRIMARY KEY IDENTITY,
	IdCurso TINYINT NOT NULL,
	IdTipoPagamento SMALLINT NOT NULL,
	IdCartao SMALLINT,
	ValorTotal DECIMAL(15,2) NOT NULL
	FOREIGN KEY (IdCurso) REFERENCES Curso(Id),
	FOREIGN KEY (IdTipoPagamento) REFERENCES TipoPagamento(Id),
	FOREIGN KEY (IdCartao) REFERENCES Cartao(Id)
	)

CREATE TABLE Parcela(
	Id TINYINT PRIMARY KEY IDENTITY,
	IdPagamento INT NOT NULL,
	ValorParcela DECIMAL(15,2) NOT NULL,
	DataVencimento VARCHAR(45) NOT NULL,
	DataPagamentoRealizado DATE,
	Pago BIT NOT NULL,
	FOREIGN KEY (IdPagamento) REFERENCES Pagamento(Id)
	)

CREATE TABLE UsuarioTurma (
	IdUsuario INT NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id),
	IdTurma INT NOT NULL,
	FOREIGN KEY (IdTurma) REFERENCES Turma(Id),
)

