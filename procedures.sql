CREATE OR ALTER PROC [dbo].[insertCursos]
	@IdUsuario INT,
	@IdTipoCurso INT,
	@Nome VARCHAR(45),
	@DataInicial DATE,
	@Duracao SMALLINT
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Inserir cursos
    Autor.............: SMN - Emanuel
    Data..............: 01/04/2024
    Ex................: DECLARE @RESULTADO TINYINT
						EXEC @RESULTADO = [dbo].[insertCursos] 4, 1, 'Como falar OI', '2024-04-01', 5
						SELECT @RESULTADO
    Retornos..........: 0 - OK
						1 - Usuario n existe
						2 - Tipo curso n existe
						3 - Erro ao inserir
    */
	BEGIN 
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 1 RETURN 1

		IF NOT EXISTS(SELECT * FROM TipoCurso WHERE Id = @IdTipoCurso) RETURN 2

		INSERT INTO Curso (IdUsuario, Nome, Duracao, DataInicial, IdTipoCurso)
			VALUES (@IdUsuario, @Nome, @Duracao, @DataInicial, @IdTipoCurso)

		IF @@ERROR != 0 RETURN 3

		RETURN 0
	END 
GO

CREATE OR ALTER PROC [dbo].[selectTodosCursos]
	@idUsuario INT
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Selecionar cursos
    Autor.............: SMN - Emanuel
    Data..............: 01/04/2024
    Ex................: EXEC [dbo].[selectTodosCursos] 4
    Retornos..........:
    */
	BEGIN 
		IF (SELECT [dbo].[validarAutenticacao](@idUsuario)) NOT IN (2, 1)
			BEGIN
				SELECT 'Usuário n autenticado'
			END
		ELSE
			BEGIN
				SELECT CR.Nome, CR.DataInicial, CR.DataFinal, US.NomeCompleto, CR.Duracao, TC.Nome FROM Curso AS CR
					INNER JOIN Usuario AS US
						ON US.Id = CR.IdUsuario
					INNER JOIN TipoCurso AS TC
						ON TC.Id = CR.IdTipoCurso
			END
	END 
GO

CREATE OR ALTER PROC SP_InserirModulo(
		@idProfessor INT,
        @IdDificuldade TINYINT,
        @IdCurso TINYINT,
        @Nome VARCHAR(45)
        )
    AS
    /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........: Inserir Modulo
    Autor.............: SMN - JUAN
    Data..............: 27/03/2024
    Ex................: EXEC [dbo].[SP_InserirModulo]
    Retornos..........: 0 - Processamento OK
                        1 - Id Dificuldade não existe
                        2 - Id Curso não existe
                        3 - Erro ao inserir
    */
    BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@idProfessor)) != 1	RETURN 1

        IF NOT EXISTS(SELECT Id FROM Dificuldade WHERE Id = @IdDificuldade ) RETURN 1

        IF NOT EXISTS(SELECT Id FROM Curso WHERE Id = @IdCurso ) RETURN 2

        INSERT INTO Modulo(IdDificuldade, IdCurso, Nome)
            VALUES(@IdDificuldade, @IdCurso, @Nome)

        IF @@ERROR != 0 RETURN 3        

        RETURN 0

    END
GO

CREATE OR ALTER PROC SP_InserirLicao(
	@idProfessor INT,
    @IdDificuldade TINYINT,
    @Nome VARCHAR(45)
    )
        AS
        /*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........: Inserir Lição
    Autor.............: SMN - JUAN
    Data..............: 27/03/2024
    Ex................: EXEC [dbo].[SP_InserirModulo]
    Retornos..........: 0 - Processamento 
						1 - Não autenticado
                        2 - Dificuldade não existe
                        3 - Erro ao inserir
    */
    BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@idProfessor)) != 1	RETURN 1

		IF NOT EXISTS(SELECT Id FROM Dificuldade WHERE Id = @IdDificuldade ) RETURN 2

		INSERT INTO Licao(IdDificuldade, Nome)
			VALUES(@IdDificuldade, @Nome)

		IF @@ERROR != 0 RETURN 3

		RETURN 0
    END
GO

