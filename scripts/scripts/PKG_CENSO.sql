drop package body pkg_censo;
drop package pkg_censo;

create or replace package pkg_censo is
    w_nu_rgm 				number(6) := 999;
	w_nu_regdocente 		number(6) := 999;
	W_SQLERRM              	VARCHAR2(2000);
	v_inst_in_id			tbl_instituicao.inst_in_id%type := 1;
	v_periodicidade			tbl_curso.cur_in_periodicidade%type := 7;
	v_modalidade			tbl_curso.cur_in_modalidade%type := 1;
	v_grau					tbl_curso.cur_in_grau%type :=  1;
	w_number				number;
	
	procedure importa_arquivo ( p_censo_st_nomearquivo 	in varchar2,
								p_censo_in_anorefe     	in number,
							    po_censo_in_id          out number);
	procedure consiste_arquivo (p_censo_in_id          	in number);
	procedure valida_arquivo(	p_censo_in_id 			in number);
	procedure invalida_arquivo(	p_censo_in_id 			in number);
	function curriculo_vigente( p_cur_in_id				in number) return number;
	function get_id_docente_cpf(p_cpf in number) return number;
	                            
end;
/
show errors;


create or replace package body pkg_censo is

	function curriculo_vigente( p_cur_in_id				in number) return number is
		cursor c_curriculo_vig is
			select curr_in_id, curr_dt_vigencia_ini
			  from tbl_curriculo
			 where cur_in_id = p_cur_in_id
			   and curr_in_situacao = 1
			 order by 2 desc;
		w_curr_in_id tbl_curriculo.curr_in_id%type;
		w_curr_dt_vigencia_ini tbl_curriculo.curr_dt_vigencia_ini%type;
		begin
			open c_curriculo_vig;
			fetch c_curriculo_vig into w_curr_in_id, w_curr_dt_vigencia_ini;
			close c_curriculo_vig;
			return w_curr_in_id;			
		end;
		
	function blob_to_clob(p_blob_in in blob) return clob is
		w_file_clob clob;
		w_file_size integer := dbms_lob.lobmaxsize;
		w_dest_offset integer := 1;
		w_src_offset integer := 1;
		w_blob_csid number := dbms_lob.default_csid;
		w_lang_context number := dbms_lob.default_lang_ctx;
		w_warning integer;
		w_length number;
		w_sqlerrm varchar2(1000);
	begin
		dbms_lob.createtemporary(w_file_clob, true);
		dbms_lob.converttoclob(w_file_clob,
			p_blob_in,
			w_file_size,
			w_dest_offset,
			w_src_offset,
			w_blob_csid,
			w_lang_context,
			w_warning);

		return w_file_clob;

	exception
		when others then
			w_sqlerrm := sqlerrm;
			raise_application_error(-20051,w_sqlerrm);

	end;

	function clob_to_blob(p_clob_in in clob) return blob is
		w_file_blob    blob;
		w_file_size    integer := dbms_lob.lobmaxsize;
		w_dest_offset  integer := 1;
		w_src_offset   integer := 1;
		w_blob_csid    number := dbms_lob.default_csid;
		w_lang_context number := dbms_lob.default_lang_ctx;
		w_warning      integer;
		w_length       number;
		w_sqlerrm      varchar2(1000);
	begin
		dbms_lob.createtemporary(w_file_blob, true);
		dbms_lob.converttoblob(w_file_blob,
			p_clob_in,
			w_file_size,
			w_dest_offset,
			w_src_offset,
			w_blob_csid,
			w_lang_context,
			w_warning);

		return w_file_blob;

	exception
		when others then
			w_sqlerrm := sqlerrm;
			raise_application_error(-20052,w_sqlerrm);

	end;
	
	function get_pais_in_id(pi_pais_st_sigla in varchar2) return tbl_pais.pais_in_id%type is
	w_pais_in_id tbl_pais.pais_in_id%type;
	begin
		select pais_in_id 
		  into w_pais_in_id
		  from tbl_pais
		 where pais_st_codigo_censo = pi_pais_st_sigla;
		return w_pais_in_id;
	end;
	
	function get_cur_in_id(pi_in_curso_emec in integer) return tbl_curso.cur_in_id%type is
	w_cur_in_id tbl_curso.cur_in_id%type;
	begin
		select cur_in_id
		  into w_cur_in_id
		  from tbl_curso
		 where cur_in_emec = pi_in_curso_emec;
		 return w_cur_in_id;
	end;

	function get_id_docente_cpf(p_cpf in number) return number is
		w_doce_in_id tbl_docente.doce_in_id%type;
	begin
		select doce_in_id into w_doce_in_id
		  from tbl_docente 
		 where doce_in_cpf = p_cpf;
		 return w_doce_in_id;
	exception when no_data_found then return null;
	end;
	
	procedure importa_arquivo (p_censo_st_nomearquivo in varchar2,
                               p_censo_in_anorefe     in number,
							   po_censo_in_id         out number) is
		w_user_st_atualiza     varchar2(30);
		w_user_dt_atualiza     date;
		w_anex_in_id           integer;
		w_clob                 clob;
		CURSOR C_CONTENT IS
		SELECT BLOB_CONTENT, 
		       NAME, 
			   FILENAME, 
			   MIME_TYPE, 
			   DBMS_LOB.GETLENGTH(BLOB_CONTENT) TAMANHO 
		  FROM APEX_APPLICATION_TEMP_FILES
		 WHERE NAME = p_censo_st_nomearquivo;
	begin
		pc_atualiza_usuario(w_user_st_atualiza, w_user_dt_atualiza);
		FOR CL IN C_CONTENT LOOP  
			select sq_censo_arquivo.nextval into w_anex_in_id from dual;
            -- w_clob := BLOB_TO_CLOB(CL.BLOB_CONTENT);
			BEGIN   
				insert into tbl_censo_arquivo(censo_in_id, 
                        censo_st_nomearquivo,
						censo_st_nomechave,
						censo_in_anorefe,
                        censo_bl_conteudo,
                        censo_st_mimetype,
                        censo_nu_tamanho,
						censo_in_situacao,
                        user_st_atualiza,
                        user_dt_atualiza)
				values  (w_anex_in_id,
				        CL.NAME,
                        CL.FILENAME,
						p_censo_in_anorefe,
                        CL.BLOB_CONTENT,
                        CL.MIME_TYPE,
                        CL.TAMANHO,
						1,
                        W_USER_ST_ATUALIZA,
                        W_USER_DT_ATUALIZA);
			END;
		END LOOP;
		po_censo_in_id := w_anex_in_id;
	end;  
	
	procedure valida_arquivo(p_censo_in_id in number) is
	begin
		update tbl_censo_arquivo
		   set censo_in_situacao = 2
		     , user_dt_atualiza = sysdate
			 , user_st_atualiza = user
		 where censo_in_id = p_censo_in_id;
	end;

	procedure invalida_arquivo(p_censo_in_id in number) is
	begin
		update tbl_censo_arquivo
		   set censo_in_situacao = 3
		     , user_dt_atualiza = sysdate
			 , user_st_atualiza = user
		 where censo_in_id = p_censo_in_id;
	end;
	
	function semestre_to_data(pi_in_semestreano varchar2) return date is
	w_sem varchar2(2);
	w_ano varchar2(4);
	w_data date;
	begin
		w_sem := substr(pi_in_semestreano,1,2);
		w_ano := substr(pi_in_semestreano,3,4);
		select to_date(case w_sem when '01' then '0101'||w_ano
		                          when '02' then '0108'||w_ano
					   else null
						end, 'DDMMYYYY') dataingresso
		  into w_data
		  from dual;	
        RETURN w_data;		  
	end;
	
	procedure consiste_arquivo(p_censo_in_id in number) is
		w_arr_linhas 					apex_application_global.vc_arr2;
		w_arr_colunas 					apex_application_global.vc_arr2;
		w_arr_ds_inconsistencia 		apex_application_global.vc_arr2;
		w_arr_vl_inconsistencia 		apex_application_global.vc_arr2;
		w_arr_curso_turno				apex_application_global.vc_arr2;
		w_arr_vagas_turno				apex_application_global.vc_arr2;
		w_turn_collection    			varchar2(32767);
		w_ds_inconsistencia 			varchar2(32767);
		w_vl_inconsistencia 			varchar2(32767);
		w_bl_conteudo 					blob;
		w_cl_conteudo 					clob;
		w_crlf       					VARCHAR2(2) := chr(10); --linefeed
		w_tamanho    					number := 1;
		w_posicaoinicial 				number := 1;
		w_ind       					integer := 0; -- posição da quebra de linha do clob
		w_indx      					binary_integer := 0; -- Índice da pl/sql table que armazena as linhas do arquivo
		w_st_deficiencias 				tbl_aluno.alu_st_deficiencia%type;
		w_reg_inconsistente 			boolean := false;
		w_sqlerrm   					varchar2(4000);
		w_validar   					boolean;
		w_pais_in_id 					tbl_pais.pais_in_id%type;
		w_reg_acur 						tbl_aluno_curso%rowtype;
		w_reg_cur						tbl_curso%rowtype;
		w_reg_curso_turno				tbl_curso_turno%rowtype;
		w_reg_docente					tbl_docente%rowtype;
		w_alu_st_nome           		tbl_aluno.alu_st_nome%type;
		w_alu_in_id             		tbl_aluno.alu_in_id%type;
		w_st_tipoarquivo        		varchar2(30);
		w_in_atuacao            		integer;
		w_turn_in_id            		tbl_turno.turn_in_id%type;
		w_prazo_minimo_intgr	 		tbl_curriculo.curr_in_prazo_min_integra%type;
		w_curr_in_id					tbl_curriculo.curr_in_id%type;
		
		
		cursor c_arquivo is 
		select censo_bl_conteudo
  		  from tbl_censo_arquivo
		 where censo_in_id = p_censo_in_id;
		procedure salva_inconsistencias (P_LINHA NUMBER) is
		begin
			w_validar := false;
			if instr(w_ds_inconsistencia,':',1) > 0 then
				/* Mais que uma inconsistencia */
				w_arr_ds_inconsistencia := apex_util.string_to_table(w_ds_inconsistencia,':');
				w_arr_vl_inconsistencia := apex_util.string_to_table(w_vl_inconsistencia,':');
				for x in 1 .. w_arr_ds_inconsistencia.count loop
					begin
						INSERT INTO TBL_CENSO_INCONSISTENCIAS 
						(CENSO_IN_ID, CENSO_IN_LINHA, INCON_IN_ID, INCON_ST_DESCRICAO, INCON_ST_VALOR, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
						VALUES 
						(P_CENSO_IN_ID, P_LINHA, SQ_CENSO_INCONSISTENCIA.NEXTVAL, ' ('||w_arr_ds_inconsistencia(x)||')',w_arr_vl_inconsistencia(x), USER, SYSDATE);
					end;
				end loop;
			else
				begin
					INSERT INTO TBL_CENSO_INCONSISTENCIAS 
					(CENSO_IN_ID, CENSO_IN_LINHA, INCON_IN_ID, INCON_ST_DESCRICAO, INCON_ST_VALOR, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
					VALUES 
					(P_CENSO_IN_ID, P_LINHA, SQ_CENSO_INCONSISTENCIA.NEXTVAL, ' ('||w_ds_inconsistencia||')',w_vl_inconsistencia, USER, SYSDATE);
				end;
			end if;
			w_ds_inconsistencia := null;
			w_vl_inconsistencia := null;
			w_arr_ds_inconsistencia.delete;
			w_arr_vl_inconsistencia.delete;
		end;
		procedure verifica_inconsistencias_turno(p_idx_coluna integer) is
			w_arr_vagas_turno apex_application_global.vc_arr2;
			w_st_turno        tbl_turno.turn_st_descricao%type;
		begin
			w_st_turno := 'MATUTINO';
			w_arr_vagas_turno(8)  := 'Prazo Mínimo para Integralização no Turno Matutino';
			w_arr_vagas_turno(9)  := 'Número de Vagas Novas Oferecidas para o Turno Matutino';
			w_arr_vagas_turno(10) := 'Número de Vagas Remanescentes Oferecidas para o Turno Matutino';
			w_arr_vagas_turno(11) := 'Número de Vagas Oferecidas via Programas Especiais para o Turno Matutino';
			w_arr_vagas_turno(12) := 'Número de Inscritos em Vagas Novas Oferecidas para o Turno Matutino';
			w_arr_vagas_turno(13) := 'Número de Inscritos em Vagas Remanescentes Oferecidas para o Turno Matutino';
			w_arr_vagas_turno(14) := 'Número de Inscritos em Vagas Oferecidas via Programas Especiais para o Turno Matutino';
			w_st_turno := 'VESPERTINO';
			w_arr_vagas_turno(16) := 'Prazo Mínimo para Integralização '||w_st_turno;
			w_arr_vagas_turno(17) := 'Número de Vagas Novas Oferecidas '||w_st_turno;
			w_arr_vagas_turno(18) := 'Número de Vagas Remanescentes Oferecidas '||w_st_turno;
			w_arr_vagas_turno(19) := 'Número de Vagas Oferecidas via Programas Especiais '||w_st_turno;
			w_arr_vagas_turno(20) := 'Número de Inscritos em Vagas Novas Oferecidas '||w_st_turno;
			w_arr_vagas_turno(21) := 'Número de Inscritos em Vagas Remanescentes Oferecidas '||w_st_turno;
			w_arr_vagas_turno(22) := 'Número de Inscritos em Vagas Oferecidas via Programas Especiais '||w_st_turno;
			w_st_turno := 'NOTURNO';
			w_arr_vagas_turno(24) := 'Prazo Mínimo para Integralização '||w_st_turno;
			w_arr_vagas_turno(25) := 'Número de Vagas Novas Oferecidas '||w_st_turno;
			w_arr_vagas_turno(26) := 'Número de Vagas Remanescentes Oferecidas '||w_st_turno;
			w_arr_vagas_turno(27) := 'Número de Vagas Oferecidas via Programas Especiais '||w_st_turno;
			w_arr_vagas_turno(28) := 'Número de Inscritos em Vagas Novas Oferecidas '||w_st_turno;
			w_arr_vagas_turno(29) := 'Número de Inscritos em Vagas Remanescentes Oferecidas '||w_st_turno;
			w_arr_vagas_turno(30) := 'Número de Inscritos em Vagas Oferecidas via Programas Especiais '||w_st_turno;
			w_st_turno := 'INTEGRAL';
			w_arr_vagas_turno(32) := 'Prazo Mínimo para Integralização '||w_st_turno;
			w_arr_vagas_turno(33) := 'Número de Vagas Novas Oferecidas '||w_st_turno;
			w_arr_vagas_turno(34) := 'Número de Vagas Remanescentes Oferecidas '||w_st_turno;
			w_arr_vagas_turno(35) := 'Número de Vagas Oferecidas via Programas Especiais '||w_st_turno;
			w_arr_vagas_turno(36) := 'Número de Inscritos em Vagas Novas Oferecidas '||w_st_turno;
			w_arr_vagas_turno(37) := 'Número de Inscritos em Vagas Remanescentes Oferecidas '||w_st_turno;
			w_arr_vagas_turno(38) := 'Número de Inscritos em Vagas Oferecidas via Programas Especiais '||w_st_turno;
			w_st_turno := 'EAD';
			w_arr_vagas_turno(39) := 'Prazo Mínimo para Integralização '||w_st_turno;
			w_arr_vagas_turno(40) := 'Número de Vagas Novas Oferecidas '||w_st_turno;
			w_arr_vagas_turno(41) := 'Número de Vagas Remanescentes Oferecidas '||w_st_turno;
			w_arr_vagas_turno(42) := 'Número de Vagas Oferecidas via Programas Especiais '||w_st_turno;
			w_arr_vagas_turno(43) := 'Número de Inscritos em Vagas Novas Oferecidas '||w_st_turno;
			w_arr_vagas_turno(44) := 'Número de Inscritos em Vagas Remanescentes Oferecidas '||w_st_turno;
			w_arr_vagas_turno(45) := 'Número de Inscritos em Vagas Oferecidas via Programas Especiais '||w_st_turno;
			begin
			    DBMS_OUTPUT.PUT_LINE('w_arr_colunas['||p_idx_coluna||']'||W_ARR_COLUNAS(p_idx_coluna));
				w_number := to_number(w_arr_colunas(p_idx_coluna));
			exception 
			     when value_error or invalid_number then
					w_reg_inconsistente := true;
					if w_ds_inconsistencia is not null then
						w_ds_inconsistencia := w_ds_inconsistencia||p_idx_coluna||':Número de '||w_arr_vagas_turno(p_idx_coluna)||' deve ser numérico.';
						w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(p_idx_coluna);
					else
						w_ds_inconsistencia := 'Número de '||w_arr_vagas_turno(p_idx_coluna)||' deve ser numérico.';
						w_vl_inconsistencia := w_arr_colunas(p_idx_coluna);
					end if;
				when others then
					w_reg_inconsistente := true;
					w_sqlerrm           := sqlerrm;
					if w_ds_inconsistencia is not null then
						w_ds_inconsistencia := w_ds_inconsistencia||p_idx_coluna||': '||w_sqlerrm;
						w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(p_idx_coluna);
					else
						w_ds_inconsistencia := w_sqlerrm;
						w_vl_inconsistencia := w_arr_colunas(p_idx_coluna);
					end if;
			end;
		end;
	begin
	  w_validar := true;
	  delete from tbl_censo_inconsistencias
	   where censo_in_id = p_censo_in_id;
	  open c_arquivo;
	  fetch c_arquivo into w_bl_conteudo;
	  close c_arquivo;
	  w_cl_conteudo := blob_to_clob(w_bl_conteudo);
	  -- 
	  DBMS_OUTPUT.PUT_LINE(dbms_lob.getlength(w_cl_conteudo));
	  DBMS_OUTPUT.PUT_LINE(dbms_lob.instr(w_cl_conteudo, w_crlf, w_posicaoinicial, 1));
	  w_ind := 1; 
	  while dbms_lob.instr(w_cl_conteudo, w_crlf, w_posicaoinicial, 1) > 0 loop
	    w_ind := dbms_lob.instr(w_cl_conteudo, w_crlf, w_posicaoinicial, 1);
		dbms_output.put_line('w_ind => '||w_ind);
		w_tamanho := w_ind - w_posicaoinicial;
		w_indx := w_indx + 1;
		w_arr_linhas(w_indx) := DBMS_LOB.SUBSTR ( w_cl_conteudo, w_tamanho, w_posicaoinicial);
		w_posicaoinicial := w_ind+1;
	  end loop;
	  -- Armazena ultima linha do arquivo
	  w_tamanho := dbms_lob.getlength(w_cl_conteudo) - w_posicaoinicial;
	  w_indx := w_indx + 1;
	  w_arr_linhas(w_indx) := DBMS_LOB.SUBSTR ( w_cl_conteudo, w_tamanho, w_posicaoinicial);
 	  --
	  dbms_output.put_line('total de linhas : '||w_arr_linhas.count);
	  for i in 1 .. w_arr_linhas.count loop
	    if i <= 5 then
			dbms_output.put_line('linha ['||i||']=> '||w_arr_linhas(i));
		end if;
		w_arr_colunas := apex_util.string_to_table(w_arr_linhas(i),'|');
		w_ds_inconsistencia := null;
		w_vl_inconsistencia := null;
		w_arr_ds_inconsistencia.delete;
		w_arr_vl_inconsistencia.delete;
		if substr(w_arr_linhas(i),1,2) in ('21','31','32','41','42') then
			w_reg_inconsistente  := false;
		end if;
		-- Identifica o Tipo do Arquivo
		if substr(w_arr_linhas(i),1,2)='20' then
			-- Arquivo de Cursos
			w_st_tipoarquivo := 'Cursos';
			continue;
		elsif substr(w_arr_linhas(i),1,2)='30' then
			-- Arquivo de Docentes
			w_st_tipoarquivo := 'Docentes';
			continue;
		elsif substr(w_arr_linhas(i),1,2)='40' then
			-- Tipo de Arquivo Aluno
			w_st_tipoarquivo := 'Alunos';
			continue;
		elsif substr(w_arr_linhas(i),1,2)='41' then
		    -- Linha 41 contém informações do Aluno
			-- 
			/* exemplo: 41|400002165540|JOSE ADRIANO DE LIRA|06943279645||02071982|0|2|MARIA FRANCISCA FERREIRA DE LIRA|1|35|3550308|BRA|0||||||||||||| */
			-- Verificar Consistência dos Dados
			-- w_arr_colunas(1) := TIPO DO ARQUIVO;
			-- w_arr_colunas(2) := ID DO ALUNO NO EMEC;
			-- w_arr_colunas(3) := NOME;
			-- w_arr_colunas(4) := CPF;
			-- w_arr_colunas(5) := PASSAPORTE;
			-- w_arr_colunas(6) := Data de Nascimento;
			-- w_arr_colunas(7) := SEXO;
			-- w_arr_colunas(8) := COR/RAÇA;
			-- w_arr_colunas(9) := NOME COMPLETO DA MÃE;
			-- w_arr_colunas(10) := NACIONALIDADE;
			-- w_arr_colunas(11) := UF DE NASCIMENTO;
			-- w_arr_colunas(12) := MUNICIPIO DE NASCIMENTO;
			-- w_arr_colunas(13) := PAÍS DE ORIGEM;
			-- w_arr_colunas(14) := FLAG DE DEFICIENCIA;
			-- w_arr_colunas(15) := CEGUEIRA;
			-- w_arr_colunas(16) := BAIXA VISÃO;
			-- w_arr_colunas(17) := SURDEZ;
			-- w_arr_colunas(18) := DEFICIENCIA AUDITIVA;
			-- w_arr_colunas(19) := DEFICIENCIA FISICA;
			-- w_arr_colunas(20) := SURDOCEGUEIRA;
			-- w_arr_colunas(21) := MULTIPLA;
			-- w_arr_colunas(22) := INTELECTUAL;
			-- w_arr_colunas(23) := AUTISMO INFANTIL (TRANSTORNO GLOBAL DO DESENVOLVIMENTO);
			-- w_arr_colunas(24) := SINDROME DE ASPERGER (TRANSTORNO GLOBAL DO DESENVOLVIMENTO);
			-- w_arr_colunas(25) := SINDROME DE RETT (TRANSTORNO GLOBAL DO DESENVOLVIMENTO);
			-- w_arr_colunas(25) := TRANSTORNO DEGENERATIVO DA INFÂNCIA (TRANSTORNO GLOBAL DO DESENVOLVIMENTO);
			w_alu_st_nome := w_arr_colunas(3);
			-- w_arr_colunas(26) := ALTAS HABILIDADES SUPER DOTAÇÃO;
			if not fc_valida_cpf(w_arr_colunas(4)) = 1 then
				-- CPF Inválido
				w_reg_inconsistente := true;
				w_ds_inconsistencia := 'CPF Inválido';
				w_vl_inconsistencia := w_arr_colunas(4);
			end if;
				
			if to_date(w_arr_colunas(6),'DDMMYYYY') >= add_months(sysdate, (14*-12)) then
				-- Data de Nascimento não Aceita - Menor de 14 anos
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Data de Nascimento não aceita (Menor que 14 anos)';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(6);
				else
					w_ds_inconsistencia := 'Data de Nascimento não aceita (Menor que 14 anos)';
					w_vl_inconsistencia := w_arr_colunas(6);
				end if;
			end if;
			
			if w_arr_colunas(7) not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Sexo só pode conter os valores 0=Masculino; 1=Feminino';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(7);
				else
					w_ds_inconsistencia := 'Sexo só pode conter os valores 0=Masculino; 1=Feminino';
					w_vl_inconsistencia := w_arr_colunas(7);
				end if;
			end if;
			if w_arr_colunas(8) not in ('0','1','2','3','4','5','6') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Cor/Raça só pode conter os valores 0=Não quiz declarar; 1=Branca; 2=Preta; 3=Parda; 4=Amarela; 5=Indígena; 6=Não dispõe da informação';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(8);
				else
					w_ds_inconsistencia := 'Cor/Raça só pode conter os valores 0=Não quiz declarar; 1=Branca; 2=Preta; 3=Parda; 4=Amarela; 5=Indígena; 6=Não dispõe da informação';
					w_vl_inconsistencia := w_arr_colunas(8);
				end if;
			end if;
			
			if not w_reg_inconsistente then
				W_NU_RGM := W_NU_RGM + 1;
				w_st_deficiencias := null;
				if w_arr_colunas(14) = '1' then
					-- Aluno com deficiencia
					-- 1)Cegueira
					if w_arr_colunas(15) = '1' then
						w_st_deficiencias := '1';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 2)Baixa Visão
					if w_arr_colunas(16) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'2';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 3)Surdez
					if w_arr_colunas(17) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'3';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 4)Deficiência Auditiva
					if w_arr_colunas(18) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'4';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 5)Deficiência Física
					if w_arr_colunas(19) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'5';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 6)SurdoCegueira
					if w_arr_colunas(20) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'6';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 7)Multipla
					if w_arr_colunas(21) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'7';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 8)Intelectual
					if w_arr_colunas(22) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'8';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					
					-- 9)Autismo Infantil
					if w_arr_colunas(23) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'9';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 10)Sindrome de Asperger
					if w_arr_colunas(24) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'10';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 11)Sindrome de Rett
					if w_arr_colunas(25) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'11';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 13)Transtorno Degenerativo da Infância
					if w_arr_colunas(26) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'13';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 12)Altas Habilidades Super Dotação
					if w_arr_colunas(27) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'12';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
				else
					w_st_deficiencias := null;
				end if;
				
				w_pais_in_id:= get_pais_in_id(w_arr_colunas(13));
				
				BEGIN
					
					INSERT INTO TBL_ALUNO
					(ALU_IN_ID, ALU_IN_RGM, ALU_ST_NOME, ALU_ST_NOME_CENSO, ALU_IN_CPF, ALU_ST_PASSAPORTE,
					ALU_IN_NACIONALIDADE, ALU_DT_NASCIMENTO, ALU_IN_SEXO, ALU_IN_CORRACA, ALU_ST_NOME_MAE,
					ALU_ST_NOME_MAE_CENSO, ALU_IN_PAIS_ORIGEM, ALU_IN_UF_NASCIMENTO, ALU_IN_MUNI_NASCIMENTO, 
					ALU_IN_DEFICIENTE, ALU_ST_DEFICIENCIA, ALU_IN_CANHOTO, ALU_IN_OBITO, ALU_IN_ESCOLARIDADE)
					VALUES (SQ_ALUNO.NEXTVAL, W_NU_RGM, w_arr_colunas(3), w_arr_colunas(3), w_arr_colunas(4), w_arr_colunas(5),
		            1, w_arr_colunas(6), w_arr_colunas(7), w_arr_colunas(8), w_arr_colunas(9),
					w_arr_colunas(9), w_pais_in_id, w_arr_colunas(11), w_arr_colunas(12), 
					w_arr_colunas(14), w_st_deficiencias, 0, 0, 5) RETURNING ALU_IN_ID INTO W_ALU_IN_ID;
				EXCEPTION WHEN DUP_VAL_ON_INDEX THEN 
				    SELECT ALU_IN_ID INTO W_ALU_IN_ID
					  FROM TBL_ALUNO
					 WHERE ALU_IN_CPF = w_arr_colunas(4);
					WHEN OTHERS THEN
					W_SQLERRM := SQLERRM;
					w_reg_inconsistente := true;
					if w_ds_inconsistencia is not null then
						w_ds_inconsistencia := w_ds_inconsistencia||':PKG_CENSO.CONSISTE_ARQUIVO RAISE OTHERS_EXCEPTIONS Aluno:'||w_arr_colunas(3);
						w_vl_inconsistencia := w_vl_inconsistencia||':'||w_sqlerrm;
					else
						w_ds_inconsistencia := 'PKG_CENSO.CONSISTE_ARQUIVO RAISE OTHERS_EXCEPTIONS Aluno:'||w_arr_colunas(3);
						w_vl_inconsistencia := w_sqlerrm;
					end if;
					salva_inconsistencias(I);
				END;		
			else
				salva_inconsistencias(I);
			end if;
		elsif substr(w_arr_linhas(i),1,2)='42' then
			/* Vínculo Aluno X Curso */
			/* 42||71365|||1|3||||012013|1|1|0|0|0|0||0|0|0|0|0|||||0||||||0||||||||||||0|||||||0|||||||||2960|2268 */
			/* =============================== DESCRIÇÃO DOS CAMPOS =============================================
			1  Tipo do Registro
			2  Semestre de referência
			3  Código do curso
			4  Código do pólo do curso a distância
			5  ID na IES – identificação única do aluno na IES
			6  Turno do aluno
			7  Situação de vínculo do aluno ao curso
			8  Curso origem
			9  Semestre de conclusão do curso
			10 Aluno Parfor
			11 Semestre de ingresso no curso
			12 Tipo de escola que concluiu o Ensino Médio
			13 Forma de ingresso/seleção – vestibular
			14 Forma de ingresso/seleção – Enem
			15 Forma de ingresso/seleção – Avaliação Seriada
			16 Forma de ingresso/seleção – seleção simplificada
			17 Forma de ingresso/seleção – Egresso BI/LI
			18 Forma de ingresso/seleção – PEC-G
			19 Forma de ingresso/seleção – transferência ex officio
			20 Forma de ingresso/seleção – decisão judicial
			21 Forma de ingresso – seleção para vagas remanescentes
			22 Forma de ingresso – seleção para vagas de programas	especiais
			23 Mobilidade acadêmica
			24 Tipo de mobilidade acadêmica
			25 IES destino
			26 Tipo de mobilidade acadêmica internacional
			27 País destino
			28 Programa de reserva de vagas 0
			29 Programa de reserva de vagas/ações afirmativas – étnico
			30 Programa de reserva de vagas/ações afirmativas – pessoa com deficiência
			31 Programa de reserva de vagas – estudante procedente de escola pública
			32 Programa de reserva de vagas/ações afirmativas – social/renda familiar
			33 Programa de reserva de vagas/ações afirmativas – outros
			34 Financiamento estudantil 0
			35 Financiamento estudantil reembolsável – Fies
			36 Financiamento estudantil reembolsável – governo estadual
			37 Financiamento estudantil reembolsável – governo municipal
			38 Financiamento estudantil reembolsável – IES
			39 Financiamento estudantil reembolsável – entidades externas
			40 Tipo de financiamento não reembolsável – ProUni integral
			41 Tipo de financiamento não reembolsável – ProUni parcial
			42 Tipo de financiamento não reembolsável – entidades externas
			43 Tipo de financiamento não reembolsável – governo estadual
			44 Tipo de financiamento não reembolsável – IES
			45 Tipo de financiamento não reembolsável – governo municipal
			46 Apoio social 0
			47 Tipo de apoio social – alimentação
			48 Tipo de apoio social – moradia
			49 Tipo de apoio social – transporte
			50 Tipo de apoio social – material didático
			51 Tipo de apoio social – bolsa trabalho
			52 Tipo de apoio social – bolsa permanência
			53 Atividade extracurricular 0
			54 Atividade extracurricular – pesquisa
			55 Bolsa/remuneração referente à atividade extracurricular – pesquisa
			56 Atividade extracurricular – extensão
			57 Bolsa/remuneração referente à atividade extracurricular – extensão
			58 Atividade extracurricular – monitoria
			59 Bolsa/remuneração referente à atividade extracurricular – monitoria
			60 Atividade extracurricular – estágio não obrigatório 
			61 Bolsa/remuneração referente à atividade extracurricular – estágio não obrigatório
			62 Carga horária total do curso por aluno 1000
			63 Carga horária integralizada pelo aluno 100
			================================================================== */
			if w_arr_colunas(3) is null then
				w_validar := false;
				w_reg_inconsistente := true;
				w_ds_inconsistencia := 'Código EMEC do Curso Nulo';
				w_vl_inconsistencia := w_arr_colunas(3);
			else
				begin
					w_reg_acur.CUR_IN_ID := get_cur_in_id(to_number(w_arr_colunas(3))); -- Busca o id do curso pelo código EMEC
				exception when others then
					w_reg_inconsistente := true;
					w_validar := false;
					w_ds_inconsistencia := 'Código do Curso Inválido';
					w_vl_inconsistencia := w_arr_colunas(3);
				end;
			end if;
			
			w_reg_acur.ALU_IN_ID := w_alu_in_id;
			w_reg_acur.ACUR_DT_INGRESSO := semestre_to_data(w_arr_colunas(11));
			w_reg_acur.ACUR_DT_ULTIMA_MATRICULA := w_reg_acur.ACUR_DT_INGRESSO;
			w_reg_acur.ACUR_IN_SITUACAO := w_arr_colunas(7);
			if w_arr_colunas(13) = '1' then
				w_reg_acur.acur_in_ingresso := 1;
			elsif w_arr_colunas(14) = '1' then
				w_reg_acur.acur_in_ingresso := 2;
			elsif w_arr_colunas(15) = '1' then
				w_reg_acur.acur_in_ingresso := 3;
			elsif w_arr_colunas(16) = '1' then
				w_reg_acur.acur_in_ingresso := 4;
			elsif w_arr_colunas(17) = '1' then
				w_reg_acur.acur_in_ingresso := 5;
			elsif w_arr_colunas(18) = '1' then
				w_reg_acur.acur_in_ingresso := 6;
			elsif w_arr_colunas(19) = '1' then
				w_reg_acur.acur_in_ingresso := 7;
			elsif w_arr_colunas(20) = '1' then
				w_reg_acur.acur_in_ingresso := 8;
			elsif w_arr_colunas(21) = '1' then
				w_reg_acur.acur_in_ingresso := 9;
			elsif w_arr_colunas(22) = '1' then
				w_reg_acur.acur_in_ingresso := 10;
			else
				w_reg_acur.acur_in_ingresso := 1;
			end if;
			
			if w_arr_colunas(23) is not null then
				/* Mobilidade Academica */
				if w_arr_colunas(24) = '0' then
					/* Nacional */
					w_reg_acur.acur_in_mobdacad := 1;
					w_reg_acur.acur_in_mobdacad_iesdest := w_arr_colunas(25);
				else
					/* Internacional */
					w_reg_acur.acur_in_mobdacad := 2;
					w_reg_acur.acur_in_mobdacad_inter := w_arr_colunas(26);
					w_reg_acur.acur_in_mobdacad_paisdest := w_arr_colunas(27);
				end if;
			end if;
			
			if w_arr_colunas(34) = '1' then
				if w_arr_colunas(35) = '1' then
					w_reg_acur.acur_in_financiamento := 1;
				end if;
				if w_arr_colunas(36) = '1' then
					w_reg_acur.acur_in_financiamento := 2;
				end if;
				if w_arr_colunas(37) = '1' then
					w_reg_acur.acur_in_financiamento := 3;
				end if;
				if w_arr_colunas(38) = '1' then
					w_reg_acur.acur_in_financiamento := 4;
				end if;
				if w_arr_colunas(39) = '1' then
					w_reg_acur.acur_in_financiamento := 5;
				end if;
				if w_arr_colunas(40) = '1' then
					w_reg_acur.acur_in_financiamento := 6;
				end if;
				if w_arr_colunas(41) = '1' then
					w_reg_acur.acur_in_financiamento := 7;
				end if;
				if w_arr_colunas(42) = '1' then
					w_reg_acur.acur_in_financiamento := 8;
				end if;
				if w_arr_colunas(43) = '1' then
					w_reg_acur.acur_in_financiamento := 9;
				end if;
				if w_arr_colunas(44) = '1' then
					w_reg_acur.acur_in_financiamento := 10;
				end if;
				if w_arr_colunas(45) = '1' then
					w_reg_acur.acur_in_financiamento := 11;
				end if;		
			end if;

			if nvl(w_arr_colunas(46),'0') = '1' then
				if w_arr_colunas(47) = '1' then
					w_reg_acur.acur_in_apoio_social := 1;
				end if;
				if w_arr_colunas(48) = '1' then
					w_reg_acur.acur_in_apoio_social := 2;
				end if;
				if w_arr_colunas(49) = '1' then
					w_reg_acur.acur_in_apoio_social := 3;
				end if;
				if w_arr_colunas(50) = '1' then
					w_reg_acur.acur_in_apoio_social := 4;
				end if;
				if w_arr_colunas(51) = '1' then
					w_reg_acur.acur_in_apoio_social := 5;
				end if;
				if w_arr_colunas(52) = '1' then
					w_reg_acur.acur_in_apoio_social := 6;
				end if;
			end if;

			if nvl(w_arr_colunas(53),'0') = '1' then
				
				if w_arr_colunas(54) = '1' then
					w_reg_acur.acur_in_atividade_extra := 1;
				end if;
				if w_arr_colunas(56) = '1' then
					w_reg_acur.acur_in_atividade_extra := 2;
				end if;
				if w_arr_colunas(58) = '1' then
					w_reg_acur.acur_in_atividade_extra := 3;
				end if;
				if w_arr_colunas(60) = '1' then
					w_reg_acur.acur_in_atividade_extra := 4;
				end if;
				
				if w_arr_colunas(55) is not null then
					begin
					w_reg_acur.acur_nu_bolsa_pesquisa := to_number(w_arr_colunas(55));
					exception when others then
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':Valor Bolsa Pesquisa Informado não numérico';
							w_vl_inconsistencia := ':'||w_arr_colunas(55);
						else
							w_ds_inconsistencia := 'Valor Bolsa Pesquisa Informado não numérico';
							w_vl_inconsistencia := w_arr_colunas(55);
						end if;
						salva_inconsistencias(I);
					end;
				end if;

				if w_arr_colunas(57) is not null then
					begin
					w_reg_acur.acur_nu_bolsa_extensao := to_number(w_arr_colunas(57));
					exception when others then
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':Valor Bolsa Extensão Informado não numérico';
							w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(57);
						else
							w_ds_inconsistencia := 'Valor Bolsa Extensão Informado não numérico';
							w_vl_inconsistencia := w_arr_colunas(57);
						end if;
						salva_inconsistencias(I);
					end;
				end if;

				if w_arr_colunas(59) is not null then
					begin
					w_reg_acur.acur_nu_bolsa_monitoria := to_number(w_arr_colunas(59));
					exception when others then
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':Valor Bolsa Monitoria Informado não numérico';
							w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(59);
						else
							w_ds_inconsistencia := 'Valor Bolsa Monitoria Informado não numérico';
							w_vl_inconsistencia := w_arr_colunas(59);
						end if;
						salva_inconsistencias(I);
					end;
				end if;

				if w_arr_colunas(61) is not null then
					begin
					w_reg_acur.acur_nu_bolsa_estagio := to_number(w_arr_colunas(61));
					exception when others then
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':Valor Bolsa Estágio Informado não numérico';
							w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(61);
						else
							w_ds_inconsistencia := 'Valor Bolsa Estágio Informado não numérico';
							w_vl_inconsistencia := w_arr_colunas(61);
						end if;
						salva_inconsistencias(I);
					end;
				end if;
			
			end if;
			
			if not w_reg_inconsistente then
				begin
					insert into tbl_aluno_curso 
					(ACUR_IN_ID, CUR_IN_ID, ALU_IN_ID, ACUR_DT_INGRESSO, ACUR_DT_ULTIMA_MATRICULA,
					ACUR_IN_SITUACAO, ACUR_IN_INGRESSO, ACUR_IN_MOBDACAD, ACUR_IN_MOBDACAD_IESDEST, 
					ACUR_IN_MOBDACAD_INTER, ACUR_IN_MOBDACAD_PAISDEST, ACUR_IN_FINANCIAMENTO, ACUR_NU_BOLSA_PESQUISA, 
					ACUR_NU_BOLSA_EXTENSAO, ACUR_NU_BOLSA_MONITORIA, ACUR_NU_BOLSA_ESTAGIO, ACUR_IN_ATIVIDADE_EXTRA, 
					ACUR_IN_APOIO_SOCIAL, TUR_IN_ID)
					values
					(sq_curso_aluno.nextval, w_reg_acur.CUR_IN_ID, w_reg_acur.ALU_IN_ID, w_reg_acur.ACUR_DT_INGRESSO, w_reg_acur.ACUR_DT_ULTIMA_MATRICULA,
					w_reg_acur.ACUR_IN_SITUACAO, w_reg_acur.ACUR_IN_INGRESSO, w_reg_acur.ACUR_IN_MOBDACAD, w_reg_acur.ACUR_IN_MOBDACAD_IESDEST, 
					w_reg_acur.ACUR_IN_MOBDACAD_INTER, w_reg_acur.ACUR_IN_MOBDACAD_PAISDEST, w_reg_acur.ACUR_IN_FINANCIAMENTO, w_reg_acur.ACUR_NU_BOLSA_PESQUISA, 
					w_reg_acur.ACUR_NU_BOLSA_EXTENSAO, w_reg_acur.ACUR_NU_BOLSA_MONITORIA, w_reg_acur.ACUR_NU_BOLSA_ESTAGIO, w_reg_acur.ACUR_IN_ATIVIDADE_EXTRA, 
					w_reg_acur.ACUR_IN_APOIO_SOCIAL, w_reg_acur.TUR_IN_ID);
				exception 
					when dup_val_on_index then null;
				    when others then
						w_reg_inconsistente := true;
						W_SQLERRM := SQLERRM;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':PKG_CENSO.CONSISTE_ARQUIVO TBL_ALUNO_CURSO RAISE OTHERS_EXCEPTIONS Aluno_curso:'||w_arr_colunas(3);
							w_vl_inconsistencia := w_vl_inconsistencia||':'||w_sqlerrm;
						else
							w_ds_inconsistencia := 'PKG_CENSO.CONSISTE_ARQUIVO TBL_ALUNO_CURSO RAISE OTHERS_EXCEPTIONS Aluno_curso:'||w_arr_colunas(3);
							w_vl_inconsistencia := w_sqlerrm;
						end if;
						salva_inconsistencias(I);
				end;
			end if;
		elsif substr(w_arr_linhas(i),1,2) = '21' then
			-- Tratamento Curso
			--X 1 Tipo do registro 21
			--X 2 Código do curso no e-MEC 2137
			-- 3 Curso teve aluno vinculado em 2015? 1
			-- 4 Motivo de curso sem aluno vinculado em 2015
			--X 5 Curso representado por outro curso da IES
			-- 6 Curso financiado por convênio 0
			--X 7 Turno de funcionamento do curso – matutino 1
			--X 8 Prazo mínimo para integralização no turno matutino 4.0
			--X 9 Número de vagas novas oferecidas – turno matutino 100
			--X 10 Número de vagas remanescentes – turno matutino 50
			--X 11 Número de vagas oferecidas via programas especiais – turno matutino 600
			--X 12 Número de inscritos para vagas novas oferecidas – turno matutino 1000
			--X 13 Número de inscritos em vagas remanescentes – turno matutino 20
			--X 14 Número de inscritos em vagas oferecidas por programas especiais –
			--    turno matutino 40
			--X 15 Turno de funcionamento do curso – vespertino 0
			--X 16 Prazo mínimo para integralização no turno vespertino
			--X 17 Número de vagas novas oferecidas – turno vespertino
			--X 18 Número de vagas remanescentes – turno vespertino
			--X 19 Número de vagas oferecidas por programas especiais – turno vespertino
			--X 20 Número de inscritos para vagas novas oferecidas – turno vespertino
			--X 21 Número de inscritos em vagas remanescentes – turno vespertino
			--X 22 Número de inscritos em vagas oferecidas de programas especiais –
			--    turno vespertino
			--X 23 Turno de funcionamento do curso – noturno 1
			--X 24 Prazo mínimo para integralização no turno noturno 5.0
			--X 25 Número de vagas novas oferecidas – turno noturno 100
			--X 26 Número de vagas remanescentes – turno noturno 50
			--X 27 Número de vagas oferecidas de programas especiais – turno noturno 1000
			--X 28 Número de inscritos para vagas novas oferecidas – turno noturno 3000
			--X 29 Número de inscritos para número de vagas remanescentes – turno noturno 300
			--X 30 Número de inscritos para vagas oferecidas por programas especiais – turno noturno 100
			--X 31 Turno de funcionamento do curso – integral 0
			--X 32 Prazo mínimo para integralização no turno integral
			--X 33 Número de vagas novas oferecidas – turno integral
			--X 34 Número de vagas remanescentes – turno integral
			--X 35 Número de vagas oferecidas por programas especiais – turno integral
			--X 36 Número de inscritos para vagas novas oferecidas – turno integral
			--X 37 Número de inscritos para vagas remanescentes – turno integral
			--X 38 Número de inscritos para vagas oferecidas por programas especiais – turno integral
			--X 39 Prazo mínimo para integralização para EAD
			--X 40 Número de vagas novas oferecidas – EAD
			--X 41 Número de vagas remanescentes – EAD
			--X 42 Número de vagas oferecidas por programas especiais – EAD
			--X 43 Número de inscritos para vagas novas oferecidas – EAD
			--X 44 Número de inscritos para número de vagas remanescentes – EAD
			--X 45 Número de inscritos para vagas oferecidas por programas especiais –EAD
			-- 46 Condições de ensino-aprendizagem, por meio de tecnologia assistiva ou
			--    ajuda técnica a pessoas com deficiência 0
			-- 47 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    material em Braille
			-- 48 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    material em áudio
			-- 49 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    recursos de informática acessível
			-- 50 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    material em formato impresso em caractere ampliado
			-- 51 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    material pedagógico tátil
			-- 52 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    recursos de acessibilidade à comunicação
			-- 53 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    tradutor e intérprete de língua brasileira de sinais
			-- 54 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    guia intérprete
			-- 55 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    material didático em língua brasileira de sinais
			-- 56 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    inserção da disciplina de língua brasileira de sinais no curso
			-- 57 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    material didático em formato impresso acessível
			-- 58 Recursos de tecnologia assistiva disponíveis às pessoas com deficiência:
			--    material didático digital acessível
			-- 59 Utiliza instalações para aulas práticas (laboratórios)? 1
			-- 60 Oferece disciplina semipresencial? 1
			-- 61 Percentual de carga horária semipresencial 15			
			if w_arr_colunas(2) is null then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Código EMEC do curso não pode ser nulo.';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(2);
				else
					w_ds_inconsistencia := 'Código EMEC do curso não pode ser nulo.';
					w_vl_inconsistencia := w_arr_colunas(2);
				end if;
			else
				begin
					w_reg_cur.CUR_IN_ID := get_cur_in_id(to_number(w_arr_colunas(2))); -- Busca o id do curso pelo código EMEC
					if w_reg_cur.cur_in_id is null then
						select sq_curso.nextval into w_reg_cur.cur_in_id from dual;
					end if;
				exception when others then
					w_reg_inconsistente := true;
					if w_ds_inconsistencia is not null then
						w_ds_inconsistencia := w_ds_inconsistencia||':Código EMEC do curso inválido.';
						w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(2);
					else
						w_ds_inconsistencia := w_ds_inconsistencia||'Código EMEC do curso inválido.';
						w_vl_inconsistencia := w_arr_colunas(2);
					end if;
				end;
			end if;
			if w_arr_colunas(5) is not null then
				begin
					w_reg_cur.CUR_IN_ID := get_cur_in_id(to_number(w_arr_colunas(5))); -- Busca o id do curso pelo código EMEC
				exception when others then
					w_reg_inconsistente := true;
					if w_ds_inconsistencia is not null then
						w_ds_inconsistencia := w_ds_inconsistencia||':Código EMEC do curso Representado inválido.';
						w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(5);
					else
						w_ds_inconsistencia := w_ds_inconsistencia||'Código EMEC do curso Representado inválido.';
						w_vl_inconsistencia := w_arr_colunas(5);
					end if;
				end;
			end if;
			if nvl(w_arr_colunas(7),'0') not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Turno Matutino inválido.';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(7);
				else
					w_ds_inconsistencia := 'Turno Matutino inválido.';
					w_vl_inconsistencia := w_arr_colunas(7);
				end if;
			else
				if w_turn_collection is not null then
					w_turn_collection := w_turn_collection || ':1';
				else
					w_turn_collection := '1';
				end if;
			end if;
			if nvl(w_arr_colunas(15),'0') not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Turno Vespertino inválido.';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(15);
				else
					w_ds_inconsistencia := 'Turno Vespertino inválido.';
					w_vl_inconsistencia := w_arr_colunas(15);
				end if;
			else
				if w_turn_collection is not null then
					w_turn_collection := w_turn_collection || ':4';
				else
					w_turn_collection := '4';
				end if;
			end if;
			if nvl(w_arr_colunas(23),'0') not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Turno Noturno inválido.';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(23);
				else
					w_ds_inconsistencia := 'Turno Noturno inválido.';
					w_vl_inconsistencia := w_arr_colunas(23);
				end if;
			else
				if w_turn_collection is not null then
				w_turn_collection := w_turn_collection || ':2';
				else
					w_turn_collection := '2';
				end if;
			end if;
			if nvl(w_arr_colunas(31),'0') not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Turno Integral inválido.';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(31);
				else
					w_ds_inconsistencia := 'Turno Integral inválido.';
					w_vl_inconsistencia := w_arr_colunas(31);
				end if;
			else
				if w_turn_collection is not null then
					w_turn_collection := w_turn_collection || ':5';
				else
					w_turn_collection := '5';
				end if;
			end if;
			--
			if w_arr_colunas(7) = '1' then
				-- Se for informado Turno Matutino as colunas referentes a vagas deverão ser numéricas
				for t in 8 .. 14 loop
				    begin
						verifica_inconsistencias_turno(t);
					exception 
						when no_data_found then null;
					end;
				end loop;
			elsif w_arr_colunas(15) = '1' then
				for t in 16 .. 22 loop
				    begin
						verifica_inconsistencias_turno(t);
					exception 
						when no_data_found then null;
					end;
				end loop;
			elsif w_arr_colunas(23) = '1' then
				for t in 24 .. 30 loop
				    begin
						verifica_inconsistencias_turno(t);
					exception 
						when no_data_found then null;
					end;
				end loop;
			elsif w_arr_colunas(31) = '1' then
				for t in 32 .. 38 loop
				    begin
						verifica_inconsistencias_turno(t);
					exception 
						when no_data_found then null;
					end;
				end loop;
			end if;
			for t in 39 .. 45 loop
				/* EAD */
				if w_arr_colunas(t) is not null then
					begin
						verifica_inconsistencias_turno(t);
						if w_turn_collection is not null then
							w_turn_collection := w_turn_collection || ':3';
						else
							w_turn_collection := '3';
						end if;
					exception 
						when no_data_found then null;
					end;
				end if;
			end loop;
			if nvl(w_arr_colunas(46),'0') = '1' then
				/* Recursos de Tecnologia Assistiva */
				for t in 47 .. 58 loop
					if nvl(w_arr_colunas(t),'0') not in ('0','1') then
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':Recursos de tecnologia assistiva disponíveis às pessoas com deficiência Inválido.'||fc_referencia_descricao('CONDICAO_ENSINO_APRENDIZAGEM',(t-46));
							w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(t);
						else
							w_ds_inconsistencia := 'Recursos de tecnologia assistiva disponíveis às pessoas com deficiência Inválido.'||fc_referencia_descricao('CONDICAO_ENSINO_APRENDIZAGEM',(t-46));
							w_vl_inconsistencia := w_arr_colunas(t);
						end if;
					end if;
				end loop;
			end if;
			if nvl(w_arr_colunas(59),'0') not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Valor Inválido informado para Utiliza Laboratórios (S=1/N=0)?.';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(59);
				else
					w_ds_inconsistencia := 'Valor Inválido informado para Utiliza Laboratórios (S=1/N=0)?.';
					w_vl_inconsistencia := w_arr_colunas(59);
				end if;
			end if;
			if nvl(w_arr_colunas(60),'0') not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Valor Inválido [Oferece Disciplina semi-presencial (S=1/N=0)?.]';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(60);
				else
					w_ds_inconsistencia := 'Valor Inválido [Oferece Disciplina semi-presencial (S=1/N=0)?.]';
					w_vl_inconsistencia := w_arr_colunas(60);
				end if;
			elsif w_arr_colunas(60) = '1' then
				begin
					w_number := to_number(w_arr_colunas(61));
				exception
					when invalid_number or value_error then
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':Valor não Numérico [Percentual Carga Horária Semi-Presencial]';
							w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(61);
						else
							w_ds_inconsistencia := 'Valor não Numérico [Percentual Carga Horária Semi-Presencial]';
							w_vl_inconsistencia := w_arr_colunas(61);
						end if;
					when others then
					    w_sqlerrm := sqlerrm;
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':'||w_sqlerrm;
							w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(61);
						else
							w_ds_inconsistencia := w_sqlerrm;
							w_vl_inconsistencia := w_arr_colunas(61);
						end if;
				end;
			end if;
			if not w_reg_inconsistente then
				w_arr_curso_turno := apex_util.string_to_table(w_turn_collection,':');
				w_turn_collection := null;
				w_reg_cur.cur_in_emec := w_arr_colunas(2);
				w_reg_cur.cur_in_situacao := 1; -- aTIVO
				w_reg_cur.cur_in_representado := w_arr_colunas(5);
				w_reg_cur.cur_in_codigo_representa := null;
				w_reg_cur.cur_st_nome := 'Curso '||w_arr_colunas(2);
				w_reg_cur.CUR_ST_HABILITACAO := null;
				w_reg_cur.cur_st_portaria   := null;
				w_reg_cur.cur_st_autorizacao_mec := null;
				w_reg_cur.CUR_DT_AUTORIZACAO 		:= to_date(null);
				w_reg_cur.user_st_atualiza 			:= user;
				w_reg_cur.user_dt_atualiza 			:= sysdate;
				w_reg_cur.cur_in_periodicidade 		:= v_periodicidade; --Semestral
				w_reg_cur.cur_dt_publica_dou 			:= to_date(null);
				w_reg_cur.cur_in_modalidade  			:= v_modalidade;
				w_reg_cur.cur_in_grau 				:= v_grau;
				w_reg_cur.cur_in_inst_convenio 		:= w_arr_colunas(57);
				w_reg_cur.cur_in_cond_pessdef   		:=  w_arr_colunas(58);
				w_reg_cur.cur_in_utiliza_laboratorio   := w_arr_colunas(59);
				w_reg_cur.cur_in_disc_semipresencial   := w_arr_colunas(60);
				begin
					w_reg_cur.cur_nu_pctl_chsemipresencial := to_number(w_arr_colunas(61));
				exception
					when others then
					w_reg_cur.cur_nu_pctl_chsemipresencial := 0;
				end;
				
				
				begin
					insert into tbl_curso 
					( 	CUR_IN_ID , INST_IN_ID , CUR_IN_EMEC, CUR_IN_SITUACAO , CUR_IN_REPRESENTADO,
						CUR_IN_CODIGO_REPRESENTA, CUR_ST_NOME, CUR_ST_HABILITACAO, CUR_ST_PORTARIA,
						CUR_ST_AUTORIZACAO_MEC, CUR_DT_AUTORIZACAO, USER_ST_ATUALIZA, USER_DT_ATUALIZA,
						CUR_IN_PERIODICIDADE, CUR_DT_PUBLICA_DOU, CUR_IN_MODALIDADE, CUR_IN_GRAU,
						CUR_IN_INST_CONVENIO, CUR_IN_COND_PESSDEF, 
						CUR_IN_DISC_SEMIPRESENCIAL,	CUR_NU_PCTL_CHSEMIPRESENCIAL)
					values
					( 	w_reg_cur.CUR_IN_ID , v_inst_in_id , w_reg_cur.CUR_IN_EMEC, w_reg_cur.CUR_IN_SITUACAO , w_reg_cur.CUR_IN_REPRESENTADO,
						w_reg_cur.CUR_IN_CODIGO_REPRESENTA, w_reg_cur.CUR_ST_NOME, w_reg_cur.CUR_ST_HABILITACAO, w_reg_cur.CUR_ST_PORTARIA,
						w_reg_cur.CUR_ST_AUTORIZACAO_MEC, w_reg_cur.CUR_DT_AUTORIZACAO, USER, SYSDATE,
						w_reg_cur.CUR_IN_PERIODICIDADE, w_reg_cur.CUR_DT_PUBLICA_DOU, w_reg_cur.CUR_IN_MODALIDADE, w_reg_cur.CUR_IN_GRAU,
						w_reg_cur.CUR_IN_INST_CONVENIO, w_reg_cur.CUR_IN_COND_PESSDEF, 
						w_reg_cur.CUR_IN_DISC_SEMIPRESENCIAL,	w_reg_cur.CUR_NU_PCTL_CHSEMIPRESENCIAL);
				exception 
					when dup_val_on_index then
						update tbl_curso
						   set CUR_IN_INST_CONVENIO = w_reg_cur.cur_in_inst_convenio
							 , CUR_IN_COND_PESSDEF = w_reg_cur.CUR_IN_COND_PESSDEF
							 , CUR_IN_DISC_SEMIPRESENCIAL = w_reg_cur.cur_in_disc_semipresencial
							 , CUR_NU_PCTL_CHSEMIPRESENCIAL = w_reg_cur.cur_nu_pctl_chsemipresencial
						 where CUR_IN_ID = w_reg_cur.cur_in_id;
				    when others then 
					    w_sqlerrm := sqlerrm;
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':'||w_sqlerrm;
							w_vl_inconsistencia := w_vl_inconsistencia||':Update Curso ('||w_reg_cur.cur_in_inst_convenio||','
							                                       ||w_reg_cur.cur_in_cond_pessdef||','
																   ||w_reg_cur.cur_in_disc_semipresencial||','
																   ||w_reg_cur.cur_nu_pctl_chsemipresencial||')';
						else
							w_ds_inconsistencia := w_sqlerrm;
							w_vl_inconsistencia := 'Update Curso ('||w_reg_cur.cur_in_inst_convenio||','
							                                       ||w_reg_cur.cur_in_cond_pessdef||','
																   ||w_reg_cur.cur_in_disc_semipresencial||','
																   ||w_reg_cur.cur_nu_pctl_chsemipresencial||')';
						end if;
				end;
				
				for tc in 1 .. w_arr_curso_turno.count loop
					if w_arr_curso_turno(tc) = 1 then
						-- Matutino
						w_prazo_minimo_intgr     := to_number(w_arr_colunas(8));
						w_reg_curso_turno.in_vaga_nova := to_number(w_arr_colunas(9));
						w_reg_curso_turno.in_vaga_reman := to_number(w_arr_colunas(10));
						w_reg_curso_turno.in_vaga_progesp := to_number(w_arr_colunas(11));
						w_reg_curso_turno.in_inscrito_nova := to_number(w_arr_colunas(12));
						w_reg_curso_turno.in_inscrito_reman := to_number(w_arr_colunas(13));
						w_reg_curso_turno.in_inscrito_progesp := to_number(w_arr_colunas(14));
					elsif w_arr_curso_turno(tc) = 4 then
						-- Vespertino
						w_prazo_minimo_intgr    := to_number(w_arr_colunas(16));
						w_reg_curso_turno.in_vaga_nova := to_number(w_arr_colunas(17));
						w_reg_curso_turno.in_vaga_reman := to_number(w_arr_colunas(18));
						w_reg_curso_turno.in_vaga_progesp := to_number(w_arr_colunas(19));
						w_reg_curso_turno.in_inscrito_nova := to_number(w_arr_colunas(20));
						w_reg_curso_turno.in_inscrito_reman := to_number(w_arr_colunas(21));
						w_reg_curso_turno.in_inscrito_progesp := to_number(w_arr_colunas(22));
					elsif w_arr_curso_turno(tc) = 2 then
						-- Noturno
						w_prazo_minimo_intgr     := to_number(w_arr_colunas(24));
						w_reg_curso_turno.in_vaga_nova := to_number(w_arr_colunas(25));
						w_reg_curso_turno.in_vaga_reman := to_number(w_arr_colunas(26));
						w_reg_curso_turno.in_vaga_progesp := to_number(w_arr_colunas(27));
						w_reg_curso_turno.in_inscrito_nova := to_number(w_arr_colunas(28));
						w_reg_curso_turno.in_inscrito_reman := to_number(w_arr_colunas(29));
						w_reg_curso_turno.in_inscrito_progesp := to_number(w_arr_colunas(30));
					elsif w_arr_curso_turno(tc) = 5 then
						-- Integral
						w_prazo_minimo_intgr  := to_number(w_arr_colunas(32));
						w_reg_curso_turno.in_vaga_nova := to_number(w_arr_colunas(33));
						w_reg_curso_turno.in_vaga_reman := to_number(w_arr_colunas(34));
						w_reg_curso_turno.in_vaga_progesp := to_number(w_arr_colunas(35));
						w_reg_curso_turno.in_inscrito_nova := to_number(w_arr_colunas(36));
						w_reg_curso_turno.in_inscrito_reman := to_number(w_arr_colunas(37));
						w_reg_curso_turno.in_inscrito_progesp := to_number(w_arr_colunas(38));
					elsif w_arr_curso_turno(tc) = 3 then
						-- EAD
						w_prazo_minimo_intgr       := to_number(w_arr_colunas(39));
						w_reg_curso_turno.in_vaga_nova := to_number(w_arr_colunas(40));
						w_reg_curso_turno.in_vaga_reman := to_number(w_arr_colunas(41));
						w_reg_curso_turno.in_vaga_progesp := to_number(w_arr_colunas(42));
						w_reg_curso_turno.in_inscrito_nova := to_number(w_arr_colunas(43));
						w_reg_curso_turno.in_inscrito_reman := to_number(w_arr_colunas(44));
						w_reg_curso_turno.in_inscrito_progesp := to_number(w_arr_colunas(45));
					end if;
					begin
						select sq_curso_turno.nextval into w_reg_curso_turno.cturn_in_id from dual;
						insert into tbl_curso_turno(cturn_in_id, cur_in_id, turn_in_id, in_vaga_nova, in_vaga_reman, in_vaga_progesp,
						                            in_inscrito_nova, in_inscrito_reman, in_inscrito_progesp, user_st_atualiza, user_dt_atualiza)
						values (sq_curso_turno.nextval, w_reg_cur.cur_in_id, w_arr_curso_turno(tc), w_reg_curso_turno.in_vaga_nova, w_reg_curso_turno.in_vaga_reman, w_reg_curso_turno.in_vaga_progesp,
								w_reg_curso_turno.in_inscrito_nova, w_reg_curso_turno.in_inscrito_reman, w_reg_curso_turno.in_inscrito_progesp, user, sysdate);
					exception 
					     when dup_val_on_index then 
							null;
						 when others then
							w_sqlerrm := sqlerrm;
							w_reg_inconsistente := true;
							if w_ds_inconsistencia is not null then
								w_ds_inconsistencia := w_ds_inconsistencia||w_sqlerrm;
								w_vl_inconsistencia := ':Insert Curso Turno ('||w_reg_curso_turno.cturn_in_id||')';
							else
								w_vl_inconsistencia := 'Insert Curso Turno ('||w_reg_curso_turno.cturn_in_id||')';
						end if;
							  
					end;
					-- Identifica o Curriculo e salva o Prazo Mínimo de Integralização
					w_curr_in_id := curriculo_vigente(w_reg_cur.cur_in_id);
					begin
						update tbl_curriculo
						   set curr_in_prazo_min_integra = w_prazo_minimo_intgr
						     , curr_in_prazo_max_integra = round(w_prazo_minimo_intgr+(w_prazo_minimo_intgr/2))
							 , user_st_atualiza = user
							 , user_dt_atualiza = sysdate
						 where curr_in_id = w_curr_in_id;
					exception
						 when others then
							w_sqlerrm := sqlerrm;
							w_reg_inconsistente := true;
							if w_ds_inconsistencia is not null then
								w_ds_inconsistencia := w_ds_inconsistencia||':'||w_sqlerrm;
								w_vl_inconsistencia := w_vl_inconsistencia||':Update tbl_curriculo ('||w_curr_in_id||')';
							else
								w_vl_inconsistencia := 'Update tbl_curriculo ('||w_curr_in_id||')';
						end if;
					end;
				end loop;
				if w_reg_inconsistente then
					salva_inconsistencias(I);
				end if;
			else
				salva_inconsistencias(I);
			end if;
		elsif substr(w_arr_linhas(i),1,2) = '31' then
			-- Tratamento Docente
			-- 1 Tipo do registro 31
			-- 2 ID do docente na IES
			-- 3 Nome JOSE OLIVEIRA
			-- 4 CPF 00288822201
			-- 5 Documento de estrangeiro
			-- 6 Data de nascimento 25021980
			-- 7 Sexo 0
			-- 8 Cor/Raça 0
			-- 9 Nome completo da mãe LUCIA VIERA
			--10 Nacionalidade 1
			--11 País de origem BRA
			--12 UF de nascimento 14
			--13 Município de nascimento 1400027
			--14 Docente com deficiência 0
			--15 Tipo de deficiência – cegueira
			--16 Tipo de deficiência – visão subnormal ou baixa visão
			--17 Tipo de deficiência – surdez
			--18 Tipo de deficiência – auditiva
			--19 Tipo de deficiência – física
			--20 Tipo de deficiência – surdocegueira
			--21 Tipo de deficiência – múltipla
			--22 Tipo de deficiência – intelectual
			--23 Escolaridade 2
			--24 Pós-graduação 2
			--25 Situação do docente na IES 1
			--26 Docente em exercício em 31/12/2012 na IES 1
			--27 Regime de trabalho 3
			--28 Docente substituto 1
			--29 Docente visitante
			--30 Tipo de vínculo de docente visitante à IES
			--31 Atuação do docente – ensino em curso sequencial de
			--32 Atuação do docente – ensino em curso de graduação presencial 1
			--33 Atuação do docente – ensino em curso de graduação a distância 0
			--34 Atuação do docente – ensino de pós-graduação stricto sensu presencial 0
			--35 Atuação do Docente – ensino de pós-graduação stricto sensu a distância 0
			--36 Atuação do docente – pesquisa 0
			--37 Atuação do docente – extensão 0
			--38 Atuação do docente – gestão, planejamento e avaliação 0
			--39 Bolsa de pesquisa 0
			if not fc_valida_cpf(w_arr_colunas(4)) = 1 then
				-- CPF Inválido
				w_reg_inconsistente := true;
				w_ds_inconsistencia := 'CPF Inválido';
				w_vl_inconsistencia := w_arr_colunas(4);
			end if;
				
			if to_date(w_arr_colunas(6),'DDMMYYYY') >= add_months(sysdate, (14*-12)) then
				-- Data de Nascimento não Aceita - Menor de 14 anos
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Data de Nascimento não aceita (Menor que 14 anos)';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(6);
				else
					w_ds_inconsistencia := 'Data de Nascimento não aceita (Menor que 14 anos)';
					w_vl_inconsistencia := w_arr_colunas(6);
				end if;
			end if;
			
			if w_arr_colunas(7) not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Sexo só pode conter os valores 0=Masculino; 1=Feminino';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(7);
				else
					w_ds_inconsistencia := 'Sexo só pode conter os valores 0=Masculino; 1=Feminino';
					w_vl_inconsistencia := w_arr_colunas(7);
				end if;
			end if;
			if w_arr_colunas(8) not in ('0','1','2','3','4','5','6') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Cor/Raça só pode conter os valores 0=Não quiz declarar; 1=Branca; 2=Preta; 3=Parda; 4=Amarela; 5=Indígena; 6=Não dispõe da informação';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(8);
				else
					w_ds_inconsistencia := 'Cor/Raça só pode conter os valores 0=Não quiz declarar; 1=Branca; 2=Preta; 3=Parda; 4=Amarela; 5=Indígena; 6=Não dispõe da informação';
					w_vl_inconsistencia := w_arr_colunas(8);
				end if;
			end if;
			if w_arr_colunas(23) not in ('1','2','3','4','5','6') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Escolaridade Inválida';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(23);
				else
					w_ds_inconsistencia := 'Escolaridade Inválida';
					w_vl_inconsistencia := w_arr_colunas(23);
				end if;
			end if;
			if w_arr_colunas(24) not in ('1','2','3','4','5','6') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Pós-Graduação invalida';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(24);
				else
					w_ds_inconsistencia := 'Pós-Graduação invalida';
					w_vl_inconsistencia := w_arr_colunas(24);
				end if;
			end if;
			if w_arr_colunas(25) not in ('1','2','3','4','5') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Situação do Docente na IES Inválida';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(25);
				else
					w_ds_inconsistencia := 'Situação do Docente na IES Inválida';
					w_vl_inconsistencia := w_arr_colunas(25);
				end if;
			end if;
			if nvl(w_arr_colunas(26),'0') not in ('1','0') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Docente em Exercício deve conter os valores 1=Sim ou 0=Não';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(26);
				else
					w_ds_inconsistencia := 'Docente em Exercício deve conter os valores 1=Sim ou 0=Não';
					w_vl_inconsistencia := w_arr_colunas(26);
				end if;
			end if;
			if nvl(w_arr_colunas(30),'1') not in ('1','2','3','4') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Tipo de Vínculo do Docente Inválido';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(30);
				else
					w_ds_inconsistencia := 'Tipo de Vínculo do Docente Inválido';
					w_vl_inconsistencia := w_arr_colunas(30);
				end if;
			end if;
			for atuacao in 31 .. 38 loop
				if w_arr_colunas(atuacao) not in ('0','1') then
					w_reg_inconsistente := true;
					if w_ds_inconsistencia is not null then
						w_ds_inconsistencia := w_ds_inconsistencia||':Atuação Inválida';
						w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(atuacao);
					else
						w_ds_inconsistencia := 'Atuação Inválida('||atuacao||')';
						w_vl_inconsistencia := w_arr_colunas(atuacao);
					end if;
				elsif w_arr_colunas(atuacao) = '1' then
					w_in_atuacao := atuacao - 30;
					exit;
				end if;
				
			end loop;
			
			dbms_output.put_line('w_arr_colunas(30)=>'||w_arr_colunas(30));
			dbms_output.put_line('w_arr_colunas(38)=>'||w_arr_colunas(38));
			dbms_output.put_line('w_arr_colunas(39)=>'||w_arr_colunas(39));
			if w_arr_colunas(39) is not null and w_arr_colunas(39) not in ('0','1') then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := w_ds_inconsistencia||':Valor Informado para Bolsa de Pesquisa (S/N) Inválido; Valores Permitidos nulo 0 e 1.';
					w_vl_inconsistencia := w_vl_inconsistencia||':'||w_arr_colunas(39);
				else
					w_ds_inconsistencia := 'Valor Informado para Bolsa de Pesquisa (S/N) Inválido; Valores Permitidos nulo 0 e 1.';
					w_vl_inconsistencia := w_arr_colunas(39);
				end if;
			end if;
			if not w_reg_inconsistente then
				W_NU_REGDOCENTE := W_NU_REGDOCENTE + 1;
				w_st_deficiencias := null;
				if w_arr_colunas(14) = '1' then
					-- Prof com deficiencia
					-- 1)Cegueira
					if w_arr_colunas(15) = '1' then
						w_st_deficiencias := '1';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 2)Baixa Visão
					if w_arr_colunas(16) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'2';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 3)Surdez
					if w_arr_colunas(17) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'3';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 4)Deficiência Auditiva
					if w_arr_colunas(18) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'4';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 5)Deficiência Física
					if w_arr_colunas(19) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'5';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 6)SurdoCegueira
					if w_arr_colunas(20) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'6';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 7)Multipla
					if w_arr_colunas(21) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'7';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
					-- 8)Intelectual
					if w_arr_colunas(22) = '1' then
						w_st_deficiencias := w_st_deficiencias ||'8';
					end if;
					if w_st_deficiencias is not null then
						w_st_deficiencias := w_st_deficiencias ||':';
					end if;
				end if;
				-- Carrega Registro

			-- Tratamento Docente
			-- 1 Tipo do registro 31
			-- 2 ID do docente na IES
			-- 3 Nome JOSE OLIVEIRA
			-- 4 CPF 00288822201
			-- 5 Documento de estrangeiro
			-- 6 Data de nascimento 25021980
			-- 7 Sexo 0
			-- 8 Cor/Raça 0
			-- 9 Nome completo da mãe LUCIA VIERA
			--10 Nacionalidade 1
			--11 País de origem BRA
			--12 UF de nascimento 14
			--13 Município de nascimento 1400027
			--14 Docente com deficiência 0
			--15 Tipo de deficiência – cegueira
			--16 Tipo de deficiência – visão subnormal ou baixa visão
			--17 Tipo de deficiência – surdez
			--18 Tipo de deficiência – auditiva
			--19 Tipo de deficiência – física
			--20 Tipo de deficiência – surdocegueira
			--21 Tipo de deficiência – múltipla
			--22 Tipo de deficiência – intelectual
			--23 Escolaridade 2
			--24 Pós-graduação 2
			--25 Situação do docente na IES 1
			--26 Docente em exercício em 31/12/2012 na IES 1
			--27 Regime de trabalho 3
			--28 Docente substituto 1
			--29 Docente visitante
			--30 Tipo de vínculo de docente visitante à IES
			--31 Atuação do docente – ensino em curso sequencial de
			--32 Atuação do docente – ensino em curso de graduação presencial 1
			--33 Atuação do docente – ensino em curso de graduação a distância 0
			--34 Atuação do docente – ensino de pós-graduação stricto sensu presencial 0
			--35 Atuação do Docente – ensino de pós-graduação stricto sensu a distância 0
			--36 Atuação do docente – pesquisa 0
			--37 Atuação do docente – extensão 0
			--38 Atuação do docente – gestão, planejamento e avaliação 0
			--39 Bolsa de pesquisa 0
				w_reg_docente.doce_in_id := get_id_docente_cpf(to_number(w_arr_colunas(4)));
				if w_reg_docente.doce_in_id is null then
					select sq_docente.nextval into w_reg_docente.doce_in_id FROM DUAL;
				end if;
				w_reg_docente.doce_st_nome          	:= w_arr_colunas(3);
				w_reg_docente.doce_in_cpf           	:= to_number(w_arr_colunas(4));
				w_reg_docente.doce_st_docestrangeiro 	:= w_arr_colunas(5);
				w_reg_docente.doce_dt_nascimento    	:= to_date(w_arr_colunas(6),'DDMMYYYY');
				w_reg_docente.doce_in_sexo          	:= w_arr_colunas(7);
				w_reg_docente.DOCE_IN_COR_RACA       	:= w_arr_colunas(8);
				w_reg_docente.doce_st_nome_mae      	:= w_arr_colunas(9);
				w_reg_docente.doce_in_nacionalidade 	:= w_arr_colunas(10);
				w_reg_docente.doce_in_pais_origem   	:= get_pais_in_id(w_arr_colunas(11));
				w_reg_docente.doce_in_uf_nascimento 	:= w_arr_colunas(12);
				w_reg_docente.doce_in_muni_nascimento 	:= w_arr_colunas(13);
				w_reg_docente.doce_in_deficiente    	:= w_arr_colunas(14);
				w_reg_docente.doce_st_deficiencia   	:= w_st_deficiencias;
				w_reg_docente.doce_in_escolaridade  	:= w_arr_colunas(23);
				w_reg_docente.doce_in_situacao      	:= w_arr_colunas(25);
				w_reg_docente.doce_in_exercicio3112 	:= w_arr_colunas(26);
				w_reg_docente.doce_in_regime        	:= w_arr_colunas(27);
				w_reg_docente.doce_in_substituto    	:= w_arr_colunas(28);
				w_reg_docente.doce_in_visitante			:= w_arr_colunas(29);
				w_reg_docente.doce_in_vinculo_visitante := w_arr_colunas(30);
				w_reg_docente.doce_in_atuacao       	:= w_in_atuacao;
				w_reg_docente.doce_in_bolsa_pesquisa  	:= w_arr_colunas(39);
				
				begin
					insert into tbl_docente
						(doce_in_id, doce_in_matricula, doce_st_nome, doce_in_cpf, doce_st_docestrangeiro, doce_dt_nascimento,
						 doce_in_sexo, DOCE_IN_COR_RACA, doce_St_nome_mae, doce_in_nacionalidade, doce_in_pais_origem, 
						 doce_in_uf_nascimento, doce_in_muni_nascimento, doce_in_deficiente, doce_st_deficiencia, doce_in_escolaridade, 
						 doce_in_situacao, doce_in_exercicio3112, doce_in_regime, doce_in_substituto, doce_in_vinculo_visitante, 
						 doce_in_atuacao, doce_in_bolsa_pesquisa)
					values
						(w_reg_docente.doce_in_id, W_NU_REGDOCENTE, w_reg_docente.doce_st_nome, w_reg_docente.doce_in_cpf, w_reg_docente.doce_st_docestrangeiro, w_reg_docente.doce_dt_nascimento,
						 w_reg_docente.doce_in_sexo, w_reg_docente.DOCE_IN_COR_RACA, w_reg_docente.doce_st_nome_mae, w_reg_docente.doce_in_nacionalidade, w_reg_docente.doce_in_pais_origem,
						 w_reg_docente.doce_in_uf_nascimento, w_reg_docente.doce_in_muni_nascimento, w_reg_docente.doce_in_deficiente, w_reg_docente.doce_st_deficiencia, w_reg_docente.doce_in_escolaridade,
						 w_reg_docente.doce_in_situacao, w_reg_docente.doce_in_exercicio3112, w_reg_docente.doce_in_regime, w_reg_docente.doce_in_substituto, w_reg_docente.doce_in_vinculo_visitante,
						 w_reg_docente.doce_in_atuacao, w_reg_docente.doce_in_bolsa_pesquisa);
				exception
					when dup_val_on_index then
						update tbl_docente
						   set doce_st_nome = w_reg_docente.doce_st_nome
						     , doce_in_situacao = w_reg_docente.doce_in_situacao
							 , doce_in_exercicio3112 = w_reg_docente.doce_in_exercicio3112
							 , doce_in_regime = w_reg_docente.doce_in_regime
							 , doce_in_substituto = w_reg_docente.doce_in_substituto
							 , doce_in_vinculo_visitante = w_reg_docente.doce_in_vinculo_visitante
							 , doce_in_atuacao = w_in_atuacao
							 , doce_in_bolsa_pesquisa = w_reg_docente.doce_in_bolsa_pesquisa
						 where doce_in_id = w_reg_docente.doce_in_id;
					when others then
						w_sqlerrm := sqlerrm;
						w_reg_inconsistente := true;
						if w_ds_inconsistencia is not null then
							w_ds_inconsistencia := w_ds_inconsistencia||':'||w_sqlerrm;
							w_vl_inconsistencia := w_vl_inconsistencia||':Update Docente ('||w_reg_docente.doce_in_id||')';
						else
							w_ds_inconsistencia := w_sqlerrm;
							w_vl_inconsistencia := 'Update Docente ('||w_reg_docente.doce_in_id||')';
						end if;
						salva_inconsistencias(I);
				end;
			else
				salva_inconsistencias(I);
			end if;
		elsif substr(w_arr_linhas(i),1,2) = '32' then
			-- Tratamento Docente X Curso
			begin
				w_number := to_number(w_arr_colunas(2));
			exception when others then
				w_reg_inconsistente := true;
				if w_ds_inconsistencia is not null then
					w_ds_inconsistencia := ':Código do Curso deve ser numérico';
					w_vl_inconsistencia := ':'||w_arr_colunas(2);
				else
					w_ds_inconsistencia := 'Código do Curso deve ser numérico';
					w_vl_inconsistencia := w_arr_colunas(2);
				end if;
				salva_inconsistencias(I);
			end;
			-- 
			begin
				insert into 
					tbl_docente_curso (dcur_in_id, doce_in_id, cur_in_id)
				values 
					(sq_curso_docente.nextval, w_reg_docente.doce_in_id, w_arr_colunas(2));
			exception
				when dup_val_on_index then null;
				when others then
					w_reg_inconsistente := true;
					w_sqlerrm := sqlerrm;
					if w_ds_inconsistencia is not null then
						w_ds_inconsistencia := ':DOCENTE x CURSO ('||w_sqlerrm||')';
						w_vl_inconsistencia := ':'||w_reg_docente.doce_in_id||','||w_arr_colunas(2);
					else
						w_ds_inconsistencia := 'DOCENTE x CURSO ('||w_sqlerrm||')';
						w_vl_inconsistencia := w_reg_docente.doce_in_id||','||w_arr_colunas(2);
					end if;
					salva_inconsistencias(I);
			end;
			--
		elsif length(w_arr_linhas(i)) > 0 then
			w_reg_inconsistente := true;
			if w_ds_inconsistencia is not null then
				w_ds_inconsistencia := w_ds_inconsistencia||':Tipo de Registro Inválido';
				w_vl_inconsistencia := w_vl_inconsistencia||':'||substr(w_arr_linhas(i),1,2);
			else
				w_ds_inconsistencia := 'Tipo de Registro Inválido';
				w_vl_inconsistencia := substr(w_arr_linhas(i),1,2);
			end if;
			salva_inconsistencias(I);
		
		end if;
				
	  end loop;
	  
	  if w_validar then
		VALIDA_ARQUIVO(P_CENSO_IN_ID);
	  else
	    INVALIDA_ARQUIVO(P_CENSO_IN_ID);
	  end if;
	  
	end;
begin
	dbms_session.set_nls('NLS_NUMERIC_CHARACTERS','".,"');
end;
    
/
show errors;

  