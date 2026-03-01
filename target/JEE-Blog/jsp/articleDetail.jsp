<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp"/>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />

<c:if test="${not empty article}">

<%-- ARTICLE DARK HEADER --%>
<div class="article-header">
  <div class="mesh"></div>
  <div class="container" style="position:relative;z-index:1">
    <a href="${pageContext.request.contextPath}/articles" class="btn-ghost-custom mb-3 d-inline-flex"
       style="color:rgba(255,255,255,0.45)">
      <i class="bi bi-arrow-left"></i><fmt:message key="article.back" bundle="${bundle}"/>
    </a>
    <h1>${article.title}</h1>
    <div class="art-meta-bar">
      <span>
        <span class="art-avatar" style="width:26px;height:26px;font-size:0.68rem;display:inline-flex">${article.authorUsername.substring(0,1).toUpperCase()}</span>
        &nbsp;${article.authorUsername}
      </span>
      <span><i class="bi bi-calendar3 me-1"></i><fmt:formatDate value="${article.createdAt}" pattern="dd MMM yyyy, HH:mm"/></span>
      <c:if test="${not empty article.updatedAt}">
        <span><i class="bi bi-pencil me-1"></i>${lang=='fr'?'Modifié le':'Edited'} <fmt:formatDate value="${article.updatedAt}" pattern="dd MMM yyyy"/></span>
      </c:if>
    </div>
    <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.id == article.authorId}">
      <div class="d-flex gap-2 flex-wrap mt-3">
        <a href="${pageContext.request.contextPath}/articles?action=edit&id=${article.id}" class="btn-warn-custom">
          <i class="bi bi-pencil"></i><fmt:message key="article.edit" bundle="${bundle}"/>
        </a>
        <a href="${pageContext.request.contextPath}/articles?action=delete&id=${article.id}"
           class="btn-danger-custom"
           onclick="return confirm('<fmt:message key="btn.confirm_delete" bundle="${bundle}"/>')">
          <i class="bi bi-trash"></i><fmt:message key="article.delete" bundle="${bundle}"/>
        </a>
      </div>
    </c:if>
  </div>
</div>

<div class="container py-4">
  <div class="row g-4">
    <div class="col-lg-8">
      <div class="article-body mb-4">${article.content}</div>

      <%-- COMMENTS --%>
      <div class="card">
        <div class="ch-dark d-flex align-items-center justify-content-between">
          <span><i class="bi bi-chat-dots me-2"></i><fmt:message key="article.comments" bundle="${bundle}"/></span>
          <span class="badge-blue">${comments.size()}</span>
        </div>
        <c:choose>
          <c:when test="${empty comments}">
            <div style="padding:2.5rem;text-align:center;color:var(--text-muted);font-size:0.88rem">
              <i class="bi bi-chat" style="font-size:2rem;opacity:0.15;display:block;margin-bottom:8px"></i>
              <fmt:message key="article.no_comments" bundle="${bundle}"/>
            </div>
          </c:when>
          <c:otherwise>
            <c:forEach var="comment" items="${comments}">
              <div class="comment-item">
                <div class="comment-author">
                  <span class="art-avatar">${comment.authorUsername.substring(0,1).toUpperCase()}</span>
                  ${comment.authorUsername}
                  <span class="comment-date"><fmt:formatDate value="${comment.createdAt}" pattern="dd MMM yyyy, HH:mm"/></span>
                  <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.id == comment.authorId}">
                    <form action="${pageContext.request.contextPath}/comments" method="post" class="ms-auto d-inline">
                      <input type="hidden" name="action" value="delete"/>
                      <input type="hidden" name="commentId" value="${comment.id}"/>
                      <input type="hidden" name="articleId" value="${article.id}"/>
                      <button class="btn-ghost-custom" style="padding:0.15rem 0.4rem;font-size:0.72rem"
                              onclick="return confirm('<fmt:message key="btn.confirm_delete" bundle="${bundle}"/>')">
                        <i class="bi bi-trash"></i>
                      </button>
                    </form>
                  </c:if>
                </div>
                <p class="comment-text mb-0">${comment.content}</p>
              </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>

        <c:if test="${not empty sessionScope.currentUser}">
          <div style="padding:1.3rem;background:var(--accent-light);border-top:1px solid var(--border)">
            <p style="font-size:0.8rem;font-weight:700;color:var(--text-secondary);margin-bottom:8px">
              <i class="bi bi-plus-circle me-1"></i><fmt:message key="article.add_comment" bundle="${bundle}"/>
            </p>
            <form action="${pageContext.request.contextPath}/comments" method="post">
              <input type="hidden" name="articleId" value="${article.id}"/>
              <textarea name="content" class="form-control mb-2" rows="3"
                        placeholder="<fmt:message key='article.comment_placeholder' bundle='${bundle}'/>"></textarea>
              <button type="submit" class="btn-primary-custom">
                <i class="bi bi-send"></i><fmt:message key="article.submit_comment" bundle="${bundle}"/>
              </button>
            </form>
          </div>
        </c:if>
        <c:if test="${empty sessionScope.currentUser}">
          <div style="padding:1.1rem;text-align:center;background:var(--accent-light);border-top:1px solid var(--border)">
            <small style="color:var(--text-muted)">
              <a href="${pageContext.request.contextPath}/login" style="color:var(--accent);font-weight:600">${lang=='fr'?'Connectez-vous':'Log in'}</a>
              ${lang=='fr'?' pour commenter.':' to comment.'}
            </small>
          </div>
        </c:if>
      </div>
    </div>

    <%-- SIDEBAR --%>
    <div class="col-lg-4">
      <div class="card" style="position:sticky;top:80px">
        <div class="ch-dark"><i class="bi bi-person me-2"></i>${lang=='fr'?'Auteur':'Author'}</div>
        <div style="padding:1.5rem;text-align:center">
          <div class="art-avatar mx-auto mb-2" style="width:48px;height:48px;font-size:1.2rem">
            ${article.authorUsername.substring(0,1).toUpperCase()}
          </div>
          <p style="font-weight:700;color:var(--text-primary);margin-bottom:4px">${article.authorUsername}</p>
          <p style="font-size:0.78rem;color:var(--text-muted)">${lang=='fr'?'Membre JEE-Blog':'JEE-Blog member'}</p>
        </div>
        <hr class="divider" style="margin:0"/>
        <div style="padding:1rem 1.3rem">
          <p style="font-size:0.72rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:1.5px;font-weight:700;margin-bottom:6px">
            ${lang=='fr'?'Publié le':'Published on'}
          </p>
          <p style="font-size:0.88rem;color:var(--text-primary);margin:0">
            <i class="bi bi-calendar3 me-2" style="color:var(--accent)"></i>
            <fmt:formatDate value="${article.createdAt}" pattern="dd MMMM yyyy"/>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>
</c:if>

<jsp:include page="footer.jsp"/>