CREATE OR ALTER PROC [dbo].[insertDicionario]
	@idProfessor INT,
	@IdCurso INT,
	@Nome VARCHAR(45),
	@Descricao VARCHAR(100)
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Inserir dicionario
    Autor.............: SMN - Emanuel
    Data..............: 01/04/2024
    Ex................: DECLARE @RESULTADO TINYINT
						EXEC @RESULTADO = [dbo].[insertDicionario] 1, 'Dicionario de portgues', 'Muito bom'
						SELECT @RESULTADO
    Retornos..........: 0 - OK
						1 - Não autenticado
						2 - Curso n existe
						3 - Erro ao inserir
    */
	BEGIN 
		IF (SELECT [dbo].[validarAutenticacao](@idProfessor)) != 1	RETURN 1

		IF (SELECT Id FROM Curso WHERE Id = @IdCurso) IS NULL RETURN 2

		INSERT INTO Dicionario (IdCurso, Nome, Descricao)
			VALUES (@IdCurso, @Nome, @Descricao)

		IF @@ERROR != 0 RETURN 3

		RETURN 0
	END 
GO

CREATE OR ALTER PROC [dbo].[insertForum]
	@idProfessor INT,
	@IdCurso INT,
	@Descricao VARCHAR(100)
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Inserir forum
    Autor.............: SMN - Emanuel
    Data..............: 01/04/2024
    Ex................: DECLARE @RESULTADO TINYINT
						EXEC @RESULTADO = [dbo].[insertForum] 1, 'Comentários total'
						SELECT @RESULTADO
    Retornos..........: 0 - OK
						1 - Curso n existe
						2 - Erro ao inserir
    */
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@idProfessor)) != 1	RETURN 1

		IF (SELECT Id FROM Curso WHERE Id = @IdCurso) IS NULL RETURN 1

		INSERT INTO Forum (IdCurso, DescricaoCurso)
			VALUES (@IdCurso, @Descricao)

		IF @@ERROR != 0 RETURN 2

		RETURN 0
	END 
GO

CREATE OR ALTER PROC [dbo].[insertProgresso]
	@idProfessor INT,
	@IdModulo TINYINT,
	@IdUsuario INT,
	@Media DECIMAL(2,1),
	@Feedback VARCHAR(200)

	AS
	/*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........: Inserir pregresso
    Autor.............: SMN - JUAN
    Data..............: 27/03/2024
    Ex................: DECLARE @resultado INT
						EXEC @resultado = [dbo].[insertProgresso] 4, 1, 1, 5.6, 'NOTA RUIM'
						SELECT @resultado
    Retornos..........: 0 - Processamento 
                        1 - Não autenticado
                        2 - Modulo não existe
						3 - Usuario não existe
						4 - Erro ao inserir
    */
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@idProfessor)) != 1	RETURN 1

		IF NOT EXISTS(SELECT Id FROM Modulo WHERE Id = @IdModulo ) RETURN 2

		IF NOT EXISTS(SELECT Id FROM Usuario WHERE Id = @IdUsuario ) RETURN 3

		INSERT INTO Progresso (IdModulo, IdUsuario, Media, Feedback)
			VALUES (@IdModulo, @IdUsuario, @Media, @Feedback)

		IF @@ERROR != 0 RETURN 4

        RETURN 0

	END
GO

CREATE OR ALTER PROC [dbo].[selectProgressos]
	@IdUsuario INT

	AS
	/*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........: Inserir pregresso
    Autor.............: SMN - JUAN
    Data..............: 27/03/2024
    Ex................: EXEC [dbo].[selectProgressos] 1
    Retornos..........: 0 - Processamento 
                        1 - Não autenticado
                        2 - Modulo não existe
						3 - Usuario não existe
						4 - Erro ao inserir
    */
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2
			BEGIN
				SELECT 'Você não é aluno'
				RETURN
			END

		SELECT * FROM Progresso AS PR
			INNER JOIN Usuario AS US
				ON US.Id = PR.IdUsuario
		WHERE US.Id = @IdUsuario
		

	END
GO

