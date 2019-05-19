<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>

<!doctype html>
<html lang="kr">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
	<title><tiles:getAsString name="title" /></title>
	
	<script type="text/javascript">
		var base = '${base}';
	</script>
	
	<script src="${base}/js/lib/jquery-2.1.1.min.js"></script>
	<script src="${base}/js/common.js"></script>
	<script src="${base}/js/storage.js"></script>
	<script src="${base}/js/bootstrap-datepicker.min.js"></script>
	<script src="${base}/js/bootstrap-datepicker.kr.js"></script>
	
	<script src="${base}/js/validation/jquery.alerts-1.1/jquery.alerts.js"></script>
	<script src="${base}/js/validation/common.js"></script>
	
	<%-- <script src="${base}/js/graph/highcharts.src.js"></script>
	<script src="${base}/js/graph/highcharts-more.js"></script> --%>
	<script src="https://code.highcharts.com/stock/highstock.js"></script>
	<script src="https://code.highcharts.com/stock/modules/exporting.js"></script>
	<script type="text/javascript" src="https://www.highcharts.com/samples/data/usdeur.js"></script>
	
	<script type="text/javascript" src="${base}/js/lib/jquery.i18n.properties.min.js"></script>
	
	<link rel="stylesheet" href="${base}/js/validation/jquery.alerts-1.1/jquery.alerts.css">
	
	<link rel="stylesheet" type="text/css" href="${base}/css/common.css"/>
	<link rel="stylesheet" type="text/css" href="${base}/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" href="${base}/css/jquery.colorpicker.css" />
	<link rel="stylesheet" type="text/css" href="${base}/css/datepicker3.css" />
</head>
<body>
	<div class="wrapper">		
		<tiles:insertAttribute name="header" />
	
		<tiles:insertAttribute name="container" />
	
		<tiles:insertAttribute name="footer" />
	</div>
</body>
</html>