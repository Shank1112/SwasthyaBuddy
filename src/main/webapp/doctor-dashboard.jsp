<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  Object userObj = session.getAttribute("user");
  if (userObj == null) { response.sendRedirect("login.jsp"); return; }
  com.swasthyabuddy.model.User user = (com.swasthyabuddy.model.User) userObj;
  String userName = user.getFirstName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — Doctor Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    :root{--bg:#060b18;--surface:#0d1528;--surf2:#111e38;--accent:#3b82f6;--teal:#06b6d4;--emerald:#10b981;--rose:#f43f5e;--amber:#f59e0b;--violet:#8b5cf6;--white:#f8fafc;--muted:#64748b;--muted2:#94a3b8;--border:rgba(148,163,184,0.08);--border2:rgba(148,163,184,0.14);}
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
    .sb-footer{margin-top:auto;padding:14px;border-top:1px solid var(--border);}
    .uc{display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(255,255,255,0.03);border:1px solid var(--border);border-radius:11px;}
    .uc-av{width:32px;height:32px;background:linear-gradient(135deg,var(--emerald),#059669);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;flex-shrink:0;}
    .uc-name{font-size:0.78rem;font-weight:600;color:var(--white);}
    .uc-role{font-size:0.6rem;color:var(--muted);}
    .uc-out{margin-left:auto;color:var(--muted);text-decoration:none;font-size:15px;}
    .uc-out:hover{color:var(--rose);}

    .main{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;position:relative;z-index:1;padding:40px;}

    /* Animated orbs */
    .orb1{position:fixed;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,0.1) 0%,transparent 70%);top:-100px;right:-100px;animation:orb 8s ease-in-out infinite alternate;pointer-events:none;}
    .orb2{position:fixed;width:350px;height:350px;border-radius:50%;background:radial-gradient(circle,rgba(139,92,246,0.08) 0%,transparent 70%);bottom:-50px;left:200px;animation:orb 10s ease-in-out infinite alternate-reverse;pointer-events:none;}
    @keyframes orb{from{transform:translate(0,0) scale(1)}to{transform:translate(30px,20px) scale(1.08)}}

    /* Main card */
    .card{background:rgba(13,21,40,0.7);border:1px solid var(--border2);border-radius:24px;padding:52px 56px;text-align:center;max-width:560px;width:100%;backdrop-filter:blur(20px);animation:fadeUp 0.6s cubic-bezier(0.16,1,0.3,1);}
    @keyframes fadeUp{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:translateY(0)}}

    /* Animated icon */
    .big-icon{position:relative;width:90px;height:90px;margin:0 auto 28px;animation:iconFloat 4s ease-in-out infinite;}
    @keyframes iconFloat{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
    .bi-bg{position:absolute;inset:0;border-radius:50%;background:linear-gradient(135deg,rgba(139,92,246,0.15),rgba(59,130,246,0.1));border:1px solid rgba(139,92,246,0.3);animation:ringPulse 3s ease-in-out infinite;}
    @keyframes ringPulse{0%,100%{box-shadow:0 0 0 0 rgba(139,92,246,0.3)}50%{box-shadow:0 0 0 16px rgba(139,92,246,0)}}
    .bi-inner{position:absolute;inset:8px;border-radius:50%;background:linear-gradient(135deg,var(--violet),var(--accent));display:flex;align-items:center;justify-content:center;font-size:32px;}

    .tag{display:inline-flex;align-items:center;gap:6px;padding:5px 14px;background:rgba(139,92,246,0.1);border:1px solid rgba(139,92,246,0.25);border-radius:30px;font-size:0.68rem;font-weight:700;color:#a78bfa;text-transform:uppercase;letter-spacing:0.1em;margin-bottom:20px;}
    .tag-dot{width:5px;height:5px;border-radius:50%;background:#a78bfa;animation:pulse2 2s infinite;}
    @keyframes pulse2{0%,100%{opacity:1}50%{opacity:0.3}}

    h1{font-family:'Outfit',sans-serif;font-size:1.8rem;font-weight:800;letter-spacing:-0.03em;margin-bottom:14px;}
    h1 span{background:linear-gradient(135deg,var(--violet),var(--accent));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}

    .desc{font-size:0.9rem;color:var(--muted2);line-height:1.75;margin-bottom:32px;}

    /* Progress bar */
    .progress-wrap{margin-bottom:32px;}
    .progress-lbl{display:flex;justify-content:space-between;font-size:0.7rem;color:var(--muted);margin-bottom:8px;}
    .progress-lbl strong{color:var(--white);}
    .prog-bar{height:6px;background:rgba(255,255,255,0.06);border-radius:3px;overflow:hidden;}
    .prog-fill{height:100%;width:65%;background:linear-gradient(90deg,var(--violet),var(--accent));border-radius:3px;animation:progPulse 2s ease-in-out infinite;}
    @keyframes progPulse{0%,100%{opacity:0.8}50%{opacity:1}}

    /* Feature chips */
    .features{display:flex;flex-wrap:wrap;gap:8px;justify-content:center;margin-bottom:32px;}
    .feat-chip{display:flex;align-items:center;gap:6px;padding:7px 14px;background:rgba(255,255,255,0.03);border:1px solid var(--border);border-radius:20px;font-size:0.76rem;color:var(--muted2);}
    .feat-chip .fc-dot{width:6px;height:6px;border-radius:50%;}
    .fc-done{background:var(--emerald);}
    .fc-wip{background:var(--amber);}
    .fc-todo{background:var(--muted);}

    .actions{display:flex;gap:12px;justify-content:center;flex-wrap:wrap;}
    .btn-maps{display:flex;align-items:center;gap:8px;padding:12px 22px;background:linear-gradient(135deg,var(--accent),#2563eb);border:none;border-radius:12px;color:white;font-family:'Outfit',sans-serif;font-size:0.88rem;font-weight:700;cursor:pointer;text-decoration:none;transition:all 0.2s;}
    .btn-maps:hover{transform:translateY(-1px);box-shadow:0 8px 24px rgba(59,130,246,0.35);color:white;}
    .btn-profile{display:flex;align-items:center;gap:8px;padding:12px 22px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:12px;color:var(--muted2);font-size:0.88rem;cursor:pointer;text-decoration:none;transition:all 0.2s;}
    .btn-profile:hover{border-color:rgba(59,130,246,0.3);color:var(--white);}

    .note{margin-top:24px;font-size:0.72rem;color:var(--muted);line-height:1.6;}
    .note strong{color:var(--accent);}

    @media(max-width:768px){.sidebar{display:none;}.card{padding:36px 24px;}.main{padding:20px;}}
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-header"><div class="sb-brand"><div class="sb-logo">🩺</div><div class="sb-title">Swasthya<em>Buddy</em></div></div></div>
  <div class="sb-sec">Menu</div>
  <a href="doctor-dashboard.jsp" class="nl active"><span class="ni">🔔</span>Live Alerts</a>
  <a href="maps.jsp" class="nl"><span class="ni">🗺️</span>Find Clinics</a>
  <a href="medicines.jsp" class="nl"><span class="ni">💊</span>Medicines</a>
  <div class="sb-sec">Account</div>
  <a href="profile.jsp" class="nl"><span class="ni">👤</span>My Profile</a>
  <div class="sb-footer"><div class="uc"><div class="uc-av"><%= userName.charAt(0) %></div><div><div class="uc-name"><%= userName %></div><div class="uc-role">Doctor</div></div><a href="AuthServlet?action=logout" class="uc-out">⏻</a></div></div>
</aside>

<div class="main">
  <div class="orb1"></div>
  <div class="orb2"></div>

  <div class="card">
    <div class="big-icon">
      <div class="bi-bg"></div>
      <div class="bi-inner">👨‍⚕️</div>
    </div>

    <div class="tag"><span class="tag-dot"></span>In Active Development</div>

    <h1>Doctor Portal<br/><span>Coming Soon</span></h1>

    <p class="desc">
      The Doctor Dashboard is currently being built with care.<br/>
      Real-time patient alerts, SSE notifications, and patient management tools are on their way, Dr. <strong><%= userName %></strong>.
    </p>

    <div class="progress-wrap">
      <div class="progress-lbl"><span>Development Progress</span><strong>65% Complete</strong></div>
      <div class="prog-bar"><div class="prog-fill"></div></div>
    </div>

    <div class="features">
      <div class="feat-chip"><span class="fc-dot fc-done"></span>Auth & Role System</div>
      <div class="feat-chip"><span class="fc-dot fc-done"></span>Patient Registration</div>
      <div class="feat-chip"><span class="fc-dot fc-done"></span>AI Prediction Engine</div>
      <div class="feat-chip"><span class="fc-dot fc-wip"></span>Live SSE Alerts</div>
      <div class="feat-chip"><span class="fc-dot fc-wip"></span>Patient Dashboard</div>
      <div class="feat-chip"><span class="fc-dot fc-todo"></span>Prescription Module</div>
      <div class="feat-chip"><span class="fc-dot fc-todo"></span>Analytics Panel</div>
    </div>

    <div class="actions">
      <a href="maps.jsp" class="btn-maps">🗺️ Find Clinics</a>
      <a href="profile.jsp" class="btn-profile">👤 My Profile</a>
    </div>

    <div class="note">
      Built with ❤️ for the hackathon · <strong>SwasthyaBuddy v1.0</strong><br/>
      Doctor features will be fully functional in the next release.
    </div>
  </div>
</div>
</body>
</html>
