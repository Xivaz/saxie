drop package body pkg_aluno_util;
drop package pkg_aluno_util;

create or replace package pkg_aluno_util is
	procedure carrega_alunos;
end;
/

create or replace package body pkg_aluno_util is
  --
  function proximo_rgm return number is
	w_alu_in_rgm tbl_aluno.alu_in_rgm%type;
	begin
		select max(alu_in_rgm)+1 
		  into w_alu_in_rgm
		  from tbl_aluno;
		return w_alu_in_rgm;
	end;
	
  function referencia_codigo (p_refe_st_tipo varchar2, p_refe_st_descricao varchar2) return number is
    cursor c_refe_codigo is
    SELECT R.REFE_IN_CODIGO
      FROM TBL_REFERENCIA R
     WHERE UPPER(R.REFE_ST_DESCRICAO)=upper(p_refe_st_descricao)
       AND R.REFE_ST_TIPO = p_refe_st_tipo;
	w_refe_codigo tbl_referencia.refe_in_codigo%type;
  begin
	open c_refe_codigo;
	fetch c_refe_codigo into w_refe_codigo;
	close c_refe_codigo;
	return w_refe_codigo;
  end;
  
  procedure carrega_alunos is
    cursor c_alunos is
	select * from tbl_carga_alunos;
	W_ALU_ST_RNE			tbl_aluno.alu_st_rne%type;
	W_ALU_IN_NACIONALIDADE	tbl_aluno.alu_in_nacionalidade%type := 1;
	W_ALU_DT_NASCIMENTO		tbl_aluno.alu_dt_nascimento%type 	:= to_date('24/09/1990','dd/mm/yyyy');
	W_ALU_IN_SEXO			tbl_aluno.alu_in_sexo%type       	:= 1;
	W_ALU_IN_CORRACA		tbl_aluno.alu_in_corraca%type		:= 1;
	W_ALU_IN_PAIS_ORIGEM	tbl_aluno.alu_in_pais_origem%type 	:= 1;
	W_ALU_IN_UF_NASCIMENTO	tbl_aluno.alu_in_uf_nascimento%type	:= null;
	W_ALU_IN_DEFICIENTE		tbl_aluno.alu_in_deficiente%type	:=0;
	W_ALU_ST_DEFICIENCIA	tbl_aluno.alu_st_deficiencia%type	:= NULL;
	W_ALU_IN_OBITO			tbl_aluno.alu_in_obito%type 		:= 0;
	W_ALU_IN_ESCOLARIDADE	tbl_aluno.alu_in_escolaridade%type;
	W_PROXIMO_RGM			tbl_aluno.alu_in_rgm%type;
	W_ALU_IN_ID				tbl_aluno.alu_in_id%type;
	W_ALU_IN_CANHOTO		tbl_aluno.alu_in_canhoto%type := 0;
	w_cont_insert			number := 0;
	w_cont_update			number := 0;
	w_cont_fail			number := 0;
    begin
		for cl in c_alunos loop
			begin
				select sq_aluno.nextval into w_alu_in_id from dual;
				w_proximo_rgm := proximo_rgm;
				if cl.nacionalidade = 'BRASILEIRA' then
					W_ALU_IN_NACIONALIDADE := 1;
					W_ALU_ST_RNE := NULL;
				else
					W_ALU_IN_NACIONALIDADE := 3;
					W_ALU_ST_RNE := cl.rg;
				end if;
				W_ALU_IN_CORRACA := NVL(referencia_codigo('COR_RACA',cl.racacor),0);
				
				W_ALU_IN_PAIS_ORIGEM := 1;
				W_ALU_IN_UF_NASCIMENTO := 1;
				W_ALU_IN_ESCOLARIDADE  := 3;
			end;
			begin
				insert into tbl_aluno(ALU_IN_ID, 
							ALU_IN_RGM, 
							ALU_ST_NOME, 
							ALU_ST_NOME_CENSO,
							ALU_IN_CPF, 
							ALU_ST_RG, 
							ALU_ST_RNE, 
							ALU_IN_NACIONALIDADE, 
							ALU_IN_CANHOTO,
							ALU_DT_NASCIMENTO, 
							ALU_IN_SEXO, 
							ALU_IN_CORRACA, 
							ALU_IN_DEFICIENTE,
							ALU_IN_PAIS_ORIGEM, 
							ALU_IN_UF_NASCIMENTO, 
							ALU_IN_ESCOLARIDADE,
							ALU_IN_OBITO)
				values (	W_ALU_IN_ID, 
							w_proximo_rgm, 
							cl.nome, 
							UPPER(cl.nome), 
							cl.cpf, 
							cl.rg, 
							W_ALU_ST_RNE, 
							W_ALU_IN_NACIONALIDADE, 
							W_ALU_IN_CANHOTO,
							W_ALU_DT_NASCIMENTO,  
							W_ALU_IN_SEXO, 
							W_ALU_IN_CORRACA, 
							W_ALU_IN_DEFICIENTE,
							W_ALU_IN_PAIS_ORIGEM, 
							W_ALU_IN_UF_NASCIMENTO, 
							W_ALU_IN_ESCOLARIDADE,
							W_ALU_IN_OBITO);
				w_cont_insert := w_cont_insert + 1;
			exception 
				WHEN dup_val_on_index then
				update tbl_aluno
				   set alu_dt_nascimento = W_ALU_DT_NASCIMENTO
					 , alu_st_rg = cl.rg
					 , alu_in_nacionalidade = W_ALU_IN_NACIONALIDADE
					 , alu_in_sexo = W_ALU_IN_SEXO
				 where alu_in_cpf = cl.cpf;
				 w_cont_update := w_cont_update + 1;
				 when others then w_cont_fail := w_cont_fail + 1;
			end;
		end loop;
		
		dbms_output.put_line(' Total de Linhas Inseridas = '||w_cont_insert);
		dbms_output.put_line(' Total de Linhas Atualizadas = '||w_cont_update);
		dbms_output.put_line(' Total de Falhas = '||w_cont_fail);
	end;
  --
  end;
/

show errors;
/