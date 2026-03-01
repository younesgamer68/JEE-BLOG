<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp"/>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />

<div class="auth-wrapper">
  <div class="card auth-card" style="max-width:960px">

    <%-- LEFT PANEL --%>
    <div class="auth-panel-left">
      <div class="auth-left-brand">
        <div class="brand-icon"><i class="bi bi-person-plus"></i></div> JEE-Blog
      </div>
      <p class="auth-left-tagline">
        ${lang=='fr'
          ? 'Créez votre compte gratuitement et rejoignez notre communauté de développeurs Jakarta EE.'
          : 'Create your free account and join our Jakarta EE developer community.'}
      </p>
      <ul class="auth-left-features list-unstyled">
        <li><i class="bi bi-shield-check-fill"></i>${lang=='fr'?'Validation par email sécurisée':'Secure email validation'}</li>
        <li><i class="bi bi-pencil-square"></i>${lang=='fr'?'Publiez des articles illimités':'Publish unlimited articles'}</li>
        <li><i class="bi bi-mortarboard-fill"></i>${lang=='fr'?'Profil avec filière & semestre':'Profile with filiere & semester'}</li>
        <li><i class="bi bi-chat-dots-fill"></i>${lang=='fr'?'Participez aux discussions':'Participate in discussions'}</li>
        <li><i class="bi bi-moon-stars-fill"></i>${lang=='fr'?'Mode sombre inclus':'Dark mode included'}</li>
      </ul>
    </div>

    <%-- RIGHT PANEL --%>
    <div class="auth-panel-right">
      <h3><fmt:message key="register.title" bundle="${bundle}"/></h3>
      <p class="auth-sub">${lang=='fr'?'Un email de confirmation sera envoyé après inscription.':'A confirmation email will be sent after registration.'}</p>

      <c:if test="${not empty success}">
        <div class="alert alert-success mb-3">
          <i class="bi bi-envelope-check me-2"></i><fmt:message key="register.success" bundle="${bundle}"/>
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3">
          <i class="bi bi-exclamation-circle me-2"></i>
          <c:choose>
            <c:when test="${error=='email_exists'}"><fmt:message key="register.error.email_exists" bundle="${bundle}"/></c:when>
            <c:when test="${error=='username_exists'}"><fmt:message key="register.error.username_exists" bundle="${bundle}"/></c:when>
            <c:when test="${error=='all_fields_required'}"><fmt:message key="register.error.all_fields" bundle="${bundle}"/></c:when>
            <c:otherwise><fmt:message key="register.error.failed" bundle="${bundle}"/></c:otherwise>
          </c:choose>
        </div>
      </c:if>

      <c:if test="${empty success}">
        <form action="${pageContext.request.contextPath}/register" method="post">
          <div class="row g-3 mb-3">
            <div class="col-6">
              <label class="form-label"><fmt:message key="register.firstname" bundle="${bundle}"/></label>
              <input type="text" name="firstName" class="form-control"
                     placeholder="${lang=='fr'?'Prénom':'First name'}" required/>
            </div>
            <div class="col-6">
              <label class="form-label"><fmt:message key="register.lastname" bundle="${bundle}"/></label>
              <input type="text" name="lastName" class="form-control"
                     placeholder="${lang=='fr'?'Nom':'Last name'}" required/>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label"><fmt:message key="register.username" bundle="${bundle}"/></label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-at"></i></span>
              <input type="text" name="username" class="form-control" placeholder="monpseudo" required/>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label"><fmt:message key="register.email" bundle="${bundle}"/></label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-envelope"></i></span>
              <input type="email" name="email" class="form-control" placeholder="email@exemple.com" required/>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label"><fmt:message key="register.password" bundle="${bundle}"/></label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-lock"></i></span>
              <input type="password" name="password" class="form-control" placeholder="••••••••" required minlength="6"/>
            </div>
          </div>

          <%-- FILIERE & SEMESTER --%>
          <div class="row g-3 mb-3">
            <div class="col-7">
              <label class="form-label">
                <i class="bi bi-mortarboard me-1" style="color:var(--accent)"></i>
                ${lang=='fr'?'Filière':'Field of study'}
              </label>
              <select name="filiere" class="form-select" required>
                <option value="">${lang=='fr'?'-- Choisir --':'-- Select --'}</option>
                <%-- Filières demandées par l'utilisateur --%>
                <option value="CDL">CDL – Cycle de Licence</option>
                <option value="TCC">TCC – Technicien en Commerce &amp; Communication</option>
                <option value="TM">TM – Technicien en Maintenance</option>
                <option value="Génie Électrique">Génie Électrique</option>
                <option value="Génie Bio-Industriel">Génie Bio-Industriel</option>
                <%-- 4 filières supplémentaires --%>
                <option value="Génie Informatique">Génie Informatique</option>
                <option value="Génie Civil">Génie Civil</option>
                <option value="GEA">GEA – Gestion des Entreprises &amp; Administrations</option>
                <option value="Commerce et Marketing">Commerce &amp; Marketing International</option>
              </select>
            </div>
            <div class="col-5">
              <label class="form-label">
                <i class="bi bi-calendar2-week me-1" style="color:var(--accent)"></i>
                ${lang=='fr'?'Semestre':'Semester'}
              </label>
              <select name="semester" class="form-select" required>
                <option value="0">${lang=='fr'?'-- S# --':'-- S# --'}</option>
                <option value="1">S1</option>
                <option value="2">S2</option>
                <option value="3">S3</option>
                <option value="4">S4</option>
              </select>
            </div>
          </div>

          <div class="mb-4">
            <label class="form-label"><fmt:message key="register.bio" bundle="${bundle}"/></label>
            <textarea name="bio" class="form-control" rows="2"
                      placeholder="${lang=='fr'?'Quelques mots sur vous...':'A few words about you...'}"></textarea>
          </div>

          <button type="submit" class="btn-primary-custom w-100 justify-content-center">
            <fmt:message key="register.submit" bundle="${bundle}"/><i class="bi bi-arrow-right ms-1"></i>
          </button>
        </form>
      </c:if>

      <hr class="divider mt-4"/>
      <p style="text-align:center;font-size:0.85rem;color:var(--text-muted);margin:0">
        <fmt:message key="register.have_account" bundle="${bundle}"/>
        <a href="${pageContext.request.contextPath}/login" style="color:var(--accent);font-weight:700;text-decoration:none">
          <fmt:message key="register.login_link" bundle="${bundle}"/>
        </a>
      </p>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
