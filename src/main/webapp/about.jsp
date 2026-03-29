<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swasthyabuddy.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  String userName = user != null ? user.getFirstName() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — About</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    :root{--bg:#060b18;--surface:#0d1528;--surf2:#111e38;--accent:#3b82f6;--teal:#06b6d4;--emerald:#10b981;--rose:#f43f5e;--amber:#f59e0b;--white:#f8fafc;--muted:#64748b;--muted2:#94a3b8;--border:rgba(148,163,184,0.08);--border2:rgba(148,163,184,0.14);}
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--white);display:flex;min-height:100vh;}
    body::before{content:'';position:fixed;inset:0;background-image:linear-gradient(rgba(59,130,246,0.025) 1px,transparent 1px),linear-gradient(90deg,rgba(59,130,246,0.025) 1px,transparent 1px);background-size:40px 40px;pointer-events:none;z-index:0;}

    /* SIDEBAR */
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
    .ni{font-size:15px;width:20px;text-align:center;flex-shrink:0;}
    .nb{margin-left:auto;background:var(--accent);color:white;font-size:0.57rem;font-weight:700;padding:2px 6px;border-radius:20px;}
    .sb-footer{margin-top:auto;padding:14px;border-top:1px solid var(--border);}
    .uc{display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(255,255,255,0.03);border:1px solid var(--border);border-radius:11px;}
    .uc-av{width:32px;height:32px;background:linear-gradient(135deg,var(--accent),var(--teal));border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;flex-shrink:0;}
    .uc-name{font-size:0.78rem;font-weight:600;}
    .uc-role{font-size:0.6rem;color:var(--muted);}
    .uc-out{margin-left:auto;color:var(--muted);text-decoration:none;font-size:15px;}
    .uc-out:hover{color:var(--rose);}

    /* MAIN */
    .main{flex:1;overflow-y:auto;position:relative;z-index:1;}
    .topbar{display:flex;align-items:center;justify-content:space-between;padding:14px 24px;border-bottom:1px solid var(--border);background:rgba(6,11,24,0.85);backdrop-filter:blur(20px);position:sticky;top:0;z-index:10;}
    .tb-title{font-family:'Outfit',sans-serif;font-size:1rem;font-weight:700;}
    .tb-sub{font-size:0.7rem;color:var(--muted);margin-top:1px;}
    .back-btn{display:flex;align-items:center;gap:6px;color:var(--muted2);text-decoration:none;font-size:0.8rem;padding:7px 14px;border:1px solid var(--border);border-radius:8px;transition:all 0.2s;}
    .back-btn:hover{color:var(--white);border-color:var(--accent);}

    /* CONTENT */
    .content{max-width:900px;margin:0 auto;padding:40px 32px 80px;}

    /* HERO */
    .hero{text-align:center;padding:60px 20px 50px;position:relative;}
    .hero-glow{position:absolute;width:400px;height:400px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,0.12) 0%,transparent 70%);top:50%;left:50%;transform:translate(-50%,-50%);pointer-events:none;}
    .hero-logo{width:80px;height:80px;background:linear-gradient(135deg,var(--accent),var(--teal));border-radius:22px;display:flex;align-items:center;justify-content:center;font-size:40px;margin:0 auto 24px;box-shadow:0 0 40px rgba(59,130,246,0.4);position:relative;}
    .hero-name{font-family:'Outfit',sans-serif;font-size:2.4rem;font-weight:800;letter-spacing:-0.03em;margin-bottom:12px;}
    .hero-name em{background:linear-gradient(135deg,var(--accent),var(--teal));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;font-style:normal;}
    .hero-tag{display:inline-flex;align-items:center;gap:6px;padding:5px 16px;background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.25);border-radius:30px;font-size:0.74rem;color:var(--teal);font-weight:600;margin-bottom:20px;}
    .hero-desc{font-size:1rem;color:var(--muted2);line-height:1.8;max-width:580px;margin:0 auto;}

    /* STATS */
    .stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin:40px 0;}
    .stat{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:20px;text-align:center;}
    .stat-n{font-family:'Outfit',sans-serif;font-size:1.8rem;font-weight:800;background:linear-gradient(135deg,var(--accent),var(--teal));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}
    .stat-l{font-size:0.72rem;color:var(--muted);margin-top:4px;}

    /* SECTION */
    .sec{margin-bottom:48px;}
    .sec-h{font-family:'Outfit',sans-serif;font-size:1.3rem;font-weight:700;margin-bottom:6px;display:flex;align-items:center;gap:10px;}
    .sec-sub{font-size:0.84rem;color:var(--muted2);margin-bottom:20px;line-height:1.7;}

    /* TIMELINE */
    .timeline{display:flex;flex-direction:column;gap:0;}
    .tl-item{display:flex;gap:20px;position:relative;}
    .tl-item:not(:last-child) .tl-line{position:absolute;left:19px;top:40px;bottom:-20px;width:2px;background:linear-gradient(to bottom,var(--accent),transparent);}
    .tl-dot{width:40px;height:40px;border-radius:50%;background:rgba(59,130,246,0.1);border:2px solid rgba(59,130,246,0.3);display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0;position:relative;z-index:1;}
    .tl-body{flex:1;padding:0 0 32px;}
    .tl-date{font-size:0.68rem;color:var(--accent);font-weight:700;text-transform:uppercase;letter-spacing:0.1em;margin-bottom:4px;}
    .tl-title{font-family:'Outfit',sans-serif;font-size:0.95rem;font-weight:700;margin-bottom:4px;}
    .tl-desc{font-size:0.8rem;color:var(--muted2);line-height:1.6;}

    /* FEATURES GRID */
    .feat-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:16px;}
    .feat-card{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:20px;transition:all 0.3s;}
    .feat-card:hover{border-color:rgba(59,130,246,0.3);transform:translateY(-2px);}
    .fc-icon{font-size:28px;margin-bottom:12px;}
    .fc-title{font-family:'Outfit',sans-serif;font-size:0.95rem;font-weight:700;margin-bottom:6px;}
    .fc-desc{font-size:0.78rem;color:var(--muted2);line-height:1.6;}
    .fc-badge{display:inline-block;margin-top:8px;padding:3px 10px;background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.2);border-radius:20px;font-size:0.65rem;color:var(--accent);font-weight:600;}

    /* TEAM */
    .team-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;}
    .team-card{background:var(--surface);border:1px solid var(--border);border-radius:16px;padding:24px;text-align:center;transition:all 0.3s;}
    .team-card:hover{border-color:rgba(59,130,246,0.3);transform:translateY(-3px);}
    .team-av{width:64px;height:64px;border-radius:50%;margin:0 auto 14px;display:flex;align-items:center;justify-content:center;font-size:26px;font-weight:800;font-family:'Outfit',sans-serif;}
    .team-name{font-family:'Outfit',sans-serif;font-size:0.95rem;font-weight:700;margin-bottom:4px;}
    .team-role{font-size:0.74rem;color:var(--accent);font-weight:600;margin-bottom:8px;}
    .team-desc{font-size:0.74rem;color:var(--muted2);line-height:1.6;}
    .team-tags{display:flex;flex-wrap:wrap;gap:6px;justify-content:center;margin-top:12px;}
    .team-tag{padding:3px 8px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:20px;font-size:0.62rem;color:var(--muted2);}

    /* TECH STACK */
    .tech-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;}
    .tech-card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:16px;display:flex;align-items:center;gap:12px;transition:all 0.2s;}
    .tech-card:hover{border-color:rgba(59,130,246,0.2);}
    .tech-icon{font-size:22px;}
    .tech-name{font-size:0.82rem;font-weight:600;}
    .tech-type{font-size:0.68rem;color:var(--muted);}

    /* MISSION */
    .mission-box{background:linear-gradient(135deg,rgba(59,130,246,0.08),rgba(6,182,212,0.05));border:1px solid rgba(59,130,246,0.2);border-radius:18px;padding:36px;text-align:center;}
    .mission-icon{font-size:40px;margin-bottom:16px;}
    .mission-h{font-family:'Outfit',sans-serif;font-size:1.4rem;font-weight:800;margin-bottom:12px;}
    .mission-t{font-size:0.88rem;color:var(--muted2);line-height:1.8;max-width:560px;margin:0 auto;}

    /* MOBILE NAV */
    .mob-nav{display:none;position:fixed;bottom:0;left:0;right:0;background:var(--surface);border-top:1px solid var(--border);padding:6px 8px;justify-content:space-around;align-items:center;z-index:200;}
    .mob-nav a{display:flex;flex-direction:column;align-items:center;gap:2px;color:var(--muted2);text-decoration:none;font-size:0.58rem;padding:6px 8px;border-radius:10px;min-width:48px;}
    .mob-nav a.active{color:var(--accent);background:rgba(59,130,246,0.1);}
    .mob-nav a span{font-size:18px;}
    .mob-nav .more-btn{display:flex;flex-direction:column;align-items:center;gap:2px;color:var(--muted2);font-size:0.58rem;padding:6px 8px;border-radius:10px;background:none;border:none;cursor:pointer;min-width:48px;}
    .mob-nav .more-btn span{font-size:18px;}
    .mob-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,0.6);z-index:300;backdrop-filter:blur(4px);}
    .mob-overlay.open{display:block;}
    .mob-sheet{position:fixed;bottom:0;left:0;right:0;background:var(--surface);border-radius:20px 20px 0 0;padding:16px;z-index:301;transform:translateY(100%);transition:transform 0.3s cubic-bezier(0.16,1,0.3,1);}
    .mob-sheet.open{transform:translateY(0);}
    .sheet-handle{width:40px;height:4px;background:var(--border);border-radius:2px;margin:0 auto 16px;}
    .sheet-title{font-family:'Outfit',sans-serif;font-size:0.9rem;font-weight:700;color:var(--muted2);margin-bottom:12px;padding:0 4px;}
    .sheet-link{display:flex;align-items:center;gap:14px;padding:14px 12px;color:var(--white);text-decoration:none;font-size:0.88rem;border-radius:12px;transition:all 0.2s;}
    .sheet-link:hover{background:rgba(255,255,255,0.05);}
    .sheet-link .si{font-size:20px;width:24px;text-align:center;}
    .sheet-link.danger{color:var(--rose);}

    @media(max-width:900px){
      .sidebar{display:none;}
      .mob-nav{display:flex;}
      .main{padding-bottom:68px;}
      .content{padding:24px 16px 80px;}
      .stats{grid-template-columns:repeat(2,1fr);}
      .feat-grid{grid-template-columns:1fr;}
      .team-grid{grid-template-columns:repeat(2,1fr);}
      .tech-grid{grid-template-columns:repeat(2,1fr);}
      .hero-name{font-size:1.8rem;}
    }
    @media(max-width:480px){
      .team-grid{grid-template-columns:1fr;}
      .stats{grid-template-columns:repeat(2,1fr);}
    }
  </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="sb-header">
    <div class="sb-brand">
      <div class="sb-logo">🩺</div>
      <div class="sb-title">Swasthya<em>Buddy</em></div>
    </div>
  </div>
  <div class="sb-sec">Menu</div>
  <a href="patient-dashboard.jsp" class="nl"><span class="ni">💬</span>Symptom Check</a>
  <a href="result.jsp" class="nl"><span class="ni">📊</span>My Results</a>
  <a href="maps.jsp" class="nl"><span class="ni">🗺️</span>Find Clinics</a>
  <a href="medicines.jsp" class="nl"><span class="ni">💊</span>Medicines<span class="nb">New</span></a>
  <div class="sb-sec">Account</div>
  <a href="HistoryServlet" class="nl"><span class="ni">🕐</span>History</a>
  <a href="profile.jsp" class="nl"><span class="ni">👤</span>My Profile</a>
  <a href="about.jsp" class="nl active"><span class="ni">ℹ️</span>About</a>
  <div class="sb-footer">
    <div class="uc">
      <div class="uc-av"><%= userName != null ? userName.charAt(0) : "?" %></div>
      <div><div class="uc-name"><%= userName != null ? userName : "Guest" %></div><div class="uc-role">Patient</div></div>
      <a href="AuthServlet?action=logout" class="uc-out" title="Logout">⏻</a>
    </div>
  </div>
