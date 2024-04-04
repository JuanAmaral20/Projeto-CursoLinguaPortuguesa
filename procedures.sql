CREATE OR ALTER PROC [dbo].[insertCursos]
	@IdUsuario INT,
	@IdProfessor INT,
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
						EXEC @RESULTADO = [dbo].[insertCursos] 5, 4, 1, 'Como falar OI', '2024-04-01', 5
						SELECT @RESULTADO
    Retornos..........: 0 - OK
						1 - Usuario n é professor
						2 - Tipo curso n existe
						3 - Erro ao inserir
	*/
	BEGIN 
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 1 RETURN 1

		IF NOT EXISTS(SELECT * FROM TipoCurso WHERE Id = @IdTipoCurso) RETURN 2

		INSERT INTO Curso (IdUsuario, Nome, Duracao, DataInicial, IdTipoCurso)
			VALUES (@IdProfessor, @Nome, @Duracao, @DataInicial, @IdTipoCurso)

		IF @@ERROR != 0 RETURN 3

		RETURN 0
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
												1 - Usuario n é professor
                        2 - Id Dificuldade não existe
                        3 - Id Curso não existe
                        4 - Erro ao inserir
    */
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@idProfessor)) != 1	RETURN 1

		IF NOT EXISTS(SELECT Id FROM Dificuldade WHERE Id = @IdDificuldade ) RETURN 2

		IF NOT EXISTS(SELECT Id FROM Curso WHERE Id = @IdCurso ) RETURN 3

		INSERT INTO Modulo(IdDificuldade, IdCurso, Nome)
				VALUES(@IdDificuldade, @IdCurso, @Nome)

		IF @@ERROR != 0 RETURN 4        

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
												1 - Não é professor
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
						1 - Não é professor
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
												1 - Usuário n é professor
												2 - Curso n existe
												3 - Erro ao inserir
    */
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@idProfessor)) != 1	RETURN 1

		IF (SELECT Id FROM Curso WHERE Id = @IdCurso) IS NULL RETURN 2

		INSERT INTO Forum (IdCurso, DescricaoCurso)
			VALUES (@IdCurso, @Descricao)

		IF @@ERROR != 0 RETURN 3

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
                        1 - Usuario não é professor
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
						1 - Usuario n é professor
                        2 -	Turma não existe
                        3 - Usuario não existe
						4 - A turma na está cheia
						5 - Erro ao inserir
	*/

	BEGIN
		-- Variaveis
		DECLARE @tipoTurma BIT

		IF (SELECT [dbo].[validarAutenticacao](@IdProfessor)) != 1 RETURN 1

		IF NOT EXISTS (SELECT Id FROM Turma WHERE Id = @idTurma) RETURN 2

		IF NOT EXISTS (SELECT Id FROM Usuario WHERE Id = @idUsuario) RETURN 3

		-- inserindo variaveis
		SET @tipoTurma = (SELECT Presencial FROM Turma WHERE Id = @idTurma)

		IF (@tipoTurma = 1) AND (SELECT COUNT(IdTurma) FROM UsuarioTurma WHERE IdTurma = @idTurma) = 15 RETURN 4

		INSERT INTO UsuarioTurma (IdUsuario, IdTurma) VALUES (@idUsuario, @idTurma)

		IF @@ERROR != 0 RETURN 5

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
											1 - Email invalido
											2 - Erro ao inserir
	*/
	BEGIN
		IF @Email NOT LIKE '%@%.%' RETURN 1
			INSERT INTO Usuario(Nome, Sobrenome, CPF, Email, Senha, IdProfessor)
					VALUES(@Nome, @Sobrenome, @CPF, @Email, HASHBYTES('MD2',@Senha), @IdProfessor)

			IF @@ERROR != 0 RETURN 2

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
						1 - Usuario não autenticado
						2 -	Curso não existe
						3 - Tipo de pagamento não existe
						4 - Numero de parcelas invalidas
						5 - Erro ao inserir
	*/
	BEGIN
		-- Variaveis
		DECLARE @valorComDesconto DECIMAL(15, 2)

		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2 RETURN 1

		IF NOT EXISTS (SELECT Id FROM Curso WHERE Id = @IdCurso) RETURN 2

		IF NOT EXISTS (SELECT Id FROM TipoPagamento WHERE Id = @IdTipoPagamento) RETURN 3

		IF @quantidadeParcelas IS NOT NULL AND @quantidadeParcelas > 5 RETURN 4

		SET @valorComDesconto = (SELECT [dbo].[CalcularValorTotal](@IdCurso, @IdTipoPagamento, @ValorTotal, @quantidadeParcelas))

		INSERT INTO Pagamento (IdCartao, IdCurso, IdTipoPagamento, quantidadeParcelas, ValorTotal, UsuarioId)
			VALUES (@IdCartao, @IdCurso, @IdTipoPagamento, @quantidadeParcelas, @valorComDesconto, @IdUsuario)

		IF @@ERROR != 0 RETURN 5

		RETURN 0
	END
