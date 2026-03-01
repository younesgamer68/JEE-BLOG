<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />

<footer class="site-footer">
  <div class="footer-bg-grid"></div>
  <div class="footer-bg-glow"></div>

  <%-- CENTER LOGO BLOCK --%>
  <div class="footer-center-logo">
    <div class="footer-logo-mark">
      <div class="footer-logo-icon"><i class="bi bi-journal-richtext"></i></div>
      <div class="footer-logo-text">JEE<span>-Blog</span></div>
    </div>
    <p class="footer-tagline">
      ${lang=='fr'
        ? 'Plateforme éducative de blogging construite avec Jakarta EE, Servlets, JSP & JSTL. Projet académique — EST Agadir, Maroc.'
        : 'Educational blogging platform built with Jakarta EE, Servlets, JSP & JSTL. Academic project — EST Agadir, Morocco.'}
    </p>

    <div class="footer-social-row">
      <a href="https://github.com/younesgamer68" class="footer-social-btn" title="GitHub" target="_blank"><i class="bi bi-github"></i></a>
      <a href="https://www.linkedin.com/in/youness-ben-touttibt-2a773b336/" class="footer-social-btn" title="LinkedIn" target="_blank"><i class="bi bi-linkedin"></i></a>
      <a href="https://x.com/Hadroc1" class="footer-social-btn" title="Twitter/X" target="_blank"><i class="bi bi-twitter-x"></i></a>
      <a href="https://mail.google.com/mail/u/0/#inbox" class="footer-social-btn" title="Email" target="_blank"><i class="bi bi-envelope-fill"></i></a>
      <a href="https://www.youtube.com/" class="footer-social-btn" title="YouTube" target="_blank"><i class="bi bi-youtube"></i></a>
    </div>
  </div>

  <%-- MAIN COLUMNS --%>
  <div class="footer-main">
    <div class="container">
      <div class="row g-5 justify-content-center">

        <%-- Navigation --%>
        <div class="col-lg-3 col-md-4 footer-col">
          <h6>${lang=='fr'?'Navigation':'Navigation'}</h6>
          <ul class="footer-links">
            <li><a href="${pageContext.request.contextPath}/articles"><i class="bi bi-chevron-right"></i><fmt:message key="nav.articles" bundle="${bundle}"/></a></li>
            <c:if test="${not empty sessionScope.currentUser}">
              <li><a href="${pageContext.request.contextPath}/articles?action=add"><i class="bi bi-chevron-right"></i><fmt:message key="nav.add_article" bundle="${bundle}"/></a></li>
              <li><a href="${pageContext.request.contextPath}/profile"><i class="bi bi-chevron-right"></i><fmt:message key="nav.profile" bundle="${bundle}"/></a></li>
              <li><a href="${pageContext.request.contextPath}/logout"><i class="bi bi-chevron-right"></i><fmt:message key="nav.logout" bundle="${bundle}"/></a></li>
            </c:if>
            <c:if test="${empty sessionScope.currentUser}">
              <li><a href="${pageContext.request.contextPath}/login"><i class="bi bi-chevron-right"></i><fmt:message key="nav.login" bundle="${bundle}"/></a></li>
              <li><a href="${pageContext.request.contextPath}/register"><i class="bi bi-chevron-right"></i><fmt:message key="nav.register" bundle="${bundle}"/></a></li>
            </c:if>
          </ul>
        </div>

        <%-- Contact --%>
        <div class="col-lg-4 col-md-5 footer-col">
          <h6>${lang=='fr'?'Contact':'Contact'}</h6>
          <div class="footer-contact-item">
            <i class="bi bi-geo-alt-fill"></i>
            <span>${lang=='fr'?'École Supérieure de Technologie, Agadir, Maroc':'École Supérieure de Technologie, Agadir, Morocco'}</span>
          </div>
          <div class="footer-contact-item">
            <i class="bi bi-envelope-fill"></i>
            <a href="mailto:gameryounes68@gmail.com">gameryounes68@gmail.com</a>
          </div>
          <div class="footer-contact-item">
            <i class="bi bi-mortarboard-fill"></i>
            <span>${lang=='fr'?'Projet TP Jakarta EE':'Jakarta EE TP Project'}</span>
          </div>
          <div class="footer-contact-item">
            <i class="bi bi-clock-fill"></i>
            <span>${lang=='fr'?'Lun – Ven, 9h – 17h (GMT+1)':'Mon – Fri, 9am – 5pm (GMT+1)'}</span>
          </div>
        </div>

      </div>
    </div>
  </div>

  <%-- BOTTOM BAR --%>
  <div class="footer-bottom">
    <div class="container d-flex flex-wrap align-items-center justify-content-between gap-2">
      <p class="copy mb-0">&copy; <fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy"/> JEE-Blog &mdash; ${lang=='fr'?'Tous droits réservés':'All rights reserved'} &mdash; EST Agadir</p>
      <div class="footer-bottom-links">
        <a href="#">${lang=='fr'?'Confidentialité':'Privacy'}</a>
        <a href="#">${lang=='fr'?'Conditions':'Terms'}</a>
        <a href="#">Cookies</a>
      </div>
    </div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