</aside>

<div class="main">
  <div class="topbar">
    <div>
      <div class="tb-title">About SwasthyaBuddy</div>
      <div class="tb-sub">Our story, mission & team</div>
    </div>
    <a href="patient-dashboard.jsp" class="back-btn">← Back</a>
  </div>

  <div class="content">

    <!-- HERO -->
    <div class="hero">
      <div class="hero-glow"></div>
      <div class="hero-logo">🩺</div>
      <div class="hero-tag">🏆 NareshIT Hackathon 2026</div>
      <div class="hero-name">Swasthya<em>Buddy</em></div>
      <p class="hero-desc">An AI-powered health companion that predicts diseases from symptoms, connects patients with nearby doctors, and delivers real-time health insights — built in 48 hours for the NareshIT Hackathon 2026.</p>
    </div>

    <!-- STATS -->
    <div class="stats">
      <div class="stat"><div class="stat-n">41+</div><div class="stat-l">Diseases Detected</div></div>
      <div class="stat"><div class="stat-n">2</div><div class="stat-l">AI Models</div></div>
      <div class="stat"><div class="stat-n">48h</div><div class="stat-l">Built In</div></div>
      <div class="stat"><div class="stat-n">100%</div><div class="stat-l">Open Source</div></div>
    </div>

    <!-- MISSION -->
    <div class="sec">
      <div class="mission-box">
        <div class="mission-icon">🎯</div>
        <div class="mission-h">Our Mission</div>
        <p class="mission-t">Millions of Indians lack timely access to accurate medical guidance. SwasthyaBuddy bridges this gap by combining machine learning, real-time communication, and modern web technology to democratize healthcare — making expert-level health insights available to everyone, anywhere.</p>
      </div>
    </div>

    <!-- JOURNEY -->
    <div class="sec">
      <div class="sec-h">🗺️ Our Journey</div>
      <p class="sec-sub">From idea to deployment — the story of SwasthyaBuddy</p>
      <div class="timeline">
        <div class="tl-item">
          <div class="tl-dot">💡</div>
          <div class="tl-line"></div>
          <div class="tl-body">
            <div class="tl-date">Day 1 — Morning</div>
            <div class="tl-title">The Idea</div>
            <div class="tl-desc">Inspired by the lack of accessible healthcare tools in rural India, the team decided to build an AI symptom checker that could work for anyone with a smartphone.</div>
          </div>
        </div>
        <div class="tl-item">
          <div class="tl-dot">🧠</div>
          <div class="tl-line"></div>
          <div class="tl-body">
            <div class="tl-date">Day 1 — Afternoon</div>
            <div class="tl-title">ML Model Training</div>
            <div class="tl-desc">Trained SVM and Decision Tree models on a dataset of 41 diseases and 132 symptoms. Achieved high accuracy using ensemble prediction with confidence scoring.</div>
          </div>
        </div>
        <div class="tl-item">
          <div class="tl-dot">⚡</div>
          <div class="tl-line"></div>
          <div class="tl-body">
            <div class="tl-date">Day 1 — Night</div>
            <div class="tl-title">Backend & Real-time Alerts</div>
            <div class="tl-desc">Built the Java Servlet backend with SSE (Server-Sent Events) for real-time doctor dashboard alerts. Integrated MySQL for persistent data storage.</div>
          </div>
        </div>
        <div class="tl-item">
          <div class="tl-dot">🎨</div>
          <div class="tl-line"></div>
          <div class="tl-body">
            <div class="tl-date">Day 2 — Morning</div>
            <div class="tl-title">UI/UX Design</div>
            <div class="tl-desc">Designed a beautiful, responsive dark-mode interface with an AI chat experience, patient dashboard, maps integration, and medicine search.</div>
          </div>
        </div>
        <div class="tl-item">
          <div class="tl-dot">🚀</div>
          <div class="tl-body">
            <div class="tl-date">Day 2 — Evening</div>
            <div class="tl-title">Deployed to Railway</div>
            <div class="tl-desc">Successfully deployed the full stack — Java/Tomcat backend on Railway, Python Flask ML API on Render, and MySQL database on Railway. Live and ready for demo!</div>
          </div>
        </div>
      </div>
    </div>

    <!-- FEATURES -->
    <div class="sec">
      <div class="sec-h">✨ Key Features</div>
      <p class="sec-sub">Everything SwasthyaBuddy can do for you</p>
      <div class="feat-grid">
        <div class="feat-card">
          <div class="fc-icon">🤖</div>
          <div class="fc-title">AI Disease Prediction</div>
          <div class="fc-desc">Enter your symptoms and our ML models analyse them using SVM and Decision Tree algorithms to predict the top 3 most likely diseases with confidence scores.</div>
          <span class="fc-badge">SVM + Decision Tree</span>
        </div>
        <div class="feat-card">
          <div class="fc-icon">📡</div>
          <div class="fc-title">Real-time Doctor Alerts</div>
          <div class="fc-desc">When a patient receives a high-confidence prediction, doctors are instantly notified via Server-Sent Events without any page refresh needed.</div>
          <span class="fc-badge">SSE Technology</span>
        </div>
        <div class="feat-card">
          <div class="fc-icon">🗺️</div>
          <div class="fc-title">Nearby Clinic Finder</div>
          <div class="fc-desc">Find hospitals and clinics near you using OpenStreetMap integration. Get directions and contact information instantly.</div>
          <span class="fc-badge">OpenStreetMap API</span>
        </div>
        <div class="feat-card">
          <div class="fc-icon">💊</div>
          <div class="fc-title">Medicine Search</div>
          <div class="fc-desc">Search for medicines, check drug information, side effects and alternatives using the OpenFDA drug database integration.</div>
          <span class="fc-badge">OpenFDA API</span>
        </div>
        <div class="feat-card">
          <div class="fc-icon">📊</div>
          <div class="fc-title">Health History</div>
          <div class="fc-desc">All your past predictions are saved and accessible. Track your health journey over time with detailed history records.</div>
          <span class="fc-badge">MySQL Database</span>
        </div>
        <div class="feat-card">
          <div class="fc-icon">📱</div>
          <div class="fc-title">Mobile Responsive</div>
          <div class="fc-desc">Fully responsive design that works beautifully on mobile, tablet, and desktop. Access your health companion from any device.</div>
          <span class="fc-badge">Progressive UI</span>
        </div>
      </div>
    </div>

    <!-- TECH STACK -->
    <div class="sec">
      <div class="sec-h">🛠️ Tech Stack</div>
      <p class="sec-sub">Technologies powering SwasthyaBuddy</p>
      <div class="tech-grid">
        <div class="tech-card"><div class="tech-icon">☕</div><div><div class="tech-name">Java Servlets</div><div class="tech-type">Backend</div></div></div>
        <div class="tech-card"><div class="tech-icon">🐍</div><div><div class="tech-name">Python Flask</div><div class="tech-type">ML API</div></div></div>
        <div class="tech-card"><div class="tech-icon">🗄️</div><div><div class="tech-name">MySQL</div><div class="tech-type">Database</div></div></div>
        <div class="tech-card"><div class="tech-icon">🧠</div><div><div class="tech-name">Scikit-learn</div><div class="tech-type">Machine Learning</div></div></div>
        <div class="tech-card"><div class="tech-icon">🐱</div><div><div class="tech-name">Apache Tomcat 11</div><div class="tech-type">Server</div></div></div>
        <div class="tech-card"><div class="tech-icon">🚂</div><div><div class="tech-name">Railway</div><div class="tech-type">Deployment</div></div></div>
        <div class="tech-card"><div class="tech-icon">🌐</div><div><div class="tech-name">OpenStreetMap</div><div class="tech-type">Maps</div></div></div>
        <div class="tech-card"><div class="tech-icon">💊</div><div><div class="tech-name">OpenFDA API</div><div class="tech-type">Medicine Data</div></div></div>
        <div class="tech-card"><div class="tech-icon">📡</div><div><div class="tech-name">SSE</div><div class="tech-type">Real-time Alerts</div></div></div>
      </div>
    </div>

    <!-- TEAM -->
    <div class="sec">
      <div class="sec-h">👥 Meet the Team</div>
      <p class="sec-sub">The minds behind SwasthyaBuddy — NareshIT Hackathon 2026</p>
      <div class="team-grid">
        <div class="team-card">
          <div class="team-av" style="background:linear-gradient(135deg,#3b82f6,#06b6d4);">S</div>
          <div class="team-name">Shashank Pandhre</div>
          <div class="team-role">Java Backend Lead</div>
          <div class="team-desc">Architected the servlet backend, SSE real-time alerts, database layer, and Railway deployment pipeline.</div>
          <div class="team-tags"><span class="team-tag">Java</span><span class="team-tag">MySQL</span><span class="team-tag">DevOps</span></div>
        </div>
        <div class="team-card">
          <div class="team-av" style="background:linear-gradient(135deg,#7c3aed,#3b82f6);">A</div>
          <div class="team-name">Anant Joshi</div>
          <div class="team-role">ML Engineer</div>
          <div class="team-desc">Built and trained the disease prediction models using SVM and Decision Tree, deployed Flask API on Render.</div>
          <div class="team-tags"><span class="team-tag">Python</span><span class="team-tag">ML</span><span class="team-tag">Flask</span></div>
        </div>
        <div class="team-card">
          <div class="team-av" style="background:linear-gradient(135deg,#10b981,#06b6d4);">T</div>
          <div class="team-name">Team Member 3</div>
          <div class="team-role">Frontend Developer</div>
          <div class="team-desc">Designed and built the responsive UI, JSP pages, mobile navigation, and the beautiful dark-mode interface.</div>
          <div class="team-tags"><span class="team-tag">JSP</span><span class="team-tag">CSS</span><span class="team-tag">UX</span></div>
        </div>
      </div>
    </div>

  </div>
