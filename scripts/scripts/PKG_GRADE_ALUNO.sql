create or replace package PKG_GRADE_ALUNO is
  procedure verifica_matricula (pi_acur_in_id in integer, po_alu_in_id out integer, po_cur_st_nome out varchar2, po_tur_st_codigo out varchar2);
end;
/
show errors;

create or replace package body PKG_GRADE_ALUNO is  
  procedure verifica_matricula (pi_acur_in_id in integer, po_alu_in_id out integer, po_cur_st_nome out varchar2, po_tur_st_codigo out varchar2) is
    cursor c_matricula is
    select acur.alu_in_id, cur.cur_st_nome, tur.tur_st_codigo
      from tbl_aluno_curso acur, tbl_matricula mat, tbl_curso cur, tbl_turma tur
     where mat.acur_in_id = acur.acur_in_id
       and cur.cur_in_id  = acur.cur_in_id
       and tur.tur_in_id  = acur.tur_in_id
       and mat.matr_in_situacao = 2
	   and mat.acur_in_id = pi_acur_in_id;
    begin
	  open c_matricula;
	  fetch c_matricula into po_alu_in_id, po_cur_st_nome, po_tur_st_codigo;
	  if c_matricula%notfound then
	     raise_application_error(-20001,'Não Existe Matricula Vigente para o Aluno!');
	  end if;
	  close c_matricula;
	end;
end;
/
show errors;