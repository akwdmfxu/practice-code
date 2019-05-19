<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="contents">
	<div class="contents_con">
		<h2 class="tit">일일 현황 요약 <span class="date">(데이터 기준일 : 2일 전)</span></h2>
		<c:set var="ymd" value="${fn:substring(endDay,0,4)}년${fn:substring(endDay,5,7)}월${fn:substring(endDay,8,10)}일"/>
		<ul class="section_list">
			<li>
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
						<tr>
							<th class="non_style">&nbsp;</th>
							<th colspan="2" class="bg_color01">
								일현황
							</th>
							<th colspan="3" class="bg_color02">
								누적현황
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
						
						<c:forEach items="${list}" var="i">
							<c:choose>
								<c:when test="${i.serviceName != 'TOTAL'}">
									<tr>
										<td class="non_style">${i.serviceName}</td>
										<td class="bg_pink bor_top">${i.todayAndApp}</td>
										<td class="bg_pink bor_top">${i.todayIosApp}</td>
										<td class="bg_blue bor_top">${i.accumAndMem}</td>
										<td class="bg_blue bor_top">${i.accumIosMem}</td>
										<td class="bg_blue bor_top">${i.totalMem}</td>
										<td class="bg_purple bor_top">${i.dailyAvgMem}</td>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
									<td class="non_style">${i.serviceName}</td>
									<td class="bg_blue"><span class="f_bold">${i.todayAndApp}</span></td>
									<td class="bg_blue"><span class="f_bold">${i.todayIosApp}</span></td>
									<td class="bg_blue"><span class="f_bold">${i.accumAndMem}</span></td>
									<td class="bg_blue"><span class="f_bold">${i.accumIosMem}</span></td>
									<td class="bg_blue"><span class="f_bold">${i.totalMem}</span></td>
									<td class="bg_blue"><span class="f_bold">${i.dailyAvgMem}</span></td>
								</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</table>
				</div>
			</li>
			<li>
				<h3 class="section_tit">다운현황<span class="date">(${ymd})</span></h3>
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
						<tr>
							<th class="non_style">&nbsp;</th>
							<th colspan="2" class="bg_color01">
								일현황
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
						<c:forEach items="${list}" var="i">
							<c:choose>
								<c:when test="${i.serviceName != 'TOTAL'}">
									<tr>
										<td class="non_style">${i.serviceName}</td>
										<td class="bg_pink bor_top">${i.todayAndDwn}</td>
										<td class="bg_pink bor_top">${i.todayIosDwn}</td>
										<td class="bg_blue bor_top">${i.accumAndDwn}</td>
										<td class="bg_blue bor_top">${i.accumIosDwn}</td>
										<td class="bg_blue bor_top">${i.totalDwn}</td>
										<td class="bg_purple bor_top">${i.dailyAvgDwn}</td>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<td class="non_style">${i.serviceName}</td>
										<td class="bg_blue"><span class="f_bold">${i.todayAndDwn}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.todayIosDwn}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.accumAndDwn}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.accumIosDwn}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.totalDwn}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.dailyAvgDwn}</span></td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</table>
				</div>
			</li>
			<li>
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
						<tr>
							<th class="non_style">&nbsp;</th>
							<th colspan="3" class="bg_color01">
								일현황
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
						<c:forEach items="${list}" var="i">
							<c:choose>
								<c:when test="${i.serviceName != 'TOTAL'}">	
									<tr>
										<td class="non_style">${i.serviceName}</td>
										<td class="bg_pink bor_top">${i.todayAndApp}</td>
										<td class="bg_pink bor_top">${i.todayIosApp}</td>
										<td class="bg_pink bor_top">${i.totalApp}</td>
										<td class="bg_blue bor_top">${i.useRateAnd}</td>
										<td class="bg_blue bor_top">${i.useRateIos}</td>
										<td class="bg_blue bor_top">${i.useRateTot}</td>
										<td class="bg_purple bor_top">${i.useAppAvg}</td>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<td class="non_style">${i.serviceName}</td>
										<td class="bg_blue"><span class="f_bold">${i.todayAndApp}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.todayIosApp}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.totalApp}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.useRateAnd}%</span></td>
										<td class="bg_blue"><span class="f_bold">${i.useRateIos}%</span></td>
										<td class="bg_blue"><span class="f_bold">${i.useRateTot}%</span></td>
										<td class="bg_blue"><span class="f_bold">${i.useAppAvg}</span></td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</table>
				</div>
			</li>
			<li>
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
						<tr>
							<th class="non_style">&nbsp;</th>
							<th class="bg_color01">
								일현황
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
						<c:forEach items="${list}" var="i">
							<c:choose>
								<c:when test="${i.serviceName != 'TOTAL'}">	
									<tr>
										<td class="non_style">${i.serviceName}</td>
										<td class="bg_pink bor_top">${i.todayWeb}</td>
										<td class="bg_blue bor_top">${i.dailyAvgWeb}</td>
										<td class="bg_purple bor_top">${i.webTotal}</td>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<td class="non_style">${i.serviceName}</td>
										<td class="bg_blue"><span class="f_bold">${i.todayWeb}</span></td>
										<td class="bg_blue"><span class="f_bold">${i.dailyAvgWeb}%</span></td>
										<td class="bg_blue"><span class="f_bold">${i.webTotal}</span></td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</table>
				</div>
			</li>
		</ul>
	</div>
</div>
