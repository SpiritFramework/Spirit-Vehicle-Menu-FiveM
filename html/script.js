let currentConfig = {};
let currentData = {};
let currentCategory = null;

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'toggle':
            handleToggle(data);
            break;
        case 'updateMenu':
            handleUpdateMenu(data);
            break;
        case 'notification':
            showNotification(data.message, data.notificationType);
            break;
    }
});

function handleToggle(data) {
    const app = document.getElementById('app');
    
    if (data.display) {
        currentConfig = data.config;
        currentData = data.data;
        
        applyConfig(currentConfig);
        
        app.classList.add('active');
        
        if (data.menu === 'main') {
            renderMainMenu(currentData);
        }
    } else {
        app.classList.remove('active');
    }
}

function handleUpdateMenu(data) {
    if (data.menu === 'category') {
        renderCategory(data.data);
    } else if (data.menu === 'main') {
        renderMainMenu(data.data);
    }
}

function applyConfig(config) {
    const root = document.documentElement;
    if (config.Style) {
        if (config.Style.accentColor) root.style.setProperty('--accent', config.Style.accentColor);
        if (config.Style.accentHover) root.style.setProperty('--accent-hover', config.Style.accentHover);
    }
    
    document.getElementById('serverName').textContent = config.ServerName || 'VEHICLE SPAWNER';
    
    if (config.ServerLogo) {
        document.getElementById('serverLogo').innerHTML = `<img src="${config.ServerLogo}" style="width:100%;height:100%;object-fit:cover;border-radius:12px;">`;
    }
    
    // Update position if needed
    const app = document.getElementById('app');
    if (config.Position) {
        app.style.left = config.Position.x + '%';
        app.style.top = config.Position.y + '%';
    }
}

function renderMainMenu(data) {
    document.getElementById('breadcrumb').textContent = 'Main Menu';
    document.getElementById('searchContainer').style.display = 'none';
    document.getElementById('itemCount').textContent = data.categories.length + ' categories';
    
    const content = document.getElementById('menuContent');
    content.innerHTML = '<div class="category-grid"></div>';
    const grid = content.querySelector('.category-grid');
    
    data.categories.forEach((cat, index) => {
        const card = document.createElement('div');
        card.className = 'category-card';
        card.style.setProperty('--category-color', cat.color);
        
        card.innerHTML = `
            <div class="category-icon" style="background: ${cat.color}20; color: ${cat.color};">
                ${cat.icon}
            </div>
            <div class="category-info">
                <div class="category-name">${cat.label}</div>
                <div class="category-count">${cat.count} vehicles</div>
            </div>
            <div class="category-arrow">→</div>
        `;
        
        card.onclick = () => selectCategory(cat.key);
        grid.appendChild(card);
    });
}

function renderCategory(data) {
    currentCategory = data;
    document.getElementById('breadcrumb').textContent = data.categoryName;
    document.getElementById('searchContainer').style.display = 'block';
    document.getElementById('itemCount').textContent = data.vehicles.length + ' vehicles';
    document.getElementById('searchInput').value = '';
    
    const content = document.getElementById('menuContent');
    content.innerHTML = `
        <button class="back-btn" onclick="goBack()">
            ← Back to Categories
        </button>
        <div class="vehicle-list" id="vehicleList"></div>
    `;
    
    renderVehicleList(data.vehicles);
}

function renderVehicleList(vehicles) {
    const list = document.getElementById('vehicleList');
    list.innerHTML = '';
    
    if (vehicles.length === 0) {
        list.innerHTML = `
            <div class="empty-state">
                <div style="font-size: 48px; margin-bottom: 10px;">🔍</div>
                <div>No vehicles found</div>
            </div>
        `;
        return;
    }
    
    vehicles.forEach((veh) => {
        const item = document.createElement('div');
        item.className = 'vehicle-item';
        item.dataset.name = veh.name.toLowerCase();
        item.dataset.label = veh.label.toLowerCase();
        
        item.innerHTML = `
            <div class="vehicle-icon">🚗</div>
            <div class="vehicle-details">
                <div class="vehicle-name">${veh.label}</div>
                <div class="vehicle-desc">${veh.desc || 'No description'}</div>
            </div>
            <button class="spawn-btn" onclick="event.stopPropagation(); spawnVehicle('${veh.name}', '${veh.label}')">SPAWN</button>
        `;
        
        item.onclick = () => spawnVehicle(veh.name, veh.label);
        
        list.appendChild(item);
    });
}

function filterVehicles() {
    const search = document.getElementById('searchInput').value.toLowerCase();
    const items = document.querySelectorAll('.vehicle-item');
    
    items.forEach(item => {
        const name = item.dataset.name;
        const label = item.dataset.label;
        const match = name.includes(search) || label.includes(search);
        item.style.display = match ? 'flex' : 'none';
    });
    
    const visible = Array.from(items).filter(i => i.style.display !== 'none').length;
    document.getElementById('itemCount').textContent = visible + ' vehicles';
}

function selectCategory(key) {
    fetch(`https://${GetParentResourceName()}/selectCategory`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ category: key })
    });
}

function spawnVehicle(model, label) {
    fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ model: model, label: label })
    });
}

function goBack() {
    fetch(`https://${GetParentResourceName()}/goBack`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function closeMenu() {
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function showNotification(message, type = 'info') {
    const container = document.getElementById('notificationContainer');
    const notif = document.createElement('div');
    notif.className = `notification ${type}`;
    
    const icon = type === 'success' ? '✓' : type === 'error' ? '✕' : 'ℹ';
    notif.innerHTML = `<span style="font-size: 20px;">${icon}</span> ${message}`;
    
    container.appendChild(notif);
    
    setTimeout(() => notif.classList.add('show'), 10);
    setTimeout(() => {
        notif.classList.remove('show');
        setTimeout(() => notif.remove(), 300);
    }, 3000);
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeMenu();
    }
});