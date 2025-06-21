drop table tbl_censo_arquivo cascade constraints;

create table tbl_censo_arquivo(censo_in_id          integer not null,
                               censo_st_nomearquivo varchar2(255) not null, 
                               censo_st_nomechave   varchar2(255) not null, 
							   censo_in_anorefe     number(8) not null,
                               censo_bl_conteudo    blob, 
							   censo_st_mimetype    varchar2(50),
							   censo_st_charset     varchar2(50),
							   censo_nu_tamanho     number,
							   censo_in_situacao    number,
                               user_st_atualiza     varchar2(30)  not null,
                               user_dt_atualiza     date          not null)
	tablespace TS_DATA
	pctfree 10
	initrans 1
	maxtrans 255
	storage
	(
		initial 64K
		next 1M
		minextents 1
		maxextents unlimited
	);

create SEQUENCE SQ_CENSO_ARQUIVO START WITH 1 INCREMENT BY 1 NOCACHE ORDER;
  
ALTER TABLE TBL_CENSO_ARQUIVO
  ADD CONSTRAINT PK_CENSO_ARQ PRIMARY KEY (CENSO_IN_ID) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  / 

ALTER TABLE TBL_CENSO_ARQUIVO
  ADD CONSTRAINT UK_CENSO_ARQNOME UNIQUE(CENSO_ST_NOMEARQUIVO) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  / 

drop table tbl_censo_inconsistencias cascade constraints;						   
create table tbl_censo_inconsistencias(censo_in_id integer       not null,
                               censo_in_linha      integer       not null,
                               incon_in_id         integer       not null,
                               incon_st_descricao  varchar2(255) not null,
                               incon_st_valor      varchar2(4000),
                               user_st_atualiza    varchar2(30)  not null,
                               user_dt_atualiza    date          not null)						   
	tablespace TS_DATA
	pctfree 10
	initrans 1
	maxtrans 255
	storage
	(
		initial 64K
		next 1M
		minextents 1
		maxextents unlimited
	);

create SEQUENCE SQ_CENSO_INCONSISTENCIA START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

ALTER TABLE TBL_CENSO_INCONSISTENCIAS
  ADD CONSTRAINT PK_CENSO_INCO PRIMARY KEY (INCON_IN_ID) 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0 FREELISTS 6 FREELIST GROUPS 2 BUFFER_POOL DEFAULT) 
  / 

ALTER TABLE TBL_CENSO_INCONSISTENCIAS
  ADD CONSTRAINT FK_CENSO_INCO_CENSO_ARQ FOREIGN KEY (CENSO_IN_ID) REFERENCES TBL_CENSO_ARQUIVO;
  
INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'SITUACAO_ARQUIVO_CENSO' , 1, 'Processando', 'ADMIN', SYSDATE);
  
INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'SITUACAO_ARQUIVO_CENSO' , 2, 'Importado com sucesso', 'ADMIN', SYSDATE);
  
INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'SITUACAO_ARQUIVO_CENSO' , 3, 'Inconsistente', 'ADMIN', SYSDATE);
  
INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'TIPO_ARQUIVO_CENSO' , 1, 'Curso', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'TIPO_ARQUIVO_CENSO' , 2, 'Docente', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'TIPO_ARQUIVO_CENSO' , 3, 'Aluno', 'ADMIN', SYSDATE);
