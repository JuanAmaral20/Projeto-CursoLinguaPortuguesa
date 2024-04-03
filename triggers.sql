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