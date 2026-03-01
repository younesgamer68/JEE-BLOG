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
        <div class="brand-icon"><i class="bi bi-key"></i></div> JEE-Blog
      </div>
      <p class="auth-left-tagline">
        ${lang=='fr'
          ? 'Pas de panique ! Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe directement dans votre Gmail.'
          : 'No worries! Enter your email address and we will send a reset link straight to your Gmail inbox.'}
      </p>
      <ul class="auth-left-features list-unstyled">
        <li><i class="bi bi-envelope-check-fill"></i>${lang=='fr'?'Lien envoyé sur votre Gmail':'Link sent to your Gmail'}</li>
        <li><i class="bi bi-shield-lock-fill"></i>${lang=='fr'?'Lien sécurisé & temporaire':'Secure & temporary link'}</li>
        <li><i class="bi bi-clock-history"></i>${lang=='fr'?'Expire dans 30 minutes':'Expires in 30 minutes'}</li>
        <li><i class="bi bi-arrow-repeat"></i>${lang=='fr'?'Changez librement votre mot de passe':'Change your password freely'}</li>
      </ul>
    </div>

    <%-- RIGHT PANEL --%>
    <div class="auth-panel-right">
      <h3><fmt:message key="forgot.title" bundle="${bundle}"/></h3>
      <p class="auth-sub"><fmt:message key="forgot.subtitle" bundle="${bundle}"/></p>

      <c:if test="${not empty success}">
        <div class="alert alert-success mb-3">
          <i class="bi bi-envelope-check me-2"></i><fmt:message key="forgot.success" bundle="${bundle}"/>
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3">
          <i class="bi bi-exclamation-circle me-2"></i>
          <c:choose>
            <c:when test="${error=='empty'}"><fmt:message key="forgot.error.empty" bundle="${bundle}"/></c:when>
            <c:otherwise>${lang=='fr'?'Une erreur est survenue.':'An error occurred.'}</c:otherwise>
          </c:choose>
        </div>
      </c:if>

      <c:if test="${empty success}">
        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
          <div class="mb-4">
            <label class="form-label"><fmt:message key="forgot.email_label" bundle="${bundle}"/></label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-envelope"></i></span>
              <input type="email" name="email" class="form-control"
                     placeholder="alice@gmail.com" required autofocus/>
            </div>
          </div>
          <button type="submit" class="btn-primary-custom w-100 justify-content-center">
            <i class="bi bi-send me-1"></i><fmt:message key="forgot.submit" bundle="${bundle}"/>
          </button>
        </form>
      </c:if>

      <hr class="divider mt-4"/>
      <p style="text-align:center;font-size:0.85rem;color:var(--text-muted);margin:0">
        <a href="${pageContext.request.contextPath}/login"
           style="color:var(--accent);font-weight:700;text-decoration:none">
          <i class="bi bi-arrow-left me-1"></i><fmt:message key="forgot.back_login" bundle="${bundle}"/>
        </a>
      </p>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
