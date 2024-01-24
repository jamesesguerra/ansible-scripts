Install-Module Az.Accounts -Force

Import-Module (Join-Path -Path $pwd -Childpath "AZAccessToken.psm1")
Import-Module (Join-Path -Path $pwd -Childpath "PAT.psm1")
Import-Module (Join-Path -Path $pwd -Childpath "Variables.psm1")


$PAT_URL = "https://vssps.dev.azure.com/StealthDev/_apis/tokens/pats?api-version=7.1-preview.1"

$headers = @{
    "Content-Type" = "application/json";
    "Authorization" = "Bearer $(Get-Token)"
}

$token_name = "automated_pat"
$var_grp_name = "devops-tokens"
$encoded_var_grp_name = [System.Web.HttpUtility]::UrlEncode($var_grp_name)
$var_name = "PR_PAT"

function Main {
    $pat = Update-PAT -token_name $token_name -pat_url $PAT_URL -headers $headers
    Write-Host $pat
    Update-VarGrp -var_grp_name $encoded_var_grp_name -var_name $var_name -var_value $pat -headers $headers
}

Main
