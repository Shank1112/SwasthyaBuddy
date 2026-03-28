<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
  Object userObj = session.getAttribute("user");
  if (userObj == null) { response.sendRedirect("login.jsp"); return; }
  com.swasthyabuddy.model.User user = (com.swasthyabuddy.model.User) userObj;
  String userName = user.getFirstName();
  List<Map<String,String>> history = (List<Map<String,String>>) session.getAttribute("predictionHistory");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — History</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    :root{--bg:#060b18;--surface:#0d1528;--surf2:#111e38;--accent:#3b82f6;--teal:#06b6d4;--emerald:#10b981;--rose:#f43f5e;--amber:#f59e0b;--white:#f8fafc;--muted:#64748b;--muted2:#94a3b8;--border:rgba(148,163,184,0.08);--border2:rgba(148,163,184,0.14);}
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--white);min-height:100vh;display:flex;}
    body::before{content:'';position:fixed;inset:0;background-image:linear-gradient(rgba(59,130,246,0.025) 1px,transparent 1px),linear-gradient(90deg,rgba(59,130,246,0.025) 1px,transparent 1px);background-size:40px 40px;pointer-events:none;z-index:0;}
    .sidebar{width:256px;background:var(--surface);border-right:1px solid var(--border);display:flex;flex-direction:column;flex-shrink:0;position:sticky;top:0;height:100vh;overflow-y:auto;z-index:100;}
    .sb-header{padding:22px 18px 18px;border-bottom:1px solid var(--border);}
    .sb-brand{display:flex;align-items:center;gap:11px;}
    .sb-logo{width:38px;height:38px;background:linear-gradient(135deg,var(--accent),var(--teal));border-radius:11px;display:flex;align-items:center;justify-content:center;font-size:18px;box-shadow:0 0 18px rgba(59,130,246,0.3);flex-shrink:0;}
    .sb-title{font-family:'Outfit',sans-serif;font-size:1rem;font-weight:700;}
    .sb-title em{color:var(--teal);font-style:normal;}
    .sb-sec{font-size:0.58rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.15em;padding:14px 18px 5px;}
    .nl{display:flex;align-items:center;gap:11px;padding:9px 14px;margin:2px 6px;color:var(--muted2);font-size:0.83rem;font-weight:500;text-decoration:none;border-radius:9px;transition:all 0.2s;}
    .nl:hover{color:var(--white);background:rgba(255,255,255,0.04);}
    .nl.active{color:var(--white);background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.15);}
    .nl.active .ni{color:var(--accent);}
    .ni{font-size:15px;width:20px;text-align:center;flex-shrink:0;}
    .nb{margin-left:auto;background:var(--accent);color:white;font-size:0.57rem;font-weight:700;padding:2px 6px;border-radius:20px;}
    .sb-footer{margin-top:auto;padding:14px;border-top:1px solid var(--border);}
    .uc{display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(255,255,255,0.03);border:1px solid var(--border);border-radius:11px;}
    .uc-av{width:32px;height:32px;background:linear-gradient(135deg,var(--accent),var(--teal));border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;flex-shrink:0;}
    .uc-name{font-size:0.78rem;font-weight:600;color:var(--white);}
    .uc-role{font-size:0.6rem;color:var(--muted);}
    .uc-out{margin-left:auto;color:var(--muted);text-decoration:none;font-size:15px;}
    .uc-out:hover{color:var(--rose);}
    .main{flex:1;display:flex;flex-direction:column;overflow-y:auto;position:relative;z-index:1;}
    .topbar{display:flex;align-items:center;justify-content:space-between;padding:14px 24px;border-bottom:1px solid var(--border);background:rgba(6,11,24,0.85);backdrop-filter:blur(20px);position:sticky;top:0;z-index:50;flex-shrink:0;}
    .tb-title{font-family:'Outfit',sans-serif;font-size:1rem;font-weight:700;}
    .tb-sub{font-size:0.7rem;color:var(--muted);margin-top:1px;}
    .content{padding:28px;max-width:900px;width:100%;margin:0 auto;}

    /* Stats row */
    .stats{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:28px;}
    .stat{background:var(--surface);border:1px solid var(--border2);border-radius:14px;padding:20px;transition:all 0.2s;animation:fadeUp 0.4s ease both;}
    .stat:nth-child(1){animation-delay:0.05s;} .stat:nth-child(2){animation-delay:0.1s;} .stat:nth-child(3){animation-delay:0.15s;}
    @keyframes fadeUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
    .stat:hover{border-color:rgba(59,130,246,0.2);transform:translateY(-2px);}
    .stat-n{font-family:'Outfit',sans-serif;font-size:2rem;font-weight:800;}
    .stat-l{font-size:0.72rem;color:var(--muted);margin-top:3px;}

    .sec-title{font-family:'Outfit',sans-serif;font-size:0.85rem;font-weight:700;margin-bottom:16px;display:flex;align-items:center;gap:8px;}
    .sec-title::after{content:'';flex:1;height:1px;background:var(--border);}

    /* History cards */
    .hc{background:var(--surface);border:1px solid var(--border2);border-radius:14px;padding:20px;margin-bottom:12px;transition:all 0.2s;animation:fadeUp 0.4s ease both;}
    .hc:hover{border-color:rgba(59,130,246,0.25);transform:translateX(3px);}
    .hc-top{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;margin-bottom:12px;}
    .hc-dis{font-family:'Outfit',sans-serif;font-size:1rem;font-weight:700;display:flex;align-items:center;gap:8px;}
    .hc-dis-icon{width:32px;height:32px;background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.2);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:14px;}
    .hc-date{font-size:0.68rem;color:var(--muted);white-space:nowrap;}
    .sym-tags{display:flex;flex-wrap:wrap;gap:5px;margin-bottom:14px;}
    .sym-t{padding:3px 9px;background:rgba(59,130,246,0.08);border:1px solid rgba(59,130,246,0.15);border-radius:20px;font-size:0.68rem;color:var(--accent);}
    .conf-row{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
    .conf-item .ci-label{font-size:0.62rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:5px;}
    .ci-bar{height:4px;background:rgba(255,255,255,0.06);border-radius:2px;overflow:hidden;margin-bottom:4px;}
    .ci-fill{height:100%;border-radius:2px;}
    .svm-fill{background:linear-gradient(90deg,var(--accent),var(--teal));}
    .dt-fill{background:linear-gradient(90deg,var(--emerald),#34d399);}
    .ci-pct{font-size:0.72rem;font-weight:700;}
    .svm-pct{color:var(--accent);} .dt-pct{color:var(--emerald);}

    /* Empty state */
    .empty{text-align:center;padding:64px 20px;}
    .empty-icon{font-size:3.5rem;opacity:0.2;margin-bottom:14px;}
    .empty-h{font-family:'Outfit',sans-serif;font-size:1rem;color:var(--muted2);margin-bottom:6px;}
    .empty-p{font-size:0.8rem;color:var(--muted);}
    .btn-start{display:inline-flex;align-items:center;gap:8px;margin-top:18px;padding:11px 22px;background:linear-gradient(135deg,var(--accent),#2563eb);border:none;border-radius:11px;color:white;font-family:'Outfit',sans-serif;font-size:0.88rem;font-weight:600;cursor:pointer;text-decoration:none;transition:all 0.2s;}
    .btn-start:hover{transform:translateY(-1px);box-shadow:0 6px 20px rgba(59,130,246,0.35);color:white;}

    @media(max-width:768px){.sidebar{display:none;}.stats{grid-template-columns:1fr;}.content{padding:20px 16px;}}
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-header"><div class="sb-brand"><div class="sb-logo">🩺</div><div class="sb-title">Swasthya<em>Buddy</em></div></div></div>
  <div class="sb-sec">Menu</div>
  <a href="patient-dashboard.jsp" class="nl"><span class="ni">💬</span>Symptom Check</a>
  <a href="result.jsp" class="nl"><span class="ni">📊</span>My Results</a>
  <a href="maps.jsp" class="nl"><span class="ni">🗺️</span>Find Clinics</a>
  <a href="medicines.jsp" class="nl"><span class="ni">💊</span>Medicines<span class="nb">New</span></a>
  <div class="sb-sec">Account</div>
  <a href="HistoryServlet" class="nl active"><span class="ni">🕐</span>History</a>
  <a href="profile.jsp" class="nl"><span class="ni">👤</span>My Profile</a>
  <div class="sb-footer"><div class="uc"><div class="uc-av"><%= userName.charAt(0) %></div><div><div class="uc-name"><%= userName %></div><div class="uc-role">Patient</div></div><a href="AuthServlet?action=logout" class="uc-out">⏻</a></div></div>
</aside>

<div class="main">
  <div class="topbar">
    <div><div class="tb-title">Prediction History</div><div class="tb-sub">All your past symptom checks</div></div>
  </div>
  <div class="content">
    <div class="stats">
      <div class="stat">
        <div class="stat-n"><%= history != null ? history.size() : 0 %></div>
        <div class="stat-l">Total Checks</div>
      </div>
      <div class="stat" style="border-color:rgba(59,130,246,0.2);">
        <div class="stat-n" style="color:var(--accent);">AI</div>
        <div class="stat-l">SVM + Decision Tree</div>
      </div>
      <div class="stat" style="border-color:rgba(16,185,129,0.2);">
        <div class="stat-n" style="color:var(--emerald);">🔒</div>
        <div class="stat-l">Data Secured</div>
      </div>
    </div>

    <div class="sec-title">📋 Past Predictions</div>

    <% if (history == null || history.isEmpty()) { %>
    <div class="empty">
      <div class="empty-icon">🔬</div>
      <div class="empty-h">No prediction history yet</div>
      <div class="empty-p">Start your first symptom check to see your history here.</div>
      <a href="patient-dashboard.jsp" class="btn-start">Start Symptom Check →</a>
    </div>
    <% } else {
       int idx=0;
       for (Map<String,String> row : history) {
         String symptoms = row.get("symptoms") != null ? row.get("symptoms") : "";
         String disease  = row.get("disease")  != null ? row.get("disease")  : "Unknown";
         String createdAt= row.get("createdAt")!= null ? row.get("createdAt"): "";
         double confSvm=0, confDt=0;
         try{confSvm=Double.parseDouble(row.get("confSvm"));}catch(Exception ex){}
         try{confDt=Double.parseDouble(row.get("confDt"));}catch(Exception ex){}
         idx++;
    %>
    <div class="hc" style="animation-delay:<%= idx*0.06 %>s;">
      <div class="hc-top">
        <div class="hc-dis">
          <div class="hc-dis-icon">🔬</div>
          <%= disease %>
        </div>
        <div class="hc-date"><%= createdAt %></div>
      </div>
      <div class="sym-tags">
        <% for (String s : symptoms.split(",")) { %><span class="sym-t"><%= s.trim() %></span><% } %>
      </div>
      <div class="conf-row">
        <div class="conf-item">
          <div class="ci-label">SVM Confidence</div>
          <div class="ci-bar"><div class="ci-fill svm-fill" style="width:<%= confSvm %>%"></div></div>
          <div class="ci-pct svm-pct"><%= String.format("%.1f", confSvm) %>%</div>
        </div>
        <div class="conf-item">
          <div class="ci-label">Decision Tree</div>
          <div class="ci-bar"><div class="ci-fill dt-fill" style="width:<%= confDt %>%"></div></div>
          <div class="ci-pct dt-pct"><%= String.format("%.1f", confDt) %>%</div>
        </div>
      </div>
    </div>
    <% } } %>
  </div>
</div>
</body>
</html>
