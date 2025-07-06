Write-Host "Начинаю добавление метки UTF-8 BOM к .ass файлам..." -ForegroundColor Yellow

$subtitleFiles = Get-ChildItem -Path . -Filter *.ass
if (-not $subtitleFiles) {
    Write-Host "В этой папке не найдено .ass файлов." -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода..."
    exit
}

$errorCount = 0
foreach ($file in $subtitleFiles) {
    Write-Host "Обрабатываю: $($file.Name)"
    try {
        
        $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
        
        
        
        $utf8WithBom = New-Object System.Text.UTF8Encoding($true)
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8WithBom)
    }
    catch {
        Write-Host "  - Ошибка при конвертации файла $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host ""
if ($errorCount -eq 0) {
    Write-Host "Готово! Все файлы ($($subtitleFiles.Count)) были успешно пересохранены с меткой UTF-8 BOM." -ForegroundColor Green
} else {
    Write-Host "Конвертация завершена с ошибками ($errorCount)." -ForegroundColor Yellow
}

Write-Host "Теперь можете запускать основной скрипт process.ps1"
Read-Host "Нажмите Enter для выхода..."