CREATE OR ALTER PROC [dbo].[insertAlunosEmTurmas]
	@IdProfessor INT,
	@idTurma INT,
	@idUsuario INT
	AS
	/*
    Documentação
    Arquivo fonte.....: 
    Objetivo..........: Inserir alunos em turma
    Autor.............: SMN - JUAN
    Data..............: 27/03/2024
    Ex................: DECLARE @resultado INT
						EXEC @resultado = [dbo].[insertAlunosEmTurmas] 1, 1
						SELECT @resultado
    Retornos..........: 0 - Processamento OK
                        1 -	Turma não existe
                        2 - Usuario não existe
						3 - A turma na está cheia
						4 - Erro ao inserir
	*/

	BEGIN
		-- Variaveis
		DECLARE @tipoTurma BIT

		IF (SELECT [dbo].[validarAutenticacao](@IdProfessor)) != 1
			BEGIN
				SELECT 'Você não é professor'
				RETURN
			END

		IF NOT EXISTS (SELECT Id FROM Turma WHERE Id = @idTurma) RETURN 1

		IF NOT EXISTS (SELECT Id FROM Usuario WHERE Id = @idUsuario) RETURN 2

		-- inserindo variaveis
		SET @tipoTurma = (SELECT Presencial FROM Turma WHERE Id = @idTurma)

		IF (@tipoTurma = 1) AND (SELECT COUNT(IdTurma) FROM UsuarioTurma WHERE IdTurma = @idTurma) = 15 RETURN 3

		INSERT INTO UsuarioTurma (IdUsuario, IdTurma) VALUES (@idUsuario, @idTurma)

		IF @@ERROR != 0 RETURN 4

		RETURN 0
	END
GO

CREATE OR ALTER PROC SP_InserirUsuarios(
        @Nome VARCHAR(45),
        @Sobrenome VARCHAR(100),
        @CPF VARCHAR(14),
        @Email VARCHAR(100),
        @Senha VARCHAR(20),
        @IdProfessor INT = NULL
        )
        AS
		/*
		Documentação
		Arquivo fonte.....: 
		Objetivo..........: Inserir usuarios
		Autor.............: SMN - JUAN
		Data..............: 27/03/2024
		Ex................: DECLARE @resultado INT
							EXEC @resultado = [dbo].[SP_InserirUsuarios]  'teste', 'ergrege', 12345678945, 'tss@teste.com', 123456798
							SELECT @resultado
		Retornos..........: 0 - Processamento OK
							1 -	Turma não existe
							2 - Usuario não existe
							3 - A turma na está cheia
							4 - Erro ao inserir
		*/
        BEGIN
			IF @Email NOT LIKE '%@%.%' RETURN 1

            INSERT INTO Usuario(Nome, Sobrenome, CPF, Email, Senha, IdProfessor)
                VALUES(@Nome, @Sobrenome, @CPF, @Email, HASHBYTES('MD2',@Senha), @IdProfessor)

            RETURN 0
        END
    GO

CREATE OR ALTER PROC [dbo].[insertPagamento] 
	@IdUsuario INT,
	@IdCurso TINYINT,
	@IdTipoPagamento SMALLINT,
	@ValorTotal DECIMAL(15,2),
	@IdCartao SMALLINT = NULL,
	@quantidadeParcelas INT = NULL

	AS
	/*
	Documentação
	Arquivo fonte.....: 
	Objetivo..........: Inserir pagamento
	Autor.............: SMN - JUAN
	Data..............: 27/03/2024
	Ex................: DECLARE @resultado INT
						EXEC @resultado = [dbo].[insertPagamento] 1, 1, 2, 5000, null, 4
						SELECT @resultado
	Retornos..........: 0 - Processamento OK
						1 -	Curso não existe
						2 - Tipo de pagamento não existe
						3 - Numero de parcelas invalidas
						3 - Erro ao inserir
	*/
	BEGIN
		-- Variaveis
		DECLARE @valorComDesconto DECIMAL(15, 2)

		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2
			BEGIN
				SELECT 'Você não é aluno'
				RETURN
			END

		IF NOT EXISTS (SELECT Id FROM Curso WHERE Id = @IdCurso) RETURN 1

		IF NOT EXISTS (SELECT Id FROM TipoPagamento WHERE Id = @IdTipoPagamento) RETURN 2

		IF @quantidadeParcelas IS NOT NULL AND @quantidadeParcelas > 5 RETURN 3

		SET @valorComDesconto = (SELECT [dbo].[CalcularValorTotal](@IdCurso, @IdTipoPagamento, @ValorTotal, @quantidadeParcelas))

		INSERT INTO Pagamento (IdCartao, IdCurso, IdTipoPagamento, quantidadeParcelas, ValorTotal)
			VALUES (@IdCartao, @IdCurso, @IdTipoPagamento, @quantidadeParcelas, @valorComDesconto)

		IF @@ERROR != 0 RETURN 4

		RETURN 0
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