GO

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
						EXEC @resultado = [dbo].[insertCartao] 5,'VISA', 13, '02/2024', 123
						SELECT @resultado
	Retornos..........: 0 - Processamento OK
						1 - Usuario n é aluno
						2 -	Curso não existe
						3 - Erro ao inserir
	*/
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2 RETURN 1

		IF (@Bandeira NOT LIKE 'MASTER CARD') AND (@Bandeira NOT LIKE 'VISA') RETURN 2

		INSERT INTO Cartao (Numero, Validade, Bandeira, CVC, UsuarioId)
			VALUES (@Numero, @Validade, @Bandeira, @CVC, @idUsuario)

		IF @@ERROR != 0 RETURN 3

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
						1 - Usuario não é aluno
						2 -	Parcela não existe
						3 - Error ao atualizar
	*/
    BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2 RETURN 1

		IF NOT EXISTS(SELECT Id FROM Parcela WHERE Id = @Id) RETURN 2

		UPDATE Parcela
				SET DataPagamentoRealizado = GETDATE(),
					Pago = 1
		WHERE Id = @Id

		IF @@ERROR != 0 RETURN 3

		RETURN 0
    END
GO

CREATE OR ALTER PROC [dbo].[insertEndereco]
	@IdUsuario INT,
	@IdCidade INT,
	@NomeRua VARCHAR(100),
	@Numero SMALLINT,
	@Bairro VARCHAR(45),
	@Cep VARCHAR(9),
	@Complemento VARCHAR(45) = null
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: inserir endereco
    Autor.............: SMN - Emanuel
    Data..............: 04/04/2024
    Ex................: EXEC [dbo].[insertEndereco] 5, 1, 'Praça', 123, 'Centro', 54380000
	*/
	BEGIN 
		IF (SELECT [dbo].[validarAutenticacao](@idUsuario)) NOT IN (2, 1)
			BEGIN
				SELECT 'Você não está autenticado'
				RETURN
			END

		IF NOT EXISTS(SELECT * FROM Usuario WHERE Id = @IdUsuario) 
			BEGIN
				SELECT 'Usuário não existe'
				RETURN
			END


		IF NOT EXISTS(SELECT * FROM Cidade WHERE Id = @IdCidade) 
			BEGIN
				SELECT 'Cidade não existe'
				RETURN
			END

		INSERT INTO Endereco (Bairro, Cep, Complemento, IdCidade, IdUsuario, NomeRua, Numero)
			VALUES (@Bairro, @Cep, @Complemento, @IdCidade, @IdUsuario, @NomeRua, @Numero)

		IF @@ERROR != 0 
			BEGIN
				SELECT 'Erro ao inserir'
				RETURN
			END

		SELECT 'Sucesso'
	END 
GO

CREATE OR ALTER PROC [dbo].[insertCidade]
	@IdUsuario INT,
	@IdUF INT,
	@NomeCidade VARCHAR(60)
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Inserir cidade
    Autor.............: SMN - Emanuel
    Data..............: 04/04/2024
    Ex................: EXEC [dbo].[insertCidade] 5, 1, 'Jampa'
	*/
	BEGIN 
		IF (SELECT [dbo].[validarAutenticacao](@idUsuario)) NOT IN (2, 1)
			BEGIN
				SELECT 'Você não está autenticado'
				RETURN
			END

		IF NOT EXISTS(SELECT * FROM UF WHERE Id = @IdUF) 
			BEGIN
				SELECT 'UF não existe'
				RETURN
			END

		INSERT INTO Cidade (NomeCidade, IdUF)
			VALUES (@NomeCidade, @IdUF)

		IF @@ERROR != 0 
			BEGIN
				SELECT 'Erro ao inserir'
				RETURN
			END

		SELECT 'Sucesso'
	END 
GO

// SELECTS

