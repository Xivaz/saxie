(	($F{MES} == "02" && 	$F{ANOBISEXTO} == 0) ?  
	//Ano bissexto e Mês = Fevereiro
	(	WEEKDAY($V{vDataInicial}) == 7 ? 
			java.util.Arrays.asList("23","24","25","26","27","28","29") :
		(	WEEKDAY($V{vDataInicial}) == 6 ? 
				java.util.Arrays.asList("24","25","26","27","28","29","") :
			(	WEEKDAY($V{vDataInicial}) == 5 ? 
					java.util.Arrays.asList("25","26","27","28","29","","") :
				(	WEEKDAY($V{vDataInicial}) == 4 ? 
						java.util.Arrays.asList("26","27","28","29","","","") :
					(	WEEKDAY($V{vDataInicial}) == 3 ? 
							java.util.Arrays.asList("27","28","29","","","","") :
						(	WEEKDAY($V{vDataInicial}) == 2 ? 
								java.util.Arrays.asList("28","29","","","","","") :
							(	WEEKDAY($V{vDataInicial}) == 1 ? 
									java.util.Arrays.asList("29","","","","","","") :										
									java.util.Arrays.asList("","","","","","","") 
							)
						)
					)
				)
			)
		)
	)	
	:  
	(	($F{MES} == "02" && 	$F{ANOBISEXTO} != 0) ?	
	// Não é ano bissexto e Mês = Fevereiro
		(	WEEKDAY($V{vDataInicial}) == 7 ? 
				java.util.Arrays.asList("23","24","25","26","27","28","") :
			(	WEEKDAY($V{vDataInicial}) == 6 ? 
					java.util.Arrays.asList("24","25","26","27","28","","") :
				(	WEEKDAY($V{vDataInicial}) == 5 ? 
						java.util.Arrays.asList("25","26","27","28","","","") :
					(	WEEKDAY($V{vDataInicial}) == 4 ? 
							java.util.Arrays.asList("26","27","28","","","","") :
						(	WEEKDAY($V{vDataInicial}) == 3 ? 
								java.util.Arrays.asList("27","28","","","","","") :
							(	WEEKDAY($V{vDataInicial}) == 2 ? 
									java.util.Arrays.asList("28","","","","","","") :
								(	WEEKDAY($V{vDataInicial}) == 1 ? 
									java.util.Arrays.asList("","","","","","","") :										
									java.util.Arrays.asList("","","","","","","") 
								)
							)
						)
					)
				)
			)
		)
	:  
 	(	($F{MES} == "01" || $F{MES} == "03" || $F{MES} == "05" || $F{MES} == "07" || $F{MES} == "08" || 
	 		$F{MES} == "10" || $F{MES} == "12"	 ) ?
		// Mêses (Janeiro, Março, Maio, Julho, Agosto, Outubro, Dezembro)
		(	WEEKDAY($V{vDataInicial}) == 7 ? 
				java.util.Arrays.asList("23","24","25","26","27","28","29") :
			(	WEEKDAY($V{vDataInicial}) == 6 ? 
					java.util.Arrays.asList("24","25","26","27","28","29","30") :
				(	WEEKDAY($V{vDataInicial}) == 5 ? 
						java.util.Arrays.asList("25","26","27","28","29","30","31") :
					(	WEEKDAY($V{vDataInicial}) == 4 ? 
							java.util.Arrays.asList("26","27","28","29","30","31","") :
						(	WEEKDAY($V{vDataInicial}) == 3 ? 
								java.util.Arrays.asList("27","28","29","30","31","","") :
							(	WEEKDAY($V{vDataInicial}) == 2 ? 
									java.util.Arrays.asList("28","29","30","31","","","") :
								(	WEEKDAY($V{vDataInicial}) == 1 ? 
										java.util.Arrays.asList("29","30","31","","","","") :										
										java.util.Arrays.asList("","","","","","","") 
								)
							)
						)
					)
				)
			)
		) 	
		: 	
		// Mêses (Abril, Junho, Setembro, Novembro)
		// (	(	$F{MES} == "04" || 	$F{MES} == "06" ||	 $F{MES} == "09" ||	 $F{MES} == "11") ?
		(	WEEKDAY($V{vDataInicial}) == 7 ? 
				java.util.Arrays.asList("23","24","25","26","27","28","29") :
			(	WEEKDAY($V{vDataInicial}) == 6 ? 
					java.util.Arrays.asList("24","25","26","27","28","29","30") :
					(	WEEKDAY($V{vDataInicial}) == 5 ? 
							java.util.Arrays.asList("25","26","27","28","29","30","") :
							(	WEEKDAY($V{vDataInicial}) == 4 ? 
								java.util.Arrays.asList("26","27","28","29","30","","") :
								(	WEEKDAY($V{vDataInicial}) == 3 ? 
									java.util.Arrays.asList("27","28","29","30","","","") :
									(	WEEKDAY($V{vDataInicial}) == 2 ? 
										java.util.Arrays.asList("28","29","30","","","","") :
										(	WEEKDAY($V{vDataInicial}) == 1 ? 
											java.util.Arrays.asList("29","30","","","","","") :										
											java.util.Arrays.asList("","","","","","","") 
										)
									)
								)
							)
						)
					) 
				)
			) 
		)
	)