CREATE OR ALTER PROC [dbo].[insertCartao]
	@idUsuario INT,
	@Bandeira VARCHAR(45),
	@Numero BIGINT,
	@Validade VARCHAR(45),
	@CVC SMALLINT

	AS
	/*
	Documentação
	Arquivo fonte.....: 
	Objetivo..........: Inserir pagamento
	Autor.............: SMN - JUAN
	Data..............: 27/03/2024
	Ex................: DECLARE @resultado INT
						EXEC @resultado = [dbo].[insertCartao] 'te', 13, '02/2024', 123
						SELECT @resultado
	Retornos..........: 0 - Processamento OK
						1 -	Curso não existe
						2 - Tipo de pagamento não existe
						3 - Numero de parcelas invalidas
						3 - Erro ao inserir
	*/
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2
			BEGIN
				SELECT 'Você não é aluno'
				RETURN
			END


		IF (@Bandeira NOT LIKE 'MASTER CARD') AND (@Bandeira NOT LIKE 'VISA') RETURN 1

		INSERT INTO Cartao (Numero, Validade, Bandeira, CVC)
			VALUES (@Numero, @Validade, @Bandeira, @CVC)

		IF @@ERROR != 0 RETURN 2

		RETURN 0
	END
GO

CREATE OR ALTER PROC SP_AtualizarParcela(
	@IdUsuario INT,
    @Id INT
    )
    AS
	/*
	Documentação
	Arquivo fonte.....: 
	Objetivo..........: Atualizar parcela
	Autor.............: SMN - JUAN
	Data..............: 27/03/2024
	Ex................: DECLARE @resultado INT
						EXEC @resultado = [dbo].[SP_AtualizarParcela] 1
						SELECT @resultado
	Retornos..........: 0 - Processamento OK
						1 -	Parcela não existe
						2 - Error ao atualizar
	*/
    BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2
			BEGIN
				SELECT 'Você não é aluno'
				RETURN
			END

        IF NOT EXISTS(SELECT Id FROM Parcela WHERE Id = @Id) RETURN 1

        UPDATE Parcela
            SET DataPagamentoRealizado = GETDATE()
        WHERE Id = @Id

		IF @@ERROR != 0 RETURN 2

		RETURN 0
    END
GO

CREATE OR ALTER PROC listarForuns
	@idCurso INT
	AS
	/*
	Documentação
	Arquivo fonte.....: 
	Objetivo..........: Selecionar foruns
	Autor.............: SMN - JUAN
	Data..............: 27/03/2024
	Ex................:	EXEC [dbo].[listarForuns] 'te', 13, '02/2024', 123
	Retornos..........: 1 - Curso n existe

	*/
	BEGIN
		IF NOT EXISTS (SELECT Id FROM Curso WHERE Id = @idCurso) RETURN 1

		SELECT * FROM Forum
			WHERE IdCurso = @idCurso
	END
GO


CREATE OR ALTER PROC listarDicionarios
	@idCurso INT
	AS
	/*
	Documentação
	Arquivo fonte.....: 
	Objetivo..........: listart dicionarios
	Autor.............: SMN - JUAN
	Data..............: 27/03/2024
	Ex................: EXEC  [dbo].[listarDicionarios]
	Retornos..........: 1 - Curso n existe
	*/
	BEGIN
		IF NOT EXISTS (SELECT Id FROM Curso WHERE Id = @idCurso) RETURN 1

		SELECT * FROM Dicionario
			WHERE IdCurso = @idCurso
	END
GO