</div>

<!-- Mobile Bottom Nav -->
<nav class="mob-nav">
  <a href="patient-dashboard.jsp"><span>💬</span>Symptoms</a>
  <a href="result.jsp"><span>📊</span>Results</a>
  <a href="maps.jsp"><span>🗺️</span>Clinics</a>
  <a href="medicines.jsp"><span>💊</span>Medicines</a>
  <button class="more-btn" onclick="openSheet()"><span>⋯</span>More</button>
</nav>

<div class="mob-overlay" id="overlay" onclick="closeSheet()"></div>
<div class="mob-sheet" id="mobSheet">
  <div class="sheet-handle"></div>
  <div class="sheet-title">More Options</div>
  <a href="HistoryServlet" class="sheet-link"><span class="si">🕐</span>History</a>
  <a href="profile.jsp" class="sheet-link"><span class="si">👤</span>My Profile</a>
  <a href="about.jsp" class="sheet-link"><span class="si">ℹ️</span>About SwasthyaBuddy</a>
  <a href="AuthServlet?action=logout" class="sheet-link danger"><span class="si">⏻</span>Logout</a>
</div>

<script>
function openSheet(){document.getElementById('overlay').classList.add('open');document.getElementById('mobSheet').classList.add('open');}
function closeSheet(){document.getElementById('overlay').classList.remove('open');document.getElementById('mobSheet').classList.remove('open');}
</script>
</body>
</html>