CREATE OR ALTER TRIGGER TRG_InserirNomeCompleto
        ON [dbo].[Usuario]
        AFTER INSERT 
        AS

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