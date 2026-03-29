<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swasthyabuddy.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  String userName = user.getFirstName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — Symptom Check</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    :root{--bg:#060b18;--surface:#0d1528;--surf2:#111e38;--surf3:#162040;--accent:#3b82f6;--teal:#06b6d4;--emerald:#10b981;--rose:#f43f5e;--amber:#f59e0b;--white:#f8fafc;--muted:#64748b;--muted2:#94a3b8;--border:rgba(148,163,184,0.08);--border2:rgba(148,163,184,0.14);}
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--white);height:100vh;display:flex;overflow:hidden;}
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

    .main{flex:1;display:flex;flex-direction:column;overflow:hidden;position:relative;z-index:1;}
    .topbar{display:flex;align-items:center;justify-content:space-between;padding:14px 24px;border-bottom:1px solid var(--border);background:rgba(6,11,24,0.85);backdrop-filter:blur(20px);flex-shrink:0;}
    .tb-left .tb-title{font-family:'Outfit',sans-serif;font-size:1rem;font-weight:700;}
    .tb-left .tb-sub{font-size:0.7rem;color:var(--muted);margin-top:1px;}
    .ai-pill{display:flex;align-items:center;gap:6px;padding:5px 12px;background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.2);border-radius:20px;font-size:0.7rem;color:var(--emerald);font-weight:600;}
    .ai-dot{width:6px;height:6px;border-radius:50%;background:var(--emerald);animation:pulse 2s infinite;}
    @keyframes pulse{0%,100%{opacity:1;transform:scale(1)}50%{opacity:0.5;transform:scale(0.8)}}

    .chat-area{flex:1;display:flex;overflow:hidden;}
    .chat-col{flex:1;display:flex;flex-direction:column;overflow:hidden;}
    .messages{flex:1;overflow-y:auto;padding:24px;display:flex;flex-direction:column;gap:16px;}
    .messages::-webkit-scrollbar{width:3px;}
    .messages::-webkit-scrollbar-thumb{background:var(--border);border-radius:2px;}
    .msg{display:flex;gap:10px;max-width:78%;animation:msgIn 0.35s cubic-bezier(0.16,1,0.3,1);}
    @keyframes msgIn{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
    .msg.bot{align-self:flex-start;}
    .msg.user{align-self:flex-end;flex-direction:row-reverse;}
    .msg-av{width:34px;height:34px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;margin-top:2px;}
    .bot .msg-av{background:linear-gradient(135deg,var(--accent),var(--teal));}
    .user .msg-av{background:linear-gradient(135deg,#7c3aed,var(--accent));}
    .bubble{padding:12px 16px;border-radius:16px;font-size:0.86rem;line-height:1.65;}
    .bot .bubble{background:var(--surface);border:1px solid var(--border2);border-top-left-radius:4px;}
    .user .bubble{background:linear-gradient(135deg,rgba(59,130,246,0.2),rgba(59,130,246,0.1));border:1px solid rgba(59,130,246,0.25);border-top-right-radius:4px;}
    .msg-time{font-size:0.62rem;color:var(--muted);margin-top:5px;}
    .bot .msg-time{text-align:left;}.user .msg-time{text-align:right;}
    .chips{display:flex;flex-wrap:wrap;gap:7px;margin-top:12px;}
    .chip{padding:6px 14px;border:1px solid rgba(59,130,246,0.3);border-radius:20px;font-size:0.76rem;color:var(--accent);cursor:pointer;transition:all 0.2s;background:rgba(59,130,246,0.06);}
    .chip:hover{background:rgba(59,130,246,0.15);border-color:var(--accent);color:var(--white);transform:translateY(-1px);}
    .typing{display:flex;align-items:center;gap:4px;padding:10px 14px;background:var(--surface);border:1px solid var(--border2);border-radius:16px;border-top-left-radius:4px;width:fit-content;}
    .td{width:7px;height:7px;border-radius:50%;background:var(--muted2);animation:bounce 1.2s infinite;}
    .td:nth-child(2){animation-delay:0.2s;}.td:nth-child(3){animation-delay:0.4s;}
    @keyframes bounce{0%,100%{transform:translateY(0);opacity:0.4}50%{transform:translateY(-5px);opacity:1}}

    .input-bar{padding:14px 20px;background:rgba(6,11,24,0.9);border-top:1px solid var(--border);flex-shrink:0;}
    .tags-row{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:10px;min-height:0;}
    .sym-tag{display:flex;align-items:center;gap:5px;padding:4px 10px;background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.25);border-radius:20px;font-size:0.74rem;color:var(--emerald);animation:tagPop 0.2s ease;}
    @keyframes tagPop{from{opacity:0;transform:scale(0.75)}to{opacity:1;transform:scale(1)}}
    .tag-x{cursor:pointer;color:var(--muted);font-size:11px;line-height:1;}
    .tag-x:hover{color:var(--rose);}
    .input-row{display:flex;gap:10px;align-items:flex-end;}
    .sym-inp{flex:1;background:rgba(255,255,255,0.04);border:1px solid rgba(148,163,184,0.12);border-radius:12px;color:var(--white);padding:12px 16px;font-size:0.87rem;font-family:'Plus Jakarta Sans',sans-serif;resize:none;outline:none;transition:all 0.2s;max-height:100px;line-height:1.5;}
    .sym-inp::placeholder{color:#1e2d45;}
    .sym-inp:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(59,130,246,0.1);}
    .btn-send{width:44px;height:44px;background:linear-gradient(135deg,var(--accent),#2563eb);border:none;border-radius:12px;color:white;font-size:18px;cursor:pointer;transition:all 0.2s;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
    .btn-send:hover{transform:scale(1.05);box-shadow:0 4px 16px rgba(59,130,246,0.4);}
    .btn-analyse{padding:12px 20px;background:linear-gradient(135deg,var(--emerald),#059669);border:none;border-radius:12px;color:white;font-family:'Outfit',sans-serif;font-size:0.82rem;font-weight:700;cursor:pointer;transition:all 0.2s;white-space:nowrap;flex-shrink:0;}
    .btn-analyse:hover{transform:translateY(-1px);box-shadow:0 4px 16px rgba(16,185,129,0.35);}
    .btn-analyse:disabled{opacity:0.4;cursor:not-allowed;transform:none;box-shadow:none;}
    .inp-hint{font-size:0.66rem;color:var(--muted);margin-top:8px;text-align:center;}
    kbd{background:rgba(255,255,255,0.06);border:1px solid var(--border);padding:1px 5px;border-radius:4px;font-size:0.62rem;}

    .side-panel{width:264px;flex-shrink:0;padding:20px;overflow-y:auto;border-left:1px solid var(--border);display:flex;flex-direction:column;gap:14px;}
    .sp-title{font-size:0.62rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.14em;}
    .stat-box{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:16px;}
    .stat-num{font-family:'Outfit',sans-serif;font-size:2rem;font-weight:800;color:var(--white);}
    .stat-lbl{font-size:0.7rem;color:var(--muted);margin-top:2px;}
    .sym-list-box{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:16px;}
    .sym-ul{list-style:none;display:flex;flex-direction:column;gap:8px;}
    .sym-ul li{display:flex;align-items:center;gap:8px;font-size:0.8rem;color:var(--white);}
    .sym-ul li::before{content:'';width:6px;height:6px;border-radius:50%;background:var(--teal);flex-shrink:0;}
    .tip-box{background:rgba(59,130,246,0.05);border:1px solid rgba(59,130,246,0.15);border-radius:12px;padding:14px;}
    .tip-lbl{font-size:0.6rem;font-weight:700;color:var(--accent);text-transform:uppercase;letter-spacing:0.12em;margin-bottom:6px;}
    .tip-txt{font-size:0.76rem;color:var(--muted2);line-height:1.65;}
    .btn-clear{padding:9px 14px;background:rgba(244,63,94,0.06);border:1px solid rgba(244,63,94,0.2);border-radius:10px;color:var(--rose);font-size:0.76rem;cursor:pointer;transition:all 0.2s;width:100%;text-align:center;}
    .btn-clear:hover{background:rgba(244,63,94,0.12);}

    /* MOBILE NAV */
    .mob-nav{display:none;position:fixed;bottom:0;left:0;right:0;background:var(--surface);border-top:1px solid var(--border);padding:6px 8px;justify-content:space-around;align-items:center;z-index:200;}
    .mob-nav a{display:flex;flex-direction:column;align-items:center;gap:2px;color:var(--muted2);text-decoration:none;font-size:0.58rem;padding:6px 8px;border-radius:10px;min-width:48px;}
    .mob-nav a.active{color:var(--accent);background:rgba(59,130,246,0.1);}
    .mob-nav a span{font-size:18px;}
    .mob-nav .more-btn{display:flex;flex-direction:column;align-items:center;gap:2px;color:var(--muted2);font-size:0.58rem;padding:6px 8px;border-radius:10px;background:none;border:none;cursor:pointer;min-width:48px;}
    .mob-nav .more-btn span{font-size:18px;}

    /* MOBILE SHEET */
    .mob-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,0.6);z-index:300;backdrop-filter:blur(4px);}
    .mob-overlay.open{display:block;}
    .mob-sheet{position:fixed;bottom:0;left:0;right:0;background:var(--surface);border-radius:20px 20px 0 0;padding:16px;z-index:301;transform:translateY(100%);transition:transform 0.3s cubic-bezier(0.16,1,0.3,1);}
    .mob-overlay.open + .mob-sheet,.mob-sheet.open{transform:translateY(0);}
    .sheet-handle{width:40px;height:4px;background:var(--border);border-radius:2px;margin:0 auto 16px;}
    .sheet-title{font-family:'Outfit',sans-serif;font-size:0.9rem;font-weight:700;color:var(--muted2);margin-bottom:12px;padding:0 4px;}
    .sheet-link{display:flex;align-items:center;gap:14px;padding:14px 12px;color:var(--white);text-decoration:none;font-size:0.88rem;border-radius:12px;transition:all 0.2s;}
    .sheet-link:hover{background:rgba(255,255,255,0.05);}
    .sheet-link .si{font-size:20px;width:24px;text-align:center;}
    .sheet-link.danger{color:var(--rose);}

    @media(max-width:900px){
      .sidebar,.side-panel{display:none;}
      .mob-nav{display:flex;}
      .main{padding-bottom:68px;}
      .messages{padding:16px;}
      .input-bar{padding:10px 14px;}
    }
  </style>
</head>
<body>

<aside class="sidebar">
  <div class="sb-header">
    <div class="sb-brand">
      <div class="sb-logo">🩺</div>
      <div class="sb-title">Swasthya<em>Buddy</em></div>
    </div>
  </div>
  <div class="sb-sec">Menu</div>
  <a href="patient-dashboard.jsp" class="nl active"><span class="ni">💬</span>Symptom Check</a>
  <a href="result.jsp" class="nl"><span class="ni">📊</span>My Results</a>
  <a href="maps.jsp" class="nl"><span class="ni">🗺️</span>Find Clinics</a>
  <a href="medicines.jsp" class="nl"><span class="ni">💊</span>Medicines<span class="nb">New</span></a>
  <div class="sb-sec">Account</div>
  <a href="HistoryServlet" class="nl"><span class="ni">🕐</span>History</a>
  <a href="profile.jsp" class="nl"><span class="ni">👤</span>My Profile</a>
  <a href="about.jsp" class="nl"><span class="ni">ℹ️</span>About</a>
  <div class="sb-footer">
    <div class="uc">
      <div class="uc-av"><%= userName.charAt(0) %></div>
      <div><div class="uc-name"><%= userName %></div><div class="uc-role">Patient</div></div>
      <a href="AuthServlet?action=logout" class="uc-out" title="Logout">⏻</a>
    </div>
  </div>
</aside>

<div class="main">
  <div class="topbar">
    <div class="tb-left">
      <div class="tb-title">Symptom Check</div>
      <div class="tb-sub">Describe your symptoms one at a time</div>
    </div>
    <div class="ai-pill"><div class="ai-dot"></div>AI Ready</div>
  </div>

  <div class="chat-area">
    <div class="chat-col">
      <div class="messages" id="messages">
        <div class="msg bot">
          <div class="msg-av">🤖</div>
          <div>
            <div class="bubble">Hello <strong><%= userName %></strong>! 👋 I'm your AI health assistant. Tell me your symptoms one at a time and I'll help analyse them for you.</div>
            <div class="msg-time">Just now</div>
          </div>
        </div>
        <div class="msg bot">
          <div class="msg-av">🤖</div>
          <div>
            <div class="bubble">
              Quick-start with common symptoms:
              <div class="chips">
                <span class="chip" onclick="chipAdd('Fever')">🌡 Fever</span>
                <span class="chip" onclick="chipAdd('Headache')">🤕 Headache</span>
                <span class="chip" onclick="chipAdd('Cough')">😷 Cough</span>
                <span class="chip" onclick="chipAdd('Fatigue')">😴 Fatigue</span>
                <span class="chip" onclick="chipAdd('Nausea')">🤢 Nausea</span>
                <span class="chip" onclick="chipAdd('Chest Pain')">💔 Chest Pain</span>
                <span class="chip" onclick="chipAdd('Breathlessness')">😮‍💨 Breathlessness</span>
                <span class="chip" onclick="chipAdd('Body Ache')">🦴 Body Ache</span>
              </div>
            </div>
            <div class="msg-time">Just now</div>
          </div>
        </div>
      </div>

      <div class="input-bar">
        <div class="tags-row" id="tagsRow"></div>
        <div class="input-row">
          <textarea class="sym-inp" id="si" placeholder="Type a symptom and press Enter…" rows="1" onkeydown="onKey(event)" oninput="resize(this)"></textarea>
          <button class="btn-send" onclick="addFromInp()" title="Add">➤</button>
          <button class="btn-analyse" id="analyseBtn" disabled onclick="doPredict()">🔍 Analyse</button>
        </div>
        <div class="inp-hint">Press <kbd>Enter</kbd> to add · Need at least 2 symptoms</div>
      </div>
    </div>

    <div class="side-panel">
      <div class="sp-title">Session</div>
      <div class="stat-box">
        <div class="stat-num" id="cnt">0</div>
        <div class="stat-lbl">Symptoms Added</div>
      </div>
      <div class="sym-list-box">
        <div class="sp-title" style="margin-bottom:10px;">Your Symptoms</div>
        <ul class="sym-ul" id="symUl"><li style="color:var(--muted);font-size:0.78rem;font-style:italic;">Nothing yet</li></ul>
      </div>
      <div class="tip-box">
        <div class="tip-lbl">💡 Tip</div>
        <div class="tip-txt">Add 3–4 specific symptoms for best accuracy. E.g. "severe headache" vs just "pain".</div>
      </div>
      <button class="btn-clear" onclick="clearAll()">🗑 Clear All</button>
    </div>
  </div>
</div>

<!-- Mobile Bottom Nav -->
<nav class="mob-nav">
  <a href="patient-dashboard.jsp" class="active"><span>💬</span>Symptoms</a>
  <a href="result.jsp"><span>📊</span>Results</a>
  <a href="maps.jsp"><span>🗺️</span>Clinics</a>
  <a href="medicines.jsp"><span>💊</span>Medicines</a>
  <button class="more-btn" onclick="openSheet()"><span>⋯</span>More</button>
</nav>

<!-- Mobile Sheet Overlay -->
<div class="mob-overlay" id="overlay" onclick="closeSheet()"></div>
<div class="mob-sheet" id="mobSheet">
  <div class="sheet-handle"></div>
  <div class="sheet-title">More Options</div>
  <a href="HistoryServlet" class="sheet-link"><span class="si">🕐</span>History</a>
  <a href="profile.jsp" class="sheet-link"><span class="si">👤</span>My Profile</a>
  <a href="about.jsp" class="sheet-link"><span class="si">ℹ️</span>About SwasthyaBuddy</a>
  <a href="AuthServlet?action=logout" class="sheet-link danger"><span class="si">⏻</span>Logout</a>
</div>

<form id="pf" action="PredictionServlet" method="post" style="display:none;"><input type="hidden" name="symptoms" id="sh"/></form>

<script>
let symptoms=[];
const botLines=["Got it — noted <strong>{s}</strong>. Anything else?","Noted: <strong>{s}</strong>. Keep going!","Added <strong>{s}</strong>. Any other symptoms?","I see you're experiencing <strong>{s}</strong>. More?","Understood — <strong>{s}</strong>. Add more or click Analyse."];
let bi=0;
function now(){return new Date().toLocaleTimeString([],{hour:'2-digit',minute:'2-digit'});}
function chipAdd(s){addSym(s);addUserMsg(s);botReply(s);}
function addFromInp(){const el=document.getElementById('si');const v=el.value.trim();if(!v)return;addSym(v);addUserMsg(v);botReply(v);el.value='';el.style.height='auto';}
function addSym(s){const c=s.trim().toLowerCase();if(!c||symptoms.includes(c))return;symptoms.push(c);renderTags();renderPanel();document.getElementById('analyseBtn').disabled=symptoms.length<2;}
function removeSym(s){symptoms=symptoms.filter(x=>x!==s);renderTags();renderPanel();document.getElementById('analyseBtn').disabled=symptoms.length<2;}
function renderTags(){const r=document.getElementById('tagsRow');r.innerHTML='';symptoms.forEach(s=>{const d=document.createElement('div');d.className='sym-tag';d.innerHTML=s+' <span class="tag-x" onclick="removeSym(\''+s+'\')">✕</span>';r.appendChild(d);});}
function renderPanel(){document.getElementById('cnt').textContent=symptoms.length;const ul=document.getElementById('symUl');ul.innerHTML=symptoms.length?symptoms.map(s=>'<li>'+s.charAt(0).toUpperCase()+s.slice(1)+'</li>').join(''):'<li style="color:var(--muted);font-style:italic;">Nothing yet</li>';}
function addUserMsg(t){const d=document.createElement('div');d.className='msg user';d.innerHTML='<div class="msg-av">👤</div><div><div class="bubble">'+t+'</div><div class="msg-time">'+now()+'</div></div>';document.getElementById('messages').appendChild(d);scrollDown();}
function botReply(s){showTyping();setTimeout(()=>{removeTyping();const d=document.createElement('div');d.className='msg bot';d.innerHTML='<div class="msg-av">🤖</div><div><div class="bubble">'+botLines[bi%botLines.length].replace('{s}',s)+'</div><div class="msg-time">'+now()+'</div></div>';bi++;document.getElementById('messages').appendChild(d);scrollDown();},900);}
function showTyping(){const t=document.createElement('div');t.className='msg bot';t.id='typing';t.innerHTML='<div class="msg-av">🤖</div><div class="typing"><div class="td"></div><div class="td"></div><div class="td"></div></div>';document.getElementById('messages').appendChild(t);scrollDown();}
function removeTyping(){const t=document.getElementById('typing');if(t)t.remove();}
function doPredict(){if(symptoms.length<2)return;addUserMsg('Analyse: '+symptoms.join(', '));showTyping();setTimeout(()=>{removeTyping();const d=document.createElement('div');d.className='msg bot';d.innerHTML='<div class="msg-av">🤖</div><div><div class="bubble">Analysing <strong>'+symptoms.length+' symptoms</strong>… Sending to AI model now ✨</div><div class="msg-time">'+now()+'</div></div>';document.getElementById('messages').appendChild(d);scrollDown();setTimeout(()=>{document.getElementById('sh').value=symptoms.join(',');document.getElementById('pf').submit();},1200);},1000);}
function clearAll(){symptoms=[];renderTags();renderPanel();document.getElementById('analyseBtn').disabled=true;const d=document.createElement('div');d.className='msg bot';d.innerHTML='<div class="msg-av">🤖</div><div><div class="bubble">Cleared! Let\'s start fresh. What are you feeling?</div><div class="msg-time">'+now()+'</div></div>';document.getElementById('messages').appendChild(d);scrollDown();}
function onKey(e){if(e.key==='Enter'&&!e.shiftKey){e.preventDefault();addFromInp();}}
function resize(el){el.style.height='auto';el.style.height=Math.min(el.scrollHeight,100)+'px';}
function scrollDown(){const m=document.getElementById('messages');m.scrollTop=m.scrollHeight;}
function openSheet(){document.getElementById('overlay').classList.add('open');document.getElementById('mobSheet').classList.add('open');}
function closeSheet(){document.getElementById('overlay').classList.remove('open');document.getElementById('mobSheet').classList.remove('open');}
</script>
</body>
</html>