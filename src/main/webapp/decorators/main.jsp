<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%
String baseUrl = request.getContextPath() + "/";
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<base href="<%=baseUrl%>" />
<title><decorator:title default="Yoo DB Manager" /></title>
<meta http-equiv="keywords" content="Yoo DB Manager" />
<meta http-equiv="description" content="Yoo DB Manager" />
<meta name="title" content="<decorator:title /> "/>
<meta name="author" content="Yohann" />

<link rel="stylesheet" href="css/bootstrap.css?v1">
<link rel="stylesheet" href="css/style.css?v1">
<script src="js/core.js"></script>
<decorator:head />
</head>

<body>
<div class="container-narrow">
  <div class="masthead">
    <h3><a href="index">Yoo DB Manager</a></h3>
  </div>

  <hr>

  <decorator:body />

  <hr>

  <div class="footer">
    <p>&copy; <script>document.write(new Date().getFullYear())</script> | by Yohann</p>
  </div>
</div> <!-- /container -->

</body>
</html>
