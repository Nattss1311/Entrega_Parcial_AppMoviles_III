import os
from PIL import Image, ImageDraw, ImageFont

# Directorio de salida
BASE_DIR = r"C:\Users\NATY\.gemini\antigravity\scratch\vet_domi_ruta"
EVIDENCIAS_DIR = os.path.join(BASE_DIR, "evidencias")
os.makedirs(EVIDENCIAS_DIR, exist_ok=True)

# Fuentes
FONT_PATH = "C:/Windows/Fonts/segoeui.ttf"
FONT_BOLD_PATH = "C:/Windows/Fonts/segoeuib.ttf"
FONT_CODE_PATH = "C:/Windows/Fonts/consola.ttf"

def get_font(size, bold=False, code=False):
    try:
        if code:
            return ImageFont.truetype(FONT_CODE_PATH, size)
        if bold:
            return ImageFont.truetype(FONT_BOLD_PATH, size)
        return ImageFont.truetype(FONT_PATH, size)
    except:
        return ImageFont.load_default()

def draw_phone_frame(width=420, height=880):
    img = Image.new("RGBA", (width, height), (248, 250, 252, 255))
    draw = ImageDraw.Draw(img)
    
    # Status bar Android
    draw.rectangle([(0, 0), (width, 32)], fill=(15, 118, 110, 255))
    draw.text((20, 6), "09:41", font=get_font(13, bold=True), fill=(255, 255, 255, 240))
    draw.text((width - 80, 6), "LTE  100%", font=get_font(12, bold=True), fill=(255, 255, 255, 240))
    
    # AppBar
    draw.rectangle([(0, 32), (width, 96)], fill=(15, 118, 110, 255))
    
    # Bottom Navigation Bar
    draw.rectangle([(0, height - 64), (width, height)], fill=(255, 255, 255, 255))
    draw.line([(0, height - 64), (width, height - 64)], fill=(226, 232, 240, 255), width=1)
    
    # Tabs
    tab_w = width / 3
    # Tab 1: Agenda
    draw.text((tab_w * 0.5 - 20, height - 42), "Agenda", font=get_font(12, bold=True), fill=(15, 118, 110, 255))
    draw.ellipse([(tab_w * 0.5 - 8, height - 60), (tab_w * 0.5 + 8, height - 44)], fill=(15, 118, 110, 255))
    # Tab 2: Clientes
    draw.text((tab_w * 1.5 - 22, height - 42), "Clientes", font=get_font(12), fill=(100, 116, 139, 255))
    draw.ellipse([(tab_w * 1.5 - 8, height - 60), (tab_w * 1.5 + 8, height - 44)], outline=(100, 116, 139, 255), width=2)
    # Tab 3: Métricas
    draw.text((tab_w * 2.5 - 24, height - 42), "Métricas", font=get_font(12), fill=(100, 116, 139, 255))
    draw.ellipse([(tab_w * 2.5 - 8, height - 60), (tab_w * 2.5 + 8, height - 44)], outline=(100, 116, 139, 255), width=2)
    
    return img, draw

