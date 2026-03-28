<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  Object userObj = session.getAttribute("user");
  if (userObj == null) { response.sendRedirect("login.jsp"); return; }
  com.swasthyabuddy.model.User user = (com.swasthyabuddy.model.User) userObj;
  String userName = user.getFirstName();
  String userRole = user.getRole();
  String dashboard = "DOCTOR".equalsIgnoreCase(userRole) ? "doctor-dashboard.jsp" : "patient-dashboard.jsp";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SwasthyaBuddy — Find Clinics</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
  <style>
    :root{--bg:#060b18;--surface:#0d1528;--surf2:#111e38;--accent:#3b82f6;--teal:#06b6d4;--emerald:#10b981;--rose:#f43f5e;--amber:#f59e0b;--white:#f8fafc;--muted:#64748b;--muted2:#94a3b8;--border:rgba(148,163,184,0.08);--border2:rgba(148,163,184,0.14);}
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
    .topbar{display:flex;align-items:center;justify-content:space-between;padding:14px 24px;border-bottom:1px solid var(--border);background:rgba(6,11,24,0.85);backdrop-filter:blur(20px);flex-shrink:0;gap:14px;}
    .tb-left .tb-title{font-family:'Outfit',sans-serif;font-size:1rem;font-weight:700;}
    .tb-left .tb-sub{font-size:0.7rem;color:var(--muted);margin-top:1px;}
    .loc-pill{display:flex;align-items:center;gap:6px;padding:5px 14px;border-radius:20px;font-size:0.7rem;font-weight:600;transition:all 0.3s;}
    .loc-pill.detecting{background:rgba(245,158,11,0.08);border:1px solid rgba(245,158,11,0.25);color:var(--amber);}
    .loc-pill.found{background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.25);color:var(--emerald);}
    .loc-pill.error{background:rgba(244,63,94,0.08);border:1px solid rgba(244,63,94,0.25);color:var(--rose);}
    .loc-dot{width:6px;height:6px;border-radius:50%;flex-shrink:0;}
    .detecting .loc-dot{background:var(--amber);animation:blink 1s infinite;}
    .found .loc-dot{background:var(--emerald);}
    .error .loc-dot{background:var(--rose);}
    @keyframes blink{0%,100%{opacity:1}50%{opacity:0.3}}
    .map-body{flex:1;display:flex;overflow:hidden;}
    .left-panel{width:340px;flex-shrink:0;display:flex;flex-direction:column;border-right:1px solid var(--border);overflow:hidden;background:var(--surface);}
    .search-section{padding:16px;border-bottom:1px solid var(--border);flex-shrink:0;}
    .search-row{display:flex;gap:8px;margin-bottom:12px;}
    .search-input{flex:1;background:rgba(255,255,255,0.04);border:1px solid rgba(148,163,184,0.12);border-radius:10px;color:var(--white);padding:10px 14px;font-size:0.84rem;font-family:'Plus Jakarta Sans',sans-serif;outline:none;transition:all 0.2s;}
    .search-input::placeholder{color:#1e2d45;}
    .search-input:focus{border-color:var(--accent);background:rgba(59,130,246,0.04);box-shadow:0 0 0 3px rgba(59,130,246,0.1);}
    .btn-search{padding:10px 16px;background:linear-gradient(135deg,var(--accent),#2563eb);border:none;border-radius:10px;color:white;font-size:13px;cursor:pointer;transition:all 0.2s;flex-shrink:0;}
    .btn-search:hover{transform:scale(1.04);box-shadow:0 4px 14px rgba(59,130,246,0.4);}
    .type-pills{display:flex;gap:6px;flex-wrap:wrap;}
    .type-pill{padding:5px 12px;border-radius:20px;font-size:0.7rem;border:1px solid var(--border);background:rgba(255,255,255,0.02);color:var(--muted2);cursor:pointer;transition:all 0.2s;font-family:'Plus Jakarta Sans',sans-serif;}
    .type-pill:hover{color:var(--white);border-color:rgba(59,130,246,0.4);}
    .type-pill.active{background:rgba(59,130,246,0.12);border-color:rgba(59,130,246,0.4);color:var(--white);}
    .results-meta{padding:8px 16px;font-size:0.69rem;color:var(--muted);border-bottom:1px solid var(--border);flex-shrink:0;}
    .places-list{flex:1;overflow-y:auto;padding:10px;display:flex;flex-direction:column;gap:8px;}
    .places-list::-webkit-scrollbar{width:3px;}
    .places-list::-webkit-scrollbar-thumb{background:var(--border);border-radius:2px;}
    .list-state{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;gap:12px;color:var(--muted);text-align:center;padding:24px;}
    .list-state .si{font-size:2.8rem;opacity:0.3;}
    .list-state p{font-size:0.8rem;line-height:1.65;}
    .spinner{width:28px;height:28px;border:2px solid var(--border2);border-top-color:var(--accent);border-radius:50%;animation:spin 0.75s linear infinite;}
    @keyframes spin{to{transform:rotate(360deg)}}
    .place-card{background:rgba(255,255,255,0.025);border:1px solid var(--border2);border-radius:13px;padding:14px;cursor:pointer;transition:all 0.2s;animation:cardIn 0.3s ease;}
    @keyframes cardIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
    .place-card:hover{border-color:rgba(59,130,246,0.3);background:rgba(59,130,246,0.04);transform:translateX(3px);}
    .place-card.selected{border-color:rgba(59,130,246,0.5);background:rgba(59,130,246,0.07);}
    .pc-top{display:flex;align-items:flex-start;gap:10px;margin-bottom:8px;}
    .pc-icon{width:36px;height:36px;border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0;}
    .ic-hospital{background:rgba(244,63,94,0.12);border:1px solid rgba(244,63,94,0.2);}
    .ic-pharmacy{background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.2);}
    .ic-clinic{background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.2);}
    .pc-name{font-family:'Outfit',sans-serif;font-size:0.86rem;font-weight:600;color:var(--white);line-height:1.3;flex:1;}
    .pc-dist{font-size:0.65rem;color:var(--teal);white-space:nowrap;font-weight:600;}
    .pc-addr{font-size:0.7rem;color:var(--muted);margin-bottom:10px;line-height:1.55;}
    .pc-open{font-size:0.65rem;color:var(--emerald);margin-bottom:10px;}
    .pc-actions{display:flex;gap:6px;}
    .btn-pc{flex:1;padding:6px;border-radius:8px;font-size:0.68rem;font-family:'Plus Jakarta Sans',sans-serif;cursor:pointer;transition:all 0.2s;text-align:center;text-decoration:none;border:none;display:inline-block;}
    .btn-dir{background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.25)!important;color:var(--accent);}
    .btn-dir:hover{background:rgba(59,130,246,0.2);color:var(--accent);}
    .btn-show{background:rgba(255,255,255,0.04);border:1px solid var(--border2)!important;color:var(--muted2);}
    .btn-show:hover{color:var(--white);}
    .map-col{flex:1;position:relative;}
    #map{width:100%;height:100%;}
    .leaflet-popup-content-wrapper{background:#0d1528!important;border:1px solid rgba(59,130,246,0.3)!important;border-radius:14px!important;color:var(--white)!important;box-shadow:0 16px 48px rgba(0,0,0,0.6)!important;font-family:'Plus Jakarta Sans',sans-serif!important;}
    .leaflet-popup-tip{background:#0d1528!important;}
    .leaflet-popup-content{margin:14px 16px!important;}
    .pop-name{font-family:'Outfit',sans-serif;font-size:0.9rem;font-weight:700;color:var(--white);margin-bottom:4px;}
    .pop-type{font-size:0.63rem;padding:2px 8px;border-radius:6px;display:inline-block;margin-bottom:7px;text-transform:uppercase;}
    .pop-type.hospital{background:rgba(244,63,94,0.12);border:1px solid rgba(244,63,94,0.3);color:var(--rose);}
    .pop-type.pharmacy{background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.3);color:var(--emerald);}
    .pop-type.clinic{background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.3);color:var(--accent);}
    .pop-addr{font-size:0.73rem;color:var(--muted2);margin-bottom:7px;line-height:1.5;}
    .pop-open{font-size:0.68rem;color:var(--emerald);margin-bottom:8px;}
    .pop-link{display:block;padding:7px;background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.25);border-radius:8px;color:var(--accent);text-align:center;font-size:0.72rem;text-decoration:none;transition:all 0.2s;}
    .pop-link:hover{background:rgba(59,130,246,0.2);color:var(--white);}
    .map-overlay{position:absolute;top:14px;right:14px;display:flex;flex-direction:column;gap:7px;z-index:10;}
    .map-btn{padding:7px 14px;background:rgba(6,11,24,0.9);border:1px solid var(--border2);border-radius:9px;color:var(--muted2);font-size:0.72rem;font-family:'Plus Jakarta Sans',sans-serif;cursor:pointer;backdrop-filter:blur(12px);transition:all 0.2s;}
    .map-btn:hover{color:var(--white);border-color:rgba(59,130,246,0.4);}
    .map-btn.on{background:rgba(59,130,246,0.15);border-color:rgba(59,130,246,0.4);color:var(--white);}
    .leaflet-control-attribution{background:rgba(6,11,24,0.85)!important;color:var(--muted)!important;font-size:9px!important;}
    .leaflet-control-attribution a{color:var(--accent)!important;}
    @media(max-width:900px){.sidebar{display:none;}.left-panel{width:100%;max-height:42vh;border-right:none;border-bottom:1px solid var(--border);}.map-body{flex-direction:column;}}
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-header"><div class="sb-brand"><div class="sb-logo">🩺</div><div class="sb-title">Swasthya<em>Buddy</em></div></div></div>
  <div class="sb-sec">Menu</div>
  <a href="<%= dashboard %>" class="nl"><span class="ni"><%= "DOCTOR".equalsIgnoreCase(userRole) ? "🔔" : "💬" %></span><%= "DOCTOR".equalsIgnoreCase(userRole) ? "Live Alerts" : "Symptom Check" %></a>
  <% if (!"DOCTOR".equalsIgnoreCase(userRole)) { %>
  <a href="result.jsp"     class="nl"><span class="ni">📊</span>My Results</a>
  <a href="HistoryServlet" class="nl"><span class="ni">🕐</span>History</a>
  <% } %>
  <a href="maps.jsp"       class="nl active"><span class="ni">🗺️</span>Find Clinics</a>
  <a href="medicines.jsp"  class="nl"><span class="ni">💊</span>Medicines<span class="nb">New</span></a>
  <div class="sb-sec">Account</div>
  <a href="profile.jsp"    class="nl"><span class="ni">👤</span>My Profile</a>
  <div class="sb-footer"><div class="uc"><div class="uc-av"><%= userName.charAt(0) %></div><div><div class="uc-name"><%= userName %></div><div class="uc-role"><%= userRole %></div></div><a href="AuthServlet?action=logout" class="uc-out">⏻</a></div></div>
