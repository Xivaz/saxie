
var url1 = "http://localhost:8081/jasperserver/flow.html?_flowId=viewReportFlow&ParentFolderUri=/reports/SAXIE&reportUnit=/reports/SAXIE/";
var rpt= "Declaracao_A4";
var url2="&j_username=";
url2+=apex.item( "P42_JASPERUSER" ).getValue();
url2+="&j_password=";
url2+=apex.item( "P42_JASPERPWD" ).getValue();
url2+="&aluno_curso=";
url2+=apex.item( "P42_ACUR_IN_ID" ).getValue();
var urlx = "";
// -----------------
if (apex.item( "P42_TIPOS_DE_RELATORIO" ).getValue() == "1") {
 rpt= "Declaracao_A4"; 
 urlx = url1+rpt+url2;
 apex.navigation.dialog(urlx, {
        title:'Declaração de Matrícula',
        height:'480',
        width:'800',
        maxWidth:'1200',
        modal:true,
        resizable:false },
        'a-Dialog--uiDialog',
        $('#myregion_static_id')); }
else {
  if (apex.item( "P42_TIPOS_DE_RELATORIO" ).getValue() == "2") {
    rpt= "Historico"; 
    urlx = url1+rpt+url2;
    apex.navigation.dialog(urlx, {
        title:'Declaração de Matrícula',
        height:'480',
        width:'800',
        maxWidth:'1200',
        modal:true,
        resizable:false },
        'a-Dialog--uiDialog',
        $('#myregion_static_id')); }
  }
}