CREATE OR ALTER TRIGGER TRG_InserirNomeCompleto
    ON [dbo].[Usuario]
    AFTER INSERT 
    AS
    /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........:	Inserir nome completo
    Autor.............: SMN - Emanuel
    Data..............: 28/03/2024
    */
    BEGIN
        DECLARE @IdI INT

        SELECT @IdI = Id
        FROM inserted

        IF @IdI IS NOT NULL
            UPDATE Usuario
                SET NomeCompleto = CONCAT(Nome,' ', Sobrenome)
            WHERE Id = @IdI
    END
GO

CREATE OR ALTER TRIGGER [dbo].[inserirParcelas]
	ON Pagamento
	AFTER INSERT

	AS
    /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........:	Inserir parcelas
    Autor.............: SMN - Emanuel
    Data..............: 28/03/2024
    */
	BEGIN
		-- variaveis
		DECLARE @pagamentoIdI INT,
				@quantidadeI INT,
				@valorTotal DECIMAL(15, 2),
				@contador INT = 0

		-- inserindo valores
		SELECT	@pagamentoIdI = Id,
				@quantidadeI = quantidadeParcelas,
				@valorTotal  = ValorTotal FROM inserted
		

	
		IF (@pagamentoIdI IS NOT NULL) AND (@quantidadeI IS NOT NULL)
			
			WHILE @contador != @quantidadeI
				BEGIN
					SET @contador += 1

					INSERT INTO Parcela (IdPagamento, ValorParcela, DataVencimento, Pago)
						VALUES (@pagamentoIdI, @valorTotal / @quantidadeI, DATEADD(MONTH, @contador, GETDATE()), 0)
				END

			
	END
GO

CREATE OR ALTER TRIGGER TRG_InserirNomeCidadeUF
    ON [dbo].[Cidade]
    AFTER INSERT 
    AS
    /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........:	Inserir nome completo
    Autor.............: SMN - Emanuel
    Data..............: 28/03/2024
    */
    BEGIN
        DECLARE @IdI INT,
                @NomeCidade VARCHAR(20),
                @SiglaUF CHAR(2)

        SELECT    @IdI = i.Id ,
                @NomeCidade = NomeCidade,
                @SiglaUF = Sigla
        FROM inserted i
        INNER JOIN UF u
        ON U.Id = i.IdUF

        IF @IdI IS NOT NULL
            UPDATE Cidade
                SET NomeCidadeUF = CONCAT(@NomeCidade,'-', @SiglaUF)
            WHERE Id = @IdI
    END
GO


CREATE OR ALTER TRIGGER TRG_InserirDataFinalCurso
    ON [dbo].[Curso]
    AFTER INSERT 
    AS
    /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........:	Inserir data final do curso
    Autor.............: SMN - Emanuel
    Data..............: 28/03/2024
    */
    BEGIN
        DECLARE @IdI INT,
                @DataIni DATE,
                @Duracao INT

        SELECT    @IdI = Id ,
                @DataIni = DataInicial,
                @Duracao = Duracao
        FROM inserted 

        IF @IdI IS NOT NULL
            UPDATE Curso
                SET DataFinal = DATEADD(YEAR, @Duracao, @DataIni)
            WHERE Id = @IdI
    END
GO

CREATE OR ALTER TRIGGER [dbo].[atualizarQuantidade]
    ON [dbo].[UsuarioTurma]
    AFTER INSERT 
    AS
    /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........:	Atualizar quantidade de turmas
    Autor.............: SMN - Emanuel
    Data..............: 28/03/2024
    */
    BEGIN
        -- VARIAVES
        DECLARE	@quantidade INT,
                @idITurma INT

        -- inserindom valores
        SET @idITurma = (SELECT IdTurma FROM inserted)
        SET @quantidade = (SELECT COUNT(IdUsuario) FROM UsuarioTurma WHERE IdTurma = @idITurma)

        -- verificar se não tá nulo
        IF (@idITurma IS NOT NULL)
            UPDATE Turma
                SET Quantidade = @quantidade
                WHERE Id = @idITurma

    END
GO

CREATE OR ALTER TRIGGER TRG_ContadorDeParcelasPagas
	ON [dbo].[Parcela]
	AFTER UPDATE
	AS
    /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........:	Contar parcelas pagas
    Autor.............: SMN - Emanuel
    Data..............: 28/03/2024
    */
	BEGIN
		-- Variaveis
		DECLARE @idI INT,
				@IdUsuarioIdI INT

		-- inserindo variaveis
		SELECT @idI = i.Id, @IdUsuarioIdI = P.UsuarioId FROM inserted AS i
			INNER JOIN Pagamento AS P
				ON i.IdPagamento = P.Id

		IF (@idI IS NOT NULL) AND (NOT EXISTS (SELECT * FROM ControlePagamento WHERE IdUsuario = @IdUsuarioIdI))
			INSERT INTO ControlePagamento (IdUsuario, QtdParcelas, TotalParcelas)
				VALUES (@IdUsuarioIdI, 1, 0)
		ELSE 
			UPDATE ControlePagamento
				SET QtdParcelas += 1
				WHERE IdUsuario = @IdUsuarioIdI

	END
GO

CREATE TRIGGER TRG_atualizarHoraFinalAutenticacao
	ON Autenticacao
	AFTER INSERT, UPDATE
	AS
	BEGIN
		-- variaveis
		DECLARE @IdI INT,
				@horaInicial TIME

		-- Inserindo valores
		SET @IdI = (SELECT Id FROM inserted)
		SET @horaInicial = (SELECT HorarioInicial FROM inserted)

		IF @IdI IS NOT NULL
			UPDATE Autenticacao
				SET HorarioFinal = DATEADD(HOUR, 6,  @horaInicial)
				WHERE Id = @IdI

	END
GO
