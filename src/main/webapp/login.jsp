<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — Sign In</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --bg: #060b18; --surface: #0d1528; --surf2: #111e38;
      --accent: #3b82f6; --teal: #06b6d4; --emerald: #10b981;
      --rose: #f43f5e; --amber: #f59e0b;
      --white: #f8fafc; --muted: #64748b; --muted2: #94a3b8;
      --border: rgba(148,163,184,0.08); --glow: rgba(59,130,246,0.15);
    }
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--white);min-height:100vh;display:flex;overflow:auto;}
    body::before{content:'';position:fixed;inset:0;background-image:linear-gradient(rgba(59,130,246,0.03) 1px,transparent 1px),linear-gradient(90deg,rgba(59,130,246,0.03) 1px,transparent 1px);background-size:40px 40px;pointer-events:none;z-index:0;}
    .left{width:55%;position:relative;display:flex;flex-direction:column;justify-content:center;padding:60px 70px;overflow:hidden;z-index:1;}
    .left::before{content:'';position:absolute;width:600px;height:600px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,0.18) 0%,transparent 70%);top:-100px;left:-100px;animation:orb1 8s ease-in-out infinite alternate;}
    .left::after{content:'';position:absolute;width:400px;height:400px;border-radius:50%;background:radial-gradient(circle,rgba(6,182,212,0.12) 0%,transparent 70%);bottom:-50px;right:50px;animation:orb2 10s ease-in-out infinite alternate;}
    @keyframes orb1{from{transform:translate(0,0) scale(1)}to{transform:translate(40px,30px) scale(1.1)}}
    @keyframes orb2{from{transform:translate(0,0) scale(1)}to{transform:translate(-30px,-40px) scale(1.15)}}
    .left-inner{position:relative;z-index:2;}
    .brand{display:flex;align-items:center;gap:14px;margin-bottom:64px;}
    .brand-logo{width:48px;height:48px;background:linear-gradient(135deg,var(--accent),var(--teal));border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:24px;box-shadow:0 0 30px rgba(59,130,246,0.4);}
    .brand-name{font-family:'Outfit',sans-serif;font-size:1.4rem;font-weight:700;color:var(--white);}
    .brand-name em{color:var(--teal);font-style:normal;}
    .hero-tag{display:inline-flex;align-items:center;gap:6px;padding:5px 14px;background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.25);border-radius:30px;font-size:0.72rem;color:var(--teal);font-weight:600;letter-spacing:0.08em;text-transform:uppercase;margin-bottom:24px;}
    .hero-tag span{width:6px;height:6px;border-radius:50%;background:var(--teal);animation:blink 2s infinite;}
    @keyframes blink{0%,100%{opacity:1}50%{opacity:0.3}}
    .hero-h{font-family:'Outfit',sans-serif;font-size:clamp(2.2rem,3.5vw,3.2rem);font-weight:800;line-height:1.1;margin-bottom:18px;letter-spacing:-0.03em;}
    .hero-h .grad{background:linear-gradient(135deg,var(--accent),var(--teal));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}
    .hero-sub{font-size:0.95rem;color:var(--muted2);line-height:1.75;max-width:400px;margin-bottom:52px;}
    .features{display:flex;flex-direction:column;gap:14px;}
    .feat{display:flex;align-items:center;gap:16px;padding:16px 20px;background:rgba(255,255,255,0.025);border:1px solid var(--border);border-radius:14px;transition:all 0.3s;backdrop-filter:blur(10px);}
    .feat:hover{background:rgba(59,130,246,0.06);border-color:rgba(59,130,246,0.2);transform:translateX(6px);}
    .feat-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0;}
    .fi-blue{background:rgba(59,130,246,0.12);border:1px solid rgba(59,130,246,0.2);}
    .fi-cyan{background:rgba(6,182,212,0.1);border:1px solid rgba(6,182,212,0.2);}
    .fi-emerald{background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.2);}
    .feat-text strong{display:block;font-size:0.85rem;color:var(--white);font-weight:600;margin-bottom:2px;}
    .feat-text span{font-size:0.75rem;color:var(--muted);}
    .right{width:45%;display:flex;align-items:center;justify-content:center;padding:40px 56px;position:relative;z-index:1;}
    .right::before{content:'';position:absolute;left:0;top:10%;bottom:10%;width:1px;background:linear-gradient(to bottom,transparent,rgba(59,130,246,0.2),transparent);}
    .login-box{width:100%;max-width:400px;animation:slideUp 0.6s cubic-bezier(0.16,1,0.3,1);}
    @keyframes slideUp{from{opacity:0;transform:translateY(30px)}to{opacity:1;transform:translateY(0)}}
    .login-h{font-family:'Outfit',sans-serif;font-size:1.9rem;font-weight:700;letter-spacing:-0.03em;margin-bottom:6px;}
    .login-sub{font-size:0.85rem;color:var(--muted2);margin-bottom:36px;}
    .login-sub a{color:var(--accent);text-decoration:none;font-weight:500;}
    .login-sub a:hover{text-decoration:underline;}
    .alert-err{padding:12px 16px;background:rgba(244,63,94,0.08);border:1px solid rgba(244,63,94,0.25);border-radius:10px;color:#f87171;font-size:0.82rem;margin-bottom:20px;display:flex;gap:8px;align-items:flex-start;}
    .alert-ok{padding:12px 16px;background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.25);border-radius:10px;color:#34d399;font-size:0.82rem;margin-bottom:20px;}
    .roles{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:28px;}
    .role-btn{padding:14px 10px;border:1.5px solid var(--border);border-radius:12px;background:rgba(255,255,255,0.02);color:var(--muted2);font-size:0.82rem;font-family:'Plus Jakarta Sans',sans-serif;cursor:pointer;transition:all 0.2s;text-align:center;}
    .role-btn .ri{font-size:22px;display:block;margin-bottom:5px;}
    .role-btn.active{border-color:var(--accent);background:rgba(59,130,246,0.08);color:var(--white);box-shadow:0 0 0 1px var(--accent),inset 0 0 20px rgba(59,130,246,0.05);}
    .role-btn:hover:not(.active){border-color:rgba(59,130,246,0.3);color:var(--white);}
    .fl{margin-bottom:18px;}
    .fl label{display:block;font-size:0.72rem;font-weight:600;color:var(--muted2);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:8px;}
    .fl-row{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;}
    .forgot{font-size:0.75rem;color:var(--accent);text-decoration:none;}
    .forgot:hover{text-decoration:underline;}
    .inp{width:100%;background:rgba(255,255,255,0.04);border:1px solid rgba(148,163,184,0.12);border-radius:11px;color:var(--white);padding:13px 16px;font-size:0.9rem;font-family:'Plus Jakarta Sans',sans-serif;outline:none;transition:all 0.2s;}
    .inp::placeholder{color:#2d3f5c;}
    .inp:focus{border-color:var(--accent);background:rgba(59,130,246,0.04);box-shadow:0 0 0 3px rgba(59,130,246,0.1);}
    .inp-wrap{position:relative;}
    .inp-wrap .inp{padding-right:44px;}
    .eye-btn{position:absolute;right:14px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--muted);cursor:pointer;font-size:16px;padding:2px;}
    .eye-btn:hover{color:var(--white);}
    .btn-signin{width:100%;padding:14px;background:linear-gradient(135deg,var(--accent),#2563eb);border:none;border-radius:11px;color:var(--white);font-family:'Outfit',sans-serif;font-size:1rem;font-weight:600;cursor:pointer;transition:all 0.3s;margin-top:8px;position:relative;overflow:hidden;}
    .btn-signin::after{content:'';position:absolute;inset:0;background:linear-gradient(135deg,var(--teal),var(--accent));opacity:0;transition:opacity 0.3s;}
    .btn-signin:hover::after{opacity:1;}
    .btn-signin:hover{transform:translateY(-1px);box-shadow:0 8px 28px rgba(59,130,246,0.4);}
    .btn-signin span{position:relative;z-index:1;}
    .divider{display:flex;align-items:center;gap:12px;margin:24px 0;color:var(--muted);font-size:0.75rem;}
    .divider::before,.divider::after{content:'';flex:1;height:1px;background:var(--border);}
    .legal{text-align:center;font-size:0.75rem;color:var(--muted);line-height:1.7;}
    .legal a{color:var(--accent);text-decoration:none;}

    /* MOBILE */
    .mob-brand{display:none;align-items:center;gap:12px;padding:24px 24px 0;}
    .mob-brand-logo{width:40px;height:40px;background:linear-gradient(135deg,var(--accent),var(--teal));border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;}
    .mob-brand-name{font-family:'Outfit',sans-serif;font-size:1.2rem;font-weight:700;}
    .mob-brand-name em{color:var(--teal);font-style:normal;}

    @media(max-width:768px){
      body{flex-direction:column;overflow:auto;}
      .left{display:none;}
      .right{width:100%;padding:24px;min-height:100vh;align-items:flex-start;}
      .right::before{display:none;}
      .login-box{max-width:100%;}
      .mob-brand{display:flex;}
      .login-h{font-size:1.6rem;margin-top:28px;}
    }
  </style>
</head>
<body>

<!-- Mobile brand header -->
<div class="mob-brand">
  <div class="mob-brand-logo">🩺</div>
  <div class="mob-brand-name">Swasthya<em>Buddy</em></div>
</div>

<div class="left">
  <div class="left-inner">
    <div class="brand">
      <div class="brand-logo">🩺</div>
      <div class="brand-name">Swasthya<em>Buddy</em></div>
    </div>
    <div class="hero-tag"><span></span> AI-Powered Healthcare</div>
    <h1 class="hero-h">Your Smart<br/><span class="grad">Health Companion</span></h1>
    <p class="hero-sub">Intelligent disease prediction, real-time doctor alerts, and smart clinic discovery — all in one beautifully designed platform.</p>
    <div class="features">
      <div class="feat"><div class="feat-icon fi-blue">🤖</div><div class="feat-text"><strong>AI Disease Prediction</strong><span>SVM + Decision Tree models with confidence scores</span></div></div>
      <div class="feat"><div class="feat-icon fi-cyan">📡</div><div class="feat-text"><strong>Live Doctor Alerts</strong><span>Real-time notifications via Server-Sent Events</span></div></div>
      <div class="feat"><div class="feat-icon fi-emerald">🗺️</div><div class="feat-text"><strong>Nearby Clinics & Medicines</strong><span>OpenStreetMap + OpenFDA integration</span></div></div>
    </div>
  </div>
</div>

<div class="right">
  <div class="login-box">
    <h2 class="login-h">Welcome back</h2>
    <p class="login-sub">No account? <a href="signup.jsp">Sign up free →</a></p>
    <%
      String error   = (String) request.getAttribute("error");
      String success = (String) request.getAttribute("success");
    %>
    <% if (error != null && !error.isEmpty()) { %><div class="alert-err">⚠ <%= error %></div><% } %>
    <% if (success != null && !success.isEmpty()) { %><div class="alert-ok">✓ <%= success %></div><% } %>
    <div class="roles">
      <button type="button" class="role-btn active" onclick="setRole(this,'PATIENT')"><span class="ri">🧑‍⚕️</span>Patient</button>
      <button type="button" class="role-btn" onclick="setRole(this,'DOCTOR')"><span class="ri">👨‍⚕️</span>Doctor</button>
    </div>
    <form action="AuthServlet" method="post">
      <input type="hidden" name="action" value="login"/>
      <input type="hidden" name="role" id="roleHidden" value="PATIENT"/>
      <div class="fl">
        <label>Email Address</label>
        <input type="email" class="inp" name="email" placeholder="you@example.com" required autocomplete="email"/>
      </div>
      <div class="fl">
        <div class="fl-row"><label style="margin-bottom:0;">Password</label><a href="#" class="forgot">Forgot password?</a></div>
        <div class="inp-wrap">
          <input type="password" class="inp" name="password" id="pw" placeholder="Enter your password" required autocomplete="current-password"/>
          <button type="button" class="eye-btn" onclick="togglePw()">👁</button>
        </div>
      </div>
      <button type="submit" class="btn-signin"><span>Sign In →</span></button>
    </form>
    <div class="divider">or</div>
    <div class="legal">By signing in you agree to our <a href="#">Terms</a> &amp; <a href="#">Privacy Policy</a></div>
  </div>
</div>

<script>
function setRole(btn,role){document.querySelectorAll('.role-btn').forEach(b=>b.classList.remove('active'));btn.classList.add('active');document.getElementById('roleHidden').value=role;}
function togglePw(){const f=document.getElementById('pw');f.type=f.type==='password'?'text':'password';}
</script>
</body>
</html>