CREATE OR ALTER PROC listarForuns
	@IdUsuario INT,
	@idCurso INT
	AS
	/*
	Documentação
	Arquivo fonte.....: 
	Objetivo..........: Selecionar foruns
	Autor.............: SMN - JUAN
	Data..............: 27/03/2024
	Ex................:	EXEC [dbo].[listarForuns] 'te', 13, '02/2024', 123

	*/
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2 
			BEGIN
				SELECT 'USUARIO N AUTENTICADO'
				RETURN
			END

		IF NOT EXISTS (SELECT Id FROM Curso WHERE Id = @idCurso)
			BEGIN
				SELECT 'CURSO N ENCONTRADO'
				RETURN
			END


		SELECT * FROM Forum
			WHERE IdCurso = @idCurso
	END
GO

CREATE OR ALTER PROC listarDicionarios
	@IdUsuario INT,
	@idCurso INT
	AS
	/*
	Documentação
	Arquivo fonte.....: 
	Objetivo..........: listart dicionarios
	Autor.............: SMN - JUAN
	Data..............: 27/03/2024
	Ex................: EXEC  [dbo].[listarDicionarios]
	*/
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2 
			BEGIN
				SELECT 'USUARIO N AUTENTICADO'
				RETURN
			END

		IF NOT EXISTS (SELECT Id FROM Curso WHERE Id = @idCurso)
			BEGIN
				SELECT 'CURSO N ENCONTRADO'
				RETURN
			END

		SELECT * FROM Dicionario
			WHERE IdCurso = @idCurso
	END
GO

CREATE OR ALTER PROC listarLicoes
	@IdUsuario INT,
	@idCurso INT
	AS
	/*
	Documentação
	Arquivo fonte.....: 
	Objetivo..........: listart dicionarios
	Autor.............: SMN - JUAN
	Data..............: 27/03/2024
	Ex................: EXEC  [dbo].[listarLicoes] 5, 10
	*/
	BEGIN
		IF (SELECT [dbo].[validarAutenticacao](@IdUsuario)) != 2 
			BEGIN
				SELECT 'USUARIO N AUTENTICADO'
				RETURN
			END

		IF NOT EXISTS (SELECT Id FROM Curso WHERE Id = @idCurso)
			BEGIN
				SELECT 'CURSO N ENCONTRADO'
				RETURN
			END

		SELECT L.Nome, M.Nome AS Modulo, D.Nivel AS Dificuldade FROM Licao AS L
			INNER JOIN Modulo AS M
				ON M.Id = L.ModuloId
			INNER JOIN Dificuldade AS D
				ON D.Id = L.IdDificuldade
			WHERE M.IdCurso = @idCurso
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

CREATE OR ALTER PROC [dbo].[emitirExtrado]
	@IdUsuario INT
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Selecionar todos as parcelas pagas
    Autor.............: SMN - Emanuel
    Data..............: 04/04/2024
    Ex................: EXEC [dbo].[emitirExtrado] 5
	*/
	BEGIN 
		IF (SELECT [dbo].[validarAutenticacao](@idUsuario)) != 2
			BEGIN
				SELECT 'Você não é aluno'
				RETURN
			END

		IF NOT EXISTS(SELECT * FROM Usuario WHERE Id = @IdUsuario) 
			BEGIN
				SELECT 'Usuário não existe'
				RETURN
			END

		SELECT C.Nome, P.ValorParcela, P.Pago, P.DataPagamentoRealizado FROM Parcela AS P
			INNER JOIN Pagamento AS PA
				ON PA.Id = P.IdPagamento
			INNER JOIN Curso AS C
				ON C.Id = PA.IdCurso
			WHERE PA.UsuarioId = @IdUsuario
		
	END 
GO

CREATE OR ALTER PROC [dbo].[selecionarDadosUsuario]
	@IdUsuario INT
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Selecionar dados do perfil do usuario
    Autor.............: SMN - Emanuel
    Data..............: 04/04/2024
    Ex................: EXEC [dbo].[selecionarDadosUsuario] 5
	*/
	BEGIN 
		IF (SELECT [dbo].[validarAutenticacao](@idUsuario)) != 2
			BEGIN
				SELECT 'Você não é aluno'
				RETURN
			END

		IF NOT EXISTS(SELECT * FROM Usuario WHERE Id = @IdUsuario) 
			BEGIN
				SELECT 'Usuário não existe'
				RETURN
			END

		SELECT US.NomeCompleto, E.NomeRua, E.Bairro, C.TelefoneCelular  FROM Usuario AS US
			INNER JOIN Endereco AS E
				ON E.IdUsuario = US.Id
			INNER JOIN Contato AS C
				ON C.IdUsuario = US.Id
			WHERE US.Id = @IdUsuario
		
	END 
GO


