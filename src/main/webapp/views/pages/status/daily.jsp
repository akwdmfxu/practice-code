<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" type="text/css" href="${base}/css/jquery.mCustomScrollbar.css"/>
<script type="text/javascript" src="${base}/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript">
	var serviceNo = "${serviceNo}";
	
	$( window ).resize(function() {
		if(serviceNo == ""){
			$("#memGraph").height($("#memTable").height());
			$("#appGraph").height($("#appTable").height());
			$("#dwnGraph").height($("#dwnTable").height());
			$("#uvGraph").height($("#uvTable").height());
			$("#webGraph").height($("#webTable").height());	
		}else{
			$("#memServiceGraph").height($("#memServiceTable").height());
			$("#appServiceGraph").height($("#appServiceTable").height());
			$("#dwnServiceGraph").height($("#dwnServiceTable").height());
			$("#webServiceGraph").height($("#webServiceTable").height());
			$("#uvServiceGraph").height($("#uvServiceTable").height());
		}
		
	});
	
	function link() {
		if( window.innerWidth > 768 ){
			location.href="${base}/status/daily?startDay=" + $("#startDay").val() + "&endDay=" + $("#endDay").val() + "&serviceNo=" +$("#combo option:selected").val();
		}else{
			location.href="${base}/status/daily?startDay=" + $("#mstartDay").val() + "&endDay=" + $("#mendDay").val() + "&serviceNo=" +$("#combo option:selected").val();
		}
	}
	
	function linkTab(url) {
		location.href="${base}/status/" + url;
	}
	
	$(document).ready(function(){
		//데이트피커 설정
		$(".datepicker").datepicker({
			language: "kr",
			buttonText: "달력",
			todayHighlight: true,
			autoclose: true
		});
		
		//상단 서비스 셀렉트 박스
		fn_getServiceCombobox('combo', 'SVC', serviceNo, '서비스 선택', 'Y', 'Y');

		if(serviceNo != ""){
			$(".allService" ).hide();
			$(".detailService" ).show();
		}else{
			$(".detailService" ).hide();
			$(".allService" ).show();
		}
		
		//그래프 설정
		var json = ${json};					// 그래프 내용 불러옴
		var memList = json.memberData;		// 회원 현황 
		var memSeries = [];					// 차트에 들어갈 회원 현황 배열
		var memAndList = json.memAndData;	// 회원 And 현황 
		var memAndSeries = [];				// 차트에 들어갈 회원 And 현황 배열
		var memIosList = json.memIosData;	// 회원 Ios 현황 
		var memIosSeries = [];				// 차트에 들어갈 회원 Ios 현황 배열
		
		var dwnTotData = json.dwnTotData;   // 다운로드 누적 현황
		var dwnTotSeries = [];					// 차트에 들어갈 다운로드 누적 현황 배열
		var dwnList = json.downloadData;	// 다운로드 현황
		var dwnSeries = [];					// 차트에 들어갈 다운로드 현황 배열
		var webList = json.webDataList;		// 웹 사용 현황 
		var webSeries = [];					// 차트에 들어갈 웹 현황 배열
		var appList = json.appData;			// 앱 사용 현황 
		var appSeries = [];					// 차트에 들어갈 앱 현황 배열
		var appTotList = json.appTotData;	// 앱 누적 사용 현황 
		var appTotSeries = [];				// 차트에 들어갈 앱 누적 현황 배열
		var uvList = json.uvData;			// uv 사용 현황 
		var uvSeries = [];					// 차트에 들어갈 uv 현황 배열
		var uvTotList = json.uvTotData;		// uv 누적 사용 현황 
		var uvTotSeries = [];				// 차트에 들어갈 uv 누적 현황 배열
		
		var max = json.xAxis.length;		// 차트 X축 max값
		var min = 0;						// 차트 X축 min값
		
		if(json.xAxis.length <= 10) min = max-10;
		
		// 차트별 각 데이터 분류
		memAndSeries = parsingData(memAndList, "line", "android", "mem");
		memIosSeries = parsingData(memIosList, "line", "ios", "mem");
		dwnSeries = parsingData(dwnList, "line", null,"dwn");
		dwnTotSeries = parsingData(dwnTotData, "column", "누적", "dwn");
		webSeries = parsingData(webList, "line", null,"web");
		appSeries = parsingData(appList, "line", null,"app");
		appTotSeries = parsingData(appTotList, "column", "누적", "app");
		uvSeries = parsingData(uvList, "line", null,"uv");
		uvTotSeries = parsingData(uvTotList, "column", "누적", "uv");
		
		if(serviceNo == ""){
			memSeries = parsingData(memList, "column", null, "mem");
			$("#memGraph").height($("#memTable").height());
			$("#appGraph").height($("#appTable").height());
			$("#dwnGraph").height($("#dwnTable").height());
			$("#uvGraph").height($("#uvTable").height());
			$("#webGraph").height($("#webTable").height());
			
			drawBarGraph('memGraph', memSeries, json);
			drawLineGraph('appGraph', appSeries, json);
			drawLineGraph('dwnGraph', dwnSeries, json);
			drawLineGraph('uvGraph', uvSeries, json);
			drawLineGraph('webGraph', webSeries, json);
		}else{
			memSeries = parsingData(memList, "column", "누적", "mem");
			$("#memServiceGraph").height($("#memServiceTable").height());
			$("#appServiceGraph").height($("#appServiceTable").height());
			$("#dwnServiceGraph").height($("#dwnServiceTable").height());
			$("#webServiceGraph").height($("#webServiceTable").height());
			$("#uvServiceGraph").height($("#uvServiceTable").height());
			
			for(var i=0; i<memIosSeries.length; i++) memSeries.push(memIosSeries[i])
			for(var i=0; i<memAndSeries.length; i++) memSeries.push(memAndSeries[i])
			for(var i=0; i<dwnTotSeries.length; i++) dwnSeries.push(dwnTotSeries[i])
			for(var i=0; i<appTotSeries.length; i++) appSeries.push(appTotSeries[i])
			for(var i=0; i<uvTotSeries.length; i++) uvSeries.push(uvTotSeries[i])
			
			drawBarGraph('memServiceGraph', memSeries, json);
			drawLineGraph('appServiceGraph', appSeries, json);
			drawBarGraph('dwnServiceGraph', dwnSeries, json);
			drawLineGraph('uvServiceGraph', uvSeries, json);
			drawLineGraph('webServiceGraph', webSeries, json);
		}
		
		/* $(".graph_tb").each(function(i) {
			console.log($(this).children().tbody());
		}) */
		
		var tdArr = $("td");
		var txt;
		$.each(tdArr, function (i, val) {
			if( $(val).text() == '0' || $(val).text() == '0%' || $(val).text() == '0.0%') $(val).text('-'); 
		})
	});
	
	//그래프 데이터 파싱해서 생성
	function parsingData(list,type,name,service) {
		var series = [];
		
		if(list == null) return [];
		
		for(var i=0; i<list.length; i++){
			var data = [];
			var flag = "";
			
			switch(service){
				case 'mem' : flag = list[i].memSvcYn; break; 
				case 'dwn' : flag = list[i].memSvcYn; break; 
				case 'app' : flag = list[i].appSvcYn; break; 
				case 'web' : flag = list[i].webSvcYn; break; 
				case 'uv' : flag = list[i].uvSvcYn; break; 
			}
						
			if(flag != 'N'){
				for(var j=0; j<list[i].data.length; j++){
					data.push(list[i].data[j]*1);
				}
				
				if(name == null || name == "")
					series.push({color: list[i].color, data: data, name: list[i].serviceName, type: type});
				else if(name == "누적")
					series.push({color: '#5584ff', data: data, name: name, type: type});
				else
					series.push({color: list[i].color, data: data, name: name, type: type});				
			}
			
		}
		return series;
	}
	
	function drawBarGraph(name, series, json, min, max) {
		$('#' + name).highcharts({
		    chart: {
		        type: 'column'
		    },
		    title: {
		        text: ''
		    },
		    xAxis: {
		    	categories: json.xAxis,
		    	min : min,
		    	max : max,
		    	scrollbar: {
			        enabled: true
			    }, 
		    },
		    yAxis: {
		        min: 0,
		        //max: 1200,
		        title: {
		            text: ''
		        },
		        stackLabels: {
		            enabled: true,
		            style: {
		                fontWeight: 'bold',
		                color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
		            }
		        }
		    },
		    legend: {
		        align: 'right',
		        verticalAlign: 'top',
		        layout: 'vertical'
		    },
		    tooltip: {
		        headerFormat: '<b>{point.x}</b><br/>',
		        pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
		    },
		    plotOptions: {
		        column: {
		            stacking: 'normal',
		            dataLabels: {
		                enabled: true,
		                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
		            }
		        }
		    },
		    series: series
		});
	}
	
	function drawLineGraph(name, series, json) {
		$('#'+name).highcharts({
		    title: {
		        text: '　 '
		    },
		    xAxis: {
		    	categories: json.xAxis
		    },

		    yAxis: {
		        title: {
		            text: ''
		        }
		    },
		    legend: {
		        align: 'right',
		        verticalAlign: 'top',
		        layout: 'vertical'
		    },
		    series: series,
		});
	}
