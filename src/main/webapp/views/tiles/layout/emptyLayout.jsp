<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>

<!doctype html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
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
	
	<script src="${base}/js/graph/highcharts.src.js"></script>
	<script src="${base}/js/graph/highcharts-more.js"></script>
	
	<script type="text/javascript" src="${base}/js/lib/jquery.i18n.properties.min.js"></script>
	
	<link rel="stylesheet" href="${base}/js/validation/jquery.alerts-1.1/jquery.alerts.css">
	
	<link rel="stylesheet" type="text/css" href="${base}/css/common.css"/>
	<link rel="stylesheet" type="text/css" href="${base}/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" href="${base}/css/jquery.colorpicker.css" />
	<link rel="stylesheet" type="text/css" href="${base}/css/datepicker3.css" />
</head>
<body class="login">
	<div class="wrapper">		
		<tiles:insertAttribute name="container" />
	</div>
</body>
</html>