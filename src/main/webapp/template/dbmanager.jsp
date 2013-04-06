<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<html>
<head>
<script type="text/javascript" src="js/jquery-1.5.2.min.js"></script>
<script type="text/javascript" src="js/jquery_plus.js"></script>
<style>
.container-narrow{width:98%;max-width: 98%}
#main .main{vertical-align: top;}
.main{padding:12px;}
.diff *{color:red !important;}
table .t1{width:2%;}
table .t2{width:30%;}
table .t3{width:20%}
table .t4{width:10%;}
table .t5{width:10%;}
table .t6{width:6%;}
.z_box2 form{display:inline;}
.del{text-decoration:line-through;}
.z_box2 li{line-height: 200%;}
</style>

<script>
function aj_execute(type, url, formName){
	var data = jq("form#"+formName).serialize()+'&connUrl2='+encodeURIComponent('${param.connUrl2}');
	jq.ajax({
		type : "POST",
		url : url,
		data : data,
		success : function(d) {
			if(d.msg=='success'){
				jq('#whole').load(location.href + ' #whole');
				jq('#'+formName).remove();
				jq('#li_'+formName).addClass('del');
				ELN.box.show({html:'执行成功！系统已刷新数据。',animate:false,close:false,mask:false,boxid:'success',autohide:3,top:-14});
			}else{
				ELN.box.show({html:'执行失败！可能已存在同名字段，但字段类型不一致。<br />请手动执行，并刷新本页面。',animate:false,close:false,boxid:'error',top:10});
			}
		}
	});
}
</script>
</head>

<body>
<table id="main" style="width:100%;">
	<tr>
		<td width="50%" class="main">
			${conn_url}
			<c:forEach items="${Tables[0]}" var="table" varStatus="status">
				<table id="data1" class="table table-bordered">
					<tr>
						<td class="th <c:if test="${table.sup=='y'}">diff</c:if>">
							<strong>${status.count}. ${table.tableName}</strong>
                            <c:if test="${table.tableNote != ''}">
							<span style="color:#999;">（${table.tableNote}）</span>
                            </c:if>
						</td>
					</tr>
					<tr>
						<td>
							<table class="table table-bordered">
								<c:forEach items="${table.tablecolumn}" var="table" varStatus="status">
								<tr class="<c:if test="${table[5]=='y'}">diff</c:if>">
									<td class="t1">${status.count}</td>
									<td class="t2">${table[0]}</td>
									<td class="t3"><span class="title3">${table[1]}</span></td>
									<td class="t4"><span class="title3">${table[2]}</span></td>
									<td class="t5"><span class="title3">${table[3]}</span></td>
									<td class="t6"><span class="title3">${table[4]}</span></td>
								</tr>
								</c:forEach>
							</table>
						</td>
					</tr>
				</table>
			</c:forEach>
		</td>
		<td width="50%" class="main">
			${conn2_url}
			<c:forEach items="${Tables[1]}" var="table" varStatus="status">
				<table id="data2" class="table table-bordered">
					<tr>
						<td class="th <c:if test="${table.sup=='y'}">diff</c:if>">
							<strong>${status.count}. ${table.tableName}</strong>
                            <c:if test="${table.tableNote != ''}">
                            <span style="color:#999;">（${table.tableNote}）</span>
                            </c:if>
						</td>
					</tr>
					<tr>
						<td>
							<table class="table table-bordered">
								<c:forEach items="${table.tablecolumn}" var="table" varStatus="status">
								<tr class="<c:if test="${table[5]=='y'}">diff</c:if>">
									<td class="t1">${status.count}</td>
									<td class="t2">${table[0]}</td>
									<td class="t3"><span class="title3">${table[1]}</span></td>
									<td class="t4"><span class="title3">${table[2]}</span></td>
									<td class="t5"><span class="title3">${table[3]}</span></td>
									<td class="t6"><span class="title3">${table[4]}</span></td>
								</tr>
								</c:forEach>
							</table>
						</td>
					</tr>
				</table>
			</c:forEach>
		</td>
	</tr>
</table>


<h2>数据库修改：</h2>
<div class="z_box2 alert alert-block">
	<ul class="unstyled">
	<c:if test="${table2Sub != '[]'}">
		<li class="b"><strong>在数据库2新增表（来自数据库1，表数据不会被添加）：</strong></li>
		<c:forEach items="${table2Sub}" var="table" varStatus="status">
		<li id="li_table2Sub${status.count}">“${table[0]}”
		<form id="table2Sub${status.count}" action="modify">
			<textarea name="sqlExec" style="display:none">${table[1]}</textarea>
			<input type="button" class="btn btn-small btn-danger" value="执行" onclick="aj_execute('type', this.form.action, this.form.id)" />
		</form>
		</li>
		</c:forEach>
	</c:if>
	
	<c:if test="${table2Sup != '[]'}">
		<li class="b"><strong>在数据库2<span class="red">删除</span>表</strong>
		<c:forEach items="${table2Sup}" var="table" varStatus="status">
			<li id="li_table2Sup${status.count}">“${table}”
			<form id="table2Sup${status.count}" action="modify">
				<textarea name="sqlExec" style="display:none">drop table `${table}`</textarea>
				<input type="button" class="btn btn-small btn-danger" value="执行" onclick="aj_execute('type', this.form.action, this.form.id)" />
			</form>
			</li>
		</c:forEach>
	</c:if>
	
	<c:if test="${table2ColumnSub != '[]'}">
		<li class="b"><strong>在数据库2内新增字段</strong></li>
		<c:forEach items="${table2ColumnSub}" var="column" varStatus="status">
			<li id="li_table2ColumnSub${status.count}">
				<c:set var="arrayvalue" value="${column}" />
				<c:set var="delim" value=":"/> 
				<c:set var="array" value="${fn:split(arrayvalue, delim)}"/>
				<code>${array[0]}.${array[1]}</code> - <code>${column}</code>
				
				<form id="table2ColumnSub${status.count}" action="modify">
					<c:set var="arrayvalue" value="${column}" />
					<c:set var="delim" value=":"/> 
					<c:set var="array" value="${fn:split(arrayvalue, delim)}"/>
					<textarea name="sqlExec" style="display:none">alter table `${array[0]}` add `${array[1]}` ${array[2]} ${array[4]}</textarea>
					<input type="button" class="btn btn-small btn-danger" value="执行" onclick="aj_execute('type', this.form.action, this.form.id)" />
				</form>
				</li>
		</c:forEach>
	</c:if>
	
	<c:if test="${table2ColumnSup != '[]'}">
		<li class="b"><strong>在数据库2内删除字段<span class="red">（注意检查是否仅为类型不同，避免误删数据）</span></strong></li>
		<c:forEach items="${table2ColumnSup}" var="column" varStatus="status">
			<li id="li_table2ColumnSup${status.count}">
				<c:set var="arrayvalue" value="${column}" />
				<c:set var="delim" value=":"/> 
				<c:set var="array" value="${fn:split(arrayvalue, delim)}"/>
				<code>${array[0]}.${array[1]}</code> - <code>${column}</code>
				<form id="table2ColumnSup${status.count}" action="modify">
					<textarea name="sqlExec" style="display:none">ALTER TABLE  `${array[0]}` DROP `${array[1]}`</textarea>
					<input type="button" class="btn btn-small btn-danger" value="执行" onclick="aj_execute('type', this.form.action, this.form.id)" />
				</form>
			</li>
		</c:forEach>
	</c:if>
	</ul>
</div>

</body>
</html>