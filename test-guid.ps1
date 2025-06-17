Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Tripwire Recon Note" Height="200" Width="400">
    <StackPanel Margin="10">
        <TextBlock Text="Scout Name:" Margin="0,0,0,5"/>
        <TextBox Name="ScoutName" Height="25" Margin="0,0,0,10"/>
        <Button Name="SubmitBtn" Content="Generate Note" Width="120" HorizontalAlignment="Left"/>
    </StackPanel>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$scoutBox = $window.FindName("ScoutName")
$submitBtn = $window.FindName("SubmitBtn")

$submitBtn.Add_Click({
    $scout = $scoutBox.Text
    [System.Windows.MessageBox]::Show("Recon note will be generated for: $scout")
    $window.Close()
})

$window.ShowDialog() | Out-Null
