Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host "Test"
$Edit = Read-Host -Prompt "Press Enter key to continue..."
Write-Host $Edit