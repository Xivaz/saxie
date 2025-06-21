var vFlagNivel = $x("P50_FMED_IN_FLAG_NIVEL").value;
window.alert(vFlagNivel);

$("#P50_FMED_IN_MODALIDADE_LABEL").hide();
$("#P50_FMED_IN_MODALIDADE").hide();
$("#P50_CUR_IN_ID_LABEL").hide();
$("#P50_CUR_IN_ID").hide();
$("#P50_FMED_IN_TIPO_DISC_LABEL").hide();
$("#P50_FMED_IN_TIPO_DISC").hide();
if (vFlagNivel=="1") {   
   $("#P50_FMED_IN_MODALIDADE_LABEL").show();
   $("#P50_FMED_IN_MODALIDADE").show();
 } else { 
     if (vFlagNivel=="2") {
        $("#P50_FMED_IN_MODALIDADE_LABEL").show();
        $("#P50_FMED_IN_MODALIDADE").show();
        $("#P50_CUR_IN_ID_LABEL").show();
        $("#P50_CUR_IN_ID").show();
      } else { 
          if (vFlagNivel.value=="3") {
           $("#P50_FMED_IN_TIPO_DISC_LABEL").show();
           $("#P50_FMED_IN_TIPO_DISC").show();
          }
      }
    }
  }      