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
        <div class="brand-icon"><i class="bi bi-journal-richtext"></i></div> JEE-Blog
      </div>
      <p class="auth-left-tagline">
        ${lang=='fr'
          ? 'Rejoignez la plateforme, partagez vos connaissances et échangez avec la communauté Jakarta EE.'
          : 'Join the platform, share your knowledge and connect with the Jakarta EE community.'}
      </p>
      <ul class="auth-left-features list-unstyled">
        <li><i class="bi bi-check-circle-fill"></i>${lang=='fr'?'Espace membres sécurisé':'Secure members area'}</li>
        <li><i class="bi bi-check-circle-fill"></i>${lang=='fr'?'Gestion des articles':'Article management'}</li>
        <li><i class="bi bi-check-circle-fill"></i>${lang=='fr'?'Commentaires interactifs':'Interactive comments'}</li>
        <li><i class="bi bi-check-circle-fill"></i>${lang=='fr'?'Interface bilingue FR / EN':'Bilingual interface FR / EN'}</li>
        <li><i class="bi bi-check-circle-fill"></i>${lang=='fr'?'Mode clair & sombre':'Light & dark mode'}</li>
      </ul>
    </div>

    <%-- RIGHT PANEL --%>
    <div class="auth-panel-right">
      <h3><fmt:message key="login.title" bundle="${bundle}"/></h3>
      <p class="auth-sub">${lang=='fr'?'Entrez vos identifiants pour accéder à votre espace.':'Enter your credentials to access your space.'}</p>

      <c:if test="${not empty success}">
        <div class="alert alert-success mb-3">
          <i class="bi bi-check-circle me-2"></i>
          <c:choose>
            <c:when test="${success=='reset_ok'}">${lang=='fr'?'Mot de passe mis à jour ! Connectez-vous.':'Password updated! Please log in.'}</c:when>
          </c:choose>
        </div>
      </c:if>

      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3">
          <i class="bi bi-exclamation-circle"></i>
          <c:choose>
            <c:when test="${error=='email_not_validated'}"><fmt:message key="login.error.not_validated" bundle="${bundle}"/></c:when>
            <c:otherwise><fmt:message key="login.error.invalid" bundle="${bundle}"/></c:otherwise>
          </c:choose>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="mb-3">
          <label class="form-label"><fmt:message key="login.email" bundle="${bundle}"/></label>
          <div class="input-group">
            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
            <input type="email" name="email" class="form-control" placeholder="alice@example.com" required autofocus/>
          </div>
        </div>
        <div class="mb-2">
          <label class="form-label"><fmt:message key="login.password" bundle="${bundle}"/></label>
          <div class="input-group">
            <span class="input-group-text"><i class="bi bi-lock"></i></span>
            <input type="password" name="password" class="form-control" placeholder="••••••••" required/>
          </div>
        </div>

        <%-- Forgot password link --%>
        <div class="mb-4 text-end">
          <a href="${pageContext.request.contextPath}/forgot-password"
             style="font-size:0.82rem;color:var(--accent);text-decoration:none;font-weight:600;">
            <i class="bi bi-key me-1"></i>${lang=='fr'?'Mot de passe oublié ?':'Forgot password?'}
          </a>
        </div>

        <button type="submit" class="btn-primary-custom w-100 justify-content-center">
          <fmt:message key="login.submit" bundle="${bundle}"/><i class="bi bi-arrow-right ms-1"></i>
        </button>
      </form>

      <hr class="divider mt-4"/>
      <p style="text-align:center;font-size:0.85rem;color:var(--text-muted);margin:0">
        <fmt:message key="login.no_account" bundle="${bundle}"/>
        <a href="${pageContext.request.contextPath}/register" style="color:var(--accent);font-weight:700;text-decoration:none">
          <fmt:message key="login.register_link" bundle="${bundle}"/>
        </a>
      </p>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
