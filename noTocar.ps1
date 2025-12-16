Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- COMPATIBILIDAD CON WINDOWS 7 ---
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$imagePath = Join-Path $scriptPath "logo.png"

# --- CONFIGURACION DE LA VENTANA ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "SOPORTE IT ACTIVO"
$form.BackColor = "DarkRed"
$form.TopMost = $true
$form.Width = 750
$form.Height = 650  
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.ControlBox = $false
$form.ShowInTaskbar = $false

# --- 1. CONFIGURACION DE LA IMAGEN ---
if (Test-Path $imagePath) {
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.ImageLocation = $imagePath
    $pictureBox.SizeMode = "Zoom"
    $pictureBox.Height = 350    
    $pictureBox.Dock = "Bottom"    
    $pictureBox.BackColor = "DarkRed"
    
    # Agregamos la imagen primero
    $form.Controls.Add($pictureBox)
    $pictureBox.Add_DoubleClick({ $form.Close() })
}

# --- 2. CONFIGURACION DEL TEXTO  ---
$label = New-Object System.Windows.Forms.Label
$label.Text = "MANTENIMIENTO EN CURSO`n`nPor favor, NO toque el mouse ni el teclado.`n`nSoporte tecnico esta trabajando en este equipo, cualquier consulta comuniquese al interno: 6300."
$label.ForeColor = "White"
$label.Font = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
$label.TextAlign = "TopCenter" 
$label.Padding = New-Object System.Windows.Forms.Padding(0, 40, 0, 0) 
$label.Dock = "Fill" 

$label.Add_DoubleClick({ $form.Close() })

$form.Controls.Add($label) 

# --- MOSTRAR ---
$form.ShowDialog()