</aside>
<div class="main">
  <div class="topbar">
    <div class="tb-left"><div class="tb-title">Find Nearby Clinics</div><div class="tb-sub">Free · OpenStreetMap · No API key needed</div></div>
    <div class="loc-pill detecting" id="locPill"><div class="loc-dot"></div><span id="locText">Detecting location...</span></div>
  </div>
  <div class="map-body">
    <div class="left-panel">
      <div class="search-section">
        <div class="search-row">
          <input type="text" class="search-input" id="searchInput" placeholder="Search city, area..." onkeydown="if(event.key==='Enter')searchByCity()"/>
          <button class="btn-search" onclick="searchByCity()">🔍</button>
        </div>
        <div class="type-pills">
          <button class="type-pill active" onclick="setType('all',this)">All</button>
          <button class="type-pill" onclick="setType('clinic',this)">🏥 Clinic</button>
          <button class="type-pill" onclick="setType('pharmacy',this)">💊 Pharmacy</button>
          <button class="type-pill" onclick="setType('hospital',this)">🚑 Hospital</button>
        </div>
      </div>
      <div class="results-meta" id="resultsMeta">Waiting for location...</div>
      <div class="places-list" id="placesList"><div class="list-state"><div class="spinner"></div><p>Detecting your location...</p></div></div>
    </div>
    <div class="map-col">
      <div id="map"></div>
      <div class="map-overlay">
        <button class="map-btn on" id="btnClinic"   onclick="toggleLayer('clinic')">🏥 Clinics</button>
        <button class="map-btn on" id="btnPharmacy" onclick="toggleLayer('pharmacy')">💊 Pharmacy</button>
        <button class="map-btn on" id="btnHospital" onclick="toggleLayer('hospital')">🚑 Hospital</button>
        <button class="map-btn"   onclick="recenter()">📍 My Location</button>
      </div>
    </div>
  </div>
