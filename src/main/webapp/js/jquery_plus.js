/**
 * @Zelipe
 */
var jq = jQuery.noConflict(); //jq

function checkForm(obj){
    //检查表单
    var go = true;
    jq.each(jq('input,textarea').serializeArray(), function(i, field){
        if(field.value=='' && go==true){
            jq('#'+field.name).focus().css({backgroundColor:'#F9DAE5'});
            go = false;
            return false;
        }else{
            jq('#'+field.name).css({backgroundColor:'#ffffff'});
            field.value=encodeURIComponent(field.value);
        }
    });
    
    if(!go) return false;
}