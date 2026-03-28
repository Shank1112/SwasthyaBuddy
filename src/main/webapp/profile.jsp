<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swasthyabuddy.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  String userName = user.getFirstName();
  String userRole = user.getRole();
  String dashboard = "DOCTOR".equalsIgnoreCase(userRole) ? "doctor-dashboard.jsp" : "patient-dashboard.jsp";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — Profile</title>
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
    .topbar{display:flex;align-items:center;padding:14px 24px;border-bottom:1px solid var(--border);background:rgba(6,11,24,0.85);backdrop-filter:blur(20px);position:sticky;top:0;z-index:50;flex-shrink:0;}
    .tb-title{font-family:'Outfit',sans-serif;font-size:1rem;font-weight:700;}
    .content{padding:28px;max-width:720px;width:100%;margin:0 auto;}

    /* Profile header */
    .prof-header{background:linear-gradient(135deg,rgba(59,130,246,0.1),rgba(6,182,212,0.05));border:1px solid rgba(59,130,246,0.2);border-radius:18px;padding:30px;display:flex;align-items:center;gap:22px;margin-bottom:24px;animation:fadeUp 0.4s ease;}
    @keyframes fadeUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
    .prof-av{width:76px;height:76px;background:linear-gradient(135deg,var(--accent),var(--teal));border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:2.2rem;font-weight:700;flex-shrink:0;box-shadow:0 0 30px rgba(59,130,246,0.3);}
    .prof-name{font-family:'Outfit',sans-serif;font-size:1.5rem;font-weight:800;letter-spacing:-0.02em;}
    .prof-email{font-size:0.83rem;color:var(--muted2);margin-top:3px;}
    .role-tag{display:inline-block;margin-top:10px;padding:4px 12px;border-radius:20px;font-size:0.68rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;}
    .rt-patient{background:rgba(59,130,246,0.12);border:1px solid rgba(59,130,246,0.25);color:var(--accent);}
    .rt-doctor{background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.2);color:var(--emerald);}

    .sec-title{font-family:'Outfit',sans-serif;font-size:0.82rem;font-weight:700;margin-bottom:16px;display:flex;align-items:center;gap:8px;color:var(--white);}
    .sec-title::after{content:'';flex:1;height:1px;background:var(--border);}

    .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:24px;}
    .info-card{background:var(--surface);border:1px solid var(--border2);border-radius:13px;padding:16px;transition:all 0.2s;animation:fadeUp 0.4s ease both;}
    .info-card:hover{border-color:rgba(59,130,246,0.2);transform:translateY(-1px);}
    .info-lbl{font-size:0.62rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:5px;}
    .info-val{font-size:0.9rem;font-weight:500;color:var(--white);}

    .danger-row{background:rgba(244,63,94,0.04);border:1px solid rgba(244,63,94,0.15);border-radius:14px;padding:20px;display:flex;align-items:center;justify-content:space-between;animation:fadeUp 0.4s ease 0.2s both;}
    .dr-text strong{display:block;color:var(--rose);font-size:0.86rem;font-weight:600;margin-bottom:3px;}
    .dr-text span{font-size:0.78rem;color:var(--muted);}
    .btn-logout{padding:10px 20px;background:rgba(244,63,94,0.08);border:1px solid rgba(244,63,94,0.25);border-radius:10px;color:var(--rose);font-size:0.82rem;font-weight:600;cursor:pointer;text-decoration:none;transition:all 0.2s;}
    .btn-logout:hover{background:rgba(244,63,94,0.15);color:var(--rose);}

    @media(max-width:768px){.sidebar{display:none;}.info-grid{grid-template-columns:1fr;}.content{padding:20px 16px;}}
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-header"><div class="sb-brand"><div class="sb-logo">🩺</div><div class="sb-title">Swasthya<em>Buddy</em></div></div></div>
  <div class="sb-sec">Menu</div>
  <a href="<%= dashboard %>" class="nl"><span class="ni"><%= "DOCTOR".equalsIgnoreCase(userRole) ? "🔔" : "💬" %></span><%= "DOCTOR".equalsIgnoreCase(userRole) ? "Live Alerts" : "Symptom Check" %></a>
  <% if (!"DOCTOR".equalsIgnoreCase(userRole)) { %>
  <a href="result.jsp" class="nl"><span class="ni">📊</span>My Results</a>
  <a href="HistoryServlet" class="nl"><span class="ni">🕐</span>History</a>
  <% } %>
  <a href="maps.jsp" class="nl"><span class="ni">🗺️</span>Find Clinics</a>
  <a href="medicines.jsp" class="nl"><span class="ni">💊</span>Medicines<span class="nb">New</span></a>
  <div class="sb-sec">Account</div>
  <a href="profile.jsp" class="nl active"><span class="ni">👤</span>My Profile</a>
  <div class="sb-footer"><div class="uc"><div class="uc-av"><%= userName.charAt(0) %></div><div><div class="uc-name"><%= userName %></div><div class="uc-role"><%= userRole %></div></div><a href="AuthServlet?action=logout" class="uc-out">⏻</a></div></div>
</aside>

<div class="main">
  <div class="topbar"><div class="tb-title">My Profile</div></div>
  <div class="content">
    <div class="prof-header">
      <div class="prof-av"><%= userName.charAt(0) %></div>
      <div>
        <div class="prof-name"><%= user.getFirstName() %> <%= user.getLastName() != null ? user.getLastName() : "" %></div>
        <div class="prof-email"><%= user.getEmail() %></div>
        <span class="role-tag <%= "DOCTOR".equalsIgnoreCase(userRole) ? "rt-doctor" : "rt-patient" %>"><%= userRole %></span>
      </div>
    </div>

    <div class="sec-title">👤 Personal Information</div>
    <div class="info-grid">
      <div class="info-card" style="animation-delay:0.05s;"><div class="info-lbl">First Name</div><div class="info-val"><%= user.getFirstName() %></div></div>
      <div class="info-card" style="animation-delay:0.08s;"><div class="info-lbl">Last Name</div><div class="info-val"><%= (user.getLastName()!=null&&!user.getLastName().isEmpty())?user.getLastName():"—" %></div></div>
      <div class="info-card" style="animation-delay:0.11s;"><div class="info-lbl">Email</div><div class="info-val"><%= user.getEmail() %></div></div>
      <div class="info-card" style="animation-delay:0.14s;"><div class="info-lbl">Phone</div><div class="info-val"><%= (user.getPhone()!=null&&!user.getPhone().isEmpty())?user.getPhone():"—" %></div></div>
      <div class="info-card" style="animation-delay:0.17s;"><div class="info-lbl">Gender</div><div class="info-val"><%= (user.getGender()!=null&&!user.getGender().isEmpty())?user.getGender():"—" %></div></div>
      <div class="info-card" style="animation-delay:0.2s;"><div class="info-lbl">Blood Group</div><div class="info-val"><%= (user.getBloodGroup()!=null&&!user.getBloodGroup().isEmpty())?user.getBloodGroup():"—" %></div></div>
    </div>

    <div class="sec-title" style="margin-top:24px;">⚙️ Account</div>
    <div class="danger-row">
      <div class="dr-text"><strong>Sign Out</strong><span>End your current session securely</span></div>
      <a href="AuthServlet?action=logout" class="btn-logout">Sign Out →</a>
    </div>
  </div>
</div>
</body>
</html>
