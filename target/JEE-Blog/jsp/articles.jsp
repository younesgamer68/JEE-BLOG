<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp"/>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />

<%-- HERO --%>
<div class="hero-banner">
  <div class="hero-mesh"></div>
  <div class="hero-particles">
    <span></span><span></span><span></span><span></span><span></span><span></span>
  </div>
  <div class="container hero-content">
    <div class="d-flex flex-wrap align-items-end justify-content-between gap-4">
      <div>
        <div class="hero-eyebrow">
          <span class="dot"></span>
          ${lang=='fr'?'Plateforme éducative — Jakarta EE':'Educational Platform — Jakarta EE'}
        </div>
        <h1 class="hero-title">
          ${lang=='fr'?'Découvrez nos':'Discover our'}<br/>
          <span class="hl">${lang=='fr'?'Articles & Tutoriels':'Articles & Tutorials'}</span>
        </h1>
        <p class="hero-sub">
          ${lang=='fr'
            ? 'Explorez des articles sur Jakarta EE, Servlets, JSP, JSTL et les meilleures pratiques du développement web Java.'
            : 'Explore articles on Jakarta EE, Servlets, JSP, JSTL and Java web development best practices.'}
        </p>
        <div class="hero-stats">
          <div class="hero-stat">
            <span class="num">${totalCount}</span>
            <span class="lbl">Articles</span>
          </div>
          <div class="hero-stat">
            <span class="num">${totalPages}</span>
            <span class="lbl">Pages</span>
          </div>
          <div class="hero-stat">
            <span class="num">2</span>
            <span class="lbl">${lang=='fr'?'Langues':'Languages'}</span>
          </div>
          <div class="hero-stat">
            <span class="num">MVC</span>
            <span class="lbl">Architecture</span>
          </div>
        </div>
      </div>
      <c:if test="${not empty sessionScope.currentUser}">
        <a href="${pageContext.request.contextPath}/articles?action=add" class="btn-primary-custom">
          <i class="bi bi-plus-lg"></i>
          <fmt:message key="nav.add_article" bundle="${bundle}"/>
        </a>
      </c:if>
    </div>
  </div>
</div>

<div class="container pb-2">

  <c:choose>
    <c:when test="${empty articles}">
      <div style="text-align:center;padding:5rem 2rem;color:var(--text-muted)">
        <i class="bi bi-journal-x" style="font-size:4rem;opacity:0.15;display:block;margin-bottom:1rem"></i>
        <p style="font-size:1rem;font-weight:500"><fmt:message key="articles.no_articles" bundle="${bundle}"/></p>
        <c:if test="${not empty sessionScope.currentUser}">
          <a href="${pageContext.request.contextPath}/articles?action=add" class="btn-primary-custom mt-2">
            <i class="bi bi-plus-lg"></i>${lang=='fr'?'Écrire le premier article':'Write the first article'}
          </a>
        </c:if>
      </div>
    </c:when>
    <c:otherwise>
      <%-- Article grid --%>
      <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach var="article" items="${articles}" varStatus="st">
          <div class="col" style="animation:page-in 0.4s ease ${st.index * 0.06}s both">
            <div class="card article-card h-100">
              <div class="card-top-bar"></div>
              <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-3">
                  <span class="art-num"><i class="bi bi-hash"></i>${article.id}</span>
                  <span style="font-size:0.72rem;color:var(--text-muted)">
                    <fmt:formatDate value="${article.createdAt}" pattern="dd MMM yyyy"/>
                  </span>
                </div>
                <h5 class="mb-2">
                  <a href="${pageContext.request.contextPath}/articles?action=detail&id=${article.id}">
                    ${article.title}
                  </a>
                </h5>
                <div class="art-meta mb-3">
                  <span class="art-avatar">${article.authorUsername.substring(0,1).toUpperCase()}</span>
                  <span style="font-weight:600;color:var(--text-primary)">${article.authorUsername}</span>
                </div>
                <p class="art-excerpt">
                  ${article.content.length() > 130
                    ? article.content.substring(0,130).concat('...')
                    : article.content}
                </p>
              </div>
              <div class="card-foot">
                <a href="${pageContext.request.contextPath}/articles?action=detail&id=${article.id}"
                   class="btn-ghost-custom" style="color:var(--accent);font-weight:600">
                  <fmt:message key="articles.read_more" bundle="${bundle}"/>
                  <i class="bi bi-arrow-right"></i>
                </a>
                <span style="font-size:0.72rem;color:var(--text-muted)"><i class="bi bi-chat"></i></span>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

      <%-- PAGINATION --%>
      <c:if test="${totalPages > 1}">
        <div class="pagination-wrap">
          <%-- Prev --%>
          <a href="${pageContext.request.contextPath}/articles?page=${currentPage - 1}"
             class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
            <i class="bi bi-chevron-left"></i>
          </a>

          <%-- Page numbers --%>
          <c:forEach begin="1" end="${totalPages}" var="p">
            <c:choose>
              <c:when test="${p == currentPage}">
                <span class="page-btn active">${p}</span>
              </c:when>
              <c:when test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                <a href="${pageContext.request.contextPath}/articles?page=${p}" class="page-btn">${p}</a>
              </c:when>
              <c:when test="${p == currentPage - 3 || p == currentPage + 3}">
                <span class="page-btn disabled" style="border:none;background:transparent">...</span>
              </c:when>
            </c:choose>
          </c:forEach>

          <%-- Next --%>
          <a href="${pageContext.request.contextPath}/articles?page=${currentPage + 1}"
             class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
            <i class="bi bi-chevron-right"></i>
          </a>
        </div>

        <p style="text-align:center;font-size:0.78rem;color:var(--text-muted);padding-bottom:20px">
          ${lang=='fr'?'Page':'Page'} ${currentPage} ${lang=='fr'?'sur':'of'} ${totalPages}
          &bull; ${totalCount} ${lang=='fr'?'articles au total':'articles total'}
        </p>
      </c:if>

    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="footer.jsp"/>
