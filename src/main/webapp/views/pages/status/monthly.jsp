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
		var a = $("#startMonth").val();
		if( window.innerWidth > 768 ){
			location.href="/status/monthly?startMonth=" + $("#startDay").val() + "&serviceNo=" +$("#combo option:selected").val();;
		}else{
			location.href="/status/monthly?startMonth=" + $("#mstartDay").val() + "&serviceNo=" +$("#combo option:selected").val();;
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
			autoclose: true,
			format: "yyyy-mm",
			viewMode: "months", 
		    minViewMode: "months"
		});
		
		if(serviceNo != ""){
			$(".allService" ).hide();
			$(".detailService" ).show();
		}else{
			$(".detailService" ).hide();
			$(".allService" ).show();
		}
		
		//상단 서비스 셀렉트 박스
		fn_getServiceCombobox('combo', 'SVC', serviceNo, '서비스 선택', 'Y', 'Y');
		
		//그래프 설정
		var json = ${json};					// 그래프 내용 불러옴
		var memList = json.memberData;		// 회원 현황 
		var memSeries = [];					// 차트에 들어갈 회원 현황 배열
		var memTotList = json.memTotData;// 회원 누적 현황
		var memTotSeries = [];				// 차트에 들어갈 누적 회원  현황 배열
		
		var dwnList = json.downloadData;	// 다운로드 현황
		var dwnSeries = [];					// 차트에 들어갈 다운로드 현황 배열
		var dwnTotList = json.dwnTotData;	// 다운로드 누적 현황
		var dwnTotSeries = [];					// 차트에 들어갈 누적 다운로드 현황 배열
		
		var webList = json.webDataList;		// 웹 사용 현황 
		var webSeries = [];					// 차트에 들어갈 웹 현황 배열
		
		var appList = json.appData;			// 앱 사용 현황 
		var appSeries = [];					// 차트에 들어갈 앱 현황 배열
		var appTotList = json.appTotData;			// 앱 사용 현황 
		var appTotSeries = [];					// 차트에 들어갈 앱 현황 배열
		
		var uvList = json.uvData;			// uv 사용 현황 
		var uvSeries = [];					// 차트에 들어갈 uv 현황 배열
		var uvTotList = json.uvTotData;		// uv 누적 사용 현황 
		var uvTotSeries = [];				// 차트에 들어갈 uv 누적 현황 배열
		
		// 차트별 각 데이터 분류
		dwnSeries = parsingData(dwnList, "line");
		webSeries = parsingData(webList, "line");
		appSeries = parsingData(appList, "line");
		uvSeries = parsingData(uvList, "line");
		memTotSeries = parsingData(memTotList, "column", "누적");
		dwnTotSeries = parsingData(dwnTotList, "column", "누적");
		appTotSeries = parsingData(appTotList, "column", "누적");
		uvTotSeries = parsingData(uvTotList, "column", "누적");
		
		if(serviceNo == ""){
			$("#memGraph").height($("#memTable").height());
			$("#appGraph").height($("#appTable").height());
			$("#dwnGraph").height($("#dwnTable").height());
			$("#uvGraph").height($("#uvTable").height());
			$("#webGraph").height($("#webTable").height());
			
			memSeries = parsingData(memList, "column");
			drawBarGraph('memGraph', memSeries, json);
			drawLineGraph('appGraph', appSeries, json);
			drawLineGraph('dwnGraph', dwnSeries, json);
			drawLineGraph('uvGraph', uvSeries, json);
			drawLineGraph('webGraph', webSeries, json);
		}else{
			
			$("#memServiceGraph").height($("#memServiceTable").height());
			$("#appServiceGraph").height($("#appServiceTable").height());
			$("#dwnServiceGraph").height($("#dwnServiceTable").height());
			$("#webServiceGraph").height($("#webServiceTable").height());
			$("#uvServiceGraph").height($("#uvServiceTable").height());
			
			memSeries = parsingData(memList, "line");

			for(var i=0; i<memTotSeries.length; i++) memSeries.push(memTotSeries[i])
			for(var i=0; i<dwnTotSeries.length; i++) dwnSeries.push(dwnTotSeries[i])
			for(var i=0; i<appTotSeries.length; i++) appSeries.push(appTotSeries[i])
			for(var i=0; i<uvTotSeries.length; i++) uvSeries.push(uvTotSeries[i])
			
			drawBarGraph('memServiceGraph', memSeries, json);
			drawLineGraph('appServiceGraph', appSeries, json);
			drawLineGraph('dwnServiceGraph', dwnSeries, json);
			drawLineGraph('uvServiceGraph', uvSeries, json);
			drawLineGraph('webServiceGraph', webSeries, json);
		}
	});
	
	//그래프 데이터 파싱해서 생성
	function parsingData(list,type,name) {
		var series = [];
		
		if(list == null) return [];
		
		for(var i=0; i<list.length; i++){
			var data = [];
			
			for(var j=0; j<list[i].data.length; j++){
				data.push(list[i].data[j]*1);
			}
			if(name == null || name == "")
				series.push({color: list[i].color, data: data, name: list[i].serviceName, type: type});
			else
				series.push({color: list[i].color, data: data, name: name, type: type});
		}
		return series;
	}
	
	
	function drawBarGraph(name, series, json) {
		$('#' + name).highcharts({
		    chart: {
		        type: 'column'
		    },
		    title: {
		        text: ''
		    },
		    xAxis: {
		    	categories: json.xAxis/* ,
		    	min: 0,
		    	scrollbar: {
			        enabled: true
			    }, */
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
		    /* legend: {
		        x: 0,
		        verticalAlign: 'top',
		        backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
		        borderColor: '#CCC',
		        borderWidth: 1,
		        shadow: false
		    }, */
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
		    /* legend: {
		        x: 0,
		        verticalAlign: 'top',
		        backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
		        borderColor: '#CCC',
		        borderWidth: 1,
		        shadow: false
		    }, */
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
				<li style="cursor: pointer" onclick="linkTab('daily')">일별</li>
				<li style="cursor: pointer" class="active">월별</li>
				<li style="cursor: pointer" onclick="linkTab('yearly')">년별</li>
			</ul>
		</div>
		<div class="search_all">
		
			<select id="combo">
				<option value="" selected="selected">서비스명</option>
			</select>
			<div class="m_date">
				<input type="date" class="input_date" id="mStartDay" value="${startMonth}"/>
			</div>
			<div class="pc_date">
				<input type="text" class="datepicker" id="startDay" value="${startMonth}" /> 
			</div>
			<a href="#" class="btn_search" onclick="link();" >조회</a>
		</div>
		<c:set var="ymd" value="${fn:substring(startMonth,0,4)}년 ${fn:substring(startMonth,5,7)}월"/>
		<div class= "allService">
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
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th colspan="2" class="bg_color01">
										전월<br />
									</th>
									<th colspan="2" class="bg_color02">
										당월<br />
									</th>
									<th colspan="2" class="bg_color01">
										전월대비<br />
									</th>
									<th colspan="2" class="bg_color03">
										누적현황 <br />
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color05">android</th>
									<th class="bg_color05">iOS</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color06">android</th>
									<th class="bg_color06">iOS</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:12%;" />
									<col style="width:12%;" />
								</colgroup>
								<c:set value="0" var="avgAnd"/>
								<c:set value="0" var="avgIos"/>
								<c:set value="0" var="idx"/>
								<tbody>	
									<c:forEach items="${list}" var="i" varStatus="stat">
										<c:if test="${i.serviceName != 'TOTAL'}">
											<c:set value="${avgAnd + i.compareAndMem}" var="avgAnd"/>
											<c:set value="${avgIos + i.compareIosMem}" var="avgIos"/>
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.lastMonthAndMem}" pattern="#,###" /></td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.lastMonthIosMem}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.thisMonthAndMem}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.thisMonthIosMem}" pattern="#,###" /></td>
												<td class="bg_pink bor_top">${i.compareAndMem}%</td>
												<td class="bg_pink bor_top">${i.compareIosMem}%</td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.accumAndMem}" pattern="#,###" /></td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.accumIosMem}" pattern="#,###" /></td>
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
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
							</colgroup>
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="bg_blue">${list[idx].serviceName}</td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthAndMem}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthIosMem}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthAndMem}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthIosMem}" pattern="#,###" /></td>
										<td class="bg_blue">${avgAnd / idx}%</td>
										<td class="bg_blue">${avgIos / idx}%</td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].accumAndMem}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].accumIosMem}" pattern="#,###" /></td>
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
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th colspan="2" class="bg_color01">
										전월<br />
									</th>
									<th colspan="2" class="bg_color02">
										당월<br />
									</th>
									<th colspan="2" class="bg_color01">
										전월대비<br />
									</th>
									<th colspan="2" class="bg_color03">
										누적현황 <br />
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color05">android</th>
									<th class="bg_color05">iOS</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color06">android</th>
									<th class="bg_color06">iOS</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:12%;" />
									<col style="width:12%;" />
								</colgroup>
								<c:set value="0" var="avgAnd"/>
								<c:set value="0" var="avgIos"/>
								<tbody>
									<c:forEach items="${list}" var="i" varStatus="stat">
										<c:if test="${i.serviceName != 'TOTAL'}">
											<c:set value="${avgAnd + i.compareAndDwn}" var="avgAnd"/>
											<c:set value="${avgIos + i.compareIosDwn}" var="avgIos"/>
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.lastMonthAndDwn}" pattern="#,###" /></td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.lastMonthIosDwn}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.thisMonthAndDwn}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.thisMonthIosDwn}" pattern="#,###" /></td>
												<td class="bg_pink bor_top">${i.compareAndDwn}%</td>
												<td class="bg_pink bor_top">${i.compareIosDwn}%</td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.accumAndDwn}" pattern="#,###" /></td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.accumIosDwn}" pattern="#,###" /></td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
							</colgroup>
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="bg_blue">${list[idx].serviceName}</td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthAndDwn}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthIosDwn}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthAndDwn}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthIosDwn}" pattern="#,###" /></td>
										<td class="bg_blue">${avgAnd / idx}%</td>
										<td class="bg_blue">${avgIos / idx}%</td>
										<td class="bg_blue"><fmt:formatNumber value="${i.accumAndDwn}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${i.accumIosDwn}" pattern="#,###" /></td>
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
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th colspan="2" class="bg_color01">
										전월<br />
									</th>
									<th colspan="2" class="bg_color02">
										당월<br />
									</th>
									<th colspan="2" class="bg_color01">
										전월대비<br />
									</th>
									<th colspan="2" class="bg_color03">
										누적현황 <br />
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color05">android</th>
									<th class="bg_color05">iOS</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color06">android</th>
									<th class="bg_color06">iOS</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:12%;" />
									<col style="width:12%;" />
								</colgroup>
								<c:set value="0" var="avgAnd"/>
								<c:set value="0" var="avgIos"/>
								<tbody>
									<c:forEach items="${list}" var="i" varStatus="stat">
										<c:if test="${i.serviceName != 'TOTAL'}">
											<c:set value="${avgAnd + i.compareAndApp}" var="avgAnd"/>
											<c:set value="${avgIos + i.compareIosApp}" var="avgIos"/>
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.lastMonthAndApp}" pattern="#,###" /></td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.lastMonthIosApp}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.thisMonthAndApp}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.thisMonthIosApp}" pattern="#,###" /></td>
												<td class="bg_pink bor_top">${i.compareAndApp}</td>
												<td class="bg_pink bor_top">${i.compareIosApp}</td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.accumAndApp}" pattern="#,###" /></td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.accumIosApp}" pattern="#,###" /></td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
							</colgroup>
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="bg_blue">${list[idx].serviceName}</td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthAndApp}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthIosApp}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthAndApp}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthIosApp}" pattern="#,###" /></td>
										<td class="bg_blue">${avgAnd / idx}%</td>
										<td class="bg_blue">${avgIos / idx}%</td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].accumAndApp}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].accumIosApp}" pattern="#,###" /></td>
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
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color01">
										전월
									</th>
									<th class="bg_color02">
										당월
									</th>
									<th class="bg_color01">
										전월대비
									</th>
									<th class="bg_color03">
										누적
									</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:21%;" />
									<col style="width:21%;" />
									<col style="width:21%;" />
									<col style="width:21%;" />
								</colgroup>
								<c:set value="0" var="avgSum"/>
								<tbody>
									<c:forEach items="${list}" var="i" varStatus="stat">
										<c:if test="${i.serviceName != 'TOTAL'}">
											<c:set value="${avgSum + i.compareWeb}" var="avgSum"/>									
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink"><fmt:formatNumber value="${i.lastMonthWeb}" pattern="#,###" /></td>
												<td class="bg_blue"><fmt:formatNumber value="${i.thisMonthWeb}" pattern="#,###" /></td>
												<td class="bg_pink">${i.compareWeb}%</td>
												<td class="bg_purple"><fmt:formatNumber value="${i.webTotal}" pattern="#,###" /></td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
							</colgroup>
							<tfoot>
								<c:if test="${fn:length(list) > 0}">
									<tr>
										<td class="bg_blue">${list[idx].serviceName}</td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthWeb}" pattern="#,###" /></td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthWeb}" pattern="#,###" /></td>
										<td class="bg_blue">${avgSum / idx}%</td>
										<td class="bg_blue"><fmt:formatNumber value="${list[idx].webTotal}" pattern="#,###" /></td>
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
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th colspan="2" class="bg_color01">
										전월<br />
									</th>
									<th colspan="2" class="bg_color02">
										당월<br />
									</th>
									<th colspan="2" class="bg_color01">
										전월대비<br />
									</th>
									<th colspan="2" class="bg_color03">
										누적현황 <br />
									</th>
								</tr>
								<tr>
									<th class="non_style">&nbsp;</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color05">android</th>
									<th class="bg_color05">iOS</th>
									<th class="bg_color04">android</th>
									<th class="bg_color04">iOS</th>
									<th class="bg_color06">android</th>
									<th class="bg_color06">iOS</th>
								</tr>
							</thead>
						</table>
						<div class="td_scroll mCustomScrollbar">
							<table class="graph_tb">
								<colgroup>
									<col style="width:16%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:12%;" />
									<col style="width:12%;" />
								</colgroup>
								<c:set value="0" var="avgAnd"/>
								<c:set value="0" var="avgIos"/>
								<tbody>
									<c:forEach items="${list}" var="i" varStatus="stat">
										<c:if test="${i.serviceName != 'TOTAL'}">
											<c:set value="${avgAnd + i.compareAndUv}" var="avgAnd"/>
											<c:set value="${avgIos + i.compareIosUv}" var="avgIos"/>
											<tr>
												<td class="non_style">${i.serviceName}</td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.lastMonthAndUv}" pattern="#,###" /></td>
												<td class="bg_pink bor_top"><fmt:formatNumber value="${i.lastMonthIosUv}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.thisMonthAndUv}" pattern="#,###" /></td>
												<td class="bg_blue bor_top"><fmt:formatNumber value="${i.thisMonthIosUv}" pattern="#,###" /></td>
												<td class="bg_pink bor_top">${i.compareAndUv}%</td>
												<td class="bg_pink bor_top">${i.compareIosUv}%</td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.uvAndSum}" pattern="#,###" /></td>
												<td class="bg_purple bor_top"><fmt:formatNumber value="${i.uvIosSum}" pattern="#,###" /></td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<table class="graph_tb">
							<colgroup>
								<col style="width:16%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
							</colgroup>
							<c:if test="${fn:length(list) > 0}">
								<tr>
									<td class="bg_blue">${list[idx].serviceName}</td>
									<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthAndUv}" pattern="#,###" /></td>
									<td class="bg_blue"><fmt:formatNumber value="${list[idx].lastMonthIosUv}" pattern="#,###" /></td>
									<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthAndUv}" pattern="#,###" /></td>
									<td class="bg_blue"><fmt:formatNumber value="${list[idx].thisMonthIosUv}" pattern="#,###" /></td>
									<td class="bg_blue">${avgAnd / idx}%</td>
									<td class="bg_blue">${avgIos / idx}%</td>
									<td class="bg_blue"><fmt:formatNumber value="${list[idx].uvAndSum}" pattern="#,###" /></td>
									<td class="bg_blue"><fmt:formatNumber value="${list[idx].uvIosSum}" pattern="#,###" /></td>
								</tr>
							</c:if>
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
								<col style="width:16%;" />
								<col style="width:11%;" />
								<col style="width:10%;" />
								<col style="width:11%;" />
								<col style="width:10%;" />
								<col style="width:11%;" />
								<col style="width:10%;" />
								<col style="width:11%;" />
								<col style="width:10%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th colspan="2" class="bg_color01">
									전월<br />
								</th>
								<th colspan="2" class="bg_color02">
									당월<br />
								</th>
								<th colspan="2" class="bg_color03">
									전월대비<br />
								</th>
								<th colspan="2" class="bg_color02">
									누적현황<br />
								</th>
							</tr>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color04">android</th>
								<th class="bg_color04">iOS</th>
								
								<th class="bg_color05">android</th>
								<th class="bg_color05">iOS</th>
								
								<th class="bg_color06">android</th>
								<th class="bg_color06">iOS</th>
								
								<th class="bg_color05">android</th>
								<th class="bg_color05">iOS</th>
							</tr>
							<tr>
								<td class="non_style">가입</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memAndJoinLmonth}" pattern="#,###" /></td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memIosJoinLmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memAndJoinTmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memIosJoinTmonth}" pattern="#,###" /></td>
								<td class="bg_purple bor_top">${list[0].compareAndJoinMem}%</td>
								<td class="bg_purple bor_top">${list[0].compareIosJoinMem}%</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumAndMem}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosMem}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">해지</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memAndCancelLmonth}" pattern="#,###" /></td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memIosCancelLmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memAndCancelTmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memIosCancelTmonth}" pattern="#,###" /></td>
								<td class="bg_purple bor_top">${list[0].compareAndCancelMem}%</td>
								<td class="bg_purple bor_top">${list[0].compareIosCancelMem}%</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumAndMem}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosMem}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">탈퇴</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memAndQuitLmonth}" pattern="#,###" /></td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].memIosQuitLmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memAndQuitTmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].memIosQuitTmonth}" pattern="#,###" /></td>
								<td class="bg_purple bor_top">${list[0].compareAndQuitMem}%</td>
								<td class="bg_purple bor_top">${list[0].compareIosQuitMem}%</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumAndMem}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosMem}" pattern="#,###" /></td>
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
								<col style="width:16%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th class="bg_color01">
									android
								</th>
								<th class="bg_color02">
									ios
								</th>
								<th class="bg_color03">
									total
								</th>
								<th class="bg_color02">
									일평균
								</th>
							</tr>
							<tr>
								<th class="non_style">당월</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].dwnAndTmonth}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].dwnIosTmonth}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].dwnTotTmonth}" pattern="#,###" /></th>
								<th class="bg_blue bor_top">${list[0].dwnAndAvgTmonth}%</th>
							</tr>
							<tr>
								<th class="non_style">전월</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].dwnAndLmonth}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].dwnIosLmonth}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].dwnTotLmonth}" pattern="#,###" /></th>
								<th class="bg_blue bor_top">${list[0].dwnAndAvgLmonth}%</th>
							</tr>
							<tr>
								<th class="non_style">전월대비</th>
								<th class="bg_pink bor_top">${list[0].compareAndDwn}%</th>
								<th class="bg_blue bor_top">${list[0].compareIosDwn}%</th>
								<th class="bg_purple bor_top">${list[0].compareTotDwn}%</th>
								<th class="bg_blue bor_top">${list[0].compareAvgDwn}%</th>
							</tr>
							<tr>
								<th class="non_style">누적</th>
								<th class="bg_pink bor_top"><fmt:formatNumber value="${list[0].accumAndDwn}" pattern="#,###" /></th>
								<th class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosDwn}" pattern="#,###" /></th>
								<th class="bg_purple bor_top"><fmt:formatNumber value="${list[0].accumTotDwn}" pattern="#,###" /></th>
								<th class="bg_blue bor_top">${list[0].accumAvgDwn}%</th>
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
								<col style="width:16%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th  class="bg_color01">
									전월<br />
								</th>
								<th class="bg_color02">
									당월<br />
								</th>
								<th class="bg_color03">
									전월대비<br />
								</th>
								<th class="bg_color02">
									누적현황<br />
								</th>
							</tr>
							<tr>
								<td class="non_style">android</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].appAndUserLmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].appAndUserTmonth}" pattern="#,###" /></td>
								<td class="bg_purple bor_top">${list[0].compareAndApp}%</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumAndApp}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">ios</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].appIosUserLmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].appIosUserTmonth}" pattern="#,###" /></td>
								<td class="bg_purple bor_top">${list[0].compareIosApp}%</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosApp}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">total</td>
								<td class="bg_blue"><fmt:formatNumber value="${list[0].appTotUserLmonth}" pattern="#,###" /></td>
								<td class="bg_blue"><fmt:formatNumber value="${list[0].appTotUserTmonth}" pattern="#,###" /></td>
								<td class="bg_blue">${list[0].compareTotApp}%</td>
								<td class="bg_blue"><fmt:formatNumber value="${list[0].accumTotApp}" pattern="#,###" /></td>
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
								<col style="width:16%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th  class="bg_color01">
									전월<br />
								</th>
								<th class="bg_color02">
									당월<br />
								</th>
								<th class="bg_color03">
									전월대비<br />
								</th>
								<th class="bg_color02">
									누적현황<br />
								</th>
							</tr>
							<tr>
								<td class="non_style">web</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].webLmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].webTmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top">${list[0].compareWeb}%</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumWeb}" pattern="#,###" /></td>
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
								<col style="width:16%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
								<col style="width:21%;" />
							</colgroup>
							<tr>
								<th class="non_style">&nbsp;</th>
								<th  class="bg_color01">
									전월<br />
								</th>
								<th class="bg_color02">
									당월<br />
								</th>
								<th class="bg_color03">
									전월대비<br />
								</th>
								<th class="bg_color02">
									누적현황<br />
								</th>
							</tr>
							<tr>
								<td class="non_style">android</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].uvAndLmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].uvAndTmonth}" pattern="#,###" /></td>
								<td class="bg_purple bor_top">${list[0].compareAndUv}%</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumAndUv}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">ios</td>
								<td class="bg_pink bor_top"><fmt:formatNumber value="${list[0].uvIosLmonth}" pattern="#,###" /></td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].uvIosTmonth}" pattern="#,###" /></td>
								<td class="bg_purple bor_top">${list[0].compareIosUv}%</td>
								<td class="bg_blue bor_top"><fmt:formatNumber value="${list[0].accumIosUv}" pattern="#,###" /></td>
							</tr>
							<tr>
								<td class="non_style">total</td>
								<td class="bg_blue"><fmt:formatNumber value="${list[0].uvTotTmonth}" pattern="#,###" /></td>
								<td class="bg_blue"><fmt:formatNumber value="${list[0].uvTotLmonth}" pattern="#,###" /></td>
								<td class="bg_blue">${list[0].compareTotUv}%</td>
								<td class="bg_blue"><fmt:formatNumber value="${list[0].accumTotUv}" pattern="#,###" /></td>
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