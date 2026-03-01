<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp"/>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />

<div style="background:var(--bg-hero);padding:40px 0 30px;border-bottom:1px solid rgba(255,255,255,0.05);position:relative;overflow:hidden">
  <div style="position:absolute;inset:0;background:radial-gradient(ellipse 500px 250px at 20% 50%,rgba(37,99,176,0.18) 0%,transparent 60%)"></div>
  <div class="container" style="position:relative;z-index:1">
    <a href="${pageContext.request.contextPath}/articles" class="btn-ghost-custom mb-3 d-inline-flex" style="color:rgba(255,255,255,0.45)">
      <i class="bi bi-arrow-left"></i><fmt:message key="article.back" bundle="${bundle}"/>
    </a>
    <h2 style="color:white;font-weight:800;font-size:1.8rem;letter-spacing:-0.5px;margin:0">
      <c:choose>
        <c:when test="${not empty article}"><fmt:message key="form.edit_article" bundle="${bundle}"/></c:when>
        <c:otherwise><fmt:message key="form.new_article" bundle="${bundle}"/></c:otherwise>
      </c:choose>
    </h2>
  </div>
</div>

<div class="container py-4" style="max-width:820px">
  <c:if test="${not empty error}">
    <div class="alert alert-danger mb-3"><i class="bi bi-exclamation-circle"></i><fmt:message key="register.error.all_fields" bundle="${bundle}"/></div>
  </c:if>

  <div class="card">
    <div class="card-body p-4">
      <form action="${pageContext.request.contextPath}/articles" method="post">
        <c:choose>
          <c:when test="${not empty article}">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="id" value="${article.id}"/>
          </c:when>
          <c:otherwise><input type="hidden" name="action" value="create"/></c:otherwise>
        </c:choose>

        <div class="mb-4">
          <label class="form-label" style="font-size:0.72rem;text-transform:uppercase;letter-spacing:1.8px">
            <fmt:message key="form.title" bundle="${bundle}"/>
          </label>
          <input type="text" name="title" class="form-control"
                 style="font-size:1.1rem;font-weight:700;padding:0.75rem 1rem"
                 placeholder="${lang=='fr'?'Titre de l\'article...':'Article title...'}"
                 value="${not empty article ? article.title : ''}" required/>
        </div>

        <div class="mb-4">
          <label class="form-label" style="font-size:0.72rem;text-transform:uppercase;letter-spacing:1.8px">
            <fmt:message key="form.content" bundle="${bundle}"/>
          </label>
          <textarea name="content" class="form-control" rows="14"
                    style="font-size:0.95rem;line-height:1.8;resize:vertical"
                    placeholder="${lang=='fr'?'Rédigez votre article ici...':'Write your article here...'}"
                    required>${not empty article ? article.content : ''}</textarea>
          <small style="color:var(--text-muted);font-size:0.73rem;margin-top:5px;display:block">
            <i class="bi bi-info-circle me-1"></i>${lang=='fr'?'Les sauts de ligne sont préservés.':'Line breaks are preserved.'}
          </small>
        </div>

        <div class="d-flex gap-2 flex-wrap">
          <button type="submit" class="btn-primary-custom">
            <i class="bi bi-save"></i><fmt:message key="form.save" bundle="${bundle}"/>
          </button>
          <a href="${pageContext.request.contextPath}/articles" class="btn-outline-custom">
            <i class="bi bi-x"></i><fmt:message key="form.cancel" bundle="${bundle}"/>
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