</div>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
var map,userMarker,userLat=17.3850,userLng=78.4867;
var allPlaces=[],markers=[],activeType='all',hiddenLayers={};
function initMap(lat,lng){
  if(map){map.remove();map=null;}
  map=L.map('map',{zoomControl:true}).setView([lat,lng],14);
  L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',{attribution:'© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> © <a href="https://carto.com">CARTO</a>',subdomains:'abcd',maxZoom:19}).addTo(map);
  var ui=L.divIcon({html:'<div style="width:14px;height:14px;background:#3b82f6;border:3px solid white;border-radius:50%;box-shadow:0 0 14px rgba(59,130,246,0.7);"></div>',iconSize:[14,14],iconAnchor:[7,7],className:''});
  userMarker=L.marker([lat,lng],{icon:ui}).addTo(map).bindPopup('<div class="pop-name">📍 You are here</div>');
  L.circle([lat,lng],{radius:350,color:'#3b82f6',fillColor:'#3b82f6',fillOpacity:0.05,weight:1,opacity:0.2}).addTo(map);
  searchNearby(lat,lng);
}
function getLocation(){
  if(!navigator.geolocation){useDefault();return;}
  navigator.geolocation.getCurrentPosition(
    function(pos){userLat=pos.coords.latitude;userLng=pos.coords.longitude;setLocPill('found','Location found ✓');initMap(userLat,userLng);},
    function(){useDefault();},{timeout:9000,maximumAge:60000}
  );
}
function useDefault(){setLocPill('error','Default: Hyderabad');initMap(userLat,userLng);}
function searchNearby(lat,lng){
  showLoading('Finding nearby medical places...');
  var r=5000,q='[out:json][timeout:25];(node["amenity"="hospital"](around:'+r+','+lat+','+lng+');node["amenity"="clinic"](around:'+r+','+lat+','+lng+');node["amenity"="pharmacy"](around:'+r+','+lat+','+lng+');node["amenity"="doctors"](around:'+r+','+lat+','+lng+');node["healthcare"](around:'+r+','+lat+','+lng+'););out body;';
  fetch('https://overpass-api.de/api/interpreter?data='+encodeURIComponent(q))
    .then(function(r){return r.json();})
    .then(function(data){processResults(data.elements,lat,lng);})
    .catch(function(){loadDemoData(lat,lng);});
}
function processResults(elements,lat,lng){
  allPlaces=[];clearMarkers();
  elements.forEach(function(el){
    if(!el.tags||!el.lat)return;
    var name=el.tags.name||el.tags['name:en']||'Medical Center';
    var amenity=el.tags.amenity||el.tags.healthcare||'';
    var street=el.tags['addr:street']||'',city=el.tags['addr:city']||'';
    var addr=(street&&city)?street+', '+city:(el.tags['addr:full']||'Near your location');
    var type=amenity==='hospital'?'hospital':amenity==='pharmacy'?'pharmacy':'clinic';
    allPlaces.push({id:el.id,name:name,type:type,address:addr,opening:el.tags.opening_hours||'',lat:el.lat,lng:el.lon,dist:haversine(lat,lng,el.lat,el.lon).toFixed(1)});
  });
  allPlaces.sort(function(a,b){return parseFloat(a.dist)-parseFloat(b.dist);});
  allPlaces=allPlaces.slice(0,40);
  if(allPlaces.length===0){loadDemoData(lat,lng);return;}
  renderList(allPlaces);addMarkers(allPlaces);
  document.getElementById('resultsMeta').textContent=allPlaces.length+' medical places found within 5 km';
}
function renderList(places){
  var list=document.getElementById('placesList');list.innerHTML='';
  var filtered=activeType==='all'?places:places.filter(function(p){return p.type===activeType;});
  if(filtered.length===0){list.innerHTML='<div class="list-state"><div class="si">🔍</div><p>No '+activeType+'s found nearby.</p></div>';return;}
  filtered.forEach(function(p,i){
    var cls='ic-'+p.type,icon=p.type==='hospital'?'🏥':p.type==='pharmacy'?'💊':'🏥';
    var dir='https://www.openstreetmap.org/directions?from='+userLat+','+userLng+'&to='+p.lat+','+p.lng;
    var card=document.createElement('div');
    card.className='place-card';card.id='pc-'+p.id;card.style.animationDelay=(i*0.04)+'s';
    card.innerHTML='<div class="pc-top"><div class="pc-icon '+cls+'">'+icon+'</div><div class="pc-name">'+p.name+'</div><div class="pc-dist">📍 '+p.dist+' km</div></div>'
      +'<div class="pc-addr">'+p.address+'</div>'
      +(p.opening?'<div class="pc-open">🕐 '+p.opening+'</div>':'')
      +'<div class="pc-actions"><a class="btn-pc btn-dir" href="'+dir+'" target="_blank">🗺 Directions</a><button class="btn-pc btn-show" onclick="focusPlace('+p.id+')">📍 Show</button></div>';
    card.addEventListener('click',function(e){if(e.target.tagName==='A'||e.target.tagName==='BUTTON')return;focusPlace(p.id);});
    list.appendChild(card);
  });
}
function addMarkers(places){
  clearMarkers();
  places.forEach(function(p){
    var color=p.type==='hospital'?'#f43f5e':p.type==='pharmacy'?'#10b981':'#3b82f6';
    var icon=L.divIcon({html:'<div style="width:11px;height:11px;background:'+color+';border:2px solid white;border-radius:50%;box-shadow:0 2px 6px rgba(0,0,0,0.5);"></div>',iconSize:[11,11],iconAnchor:[5,5],className:''});
    var dir='https://www.openstreetmap.org/directions?from='+userLat+','+userLng+'&to='+p.lat+','+p.lng;
    var m=L.marker([p.lat,p.lng],{icon:icon}).addTo(map)
      .bindPopup('<div class="pop-name">'+p.name+'</div><span class="pop-type '+p.type+'">'+p.type.toUpperCase()+'</span><div class="pop-addr">'+p.address+'</div>'+(p.opening?'<div class="pop-open">🕐 '+p.opening+'</div>':'')+'<a class="pop-link" href="'+dir+'" target="_blank">🗺 Get Directions</a>');
    m._placeId=p.id;m._type=p.type;markers.push(m);
    m.on('click',function(){highlightCard(p.id);});
  });
}
function searchByCity(){
  var q=document.getElementById('searchInput').value.trim();if(!q)return;
  showLoading('Searching "'+q+'"...');
  fetch('https://nominatim.openstreetmap.org/search?q='+encodeURIComponent(q)+'&format=json&limit=1')
    .then(function(r){return r.json();})
    .then(function(data){
      if(data&&data.length>0){userLat=parseFloat(data[0].lat);userLng=parseFloat(data[0].lon);map.flyTo([userLat,userLng],14,{duration:1.2});searchNearby(userLat,userLng);}
      else showError('"'+q+'" not found.');
    }).catch(function(){showError('Search failed.');});
}
function focusPlace(id){
  var place=allPlaces.find(function(p){return p.id===id;});
  var marker=markers.find(function(m){return m._placeId===id;});
  if(!place||!marker)return;
  map.flyTo([place.lat,place.lng],17,{duration:1});marker.openPopup();highlightCard(id);
}
function highlightCard(id){
  document.querySelectorAll('.place-card').forEach(function(c){c.classList.remove('selected');});
  var c=document.getElementById('pc-'+id);if(c){c.classList.add('selected');c.scrollIntoView({behavior:'smooth',block:'nearest'});}
}
function setType(type,btn){activeType=type;document.querySelectorAll('.type-pill').forEach(function(b){b.classList.remove('active');});btn.classList.add('active');renderList(allPlaces);}
function toggleLayer(type){hiddenLayers[type]=!hiddenLayers[type];var btn=document.getElementById('btn'+type.charAt(0).toUpperCase()+type.slice(1));btn.classList.toggle('on',!hiddenLayers[type]);markers.forEach(function(m){if(m._type===type)m.setOpacity(hiddenLayers[type]?0:1);});}
function recenter(){if(map)map.flyTo([userLat,userLng],14,{duration:1});}
function clearMarkers(){markers.forEach(function(m){if(map)map.removeLayer(m);});markers=[];}
function haversine(lat1,lng1,lat2,lng2){var R=6371,dL=(lat2-lat1)*Math.PI/180,dN=(lng2-lng1)*Math.PI/180;return R*2*Math.atan2(Math.sqrt(Math.sin(dL/2)*Math.sin(dL/2)+Math.cos(lat1*Math.PI/180)*Math.cos(lat2*Math.PI/180)*Math.sin(dN/2)*Math.sin(dN/2)),Math.sqrt(1-(Math.sin(dL/2)*Math.sin(dL/2)+Math.cos(lat1*Math.PI/180)*Math.cos(lat2*Math.PI/180)*Math.sin(dN/2)*Math.sin(dN/2))));}
function setLocPill(type,text){var el=document.getElementById('locPill');el.className='loc-pill '+type;document.getElementById('locText').textContent=text;}
function showLoading(msg){document.getElementById('placesList').innerHTML='<div class="list-state"><div class="spinner"></div><p>'+msg+'</p></div>';}
function showError(msg){document.getElementById('placesList').innerHTML='<div class="list-state"><div class="si">⚠️</div><p>'+msg+'</p></div>';document.getElementById('resultsMeta').textContent='No results';}
function loadDemoData(lat,lng){
  var demo=[{name:'City General Hospital',type:'hospital',offset:[0.010,0.008]},{name:'LifeCare Clinic',type:'clinic',offset:[-0.005,0.012]},{name:'MediPlus Pharmacy',type:'pharmacy',offset:[0.007,-0.003]},{name:'Apollo Family Clinic',type:'clinic',offset:[-0.009,-0.006]},{name:'Wellness Pharmacy',type:'pharmacy',offset:[0.003,0.015]},{name:'District Hospital',type:'hospital',offset:[-0.012,0.001]},{name:'Sun Healthcare',type:'clinic',offset:[0.006,0.009]},{name:'MedStore Pharmacy',type:'pharmacy',offset:[-0.004,-0.011]}];
  allPlaces=demo.map(function(d,i){return{id:9000+i,name:d.name,type:d.type,address:'Near your location',opening:'9:00 AM – 9:00 PM',lat:lat+d.offset[0],lng:lng+d.offset[1],dist:(Math.random()*3+0.3).toFixed(1)};});
  renderList(allPlaces);addMarkers(allPlaces);
  document.getElementById('resultsMeta').textContent='Demo data — real data loads with internet';
}
window.addEventListener('load',function(){setTimeout(getLocation,100);});
</script>
</body>
</html>
