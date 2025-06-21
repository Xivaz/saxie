-- Gerado por Oracle SQL Developer Data Modeler 4.1.5.907
--   em:        2017-02-17 11:33:32 BRST
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g
-- 2017/02/22 - SILAS - Versão Estável para tabela de Instituição. 
-- 2017/03/20 - SILAS - Versão utilizando innoSetup para instalação. 
-- 2017/03/28 - SILAS - Inclusão de Anexos na Disciplina
prompt Executando dminstall...
column arquivo new_val arquivo
select 'C:\SAX\INSTALL\LOG\bdinstall1_0' || to_char(sysdate, 'yyyymmddhh24mi') || '.log' arquivo from dual;
spool &arquivo;

Alter Session Set nls_language='BRAZILIAN PORTUGUESE';
Alter Session Set NLS_TERRITORY = 'BRAZIL';
Alter Session Set NLS_NUMERIC_CHARACTERS=',.';
Alter Session Set NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

CREATE TABLE TBL_Instituicao
  (
    inst_in_id   		INTEGER CONSTRAINT NNC_Instituicao_inst_in_id NOT NULL ,
    inst_st_cnpj 		VARCHAR2 (20) NOT NULL,
    inst_st_nome 		VARCHAR2 (255) NOT NULL,
    inst_St_mantenedora VARCHAR2 (255) ,
    inst_in_id_pai 		INTEGER NULL,
    inst_in_codigo_ies 	INTEGER NOT NULL,
	INST_IN_MANTENEDORA INTEGER NULL,
	inst_st_imagem     	VARCHAR2(30) NULL,
	user_st_atualiza    VARCHAR2(30) NOT NULL,
	user_dt_atualiza    DATE
  ) 
/
  
COMMENT ON COLUMN tbl_instituicao.inst_in_id
IS
  'Identificador chave da tbl_instituicao' ;
  COMMENT ON COLUMN tbl_instituicao.INST_ST_CNPJ
IS
  'Número do CNPJ' ;
  COMMENT ON COLUMN tbl_instituicao.inst_st_nome
IS
  'Nome da Instituição de Ensino' ;
  COMMENT ON COLUMN tbl_instituicao.inst_in_codigo_ies
IS
  'Id da IES no CENSO.' ;
  COMMENT ON COLUMN tbl_instituicao.inst_in_id_pai
IS
  'Identificador chave da tbl_instituicao (pai)' ;

  
