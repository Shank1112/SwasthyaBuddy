<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — Create Account</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    :root{--bg:#060b18;--surface:#0d1528;--surf2:#111e38;--accent:#3b82f6;--teal:#06b6d4;--emerald:#10b981;--rose:#f43f5e;--white:#f8fafc;--muted:#64748b;--muted2:#94a3b8;--border:rgba(148,163,184,0.08);}
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--white);min-height:100vh;display:flex;align-items:flex-start;justify-content:center;padding:40px 20px;}
    body::before{content:'';position:fixed;inset:0;background-image:linear-gradient(rgba(59,130,246,0.03) 1px,transparent 1px),linear-gradient(90deg,rgba(59,130,246,0.03) 1px,transparent 1px);background-size:40px 40px;pointer-events:none;}
    body::after{content:'';position:fixed;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,0.08) 0%,transparent 70%);top:-100px;right:-100px;pointer-events:none;}

    .wrap{width:100%;max-width:660px;position:relative;z-index:1;animation:fadeUp 0.5s cubic-bezier(0.16,1,0.3,1);}
    @keyframes fadeUp{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:translateY(0)}}

    .brand{display:flex;align-items:center;gap:12px;justify-content:center;margin-bottom:32px;}
    .brand-logo{width:44px;height:44px;background:linear-gradient(135deg,var(--accent),var(--teal));border-radius:13px;display:flex;align-items:center;justify-content:center;font-size:22px;box-shadow:0 0 24px rgba(59,130,246,0.4);}
    .brand-name{font-family:'Outfit',sans-serif;font-size:1.25rem;font-weight:700;}
    .brand-name em{color:var(--teal);font-style:normal;}

    .card{background:rgba(13,21,40,0.8);border:1px solid var(--border);border-radius:22px;padding:40px 44px;backdrop-filter:blur(20px);}
    .card-header{text-align:center;margin-bottom:32px;}
    .card-h{font-family:'Outfit',sans-serif;font-size:1.7rem;font-weight:700;letter-spacing:-0.03em;margin-bottom:6px;}
    .card-sub{font-size:0.84rem;color:var(--muted2);}
    .card-sub a{color:var(--accent);text-decoration:none;font-weight:500;}
    .card-sub a:hover{text-decoration:underline;}

    .alert-err{padding:12px 16px;background:rgba(244,63,94,0.08);border:1px solid rgba(244,63,94,0.25);border-radius:10px;color:#f87171;font-size:0.82rem;margin-bottom:20px;}

    .roles{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:32px;}
    .role-card{padding:20px 16px;border:1.5px solid var(--border);border-radius:14px;background:rgba(255,255,255,0.02);cursor:pointer;text-align:center;transition:all 0.25s;position:relative;}
    .role-card.active{border-color:var(--accent);background:rgba(59,130,246,0.06);box-shadow:0 0 0 1px var(--accent),0 8px 24px rgba(59,130,246,0.1);}
    .role-card:hover:not(.active){border-color:rgba(59,130,246,0.3);}
    .check-mark{position:absolute;top:10px;right:10px;width:18px;height:18px;border-radius:50%;background:var(--accent);color:white;font-size:10px;display:none;align-items:center;justify-content:center;}
    .role-card.active .check-mark{display:flex;}
    .role-icon{font-size:28px;margin-bottom:8px;}
    .role-name{font-family:'Outfit',sans-serif;font-size:0.92rem;font-weight:600;color:var(--white);}
    .role-desc{font-size:0.72rem;color:var(--muted);margin-top:3px;}

    .sec-label{font-size:0.68rem;font-weight:700;color:var(--teal);text-transform:uppercase;letter-spacing:0.14em;margin:24px 0 16px;display:flex;align-items:center;gap:10px;}
    .sec-label::after{content:'';flex:1;height:1px;background:var(--border);}

    .row2{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
    .fl{margin-bottom:16px;}
    .fl label{display:block;font-size:0.71rem;font-weight:600;color:var(--muted2);text-transform:uppercase;letter-spacing:0.08em;margin-bottom:7px;}
    .inp{width:100%;background:rgba(255,255,255,0.03);border:1px solid rgba(148,163,184,0.1);border-radius:11px;color:var(--white);padding:12px 14px;font-size:0.88rem;font-family:'Plus Jakarta Sans',sans-serif;outline:none;transition:all 0.2s;-webkit-appearance:none;}
    .inp::placeholder{color:#1e2d45;}
    .inp:focus{border-color:var(--accent);background:rgba(59,130,246,0.04);box-shadow:0 0 0 3px rgba(59,130,246,0.1);}
    select.inp option{background:var(--surface);}
    .inp-wrap{position:relative;}
    .inp-wrap .inp{padding-right:44px;}
    .eye{position:absolute;right:13px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--muted);cursor:pointer;font-size:15px;}

    #doctorFields{display:none;}
    #doctorFields.show{display:block;}

    .str-bar{height:3px;background:rgba(255,255,255,0.06);border-radius:2px;margin-top:8px;overflow:hidden;}
    .str-fill{height:100%;border-radius:2px;width:0%;transition:all 0.3s;}
    .str-txt{font-size:0.68rem;color:var(--muted);margin-top:5px;}

    .check-row{display:flex;align-items:flex-start;gap:10px;margin-top:18px;}
    .check-row input{width:16px;height:16px;margin-top:2px;accent-color:var(--accent);flex-shrink:0;cursor:pointer;}
    .check-row label{font-size:0.8rem;color:var(--muted2);cursor:pointer;line-height:1.5;}
    .check-row label a{color:var(--accent);text-decoration:none;}

    .btn-submit{width:100%;padding:14px;background:linear-gradient(135deg,var(--accent),#2563eb);border:none;border-radius:12px;color:var(--white);font-family:'Outfit',sans-serif;font-size:1rem;font-weight:600;cursor:pointer;transition:all 0.3s;margin-top:22px;position:relative;overflow:hidden;}
    .btn-submit::after{content:'';position:absolute;inset:0;background:linear-gradient(135deg,var(--teal),var(--accent));opacity:0;transition:opacity 0.3s;}
    .btn-submit:hover::after{opacity:1;}
    .btn-submit:hover{transform:translateY(-1px);box-shadow:0 8px 28px rgba(59,130,246,0.4);}
    .btn-submit span{position:relative;z-index:1;}

    @media(max-width:600px){.card{padding:28px 22px;}.row2{grid-template-columns:1fr;}}
  </style>
</head>
<body>
<div class="wrap">
  <div class="brand">
    <div class="brand-logo">🩺</div>
    <div class="brand-name">Swasthya<em>Buddy</em></div>
  </div>
  <div class="card">
    <div class="card-header">
      <h2 class="card-h">Create your account</h2>
      <p class="card-sub">Already registered? <a href="login.jsp">Sign in →</a></p>
    </div>

    <%
      String error = (String) request.getAttribute("error");
    %>
    <% if (error != null) { %><div class="alert-err">⚠ <%= error %></div><% } %>

    <div class="roles">
      <div class="role-card active" id="patCard" onclick="setRole('PATIENT')">
        <span class="check-mark">✓</span>
        <div class="role-icon">🧑‍⚕️</div>
        <div class="role-name">Patient</div>
        <div class="role-desc">Get AI health insights</div>
      </div>
      <div class="role-card" id="docCard" onclick="setRole('DOCTOR')">
        <span class="check-mark">✓</span>
        <div class="role-icon">👨‍⚕️</div>
        <div class="role-name">Doctor</div>
        <div class="role-desc">Manage patient alerts</div>
      </div>
    </div>

    <form action="SignupServlet" method="post" id="form">
      <input type="hidden" name="role" id="roleInput" value="PATIENT"/>

      <div class="sec-label">Personal Information</div>
      <div class="row2">
        <div class="fl"><label>First Name</label><input type="text" class="inp" name="firstName" placeholder="Rahul" required/></div>
        <div class="fl"><label>Last Name</label><input type="text" class="inp" name="lastName" placeholder="Sharma" required/></div>
      </div>
      <div class="fl"><label>Email Address</label><input type="email" class="inp" name="email" placeholder="rahul@example.com" required/></div>
      <div class="row2">
        <div class="fl"><label>Phone</label><input type="tel" class="inp" name="phone" placeholder="9876543210" maxlength="10"/></div>
        <div class="fl"><label>Date of Birth</label><input type="date" class="inp" name="dob"/></div>
      </div>
      <div class="row2">
        <div class="fl"><label>Gender</label><select class="inp" name="gender"><option value="">Select</option><option value="MALE">Male</option><option value="FEMALE">Female</option><option value="OTHER">Other</option></select></div>
        <div class="fl"><label>Blood Group</label><select class="inp" name="bloodGroup"><option value="">Select</option><option>A+</option><option>A-</option><option>B+</option><option>B-</option><option>O+</option><option>O-</option><option>AB+</option><option>AB-</option></select></div>
      </div>

      <div id="doctorFields">
        <div class="sec-label">Professional Details</div>
        <div class="fl"><label>Specialization</label><select class="inp" name="specialization"><option value="">Select</option><option>General Physician</option><option>Cardiologist</option><option>Dermatologist</option><option>Neurologist</option><option>Orthopedist</option><option>Pediatrician</option><option>Psychiatrist</option><option>Other</option></select></div>
        <div class="row2">
          <div class="fl"><label>License No.</label><input type="text" class="inp" name="licenseNo" placeholder="MCI-XXXXXXXX"/></div>
          <div class="fl"><label>Experience (yrs)</label><input type="number" class="inp" name="experience" placeholder="5" min="0" max="60"/></div>
        </div>
      </div>

      <div class="sec-label">Security</div>
      <div class="fl">
        <label>Password</label>
        <div class="inp-wrap"><input type="password" class="inp" name="password" id="pw" placeholder="Min 8 characters" oninput="checkStr(this.value)" required/><button type="button" class="eye" onclick="tglPw('pw')">👁</button></div>
        <div class="str-bar"><div class="str-fill" id="sf"></div></div>
        <div class="str-txt" id="st"></div>
      </div>
      <div class="fl">
        <label>Confirm Password</label>
        <div class="inp-wrap"><input type="password" class="inp" name="confirmPassword" id="cpw" placeholder="Re-enter password" required oninput="checkMatch()"/><button type="button" class="eye" onclick="tglPw('cpw')">👁</button></div>
        <div class="str-txt" id="mt"></div>
      </div>
      <div class="check-row"><input type="checkbox" id="terms" required/><label for="terms">I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label></div>
      <button type="submit" class="btn-submit"><span>Create Account →</span></button>
    </form>
  </div>
</div>
<script>
function setRole(r){
  document.getElementById('roleInput').value=r;
  document.getElementById('patCard').classList.toggle('active',r==='PATIENT');
  document.getElementById('docCard').classList.toggle('active',r==='DOCTOR');
  document.getElementById('doctorFields').classList.toggle('show',r==='DOCTOR');
}
function tglPw(id){const f=document.getElementById(id);f.type=f.type==='password'?'text':'password';}
function checkStr(v){
  const sf=document.getElementById('sf'),st=document.getElementById('st');
  let s=0;
  if(v.length>=8)s++;if(/[A-Z]/.test(v))s++;if(/[0-9]/.test(v))s++;if(/[^A-Za-z0-9]/.test(v))s++;
  const l=[['0%','transparent',''],['25%','#f43f5e','Weak'],['50%','#f59e0b','Fair'],['75%','#3b82f6','Good'],['100%','#10b981','Strong ✓']];
  sf.style.width=l[s][0];sf.style.background=l[s][1];st.textContent=l[s][2];st.style.color=l[s][1];
}
function checkMatch(){
  const mt=document.getElementById('mt'),pw=document.getElementById('pw').value,cpw=document.getElementById('cpw').value;
  if(!cpw){mt.textContent='';return;}
  mt.textContent=cpw===pw?'Passwords match ✓':'Passwords do not match';
  mt.style.color=cpw===pw?'#10b981':'#f43f5e';
}
document.getElementById('form').addEventListener('submit',e=>{
  if(document.getElementById('pw').value!==document.getElementById('cpw').value){e.preventDefault();alert('Passwords do not match!');}
});
</script>
</body>
</html>
