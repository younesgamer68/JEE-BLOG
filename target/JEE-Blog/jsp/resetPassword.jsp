<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp"/>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />

<div class="auth-wrapper">
  <div class="card auth-card">

    <%-- LEFT PANEL --%>
    <div class="auth-panel-left">
      <div class="auth-left-brand">
        <div class="brand-icon"><i class="bi bi-lock-fill"></i></div> JEE-Blog
      </div>
      <p class="auth-left-tagline">
        ${lang=='fr'
          ? 'Choisissez un nouveau mot de passe sécurisé. Votre compte sera protégé après cette opération.'
          : 'Choose a new secure password. Your account will be protected after this operation.'}
      </p>
      <ul class="auth-left-features list-unstyled">
        <li><i class="bi bi-check-circle-fill"></i>${lang=='fr'?'Minimum 6 caractères':'Minimum 6 characters'}</li>
        <li><i class="bi bi-check-circle-fill"></i>${lang=='fr'?'Chiffres et lettres recommandés':'Numbers and letters recommended'}</li>
        <li><i class="bi bi-check-circle-fill"></i>${lang=='fr'?'Mot de passe chiffré en base':'Password encrypted in database'}</li>
      </ul>
    </div>

    <%-- RIGHT PANEL --%>
    <div class="auth-panel-right">
      <h3><fmt:message key="reset.title" bundle="${bundle}"/></h3>
      <p class="auth-sub"><fmt:message key="reset.subtitle" bundle="${bundle}"/></p>

      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3">
          <i class="bi bi-exclamation-circle me-2"></i>
          <c:choose>
            <c:when test="${error=='mismatch'}"><fmt:message key="reset.error.mismatch" bundle="${bundle}"/></c:when>
            <c:when test="${error=='short'}"><fmt:message key="reset.error.short" bundle="${bundle}"/></c:when>
            <c:when test="${error=='invalid_token'}"><fmt:message key="reset.error.invalid" bundle="${bundle}"/></c:when>
            <c:otherwise><fmt:message key="reset.error.invalid" bundle="${bundle}"/></c:otherwise>
          </c:choose>
        </div>
      </c:if>

      <%-- If token is invalid/expired show only message, no form --%>
      <c:choose>
        <c:when test="${error=='invalid_token' or empty token}">
          <div class="alert alert-warning mb-3">
            <i class="bi bi-exclamation-triangle me-2"></i>
            ${lang=='fr'?'Ce lien est invalide ou a expiré. Veuillez refaire la demande.':'This link is invalid or has expired. Please request a new one.'}
          </div>
        </c:when>
        <c:otherwise>
          <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <input type="hidden" name="token" value="${token}"/>
            <div class="mb-3">
              <label class="form-label"><fmt:message key="reset.new_password" bundle="${bundle}"/></label>
              <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" name="password" class="form-control"
                       placeholder="••••••••" required minlength="6"/>
              </div>
            </div>
            <div class="mb-4">
              <label class="form-label"><fmt:message key="reset.confirm_password" bundle="${bundle}"/></label>
              <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                <input type="password" name="confirmPassword" class="form-control"
                       placeholder="••••••••" required minlength="6"/>
              </div>
            </div>
            <button type="submit" class="btn-primary-custom w-100 justify-content-center">
              <i class="bi bi-shield-check me-1"></i><fmt:message key="reset.submit" bundle="${bundle}"/>
            </button>
          </form>
        </c:otherwise>
      </c:choose>

      <hr class="divider mt-4"/>
      <p style="text-align:center;font-size:0.85rem;color:var(--text-muted);margin:0">
        <a href="${pageContext.request.contextPath}/login"
           style="color:var(--accent);font-weight:700;text-decoration:none">
          <i class="bi bi-arrow-left me-1"></i><fmt:message key="reset.back_login" bundle="${bundle}"/>
        </a>
      </p>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