</script>
<div class="contents">
	<div class="contents_con">
		<div class="tab_type">
			<ul>
				<li style="cursor: pointer" class="active">일별</li>
				<li style="cursor: pointer" onclick="linkTab('monthly')">월별</li>
				<li style="cursor: pointer" onclick="linkTab('yearly')">년별</li>
			</ul>
		</div>
		<div class="search_all">
			<select id="combo">
				<option value="" selected="selected">서비스명</option>
			</select>
			<div class="m_date">
				<input type="date" class="input_date" id="mStartDay" value="${startDay}"/>
				<input type="date" class="input_date" id="mEndDay" value="${endDay}" />
			</div>
			<div class="pc_date">
				<input type="text" class="datepicker" id="startDay" value="${startDay}" /> <span class="space_01">~ </span>
			<input type="text" class="datepicker" id="endDay" value="${endDay}" />
			</div>
			<a href="#" class="btn_search" onclick="link();" >조회</a>
		</div>
		<c:set var="ymd" value="${fn:substring(endDay,0,4)}년${fn:substring(endDay,5,7)}월${fn:substring(endDay,8,10)}일"/>
		<c:set var="eDay" value="${fn:substring(endDay,2,4)}.${fn:substring(endDay,5,7)}.${fn:substring(endDay,8,10)}"/>
		<c:set var="sDay" value="${fn:substring(startDay,2,4)}.${fn:substring(startDay,5,7)}.${fn:substring(startDay,8,10)}"/>
		
		<div class = "allService">
			<ul class="section_list">
				<li id="memTable">
					<h3 class="section_tit">회원현황<span class="date">(${ymd})</span></h3>
					<ul class="top_txt">
						<li>* efil : 서비스별, OS별 중복 제외</li>
						<li>* 서비스별 회원 : 각 서비스 최초 로그인 사용자 수</li>
						<li>* 누적현황 : 서비스 탈퇴, 해지자를 제외한 현재 누적</li>
					</ul>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:14%;" />
								<col style="width:13%;" />
								<col style="width:14%;" />
								<col style="width:13%;" />
								<col style="width:14%;" />
								<col style="width:16%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th colspan="2" class="bg_color01">
										TODAY<br />(${eDay})
									</th>
									<th colspan="3" class="bg_color02">
										누적현황<br />
									</th>
									<th class="bg_color03">
										누적현황 대비<br />일평균
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color05">android</th>
									<th class="bg_color05">iOS</th>
									<th class="bg_color05">TOTAL</th>
									<th class="bg_color06">일평균</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb" id="mTable">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:14%;" />
									<col style="width:13%;" />
									<col style="width:14%;" />
									<col style="width:13%;" />
									<col style="width:14%;" />
									<col style="width:16%;" />
								</colgroup>	
								<c:set value="0" var="avgSum"/>
								<c:set value="0" var="idx"/>
								<tbody>
									<c:forEach items="${list}" var="i" varStatus="stat">
										<c:if test="${i.serviceName != 'TOTAL' && i.memSvcYn == 'Y'}">
											<c:set value="${avgSum + i.dailyAvgMem}" var="avgSum"/>
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.todayAndApp}" pattern="#,###" /></td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.todayIosApp}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.accumAndMem}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.accumIosMem}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.totalMem}" pattern="#,###" /></td>
												<td class="bg_purple bor_top">${i.dailyAvgMem}%</td>
												<c:set value="${stat.count}" var="idx"/>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:14%;" />
								<col style="width:13%;" />
								<col style="width:14%;" />
								<col style="width:13%;" />
								<col style="width:14%;" />
								<col style="width:16%;" />
							</colgroup>	
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="non_style">TOTAL${fn:length(list)}</td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].todayAndApp}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].todayIosApp}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].accumAndMem}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].accumIosMem}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].totalMem}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold">${avgSum / idx}%</span></td>
									</tr>
								</c:if>
							</tfoot>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="memGraph"></p>
				</li>
				
				<li id="dwnTable">
					<h3 class="section_tit">다운로드 현황<span class="date">(${ymd})</span></h3>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:14%;" />
								<col style="width:14%;" />
								<col style="width:14%;" />
								<col style="width:13%;" />
								<col style="width:13%;" />
								<col style="width:16%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th colspan="2" class="bg_color01">
										TODAY<br />(${eDay})
									</th>
									<th colspan="3" class="bg_color02">
										전체 회원 대비 사용률<br />
									</th>
									<th class="bg_color03">
										누적현황 대비<br />일평균
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color05">android</th>
									<th class="bg_color05">iOS</th>
									<th class="bg_color05">TOTAL</th>
									<th class="bg_color06">일평균</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:14%;" />
									<col style="width:14%;" />
									<col style="width:14%;" />
									<col style="width:13%;" />
									<col style="width:13%;" />
									<col style="width:16%;" />
								</colgroup>
								<tbody>
									<c:set value="0" var="avgSum"/>
									<c:set value="0" var="avgAnd"/>
									<c:set value="0" var="avgIos"/>
									<c:set value="0" var="avgTot"/>
									<c:forEach items="${list}" var="i" varStatus="stat">
										<c:if test="${i.serviceName != 'TOTAL' && i.dwnSvcYn == 'Y'}">
											<c:set value="${avgSum + i.dailyAvgDwn}" var="avgSum"/>
											<c:set value="${avgAnd + i.accumAndDwn}" var="avgAnd"/>
											<c:set value="${avgIos + i.accumIosDwn}" var="avgIos"/>
											<c:set value="${avgTot + i.totalDwn}" var="avgTot"/>
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.todayAndDwn}" pattern="#,###" /></td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.todayIosDwn}" pattern="#,###" /></td>
												<td class="bg_blue bor_top">${i.accumAndDwn}%</td>
												<td class="bg_blue bor_top">${i.accumIosDwn}%</td>
												<td class="bg_blue bor_top">${i.totalDwn}%</td>
												<td class="bg_purple bor_top">${i.dailyAvgDwn}%</td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:14%;" />
								<col style="width:14%;" />
								<col style="width:14%;" />
								<col style="width:13%;" />
								<col style="width:13%;" />
								<col style="width:16%;" />
							</colgroup>
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="non_style">${list[idx].serviceName}</td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].todayAndDwn}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].todayIosDwn}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold">${avgAnd / idx}%</span></td>
										<td class="bg_blue"><span class="f_bold">${avgIos / idx}%</span></td>
										<td class="bg_blue"><span class="f_bold">${avgTot / idx}%</span></td>
										<td class="bg_blue"><span class="f_bold">${avgSum / idx}%</span></td>
									</tr>
								</c:if>
							</tfoot>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="dwnGraph"></p>
				</li>
				<li id="appTable">
					<h3 class="section_tit">APP 사용 현황<span class="date">(${ymd})</span></h3>
					<ul class="top_txt2">
						<li>* 서비스별 중복 사용자를 제외한 unique한 사용자 수 (비로그인 포함)</li>
					</ul>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:12%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:16%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th colspan="3" class="bg_color01">
										TODAY<br />(${eDay})
									</th>
									<th colspan="3" class="bg_color02">
										전체 회원 대비 사용률<br />
									</th>
									<th class="bg_color03">
										누적현황 대비<br />일평균
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color04">TOTAL</th>
									<th class="bg_color05">android</th>
									<th class="bg_color05">iOS</th>
									<th class="bg_color05">TOTAL</th>
									<th class="bg_color06">일평균</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:12%;" />
									<col style="width:10%;" />
									<col style="width:12%;" />
									<col style="width:12%;" />
									<col style="width:10%;" />
									<col style="width:12%;" />
									<col style="width:16%;" />
								</colgroup>
								<tbody>
									<c:set value="0" var="avgSum"/>
									<c:set value="0" var="avgAnd"/>
									<c:set value="0" var="avgIos"/>
									<c:set value="0" var="avgTot"/>
									<c:forEach items="${list}" var="i" varStatus="stat" >
										<c:if test="${i.serviceName != 'TOTAL' && i.appSvcYn == 'Y'}">	
											<c:set value="${avgSum + i.useAppAvg}" var="avgSum"/>
											<c:set value="${avgAnd + i.useRateAnd}" var="avgAnd"/>
											<c:set value="${avgIos + i.useRateIos}" var="avgIos"/>
											<c:set value="${avgTot + i.useRateTot}" var="avgTot"/>
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink "><fmt:formatNumber value="${i.todayAndApp}" pattern="#,###" /></td>
												<td class="bg_pink "><fmt:formatNumber value="${i.todayIosApp}" pattern="#,###" /></td>
												<td class="bg_pink "><fmt:formatNumber value="${i.totalApp}" pattern="#,###" /></td>
												<td class="bg_blue ">${i.useRateAnd}%</td>
												<td class="bg_blue ">${i.useRateIos}%</td>
												<td class="bg_blue ">${i.useRateTot}%</td>
												<td class="bg_purple ">${i.useAppAvg}%</td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:12%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:16%;" />
							</colgroup>
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="non_style">${i.serviceName}</td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].todayAndApp}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].todayIosApp}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].totalApp}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold">${avgAnd / idx}%</span></td>
										<td class="bg_blue"><span class="f_bold">${avgIos / idx}%</span></td>
										<td class="bg_blue"><span class="f_bold">${avgTot / idx}%</span></td>
										<td class="bg_blue"><span class="f_bold">${avgSum / idx}%</span></td>
									</tr>
								</c:if>
							</tfoot>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="appGraph"></p>
				</li>
				<li id="webTable">
					<h3 class="section_tit">WEB 사용 현황<span class="date">(${ymd})</span></h3>
					<ul class="top_txt2">
						<li>* 서비스별 중복 사용자를 제외한 unique한 접속자 수</li>
					</ul>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:28%;" />
								<col style="width:28%;" />
								<col style="width:28%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color01">
										일현황<br />(${eDay })
									</th>
									<th class="bg_color02">
										누적현황<br />
									</th>
									<th class="bg_color03">
										누적현황 대비<br />일평균
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">TODAY</th>
									<th class="bg_color05">누적</th>
									<th class="bg_color06">일평균</th>
								</tr>
							</thead>
						</table>
						
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:28%;" />
									<col style="width:28%;" />
									<col style="width:28%;" />
								</colgroup>
								<tbody>
									<c:set value="0" var="avgSum"/>
									<c:forEach items="${list}" var="i" varStatus="stat" >
										<c:if test="${i.serviceName != 'TOTAL' && i.webSvcYn == 'Y'}">	
											<tr>
												<c:set value="${avgSum + i.dailyAvgWeb}" var="avgSum"/>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink "><fmt:formatNumber value="${i.todayWeb}" pattern="#,###" /></td>
												<td class="bg_blue "><fmt:formatNumber value="${i.webTotal}" pattern="#,###" /></td>
												<td class="bg_purple ">${i.dailyAvgWeb}%</td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:28%;" />
								<col style="width:28%;" />
								<col style="width:28%;" />
							</colgroup>
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="non_style">TOTAL</td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].todayWeb}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold"><fmt:formatNumber value="${list[idx].webTotal}" pattern="#,###" /></span></td>
										<td class="bg_blue"><span class="f_bold">${avgSum / idx}%</span></td>
									</tr>
								</c:if>
							</tfoot>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="webGraph"></p>
				</li>
				<li id="uvTable">
					<h3 class="section_tit">UV 현황<span class="date">(${ymd})</span></h3>
					<ul class="top_txt2">
						<li>* 서비스별 중복 사용자를 제외한 unique한 접속자 수</li>
					</ul>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:17%;" />
								<col style="width:17%;" />
								<col style="width:17%;" />
								<col style="width:17%;" />
								<col style="width:16%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th colspan="2" class="bg_color01">
										TODAY<br />(${eDay})
									</th>
									<th colspan="2" class="bg_color02">
										누적현황<br />
									</th>
									<th class="bg_color03">
										TOTAL
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color05">android</th>
									<th class="bg_color05">iOS</th>
									<th class="bg_color06">Total</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:17%;" />
									<col style="width:17%;" />
									<col style="width:17%;" />
									<col style="width:17%;" />
									<col style="width:16%;" />
								</colgroup>
								<tbody>
									<c:forEach items="${list}" var="i" >
										<c:if test="${i.serviceName != 'TOTAL' && i.uvSvcYn == 'Y'}">
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.todayAndUv}" pattern="#,###" /></td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.todayIosUv}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.uvAndSum}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.uvIosSum}" pattern="#,###" /></td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.uvSum}" pattern="#,###" /></td>
											</tr>	
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:17%;" />
								<col style="width:17%;" />
								<col style="width:17%;" />
								<col style="width:17%;" />
								<col style="width:16%;" />
							</colgroup>
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="non_style">${list[idx].serviceName}</td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].todayAndUv}" pattern="#,###" /></td>
										<td class="bg_blue "><fmt:formatNumber value="${list[idx].todayIosUv}" pattern="#,###" /></td>
										<td class="bg_blue "><fmt:formatNumber value="${list[idx].uvAndSum}" pattern="#,###" /></td>
										<td class="bg_blue "><fmt:formatNumber value="${list[idx].uvIosSum}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].uvSum}" pattern="#,###" /></td>
									</tr>
								</c:if>
							</tfoot>	
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="uvGraph"></p>
				</li>
				<%-- <li>
					<h3 class="section_tit">판매 현황<span class="date">(${ymd})</span></h3>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color01">
									TODAY<br />(18.03.12)
								</th>
								<th colspan="3" class="bg_color02">
									누적현황<br />(18.03.12 ~ 18.03.12)
								</th>
							</tr>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color04">Today</th>
								<th class="bg_color05">월누적</th>
								<th class="bg_color05">년누적</th>
								<th class="bg_color05">전체 누적</th>
							</tr>
							<tr>
								<td class="non_style"><span class="f_bold">tracker S1</span></td>
								<td class="bg_pink bor_top">2</td>
								<td class="bg_blue bor_top">258</td>
								<td class="bg_blue bor_top">258</td>
								<td class="bg_blue bor_top">258</td>
							</tr>
							<tr>
								<td class="non_style">목표</td>
								<td class="bg_pink bor_top"><span class="f_bold">150</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">300</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">20,000</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">20,000</span></td>
							</tr>
							<tr>
								<td class="non_style">tracker S1</td>
								<td class="bg_pink bor_top"><span class="f_bold">1%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">86%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
							</tr>
							<tr>
								<td class="non_style bor_top">thermo G1</td>
								<td class="bg_pink bor_top">23</td>
								<td class="bg_blue bor_top">163</td>
								<td class="bg_blue bor_top">163</td>
								<td class="bg_blue bor_top">163</td>
							</tr>
							<tr>
								<td class="non_style">목표</td>
								<td class="bg_pink bor_top"><span class="f_bold">150</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">250</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">20,000</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">25,000</span></td>
							</tr>
							<tr>
								<td class="non_style">달성율</td>
								<td class="bg_pink bor_top"><span class="f_bold">15%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">65%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
							</tr>
							<tr>
								<td class="non_style bor_top"><span class="f_bold">마비하비</span></td>
								<td class="bg_pink bor_top">23</td>
								<td class="bg_blue bor_top">163</td>
								<td class="bg_blue bor_top">163</td>
								<td class="bg_blue bor_top">163</td>
							</tr>
							<tr>
								<td class="non_style">목표</td>
								<td class="bg_pink bor_top"><span class="f_bold">150</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">250</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">30,000</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">40,000</span></td>
							</tr>
							<tr>
								<td class="non_style">달성율</td>
								<td class="bg_pink bor_top"><span class="f_bold">15%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">65%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
							</tr>
						</table>
					</div>
				</li> --%>
				<%-- <li class="m_hide">
					<h3 class="section_tit">판매 현황<span class="date">(${ymd})</span></h3>
					<p class="graph_all"><img src="images/img_graph04.gif" alt="" /></p>
				</li> --%>
			</ul>
		</div>
		<div class="detailService">
			<ul class="section_list">
				<li id="memServiceTable">
					<h3 class="section_tit">회원현황<span class="date">(${ymd})</span></h3>
					<ul class="top_txt">
						<li>* efil : 서비스별, OS별 중복 제외</li>
						<li>* 서비스별 회원 : 각 서비스 최초 로그인 사용자 수</li>
						<li>* 누적현황 : 서비스 탈퇴, 해지자를 제외한 현재 누적</li>
					</ul>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:17%;" />
								<col style="width:16%;" />
								<col style="width:16%;" />
								<col style="width:17%;" />
								<col style="width:17%;" />
								<col style="width:17%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color01">
									가입<br />
								</th>
								<th class="bg_color02">
									해지<br />
								</th>
								<th class="bg_color03">
									탈퇴<br />
								</th>
								<th class="bg_color01">
									순증<br />
								</th>
								<th class="bg_color02">
									전체회원<br />
								</th>
							</tr>
							<tr>
								<td class="non_style">android</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memAndJoin}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memAndCancel}" pattern="#,###" /></td>
								<td class="bg_purple bor_top"><fmt:formatNumber value="${list[0].memAndQuit}" pattern="#,###" /></td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memAndIncrease}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumAndMem}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">ios</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memIosJoin}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memIosCancel}" pattern="#,###" /></td>
								<td class="bg_purple bor_top"><fmt:formatNumber value="${list[0].memIosQuit}" pattern="#,###" /></td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memIosIncrease}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosMem}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">total</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memAndJoin + list[0].memIosJoin}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memAndCancel + list[0].memIosCancel}" pattern="#,###" /></td>
								<td class="bg_purple bor_top"><fmt:formatNumber value="${list[0].memAndQuit + list[0].memIosQuit}" pattern="#,###" /></td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memTotIncrease}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumTotMem}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">전월평균 </td>
								<td class="bg_blue"><span class="f_bold">${list[0].memJoinAvg}%</span></td>
								<td class="bg_blue"><span class="f_bold">${list[0].memCancelAvg}%</span></td>
								<td class="bg_blue"><span class="f_bold">${list[0].memQuitAvg}%</span></td>
								<td class="bg_blue"><span class="f_bold">${list[0].memIncAvg}%</span></td>
								<td class="bg_blue"><span class="f_bold"></span></td>
							</tr>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="memServiceGraph"></p>
				</li>
				<li id="dwnServiceTable">
					<h3 class="section_tit">다운로드 현황<span class="date">(${ymd})</span></h3>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:25%;" />
								<col style="width:25%;" />
								<col style="width:25%;" />
								<col style="width:25%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color01">
									android<br />
								</th>
								<th class="bg_color02">
									ios<br />
								</th>
								<th class="bg_color03">
									total<br />
								</th>
							</tr>
							<tr>
								<th class="non_style">Today</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].dwnAndToday}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].dwnIosToday}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].dwnTotToday}" pattern="#,###" /></th>
							</tr>
							<tr>
								<th class="non_style">누적현황</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].accumAndDwn}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosDwn}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].accumTotDwn}" pattern="#,###" /></th>
							</tr>
							<tr>
								<th class="non_style">전월일 평균</th>
								<th class="bg_pink bor_top">${list[0].dwnAndAvg}%</th>
								<th class="bg_blue bor_top">${list[0].dwnIosAvg}%</th>
								<th class="bg_purple bor_top">${list[0].dwnTotAvg}%</th>
							</tr>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="dwnServiceGraph"></p>
				</li>
				<li id="appServiceTable">
					<h3 class="section_tit">APP 사용 현황<span class="date">(${ymd})</span></h3>
					<ul class="top_txt2">
						<li>* 서비스별 중복 사용자를 제외한 unique한 사용자 수 (비로그인 포함)</li>
					</ul>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:25%;" />
								<col style="width:25%;" />
								<col style="width:25%;" />
								<col style="width:25%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color01">
									android<br />
								</th>
								<th class="bg_color02">
									ios<br />
								</th>
								<th class="bg_color03">
									total<br />
								</th>
							</tr>
							<tr>
								<th class="non_style">Today</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].appAndUser}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].appIosUser}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].appTotUser}" pattern="#,###" /></th>
							</tr>
							<tr>
								<th class="non_style">누적현황</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].accumAndApp}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosApp}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].accumTotApp}" pattern="#,###" /></th>
							</tr>
							<tr>
								<th class="non_style">전월일 평균</th>
								<th class="bg_pink bor_top">${list[0].appAndAvg}%</th>
								<th class="bg_blue bor_top">${list[0].appIosAvg}%</th>
								<th class="bg_purple bor_top">${(list[0].appAndAvg + list[0].appIosAvg) / 2}%</th>
							</tr>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="appServiceGraph"></p>
				</li>
				<li id="webServiceTable">
					<h3 class="section_tit">WEB 사용 현황<span class="date">(${ymd})</span></h3>
					<ul class="top_txt2">
						<li>* 서비스별 중복 사용자를 제외한 unique한 접속자 수</li>
					</ul>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:50%;" />
								<col style="width:50%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color02">
									total<br />
								</th>
							</tr>
							<tr>
								<th class="non_style">Today</th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].webToday}" pattern="#,###" /></th>
							</tr>
							<tr>
								<th class="non_style">누적현황</th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumWeb}" pattern="#,###" /></th>
							</tr>
							<tr>
								<th class="non_style">전월일 평균</th>
								<th class="bg_blue bor_top">${list[0].webAvg}%</th>
							</tr>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="webServiceGraph"></p>
				</li>
				<li id="uvServiceTable">
					<h3 class="section_tit">UV 현황<span class="date">(${ymd})</span></h3>
					<ul class="top_txt2">
						<li>* 서비스별 중복 사용자를 제외한 unique한 접속자 수</li>
					</ul>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:25%;" />
								<col style="width:25%;" />
								<col style="width:25%;" />
								<col style="width:25%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color01">
									android<br />
								</th>
								<th class="bg_color02">
									ios<br />
								</th>
								<th class="bg_color03">
									total<br />
								</th>
							</tr>
							<tr>
								<th class="non_style">Today</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].uvAndToday}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].uvIosToday}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].uvTotToday}" pattern="#,###" /></th>
							</tr>
							<tr>
								<th class="non_style">누적현황</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].accumAndUv}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosUv}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].accumTotUv}" pattern="#,###" /></th>
							</tr>
							<tr>
								<th class="non_style">전월일 평균</th>
								<th class="bg_pink bor_top">${list[0].uvAndAvg}%</th>
								<th class="bg_blue bor_top">${list[0].uvIosAvg}%</th>
								<th class="bg_purple bor_top">${list[0].uvTotAvg}%</th>
							</tr>
						</table>
					</div>
				</li>
				<li class="m_hide">
					<p class="graph_all" id="uvServiceGraph"></p>
				</li>
				<%-- <li>
					<h3 class="section_tit">판매 현황<span class="date">(${ymd})</span></h3>
					<div class="tb_out">
						<table class="graph_tb">
							<colgroup>
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color01">
									TODAY<br />(18.03.12)
								</th>
								<th colspan="3" class="bg_color02">
									누적현황<br />(18.03.12 ~ 18.03.12)
								</th>
							</tr>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color04">Today</th>
								<th class="bg_color05">월누적</th>
								<th class="bg_color05">년누적</th>
								<th class="bg_color05">전체 누적</th>
							</tr>
							<tr>
								<td class="non_style"><span class="f_bold">tracker S1</span></td>
								<td class="bg_pink bor_top">2</td>
								<td class="bg_blue bor_top">258</td>
								<td class="bg_blue bor_top">258</td>
								<td class="bg_blue bor_top">258</td>
							</tr>
							<tr>
								<td class="non_style">목표</td>
								<td class="bg_pink bor_top"><span class="f_bold">150</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">300</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">20,000</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">20,000</span></td>
							</tr>
							<tr>
								<td class="non_style">tracker S1</td>
								<td class="bg_pink bor_top"><span class="f_bold">1%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">86%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
							</tr>
							<tr>
								<td class="non_style bor_top">thermo G1</td>
								<td class="bg_pink bor_top">23</td>
								<td class="bg_blue bor_top">163</td>
								<td class="bg_blue bor_top">163</td>
								<td class="bg_blue bor_top">163</td>
							</tr>
							<tr>
								<td class="non_style">목표</td>
								<td class="bg_pink bor_top"><span class="f_bold">150</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">250</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">20,000</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">25,000</span></td>
							</tr>
							<tr>
								<td class="non_style">달성율</td>
								<td class="bg_pink bor_top"><span class="f_bold">15%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">65%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
							</tr>
							<tr>
								<td class="non_style bor_top"><span class="f_bold">마비하비</span></td>
								<td class="bg_pink bor_top">23</td>
								<td class="bg_blue bor_top">163</td>
								<td class="bg_blue bor_top">163</td>
								<td class="bg_blue bor_top">163</td>
							</tr>
							<tr>
								<td class="non_style">목표</td>
								<td class="bg_pink bor_top"><span class="f_bold">150</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">250</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">30,000</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">40,000</span></td>
							</tr>
							<tr>
								<td class="non_style">달성율</td>
								<td class="bg_pink bor_top"><span class="f_bold">15%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">65%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
								<td class="bg_blue bor_top"><span class="f_bold">1%</span></td>
							</tr>
						</table>
					</div>
				</li> --%>
				<%-- <li class="m_hide">
					<h3 class="section_tit">판매 현황<span class="date">(${ymd})</span></h3>
					<p class="graph_all"><img src="images/img_graph04.gif" alt="" /></p>
				</li> --%>
			</ul>
		</div>
	</div>
</div>