<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp"/>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />

<div style="min-height:calc(100vh - 72px);display:flex;align-items:center;justify-content:center;padding:40px 16px">
  <div class="val-card">
    <c:choose>
      <c:when test="${validationResult=='success'}">
        <span class="val-icon">✅</span>
        <h4 style="font-weight:800;color:var(--text-primary);margin-bottom:8px">${lang=='fr'?'Email validé !':'Email validated!'}</h4>
        <p style="color:var(--text-muted);font-size:0.9rem;margin-bottom:24px"><fmt:message key="validation.success" bundle="${bundle}"/></p>
      </c:when>
      <c:otherwise>
        <span class="val-icon">❌</span>
        <h4 style="font-weight:800;color:var(--text-primary);margin-bottom:8px">${lang=='fr'?'Lien invalide':'Invalid link'}</h4>
        <p style="color:var(--text-muted);font-size:0.9rem;margin-bottom:24px"><fmt:message key="validation.invalid" bundle="${bundle}"/></p>
      </c:otherwise>
    </c:choose>
    <a href="${pageContext.request.contextPath}/login" class="btn-primary-custom justify-content-center w-100">
      <i class="bi bi-box-arrow-in-right"></i><fmt:message key="validation.go_login" bundle="${bundle}"/>
    </a>
  </div>
</div>

<jsp:include page="footer.jsp"/>
