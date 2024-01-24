function Get-Token {
    $username = $($env:USER_NAME)
    $password = ConvertTo-SecureString -String $($env:PASSWORD) -AsPlainText -Force
    $credential = New-Object -TypeName System.Management.Automation.PSCredential ($username, $password)

    $null = Connect-AzAccount -Credential $credential -TenantId $($env:TENANT_ID)
    $token = Get-AzAccessToken
    return $token.Token
}

Export-ModuleMember -Function Get-Token