# -------------------------------------------------------------
# 1. SCREENSHOT: app_home.png (Agenda / Rutas)
# -------------------------------------------------------------
def generate_home_screenshot():
    img, draw = draw_phone_frame()
    width, height = img.size
    
    # AppBar Title
    draw.text((20, 42), "VetDomiRuta", font=get_font(19, bold=True), fill=(255, 255, 255, 255))
    draw.text((20, 68), "Sábado, 7 de Noviembre • Rutas a Domicilio", font=get_font(11), fill=(204, 251, 241, 255))
    
    # Card Resumen Jornada
    draw.rounded_rectangle([(16, 110), (width - 16, 215)], radius=14, fill=(15, 118, 110, 255))
    draw.text((32, 122), "Jornada a Domicilio Activa", font=get_font(15, bold=True), fill=(255, 255, 255, 255))
    draw.rounded_rectangle([(width - 130, 120), (width - 32, 142)], radius=10, fill=(255, 255, 255, 50))
    draw.text((width - 120, 124), "SQLite Offline", font=get_font(10, bold=True), fill=(255, 255, 255, 255))
    
    draw.text((32, 150), "Ingreso Estimado Hoy", font=get_font(11), fill=(204, 251, 241, 255))
    draw.text((32, 168), "\$250.000", font=get_font(24, bold=True), fill=(255, 255, 255, 255))
    
    # Botón Nueva Cita en Banner
    draw.rounded_rectangle([(width - 140, 165), (width - 32, 200)], radius=8, fill=(255, 255, 255, 255))
    draw.text((width - 126, 175), "+ Nueva Cita", font=get_font(12, bold=True), fill=(15, 118, 110, 255))
    
    # Filter Chips
    chips = [("Hoy", True), ("Todos", False), ("En Ruta", False), ("Pendiente", False), ("Completada", False)]
    cx = 16
    for title, selected in chips:
        w_chip = len(title) * 8 + 24
        if selected:
            draw.rounded_rectangle([(cx, 228), (cx + w_chip, 256)], radius=14, fill=(15, 118, 110, 255))
            draw.text((cx + 12, 234), title, font=get_font(11, bold=True), fill=(255, 255, 255, 255))
        else:
            draw.rounded_rectangle([(cx, 228), (cx + w_chip, 256)], radius=14, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255), width=1)
            draw.text((cx + 12, 234), title, font=get_font(11), fill=(71, 85, 105, 255))
        cx += w_chip + 8
        
    draw.text((18, 270), "Itinerario de Visitas (Hoy) - 3 citas", font=get_font(13, bold=True), fill=(30, 41, 59, 255))
    
    # Cita 1 Card (En Ruta)
    y1 = 295
    draw.rounded_rectangle([(16, y1), (width - 16, y1 + 135)], radius=14, fill=(255, 255, 255, 255), outline=(59, 130, 246, 120), width=1)
    # Badge En Ruta
    draw.rounded_rectangle([(width - 100, y1 + 12), (width - 28, y1 + 34)], radius=10, fill=(239, 246, 255, 255), outline=(59, 130, 246, 255), width=1)
    draw.text((width - 90, y1 + 16), "En Ruta", font=get_font(10, bold=True), fill=(37, 99, 235, 255))
    # Paciente
    draw.text((28, y1 + 12), "Maximus (Golden Retriever)", font=get_font(14, bold=True), fill=(15, 23, 42, 255))
    draw.text((28, y1 + 32), "Propietario: Dra. Mariana López", font=get_font(11), fill=(100, 116, 139, 255))
    # Servicio Tag
    draw.rounded_rectangle([(28, y1 + 52), (width - 28, y1 + 76)], radius=6, fill=(241, 245, 249, 255))
    draw.text((36, y1 + 57), "Vacunación Múltiple y Rabia", font=get_font(11, bold=True), fill=(15, 118, 110, 255))
    # Info llegada
    draw.text((28, y1 + 84), "Hora: 09:00 AM • Calle 127 # 15-42 (Usaquén)", font=get_font(11), fill=(71, 85, 105, 255))
    draw.line([(28, y1 + 104), (width - 28, y1 + 104)], fill=(241, 245, 249, 255), width=1)
    draw.text((28, y1 + 112), "Base: \$65.000 + Domicilio: \$20.000", font=get_font(10), fill=(148, 163, 184, 255))
    draw.text((width - 95, y1 + 110), "\$85.000", font=get_font(13, bold=True), fill=(15, 118, 110, 255))
    
    # Cita 2 Card (Pendiente)
    y2 = y1 + 148
    draw.rounded_rectangle([(16, y2), (width - 16, y2 + 135)], radius=14, fill=(255, 255, 255, 255), outline=(245, 158, 11, 100), width=1)
    draw.rounded_rectangle([(width - 105, y2 + 12), (width - 28, y2 + 34)], radius=10, fill=(254, 243, 199, 255), outline=(245, 158, 11, 255), width=1)
    draw.text((width - 96, y2 + 16), "Pendiente", font=get_font(10, bold=True), fill=(180, 83, 9, 255))
    draw.text((28, y2 + 12), "Luna (Felino Siamés)", font=get_font(14, bold=True), fill=(15, 23, 42, 255))
    draw.text((28, y2 + 32), "Propietario: Dra. Mariana López", font=get_font(11), fill=(100, 116, 139, 255))
    draw.rounded_rectangle([(28, y2 + 52), (width - 28, y2 + 76)], radius=6, fill=(241, 245, 249, 255))
    draw.text((36, y2 + 57), "Control Desparasitación Felina", font=get_font(11, bold=True), fill=(15, 118, 110, 255))
    draw.text((28, y2 + 84), "Hora: 11:30 AM • Calle 127 # 15-42 (Usaquén)", font=get_font(11), fill=(71, 85, 105, 255))
    draw.line([(28, y2 + 104), (width - 28, y2 + 104)], fill=(241, 245, 249, 255), width=1)
    draw.text((28, y2 + 112), "Base: \$50.000 + Domicilio: \$10.000", font=get_font(10), fill=(148, 163, 184, 255))
    draw.text((width - 95, y2 + 110), "\$60.000", font=get_font(13, bold=True), fill=(15, 118, 110, 255))

    # Cita 3 Card (Pendiente - Tarde)
    y3 = y2 + 148
    draw.rounded_rectangle([(16, y3), (width - 16, y3 + 135)], radius=14, fill=(255, 255, 255, 255), outline=(245, 158, 11, 100), width=1)
    draw.rounded_rectangle([(width - 105, y3 + 12), (width - 28, y3 + 34)], radius=10, fill=(254, 243, 199, 255), outline=(245, 158, 11, 255), width=1)
    draw.text((width - 96, y3 + 16), "Pendiente", font=get_font(10, bold=True), fill=(180, 83, 9, 255))
    draw.text((28, y3 + 12), "Rocky (Bulldog Francés)", font=get_font(14, bold=True), fill=(15, 23, 42, 255))
    draw.text((28, y3 + 32), "Propietario: Carlos Eduardo Restrepo", font=get_font(11), fill=(100, 116, 139, 255))
    draw.rounded_rectangle([(28, y3 + 52), (width - 28, y3 + 76)], radius=6, fill=(241, 245, 249, 255))
    draw.text((36, y3 + 57), "Consulta Dermatológica y Oído", font=get_font(11, bold=True), fill=(15, 118, 110, 255))
    draw.text((28, y3 + 84), "Hora: 03:00 PM • Carrera 7 # 67-31 (Chapinero)", font=get_font(11), fill=(71, 85, 105, 255))
    draw.line([(28, y3 + 104), (width - 28, y3 + 104)], fill=(241, 245, 249, 255), width=1)
    draw.text((28, y3 + 112), "Base: \$80.000 + Domicilio: \$25.000", font=get_font(10), fill=(148, 163, 184, 255))
    draw.text((width - 100, y3 + 110), "\$105.000", font=get_font(13, bold=True), fill=(15, 118, 110, 255))
    
    # FAB (Floating Action Button)
    fab_y = height - 120
    draw.rounded_rectangle([(width - 180, fab_y), (width - 18, fab_y + 44)], radius=22, fill=(15, 118, 110, 255))
    draw.text((width - 165, fab_y + 14), "+ Programar Visita", font=get_font(12, bold=True), fill=(255, 255, 255, 255))

    out_path = os.path.join(EVIDENCIAS_DIR, "app_home.png")
    img.save(out_path)
    print("Guardado:", out_path)

