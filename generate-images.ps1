# Generate stylized images for Kai Angel landing (local, offline-safe)
Add-Type -AssemblyName System.Drawing

$imgDir = Join-Path (Get-Location) 'img'
if (-not (Test-Path $imgDir)) { New-Item -ItemType Directory -Path $imgDir | Out-Null }

function Save-Jpeg($bmp, $path, $quality) {
    $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)
    $bmp.Save($path, $codec, $encParams)
    $bmp.Dispose()
}

# ---------- Artist portrait (500x600) ----------
function New-ArtistImage {
    $w = 500; $h = 600
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, [System.Drawing.Color]::FromArgb(10,10,10), [System.Drawing.Color]::FromArgb(35,5,5), 90)
    $g.FillRectangle($bg, $rect)

    $glow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70, 230, 0, 0))
    $g.FillEllipse($glow, 90, 60, 320, 320)
    $glow.Dispose()

    $sil = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(16,16,16))
    $g.FillEllipse($sil, 80, 300, 340, 280)
    $g.FillRectangle($sil, 215, 250, 70, 80)
    $g.FillEllipse($sil, 160, 100, 180, 200)
    $sil.Dispose()

    $rim = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 230, 0, 0))
    $g.FillEllipse($rim, 315, 110, 25, 180)
    $rim.Dispose()

    $blue = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 180, 255))
    $g.FillRectangle($blue, 60, 500, 380, 3)
    $blue.Dispose()

    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $font1 = New-Object System.Drawing.Font('Arial', 30, [System.Drawing.FontStyle]::Bold)
    $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString('KAI ANGEL', $font1, $white, (New-Object System.Drawing.RectangleF(0, 520, $w, 50)), $sf)
    $font2 = New-Object System.Drawing.Font('Arial', 12)
    $gray = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150,150,150))
    $g.DrawString('SHH TOUR 2026', $font2, $gray, (New-Object System.Drawing.RectangleF(0, 560, $w, 30)), $sf)

    $g.Dispose()
    Save-Jpeg $bmp (Join-Path $imgDir 'artist.jpg') 90
    Write-Host 'OK artist.jpg'
}

# ---------- Album covers (300x300) ----------
function New-AlbumCover($name, $c1, $c2, $title, $sub, $accentR, $accentG, $accentB) {
    $w = 300; $h = 300
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 45)
    $g.FillRectangle($bg, $rect)

    $glow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, $accentR, $accentG, $accentB))
    $g.FillEllipse($glow, 50, 50, 200, 200)
    $glow.Dispose()

    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $font = New-Object System.Drawing.Font('Arial', 40, [System.Drawing.FontStyle]::Bold)
    $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString($title, $font, $white, (New-Object System.Drawing.RectangleF(0, 80, $w, 80)), $sf)
    $font2 = New-Object System.Drawing.Font('Arial', 12)
    $gray = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180,180,180))
    $g.DrawString($sub, $font2, $gray, (New-Object System.Drawing.RectangleF(0, 170, $w, 30)), $sf)

    $g.Dispose()
    Save-Jpeg $bmp (Join-Path $imgDir $name) 90
    Write-Host "OK $name"
}

# ---------- damage cover with glitch effect ----------
function New-DamageCover {
    $w = 300; $h = 300
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $g.Clear([System.Drawing.Color]::FromArgb(8,8,8))

    $rnd = New-Object System.Random(42)
    for ($i = 0; $i -lt 14; $i++) {
        $y = $rnd.Next(0, $h)
        $bh = $rnd.Next(4, 18)
        $alpha = $rnd.Next(60, 160)
        if ($i % 2 -eq 0) {
            $color = [System.Drawing.Color]::FromArgb($alpha, 230, 0, 0)
        } else {
            $color = [System.Drawing.Color]::FromArgb($alpha, 0, 180, 255)
        }
        $bar = New-Object System.Drawing.SolidBrush($color)
        $g.FillRectangle($bar, 0, $y, $w, $bh)
        $bar.Dispose()
    }

    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $font = New-Object System.Drawing.Font('Arial', 36, [System.Drawing.FontStyle]::Bold)
    $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString('damage', $font, $white, (New-Object System.Drawing.RectangleF(0, 100, $w, 60)), $sf)
    $font2 = New-Object System.Drawing.Font('Arial', 12)
    $gray = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180,180,180))
    $g.DrawString('2025', $font2, $gray, (New-Object System.Drawing.RectangleF(0, 170, $w, 30)), $sf)

    $g.Dispose()
    Save-Jpeg $bmp (Join-Path $imgDir 'album-damage.jpg') 90
    Write-Host 'OK album-damage.jpg'
}

# ---------- Hero background: concert scene (1920x1080) ----------
function New-HeroImage {
    $w = 1920; $h = 1080
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    $g.Clear([System.Drawing.Color]::FromArgb(5,5,5))

    $glow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(50, 230, 0, 0))
    $g.FillEllipse($glow, 560, 200, 800, 800)
    $glow.Dispose()

    $beam1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(25, 230, 0, 0))
    $pts1 = [System.Drawing.Point[]]@(
        (New-Object System.Drawing.Point(700, 0)),
        (New-Object System.Drawing.Point(1150, 0)),
        (New-Object System.Drawing.Point(1500, 1080)),
        (New-Object System.Drawing.Point(300, 1080))
    )
    $g.FillPolygon($beam1, $pts1)
    $beam1.Dispose()

    $beam2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(20, 0, 180, 255))
    $pts2 = [System.Drawing.Point[]]@(
        (New-Object System.Drawing.Point(1150, 0)),
        (New-Object System.Drawing.Point(1400, 0)),
        (New-Object System.Drawing.Point(1900, 1080)),
        (New-Object System.Drawing.Point(900, 1080))
    )
    $g.FillPolygon($beam2, $pts2)
    $beam2.Dispose()

    $crowd = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(22,22,22))
    $rnd = New-Object System.Random(7)
    for ($i = 0; $i -lt 70; $i++) {
        $x = $rnd.Next(0, $w)
        $y = $rnd.Next(830, 1000)
        $r = $rnd.Next(20, 45)
        $g.FillEllipse($crowd, $x, $y, $r, $r)
    }
    $crowd.Dispose()

    $font = New-Object System.Drawing.Font('Arial', 90, [System.Drawing.FontStyle]::Bold)
    $faint = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(25, 255, 255, 255))
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString('SHH TOUR', $font, $faint, (New-Object System.Drawing.RectangleF(0, 380, $w, 120)), $sf)

    $g.Dispose()
    Save-Jpeg $bmp (Join-Path $imgDir 'hero-bg.jpg') 85
    Write-Host 'OK hero-bg.jpg'
}

New-ArtistImage
New-AlbumCover 'album-shh.jpg'  ([System.Drawing.Color]::FromArgb(60,0,0)) ([System.Drawing.Color]::FromArgb(10,10,10)) 'SHH.' '2026' 230 0 0
New-AlbumCover 'album-shh2.jpg' ([System.Drawing.Color]::FromArgb(0,30,50)) ([System.Drawing.Color]::FromArgb(10,10,10)) 'SHH!' '2026' 0 180 255
New-DamageCover
New-AlbumCover 'album-amc2.jpg' ([System.Drawing.Color]::FromArgb(25,25,40)) ([System.Drawing.Color]::FromArgb(10,10,10)) 'AMC2' 'ANGEL MAY CRY 2' 120 120 255
New-HeroImage

Write-Host 'Done. Files in img:'
Get-ChildItem $imgDir | Select-Object Name, Length