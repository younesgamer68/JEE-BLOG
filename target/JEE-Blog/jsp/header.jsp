<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="lang" value="${not empty sessionScope.lang ? sessionScope.lang : 'fr'}" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages" var="bundle" />
<!DOCTYPE html>
<html lang="${lang}" data-theme="dark">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>JEE-Blog</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <script>
    (function(){
      var t=localStorage.getItem('jee_theme')||'dark';
      document.documentElement.setAttribute('data-theme',t);
    })();
  </script>
</head>
<body>

<%-- LANGUAGE OVERLAY --%>
<div id="lang-overlay">
  <div class="overlay-grid"></div>
  <div class="overlay-orbs"><span></span><span></span><span></span></div>
  <div class="overlay-content">
    <div class="overlay-logo">JEE<em>-Blog</em></div>
    <div class="overlay-subtitle">${lang=='fr'?'Plateforme éducative':'Educational Platform'}</div>
    <div class="overlay-progress-track"><div class="overlay-progress-fill" id="overlay-bar"></div></div>
    <div class="overlay-msg" id="overlay-msg">Chargement...</div>
    <div class="overlay-dots mt-3"><span></span><span></span><span></span></div>
  </div>
</div>

<%-- NAVBAR --%>
<nav class="navbar navbar-expand-lg" id="mainNav">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/articles">
      <div class="brand-icon"><i class="bi bi-journal-richtext"></i></div>JEE-Blog
    </a>
    <button class="navbar-toggler border-0 p-1" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
      <i class="bi bi-list fs-4" style="color:rgba(255,255,255,0.6)"></i>
    </button>
    <div class="collapse navbar-collapse" id="navContent">
      <ul class="navbar-nav me-auto gap-1">
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/articles">
            <i class="bi bi-grid-3x3-gap me-1"></i><fmt:message key="nav.articles" bundle="${bundle}"/>
          </a>
        </li>
        <c:if test="${not empty sessionScope.currentUser}">
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/articles?action=add">
              <i class="bi bi-plus-circle me-1"></i><fmt:message key="nav.add_article" bundle="${bundle}"/>
            </a>
          </li>
        </c:if>
      </ul>
      <ul class="navbar-nav ms-auto align-items-center gap-2">

        <%-- DARK/LIGHT LEVER --%>
        <li class="nav-item">
          <div class="theme-toggle" id="themeToggle" title="Toggle theme">
            <i class="bi bi-moon-stars-fill toggle-icon-left"></i>
            <div class="toggle-track"><div class="toggle-thumb"></div></div>
            <i class="bi bi-sun-fill toggle-icon-right"></i>
          </div>
        </li>

        <%-- LANGUAGE --%>
        <li class="nav-item dropdown">
          <a class="nav-link lang-btn dropdown-toggle" href="#" id="langDrop" role="button" data-bs-toggle="dropdown">
            <i class="bi bi-globe2"></i>
            <c:choose><c:when test="${lang=='fr'}">🇫🇷 FR</c:when><c:otherwise>🇬🇧 EN</c:otherwise></c:choose>
          </a>
          <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item lang-switch" href="${pageContext.request.contextPath}/language?lang=fr" data-msg="Chargement du français...">🇫🇷 &nbsp;Français</a></li>
            <li><a class="dropdown-item lang-switch" href="${pageContext.request.contextPath}/language?lang=en" data-msg="Loading English...">🇬🇧 &nbsp;English</a></li>
          </ul>
        </li>

        <%-- SETTINGS --%>
        <li class="nav-item">
          <button class="settings-btn" data-bs-toggle="modal" data-bs-target="#settingsModal">
            <i class="bi bi-sliders2"></i>
          </button>
        </li>

        <c:choose>
          <c:when test="${not empty sessionScope.currentUser}">
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                <i class="bi bi-person-circle me-1"></i>${sessionScope.currentUser.username}
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right me-1"></i><fmt:message key="nav.logout" bundle="${bundle}"/>
              </a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/login">
                <i class="bi bi-door-open me-1"></i><fmt:message key="nav.login" bundle="${bundle}"/>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link btn-nav-cta" href="${pageContext.request.contextPath}/register">
                <i class="bi bi-person-plus me-1"></i><fmt:message key="nav.register" bundle="${bundle}"/>
              </a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<%-- SETTINGS MODAL --%>
