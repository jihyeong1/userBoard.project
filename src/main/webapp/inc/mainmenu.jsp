<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<nav class="navbar navbar-expand-sm bg-dark navbar-dark justify-content-end">
	<ul class="navbar-nav">
		<li class="nav-item">
			<a href="<%=request.getContextPath()%>/home.jsp" class="nav-link">홈으로</a>
		</li>
		<!-- 로그인전 : 회원가입
		로그인후 : 회원정보 / 로그아웃(로그인정보는 세션 loginMemberId -->
		<%
			if(session.getAttribute("loginMemberId") == null ){
				//로그인전
		%>	
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a>
				</li>
		<%		
			}else{
		%>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/member/profileForm.jsp">회원정보</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a>
				</li>
		<%		
			}
		%>
	
	</ul>
</nav>
