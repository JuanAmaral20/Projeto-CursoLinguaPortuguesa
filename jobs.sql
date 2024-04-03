
CREATE OR ALTER PROC JOB_AtualizarControlePagamento
		AS
		/*
		Documentação
		Arquivo fonte.....: 
		Objetivo..........: Selecionar foruns
		Autor.............: SMN - JUAN
		Data..............: 27/03/2024
		Ex................: DECLARE @resultado INT
							EXEC @resultado = [dbo].[insertCartao] 'te', 13, '02/2024', 123
							SELECT @resultado
		Retornos..........: 1 - Curso n existe
		*/
		BEGIN
			DECLARE @DATA_PROC DATE = GETDATE()
			

				UPDATE ControlePagamento
					SET TotalParcelas = TotalParcelas + QtdParcelas,
						QtdParcelas = 0,
						DataAtualizacao = @DATA_PROC
				WHERE ISNULL(DataAtualizacao, DATEADD(DAY, -1, @DATA_PROC)) < @DATA_PROC
		END
	GO