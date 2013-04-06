<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
<style type="text/css">
.ct_box{width:80%;margin:0 auto}
.ct_box .z_box{line-height:32px;}
.z_box label{width:82px;text-align:right;display:inline-block;}
</style>

<script>
function checkForm(obj){
    var go = true;
    var inputsObj = {
    	conn_url : ELN.getFormElement(obj, 'conn_url'),
    	conn_url2 : ELN.getFormElement(obj, 'conn2_url')
    };
    for(var i in inputsObj){
    	if(inputsObj[i].value==''){
   			inputsObj[i].style.backgroundColor='#F9DAE5';
   			inputsObj[i].focus();
   			go = false;
			return false;
    	}else{
   			inputsObj[i].style.backgroundColor='#FFFFFF';
   			//inputsObj[i].value=encodeURIComponent(inputsObj[i].value);
    	}
    }
    if(!go) return false;
}

function setConnVal (v1, v2) {
	E$('connUrl1').value = v1;
	E$('connUrl2').value = v2;
}
</script>
</head>

<body>
<div class="jumbotron">
    <form class="form-horizontal" action="index!dbmanager" method="get" onsubmit="return checkForm(this)">
        <p class="controls text-error">${errorMsg}</p>

        <div class="control-group">
            <label class="control-label" for="connUrl1">DATABASE TYPE</label>
            <div class="controls">
                <select>
                    <option value="mysql">mysql</option>
                </select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="connUrl1">DATABASE1</label>
            <div class="controls">
                <input type="text" id="connUrl1" name="connUrl1" placeholder="mysql://host:port/database?user=***&password=***" class="span6" value="${param.connUrl1}">
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="connUrl2">DATABASE2</label>
            <div class="controls">
                <input type="text" id="connUrl2" name="connUrl2" placeholder="mysql://host:port/database?user=***&password=***" class="span6" value="${param.connUrl2}">
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <input type="submit" class="btn btn-primary" value="Start compare" />
                <input type="reset" class="btn" value="Reset" />
            </div>
        </div>
        <div class="control-group">

            <div class="controls">
                <h4>demo data</h4>
                <blockquote><code id="connUrlEg1">mysql://localhost:3306/test?user=root&password=***</code><br />
                    <code id="connUrlEg2">mysql://localhost:3306/test1?user=root&password=***</code><br />
                    <a class="btn btn-small" href="javascript:setConnVal(E$('connUrlEg1').innerHTML, E$('connUrlEg2').innerHTML)">use demo data</a>
                </blockquote>
            </div>
        </div>
    </form>
</div>

</body>
</html>