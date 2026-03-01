<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp"/>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />

<%-- PROFILE HERO --%>
<div class="profile-hero">
  <div class="container">
    <div class="d-flex align-items-center gap-4 flex-wrap" style="position:relative;z-index:1">
      <div class="profile-avatar">${user.username.substring(0,1).toUpperCase()}</div>
      <div>
        <div class="profile-name">${user.firstName} ${user.lastName}</div>
        <div class="profile-email"><i class="bi bi-envelope me-1"></i>${user.email}</div>
        <div style="margin-top:8px;display:flex;gap:6px;flex-wrap:wrap">
          <c:if test="${not empty user.filiere}">
            <span class="badge-blue"><i class="bi bi-mortarboard me-1"></i>${user.filiere}</span>
          </c:if>
          <c:if test="${user.semester > 0}">
            <span class="badge-blue"><i class="bi bi-calendar2-week me-1"></i>S${user.semester}</span>
          </c:if>
          <span class="badge-blue" style="background:rgba(255,255,255,0.06);border-color:rgba(255,255,255,0.1);color:rgba(255,255,255,0.45)">
            <i class="bi bi-journal-text me-1"></i>${myArticles.size()} ${lang=='fr'?'articles':'articles'}
          </span>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="container py-4">
  <div class="row g-4">

    <%-- EDIT FORM --%>
    <div class="col-lg-5">
      <div class="card">
        <div class="ch-dark"><i class="bi bi-pencil-square me-2"></i><fmt:message key="profile.info" bundle="${bundle}"/></div>
        <div class="card-body p-4">
          <c:if test="${not empty success}">
            <div class="alert alert-success mb-3"><i class="bi bi-check-circle"></i><fmt:message key="profile.success" bundle="${bundle}"/></div>
          </c:if>
          <c:if test="${not empty error}">
            <div class="alert alert-danger mb-3"><i class="bi bi-exclamation-circle"></i><fmt:message key="profile.error" bundle="${bundle}"/></div>
          </c:if>

          <form action="${pageContext.request.contextPath}/profile" method="post">
            <div class="mb-3">
              <label class="form-label"><fmt:message key="register.username" bundle="${bundle}"/></label>
              <input type="text" class="form-control" value="${user.username}" readonly
                     style="opacity:0.5;cursor:not-allowed"/>
            </div>
            <div class="mb-3">
              <label class="form-label"><fmt:message key="register.email" bundle="${bundle}"/></label>
              <input type="email" class="form-control" value="${user.email}" readonly
                     style="opacity:0.5;cursor:not-allowed"/>
            </div>
            <div class="row g-3 mb-3">
              <div class="col-6">
                <label class="form-label"><fmt:message key="register.firstname" bundle="${bundle}"/></label>
                <input type="text" name="firstName" class="form-control" value="${user.firstName}" required/>
              </div>
              <div class="col-6">
                <label class="form-label"><fmt:message key="register.lastname" bundle="${bundle}"/></label>
                <input type="text" name="lastName" class="form-control" value="${user.lastName}" required/>
              </div>
            </div>

            <%-- FILIERE & SEMESTER --%>
            <div class="row g-3 mb-3">
              <div class="col-7">
                <label class="form-label"><i class="bi bi-mortarboard me-1" style="color:var(--accent)"></i>${lang=='fr'?'Filière':'Field of study'}</label>
                <select name="filiere" class="form-select">
                  <option value="">${lang=='fr'?'-- Choisir --':'-- Select --'}</option>
                  <option value="Génie Informatique" ${user.filiere=='Génie Informatique'?'selected':''}>Génie Informatique</option>
                  <option value="Génie Logiciel" ${user.filiere=='Génie Logiciel'?'selected':''}>Génie Logiciel</option>
                  <option value="Réseaux & Télécoms" ${user.filiere=='Réseaux & Télécoms'?'selected':''}>Réseaux &amp; Télécoms</option>
                  <option value="Systèmes Embarqués" ${user.filiere=='Systèmes Embarqués'?'selected':''}>Systèmes Embarqués</option>
                  <option value="Intelligence Artificielle" ${user.filiere=='Intelligence Artificielle'?'selected':''}>Intelligence Artificielle</option>
                  <option value="Cybersécurité" ${user.filiere=='Cybersécurité'?'selected':''}>Cybersécurité</option>
                  <option value="Génie Électronique" ${user.filiere=='Génie Électronique'?'selected':''}>Génie Électronique</option>
                  <option value="Autre" ${user.filiere=='Autre'?'selected':''}>Autre / Other</option>
                </select>
              </div>
              <div class="col-5">
                <label class="form-label"><i class="bi bi-calendar2-week me-1" style="color:var(--accent)"></i>${lang=='fr'?'Semestre':'Semester'}</label>
                <select name="semester" class="form-select">
                  <option value="0">--</option>
                  <option value="1" ${user.semester==1?'selected':''}>S1</option>
                  <option value="2" ${user.semester==2?'selected':''}>S2</option>
                  <option value="3" ${user.semester==3?'selected':''}>S3</option>
                  <option value="4" ${user.semester==4?'selected':''}>S4</option>
                  <option value="5" ${user.semester==5?'selected':''}>S5</option>
                  <option value="6" ${user.semester==6?'selected':''}>S6</option>
                </select>
              </div>
            </div>

            <div class="mb-4">
              <label class="form-label"><fmt:message key="register.bio" bundle="${bundle}"/></label>
              <textarea name="bio" class="form-control" rows="3">${user.bio}</textarea>
            </div>
            <button type="submit" class="btn-primary-custom w-100 justify-content-center">
              <i class="bi bi-save"></i><fmt:message key="profile.update" bundle="${bundle}"/>
            </button>
          </form>
        </div>
      </div>
    </div>

    <%-- MY ARTICLES --%>
    <div class="col-lg-7">
      <div class="card">
        <div class="ch-dark d-flex align-items-center justify-content-between">
          <span><i class="bi bi-journal-text me-2"></i><fmt:message key="profile.my_articles" bundle="${bundle}"/></span>
          <span class="badge-blue">${myArticles.size()}</span>
        </div>
        <c:choose>
          <c:when test="${empty myArticles}">
            <div style="padding:3rem;text-align:center;color:var(--text-muted)">
              <i class="bi bi-journal-plus" style="font-size:2.5rem;opacity:0.15;display:block;margin-bottom:10px"></i>
              <p style="font-size:0.88rem;margin-bottom:16px"><fmt:message key="articles.no_articles" bundle="${bundle}"/></p>
              <a href="${pageContext.request.contextPath}/articles?action=add" class="btn-primary-custom">
                <i class="bi bi-plus-lg"></i>${lang=='fr'?'Écrire un article':'Write an article'}
              </a>
            </div>
          </c:when>
          <c:otherwise>
            <ul class="list-group list-group-flush">
              <c:forEach var="article" items="${myArticles}">
                <li class="list-group-item d-flex align-items-center justify-content-between">
                  <div style="min-width:0;flex:1">
                    <a href="${pageContext.request.contextPath}/articles?action=detail&id=${article.id}">${article.title}</a>
                    <div style="font-size:0.72rem;color:var(--text-muted);margin-top:2px">
                      <fmt:formatDate value="${article.createdAt}" pattern="dd MMM yyyy"/>
                    </div>
                  </div>
                  <div class="d-flex gap-1 ms-2 flex-shrink-0">
                    <a href="${pageContext.request.contextPath}/articles?action=edit&id=${article.id}" class="btn-warn-custom"><i class="bi bi-pencil"></i></a>
                    <a href="${pageContext.request.contextPath}/articles?action=delete&id=${article.id}"
                       class="btn-danger-custom"
                       onclick="return confirm('<fmt:message key="btn.confirm_delete" bundle="${bundle}"/>')">
                      <i class="bi bi-trash"></i>
                    </a>
                  </div>
                </li>
              </c:forEach>
            </ul>
            <div style="padding:0.85rem 1.2rem;border-top:1px solid var(--border);text-align:right">
              <a href="${pageContext.request.contextPath}/articles?action=add" class="btn-ghost-custom" style="color:var(--accent);font-weight:600">
                <i class="bi bi-plus-circle"></i>${lang=='fr'?'Nouvel article':'New article'}
              </a>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

  </div>
</div>

<jsp:include page="footer.jsp"/>
