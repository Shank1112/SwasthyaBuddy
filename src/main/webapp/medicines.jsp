<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  Object userObj = session.getAttribute("user");
  if (userObj == null) { response.sendRedirect("login.jsp"); return; }
  com.swasthyabuddy.model.User user = (com.swasthyabuddy.model.User) userObj;
  String userName = user.getFirstName();
  String urlSuccess = request.getParameter("success");
  String urlError   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — Medicines</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    :root{--navy:#0b1437;--navy2:#0f1e4f;--accent:#4f8ef7;--accent2:#38d9c0;--white:#ffffff;--muted:#8a9bc4;--glass:rgba(255,255,255,0.05);--border:rgba(255,255,255,0.09);}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'DM Sans',sans-serif;background:var(--navy);color:var(--white);min-height:100vh;display:flex;}

    .sidebar{width:250px;background:var(--navy2);border-right:1px solid var(--border);display:flex;flex-direction:column;flex-shrink:0;padding:24px 0;position:sticky;top:0;height:100vh;overflow-y:auto;}
    .sb-brand{display:flex;align-items:center;gap:10px;padding:0 20px 24px;border-bottom:1px solid var(--border);margin-bottom:16px;}
    .sb-icon{width:36px;height:36px;background:linear-gradient(135deg,var(--accent),var(--accent2));border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:18px;}
    .sb-name{font-family:'Sora',sans-serif;font-size:1rem;font-weight:700;}
    .sb-name span{color:var(--accent2);}
    .nav-lbl{font-size:.6rem;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:.12em;padding:0 20px;margin:10px 0 4px;}
    .nav-item{display:flex;align-items:center;gap:12px;padding:10px 20px;color:var(--muted);font-size:.84rem;text-decoration:none;transition:all .2s;position:relative;}
    .nav-item:hover{color:var(--white);background:var(--glass);}
    .nav-item.active{color:var(--white);background:rgba(79,142,247,.12);}
    .nav-item.active::before{content:'';position:absolute;left:0;top:0;bottom:0;width:3px;background:linear-gradient(to bottom,var(--accent),var(--accent2));border-radius:0 2px 2px 0;}
    .sb-footer{margin-top:auto;padding:14px 20px;border-top:1px solid var(--border);}
    .user-pill{display:flex;align-items:center;gap:10px;padding:9px 12px;background:var(--glass);border:1px solid var(--border);border-radius:10px;}
    .avatar{width:30px;height:30px;background:linear-gradient(135deg,var(--accent),var(--accent2));border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;flex-shrink:0;}
    .u-name{font-size:.78rem;font-weight:500;}
    .u-role{font-size:.62rem;color:var(--muted);}
    .logout-a{margin-left:auto;color:var(--muted);font-size:14px;text-decoration:none;}
    .logout-a:hover{color:#ff6b6b;}

    .main{flex:1;display:flex;flex-direction:column;overflow:auto;}
    .topbar{display:flex;align-items:center;justify-content:space-between;padding:14px 28px;border-bottom:1px solid var(--border);background:rgba(11,20,55,.85);backdrop-filter:blur(10px);position:sticky;top:0;z-index:50;}
    .topbar-title{font-family:'Sora',sans-serif;font-size:1rem;font-weight:600;}
    .topbar-title span{color:var(--muted);font-weight:400;font-size:.82rem;margin-left:8px;}
    .topbar-right{display:flex;align-items:center;gap:10px;}
    .fda-badge{display:flex;align-items:center;gap:5px;padding:4px 10px;background:rgba(56,217,192,.1);border:1px solid rgba(56,217,192,.25);border-radius:20px;font-size:.65rem;color:var(--accent2);font-weight:600;letter-spacing:.05em;}
    .cart-btn{display:flex;align-items:center;gap:8px;padding:7px 16px;background:rgba(79,142,247,.12);border:1px solid rgba(79,142,247,.3);border-radius:10px;color:var(--accent);font-size:.82rem;cursor:pointer;transition:all .2s;font-family:'DM Sans',sans-serif;}
    .cart-btn:hover{background:rgba(79,142,247,.2);}
    .cart-count{background:var(--accent);color:white;font-size:.6rem;font-weight:700;padding:1px 5px;border-radius:10px;min-width:16px;text-align:center;}

    .content{flex:1;display:flex;overflow:hidden;}
    .catalog-col{flex:1;display:flex;flex-direction:column;overflow:hidden;border-right:1px solid var(--border);}

    .search-bar{display:flex;align-items:center;gap:10px;padding:14px 20px;border-bottom:1px solid var(--border);flex-shrink:0;flex-wrap:wrap;}
    .search-wrap{flex:1;min-width:240px;position:relative;display:flex;align-items:center;}
    .search-icon{position:absolute;left:12px;color:var(--muted);font-size:14px;pointer-events:none;}
    .search-input{width:100%;background:var(--glass);border:1px solid var(--border);border-radius:10px;color:var(--white);padding:9px 14px 9px 36px;font-size:.85rem;font-family:'DM Sans',sans-serif;outline:none;transition:border-color .2s;}
    .search-input::placeholder{color:#3a4a68;}
    .search-input:focus{border-color:var(--accent);}
    .btn-search{padding:8px 18px;background:linear-gradient(135deg,var(--accent),#3b7de8);border:none;border-radius:10px;color:white;font-family:'DM Sans',sans-serif;font-size:.82rem;font-weight:600;cursor:pointer;white-space:nowrap;transition:all .2s;}
    .btn-search:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(79,142,247,.4);}
    .btn-search:disabled{opacity:.5;cursor:not-allowed;transform:none;box-shadow:none;}

    .quick-bar{display:flex;gap:6px;flex-wrap:wrap;padding:10px 20px;border-bottom:1px solid var(--border);flex-shrink:0;align-items:center;}
    .quick-lbl{font-size:.65rem;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:.08em;white-space:nowrap;}
    .q-pill{padding:4px 12px;border-radius:20px;font-size:.72rem;border:1px solid var(--border);background:var(--glass);color:var(--muted);cursor:pointer;transition:all .2s;font-family:'DM Sans',sans-serif;}
    .q-pill:hover{color:var(--white);border-color:rgba(79,142,247,.4);background:rgba(79,142,247,.08);}

    .catalog-meta{padding:8px 20px;font-size:.72rem;color:var(--muted);border-bottom:1px solid var(--border);flex-shrink:0;display:flex;align-items:center;justify-content:space-between;}
    .meta-source{font-size:.62rem;color:rgba(56,217,192,.6);}

    .medicine-grid{flex:1;overflow-y:auto;display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:14px;padding:16px;align-content:start;}
    .medicine-grid::-webkit-scrollbar{width:3px;}
    .medicine-grid::-webkit-scrollbar-thumb{background:var(--border);border-radius:2px;}

    .state-wrap{display:flex;flex-direction:column;align-items:center;justify-content:center;height:240px;gap:14px;color:var(--muted);text-align:center;padding:40px;grid-column:1/-1;}
    .state-icon{font-size:3rem;opacity:.3;}
    .state-title{font-family:'Sora',sans-serif;font-size:.9rem;color:var(--muted);}
    .state-sub{font-size:.75rem;color:rgba(138,155,196,.6);max-width:320px;line-height:1.6;}
    .spinner{width:32px;height:32px;border:3px solid var(--border);border-top-color:var(--accent);border-radius:50%;animation:spin .7s linear infinite;}
    @keyframes spin{to{transform:rotate(360deg);}}

    .med-card{background:var(--glass);border:1px solid var(--border);border-radius:14px;padding:16px;display:flex;flex-direction:column;gap:10px;transition:all .2s;animation:medIn .3s ease both;}
    @keyframes medIn{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}
    .med-card:hover{border-color:rgba(79,142,247,.35);transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.25);}
    .med-top{display:flex;align-items:flex-start;justify-content:space-between;gap:8px;}
    .med-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;background:rgba(79,142,247,.12);}
    .rx-badge{font-size:.58rem;padding:2px 6px;border-radius:6px;border:1px solid rgba(255,169,77,.35);background:rgba(255,169,77,.1);color:#ffa94d;}
    .otc-badge{font-size:.58rem;padding:2px 6px;border-radius:6px;border:1px solid rgba(56,217,192,.3);background:rgba(56,217,192,.08);color:var(--accent2);}
    .med-name{font-family:'Sora',sans-serif;font-size:.88rem;font-weight:600;line-height:1.3;}
    /* Indian brand shown prominently */
    .med-india-brand{font-size:.72rem;color:var(--accent2);font-weight:600;margin-top:1px;letter-spacing:.02em;}
    .med-generic{font-size:.7rem;color:var(--muted);margin-top:2px;}
    .med-desc{font-size:.72rem;color:var(--muted);line-height:1.5;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;}
    .med-tags{display:flex;gap:4px;flex-wrap:wrap;}
    .med-tag{font-size:.6rem;padding:2px 7px;border-radius:6px;border:1px solid var(--border);background:var(--glass);color:var(--muted);}
    .med-price-row{display:flex;align-items:center;justify-content:space-between;}
    .med-price{font-family:'Sora',sans-serif;font-size:1rem;font-weight:700;}
    .in-stock{font-size:.62rem;padding:2px 7px;border-radius:6px;background:rgba(56,217,192,.1);border:1px solid rgba(56,217,192,.25);color:var(--accent2);}
    .qty-row{display:flex;align-items:center;gap:8px;}
    .qty-btn{width:26px;height:26px;border-radius:6px;background:var(--glass);border:1px solid var(--border);color:var(--white);font-size:14px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .15s;}
    .qty-btn:hover{background:rgba(79,142,247,.15);border-color:var(--accent);}
    .qty-val{font-family:'Sora',sans-serif;font-size:.85rem;font-weight:600;min-width:20px;text-align:center;}
    .btn-add{flex:1;padding:8px;background:linear-gradient(135deg,var(--accent),#3b7de8);border:none;border-radius:8px;color:white;font-family:'DM Sans',sans-serif;font-size:.78rem;font-weight:500;cursor:pointer;transition:all .2s;}
    .btn-add:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(79,142,247,.35);}
    .btn-add.added{background:linear-gradient(135deg,var(--accent2),#2ac0a8);color:var(--navy);}
    .btn-label{background:none;border:1px solid var(--border);border-radius:7px;color:var(--muted);font-size:.7rem;padding:5px 8px;cursor:pointer;transition:all .2s;font-family:'DM Sans',sans-serif;width:100%;text-align:center;}
    .btn-label:hover{color:var(--white);border-color:rgba(79,142,247,.4);}
    .btn-buy-online{background:none;border:1px solid rgba(56,217,192,.3);border-radius:7px;color:var(--accent2);font-size:.7rem;padding:5px 8px;cursor:pointer;transition:all .2s;font-family:'DM Sans',sans-serif;width:100%;text-align:center;margin-top:6px;}
    .btn-buy-online:hover{background:rgba(56,217,192,.08);color:var(--white);}

    /* ── MODAL ────────────────── */
    .modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.65);backdrop-filter:blur(5px);z-index:600;display:flex;align-items:center;justify-content:center;padding:20px;animation:fadeIn .2s ease;}
    @keyframes fadeIn{from{opacity:0}to{opacity:1}}
    .modal-box{background:var(--navy2);border:1px solid rgba(79,142,247,.2);border-radius:18px;width:100%;max-width:540px;max-height:82vh;overflow-y:auto;padding:24px;display:flex;flex-direction:column;gap:14px;}
    .modal-box::-webkit-scrollbar{width:3px;}
    .modal-box::-webkit-scrollbar-thumb{background:var(--border);}
    .modal-header{display:flex;align-items:flex-start;justify-content:space-between;gap:10px;}
    .modal-close{color:var(--muted);font-size:20px;cursor:pointer;flex-shrink:0;background:none;border:none;padding:2px 8px;border-radius:6px;line-height:1;}
    .modal-close:hover{color:var(--white);background:rgba(255,255,255,.06);}
    .modal-section{border-top:1px solid var(--border);padding-top:12px;}
    .modal-lbl{font-size:.65rem;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:.1em;margin-bottom:5px;}
    .modal-val{font-size:.8rem;color:var(--white);line-height:1.65;}
    .warn-box{background:rgba(255,169,77,.08);border:1px solid rgba(255,169,77,.25);border-radius:8px;padding:10px 12px;font-size:.75rem;color:#ffa94d;line-height:1.65;}
    .fda-note{font-size:.63rem;color:rgba(138,155,196,.45);line-height:1.6;padding-top:8px;border-top:1px solid var(--border);}

    /* ── CART PANEL ────────────────── */
    .cart-panel{width:300px;flex-shrink:0;display:flex;flex-direction:column;transition:width .3s;overflow:hidden;}
    .cart-panel.collapsed{width:0;}
    .cart-header{padding:14px 18px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;flex-shrink:0;}
    .cart-title{font-family:'Sora',sans-serif;font-size:.85rem;font-weight:600;}
    .cart-close-btn{color:var(--muted);font-size:16px;cursor:pointer;background:none;border:none;padding:2px 6px;border-radius:6px;}
    .cart-close-btn:hover{color:var(--white);}
    .cart-items{flex:1;overflow-y:auto;padding:12px;display:flex;flex-direction:column;gap:10px;}
    .cart-empty{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;gap:10px;color:var(--muted);}
    .cart-empty .ei{font-size:2.5rem;opacity:.3;}
    .cart-empty p{font-size:.8rem;}
    .cart-item{display:flex;gap:10px;padding:10px;background:var(--glass);border:1px solid var(--border);border-radius:10px;align-items:flex-start;}
    .ci-icon{width:32px;height:32px;border-radius:8px;background:rgba(79,142,247,.12);display:flex;align-items:center;justify-content:center;font-size:14px;flex-shrink:0;}
    .ci-name{font-size:.78rem;font-weight:500;line-height:1.3;}
    .ci-india{font-size:.65rem;color:var(--accent2);margin-top:1px;}
    .ci-price{font-size:.72rem;color:var(--accent);margin-top:2px;}
    .ci-remove{margin-left:auto;color:var(--muted);font-size:13px;cursor:pointer;background:none;border:none;padding:0;flex-shrink:0;}
    .ci-remove:hover{color:#ff6b6b;}
    .cart-footer{padding:14px;border-top:1px solid var(--border);flex-shrink:0;display:flex;flex-direction:column;gap:8px;}
    .cart-subtotal{display:flex;justify-content:space-between;align-items:center;}
    .subtotal-label{font-size:.78rem;color:var(--muted);}
    .subtotal-val{font-family:'Sora',sans-serif;font-size:1.1rem;font-weight:700;}
    /* Two action buttons */
    .btn-checkout{width:100%;padding:11px;background:linear-gradient(135deg,var(--accent2),#2ac0a8);border:none;border-radius:10px;color:var(--navy);font-family:'Sora',sans-serif;font-size:.85rem;font-weight:700;cursor:pointer;transition:all .2s;}
    .btn-checkout:hover{transform:translateY(-1px);box-shadow:0 4px 16px rgba(56,217,192,.3);}
    .btn-checkout:disabled{opacity:.4;cursor:not-allowed;transform:none;box-shadow:none;}
    .btn-buy-cart{width:100%;padding:9px;background:none;border:1px solid rgba(79,142,247,.35);border-radius:10px;color:var(--accent);font-family:'DM Sans',sans-serif;font-size:.82rem;cursor:pointer;transition:all .2s;}
    .btn-buy-cart:hover{background:rgba(79,142,247,.1);}
    .btn-buy-cart:disabled{opacity:.4;cursor:not-allowed;}

    /* ── CONFIRM MODAL ────────────────── */
    .confirm-modal{position:fixed;inset:0;background:rgba(0,0,0,.7);backdrop-filter:blur(6px);z-index:700;display:none;align-items:center;justify-content:center;padding:20px;}
    .confirm-box{background:var(--navy2);border:1px solid rgba(79,142,247,.25);border-radius:18px;width:100%;max-width:400px;padding:24px;display:flex;flex-direction:column;gap:16px;}
    .confirm-title{font-family:'Sora',sans-serif;font-size:1rem;font-weight:700;}
    .confirm-items{font-size:.78rem;color:var(--muted);line-height:1.8;max-height:160px;overflow-y:auto;}
    .confirm-total{font-family:'Sora',sans-serif;font-size:1.1rem;font-weight:700;color:var(--accent2);}
    .confirm-btns{display:flex;gap:10px;}
    .confirm-yes{flex:1;padding:11px;background:linear-gradient(135deg,var(--accent2),#2ac0a8);border:none;border-radius:10px;color:var(--navy);font-family:'Sora',sans-serif;font-size:.85rem;font-weight:700;cursor:pointer;}
    .confirm-no{flex:1;padding:11px;background:none;border:1px solid var(--border);border-radius:10px;color:var(--muted);font-family:'DM Sans',sans-serif;font-size:.85rem;cursor:pointer;}
    .confirm-no:hover{color:var(--white);}

    .toast-wrap{position:fixed;bottom:24px;right:24px;z-index:9999;display:flex;flex-direction:column;gap:8px;pointer-events:none;}
    .toast-item{display:flex;align-items:center;gap:10px;padding:12px 18px;background:#0f1e4f;border:1px solid rgba(56,217,192,.3);border-radius:12px;color:var(--white);font-size:.82rem;min-width:240px;max-width:320px;box-shadow:0 8px 32px rgba(0,0,0,.4);animation:toastIn .3s ease,toastOut .3s ease 2.7s forwards;}
    @keyframes toastIn{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}
    @keyframes toastOut{from{opacity:1}to{opacity:0}}

    .alert-success{background:rgba(56,217,192,.1);border:1px solid rgba(56,217,192,.3);border-radius:8px;padding:10px 14px;color:var(--accent2);font-size:.82rem;margin:12px 20px 0;}
    .alert-error{background:rgba(255,107,107,.1);border:1px solid rgba(255,107,107,.25);border-radius:8px;padding:10px 14px;color:#ff6b6b;font-size:.82rem;margin:12px 20px 0;}

    @media(max-width:900px){
      .sidebar{display:none;}
      .cart-panel{position:fixed;top:0;right:0;bottom:0;z-index:300;width:280px!important;background:var(--navy2);}
      .cart-panel.collapsed{width:0!important;}
    }
  </style>
</head>
<body>

<aside class="sidebar">
  <div class="sb-brand">
    <div class="sb-icon">🩺</div>
    <div class="sb-name">Swasthya<span>Buddy</span></div>
  </div>
  <div class="nav-lbl">Menu</div>
  <a href="patient-dashboard.jsp" class="nav-item">💬 Symptom Check</a>
  <a href="result.jsp"            class="nav-item">📊 My Results</a>
  <a href="HistoryServlet"        class="nav-item">🕐 History</a>
  <a href="maps.jsp"              class="nav-item">🗺️ Find Clinics</a>
  <a href="medicines.jsp"         class="nav-item active">💊 Medicines</a>
  <div class="nav-lbl">Account</div>
  <a href="profile.jsp"           class="nav-item">👤 My Profile</a>
  <div class="sb-footer">
    <div class="user-pill">
      <div class="avatar"><%= userName.charAt(0) %></div>
      <div>
        <div class="u-name"><%= userName %></div>
        <div class="u-role">Patient</div>
      </div>
      <a href="AuthServlet?action=logout" class="logout-a" title="Logout">⏻</a>
    </div>
  </div>
</aside>

<div class="main">
  <div class="topbar">
    <div class="topbar-title">Medicine Search <span>Powered by OpenFDA</span></div>
    <div class="topbar-right">
      <div class="fda-badge">🇺🇸 OpenFDA Live</div>
      <button class="cart-btn" onclick="toggleCart()">
        🛒 Cart <span class="cart-count" id="cartCount">0</span>
      </button>
    </div>
  </div>

  <% if ("order_placed".equals(urlSuccess)) { %>
    <div class="alert-success">✓ Order placed successfully! Thank you.</div>
  <% } %>
  <% if (urlError != null) { %>
    <div class="alert-error">⚠ Something went wrong. Please try again.</div>
  <% } %>

  <div class="content">
    <div class="catalog-col">
      <div class="search-bar">
        <div class="search-wrap">
          <span class="search-icon">🔍</span>
          <input type="text" class="search-input" id="medSearch"
                 placeholder="Search by drug name (e.g. Crocin, Paracetamol, Dolo…)"
                 onkeydown="if(event.key==='Enter'){doSearch();}" autocomplete="off"/>
        </div>
        <button class="btn-search" id="searchBtn" onclick="doSearch()">Search FDA</button>
      </div>

      <div class="quick-bar">
        <span class="quick-lbl">Quick:</span>
        <button class="q-pill" onclick="quickSearch('paracetamol')">Paracetamol / Crocin</button>
        <button class="q-pill" onclick="quickSearch('ibuprofen')">Ibuprofen / Brufen</button>
        <button class="q-pill" onclick="quickSearch('amoxicillin')">Amoxicillin</button>
        <button class="q-pill" onclick="quickSearch('cetirizine')">Cetirizine</button>
        <button class="q-pill" onclick="quickSearch('metformin')">Metformin</button>
        <button class="q-pill" onclick="quickSearch('aspirin')">Aspirin / Disprin</button>
        <button class="q-pill" onclick="quickSearch('omeprazole')">Omeprazole / Omez</button>
        <button class="q-pill" onclick="quickSearch('azithromycin')">Azithromycin / Zithromax</button>
      </div>

      <div class="catalog-meta" id="catMeta">
        <span>Search the FDA drug database — type an Indian or US drug name</span>
        <span class="meta-source">📡 api.fda.gov/drug/label.json</span>
      </div>

      <div class="medicine-grid" id="medGrid">
        <div class="state-wrap">
          <div class="state-icon">💊</div>
          <div class="state-title">Search the FDA Drug Database</div>
          <div class="state-sub">Type a medicine name — Indian brands like Crocin, Dolo, Combiflam, Augmentin are automatically mapped to their FDA equivalents.</div>
        </div>
      </div>
    </div>

    <div class="cart-panel collapsed" id="cartPanel">
      <div class="cart-header">
        <div class="cart-title">🛒 Your Cart</div>
        <button class="cart-close-btn" onclick="toggleCart()">✕</button>
      </div>
      <div class="cart-items" id="cartItems">
        <div class="cart-empty"><div class="ei">🛒</div><p>Cart is empty</p></div>
      </div>
      <div class="cart-footer">
        <div class="cart-subtotal">
          <span class="subtotal-label">Estimated Total</span>
          <span class="subtotal-val" id="cartTotal">₹0.00</span>
        </div>
        <!-- Primary: confirms + opens Google Shopping for medicine -->
        <button class="btn-checkout" id="checkoutBtn" disabled onclick="showConfirm()">🛒 Find & Order Medicine →</button>
        <!-- Secondary: Apollo Pharmacy direct -->
        <button class="btn-buy-cart" id="buyCartBtn" disabled onclick="buyCartOn1mg()">Try Apollo Pharmacy</button>
      </div>
    </div>
  </div>
</div>

<!-- Detail Modal -->
<div class="modal-overlay" id="detailModal" style="display:none;" onclick="handleModalClick(event)">
  <div class="modal-box" id="modalContent"></div>
</div>

<!-- Order Confirm Modal -->
<div class="confirm-modal" id="confirmModal">
  <div class="confirm-box">
    <div class="confirm-title">Confirm Order</div>
    <div class="confirm-items" id="confirmItems"></div>
    <div class="confirm-total" id="confirmTotal"></div>
    <div style="font-size:.68rem;color:var(--muted);">Prices are estimates. Actual prices may vary.</div>
    <div class="confirm-btns">
      <button class="confirm-no" onclick="closeConfirm()">Cancel</button>
      <button class="confirm-yes" onclick="submitOrder()">Confirm → Find on Google</button>
    </div>
  </div>
</div>

<div class="toast-wrap" id="toastWrap"></div>

<!-- Hidden form to POST order to MedicineServlet -->
<form id="orderForm" action="MedicineServlet" method="post" style="display:none;">
  <input type="hidden" name="action"       value="placeOrder"/>
  <input type="hidden" name="medicineName" id="orderMedName"/>
  <input type="hidden" name="quantity"     id="orderQty"/>
  <input type="hidden" name="totalPrice"   id="orderTotal"/>
  <input type="hidden" name="orderDetails" id="orderDetails"/>
</form>

<script>
/* ============================================================
   SwasthyaBuddy — OpenFDA Medicine Search
   Full India ↔ FDA name mapping
   ============================================================ */

/* ── COMPREHENSIVE INDIA → FDA GENERIC NAME MAPPING ─────── */
/* Key: any part of an Indian search term (lowercase)
   Value: FDA generic name to use in the OpenFDA query        */
var INDIA_TO_FDA = {
  // Paracetamol group
  'paracetamol':    'acetaminophen',
  'crocin':         'acetaminophen',
  'calpol':         'acetaminophen',
  'dolo':           'acetaminophen',
  'fepanil':        'acetaminophen',
  'metacin':        'acetaminophen',
  'pyrigesic':      'acetaminophen',
  'pacimol':        'acetaminophen',

  // Ibuprofen group
  'brufen':         'ibuprofen',
  'combiflam':      'ibuprofen',
  'ibugesic':       'ibuprofen',
  'ibuclin':        'ibuprofen',
  'advil':          'ibuprofen',

  // Aspirin group
  'disprin':        'aspirin',
  'ecosprin':       'aspirin',
  'loprin':         'aspirin',

  // Antibiotics
  'augmentin':      'amoxicillin',
  'mox':            'amoxicillin',
  'novamox':        'amoxicillin',
  'zithromax':      'azithromycin',
  'azee':           'azithromycin',
  'azifast':        'azithromycin',
  'ciprobay':       'ciprofloxacin',
  'ciplox':         'ciprofloxacin',
  'taxim':          'cefixime',
  'zifi':           'cefixime',
  'zocef':          'cefixime',
  'levoflox':       'levofloxacin',
  'tavanic':        'levofloxacin',

  // Antihistamines
  'cetzine':        'cetirizine',
  'zyrtec':         'cetirizine',
  'alerid':         'cetirizine',
  'ctd':            'cetirizine',
  'montair':        'montelukast',
  'singulair':      'montelukast',

  // Antacids / GI
  'omez':           'omeprazole',
  'ocid':           'omeprazole',
  'prilosec':       'omeprazole',
  'pan':            'pantoprazole',
  'pantocid':       'pantoprazole',
  'nexpro':         'esomeprazole',
  'nexium':         'esomeprazole',
  'razo':           'rabeprazole',
  'rablet':         'rabeprazole',
  'gelusil':        'antacid',
  'digene':         'antacid',
  'eno':            'antacid',
  'domperidone':    'domperidone',
  'domstal':        'domperidone',
  'vomistop':       'domperidone',
  'ondansetron':    'ondansetron',
  'emeset':         'ondansetron',

  // Diabetes
  'glycomet':       'metformin',
  'glucophage':     'metformin',
  'januvia':        'sitagliptin',
  'galvus':         'vildagliptin',
  'glimepiride':    'glimepiride',
  'amaryl':         'glimepiride',

  // BP / Heart
  'telma':          'telmisartan',
  'telmikind':      'telmisartan',
  'amlip':          'amlodipine',
  'amlopin':        'amlodipine',
  'norvasc':        'amlodipine',
  'atenolol':       'atenolol',
  'tenormin':       'atenolol',
  'losartan':       'losartan',
  'losar':          'losartan',
  'cozaar':         'losartan',
  'ramipril':       'ramipril',
  'cardace':        'ramipril',
  'atorvastatin':   'atorvastatin',
  'atorlip':        'atorvastatin',
  'lipitor':        'atorvastatin',
  'clopidogrel':    'clopidogrel',
  'clopitab':       'clopidogrel',
  'plavix':         'clopidogrel',

  // Respiratory
  'asthalin':       'salbutamol',
  'salbutamol':     'albuterol',
  'ventolin':       'albuterol',
  'foracort':       'budesonide',
  'budecort':       'budesonide',
  'seroflo':        'fluticasone',
  'flutivate':      'fluticasone',
  'montek':         'montelukast',
  'levocet':        'levocetirizine',
  'xyzal':          'levocetirizine',

  // Pain / NSAID
  'voveran':        'diclofenac',
  'voltaren':       'diclofenac',
  'diclofenac':     'diclofenac',
  'nimesulide':     'nimesulide',
  'nise':           'nimesulide',
  'meftal':         'mefenamic acid',
  'naproxen':       'naproxen',
  'naprosyn':       'naproxen',

  // Vitamins / Supplements
  'becosules':      'vitamin b complex',
  'neurobion':      'vitamin b12',
  'zincovit':       'multivitamin',
  'supradyn':       'multivitamin',
  'limcee':         'ascorbic acid',
  'celin':          'ascorbic acid',
  'shelcal':        'calcium carbonate',
  'calcirol':       'cholecalciferol',

  // Thyroid
  'thyroxine':      'levothyroxine',
  'thyronorm':      'levothyroxine',
  'eltroxin':       'levothyroxine',

  // Steroids / Anti-inflammatory
  'betnesol':       'betamethasone',
  'wysolone':       'prednisolone',
  'medrol':         'methylprednisolone',
  'dexa':           'dexamethasone',
  'decadron':       'dexamethasone',

  // Sleep / Anxiety
  'alprazolam':     'alprazolam',
  'alprax':         'alprazolam',
  'clonazepam':     'clonazepam',
  'rivotril':       'clonazepam',
  'zolpidem':       'zolpidem',
  'nitrest':        'zolpidem',

  // Antifungal
  'fluconazole':    'fluconazole',
  'flucos':         'fluconazole',
  'forcan':         'fluconazole',

  // Misc
  'lactulose':      'lactulose',
  'cremaffin':      'liquid paraffin',
  'dulcolax':       'bisacodyl',
  'bisacodyl':      'bisacodyl',
};

/* ── FDA GENERIC → INDIAN BRAND NAMES (for display) ─────── */
var FDA_TO_INDIA_BRANDS = {
  'acetaminophen':    ['Crocin', 'Dolo 650', 'Calpol', 'Fepanil', 'Pacimol'],
  'ibuprofen':        ['Brufen', 'Combiflam', 'Ibugesic', 'Advil'],
  'aspirin':          ['Disprin', 'Ecosprin', 'Loprin'],
  'amoxicillin':      ['Augmentin', 'Mox', 'Novamox', 'Amoxil'],
  'azithromycin':     ['Azee', 'Azifast', 'Zithromax', 'Azicip'],
  'ciprofloxacin':    ['Ciplox', 'Ciprobay', 'Cifran'],
  'cefixime':         ['Taxim-O', 'Zifi', 'Zocef'],
  'levofloxacin':     ['Levoflox', 'Tavanic', 'Levomac'],
  'cetirizine':       ['Cetzine', 'Alerid', 'Zyrtec'],
  'levocetirizine':   ['Levocet', 'Xyzal', 'Levorid'],
  'montelukast':      ['Montair', 'Singulair', 'Montek'],
  'omeprazole':       ['Omez', 'Ocid', 'Prilosec'],
  'pantoprazole':     ['Pan', 'Pantocid', 'Pantop'],
  'esomeprazole':     ['Nexpro', 'Nexium', 'Sompraz'],
  'rabeprazole':      ['Razo', 'Rablet', 'Rabeloc'],
  'ondansetron':      ['Emeset', 'Ondem', 'Zofran'],
  'domperidone':      ['Domstal', 'Vomistop', 'Motilium'],
  'metformin':        ['Glycomet', 'Glucophage', 'Gluformin'],
  'glimepiride':      ['Amaryl', 'Glimisave', 'Glimpid'],
  'sitagliptin':      ['Januvia', 'Istavel'],
  'telmisartan':      ['Telma', 'Telmikind', 'Telsar'],
  'amlodipine':       ['Amlip', 'Amlopin', 'Norvasc', 'Stamlo'],
  'atenolol':         ['Tenormin', 'Aten', 'Betacard'],
  'losartan':         ['Losar', 'Cozaar', 'Repace'],
  'ramipril':         ['Cardace', 'Ramistar', 'Hopace'],
  'atorvastatin':     ['Atorlip', 'Lipitor', 'Storvas'],
  'clopidogrel':      ['Clopitab', 'Plavix', 'Deplatt'],
  'albuterol':        ['Asthalin', 'Ventolin', 'Salbutamol'],
  'salbutamol':       ['Asthalin', 'Ventolin'],
  'budesonide':       ['Budecort', 'Foracort'],
  'fluticasone':      ['Seroflo', 'Flutivate', 'Flovent'],
  'diclofenac':       ['Voveran', 'Voltaren', 'Diclomol'],
  'mefenamic acid':   ['Meftal', 'Ponstan'],
  'naproxen':         ['Naprosyn', 'Flanax'],
  'levothyroxine':    ['Thyronorm', 'Eltroxin', 'Thyrox'],
  'prednisolone':     ['Wysolone', 'Omnacortil'],
  'methylprednisolone':['Medrol', 'Solu-Medrol'],
  'dexamethasone':    ['Decadron', 'Dexona'],
  'betamethasone':    ['Betnesol', 'Diprosone'],
  'alprazolam':       ['Alprax', 'Restyl', 'Tranax'],
  'clonazepam':       ['Rivotril', 'Clonapax'],
  'zolpidem':         ['Nitrest', 'Zolfresh'],
  'fluconazole':      ['Forcan', 'Flucos', 'Diflucan'],
  'bisacodyl':        ['Dulcolax', 'Bicolax'],
  'lactulose':        ['Duphalac', 'Cremolac'],
  'ascorbic acid':    ['Limcee', 'Celin'],
  'calcium carbonate':['Shelcal', 'Calcitas'],
  'cholecalciferol':  ['Calcirol', 'D-Rise'],
  'vitamin b complex':['Becosules', 'Neurobion'],
  'multivitamin':     ['Supradyn', 'Zincovit', 'Revital'],
};

var currentResults = [];
var cart = {};
var cartOpen = false;

/* ── UTILS ─────────────────────────────────────────────── */
function first(arr) {
  if (Array.isArray(arr) && arr.length > 0) return arr[0];
  return (typeof arr === 'string') ? arr : '';
}
function trunc(s, n) {
  if (!s) return '';
  s = String(s);
  return s.length > n ? s.slice(0, n) + '...' : s;
}
function estimatePrice(name) {
  var s = (name || 'x').toLowerCase();
  var h = 0;
  for (var i = 0; i < s.length; i++) { h = Math.imul(h, 31) + s.charCodeAt(i) | 0; }
  return 10 + (Math.abs(h) % 490);
}
function iconForRoute(route) {
  if (!route) return '💊';
  var r = String(route).toLowerCase();
  if (r.indexOf('ophthalmic') >= 0 || r.indexOf('eye') >= 0) return '👁️';
  if (r.indexOf('inject') >= 0 || r.indexOf('intravenous') >= 0) return '💉';
  if (r.indexOf('topical') >= 0 || r.indexOf('skin') >= 0) return '🧴';
  if (r.indexOf('inhal') >= 0 || r.indexOf('nasal') >= 0) return '💨';
  return '💊';
}
function esc(s) {
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

/* ── NAME RESOLUTION ──────────────────────────────────── */
/* Given user input, return the FDA-friendly search term */
function resolveToFDA(input) {
  var lower = input.trim().toLowerCase();
  // Check each key in the mapping — support partial matches
  for (var key in INDIA_TO_FDA) {
    if (lower.indexOf(key) >= 0) {
      return INDIA_TO_FDA[key];
    }
  }
  return lower; // already a known name, or pass through
}

/* Given an FDA generic name, return Indian brand names as a string */
function getIndiaBrands(genericName) {
  if (!genericName) return '';
  var lower = genericName.toLowerCase().trim();
  // Try direct match
  if (FDA_TO_INDIA_BRANDS[lower]) {
    return FDA_TO_INDIA_BRANDS[lower].slice(0, 3).join(' / ');
  }
  // Try partial match (for compound generics)
  for (var key in FDA_TO_INDIA_BRANDS) {
    if (lower.indexOf(key) >= 0 || key.indexOf(lower) >= 0) {
      return FDA_TO_INDIA_BRANDS[key].slice(0, 3).join(' / ');
    }
  }
  return '';
}

/* Given the user's original query, find Indian brands for display */
function getIndiaBrandsFromQuery(fdaGeneric, originalQuery) {
  var brands = getIndiaBrands(fdaGeneric);
  if (brands) return brands;
  // Also try the user's original input in case it itself is a brand
  var lower = originalQuery.toLowerCase();
  for (var key in INDIA_TO_FDA) {
    if (lower.indexOf(key) >= 0) {
      return getIndiaBrands(INDIA_TO_FDA[key]);
    }
  }
  return '';
}

/* ── SEARCH ─────────────────────────────────────────────── */
var _lastQuery = '';

function doSearch() {
  var raw = document.getElementById('medSearch').value.trim();
  if (!raw) { showToast('Please enter a medicine name', true); return; }

  _lastQuery = raw;
  var fdaTerm = resolveToFDA(raw);
  showLoading();

  var btn = document.getElementById('searchBtn');
  btn.disabled = true;
  btn.textContent = 'Searching...';

  var enc = encodeURIComponent(fdaTerm);
  var url = 'https://api.fda.gov/drug/label.json?search=openfda.brand_name:' + enc
          + '+openfda.generic_name:' + enc + '&limit=20';

  fetch(url)
    .then(function(res) {
      if (res.status === 404) return {results:[]};
      if (!res.ok) throw new Error('HTTP ' + res.status);
      return res.json();
    })
    .then(function(data) {
      renderResults(data.results || [], raw, fdaTerm);
    })
    .catch(function() {
      // Fallback: full-text search
      var fallback = 'https://api.fda.gov/drug/label.json?search=' + enc + '&limit=20';
      fetch(fallback)
        .then(function(r2) { return r2.ok ? r2.json() : {results:[]}; })
        .then(function(d2) { renderResults(d2.results || [], raw, fdaTerm); })
        .catch(function() { showError('FDA API unavailable — please try again shortly.'); });
    })
    .finally(function() {
      btn.disabled = false;
      btn.textContent = 'Search FDA';
    });
}

function quickSearch(term) {
  document.getElementById('medSearch').value = term;
  doSearch();
}

/* ── RENDER ─────────────────────────────────────────────── */
function renderResults(results, originalQuery, fdaTerm) {
  currentResults = results;
  var grid = document.getElementById('medGrid');
  grid.innerHTML = '';

  /* Show what was searched and what FDA term was used */
  var mappingNote = (fdaTerm.toLowerCase() !== originalQuery.toLowerCase())
    ? ' <span style="color:var(--accent2);font-size:.62rem;">(searched FDA as &ldquo;' + esc(fdaTerm) + '&rdquo;)</span>'
    : '';

  document.getElementById('catMeta').innerHTML =
    '<span>' + (results.length > 0
      ? 'Found <strong style="color:var(--white)">' + results.length + '</strong> results for &ldquo;' + esc(originalQuery) + '&rdquo;' + mappingNote
      : 'No results for &ldquo;' + esc(originalQuery) + '&rdquo;' + mappingNote)
    + '</span><span class="meta-source">📡 api.fda.gov/drug/label.json</span>';

  if (results.length === 0) {
    grid.innerHTML =
      '<div class="state-wrap">'
      + '<div class="state-icon">🔍</div>'
      + '<div class="state-title">No results found</div>'
      + '<div class="state-sub">Try the generic name directly, e.g. &ldquo;acetaminophen&rdquo; for Crocin/Dolo, '
      + '&ldquo;ibuprofen&rdquo; for Combiflam/Brufen, &ldquo;azithromycin&rdquo; for Azee.</div>'
      + '</div>';
    return;
  }

  results.forEach(function(item, i) {
    var openfda   = item.openfda || {};
    var brandName = first(openfda.brand_name)        || 'Unknown Brand';
    var genName   = first(openfda.generic_name)       || '';
    var mfrName   = first(openfda.manufacturer_name)  || '';
    var route     = first(openfda.route)              || '';
    var rxOtc     = first(openfda.product_type)       || 'OTC';
    var isRx      = String(rxOtc).toLowerCase().indexOf('prescription') >= 0;
    var purpose   = first(item.purpose) || first(item.indications_and_usage) || 'See label for details.';
    var price     = estimatePrice(brandName || genName);
    var icon      = iconForRoute(route);
    var inCart    = !!cart[i];

    /* Indian brand names for this drug */
    var indiaBrands = getIndiaBrandsFromQuery(genName, originalQuery);

    var div = document.createElement('div');
    div.className = 'med-card';
    div.style.animationDelay = (i * 0.04) + 's';
    div.innerHTML =
      '<div class="med-top">'
      + '<div class="med-icon">' + icon + '</div>'
      + '<span class="' + (isRx ? 'rx-badge' : 'otc-badge') + '">' + (isRx ? 'Rx' : 'OTC') + '</span>'
      + '</div>'
      + '<div>'
      + '<div class="med-name">' + esc(trunc(brandName, 40)) + '</div>'
      /* Indian brands shown prominently below the FDA brand name */
      + (indiaBrands ? '<div class="med-india-brand">🇮🇳 ' + esc(indiaBrands) + '</div>' : '')
      + (genName ? '<div class="med-generic">' + esc(trunc(genName, 50)) + '</div>' : '')
      + '<div class="med-desc">' + esc(trunc(purpose, 110)) + '</div>'
      + '</div>'
      + '<div class="med-tags">'
      + (route   ? '<span class="med-tag">📍 ' + esc(trunc(route,20))   + '</span>' : '')
      + (mfrName ? '<span class="med-tag">🏭 ' + esc(trunc(mfrName,22)) + '</span>' : '')
      + '</div>'
      + '<div class="med-price-row">'
      + '<div class="med-price">₹' + price + ' <span style="font-size:.55rem;color:var(--muted)">est.</span></div>'
      + '<span class="in-stock">✓ Available</span>'
      + '</div>'
      + '<div class="qty-row">'
      + '<button class="qty-btn" onclick="chQty(' + i + ',-1)">−</button>'
      + '<span class="qty-val" id="qv-' + i + '">1</span>'
      + '<button class="qty-btn" onclick="chQty(' + i + ',1)">+</button>'
      + '<button class="btn-add' + (inCart ? ' added' : '') + '" id="ab-' + i + '" onclick="addCart(' + i + ')">'
      + (inCart ? '✓ Added' : '+ Add') + '</button>'
      + '</div>'
      + '<button class="btn-label" onclick="showDetail(' + i + ')">📋 View Full Label</button>'
      + '<button class="btn-buy-online" onclick="buyOnline(\''
        + esc(brandName) + '\', \'' + esc(genName) + '\', \'' + esc(indiaBrands) + '\')">🏥 Buy on Apollo</button>';
    grid.appendChild(div);
  });
}

function showLoading() {
  document.getElementById('medGrid').innerHTML =
    '<div class="state-wrap"><div class="spinner"></div>'
    + '<div class="state-title">Searching FDA database...</div>'
    + '<div class="state-sub">Fetching real-time data from OpenFDA</div></div>';
  document.getElementById('catMeta').innerHTML =
    '<span>Searching...</span><span class="meta-source">📡 api.fda.gov/drug/label.json</span>';
}
function showError(msg) {
  document.getElementById('medGrid').innerHTML =
    '<div class="state-wrap"><div class="state-icon">⚠️</div>'
    + '<div class="state-title">Search failed</div>'
    + '<div class="state-sub">' + esc(msg) + '</div></div>';
}

/* ── DETAIL MODAL ────────────────────────────────────────── */
function showDetail(idx) {
  var item = currentResults[idx];
  if (!item) return;
  var openfda = item.openfda || {};
  var brand   = first(openfda.brand_name)        || 'Unknown';
  var gen     = first(openfda.generic_name)       || 'N/A';
  var mfr     = first(openfda.manufacturer_name)  || 'N/A';
  var route   = first(openfda.route)              || 'N/A';
  var rxOtc   = first(openfda.product_type)       || 'N/A';
  var isRx    = String(rxOtc).toLowerCase().indexOf('prescription') >= 0;
  var ndc     = (openfda.product_ndc || []).slice(0,4).join(', ') || 'N/A';
  var indiaBrands = getIndiaBrandsFromQuery(gen, _lastQuery);

  var purpose  = first(item.purpose)                   || '';
  var usage    = first(item.indications_and_usage)      || '';
  var warnings = first(item.warnings) || first(item.warnings_and_cautions) || '';
  var dosage   = first(item.dosage_and_administration)  || '';
  var inactive = first(item.inactive_ingredient)        || '';
  var storage  = first(item.storage_and_handling)       || '';
  var adverse  = first(item.adverse_reactions)          || '';

  var html =
    '<div class="modal-header">'
    + '<div><div class="med-name" style="font-size:1rem;">' + esc(brand) + '</div>'
    + (indiaBrands ? '<div class="med-india-brand" style="margin-top:4px;">🇮🇳 ' + esc(indiaBrands) + '</div>' : '')
    + '<div class="med-generic" style="margin-top:4px;">' + esc(gen) + '</div></div>'
    + '<button class="modal-close" onclick="closeModal()">✕</button>'
    + '</div>'
    + '<div style="display:flex;gap:8px;flex-wrap:wrap;">'
    + '<span class="' + (isRx ? 'rx-badge' : 'otc-badge') + '" style="font-size:.7rem;padding:3px 8px;">' + esc(rxOtc) + '</span>'
    + (route !== 'N/A' ? '<span class="med-tag">📍 ' + esc(route) + '</span>' : '')
    + (mfr  !== 'N/A' ? '<span class="med-tag">🏭 ' + esc(trunc(mfr,32)) + '</span>' : '')
    + '</div>';

  if (purpose || usage) {
    html += '<div class="modal-section"><div class="modal-lbl">Purpose / Indications</div>'
          + '<div class="modal-val">' + esc(trunc(purpose || usage, 600)) + '</div></div>';
  }
  if (dosage) {
    html += '<div class="modal-section"><div class="modal-lbl">Dosage &amp; Administration</div>'
          + '<div class="modal-val">' + esc(trunc(dosage, 600)) + '</div></div>';
  }
  if (warnings) {
    html += '<div class="modal-section"><div class="modal-lbl">⚠ Warnings</div>'
          + '<div class="warn-box">' + esc(trunc(warnings, 600)) + '</div></div>';
  }
  if (adverse) {
    html += '<div class="modal-section"><div class="modal-lbl">Adverse Reactions</div>'
          + '<div class="modal-val" style="font-size:.75rem;">' + esc(trunc(adverse, 400)) + '</div></div>';
  }
  if (inactive) {
    html += '<div class="modal-section"><div class="modal-lbl">Inactive Ingredients</div>'
          + '<div class="modal-val" style="font-size:.72rem;color:var(--muted);">' + esc(trunc(inactive, 300)) + '</div></div>';
  }
  if (storage) {
    html += '<div class="modal-section"><div class="modal-lbl">Storage &amp; Handling</div>'
          + '<div class="modal-val">' + esc(trunc(storage, 200)) + '</div></div>';
  }
  html += '<div class="modal-section"><div class="modal-lbl">NDC Code(s)</div>'
        + '<div class="modal-val" style="font-family:monospace;font-size:.75rem;color:var(--accent2);">' + esc(ndc) + '</div></div>'
        + '<div class="fda-note">Data from U.S. FDA OpenFDA API · For informational purposes only · '
        + 'Always consult a licensed healthcare professional before taking any medication.</div>';

  document.getElementById('modalContent').innerHTML = html;
  document.getElementById('detailModal').style.display = 'flex';
}
function closeModal() { document.getElementById('detailModal').style.display = 'none'; }
function handleModalClick(e) { if (e.target.id === 'detailModal') closeModal(); }

/* ── CART ────────────────────────────────────────────────── */
function chQty(idx, delta) {
  var el = document.getElementById('qv-' + idx);
  if (!el) return;
  var v = Math.max(1, parseInt(el.textContent || '1') + delta);
  el.textContent = v;
  if (cart[idx]) { cart[idx].qty = v; updateCart(); }
}

function addCart(idx) {
  var item = currentResults[idx];
  if (!item) return;
  var openfda = item.openfda || {};
  var fdaName  = first(openfda.brand_name) || first(openfda.generic_name) || 'Medicine';
  var genName  = first(openfda.generic_name) || '';
  var indiaBrands = getIndiaBrandsFromQuery(genName, _lastQuery);
  /* Display name: prefer Indian brand if found, else FDA name */
  var displayName = indiaBrands ? indiaBrands.split(' / ')[0] + ' (' + fdaName + ')' : fdaName;

  var price = estimatePrice(fdaName);
  var qtyEl = document.getElementById('qv-' + idx);
  var qty   = qtyEl ? (parseInt(qtyEl.textContent) || 1) : 1;
  var icon  = iconForRoute(first(openfda.route));

  cart[idx] = {
    idx: idx,
    fdaName: fdaName,
    indiaBrands: indiaBrands,
    displayName: displayName,
    price: price,
    qty: qty,
    icon: icon
  };
  var btn = document.getElementById('ab-' + idx);
  if (btn) { btn.textContent = '✓ Added'; btn.classList.add('added'); }
  updateCart();
  showToast('Added: ' + trunc(displayName, 30));
  if (!cartOpen) toggleCart();
}

function removeCart(idx) {
  delete cart[idx];
  var btn = document.getElementById('ab-' + idx);
  if (btn) { btn.textContent = '+ Add'; btn.classList.remove('added'); }
  updateCart();
  showToast('Item removed from cart');
}

function updateCart() {
  var items = Object.values(cart);
  var total = items.reduce(function(s,i){ return s + i.price * i.qty; }, 0);
  var count = items.reduce(function(s,i){ return s + i.qty; }, 0);
  document.getElementById('cartCount').textContent = count;
  document.getElementById('cartTotal').textContent = '₹' + total.toFixed(2);
  document.getElementById('checkoutBtn').disabled = items.length === 0;
  document.getElementById('buyCartBtn').disabled  = items.length === 0;

  var container = document.getElementById('cartItems');
  if (items.length === 0) {
    container.innerHTML = '<div class="cart-empty"><div class="ei">🛒</div><p>Cart is empty</p></div>';
    return;
  }
  container.innerHTML = '';
  items.forEach(function(item) {
    var d = document.createElement('div');
    d.className = 'cart-item';
    d.innerHTML =
      '<div class="ci-icon">' + item.icon + '</div>'
      + '<div style="flex:1;min-width:0;">'
      + '<div class="ci-name">' + esc(trunc(item.fdaName, 26)) + '</div>'
      + (item.indiaBrands ? '<div class="ci-india">🇮🇳 ' + esc(trunc(item.indiaBrands, 28)) + '</div>' : '')
      + '<div class="ci-price">₹' + item.price + ' × ' + item.qty + ' = ₹' + (item.price * item.qty).toFixed(2) + '</div>'
      + '</div>'
      + '<button class="ci-remove" onclick="removeCart(' + item.idx + ')" title="Remove">🗑</button>';
    container.appendChild(d);
  });
}

/* ── ORDER (Place Order → MedicineServlet DB) ──────────── */
function showConfirm() {
  var items = Object.values(cart);
  if (items.length === 0) return;
  var total = items.reduce(function(s,i){ return s + i.price * i.qty; }, 0);

  var html = items.map(function(item) {
    return '• ' + esc(item.displayName) + ' × ' + item.qty + ' = ₹' + (item.price * item.qty).toFixed(2);
  }).join('<br/>');
  document.getElementById('confirmItems').innerHTML = html;
  document.getElementById('confirmTotal').textContent = 'Total: ₹' + total.toFixed(2);
  document.getElementById('confirmModal').style.display = 'flex';
}

function closeConfirm() {
  document.getElementById('confirmModal').style.display = 'none';
}

function submitOrder() {
  var items = Object.values(cart);
  if (items.length === 0) return;

  var total    = items.reduce(function(s,i){ return s + i.price * i.qty; }, 0);
  var totalQty = items.reduce(function(s,i){ return s + i.qty; }, 0);
  var namesStr = items.map(function(i){ return i.displayName + ' x' + i.qty; }).join(', ');
  var details  = JSON.stringify(items.map(function(i){
    return { name: i.fdaName, indiaBrands: i.indiaBrands, qty: i.qty, price: i.price };
  }));

  /* Save to DB silently in background via fetch */
  var formData = new FormData();
  formData.append('action',       'placeOrder');
  formData.append('medicineName', namesStr);
  formData.append('quantity',     totalQty);
  formData.append('totalPrice',   total.toFixed(2));
  formData.append('orderDetails', details);
  fetch('MedicineServlet', { method: 'POST', body: formData }).catch(function(){});

  closeConfirm();

  /* Build PharmEasy search query from Indian brand names (best match for India) */
  var searchQuery = getBestPharmEasyQuery(items);
  /* Google Shopping — never blocks, shows 1mg + Netmeds + Apollo all at once */
  var shopUrl = 'https://www.google.com/search?q=' + encodeURIComponent(searchQuery + ' buy online india medicine') + '&tbm=shop';

  showToast('Opening pharmacy search...');
  setTimeout(function(){ window.open(shopUrl, '_blank'); }, 500);
}

/* Pick the best Indian name for PharmEasy search.
   For multiple items, open separate tabs for each. */
function getBestPharmEasyQuery(items) {
  /* Use first item's Indian brand if available, else generic */
  var item = items[0];
  var q = '';
  if (item.indiaBrands) {
    q = item.indiaBrands.split(' / ')[0];
  } else {
    q = item.fdaName;
  }
  /* FDA→India last-resort fixes */
  q = q.toLowerCase();
  if (q === 'acetaminophen') q = 'paracetamol';
  if (q === 'albuterol')     q = 'salbutamol';
  if (q === 'ascorbic acid') q = 'vitamin c';
  /* Strip junk */
  q = q.replace(/\s*(extra strength|tablet|capsule|oral|solution|mg)\s*/gi,' ').trim();
  /* If multiple items, open extra tabs for the rest */
  if (items.length > 1) {
    items.slice(1).forEach(function(it) {
      var extra = it.indiaBrands ? it.indiaBrands.split(' / ')[0] : it.fdaName;
      extra = extra.toLowerCase()
        .replace('acetaminophen','paracetamol')
        .replace('albuterol','salbutamol')
        .replace(/\s*(extra strength|tablet|capsule|oral|mg)\s*/gi,' ').trim();
      var extraUrl = 'https://www.google.com/search?q=' + encodeURIComponent(extra + ' buy online india medicine') + '&tbm=shop';
      setTimeout(function(){ window.open(extraUrl, '_blank'); }, 800);
    });
  }
  return q;
}

/* ── BUY ON 1MG ─────────────────────────────────────────── */
/* Single card: Buy on 1mg uses the best Indian name */
function buyOnline(fdaBrand, fdaGeneric, indiaBrands) {
  var query = '';
  /* Priority: Indian brand > FDA generic > FDA brand */
  if (indiaBrands) {
    query = indiaBrands.split(' / ')[0]; // use first Indian brand
  } else if (fdaGeneric && fdaGeneric !== 'N/A') {
    /* Map FDA generic back to Indian name */
    var mapped = getIndiaBrands(fdaGeneric);
    query = mapped ? mapped.split(' / ')[0] : fdaGeneric;
    /* Last-resort: convert acetaminophen → paracetamol for 1mg */
    if (query.toLowerCase() === 'acetaminophen') query = 'paracetamol';
    if (query.toLowerCase() === 'albuterol')     query = 'salbutamol';
    if (query.toLowerCase() === 'ascorbic acid') query = 'vitamin c';
  } else {
    query = fdaBrand;
  }
  /* Strip dosage junk */
  query = query.replace(/\s*(extra strength|tablet|capsule|oral|solution|mg|daytime|nighttime)\s*/gi, ' ').trim();

  window.open('https://www.apollopharmacy.in/search-medicines/' + encodeURIComponent(query), '_blank');
}

function buyCartOn1mg() {
  var items = Object.values(cart);
  if (items.length === 0) return;
  var item = items[0];
  var query = item.indiaBrands ? item.indiaBrands.split(' / ')[0] : item.fdaName;
  query = query.toLowerCase()
    .replace('acetaminophen','paracetamol')
    .replace('albuterol','salbutamol')
    .replace(/\s*(extra strength|tablet|capsule|oral|mg)\s*/gi,' ').trim();
  window.open('https://www.apollopharmacy.in/search-medicines/' + encodeURIComponent(query), '_blank');
}

function toggleCart() {
  cartOpen = !cartOpen;
  document.getElementById('cartPanel').classList.toggle('collapsed', !cartOpen);
}

function showToast(msg, isError) {
  var w = document.getElementById('toastWrap');
  var t = document.createElement('div');
  t.className = 'toast-item';
  t.innerHTML = '<span style="color:' + (isError ? '#ff6b6b' : 'var(--accent2)') + ';">'
              + (isError ? '⚠' : '✓') + '</span> ' + esc(msg);
  w.appendChild(t);
  setTimeout(function(){ if(t.parentNode) t.parentNode.removeChild(t); }, 3100);
}
</script>
</body>
</html>
