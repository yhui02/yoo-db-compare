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
<title><decorator:title default="Yoo DB Compare" /></title>
<meta http-equiv="keywords" content="YOO DB Compare" />
<meta http-equiv="description" content="YOO DB Compare" />
<meta name="title" content="<decorator:title /> "/>
<meta name="author" content="Yohann" />

<link rel="stylesheet" href="http://lib.sinaapp.com/js/bootstrap/3.0.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/style.css?v1">
<script src="js/core.js"></script>
<decorator:head />
</head>

<body>
    <div class="navbar">
        <div class="container page-header">
            <div class="navbar-header">
                <a class="navbar-brand" href="index"><i class="glyphicon glyphicon-fire"></i>Yoo DB Compare</a>
            </div>
        </div>
    </div>

    <div class="container">
        <decorator:body/>
    </div>

    <div class="footer container">
        <p>&copy; <script>document.write(new Date().getFullYear())</script> | @Yohann</p>
    </div>
<!-- /container -->
</body>
</html>
