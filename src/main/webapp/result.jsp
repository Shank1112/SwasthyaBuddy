<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swasthyabuddy.model.User,com.swasthyabuddy.model.Prediction,java.util.List" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  String userName = user.getFirstName();
  List<Prediction> predictions = (List<Prediction>) session.getAttribute("predictions");
  String symptomsRaw = (String) session.getAttribute("lastSymptoms");
  if (predictions == null) predictions = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — Results</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
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
    .btn-back{display:flex;align-items:center;gap:6px;padding:7px 14px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:9px;color:var(--muted2);font-size:0.8rem;text-decoration:none;transition:all 0.2s;}
    .btn-back:hover{color:var(--white);border-color:rgba(59,130,246,0.3);}

    .content{padding:28px;max-width:960px;width:100%;margin:0 auto;}

    /* Banner */
    .banner{display:flex;align-items:center;gap:20px;padding:24px 28px;background:linear-gradient(135deg,rgba(59,130,246,0.08),rgba(6,182,212,0.04));border:1px solid rgba(59,130,246,0.2);border-radius:18px;margin-bottom:28px;animation:fadeUp 0.5s ease;}
    @keyframes fadeUp{from{opacity:0;transform:translateY(-12px)}to{opacity:1;transform:translateY(0)}}
    .banner-icon{font-size:2.8rem;flex-shrink:0;}
    .banner-h{font-family:'Outfit',sans-serif;font-size:1.15rem;font-weight:700;margin-bottom:4px;}
    .banner-p{font-size:0.82rem;color:var(--muted2);line-height:1.65;}
    .sym-pills{display:flex;flex-wrap:wrap;gap:6px;margin-top:10px;}
    .sym-pill{padding:3px 10px;background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.2);border-radius:20px;font-size:0.7rem;color:var(--accent);}

    /* Results grid */
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:18px;margin-bottom:24px;}
    .card{background:var(--surface);border:1px solid var(--border2);border-radius:16px;padding:22px;transition:all 0.3s;animation:cardIn 0.4s cubic-bezier(0.16,1,0.3,1) both;cursor:default;}
    .card:nth-child(1){animation-delay:0.1s;} .card:nth-child(2){animation-delay:0.2s;} .card:nth-child(3){animation-delay:0.3s;}
    @keyframes cardIn{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
    .card:hover{transform:translateY(-3px);box-shadow:0 12px 32px rgba(0,0,0,0.3);}
    .card.r1{border-color:rgba(244,63,94,0.3);background:rgba(244,63,94,0.04);grid-column:span 2;}
    .card.r2{border-color:rgba(245,158,11,0.2);}
    .card.r3{border-color:rgba(59,130,246,0.2);}

    .card-top{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;margin-bottom:16px;}
    .rank-badge{display:inline-flex;align-items:center;justify-content:center;width:28px;height:28px;border-radius:8px;font-family:'Outfit',sans-serif;font-size:0.78rem;font-weight:700;flex-shrink:0;}
    .r1 .rank-badge{background:rgba(244,63,94,0.15);color:var(--rose);}
    .r2 .rank-badge{background:rgba(245,158,11,0.15);color:var(--amber);}
    .r3 .rank-badge{background:rgba(59,130,246,0.15);color:var(--accent);}
    .dis-name{font-family:'Outfit',sans-serif;font-size:1.05rem;font-weight:700;flex:1;}
    .r1 .dis-name{font-size:1.22rem;}
    .conf-val{font-family:'Outfit',sans-serif;font-size:1.5rem;font-weight:800;}
    .r1 .conf-val{color:var(--rose);} .r2 .conf-val{color:var(--amber);} .r3 .conf-val{color:var(--accent);}
    .conf-lbl{font-size:0.6rem;color:var(--muted);margin-top:1px;}
    .bar-wrap{height:6px;background:rgba(255,255,255,0.06);border-radius:3px;overflow:hidden;margin-bottom:12px;}
    .bar{height:100%;border-radius:3px;width:0%;transition:width 1.2s cubic-bezier(0.4,0,0.2,1);}
    .r1 .bar{background:linear-gradient(90deg,var(--rose),#fb7185);}
    .r2 .bar{background:linear-gradient(90deg,var(--amber),#fcd34d);}
    .r3 .bar{background:linear-gradient(90deg,var(--accent),var(--teal));}
    .dis-desc{font-size:0.79rem;color:var(--muted2);line-height:1.7;padding-top:12px;border-top:1px solid var(--border);}

    /* Chart */
    .chart-sec{background:var(--surface);border:1px solid var(--border2);border-radius:16px;padding:24px;margin-bottom:24px;animation:fadeUp 0.6s ease 0.4s both;}
    .sec-title{font-family:'Outfit',sans-serif;font-size:0.85rem;font-weight:700;color:var(--white);margin-bottom:20px;display:flex;align-items:center;gap:8px;}
    .sec-title::after{content:'';flex:1;height:1px;background:var(--border);}
    .chart-wrap{position:relative;height:200px;}

    /* Disclaimer */
    .disclaimer{background:rgba(245,158,11,0.06);border:1px solid rgba(245,158,11,0.2);border-radius:14px;padding:16px 20px;display:flex;gap:14px;margin-bottom:24px;animation:fadeUp 0.6s ease 0.5s both;}
    .disc-ico{font-size:20px;flex-shrink:0;margin-top:2px;}
    .disc-txt{font-size:0.79rem;color:#d4a017;line-height:1.7;}
    .disc-txt strong{color:var(--amber);}

    /* Actions */
    .actions{display:flex;flex-wrap:wrap;gap:12px;animation:fadeUp 0.6s ease 0.6s both;}
    .btn-act{display:flex;align-items:center;gap:8px;padding:12px 20px;border-radius:11px;font-family:'Plus Jakarta Sans',sans-serif;font-size:0.84rem;font-weight:600;cursor:pointer;text-decoration:none;transition:all 0.2s;border:none;}
    .btn-primary{background:linear-gradient(135deg,var(--accent),#2563eb);color:white;}
    .btn-primary:hover{transform:translateY(-1px);box-shadow:0 6px 20px rgba(59,130,246,0.35);color:white;}
    .btn-teal{background:rgba(6,182,212,0.1);border:1px solid rgba(6,182,212,0.2);color:var(--teal);}
    .btn-teal:hover{background:rgba(6,182,212,0.18);color:var(--teal);}
    .btn-ghost{background:rgba(255,255,255,0.03);border:1px solid var(--border);color:var(--muted2);}
    .btn-ghost:hover{border-color:rgba(59,130,246,0.3);color:var(--white);}

    @media(max-width:768px){.sidebar{display:none;}.grid{grid-template-columns:1fr;}.card.r1{grid-column:span 1;}.content{padding:20px 16px;}}
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-header"><div class="sb-brand"><div class="sb-logo">🩺</div><div class="sb-title">Swasthya<em>Buddy</em></div></div></div>
  <div class="sb-sec">Menu</div>
  <a href="patient-dashboard.jsp" class="nl"><span class="ni">💬</span>Symptom Check</a>
  <a href="result.jsp" class="nl active"><span class="ni">📊</span>My Results</a>
  <a href="maps.jsp" class="nl"><span class="ni">🗺️</span>Find Clinics</a>
  <a href="medicines.jsp" class="nl"><span class="ni">💊</span>Medicines<span class="nb">New</span></a>
  <div class="sb-sec">Account</div>
  <a href="HistoryServlet" class="nl"><span class="ni">🕐</span>History</a>
  <a href="profile.jsp" class="nl"><span class="ni">👤</span>My Profile</a>
  <div class="sb-footer"><div class="uc"><div class="uc-av"><%= userName.charAt(0) %></div><div><div class="uc-name"><%= userName %></div><div class="uc-role">Patient</div></div><a href="AuthServlet?action=logout" class="uc-out">⏻</a></div></div>
</aside>

<div class="main">
  <div class="topbar">
    <div><div class="tb-title">AI Prediction Results</div><div class="tb-sub">Based on your reported symptoms</div></div>
    <a href="patient-dashboard.jsp" class="btn-back">← New Check</a>
  </div>
  <div class="content">
    <div class="banner">
      <div class="banner-icon">🔬</div>
      <div>
        <div class="banner-h">Analysis Complete</div>
        <div class="banner-p">Our AI has identified the top possible conditions based on your symptoms, ranked by confidence score.</div>
        <% if (symptomsRaw != null && !symptomsRaw.isEmpty()) { %>
        <div class="sym-pills">
          <% for (String s : symptomsRaw.split(",")) { %><span class="sym-pill"><%= s.trim() %></span><% } %>
        </div>
        <% } %>
      </div>
    </div>

    <div class="grid" id="grid">
      <% if (!predictions.isEmpty()) { int rank=1; for (Prediction p : predictions) { %>
      <div class="card r<%= rank %>" data-conf="<%= p.getConfidence() %>">
        <div class="card-top">
          <div class="rank-badge">#<%= rank %></div>
          <div class="dis-name" style="flex:1;padding:0 10px;"><%= p.getName() %></div>
          <div style="text-align:right;"><div class="conf-val"><%= p.getConfidence() %>%</div><div class="conf-lbl">confidence</div></div>
        </div>
        <div class="bar-wrap"><div class="bar" data-w="<%= p.getConfidence() %>"></div></div>
        <% if (rank==1) { %><div class="dis-desc"><%= p.getDescription() %></div><% } %>
      </div>
      <% rank++; if(rank>3) break; } } else { %>
      <!-- Demo fallback -->
      <div class="card r1" data-conf="78">
        <div class="card-top"><div class="rank-badge">#1</div><div class="dis-name" style="flex:1;padding:0 10px;">Viral Fever</div><div style="text-align:right;"><div class="conf-val">78%</div><div class="conf-lbl">confidence</div></div></div>
        <div class="bar-wrap"><div class="bar" data-w="78"></div></div>
        <div class="dis-desc">Viral fever is caused by a viral infection, characterized by elevated temperature, fatigue, and body aches. Typically resolves in 3–7 days with rest and hydration. Consult a doctor if fever exceeds 103°F or lasts beyond 5 days.</div>
      </div>
      <div class="card r2" data-conf="54"><div class="card-top"><div class="rank-badge">#2</div><div class="dis-name" style="flex:1;padding:0 10px;">Influenza</div><div style="text-align:right;"><div class="conf-val">54%</div><div class="conf-lbl">confidence</div></div></div><div class="bar-wrap"><div class="bar" data-w="54"></div></div></div>
      <div class="card r3" data-conf="31"><div class="card-top"><div class="rank-badge">#3</div><div class="dis-name" style="flex:1;padding:0 10px;">Common Cold</div><div style="text-align:right;"><div class="conf-val">31%</div><div class="conf-lbl">confidence</div></div></div><div class="bar-wrap"><div class="bar" data-w="31"></div></div></div>
      <% } %>
    </div>

    <div class="chart-sec">
      <div class="sec-title">📊 Confidence Comparison</div>
      <div class="chart-wrap"><canvas id="chart"></canvas></div>
    </div>

    <div class="disclaimer">
      <div class="disc-ico">⚠️</div>
      <div class="disc-txt"><strong>Medical Disclaimer:</strong> These AI-generated results are for informational purposes only and do not constitute a medical diagnosis. Please consult a qualified healthcare professional before making any health decisions. In emergencies, contact your nearest hospital immediately.</div>
    </div>

    <div class="actions">
      <a href="maps.jsp" class="btn-act btn-primary">🗺️ Find Nearby Clinics</a>
      <a href="medicines.jsp" class="btn-act btn-teal">💊 Browse Medicines</a>
      <a href="patient-dashboard.jsp" class="btn-act btn-ghost">🔄 Check Again</a>
      <button class="btn-act btn-ghost" onclick="window.print()">🖨️ Print</button>
    </div>
  </div>
</div>

<script>
window.addEventListener('load',()=>{
  setTimeout(()=>{document.querySelectorAll('.bar').forEach(b=>{b.style.width=b.getAttribute('data-w')+'%';});},300);
  const cards=document.querySelectorAll('.card');
  const labels=[],vals=[],colors=['rgba(244,63,94,0.8)','rgba(245,158,11,0.8)','rgba(59,130,246,0.8)'],bgs=['rgba(244,63,94,0.12)','rgba(245,158,11,0.12)','rgba(59,130,246,0.12)'];
  cards.forEach((c,i)=>{const n=c.querySelector('.dis-name');if(n){labels.push(n.textContent.trim());vals.push(parseInt(c.getAttribute('data-conf')||0));}});
  new Chart(document.getElementById('chart').getContext('2d'),{type:'bar',data:{labels,datasets:[{label:'Confidence (%)',data:vals,backgroundColor:bgs.slice(0,vals.length),borderColor:colors.slice(0,vals.length),borderWidth:1.5,borderRadius:8}]},options:{indexAxis:'y',responsive:true,maintainAspectRatio:false,animation:{duration:1200,easing:'easeOutQuart',delay:ctx=>ctx.dataIndex*200},plugins:{legend:{display:false},tooltip:{backgroundColor:'#0d1528',borderColor:'rgba(255,255,255,0.08)',borderWidth:1,titleColor:'#f8fafc',bodyColor:'#94a3b8',padding:12,callbacks:{label:c=>`  ${c.parsed.x}% confidence`}}},scales:{x:{max:100,grid:{color:'rgba(255,255,255,0.04)'},ticks:{color:'#64748b',font:{size:11},callback:v=>v+'%'},border:{display:false}},y:{grid:{display:false},ticks:{color:'#f8fafc',font:{size:12,weight:'600'}},border:{display:false}}}}});
});
</script>
</body>
</html>
