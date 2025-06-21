CREATE OR REPLACE FUNCTION fc_valida_cpf(p_numero_cpf IN VARCHAR2) RETURN NUMBER IS
  w_cpf         	VARCHAR2(11) := lpad(p_numero_cpf, 11, '0');
  w_soma_dig1	 	NUMBER := 0;
  w_soma_dig2  		NUMBER := 0;
  w_arr1            owa_util.num_arr;
  x                 number := 10;
BEGIN
  -- Cálculo do primeiro dígito verificador
  for i in 1 .. 9 loop
	w_soma_dig1 := w_soma_dig1 + to_number(substr(w_cpf,i,1))*x;
	x:=x-1;
  end loop;

  w_soma_dig1 := (11 - (MOD(w_soma_dig1, 11)));
  IF (w_soma_dig1 >= 10)
  THEN
    w_soma_dig1 := 0;
  END IF;
  -- Cálculo do segundo dígito verificador
  x := 11;
  for i in 1 .. 10 loop
    if i = 10 then
		w_soma_dig2 := w_soma_dig2 + w_soma_dig1*x;
	else
		w_soma_dig2 := w_soma_dig2 + to_number(substr(w_cpf,i,1))*x;
	end if;
	x:=x-1;
  end loop;
  w_soma_dig2 := (11 - (MOD(w_soma_dig2, 11)));
  
  IF (w_soma_dig2 >= 10)
  THEN
    w_soma_dig2 := 0;
  END IF;
  IF (w_cpf = substr(w_cpf,1,9)||to_char(w_soma_dig1)||to_char(w_soma_dig2)) THEN
	RETURN 1;
  ELSE
	RETURN 0;
  END IF;

END fc_valida_cpf;
/