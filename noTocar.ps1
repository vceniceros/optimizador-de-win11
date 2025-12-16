Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Configuración de la ventana
$form = New-Object System.Windows.Forms.Form
$form.Text = "MANTENIMIENTO IT"
$form.BackColor = "DarkRed" # Color de fondo alarmante
$form.TopMost = $true # Siempre visible encima de todo
$form.FormBorderStyle = "None" # Sin bordes ni botones X
$form.WindowState = "Maximized" # Pantalla completa
$form.ShowInTaskbar = $false # No aparece en la barra de tareas

# Configuración del texto
$label = New-Object System.Windows.Forms.Label
$label.Text = "MANTENIMIENTO EN CURSO`n`nPOR FAVOR NO TOQUE EL EQUIPO`n`nSOPORTE TÉCNICO ESTÁ TRABAJANDO"
$label.AutoSize = $true
$label.ForeColor = "White"
$label.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold)
$label.TextAlign = "MiddleCenter"

# Centrar el texto en pantalla (calculo dinámico)
$form.Add_Load({
    $label.Location = New-Object System.Drawing.Point(
        ($form.Width - $label.Width) / 2,
        ($form.Height - $label.Height) / 2
    )
})

# Agregar el texto al formulario
$form.Controls.Add($label)

# Mostrar la ventana (Detiene el script aquí hasta que se cierre)
$form.ShowDialog()