ALTER TABLE TBL_Instituicao ADD CONSTRAINT tbl_instituicao_PK PRIMARY KEY ( inst_in_id ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 

DROP INDEX inst_inst_in_id_pai_IDX;  
CREATE INDEX inst_inst_in_id_pai_IDX ON tbl_instituicao
  (
    inst_in_id_pai ASC
  )
  ;

ALTER TABLE TBL_INSTITUICAO ADD inst_in_codigo_polo integer;

CREATE TABLE TBL_aluno
  (
    alu_in_id             INTEGER NOT NULL ,
	ALU_IN_RGM            INTEGER NOT NULL ,
    alu_st_nome           VARCHAR2 (255 BYTE) NOT NULL ,
    alu_st_nome_censo     VARCHAR2 (255 BYTE) NOT NULL ,
    alu_in_cpf            INTEGER NOT NULL ,
    alu_st_rg             VARCHAR2 (20 CHAR) ,
    alu_st_passaporte     VARCHAR2 (20 CHAR) ,
    alu_st_rne            VARCHAR2 (20 CHAR) ,
    alu_in_nacionalidade  INTEGER NOT NULL ,
    alu_dt_nascimento     DATE NOT NULL ,
    alu_in_sexo           INTEGER NOT NULL ,
    alu_in_corraca        INTEGER NOT NULL ,
    alu_st_nome_mae       VARCHAR2 (255 CHAR) ,
    alu_st_nome_mae_censo VARCHAR2 (255 CHAR) ,
    alu_in_pais_origem      INTEGER NOT NULL ,
    alu_in_uf_nascimento    INTEGER,
    alu_in_muni_nascimento  INTEGER,
    alu_in_deficiente     INTEGER NOT NULL ,
    alu_st_deficiencia    VARCHAR2 (255) ,
    alu_in_canhoto        INTEGER NOT NULL,
    alu_in_obito          INTEGER NOT NULL,
	alu_dt_obito          DATE NULL,
	alu_in_escolaridade   INTEGER NOT NULL,
	user_st_atualiza      VARCHAR2(30) NOT NULL,
	user_dt_atualiza      DATE  NOT NULL) 
/

COMMENT ON COLUMN TBL_ALUNO.alu_st_nome_censo
IS
  'Nome do Aluno no CENSO - Sem caractéres especiais e sem acentuação.' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_in_cpf
IS
  'CPF do Aluno' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_st_passaporte
IS
  'RNE de aluno estrangeiro' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_st_rne
IS
  'RNE do aluno se estrangeiro' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_in_nacionalidade
IS
  'Identificador da Nacionalidade do TBL_ALUNO.' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_dt_nascimento
IS
  'Data de Nascimento' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_in_sexo
IS
  'Sexo do aluno' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_in_corraca
IS
  'Cor / Raça do Aluno' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_st_nome_mae_censo
IS
  'Nome da mãe no formato para o CENSO - Sem caractéres especiais e sem acentuação.' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_in_deficiente
IS
  'Aluno Deficiênte? : 0 - Não 1 - Sim' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_in_pais_origem IS
  'País de nascimento do aluno';
  COMMENT ON COLUMN TBL_ALUNO.alu_in_uf_nascimento IS
  'UF de Nascimento do Aluno';
  
  COMMENT ON COLUMN TBL_ALUNO.alu_in_muni_nascimento IS
  'Municipio de Nascimento do Aluno';
  COMMENT ON COLUMN TBL_ALUNO.alu_st_deficiencia
IS
  'Caso o aluno possua deficiência é obrigatorio informar nesse campo as deficiências.' ;
  COMMENT ON COLUMN TBL_ALUNO.alu_in_canhoto
IS
  '0 - Não, 1 - Sim' ;

  COMMENT ON COLUMN TBL_ALUNO.alu_in_obito
IS
  'Flag para indicar caso o aluno venha a falecer (0 - Não, 1 - Sim) default 0' ;

  COMMENT ON COLUMN TBL_ALUNO.alu_dt_obito
IS
  'Data do óbito quando ocorrido' ;

ALTER TABLE TBL_aluno ADD CONSTRAINT tbl_aluno_PK PRIMARY KEY ( alu_in_id ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 

ALTER TABLE TBL_aluno ADD CONSTRAINT tbl_aluno_UK UNIQUE ( alu_in_cpf ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 


CREATE TABLE TBL_ALUNO_CURSO
  (
    acur_in_id       INTEGER NOT NULL ,
    cur_in_id        INTEGER NOT NULL ,
    alu_in_id        INTEGER NOT NULL ,
	inst_in_respfinan INTEGER NULL,
    acur_dt_ingresso DATE NOT NULL ,
	acur_dt_ultima_matricula DATE NOT NULL,
    acur_dt_colacao  DATE,
    acur_dt_transferencia  DATE,
    acur_dt_emissao_diploma DATE,
	acur_in_situacao INTEGER NOT NULL,
	acur_in_bolsa    INTEGER NOT NULL,
    user_dt_atualiza DATE NOT NULL,
	user_st_atualiza VARCHAR2(30) NOT NULL
   ) 
/

ALTER TABLE TBL_ALUNO_CURSO ADD CONSTRAINT PK_ACUR_IN_ID PRIMARY KEY (ACUR_IN_ID)
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 

ALTER TABLE TBL_aluno_curso ADD CONSTRAINT UK_ACUR_ALUNO_CURSO UNIQUE ( alu_in_id , cur_in_id ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 

CREATE TABLE TBL_ALUNO_CURSO_HISTORICO
  (
    achis_in_id               INTEGER NOT NULL ,
	achis_in_sequencia        INTEGER NOT NULL ,
    disc_in_id                INTEGER NOT NULL ,
    achis_in_falta            INTEGER ,
    achis_nu_aval1            NUMBER (5,2) ,
    achis_nu_aval2            NUMBER (5,2) ,
    achis_nu_media            NUMBER (6,2) ,
    acur_in_id                INTEGER NOT NULL,
	curr_in_id                INTEGER,
	user_st_atualiza          VARCHAR2(30) NOT NULL,
	user_dt_atualiza          DATE  NOT NULL
   ) 
/
  
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.achis_in_id IS 'Identificador Único da linha do histórico do aluno' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.disc_in_id   IS 'Id da Disciplina' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.achis_in_falta IS 'Faltas do Aluno na disciplina' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.achis_nu_aval1 IS 'Nota da Avaliação 1 do Aluno na disciplina' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.achis_nu_aval2 IS 'Nota da Avaliação 2 do Aluno na disciplina' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.achis_nu_media IS 'Nota da Média do Aluno na disciplina' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.achis_in_falta IS 'Faltas do Aluno na disciplina' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.acur_in_id    IS 'ID do Vínculo Aluno X Curso' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.achis_in_sequencia    IS 'Ordem de curso das disciplinas' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.user_st_atualiza IS 'Usuário de Atualização' ;
COMMENT ON COLUMN TBL_ALUNO_CURSO_HISTORICO.user_dt_atualiza IS 'Data de Atualização' ;
  
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD CONSTRAINT aluno_historico_PK PRIMARY KEY ( achis_in_id ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 

CREATE SEQUENCE SQ_ALUNO_CURSO_HISTORICO START WITH 1 NOCACHE ORDER;

CREATE TABLE TBL_calendario
  (
    cale_in_id        INTEGER NOT NULL ,
	cale_in_ano       numeric(4) not null,
    inst_in_id        INTEGER NOT NULL ,
    cale_st_descricao VARCHAR2 (255 BYTE) NOT NULL,
	cale_dt_inicio    DATE  NOT NULL,
	cale_dt_fim       DATE  NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  ) 
/

ALTER TABLE TBL_calendario ADD CONSTRAINT tbl_calendario_PK PRIMARY KEY ( cale_in_ano, cale_in_id ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 

ALTER TABLE TBL_calendario ADD CONSTRAINT tbl_calendario_UK UNIQUE ( cale_in_ano, cale_dt_inicio, cale_dt_fim );
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 

CREATE TABLE TBL_curso
  (
    cur_in_id                INTEGER NOT NULL ,
    inst_in_id               INTEGER NOT NULL ,
    cur_in_emec              NUMBER (12) ,
    cur_in_situacao          INTEGER ,
    cur_in_representado      INTEGER ,
    cur_in_codigo_representa NUMBER (12),
	cur_st_nome              VARCHAR2(60) NOT NULL,
	cur_st_habilitacao       VARCHAR2(60) NULL,
	cur_st_portaria          VARCHAR2(60) NULL,
	cur_st_autorizacao_mec   VARCHAR2(60) NULL,
	cur_dt_autorizacao       DATE,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
    ) 
/

COMMENT ON COLUMN tbl_curso.cur_in_emec
IS
  'Código dotbl_curso no SISTEMA EMEC' ;
  COMMENT ON COLUMN tbl_curso.cur_in_representado
IS
  'Curso representado por outro código detbl_curso no EMEC ( 0 Não Default, 1 Sim)' ;
  COMMENT ON COLUMN tbl_curso.cur_in_codigo_representa
IS
  'Código dotbl_curso EMEC que representa essetbl_curso, somente informar quando o flag cur_in_representado = 1' ;
ALTER TABLE TBL_curso ADD CONSTRAINT tbl_curso_PK PRIMARY KEY ( cur_in_id ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 


CREATE TABLE TBL_curso_turno
  (
    cturn_in_id  INTEGER NOT NULL ,
    cur_in_id    INTEGER NOT NULL ,
    turn_in_id   INTEGER NOT NULL ,
    in_vaga_nova INTEGER  DEFAULT 0 NOT NULL,
    in_vaga_reman INTEGER  DEFAULT 0 NOT NULL,
    in_vaga_progesp         INTEGER DEFAULT 0  NOT NULL ,
    in_prazo_minimo_integra NUMBER (4) DEFAULT 320,
    in_prazo_maximo_integra NUMBER (5),
    in_inscrito_nova        INTEGER DEFAULT 0  NOT NULL ,
    in_inscrito_reman       INTEGER DEFAULT 0  NOT NULL ,
    in_inscrito_progesp     INTEGER DEFAULT 0  NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL 
    ) 
/

COMMENT ON COLUMN tbl_curso_turno.in_vaga_nova
IS
  'Número de vagas novas notbl_curso/turno.' ;
  COMMENT ON COLUMN tbl_curso_turno.in_vaga_reman
IS
  'Número de vagas remanescentes notbl_curso/turno.' ;
  COMMENT ON COLUMN tbl_curso_turno.in_vaga_progesp
IS
  'Número de Vagas Oferecidas em Programas Especiais.' ;
  COMMENT ON COLUMN tbl_curso_turno.in_inscrito_nova
IS
  'Total de Inscritos notbl_curso/Turno (Calculado) para Vagas Novas' ;
  COMMENT ON COLUMN tbl_curso_turno.in_inscrito_reman
IS
  'Total de Inscritos notbl_curso/Turno (Calculado) para Vagas Remanescentes' ;
  COMMENT ON COLUMN tbl_curso_turno.in_inscrito_progesp
IS
  'Total de Inscritos notbl_curso/Turno (Calculado) para Vagas de Programas Especiais' ;

ALTER TABLE TBL_CURSO_TURNO ADD CONSTRAINT Pk_cturn_IN_ID PRIMARY KEY ( cturn_in_id ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 


ALTER TABLE TBL_CURSO_TURNO ADD CONSTRAINT uk_cturn_cur_turn UNIQUE ( cur_in_id, turn_in_id ) 
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT); 


CREATE TABLE TBL_disciplina
  ( disc_in_id INTEGER NOT NULL,
    disc_st_nome          VARCHAR2 (255 CHAR) NOT NULL ,
    disc_in_carga_horaria INTEGER NOT NULL ,
    dis_in_tipo           INTEGER,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  ) 
/

COMMENT ON COLUMN TBL_DISCIPLINA.disc_in_id
IS
  'Identificador Único da Disciplina' ;
COMMENT ON COLUMN TBL_DISCIPLINA.disc_in_id
IS
  'Identificador Único da Disciplina' ;
  COMMENT ON COLUMN TBL_DISCIPLINA.disc_st_nome
IS
  'Nome da Disciplina' ;
  COMMENT ON COLUMN TBL_DISCIPLINA.disc_in_carga_horaria
IS
  'Carga Horária da Disciplina' ;
  COMMENT ON COLUMN TBL_DISCIPLINA.dis_in_tipo
IS
  'Tipo da Disciplina (Referência).' ;
ALTER TABLE TBL_DISCIPLINA ADD CONSTRAINT disciplina_PK PRIMARY KEY ( disc_in_id ) 
 / 



CREATE TABLE TBL_DISCIPLINA_prereq
  (
    dpre_in_id         INTEGER NOT NULL ,
    dpre_dis_in_id     INTEGER NOT NULL ,
    dpre_st_observacao VARCHAR2 (2000 CHAR) ,
    disc_in_id         INTEGER NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
    )
  pctfree 10
  initrans 1
  maxtrans 255
/
ALTER TABLE TBL_disciplina_PREREQ ADD CONSTRAINT discPREREQ_PK PRIMARY KEY ( dpre_in_id ) 
 / 


CREATE TABLE TBL_docente
  (
    doce_in_id                INTEGER NOT NULL ,
	doce_in_matricula         INTEGER ,
    doce_st_nome              VARCHAR2 (255 CHAR) NOT NULL ,
    doce_in_cpf               NUMBER (11) NOT NULL ,
    doce_st_docestrangeiro    VARCHAR2 (20 CHAR) ,
    doce_dt_nascimento        DATE NOT NULL ,
    doce_in_sexo              INTEGER NOT NULL ,
    doce_in_cor_raca          INTEGER NOT NULL ,
    doce_st_nome_mae          VARCHAR2 (120 CHAR) ,
    doce_in_nacionalidade     INTEGER NOT NULL ,
    doce_in_pais_origem       INTEGER NOT NULL ,
    doce_in_uf_nascimento     INTEGER ,
    doce_in_muni_nascimento   INTEGER ,
    doce_in_deficiente        INTEGER NOT NULL ,
    doce_st_deficiencia       VARCHAR2 (255 CHAR) ,
    doce_in_escolaridade      INTEGER NOT NULL ,
    doce_in_situacao          INTEGER NOT NULL ,
    doce_in_exercicio3112     INTEGER ,
    doce_in_regime            INTEGER NOT NULL ,
    doce_in_substituto        INTEGER NOT NULL ,
    doce_in_vinculo_visitante INTEGER ,
    doce_in_atuacao           INTEGER,
	doce_in_bolsa_pesquisa	  INTEGER,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
   )
  pctfree 10
  initrans 1
  maxtrans 255
/

COMMENT ON COLUMN tbl_docente.doce_dt_nascimento
IS
  'Data de Nascimento do Docente' ;
  COMMENT ON COLUMN tbl_docente.doce_in_sexo
IS
  '0 - Masculino ; 1 - Feminino' ;
  COMMENT ON COLUMN tbl_docente.doce_in_cor_raca
IS
  'Código de Cor ou Raça para o CENSO.' ;
  COMMENT ON COLUMN tbl_docente.doce_in_pais_origem
IS
  'Referencia da tabela de Países (País de Nascimento do Docente)' ;
  COMMENT ON COLUMN tbl_docente.doce_in_uf_nascimento
IS
  'Identificador da UF de nascimento do docente' ;
  COMMENT ON COLUMN tbl_docente.doce_in_muni_nascimento
IS
  'Identificador do Municipio de nascimento do tbl_docente.' ;
  COMMENT ON COLUMN tbl_docente.doce_in_deficiente
IS
  'Flag de Identificação caso o docente possua deficiência.' ;
  COMMENT ON COLUMN tbl_docente.doce_st_deficiencia
IS
  'Caso o docente tenha deficiências, essas deficiências serão relacionadas nesse campo.' ;
  COMMENT ON COLUMN tbl_docente.doce_in_escolaridade
IS
  'Escolaridade do Docente' ;
  COMMENT ON COLUMN tbl_docente.doce_in_situacao
IS
  'Informa a situação do docente na Instituição.' ;
  COMMENT ON COLUMN tbl_docente.doce_in_regime
IS
  'Regime de trabalho' ;
  COMMENT ON COLUMN tbl_docente.doce_in_substituto
IS
  'Docente Substituo 1=Sim 0=Não' ;
  
ALTER TABLE TBL_docente ADD CONSTRAINT docente_PK PRIMARY KEY ( doce_in_id ) 
/ 


CREATE TABLE TBL_docente_curso
  (
    DCUR_IN_ID INTEGER NOT NULL ,
    doce_in_id INTEGER NOT NULL ,
    cur_in_id  INTEGER NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

ALTER TABLE TBL_docente_curso ADD CONSTRAINT PK_DCUR_IN_ID PRIMARY KEY ( Dcur_in_id ) 
/ 

ALTER TABLE TBL_docente_curso ADD CONSTRAINT UK_DCUR_DOCE_CUR UNIQUE ( DOCE_IN_ID, cur_in_id ) 
 / 


CREATE TABLE TBL_docente_disciplina
  (
    DDISC_IN_ID INTEGER NOT NULL ,
    doce_in_id INTEGER NOT NULL ,
    disc_in_id INTEGER NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/


  ALTER TABLE TBL_docente_disciplina ADD CONSTRAINT PK_DDISC_IN_ID PRIMARY KEY ( DDISC_IN_ID ) 
 / 

  ALTER TABLE TBL_docente_disciplina ADD CONSTRAINT UK_DOCE_DISC UNIQUE ( doce_in_id, disc_in_id ) 
 / 


CREATE TABLE TBL_GRADE
  (
    GRD_IN_ID         INTEGER NOT NULL ,
    cur_in_id         INTEGER NOT NULL ,
    tur_in_id         INTEGER NOT NULL ,
    disc_in_id        INTEGER NOT NULL ,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

ALTER TABLE TBL_GRADE ADD CONSTRAINT PK_GRADE PRIMARY KEY ( GRD_IN_ID ) 
 / 


CREATE TABLE TBL_historico_afastamento
  (
    hafas_dt_inicio DATE NOT NULL ,
    hafas_dt_fim    DATE ,
    hafas_st_justificativa CLOB ,
    doce_in_id  INTEGER NOT NULL ,
    hafas_in_id INTEGER NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

COMMENT ON COLUMN tbl_historico_afastamento.hafas_dt_fim
IS
  'Data de Fim do Afastamento' ;
  COMMENT ON COLUMN tbl_historico_afastamento.hafas_st_justificativa
IS
  'Justificativa para o afastamento.' ;
ALTER TABLE TBL_historico_afastamento ADD CONSTRAINT historico_afastamento_PK PRIMARY KEY ( hafas_in_id ) 
 / 


CREATE TABLE TBL_municipio
  (
    muni_in_codigo_censo INTEGER NOT NULL ,
    muni_st_nome         VARCHAR2 (255 CHAR) NOT NULL ,
    uf_in_codigo_censo   INTEGER NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

ALTER TABLE TBL_municipio ADD CONSTRAINT municipio_PK PRIMARY KEY ( muni_in_codigo_censo ) 
 / 


CREATE TABLE TBL_pais
  (
    pais_in_id           INTEGER NOT NULL ,
    pais_st_codigo_censo CHAR (3 CHAR) NOT NULL ,
    pais_st_nome         VARCHAR2 (255) ,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

COMMENT ON COLUMN tbl_pais.pais_st_codigo_censo
IS
  'Código do País no CENSO' ;
ALTER TABLE TBL_pais ADD CONSTRAINT pais_PK PRIMARY KEY ( pais_in_id ) 
 / 


CREATE TABLE TBL_periodo
  (
    peri_in_id         INTEGER NOT NULL ,
    peri_in_periodicidade INTEGER ,
    peri_dt_inicio     DATE ,
    peri_dt_fim        DATE,
	peri_st_nome       VARCHAR2(50) NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
   )
  pctfree 10
  initrans 1
  maxtrans 255
/

COMMENT ON COLUMN tbl_periodo.peri_in_id
IS
  'Identificador único do período.' ;
  COMMENT ON COLUMN tbl_periodo.peri_in_periodicidade
IS
  '1 ) Dia 2 ) Semana 3 ) Quinzena 4 ) Mes 5 ) Bimestre 6 ) Trimestre 7 ) Semestre 8 ) Ano' ;
ALTER TABLE TBL_periodo ADD CONSTRAINT periodo_PK PRIMARY KEY ( peri_in_id ) 
 / 


CREATE TABLE TBL_referencia
  (
    REFE_IN_ID        INTEGER NOT NULL ,
    REFE_ST_TIPO        VARCHAR2 (255 CHAR) ,
    REFE_IN_CODIGO      INTEGER NOT NULL ,
    REFE_ST_DESCRICAO       VARCHAR2 (255 CHAR) NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
   )
  pctfree 10
  initrans 1
  maxtrans 255
/

COMMENT ON COLUMN tbl_referencia.refe_in_id
IS
  'Id Interno da Referência.' ;
  COMMENT ON COLUMN tbl_referencia.refe_in_codigo
IS
  'Identificador do código da referencia.' ;
  COMMENT ON COLUMN tbl_referencia.refe_st_descricao
IS
  'Descrição da referencia.' ;
  COMMENT ON COLUMN tbl_referencia.refe_st_tipo
IS
  'Descrição do Tipo da referencia.' ;
  COMMENT ON COLUMN tbl_referencia.user_dt_atualiza
IS
  'Data do Sistema em que se fez a ultima atualização.' ;

  
ALTER TABLE TBL_referencia ADD CONSTRAINT referencia_PK PRIMARY KEY ( refe_in_id ) 
 / 



CREATE TABLE TBL_TURMA
  (
    peri_in_id      INTEGER NOT NULL ,
    tur_in_id       INTEGER NOT NULL ,
    cur_in_id       INTEGER NOT NULL ,
    turn_in_id      INTEGER NOT NULL ,
	tur_st_codigo   VARCHAR2(20) NOT NULL,
	tur_st_descricao VARCHAR2(50) , 
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  ) ;
COMMENT ON COLUMN TBL_TURMA.tur_in_id
IS
  'Identificador Único do Turno.' ;
ALTER TABLE TBL_turma ADD CONSTRAINT turma_PK PRIMARY KEY ( tur_in_id ) 
 / 


CREATE TABLE TBL_turno
  (
    turn_in_id         INTEGER NOT NULL ,
    turn_st_descricao  VARCHAR2 (255 CHAR) NOT NULL ,
    turn_in_modalidade INTEGER NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

COMMENT ON COLUMN TBL_TURNO.turn_st_descricao
IS
  'Descrição do Turno' ;
  COMMENT ON COLUMN tbl_turno.turn_in_modalidade
IS
  'Modalidade 1 = Presencial, 2 = a Distância.' ;
ALTER TABLE TBL_turno ADD CONSTRAINT turno_PK PRIMARY KEY ( turn_in_id ) 
 / 


CREATE TABLE TBL_ANEXO
  (ANEX_IN_ID INTEGER NOT NULL,
   ANEX_ST_NOME_IMAGEM VARCHAR2(255) NOT NULL,
   ANEX_ST_NOME_ARQUIVO VARCHAR2(255) NULL,
   ANEX_ST_MIME_TYPE VARCHAR2(255) NULL,
   USER_ST_ATUALIZA  VARCHAR2(30) NOT NULL,
   USER_DT_ATUALIZA  DATE,
   ANEX_BL_CONTEUDO  BLOB,
   ANEX_NU_TAMANHO   NUMBER NOT NULL
  )
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE
  ( INITIAL 64K
    NEXT 128K
	MINEXTENTS 1
	MAXEXTENTS UNLIMITED
  );
  
ALTER TABLE TBL_ANEXO ADD CONSTRAINT PK_ANEX PRIMARY KEY (ANEX_IN_ID)
 / 

  
CREATE TABLE TBL_ALUNO_ANEXO
  ( ALU_IN_ID  INTEGER,
    ANEX_IN_ID INTEGER,
	USER_ST_ATUALIZA VARCHAR2(30) NOT NULL,
	USER_DT_ATUALIZA DATE NOT NULL)
  pctfree 10
  initrans 1
  maxtrans 255 
/

CREATE TABLE TBL_DOCENTE_ANEXO
  ( DOCE_IN_ID INTEGER,
    ANEX_IN_ID INTEGER,
	USER_ST_ATUALIZA VARCHAR2(30) NOT NULL,
	USER_DT_ATUALIZA DATE NOT NULL)
  pctfree 10
  initrans 1
  maxtrans 255
/

CREATE TABLE TBL_DISCIPLINA_ANEXO
  ( DISC_IN_ID INTEGER,
    ANEX_IN_ID INTEGER,
	USER_ST_ATUALIZA VARCHAR2(30) NOT NULL,
	USER_DT_ATUALIZA DATE NOT NULL)
  pctfree 10
  initrans 1
  maxtrans 255
/

  CREATE TABLE TBL_uf
  (
    uf_in_codigo_censo INTEGER NOT NULL ,
    uf_st_nome         VARCHAR2 (255 CHAR) ,
    uf_st_sigla         VARCHAR2 (2 CHAR) ,
    pais_in_id         INTEGER NOT NULL,
	user_st_atualiza         VARCHAR2(30) NOT NULL,
	user_dt_atualiza         DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

COMMENT ON COLUMN TBL_uf.uf_st_nome
IS
  'Nome da Unidade da Federação (UF).' ;
ALTER TABLE TBL_uf ADD CONSTRAINT uf_PK PRIMARY KEY ( uf_in_codigo_censo ) 
 / 

/*  
  ALTER TABLE TBL_ALUNO_ANEXO DROP CONSTRAINT FK_ALUNO_ANEXO_ANEXO;
  ALTER TABLE TBL_ALUNO_ANEXO DROP CONSTRAINT FK_ALUNO_ANEXO_ALUNO;
  ALTER TABLE TBL_DOCENTE_ANEXO DROP CONSTRAINT FK_DOCENTE_ANEXO_ANEXO;
  ALTER TABLE TBL_DOCENTE_ANEXO DROP CONSTRAINT FK_DOCENTE_ANEXO_DOCENTE;
 */
 
ALTER TABLE TBL_ALUNO_ANEXO      ADD CONSTRAINT FK_ALUNO_ANEXO_ANEXO           FOREIGN KEY (ANEX_IN_ID) REFERENCES TBL_ANEXO on delete cascade;
ALTER TABLE TBL_ALUNO_ANEXO      ADD CONSTRAINT FK_ALUNO_ANEXO_ALUNO           FOREIGN KEY (ALU_IN_ID)  REFERENCES TBL_ALUNO  on delete cascade;
ALTER TABLE TBL_DOCENTE_ANEXO    ADD CONSTRAINT FK_DOCENTE_ANEXO_ANEXO         FOREIGN KEY (ANEX_IN_ID) REFERENCES TBL_ANEXO on delete cascade;
ALTER TABLE TBL_DOCENTE_ANEXO    ADD CONSTRAINT FK_DOCENTE_ANEXO_DOCENTE       FOREIGN KEY (DOCE_IN_ID) REFERENCES TBL_DOCENTE on delete cascade;
ALTER TABLE TBL_DISCIPLINA_ANEXO ADD CONSTRAINT FK_DISCIPLINA_ANEXO_ANEXO      FOREIGN KEY (ANEX_IN_ID) REFERENCES TBL_ANEXO on delete cascade;
ALTER TABLE TBL_DISCIPLINA_ANEXO ADD CONSTRAINT FK_DISCIPLINA_ANEXO_DISCIPLINA FOREIGN KEY (DISC_IN_ID) REFERENCES TBL_DISCIPLINA on delete cascade;

ALTER TABLE TBL_INSTITUICAO ADD CONSTRAINT UK_CODIGO_IES UNIQUE (INST_IN_CODIGO_IES)
 TABLESPACE "TS_INDX" 
ENABLE;

ALTER TABLE TBL_turma ADD CONSTRAINT fk_turma_periodo FOREIGN KEY ( peri_in_id ) REFERENCES TBL_periodo ( peri_in_id ) ;
ALTER TABLE TBL_uf ADD CONSTRAINT fk_uf_pais FOREIGN KEY ( pais_in_id ) REFERENCES TBL_pais ( pais_in_id ) ;
ALTER TABLE TBL_municipio ADD CONSTRAINT fk_municipio_uf_codigo_censo FOREIGN KEY ( uf_in_codigo_censo ) REFERENCES TBL_uf ( uf_in_codigo_censo ) ;
ALTER TABLE TBL_historico_afastamento ADD CONSTRAINT fk_histafas_docente FOREIGN KEY ( doce_in_id ) REFERENCES TBL_docente ( doce_in_id ) ;
ALTER TABLE TBL_docente_disciplina ADD CONSTRAINT fk_docdis_docente FOREIGN KEY ( doce_in_id ) REFERENCES TBL_docente ( doce_in_id ) ;
ALTER TABLE TBL_docente_disciplina ADD CONSTRAINT fk_docdis_disciplina FOREIGN KEY ( disc_in_id ) REFERENCES TBL_disciplina ( disc_in_id ) ;
ALTER TABLE TBL_curso_turno ADD CONSTRAINT fk_curso_turno_curso FOREIGN KEY ( cur_in_id ) REFERENCES tbl_curso ( cur_in_id ) ;
ALTER TABLE TBL_turma ADD CONSTRAINT fk_turma_curso_turno FOREIGN KEY ( cur_in_id, turn_in_id ) REFERENCES tbl_curso_turno ( cur_in_id, turn_in_id ) ;
ALTER TABLE TBL_aluno_curso ADD CONSTRAINT fk_acur_aluno FOREIGN KEY ( alu_in_id ) REFERENCES TBL_aluno ( alu_in_id ) ;
ALTER TABLE TBL_aluno_curso ADD CONSTRAINT fk_acur_curso FOREIGN KEY ( cur_in_id ) REFERENCES tbl_curso ( cur_in_id ) ;
ALTER TABLE TBL_calendario ADD CONSTRAINT fk_calen_inst FOREIGN KEY ( inst_in_id ) REFERENCES TBL_instituicao ( inst_in_id ) ;
ALTER TABLE TBL_curso ADD CONSTRAINT fk_cur_inst FOREIGN KEY ( inst_in_id ) REFERENCES TBL_instituicao ( inst_in_id ) ;
ALTER TABLE TBL_curso_turno ADD CONSTRAINT fk_curso_turno_turno FOREIGN KEY ( turn_in_id ) REFERENCES TBL_turno ( turn_in_id ) ;
ALTER TABLE TBL_docente_curso ADD CONSTRAINT fk_docurso_docente FOREIGN KEY ( doce_in_id ) REFERENCES TBL_docente ( doce_in_id ) ;
ALTER TABLE TBL_grade ADD CONSTRAINT fk_tbl_grade_turma FOREIGN KEY ( tur_in_id ) REFERENCES TBL_turma ( tur_in_id ) ;
ALTER TABLE TBL_Instituicao ADD CONSTRAINT fk_inst_inst FOREIGN KEY ( inst_in_id_pai ) REFERENCES TBL_instituicao ( inst_in_id ) ;
ALTER TABLE TBL_turma ADD CONSTRAINT tur_cur_FK FOREIGN KEY ( cur_in_id ) REFERENCES tbl_curso ( cur_in_id ) ;
ALTER TABLE TBL_turma ADD CONSTRAINT tur_turn_FK FOREIGN KEY ( turn_in_id ) REFERENCES TBL_turno ( turn_in_id ) ;
ALTER TABLE TBL_ALUNO_CURSO ADD CONSTRAINT fk_acur_inst_respfinan FOREIGN KEY (INST_IN_RESPFINAN) REFERENCES TBL_instituicao (INST_IN_ID);
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD CONSTRAINT fk_achis_acur FOREIGN KEY (acur_in_id) references TBL_ALUNO_CURSO;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD CONSTRAINT fk_achis_disc FOREIGN KEY (disc_in_id) references TBL_DISCIPLINA;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD PERI_IN_ID INTEGER NOT NULL;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD CONSTRAINT FK_ACHIS_PERI FOREIGN KEY (PERI_IN_ID) references TBL_PERIODO;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD CONSTRAINT FK_ACHIS_CURR FOREIGN KEY (CURR_IN_ID) references TBL_CURRICULO;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD ACHIS_IN_SITUACAO INTEGER NOT NULL;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD ACHIS_NU_CHTEORICA_CUMPRIDA NUMBER(10,2) NULL;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD ACHIS_NU_CHPRATICA_CUMPRIDA NUMBER(10,2) NULL;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD ACHIS_NU_AVAL3 NUMBER(5,2) NULL;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD ACHIS_NU_AVAL4 NUMBER(5,2) NULL;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD ACHIS_NU_AVAL5 NUMBER(5,2) NULL;
ALTER TABLE TBL_ALUNO_CURSO_HISTORICO ADD ACHIS_NU_AVAL6 NUMBER(5,2) NULL;



-- drop sequence sq_pais;
CREATE SEQUENCE SQ_PAIS START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_PAIS BEFORE
  INSERT ON TBL_pais FOR EACH ROW WHEN (NEW.pais_IN_ID IS NULL) BEGIN :NEW.pais_IN_ID := SQ_PAIS.NEXTVAL;
END;
/

-- drop sequence SQ_INSTITUICAO;
CREATE SEQUENCE SQ_INSTITUICAO START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_INSTITUICAO BEFORE
  INSERT ON TBL_INSTITUICAO FOR EACH ROW WHEN (NEW.INST_IN_ID IS NULL) BEGIN :NEW.INST_IN_ID := SQ_INSTITUICAO.NEXTVAL;
END;
/

-- drop sequence SQ_ALUNO;
CREATE SEQUENCE SQ_ALUNO START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_ALUNO BEFORE
  INSERT ON TBL_ALUNO FOR EACH ROW WHEN (NEW.ALU_IN_ID IS NULL) BEGIN :NEW.ALU_IN_ID := SQ_ALUNO.NEXTVAL;
END;
/

-- drop sequence SQ_ALUNO_HISTORICO;
CREATE SEQUENCE SQ_ALUNO_CURSO_HISTORICO START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_ALUNO_CURSO_HISTORICO BEFORE
  INSERT OR UPDATE ON TBL_ALUNO_CURSO_HISTORICO FOR EACH ROW 
DECLARE
  CURSOR C_GERA_SQ_DISCIPLINA(P_ACUR_IN_ID INTEGER, P_PERI_IN_ID INTEGER) IS
    SELECT NVL(ACHIS_IN_SEQUENCIA,0)
	  FROM TBL_ALUNO_CURSO_HISTORICO
	 WHERE ACUR_IN_ID = P_ACUR_IN_ID
	   AND PERI_IN_ID = P_PERI_IN_ID
	 ORDER BY ACHIS_IN_SEQUENCIA DESC;
BEGIN
  IF INSERTING THEN 
    -- ID
	:NEW.ACHIS_IN_ID := SQ_ALUNO_CURSO_HISTORICO.NEXTVAL;
	-- SEQUENCIA
	OPEN C_GERA_SQ_DISCIPLINA(:NEW.ACUR_IN_ID, :NEW.PERI_IN_ID);
	FETCH C_GERA_SQ_DISCIPLINA INTO :NEW.ACHIS_IN_SEQUENCIA;
	IF C_GERA_SQ_DISCIPLINA%FOUND THEN
		:NEW.ACHIS_IN_SEQUENCIA := NVL(:NEW.ACHIS_IN_SEQUENCIA,0)+1;
	ELSE
	    :NEW.ACHIS_IN_SEQUENCIA := 1;
	END IF;
	CLOSE C_GERA_SQ_DISCIPLINA;
	
  END IF;
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA, :NEW.USER_DT_ATUALIZA);

END;
/

CREATE FUNCTION FC_GET_CURRICULO(P_ID_TUR INTEGER) RETURN INTEGER IS
W_CURR_IN_ID TBL_CURRICULO.CURR_IN_ID%TYPE;
BEGIN
  SELECT CURR_IN_ID INTO W_CURR_IN_ID
    FROM TBL_TURMA 
   WHERE TUR_IN_ID = P_ID_TUR;
  RETURN W_CURR_IN_ID;
END;

-- drop sequence SQ_CALENDARIO;
CREATE SEQUENCE SQ_CALENDARIO START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_CALENDARIO BEFORE
  INSERT ON TBL_CALENDARIO FOR EACH ROW WHEN (NEW.CALE_IN_ID IS NULL) BEGIN :NEW.CALE_IN_ID := SQ_CALENDARIO.NEXTVAL;
END;
/

-- drop sequence SQ_CURSO;
CREATE SEQUENCE SQ_CURSO START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_CURSO BEFORE
  INSERT ON TBL_CURSO FOR EACH ROW WHEN (NEW.CUR_IN_ID IS NULL) BEGIN :NEW.CUR_IN_ID := SQ_CURSO.NEXTVAL;
END;
/

-- drop sequence SQ_DISCIPLINA;
CREATE SEQUENCE SQ_DISCIPLINA START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_DISCIPLINA BEFORE
  INSERT ON TBL_DISCIPLINA FOR EACH ROW WHEN (NEW.DISC_IN_ID IS NULL) BEGIN :NEW.DISC_IN_ID := SQ_DISCIPLINA.NEXTVAL;
END;
/

-- drop sequence SQ_DISCIPLINA_PREREQ;
CREATE SEQUENCE SQ_DISCIPLINA_PREREQ START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_DISCIPLINA_PREREQ BEFORE
  INSERT ON TBL_DISCIPLINA_PREREQ FOR EACH ROW WHEN (NEW.DPRE_IN_ID IS NULL) BEGIN :NEW.DPRE_IN_ID := SQ_DISCIPLINA_PREREQ.NEXTVAL;
END;
/

-- drop sequence SQ_DOCENTE;
CREATE SEQUENCE SQ_DOCENTE START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_DOCENTE BEFORE
  INSERT ON TBL_DOCENTE FOR EACH ROW WHEN (NEW.DOCE_IN_ID IS NULL) BEGIN :NEW.DOCE_IN_ID := SQ_DOCENTE.NEXTVAL;
END;
/

-- drop sequence SQ_CURSO_DOCENTE;
CREATE SEQUENCE SQ_CURSO_DOCENTE START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_CURSO_DOCENTE BEFORE
  INSERT ON TBL_DOCENTE_CURSO FOR EACH ROW WHEN (NEW.DCUR_IN_ID IS NULL) BEGIN :NEW.DCUR_IN_ID := SQ_CURSO_DOCENTE.NEXTVAL;
END;
/

-- drop sequence SQ_HISTORICO_AFASTAMENTO;
CREATE SEQUENCE SQ_HISTORICO_AFASTAMENTO START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_HISTORICO_AFASTAMENTO BEFORE
  INSERT ON TBL_HISTORICO_AFASTAMENTO FOR EACH ROW WHEN (NEW.HAFAS_IN_ID IS NULL) BEGIN :NEW.HAFAS_IN_ID := SQ_HISTORICO_AFASTAMENTO.NEXTVAL;
END;
/

-- drop sequence SQ_PERIODO;
CREATE SEQUENCE SQ_PERIODO START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_PERIODO BEFORE
  INSERT ON TBL_PERIODO FOR EACH ROW WHEN (NEW.PERI_IN_ID IS NULL) BEGIN :NEW.PERI_IN_ID := SQ_PERIODO.NEXTVAL;
END;
/

-- drop sequence SQ_REFERENCIA;
CREATE SEQUENCE SQ_REFERENCIA START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER TRG_BI_REFERENCIA BEFORE
  INSERT ON TBL_REFERENCIA FOR EACH ROW WHEN (NEW.REFE_IN_ID IS NULL) BEGIN :NEW.REFE_IN_ID := SQ_REFERENCIA.NEXTVAL;
END;
/

-- drop sequence SQ_TURMA;
CREATE SEQUENCE SQ_TURMA START WITH 1 NOCACHE ORDER ;

-- drop sequence SQ_TURNO;
CREATE SEQUENCE SQ_TURNO START WITH 1 NOCACHE ORDER ;
CREATE SEQUENCE SQ_ANEXO START WITH 1 NOCACHE ORDER ;
CREATE SEQUENCE SQ_DOCENTE_DISCIPLINA START WITH 1 NOCACHE ORDER ;
CREATE SEQUENCE SQ_CURSO_ALUNO START WITH 1 NOCACHE ORDER ;
CREATE SEQUENCE SQ_CURSO_TURNO START WITH 1 NOCACHE ORDER ;
CREATE SEQUENCE SQ_GRADE START WITH 1 NOCACHE ORDER ;
CREATE SEQUENCE SQ_CURRICULO START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER TRG_BI_TURNO BEFORE
  INSERT ON TBL_TURNO FOR EACH ROW WHEN (NEW.TURN_IN_ID IS NULL) BEGIN :NEW.TURN_IN_ID := SQ_TURNO.NEXTVAL;
END;
/


CREATE OR REPLACE PROCEDURE PC_ATUALIZA_USUARIO(P_NEW_ST_USER IN OUT VARCHAR2, P_NEW_DT_USER IN OUT DATE) IS
BEGIN
  P_NEW_ST_USER := NVL(HTMLDB_UTIL.GET_USERNAME(HTMLDB_UTIL.GET_CURRENT_USER_ID),USER);
  P_NEW_DT_USER := SYSDATE;
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BI_TURMA BEFORE
  INSERT ON TBL_TURMA FOR EACH ROW 
BEGIN 
  :NEW.TUR_IN_ID := SQ_TURMA.NEXTVAL;
  :NEW.ANO_IN_ID := TO_NUMBER(TO_CHAR(:NEW.TUR_DT_INICIO,'YYYY'));
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA, :NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE FUNCTION FC_VALIDA_CNPJ(pi_st_cnpj varchar2) RETURN varchar2 IS
/* FUNÇÃO PARA VALIDAR O CNPJ
   AUTOR: SILAS SILVA
   DATA: 21/02/2017
*/
W_CNPJ_ST_GERADO    VARCHAR2(14);
W_CNPJ_ST_INFORMADO VARCHAR2(14) := LPAD(replace(replace(pi_st_cnpj,'/',''),'.',''),14,'0');
BEGIN
IF W_CNPJ_ST_INFORMADO  IN ('00000000000000','11111111111111','22222222222222','33333333333333','44444444444444','55555555555555',
                            '66666666666666','77777777777777','88888888888888','99999999999999') THEN
							RAISE_APPLICATION_ERROR(-20022,'CNPJ Informado Inválido');
end if;
SELECT TO_CHAR(nu_cnpj || nu_dv1 || nu_dv2) cnpj 
    into W_CNPJ_ST_GERADO
    FROM (SELECT decode(resto2, 0, 0, 1, 0, (11 - resto2)) nu_dv2, nu_dv1, nu_cnpj 
            FROM (SELECT MOD((substr(nu_cnpj || nu_dv1, 1 , 1) * 6) + (substr(nu_cnpj || nu_dv1, 2 , 1) * 5) + 
                             (substr(nu_cnpj || nu_dv1, 3 , 1) * 4) + (substr(nu_cnpj || nu_dv1, 4 , 1) * 3) + 
                             (substr(nu_cnpj || nu_dv1, 5 , 1) * 2) + (substr(nu_cnpj || nu_dv1, 6 , 1) * 9) + 
                             (substr(nu_cnpj || nu_dv1, 7 , 1) * 8 ) + (substr(nu_cnpj || nu_dv1, 8 , 1) * 7) + 
                             (substr(nu_cnpj || nu_dv1, 9 , 1) * 6) + (substr(nu_cnpj || nu_dv1, 10, 1) * 5) + 
                             (substr(nu_cnpj || nu_dv1, 11, 1) * 4) + (substr(nu_cnpj || nu_dv1, 12, 1) * 3) +
                             (nu_dv1 * 2), 11) resto2, nu_dv1, nu_cnpj                           
                        FROM (SELECT decode(resto1, 0, 0, 1, 0, (11 - resto1)) nu_dv1, nu_cnpj
                                FROM (SELECT MOD((substr(nu_cnpj, 1 , 1) * 5) + (substr(nu_cnpj, 2 , 1) * 4) + 
                                                 (substr(nu_cnpj, 3 , 1) * 3) + (substr(nu_cnpj, 4 , 1) * 2) + 
                                                 (substr(nu_cnpj, 5 , 1) * 9) + (substr(nu_cnpj, 6 , 1) * 8 ) + 
                                                 (substr(nu_cnpj, 7 , 1) * 7) + (substr(nu_cnpj, 8 , 1) * 6) + 
                                                 (substr(nu_cnpj, 9 , 1) * 5) + (substr(nu_cnpj, 10, 1) * 4) + 
                                                 (substr(nu_cnpj, 11, 1) * 3) + (substr(nu_cnpj, 12, 1) * 2), 11) resto1, nu_cnpj 
                                        FROM (SELECT lpad(W_CNPJ_ST_INFORMADO, 12, '0') nu_cnpj FROM dual))))); 

RETURN W_CNPJ_ST_GERADO;
EXCEPTION
WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20022,'CNPJ Informado Inválido'); return null;
END;
/

show errors;

CREATE OR REPLACE FUNCTION FC_MASCARA_CNPJ(PI_ST_CNPJ VARCHAR2) RETURN VARCHAR2 IS
/* FUNÇÃO PARA MASCARAR O CNPJ
   AUTOR: SILAS SILVA
   DATA: 21/02/2017
*/
W_CNPJ_ST_FORMATADO VARCHAR2(18);
w_sqlcode           number;
w_sqlerrm           varchar2(255);
BEGIN
   W_CNPJ_ST_FORMATADO := LPAD(TO_CHAR(PI_ST_CNPJ),14,'0');
   W_CNPJ_ST_FORMATADO := SUBSTR(W_CNPJ_ST_FORMATADO,1,2)||'.'||SUBSTR(W_CNPJ_ST_FORMATADO,3,3)|| '.' ||
                            SUBSTR(W_CNPJ_ST_FORMATADO,6,3)||'/'||SUBSTR(W_CNPJ_ST_FORMATADO,9,4)|| '-' ||
							SUBSTR(W_CNPJ_ST_FORMATADO,13,2);
                          
RETURN W_CNPJ_ST_FORMATADO;
EXCEPTION
WHEN INVALID_NUMBER THEN
    w_sqlcode := sqlcode;
	w_sqlerrm := sqlerrm;
    w_sqlerrm := w_sqlcode || ' - ' || w_sqlerrm;
	RAISE_APPLICATION_ERROR(-20020,w_sqlerrm);
	return null;
WHEN OTHERS THEN
    w_sqlcode := sqlcode;
	w_sqlerrm := sqlerrm;
    w_sqlerrm := w_sqlcode || ' - ' || w_sqlerrm;
	RAISE_APPLICATION_ERROR(-20021,w_sqlerrm);
	return null;
END;
/

show errors;

CREATE OR REPLACE FUNCTION FC_VALIDA_DATA_NASCIMENTO(pi_dt_nascimento date, pi_in_anos integer) RETURN INTEGER IS
	w_dt_nascini date;
BEGIN
	w_dt_nascini := add_months(sysdate,(12*pi_in_anos)*-1);
	dbms_output.put_line('Data informada:'||to_char(pi_dt_nascimento,'dd/mm/yyyy'));
	dbms_output.put_line('Data Calculada:'||to_char(w_dt_nascini,'dd/mm/yyyy'));
	
	if pi_dt_nascimento <= w_dt_nascini then return 1;
	else return 0;
	end if;
END;
/

show errors;

CREATE OR REPLACE FUNCTION FC_MASCARA_CPF(PI_ST_CPF VARCHAR2) RETURN VARCHAR2 IS
/* FUNÇÃO PARA MASCARAR O CNPJ
   AUTOR: SILAS SILVA
   DATA: 21/02/2017
*/
W_CPF_ST_FORMATADO VARCHAR2(14);
w_sqlcode           number;
w_sqlerrm           varchar2(255);
BEGIN
   W_CPF_ST_FORMATADO := LPAD(TO_CHAR(PI_ST_CPF),11,'0');
   W_CPF_ST_FORMATADO := SUBSTR(W_CPF_ST_FORMATADO,1,3)||'.'||SUBSTR(W_CPF_ST_FORMATADO,4,3)|| '.' ||
                            SUBSTR(W_CPF_ST_FORMATADO,7,3)|| '-' ||
							SUBSTR(W_CPF_ST_FORMATADO,10,2);
                          
RETURN W_CPF_ST_FORMATADO;
EXCEPTION
WHEN INVALID_NUMBER THEN
    w_sqlcode := sqlcode;
	w_sqlerrm := sqlerrm;
    w_sqlerrm := w_sqlcode || ' - ' || w_sqlerrm;
	RAISE_APPLICATION_ERROR(-20020,w_sqlerrm);
	return null;
WHEN OTHERS THEN
    w_sqlcode := sqlcode;
	w_sqlerrm := sqlerrm;
    w_sqlerrm := w_sqlcode || ' - ' || w_sqlerrm;
	RAISE_APPLICATION_ERROR(-20021,w_sqlerrm);
	return null;
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_INSTITUICAO BEFORE
  INSERT or UPDATE ON TBL_INSTITUICAO FOR EACH ROW
DECLARE
  W_INST_ST_CNPJ VARCHAR2(20) := LPAD(REPLACE(REPLACE(:NEW.INST_ST_CNPJ,'.',''),'/',''),14,'0');
BEGIN 
  IF INSERTING THEN
     if :NEW.INST_IN_ID is null then
		SELECT SQ_INSTITUICAO.NEXTVAL INTO :NEW.INST_IN_ID FROM DUAL;
	 end if;
  END IF;
  :NEW.INST_ST_CNPJ := FC_MASCARA_CNPJ(FC_VALIDA_CNPJ(W_INST_ST_CNPJ));
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_CURSO BEFORE
  INSERT or UPDATE ON TBL_CURSO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_ALUNO BEFORE
  INSERT or UPDATE ON TBL_ALUNO FOR EACH ROW
BEGIN 
  :NEW.ALU_ST_NOME_CENSO := 
  UPPER(REPLACE(:NEW.ALU_ST_NOME,'ãõâêîôûáéíóúäëïöüçÃÕÂÊÎÔÛÄËÏÖÜÇ"´`''ªº{}[]+=_-!@#$%¨&*()/:;.,',
                                 'AOAEIOUAEIOUAEIOUCAOAEIOUAEIOUC                               '));
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_ALUNO_HISTORICO BEFORE
  INSERT or UPDATE ON TBL_ALUNO_CURSO_HISTORICO FOR EACH ROW
DECLARE
  PROCEDURE PC_CARGA_HORARIA(PI_DISC_IN_ID INTEGER, PI_CURR_IN_ID INTEGER, PO_CH_TEORICA OUT NUMBER, PO_CH_PRATICA OUT NUMBER) IS
  W_CH_TEORICA TBL_GRADE.GRD_IN_CARGA_HORARIA%TYPE;
  W_CH_PRATICA TBL_GRADE.GRD_IN_CARGA_HRPRATICA%TYPE;
  BEGIN
    IF PI_CURR_IN_ID IS NOT NULL THEN
    SELECT GRD_IN_CARGA_HORARIA, GRD_IN_CARGA_HRPRATICA
	  INTO W_CH_TEORICA, W_CH_PRATICA
	  FROM TBL_GRADE
	 WHERE DISC_IN_ID = PI_DISC_IN_ID
	   AND CURR_IN_ID = PI_CURR_IN_ID;
	ELSE
    SELECT DISC_IN_CARGA_HORARIA, DISC_IN_CARGA_HRPRATICA
	  INTO W_CH_TEORICA, W_CH_PRATICA
	  FROM TBL_DISCIPLINA
	 WHERE DISC_IN_ID = PI_DISC_IN_ID;
	END IF;
	PO_CH_TEORICA := W_CH_TEORICA;
	PO_CH_PRATICA := W_CH_PRATICA;
  END;  
  FUNCTION FC_CALCULA_MEDIA(PI_ACUR_IN_ID INTEGER, W_AV1 NUMBER, W_AV2 NUMBER, W_AV3 NUMBER, W_AV4 NUMBER, W_AV5 NUMBER, W_AV6 NUMBER) RETURN NUMBER IS
    
	TYPE T_REFCURSOR IS REF CURSOR;
    C_REF T_REFCURSOR;
    W_SQL TBL_FORMULA_MEDIA.FMED_ST_CALCULO%TYPE;
    W_CONTAV NUMBER := 0;
    W_RESULT NUMBER := 0;
	W_FMED_ST_CALCULO TBL_FORMULA_MEDIA.FMED_ST_CALCULO%TYPE;
	W_CUR_IN_ID TBL_CURSO.CUR_IN_ID%TYPE;
	W_CUR_IN_MODALIDADE TBL_CURSO.CUR_IN_MODALIDADE%TYPE;
	CURSOR C_CUR IS
	SELECT CUR_IN_ID, CUR_IN_MODALIDADE FROM TBL_CURSO
	 WHERE CUR_IN_ID IN (SELECT CUR_IN_ID FROM TBL_ALUNO_CURSO
	                      WHERE ACUR_IN_ID = PI_ACUR_IN_ID);

  BEGIN
    OPEN C_CUR;
	FETCH C_CUR INTO W_CUR_IN_ID, W_CUR_IN_MODALIDADE;
	CLOSE C_CUR;
	
	BEGIN
	-- Verifica se existe formula para o curso
    SELECT FMED_ST_CALCULO INTO W_FMED_ST_CALCULO
      FROM TBL_FORMULA_MEDIA
     WHERE CUR_IN_ID = W_CUR_IN_ID AND ROWNUM =1;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		-- Verifica se existe formula para a modalidade
        SELECT FMED_ST_CALCULO INTO W_FMED_ST_CALCULO
          FROM TBL_FORMULA_MEDIA
         WHERE FMED_IN_MODALIDADE = W_CUR_IN_MODALIDADE;
	END;
    
    W_SQL := 'SELECT '||REPLACE(W_FMED_ST_CALCULO,'%','*(1/100)')||' FROM DUAL';
    IF INSTR(W_FMED_ST_CALCULO,':AV1')>0 THEN
      W_CONTAV := W_CONTAV + 1;
    END IF;
    IF INSTR(W_FMED_ST_CALCULO,':AV2')>0 THEN
      W_CONTAV := W_CONTAV + 1;
    END IF;
    IF INSTR(W_FMED_ST_CALCULO,':AV3')>0 THEN
      W_CONTAV := W_CONTAV + 1;
    END IF;
    IF INSTR(W_FMED_ST_CALCULO,':AV4')>0 THEN
      W_CONTAV := W_CONTAV + 1;
    END IF;
    IF INSTR(W_FMED_ST_CALCULO,':AV5')>0 THEN
      W_CONTAV := W_CONTAV + 1;
    END IF;
    IF INSTR(W_FMED_ST_CALCULO,':AV6')>0 THEN
      W_CONTAV := W_CONTAV + 1;
    END IF;
    IF W_CONTAV = 1 THEN
      OPEN C_REF FOR W_SQL USING W_AV1;
      FETCH C_REF INTO W_RESULT;
      CLOSE C_REF;
    ELSIF W_CONTAV = 2 THEN
      OPEN C_REF FOR W_SQL USING W_AV1, W_AV2;
      FETCH C_REF INTO W_RESULT;
      CLOSE C_REF;
    ELSIF W_CONTAV = 3 THEN
     OPEN C_REF FOR W_SQL USING W_AV1, W_AV2, W_AV3;
     FETCH C_REF INTO W_RESULT;
     CLOSE C_REF;
  ELSIF W_CONTAV = 4 THEN
     OPEN C_REF FOR W_SQL USING W_AV1, W_AV2, W_AV3, W_AV4;
     FETCH C_REF INTO W_RESULT;
     CLOSE C_REF;
  ELSIF W_CONTAV = 5 THEN
     OPEN C_REF FOR W_SQL USING W_AV1, W_AV2, W_AV3, W_AV4, W_AV5;
     FETCH C_REF INTO W_RESULT;
     CLOSE C_REF;
  ELSIF W_CONTAV = 6 THEN
     OPEN C_REF FOR W_SQL USING W_AV1, W_AV2, W_AV3, W_AV4, W_AV5, W_AV6;
     FETCH C_REF INTO W_RESULT;
     CLOSE C_REF;
  END IF;
  
  return W_RESULT;

  EXCEPTION  WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20002,'Erro ao validar a fórmula');

  END;
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
  IF UPDATING THEN
    IF (:NEW.ACHIS_NU_AVAL1 <> :OLD.ACHIS_NU_AVAL1 OR :NEW.ACHIS_NU_AVAL2 <> :OLD.ACHIS_NU_AVAL2 OR
	    :NEW.ACHIS_NU_AVAL3 <> :OLD.ACHIS_NU_AVAL3 OR :NEW.ACHIS_NU_AVAL4 <> :OLD.ACHIS_NU_AVAL4 OR
		:NEW.ACHIS_NU_AVAL5 <> :OLD.ACHIS_NU_AVAL5 OR :NEW.ACHIS_NU_AVAL6 <> :OLD.ACHIS_NU_AVAL6) THEN
	    :NEW.ACHIS_NU_MEDIA := FC_CALCULA_MEDIA(:NEW.ACUR_IN_ID,:NEW.ACHIS_NU_AVAL1,:NEW.ACHIS_NU_AVAL2,:NEW.ACHIS_NU_AVAL3,:NEW.ACHIS_NU_AVAL4,:NEW.ACHIS_NU_AVAL5,:NEW.ACHIS_NU_AVAL6);
        IF :NEW.ACHIS_NU_MEDIA >= 6 THEN
		   :NEW.ACHIS_IN_SITUACAO := 3;
		ELSIF :OLD.ACHIS_IN_SITUACAO <> 5 THEN
		   :NEW.ACHIS_IN_SITUACAO := 4;
        END IF;		
	END IF;

    IF :NEW.ACHIS_IN_SITUACAO <> :OLD.ACHIS_IN_SITUACAO THEN
	   IF :NEW.ACHIS_IN_SITUACAO IN (3,5) then -- Aprovado
	     PC_CARGA_HORARIA(:NEW.DISC_IN_ID, :NEW.CURR_IN_ID, :NEW.ACHIS_NU_CHTEORICA_CUMPRIDA, :NEW.ACHIS_NU_CHPRATICA_CUMPRIDA);
	   END IF;
	END IF;
  END IF;
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_ALUNO_CURSO BEFORE
  INSERT or UPDATE ON TBL_ALUNO_CURSO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_CALENDARIO BEFORE
  INSERT or UPDATE ON TBL_CALENDARIO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_CURSO BEFORE
  INSERT or UPDATE ON TBL_CURSO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_CURSO_TURNO BEFORE
  INSERT or UPDATE ON TBL_CURSO_TURNO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_DISCIPLINA BEFORE
  INSERT or UPDATE ON TBL_DISCIPLINA FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_DISIPLINA_PREREQ BEFORE
  INSERT or UPDATE ON TBL_DISCIPLINA_PREREQ FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_DOCENTE BEFORE
  INSERT or UPDATE ON TBL_DOCENTE FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_DOCENTE_CURSO BEFORE
  INSERT or UPDATE ON TBL_DOCENTE_CURSO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_DOCENTE_DISCIPLINA BEFORE
  INSERT or UPDATE ON TBL_DOCENTE_DISCIPLINA FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;


CREATE OR REPLACE TRIGGER TRG_BIU_HISTORICO_AFASTAMENTO BEFORE
  INSERT or UPDATE ON TBL_HISTORICO_AFASTAMENTO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

show errors;

CREATE OR REPLACE TRIGGER TRG_BIU_MUNICIPIO BEFORE
  INSERT or UPDATE ON TBL_MUNICIPIO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_PAIS BEFORE
  INSERT or UPDATE ON TBL_PAIS FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_PERIODO BEFORE
  INSERT or UPDATE ON TBL_PERIODO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_TURMA BEFORE
  INSERT or UPDATE ON TBL_TURMA FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_TURNO BEFORE
  INSERT or UPDATE ON TBL_TURNO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_UF BEFORE
  INSERT or UPDATE ON TBL_UF FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/


CREATE OR REPLACE FUNCTION fc_valida_cpf(p_numero_cpf IN VARCHAR2) RETURN NUMBER IS
  w_cpf         	VARCHAR2(11) := lpad(p_numero_cpf, 11, '0');
  w_soma_dig1	 	NUMBER := 0;
  w_soma_dig2  		NUMBER := 0;
BEGIN
  -- Cálculo do primeiro dígito verificador
  FOR i IN REVERSE 2 .. 10
  LOOP
    w_soma_dig1 := (w_soma_dig1 + (i * to_number(substr(w_cpf, (11 - i), 1))));
  END LOOP;
  w_soma_dig1 := (11 - (MOD(w_soma_dig1, 11)));
  IF (w_soma_dig1 >= 10)
  THEN
    w_soma_dig1 := 0;
  END IF;
  -- Cálculo do segundo dígito verificador
  FOR i IN REVERSE 2 .. 11
  LOOP
    w_soma_dig2 := (w_soma_dig2 + (i * to_number(substr(w_cpf, (12 - i), 1))));
  END LOOP;
  w_soma_dig2 := (11 - (MOD(w_soma_dig2, 11)));
  IF (w_soma_dig2 = 10)
  THEN
    w_soma_dig2 := 0;
  END IF;
  IF ((w_soma_dig1 = to_number(substr(w_cpf, 10, 1))) AND
     (w_soma_dig2 = to_number(substr(w_cpf, 11, 1))))
  THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END fc_valida_cpf;
/
show errors;


CREATE OR REPLACE FUNCTION FC_REFERENCIA_DESCRICAO(PI_ST_TIPO_REFERENCIA VARCHAR2, PI_IN_VALOR_REFERENCIA NUMBER) RETURN VARCHAR2 IS
	CURSOR C_REFERENCIA IS SELECT REFE_ST_DESCRICAO
                         FROM TBL_referencia
						WHERE REFE_ST_TIPO = PI_ST_TIPO_REFERENCIA
						  AND REFE_IN_CODIGO = PI_IN_VALOR_REFERENCIA;
	W_ST_REFDESCRICAO TBL_REFERENCIA.REFE_ST_DESCRICAO%TYPE;
BEGIN
	OPEN C_REFERENCIA;
	FETCH C_REFERENCIA INTO W_ST_REFDESCRICAO;
	CLOSE C_REFERENCIA;
	RETURN W_ST_REFDESCRICAO;

END;
/

show errors;

CREATE OR REPLACE FUNCTION FC_PAIS_NOME(PI_IN_PAIS NUMBER) RETURN VARCHAR2 IS
	CURSOR C_PAIS IS SELECT PAIS_ST_NOME
                         FROM TBL_PAIS
						WHERE PAIS_IN_ID = PI_IN_PAIS;
	W_ST_PAIS_NOME TBL_PAIS.PAIS_ST_NOME%TYPE;
BEGIN
	OPEN C_PAIS;
	FETCH C_PAIS INTO W_ST_PAIS_NOME;
	CLOSE C_PAIS;
	RETURN W_ST_PAIS_NOME;

END;
/

show errors;

CREATE OR REPLACE FUNCTION FC_UF_NOME(PI_IN_UF NUMBER) RETURN VARCHAR2 IS
	CURSOR C_UF IS SELECT UF_ST_NOME
                         FROM TBL_UF
						WHERE UF_IN_CODIGO_CENSO = PI_IN_UF;
	W_ST_UF_NOME TBL_UF.UF_ST_NOME%TYPE;
BEGIN
	OPEN C_UF;
	FETCH C_UF INTO W_ST_UF_NOME;
	CLOSE C_UF;
	RETURN W_ST_UF_NOME;

END;
/

show errors;

CREATE OR REPLACE FUNCTION FC_MUNICIPIO_NOME(PI_IN_MUNICIPIO NUMBER) RETURN VARCHAR2 IS
	CURSOR C_MUNI IS SELECT MUNI_ST_NOME
                         FROM TBL_MUNICIPIO
						WHERE MUNI_IN_CODIGO_CENSO = PI_IN_MUNICIPIO;
	W_ST_MUNI_NOME TBL_MUNICIPIO.MUNI_ST_NOME%TYPE;
BEGIN
	OPEN C_MUNI;
	FETCH C_MUNI INTO W_ST_MUNI_NOME;
	CLOSE C_MUNI;
	RETURN W_ST_MUNI_NOME;

END;
/

show errors;

CREATE OR REPLACE FUNCTION FC_DEFICIENCIAS(PI_ST_DEFICIENCIAS VARCHAR2) RETURN VARCHAR2 IS
	W_ARRAY_DEFICIENCIAS APEX_APPLICATION_GLOBAL.VC_ARR2;
	W_ST_RETORNO_DEFICIENCIAS VARCHAR2(2000);
BEGIN
	IF INSTR(NVL(PI_ST_DEFICIENCIAS,'*'),':') > 0 THEN /* ARRAY */
		W_ARRAY_DEFICIENCIAS := APEX_UTIL.STRING_TO_TABLE(PI_ST_DEFICIENCIAS,':');
		FOR I IN 1 .. W_ARRAY_DEFICIENCIAS.COUNT LOOP
			BEGIN
			W_ST_RETORNO_DEFICIENCIAS := W_ST_RETORNO_DEFICIENCIAS || FC_REFERENCIA_DESCRICAO('TIPO_DEFICIENCIA',W_ARRAY_DEFICIENCIAS(I)) || ', ';
			EXCEPTION
				WHEN INVALID_NUMBER THEN NULL;
				WHEN NO_DATA_FOUND THEN NULL;
			END;
		END LOOP;
	ELSE /* NÃO É ARRAY */
		W_ST_RETORNO_DEFICIENCIAS := FC_REFERENCIA_DESCRICAO('TIPO_DEFICIENCIA',PI_ST_DEFICIENCIAS)||', ';
	END IF;
	
	W_ST_RETORNO_DEFICIENCIAS := SUBSTR(W_ST_RETORNO_DEFICIENCIAS,1,LENGTH(W_ST_RETORNO_DEFICIENCIAS)-2);
	return W_ST_RETORNO_DEFICIENCIAS;
END;
/

show errors;

CREATE OR REPLACE FUNCTION FC_ST_PERIODO(PI_IN_PERIODO NUMBER) RETURN VARCHAR2 IS
W_ST_PERIODO TBL_PERIODO.PERI_ST_NOME%TYPE;
BEGIN
	SELECT PERI_ST_NOME
	  INTO W_ST_PERIODO
	  FROM TBL_PERIODO
	 WHERE PERI_IN_ID = PI_IN_PERIODO;
	 RETURN W_ST_PERIODO;
END;
/

SHOW ERRORS;

CREATE OR REPLACE FUNCTION FC_ST_CURSO(PI_IN_CURSO NUMBER) RETURN VARCHAR2 IS
W_ST_CURSO TBL_CURSO.CUR_ST_NOME%TYPE;
BEGIN
	SELECT CUR_ST_NOME
	  INTO W_ST_CURSO
	  FROM TBL_CURSO
	 WHERE CUR_IN_ID = PI_IN_CURSO;
	 RETURN W_ST_CURSO;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE PC_VINCULA_ANEXO(PI_ANEX_IN_ID NUMBER, PI_ST_TIPO VARCHAR2, PI_IN_CHAVE INTEGER) IS
W_ST_USUARIO VARCHAR2(30);
W_DT_USUARIO DATE;
BEGIN
	PC_ATUALIZA_USUARIO(W_ST_USUARIO, W_DT_USUARIO);
	IF UPPER(PI_ST_TIPO) = 'ALUNO' THEN
		-- ANEXOS DO ALUNO
		INSERT INTO TBL_ALUNO_ANEXO(ALU_IN_ID, ANEX_IN_ID, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
		VALUES (PI_IN_CHAVE, PI_ANEX_IN_ID, W_ST_USUARIO, W_DT_USUARIO);
	ELSIF UPPER(PI_ST_TIPO) = 'DOCENTE' THEN
		-- ANEXOS DO DOCENTE
		INSERT INTO TBL_DOCENTE_ANEXO(DOCE_IN_ID, ANEX_IN_ID, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
		VALUES (PI_IN_CHAVE, PI_ANEX_IN_ID, W_ST_USUARIO, W_DT_USUARIO);
	ELSIF UPPER(PI_ST_TIPO) = 'DISCIPLINA' THEN
		-- ANEXOS DA DISCIPLINA
		INSERT INTO TBL_DISCIPLINA_ANEXO(DISC_IN_ID, ANEX_IN_ID, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
		VALUES (PI_IN_CHAVE, PI_ANEX_IN_ID, W_ST_USUARIO, W_DT_USUARIO);
	END IF;
END;
/

show errors;

ALTER TABLE TBL_CURSO
  ADD CUR_IN_PERIODICIDADE INTEGER;
  
ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_IN_INGRESSO INTEGER NOT NULL;

ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_IN_MOBDACAD INTEGER NULL;

ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_IN_MOBDACAD_INTER INTEGER NULL;
  
ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_IN_MOBDACAD_IESDEST INTEGER NULL;
  
ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_IN_MOBDACAD_PAISDEST INTEGER NULL;

ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_IN_FINANCIAMENTO INTEGER NULL;
  
ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_NU_BOLSA_PESQUISA NUMBER(10,2);

ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_NU_BOLSA_EXTENSAO NUMBER(10,2);

ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_NU_BOLSA_MONITORIA NUMBER(10,2);

ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_NU_BOLSA_ESTAGIO NUMBER(10,2);

ALTER TABLE TBL_ALUNO_CURSO
MODIFY ACUR_IN_BOLSA NULL;

ALTER TABLE TBL_GRADE
  ADD PERI_IN_ID INTEGER NOT NULL;

ALTER TABLE TBL_GRADE
  ADD GRD_IN_SEQUENCIA INTEGER;  

  
ALTER TABLE TBL_TURMA 
  ADD ANO_IN_ID INTEGER NOT NULL;
  
ALTER TABLE TBL_TURMA
  ADD TUR_DT_INICIO DATE;

ALTER TABLE TBL_TURMA
  ADD TUR_DT_ENCERRAMENTO DATE;  

ALTER TABLE TBL_TURMA
MODIFY PERI_IN_ID NULL; 

ALTER TABLE TBL_TURMA
DROP COLUMN PERI_IN_ID; 

ALTER TABLE TBL_GRADE
DROP COLUMN CUR_IN_ID;

ALTER TABLE TBL_GRADE
DROP COLUMN TUR_IN_ID;

ALTER TABLE TBL_CURSO
  ADD CUR_DT_PUBLICA_DOU DATE;

CREATE TABLE TBL_CURRICULO
  (
    CURR_IN_ID         	 INTEGER NOT NULL ,
	CURR_ST_CODIGO       VARCHAR2(20) NOT NULL,
	CURR_ST_DETALHES     VARCHAR2(2000),
	CUR_IN_ID			 INTEGER NOT NULL,
	CURR_DT_VIGENCIA_INI DATE NOT NULL,
	CURR_DT_VIGENCIA_FIM DATE,
	CURR_IN_CH_TOTAL        NUMBER,
	CURR_IN_SITUACAO     INTEGER,
	user_st_atualiza     VARCHAR2(30) NOT NULL,
	user_dt_atualiza     DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/


  CREATE TABLE TBL_FERIADO
  (
    FER_IN_ID        INTEGER NOT NULL ,
	FER_ST_NOME      VARCHAR2(50) NOT NULL,
	FER_IN_MES       INTEGER NOT NULL,
	FER_IN_DIA       INTEGER NOT NULL,
	user_st_atualiza     VARCHAR2(30) NOT NULL,
	user_dt_atualiza     DATE  NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

CREATE TABLE TBL_HORARIO_SEMANA
  (
    HOSE_IN_ID             INTEGER NOT NULL ,
	PERI_IN_ID             INTEGER NOT NULL ,
	TUR_IN_ID              INTEGER NOT NULL ,
	HOSE_CH_HORARIO        VARCHAR2(5) NOT NULL,
	HOSE_IN_DIASEM         INTEGER NOT NULL ,
	DISC_IN_ID             INTEGER NOT NULL ,
	DOCE_IN_ID             NULL,
	USUA_ST_ATUALIZA       VARCHAR2(30) NOT NULL,
	USUA_DT_ATUALIZA       DATE NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

ALTER TABLE TBL_HORARIO_SEMANA
  ADD CONSTRAINT PK_HOSE 
  PRIMARY KEY (HOSE_IN_ID)
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  TABLESPACE "TS_INDX" ENABLE;
  
ALTER TABLE TBL_HORARIO_SEMANA
  ADD CONSTRAINT UK_HOSE 
  UNIQUE (PERI_IN_ID , TUR_IN_ID , HOSE_IN_DIASEM , HOSE_CH_HORARIO)
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  TABLESPACE "TS_INDX" ENABLE;

create SEQUENCE SQ_HORARIO_SEMANA START WITH 1 NOCACHE ORDER;


CREATE TABLE TBL_TURNO_AULA
  (
    AULA_IN_ID             INTEGER NOT NULL ,
    TURN_IN_ID             INTEGER NOT NULL ,
	AULA_CH_HORA_INI       VARCHAR2(5) NOT NULL,
	AULA_CH_HORA_FIM       VARCHAR2(5) NOT NULL,
	USER_ST_ATUALIZA       VARCHAR2(30) NOT NULL,
	USER_DT_ATUALIZA       DATE NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

  CREATE SEQUENCE SQ_TURNO_AULA START WITH 1 NOCACHE ORDER;
  
ALTER TABLE TBL_TURNO_AULA
  ADD CONSTRAINT PK_TURNO_AULA
  PRIMARY KEY (AULA_IN_ID)
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FRNEELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  TABLESPACE "TS_INDX" ENABLE;
  
ALTER TABLE TBL_TURNO
  ADD TURN_CH_DURACAO_AULA CHAR(5) DEFAULT '01:00';

ALTER TABLE TBL_TURNO
  ADD TURN_IN_QTDE_AULA INTEGER DEFAULT 4;
  
UPDATE TBL_TURNO
   SET TURN_CH_DURACAO_AULA = '01:00'
     , TURN_IN_QTDE_AULA = 4
 WHERE TURN_IN_ID IN (1,2); 
 
 DECLARE
   W_HORA_MANHA CHAR(5) := '08:00';
   W_HORA_MANHAFIM CHAR(5) := '09:00';
   W_HORA_NOITE CHAR(5) := '18:00';
   W_HORA_NOITEFIM CHAR(5) := '19:00';
   W_DATA       DATE    := TRUNC(SYSDATE);
 BEGIN
   FOR L IN 1 .. 4 LOOP
	 INSERT INTO TBL_TURNO_AULA(AULA_IN_ID, TURN_IN_ID, AULA_CH_HORA_INI, AULA_CH_HORA_FIM, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
	 VALUES (SQ_TURNO_AULA.NEXTVAL, 1,  W_HORA_MANHA, W_HORA_MANHAFIM, USER, SYSDATE);
	 INSERT INTO TBL_TURNO_AULA(AULA_IN_ID, TURN_IN_ID, AULA_CH_HORA_INI, AULA_CH_HORA_FIM, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
	 VALUES (SQ_TURNO_AULA.NEXTVAL, 2,  W_HORA_NOITE, W_HORA_NOITEFIM, USER, SYSDATE);
	 W_HORA_MANHA := TO_CHAR(TO_DATE(TO_CHAR(W_DATA,'DDMMYYYY')||W_HORA_MANHA,'DDMMYYYYHH24:MI')+1/24,'HH24:MI');
	 W_HORA_NOITE := TO_CHAR(TO_DATE(TO_CHAR(W_DATA,'DDMMYYYY')||W_HORA_NOITE,'DDMMYYYYHH24:MI')+1/24,'HH24:MI');
	 W_HORA_MANHAFIM := TO_CHAR(TO_DATE(TO_CHAR(W_DATA,'DDMMYYYY')||W_HORA_MANHAFIM,'DDMMYYYYHH24:MI')+1/24,'HH24:MI');
	 W_HORA_NOITEFIM := TO_CHAR(TO_DATE(TO_CHAR(W_DATA,'DDMMYYYY')||W_HORA_NOITEFIM,'DDMMYYYYHH24:MI')+1/24,'HH24:MI');
   END LOOP;
 END;
/
  
ALTER TABLE TBL_FERIADO ADD CONSTRAINT PK_FERIADO
  PRIMARY KEY ( FER_IN_ID ) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  /

ALTER TABLE TBL_FERIADO ADD CONSTRAINT UK_FERIADO
  UNIQUE ( FER_IN_MES, FER_IN_DIA ) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  /
  
  
CREATE SEQUENCE SQ_FERIADO START WITH 1 NOCACHE ORDER;

ALTER TABLE TBL_CURRICULO ADD CURR_ST_NOME VARCHAR2(100);
  
ALTER TABLE TBL_CURRICULO ADD CONSTRAINT PK_CURRICULO
  PRIMARY KEY ( CURR_IN_ID ) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  /
 
CREATE TABLE TBL_MATRICULA
  (
    MATR_IN_ID             INTEGER NOT NULL ,
	ACUR_IN_ID             INTEGER NOT NULL ,
	PERI_IN_ID             INTEGER NOT NULL ,
	MATR_IN_SITUACAO       INTEGER NOT NULL ,
	MATR_DT_MATRICULA      DATE,
	MATR_DT_TRANCAMENTO    DATE,
	MATR_DT_CANCELAMENTO   DATE,
	MATR_DT_TRANSFERENCIA  DATE,
	MATR_RE_DEBITOS        NUMBER(20,2),
	MATR_RE_CREDITOS       NUMBER(20,2),
	MATR_ST_OBSERVACOES    VARCHAR2(2000),
	USER_ST_ATUALIZA       VARCHAR2(30) NOT NULL,
	USER_DT_ATUALIZA       DATE NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

  CREATE SEQUENCE SQ_MATRICULA START WITH 1 NOCACHE ORDER;
  
ALTER TABLE TBL_MATRICULA ADD CONSTRAINT PK_MATRICULA
  PRIMARY KEY ( MATR_IN_ID ) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  /
  
ALTER TABLE TBL_MATRICULA ADD CONSTRAINT FK_MATR_ACUR FOREIGN KEY (ACUR_IN_ID) REFERENCES TBL_ALUNO_CURSO;
ALTER TABLE TBL_MATRICULA ADD CONSTRAINT FK_MATR_PERI FOREIGN KEY (PERI_IN_ID) REFERENCES TBL_PERIODO;
  
ALTER TABLE TBL_ALUNO_CURSO
MODIFY ACUR_DT_ULTIMA_MATRICULA NULL;

CREATE TABLE TBL_TURMA_DISCIPLINA_OPTATIVA
  (
	TUDO_IN_ID            INTEGER NOT NULL ,
    TUR_IN_ID             INTEGER NOT NULL ,
	DISC_IN_ID_GRADE      INTEGER NOT NULL ,
	DISC_IN_ID_TURMA      INTEGER NOT NULL ,
    USER_ST_ATUALIZA      VARCHAR2(30) NOT NULL ,
    USER_DT_ATUALIZA      DATE NOT NULL	
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

CREATE SEQUENCE SQ_TURMA_DISCIPLINA_OPTATIVA START WITH 1 NOCACHE ORDER;
  
ALTER TABLE TBL_TURMA_DISCIPLINA_OPTATIVA ADD CONSTRAINT PK_TURMA_DISCIPLINA_OPTATIVA
  PRIMARY KEY ( TUDO_IN_ID ) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  /

ALTER TABLE TBL_TURMA_DISCIPLINA_OPTATIVA ADD CONSTRAINT UK_TURMA_DISCIPLINA_OPTATIVA
  UNIQUE ( TUR_IN_ID, DISC_IN_ID_GRADE, DISC_IN_ID_TURMA ) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  /
  
ALTER TABLE TBL_TURMA_DISCIPLINA_OPTATIVA ADD CONSTRAINT FK_TUDO_DISC_01 FOREIGN KEY (DISC_IN_ID_GRADE) REFERENCES TBL_DISCIPLINA;  
ALTER TABLE TBL_TURMA_DISCIPLINA_OPTATIVA ADD CONSTRAINT FK_TUDO_DISC_02 FOREIGN KEY (DISC_IN_ID_TURMA) REFERENCES TBL_DISCIPLINA;

drop table TBL_FORMULA_MEDIA CASCADE CONSTRAINTS;
CREATE TABLE TBL_FORMULA_MEDIA
  (
    FMED_IN_ID             INTEGER NOT NULL ,
	FMED_ST_DESCRICAO      VARCHAR2(50) NOT NULL,
	FMED_ST_CALCULO        VARCHAR2(500) NOT NULL,
	FMED_ST_OBSERVACAO     VARCHAR2(4000) NULL,
	FMED_IN_FLAG_NIVEL     CHAR(1) NOT NULL ,
	FMED_IN_MODALIDADE     CHAR(1) NOT NULL ,
	CUR_IN_ID              INTEGER NULL ,
	FMED_DT_VIGENCIA       DATE NOT NULL ,
	USER_ST_ATUALIZA       VARCHAR2(30) NOT NULL,
	USER_DT_ATUALIZA       DATE NOT NULL
  )
  pctfree 10
  initrans 1
  maxtrans 255
/

COMMENT ON TABLE TBL_FORMULA_MEDIA IS 'TABELA DE REGRAS DE CALCULOS DAS MÉDIAS';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.FMED_IN_ID IS 'Identificador Único da Fórmula de cálculo das médias';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.FMED_ST_DESCRICAO IS 'Descrição da Fórmula de cálculo das médias';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.FMED_ST_OBSERVACAO IS 'Observações da Fórmula de cálculo das médias';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.FMED_IN_FLAG_NIVEL IS 'Nível em que o cálculo das médias deve ser efetuado (1 = Modalidade 2 = Curso)';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.FMED_IN_MODALIDADE IS 'ID da Modalidade de Ensino 1=Presencial 2=A distancia';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.CUR_IN_ID  IS 'ID do Curso para o qual a regra de cálculo foi criada';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.FMED_DT_VIGENCIA IS 'Data de Início de Vigência da Fórmula de cálculo da média';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.USER_ST_ATUALIZA IS 'Último Usuário que atualizou a tabela de Fórmula de Médias';
COMMENT ON COLUMN TBL_FORMULA_MEDIA.USER_DT_ATUALIZA IS 'Última Data de Atualização na tabela de Fórmula de Médias';

ALTER TABLE TBL_FORMULA_MEDIA
  ADD CONSTRAINT PK_FORM 
  PRIMARY KEY (FMED_IN_ID)
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  TABLESPACE "TS_INDX" ENABLE;

ALTER TABLE TBL_FORMULA_MEDIA
  ADD CONSTRAINT UK_FORM_NIVEL 
  UNIQUE (FMED_IN_FLAG_NIVEL, FMED_IN_MODALIDADE, CUR_IN_ID)
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  TABLESPACE "TS_INDX" ENABLE;
  
ALTER TABLE TBL_FORMULA_MEDIA
  ADD CONSTRAINT FK_FMED_CURSO FOREIGN KEY (CUR_IN_ID) REFERENCES TBL_CURSO;
  
ALTER TABLE TBL_FORMULA_MEDIA
  ADD CONSTRAINT CK_FMED_MODALIDADE CHECK (FMED_IN_MODALIDADE IN (1,2));
  
ALTER TABLE TBL_CURSO
  ADD CUR_IN_MODALIDADE INTEGER;  
  
DROP SEQUENCE SQ_FORMULA_MEDIA;  
create SEQUENCE SQ_FORMULA_MEDIA START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER TRG_BIU_FORMULA_MEDIA BEFORE
  INSERT or UPDATE ON TBL_FORMULA_MEDIA FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_TURMA_DISC_OPTATIVA BEFORE
  INSERT or UPDATE ON TBL_TURMA_DISCIPLINA_OPTATIVA FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_MATRICULA BEFORE
  INSERT or UPDATE ON TBL_MATRICULA FOR EACH ROW
  DECLARE
    PROCEDURE SET_STATUS_ALUNO_CURSO(P_ACUR_IN_ID INTEGER, P_STAT_IN_ID INTEGER) IS
    BEGIN
      UPDATE TBL_ALUNO_CURSO
	     SET ACUR_DT_INGRESSO = SYSDATE
	   WHERE ACUR_DT_INGRESSO IS NULL
	     AND ACUR_IN_ID = P_ACUR_IN_ID;
	 
      UPDATE TBL_ALUNO_CURSO
	     SET ACUR_IN_SITUACAO = P_STAT_IN_ID
	       , ACUR_DT_ULTIMA_MATRICULA = (CASE P_STAT_IN_ID WHEN 1 THEN NULL
		                                                 WHEN 2 THEN SYSDATE
														 ELSE ACUR_DT_ULTIMA_MATRICULA
									     END)
		   , ACUR_DT_TRANSFERENCIA = (CASE P_STAT_IN_ID 	 WHEN 1 THEN NULL
		                                                 WHEN 5 THEN SYSDATE
														 ELSE ACUR_DT_TRANSFERENCIA
			   						  END)
	   WHERE ACUR_IN_ID = P_ACUR_IN_ID;
     END;
  BEGIN 
    IF INSERTING THEN
      -- Aluno curso começa com a situação desvínculado do curso
	  SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,NVL(:MATR_IN_SITUACAO,4));
    ELSE
      IF :NEW.MATR_IN_SITUACAO <> :OLD.MATR_IN_SITUACAO THEN
        IF :NEW.MATR_IN_SITUACAO = 2 THEN
           :NEW.MATR_DT_MATRICULA := SYSDATE;
           -- Aluno curso Situação Cursando
	       SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,2);
        ELSIF :NEW.MATR_IN_SITUACAO = 3 THEN
           :NEW.MATR_DT_TRANCAMENTO := SYSDATE;
           -- Aluno curso Situação Trancado
	       SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,3);
        ELSIF :NEW.MATR_IN_SITUACAO = 4 THEN
           :NEW.MATR_DT_CANCELAMENTO := SYSDATE;
           -- Aluno curso Situação Trancado
	       SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,3);
        ELSIF :NEW.MATR_IN_SITUACAO = 5 THEN
           :NEW.MATR_DT_TRANSFERENCIA := SYSDATE;
           -- Aluno curso Situação Transferido
	       SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,5);		 
        END IF;	 
	  END IF;
    END IF;
    PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
  END;
/

show errors;
 
ALTER TABLE TBL_GRADE
  ADD CURR_IN_ID INTEGER NOT NULL;
  
ALTER TABLE TBL_GRADE
  ADD CONSTRAINT FK_GRADE_CURRICULO FOREIGN KEY (CURR_IN_ID) REFERENCES TBL_CURRICULO;

ALTER TABLE TBL_TURMA
  ADD CURR_IN_ID INTEGER NOT NULL;

ALTER TABLE TBL_TURMA
  ADD CONSTRAINT FK_TURMA_CURRICULO FOREIGN KEY (CURR_IN_ID) REFERENCES TBL_CURRICULO;
  
ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_IN_ATIVIDADE_EXTRA INTEGER;  
  
ALTER TABLE TBL_ALUNO_CURSO
  ADD ACUR_IN_APOIO_SOCIAL INTEGER;  

ALTER TABLE TBL_CALENDARIO
  ADD CALE_IN_TIPO_DATA INTEGER;
  
CREATE OR REPLACE TRIGGER TRG_BIU_GRADE BEFORE
  INSERT or UPDATE ON TBL_GRADE FOR EACH ROW
DECLARE
  CURSOR C_SEQ_DESC IS 
    SELECT GRD_IN_SEQUENCIA 
	  FROM TBL_GRADE 
	 WHERE CURR_IN_ID = :NEW.CURR_IN_ID
	 ORDER BY 1 DESC;
  W_IN_SEQ INTEGER;
BEGIN
  IF INSERTING THEN

	OPEN C_SEQ_DESC;
	FETCH C_SEQ_DESC INTO W_IN_SEQ;
	CLOSE C_SEQ_DESC;
  
  	W_IN_SEQ := NVL(W_IN_SEQ,0)+1;
  	:NEW.GRD_IN_SEQUENCIA := W_IN_SEQ;
	
  END IF;
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_CURRICULO BEFORE
  INSERT or UPDATE ON TBL_CURRICULO FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/

CREATE OR REPLACE TRIGGER TRG_BIU_HORARIO_SEMANA BEFORE
  INSERT or UPDATE ON TBL_HORARIO_SEMANA FOR EACH ROW
BEGIN 
  PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
END;
/


CREATE OR REPLACE FUNCTION FC_SOMA_HORA_CURRICULO (PI_CURR_IN_ID INTEGER) RETURN NUMBER IS
  CURSOR C_DISC_CH  IS
  SELECT SUM(DISC_IN_CARGA_HORARIA)
    FROM TBL_DISCIPLINA D
	   , TBL_GRADE G
   WHERE D.DISC_IN_ID = G.DISC_IN_ID
     AND G.CURR_IN_ID = PI_CURR_IN_ID;
  W_TOT_IN_CARGA_HORARIA NUMBER;
BEGIN 
	OPEN C_DISC_CH;
	FETCH C_DISC_CH INTO W_TOT_IN_CARGA_HORARIA;
	CLOSE C_DISC_CH;
	RETURN W_TOT_IN_CARGA_HORARIA;
END;
/

show errors;

ALTER TABLE TBL_DISCIPLINA
  ADD DISC_IN_CARGA_HRPRATICA NUMBER;

ALTER TABLE TBL_DISCIPLINA
  MODIFY DISC_IN_CARGA_HORARIA NULL;  

ALTER TABLE TBL_GRADE
  ADD GRD_IN_CARGA_HRPRATICA NUMBER;

ALTER TABLE TBL_GRADE
  ADD GRD_IN_CARGA_HORARIA NUMBER;  

ALTER TABLE TBL_ALUNO_CURSO
  ADD TUR_IN_ID INTEGER;

ALTER TABLE TBL_ALUNO_CURSO
  ADD CONSTRAINT FK_ACUR_TURMA FOREIGN KEY (TUR_IN_ID) REFERENCES TBL_TURMA;
  
CREATE OR REPLACE FUNCTION FC_SOMA_HRPRATICA_CURRICULO (PI_CURR_IN_ID INTEGER) RETURN NUMBER IS
  CURSOR C_DISC_CH  IS
  SELECT SUM(DISC_IN_CARGA_HRPRATICA)
    FROM TBL_DISCIPLINA D
	   , TBL_GRADE G
   WHERE D.DISC_IN_ID = G.DISC_IN_ID
     AND G.CURR_IN_ID = PI_CURR_IN_ID;
  W_TOT_IN_CARGA_HORARIA NUMBER;
BEGIN 
	OPEN C_DISC_CH;
	FETCH C_DISC_CH INTO W_TOT_IN_CARGA_HORARIA;
	CLOSE C_DISC_CH;
	RETURN W_TOT_IN_CARGA_HORARIA;
END;
/

show errors;

CREATE OR REPLACE PROCEDURE PC_POPULA_FERIADO_CALENDARIO(P_ANO INTEGER, P_INST_IN_ID INTEGER) IS
  CURSOR C_FERI IS SELECT * FROM TBL_FERIADO;
  W_CALE_IN_ID TBL_CALENDARIO.CALE_IN_ID%TYPE;
BEGIN
  FOR CL IN C_FERI LOOP
    BEGIN
	  SELECT SQ_CALENDARIO.NEXTVAL INTO W_CALE_IN_ID FROM DUAL;
	  INSERT INTO TBL_CALENDARIO(
		CALE_IN_ID, 
		CALE_IN_ANO, 
		INST_IN_ID, 
		CALE_ST_DESCRICAO, 
		CALE_DT_INICIO, 
		CALE_DT_FIM, 
		CALE_IN_TIPO_DATA, 
		USER_ST_ATUALIZA, 
		USER_DT_ATUALIZA)
	  VALUES (
		W_CALE_IN_ID, 
		P_ANO, 
		P_INST_IN_ID, 
		CL.FER_ST_NOME, 
		TO_DATE(P_ANO||LPAD(TO_CHAR(CL.FER_IN_MES),2,'0')||LPAD(TO_CHAR(CL.FER_IN_DIA),2,'0'),'YYYYMMDD'),
		TO_DATE(P_ANO||LPAD(TO_CHAR(CL.FER_IN_MES),2,'0')||LPAD(TO_CHAR(CL.FER_IN_DIA),2,'0'),'YYYYMMDD'),
		2,
		'ADMIN',
		SYSDATE);
	END;
  END LOOP;
END;
/
SHOW ERRORS;

CREATE OR REPLACE FUNCTION FC_DISCIPLINA_HORA_SEMANA(PI_TUR_IN_ID INTEGER, PI_DISC_IN_ID INTEGER) RETURN INTEGER IS
W_TOT_AULA_SEMANA INTEGER;
BEGIN
  SELECT COUNT(*) INTO W_TOT_AULA_SEMANA
    FROM TBL_HORARIO_SEMANA
   WHERE DISC_IN_ID = PI_DISC_IN_ID
     AND TUR_IN_ID = PI_TUR_IN_ID;
  RETURN W_TOT_AULA_SEMANA;
END; 
/
SHOW ERRORS;

@POPULA_REFERENCIAS.SQL;
@POPULA_PAISES_CENSO.SQL;
@POPULA_UFS_CENSO.SQL;
@POPULA_MUNIS_CENSO.SQL;
@POPULA_FERIADOS.SQL;
@VW_DOCENTE.SQL;
@VW_ALUNO.SQL;
@VW_CURSO_TURNO.SQL;
@VW_CURSO_DOCENTE.SQL;
@VW_CURSO_ALUNO.SQL;

spool off;