<div class="modal fade settings-modal" id="settingsModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-sliders2 me-2"></i>${lang=='fr'?'Paramètres':'Settings'}</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="toggle-row">
          <div>
            <div class="toggle-label"><i class="bi bi-play-circle me-2" style="color:var(--accent)"></i>${lang=='fr'?'Animation de langue':'Language animation'}</div>
            <div class="toggle-desc">${lang=='fr'?'Écran de chargement lors du changement':'Loading screen when switching'}</div>
          </div>
          <div class="form-check form-switch ms-3"><input class="form-check-input" type="checkbox" id="animToggle"/></div>
        </div>
        <div class="toggle-row">
          <div>
            <div class="toggle-label"><i class="bi bi-stars me-2" style="color:var(--accent)"></i>${lang=='fr'?'Animations de page':'Page animations'}</div>
            <div class="toggle-desc">${lang=='fr'?'Transitions fluides entre pages':'Smooth transitions between pages'}</div>
          </div>
          <div class="form-check form-switch ms-3"><input class="form-check-input" type="checkbox" id="pageAnimToggle" checked/></div>
        </div>
        <hr class="divider mt-3"/>
        <div class="d-flex gap-2 justify-content-center">
          <a href="${pageContext.request.contextPath}/language?lang=fr" class="btn-outline-custom lang-switch" data-msg="Chargement du français...">🇫🇷 Français</a>
          <a href="${pageContext.request.contextPath}/language?lang=en" class="btn-outline-custom lang-switch" data-msg="Loading English...">🇬🇧 English</a>
        </div>
        <hr class="divider mt-3"/>
        <p style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin:0">JEE-Blog &bull; Jakarta EE 10 &bull; Tomcat 10.1 &bull; SQLite</p>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  var THEME_KEY='jee_theme', ANIM_KEY='jee_lang_anim', PAGE_KEY='jee_page_anim';
  var html=document.documentElement;
  var tog=document.getElementById('themeToggle');

  function applyTheme(t){
    html.setAttribute('data-theme',t);
    localStorage.setItem(THEME_KEY,t);
    tog.classList.toggle('light-active', t==='light');
  }
  applyTheme(localStorage.getItem(THEME_KEY)||'dark');
  tog.addEventListener('click',function(){
    applyTheme(html.getAttribute('data-theme')==='dark'?'light':'dark');
  });

  var nav=document.getElementById('mainNav');
  window.addEventListener('scroll',function(){nav.classList.toggle('scrolled',window.scrollY>40);});

  var animTog=document.getElementById('animToggle');
  var pageTog=document.getElementById('pageAnimToggle');
  if(animTog){animTog.checked=localStorage.getItem(ANIM_KEY)!=='false';animTog.addEventListener('change',function(){localStorage.setItem(ANIM_KEY,this.checked?'true':'false');});}
  if(pageTog){pageTog.checked=localStorage.getItem(PAGE_KEY)!=='false';pageTog.addEventListener('change',function(){localStorage.setItem(PAGE_KEY,this.checked?'true':'false');});}

  document.querySelectorAll('.lang-switch').forEach(function(link){
    link.addEventListener('click',function(e){
      if(localStorage.getItem(ANIM_KEY)==='false') return;
      e.preventDefault();
      var overlay=document.getElementById('lang-overlay');
      var msgEl=document.getElementById('overlay-msg');
      var barEl=document.getElementById('overlay-bar');
      if(msgEl) msgEl.textContent=this.dataset.msg||'Loading...';
      if(barEl){barEl.style.animation='none';barEl.offsetHeight;barEl.style.animation='';}
      overlay.classList.add('active');
      var href=this.href;
      setTimeout(function(){window.location.href=href;},1900);
    });
  });

  document.addEventListener('DOMContentLoaded',function(){
    if(localStorage.getItem(PAGE_KEY)!=='false') document.body.classList.add('page-enter');
  });
})();
</script>
