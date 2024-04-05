CREATE OR ALTER FUNCTION [dbo].[validarAutenticacao] (
	@idUsuario INT
)
	RETURNS TINYINT
	AS
    /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........:	Verificar autenticação
    Autor.............: SMN - Emanuel
    Data..............: 28/03/2024
    Ex................: SELECT [dbo].[validarAutenticacao] (1)
    Retornos..........: 1 - Professor
						2 - Aluno
						3 - Não autenticado
    */
	BEGIN
		-- VARIAVEIS
		DECLARE @idAutenticado TINYINT,
				@idProfessor INT,
				@horarioInicial TIME,
				@horarioFinal TIME,
				@horasAutenticadas INT
				

		-- inserindo valores
		SELECT	@horarioFinal = HorarioFinal, 
				@horarioInicial = HorarioInicial,
				@idAutenticado = Id
				FROM Autenticacao WHERE IdUsuario = @idUsuario

		SET @horasAutenticadas = (SELECT DATEDIFF(HOUR, @horarioFinal, @horarioInicial))

		
		SET @idProfessor = (SELECT IdProfessor FROM Usuario WHERE Id = @idUsuario)


		IF (@idAutenticado IS NOT NULL) AND (@idProfessor IS NOT NULL) AND (@horasAutenticadas <= 6) RETURN 1
		
		IF (@idAutenticado IS NOT NULL) AND (@idProfessor IS NULL) AND (@horasAutenticadas <= 6) RETURN 2
		
		RETURN 3
	END
GO

CREATE OR ALTER FUNCTION CalcularValorTotal (
    @IdCurso TINYINT,
    @IdTipoPagamento SMALLINT,
    @ValorTotal DECIMAL(15,2),
    @QtdParcelas SMALLINT
)
RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @ValorComDesconto DECIMAL(15,2);
    DECLARE @ValorFinal DECIMAL(15,2);

    IF @IdTipoPagamento = 2
        SET @ValorComDesconto = @ValorTotal - (@ValorTotal * 0.05); 

      IF (@QtdParcelas > 1)
        SET @ValorComDesconto += (@ValorComDesconto * 0.02 * @QtdParcelas)

    ELSE IF @IdTipoPagamento = 1 
        SET @ValorComDesconto = @ValorTotal * 0.90; 
    ELSE
        SET @ValorComDesconto = @ValorTotal;

 
    RETURN @ValorComDesconto;
END;