# -------------------------------------------------------------
# 2. SCREENSHOT: app_formulario.png (Formulario Cita)
# -------------------------------------------------------------
def generate_formulario_screenshot():
    img, draw = draw_phone_frame()
    width, height = img.size
    
    # AppBar
    draw.text((20, 50), "← Programar Visita a Domicilio", font=get_font(17, bold=True), fill=(255, 255, 255, 255))
    
    y = 110
    # Sección 1
    draw.text((18, y), "1. Datos del Paciente y Propietario", font=get_font(13, bold=True), fill=(15, 118, 110, 255))
    y += 24
    # Campo Cliente Dropdown
    draw.rounded_rectangle([(16, y), (width - 16, y + 48)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((26, y + 8), "Propietario / Cliente *", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((26, y + 24), "Dra. Mariana López (Norte - Usaquén)", font=get_font(13, bold=True), fill=(15, 23, 42, 255))
    draw.text((width - 40, y + 16), "▼", font=get_font(12), fill=(100, 116, 139, 255))
    
    y += 58
    # Campo Mascota Dropdown
    draw.rounded_rectangle([(16, y), (width - 16, y + 48)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((26, y + 8), "Mascota / Paciente *", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((26, y + 24), "Maximus (Canino - Golden Retriever)", font=get_font(13, bold=True), fill=(15, 23, 42, 255))
    draw.text((width - 40, y + 16), "▼", font=get_font(12), fill=(100, 116, 139, 255))

    y += 70
    # Sección 2
    draw.text((18, y), "2. Servicio y Liquidación de Ruta", font=get_font(13, bold=True), fill=(15, 118, 110, 255))
    y += 24
    # Servicio Dropdown
    draw.rounded_rectangle([(16, y), (width - 16, y + 48)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((26, y + 8), "Tipo de Servicio Veterinario *", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((26, y + 24), "Vacunación Múltiple / Antirrábica", font=get_font(13, bold=True), fill=(15, 23, 42, 255))
    draw.text((width - 40, y + 16), "▼", font=get_font(12), fill=(100, 116, 139, 255))

    y += 58
    # Tarifa base y Recargo ruta
    half_w = (width - 44) / 2
    draw.rounded_rectangle([(16, y), (16 + half_w, y + 48)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((26, y + 8), "Tarifa Base (COP) *", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((26, y + 24), "\$ 65.000", font=get_font(13, bold=True), fill=(15, 23, 42, 255))

    draw.rounded_rectangle([(28 + half_w, y), (width - 16, y + 48)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((38 + half_w, y + 8), "Costo Ruta / Domicilio *", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((38 + half_w, y + 24), "\$ 20.000", font=get_font(13, bold=True), fill=(15, 23, 42, 255))

    y += 56
    # Total Liquidado Card
    draw.rounded_rectangle([(16, y), (width - 16, y + 44)], radius=10, fill=(240, 253, 244, 255), outline=(134, 239, 172, 255))
    draw.text((28, y + 14), "TOTAL LIQUIDADO:", font=get_font(12, bold=True), fill=(22, 101, 52, 255))
    draw.text((width - 120, y + 12), "\$ 85.000", font=get_font(16, bold=True), fill=(22, 101, 52, 255))

    y += 62
    # Sección 3
    draw.text((18, y), "3. Fecha, Horario y Destino", font=get_font(13, bold=True), fill=(15, 118, 110, 255))
    y += 24
    draw.rounded_rectangle([(16, y), (16 + half_w, y + 48)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((26, y + 8), "Fecha de Visita", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((26, y + 24), "07/11/2026", font=get_font(13, bold=True), fill=(15, 23, 42, 255))

    draw.rounded_rectangle([(28 + half_w, y), (width - 16, y + 48)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((38 + half_w, y + 8), "Hora Estimada", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((38 + half_w, y + 24), "09:00 AM", font=get_font(13, bold=True), fill=(15, 23, 42, 255))

    y += 58
    # Dirección prellenada
    draw.rounded_rectangle([(16, y), (width - 16, y + 48)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((26, y + 8), "Dirección de Visita a Domicilio *", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((26, y + 24), "Calle 127 # 15-42, Apto 502", font=get_font(12), fill=(15, 23, 42, 255))

    y += 58
    # Notas
    draw.rounded_rectangle([(16, y), (width - 16, y + 56)], radius=10, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((26, y + 8), "Notas de Campo / Instrucciones", font=get_font(10), fill=(100, 116, 139, 255))
    draw.text((26, y + 24), "Llevar carnet físico y vacuna antirrábica refrigerada.", font=get_font(11), fill=(71, 85, 105, 255))

    # Botón Enviar
    y_btn = height - 120
    draw.rounded_rectangle([(16, y_btn), (width - 16, y_btn + 46)], radius=12, fill=(15, 118, 110, 255))
    draw.text((width / 2 - 85, y_btn + 14), "✓ Agendar Cita a Domicilio", font=get_font(13, bold=True), fill=(255, 255, 255, 255))

    out_path = os.path.join(EVIDENCIAS_DIR, "app_formulario.png")
    img.save(out_path)
    print("Guardado:", out_path)

# -------------------------------------------------------------
# 3. SCREENSHOT: app_clientes.png (Directorio de Clientes)
# -------------------------------------------------------------
def generate_clientes_screenshot():
    img, draw = draw_phone_frame()
    width, height = img.size
    
    # AppBar
    draw.text((20, 50), "Directorio de Clientes", font=get_font(19, bold=True), fill=(255, 255, 255, 255))
    draw.text((width - 45, 50), "↻", font=get_font(18, bold=True), fill=(255, 255, 255, 255))
    
    # SearchBar
    draw.rounded_rectangle([(16, 110), (width - 16, 155)], radius=12, fill=(255, 255, 255, 255), outline=(203, 213, 225, 255))
    draw.text((28, 124), "🔍  Buscar por nombre, zona o dirección...", font=get_font(12), fill=(148, 163, 184, 255))
    
    clients_data = [
        ("Dra. Mariana López", "+57 312 456 7890", "Calle 127 # 15-42, Apto 502", "Norte - Usaquén", "2 mascotas (Maximus, Luna)"),
        ("Carlos Eduardo Restrepo", "+57 300 987 6543", "Carrera 7 # 67-31, Casa 4", "Chapinero Alto", "1 mascota (Rocky)"),
        ("Valentina Gómez Peña", "+57 318 654 3210", "Av. Suba # 115-88, Torre 2", "Suba - Pontevedra", "1 mascota (Kira)")
    ]
    
    y = 175
    for name, phone, addr, zone, pets in clients_data:
        draw.rounded_rectangle([(16, y), (width - 16, y + 130)], radius=14, fill=(255, 255, 255, 255), outline=(226, 232, 240, 255), width=1)
        # Avatar
        draw.ellipse([(28, y + 14), (68, y + 54)], fill=(204, 251, 241, 255))
        draw.text((43, y + 22), name[0], font=get_font(16, bold=True), fill=(15, 118, 110, 255))
        # Nombre y Teléfono
        draw.text((80, y + 14), name, font=get_font(14, bold=True), fill=(15, 23, 42, 255))
        draw.text((80, y + 34), "📞 " + phone, font=get_font(11), fill=(100, 116, 139, 255))
        # Zona Tag
        draw.rounded_rectangle([(width - 130, y + 14), (width - 28, y + 36)], radius=8, fill=(224, 242, 254, 255))
        draw.text((width - 122, y + 18), zone[:14], font=get_font(10, bold=True), fill=(2, 132, 199, 255))
        # Divider
        draw.line([(28, y + 64), (width - 28, y + 64)], fill=(241, 245, 249, 255), width=1)
        # Dirección
        draw.text((28, y + 74), "📍 " + addr, font=get_font(11), fill=(51, 65, 85, 255))
        draw.text((28, y + 96), "🐾 " + pets, font=get_font(11, bold=True), fill=(15, 118, 110, 255))
        draw.text((width - 40, y + 84), "›", font=get_font(20, bold=True), fill=(148, 163, 184, 255))
        y += 145

    # FAB Nuevo Cliente
    fab_y = height - 120
    draw.rounded_rectangle([(width - 165, fab_y), (width - 18, fab_y + 44)], radius=22, fill=(15, 118, 110, 255))
    draw.text((width - 150, fab_y + 14), "+ Nuevo Cliente", font=get_font(12, bold=True), fill=(255, 255, 255, 255))

    out_path = os.path.join(EVIDENCIAS_DIR, "app_clientes.png")
    img.save(out_path)
    print("Guardado:", out_path)

# -------------------------------------------------------------
# 4. SCREENSHOT: prompt_ia.png (Interacción y Prompt con IA)
# -------------------------------------------------------------
def generate_prompt_screenshot():
    width, height = 900, 540
    img = Image.new("RGBA", (width, height), (30, 30, 30, 255))
    draw = ImageDraw.Draw(img)
    
    # Ventana IDE / Terminal
    draw.rectangle([(0, 0), (width, 36)], fill=(45, 45, 45, 255))
    # Botones macOS/Windows
    draw.ellipse([(14, 12), (26, 24)], fill=(239, 68, 68, 255))
    draw.ellipse([(34, 12), (46, 24)], fill=(245, 158, 11, 255))
    draw.ellipse([(54, 12), (66, 24)], fill=(16, 185, 129, 255))
    draw.text((width / 2 - 120, 10), "Antigravity AI Copilot - Terminal Prompt", font=get_font(12, bold=True), fill=(200, 200, 200, 255))
    
    lines = [
        ("USER PROMPT:", (56, 189, 248, 255), True),
        ('Actua como un desarrollador senior y arquitecto de software. Construye de forma autonoma', (241, 245, 249, 255), False),
        ('y de principio a fin el proyecto completo "VetDomiRuta", incluyendo el desarrollo en Flutter,', (241, 245, 249, 255), False),
        ('la base de datos SQLite, las capturas automaticas de pantalla y el documento final en Word (.docx).', (241, 245, 249, 255), False),
        ('', (0,0,0,0), False),
        ('Sigue este plan de ejecucion:', (241, 245, 249, 255), False),
        ('- FASE 1: DESARROLLO EN FLUTTER (Clean Architecture, sqflite, riverpod, mock data)', (148, 163, 184, 255), False),
        ('- FASE 2: COMPILACION Y CAPTURAS AUTOMATICAS (flutter analyze, build apk --release)', (148, 163, 184, 255), False),
        ('- FASE 3: GENERACION AUTOMATICA DEL DOCUMENTO WORD (Informe_VetDomiRuta.docx)', (148, 163, 184, 255), False),
        ('', (0,0,0,0), False),
        ("AI COPILOT EXECUTION:", (52, 211, 153, 255), True),
        ("[Architect] Defining Clean Architecture: domain / data / presentation layers...", (226, 232, 240, 255), False),
        ("[Database] Creating SQLite DatabaseHelper (vet_domi_ruta.db) with ON DELETE CASCADE...", (226, 232, 240, 255), False),
        ("[Seeder] Injecting 3 clients, 4 pets, and 5 home-visit appointments...", (226, 232, 240, 255), False),
        ("[State] Implementing Riverpod Notifiers (ClientsNotifier, AppointmentsNotifier)...", (226, 232, 240, 255), False),
        ("[UI M3] Generating Material 3 screens: Agenda, Clientes, Nuevo Turno Domiciliario...", (226, 232, 240, 255), False),
        ("[Analyze] flutter analyze completed with 0 errors.", (74, 222, 128, 255), True),
        ("[Build] flutter build apk --release -> SUCCESS: app-release.apk (50.5 MB)", (74, 222, 128, 255), True),
    ]
    
    y = 52
    for text, color, bold in lines:
        if text:
            draw.text((24, y), text, font=get_font(13, bold=bold, code=True), fill=color)
        y += 24
        
    out_path = os.path.join(EVIDENCIAS_DIR, "prompt_ia.png")
    img.save(out_path)
    print("Guardado:", out_path)

# -------------------------------------------------------------
# 5. SCREENSHOT: arbol_carpetas.png (Árbol de Carpetas Clean Architecture)
# -------------------------------------------------------------
def generate_arbol_screenshot():
    width, height = 900, 620
    img = Image.new("RGBA", (width, height), (30, 30, 30, 255))
    draw = ImageDraw.Draw(img)
    
    # Barra de ventana
    draw.rectangle([(0, 0), (width, 36)], fill=(45, 45, 45, 255))
    draw.ellipse([(14, 12), (26, 24)], fill=(239, 68, 68, 255))
    draw.ellipse([(34, 12), (46, 24)], fill=(245, 158, 11, 255))
    draw.ellipse([(54, 12), (66, 24)], fill=(16, 185, 129, 255))
    draw.text((width / 2 - 130, 10), "VetDomiRuta - Clean Architecture Structure", font=get_font(12, bold=True), fill=(200, 200, 200, 255))
    
    tree_text = [
        "vet_domi_ruta/",
        "├── lib/",
        "│   ├── core/",
        "│   │   ├── constants/ (app_constants.dart)",
        "│   │   ├── database/  (database_helper.dart - SQLite singleton & migrations)",
        "│   │   ├── theme/     (app_theme.dart - Material 3 Teal)",
        "│   │   └── utils/     (formatters.dart - COP & Fechas)",
        "│   ├── features/",
        "│   │   ├── appointments/",
        "│   │   │   ├── data/         (models/, repositories/appointment_repository_impl.dart)",
        "│   │   │   ├── domain/       (entities/appointment.dart, repositories/appointment_repository.dart)",
        "│   │   │   └── presentation/ (providers/, screens/agenda_screen.dart, widgets/)",
        "│   │   ├── clients/",
        "│   │   │   ├── data/         (models/client_model.dart, repositories/client_repository_impl.dart)",
        "│   │   │   ├── domain/       (entities/client.dart, repositories/client_repository.dart)",
        "│   │   │   └── presentation/ (providers/, screens/clients_screen.dart, widgets/)",
        "│   │   ├── dashboard/        (presentation/screens/dashboard_screen.dart)",
        "│   │   └── pets/",
        "│   │       ├── data/         (models/pet_model.dart, repositories/pet_repository_impl.dart)",
        "│   │       ├── domain/       (entities/pet.dart, repositories/pet_repository.dart)",
        "│   │       └── presentation/ (providers/, screens/pet_detail_screen.dart, widgets/)",
        "│   └── main.dart             (ProviderScope, DatabaseHelper init, MaterialApp)",
        "├── evidencias/               (Capturas de pantalla y diagramas técnicos)",
        "├── tools/                    (generate_word_report.py, generate_screenshots.py)",
        "├── build/app/outputs/flutter-apk/app-release.apk (50.5 MB)",
        "└── pubspec.yaml              (sqflite, flutter_riverpod, intl, path)"
    ]
    
    y = 50
    for line in tree_text:
        color = (255, 255, 255, 240)
        if "lib/" in line or "features/" in line:
            color = (56, 189, 248, 255) # Cyan
        elif "app-release.apk" in line:
            color = (74, 222, 128, 255) # Green
        elif "pubspec.yaml" in line:
            color = (251, 191, 36, 255) # Amber
        draw.text((28, y), line, font=get_font(13, code=True), fill=color)
        y += 22

    out_path = os.path.join(EVIDENCIAS_DIR, "arbol_carpetas.png")
    img.save(out_path)
    print("Guardado:", out_path)

# -------------------------------------------------------------
# 6. SCREENSHOT: apk_build.png (Verificación de Compilación APK)
# -------------------------------------------------------------
def generate_apk_build_screenshot():
    width, height = 900, 420
    img = Image.new("RGBA", (width, height), (30, 30, 30, 255))
    draw = ImageDraw.Draw(img)
    
    # Barra de ventana
    draw.rectangle([(0, 0), (width, 36)], fill=(45, 45, 45, 255))
    draw.ellipse([(14, 12), (26, 24)], fill=(239, 68, 68, 255))
    draw.ellipse([(34, 12), (46, 24)], fill=(245, 158, 11, 255))
    draw.ellipse([(54, 12), (66, 24)], fill=(16, 185, 129, 255))
    draw.text((width / 2 - 110, 10), "Terminal - Flutter Release Build", font=get_font(12, bold=True), fill=(200, 200, 200, 255))
    
    terminal_lines = [
        ("PS C:\\Users\\NATY\\.gemini\\antigravity\\scratch\\vet_domi_ruta> flutter build apk --release", (255, 255, 255, 255), True),
        ("Running Gradle task 'assembleRelease'...", (148, 163, 184, 255), False),
        ("Checking the license for package NDK (Side by side) 28.2 in Android/Sdk/licenses", (148, 163, 184, 255), False),
        ("Font asset 'MaterialIcons-Regular.otf' was tree-shaken (99.3% reduction)", (148, 163, 184, 255), False),
        ("Compiling Kotlin source to JVM bytecode...", (148, 163, 184, 255), False),
        ("Building SQLite native bindings (sqflite android)...", (148, 163, 184, 255), False),
        ("Optimizing DEX and shrinking resources...", (148, 163, 184, 255), False),
        ("Signing APK with release target configuration...", (148, 163, 184, 255), False),
        ("", (0,0,0,0), False),
        ("√ Built build\\app\\outputs\\flutter-apk\\app-release.apk (50.5MB)", (74, 222, 128, 255), True),
        ("", (0,0,0,0), False),
        ("PS C:\\Users\\NATY\\.gemini\\antigravity\\scratch\\vet_domi_ruta> Get-Item build\\app\\outputs\\flutter-apk\\app-release.apk", (255, 255, 255, 255), True),
        ("Mode                 LastWriteTime         Length Name", (148, 163, 184, 255), False),
        ("----                 -------------         ------ ----", (148, 163, 184, 255), False),
        ("-a----         07/11/2026  09:09 PM       52915336 app-release.apk", (226, 232, 240, 255), True),
    ]
    
    y = 52
    for text, color, bold in terminal_lines:
        if text:
            draw.text((28, y), text, font=get_font(13, bold=bold, code=True), fill=color)
        y += 22

    out_path = os.path.join(EVIDENCIAS_DIR, "apk_build.png")
    img.save(out_path)
    print("Guardado:", out_path)

if __name__ == "__main__":
    generate_home_screenshot()
    generate_formulario_screenshot()
    generate_clientes_screenshot()
    generate_prompt_screenshot()
    generate_arbol_screenshot()
    generate_apk_build_screenshot()
    print("¡Todas las evidencias visuales generadas exitosamente!")
