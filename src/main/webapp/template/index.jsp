<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>

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
    <div class="row">
        <p class="controls text-error">${errorMsg}</p>

        <form class="bs-example" role="form" action="index!dbmanager" method="post" onsubmit="return checkForm(this)">
            <div class="form-group">
                <label class="control-label" for="connUrl1">DATABASE TYPE</label>
                <select class="form-control">
                    <option value="mysql">mysql</option>
                </select>
            </div>

            <div class="form-group input-group">
                <span class="input-group-addon">db 1</span>
                <input type="text" id="connUrl1" name="connUrl1" class="form-control" placeholder="mysql://host:port/database?user=***&password=***" value="${param.connUrl1}">
            </div>
            <div class="form-group input-group">
                <span class="input-group-addon">db 2</span>
                <input type="text" id="connUrl2" name="connUrl2" class="form-control" placeholder="mysql://host:port/database?user=***&password=***" value="${param.connUrl2}">
            </div>
            <div class="form-group">
                <input type="submit" class="btn btn-primary" value="Start compare" />
                <input type="reset" class="btn btn-default" value="Reset" />
            </div>
        </form>

        <div class="form-group highlight">
            <h4>demo data</h4>
            <pre>
                <code id="connUrlEg1">mysql://localhost:3306/test?user=root&password=***</code><br />
                <code id="connUrlEg2">mysql://localhost:3306/test1?user=root&password=***</code><br />
            </pre>

            <a class="btn btn-default" href="javascript:setConnVal(E$('connUrlEg1').innerHTML, E$('connUrlEg2').innerHTML)">Use demo data</a>
        </div>
    </div>
</body>
</html>