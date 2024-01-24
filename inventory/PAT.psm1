function Get-Pats {
    param (
        [String] $pat_url,
        [System.Object] $headers
    )
    $tokens = Invoke-RestMethod -Uri $pat_url -Headers $headers -Method GET
    return $tokens.patTokens
}

function Get-PatId {
    param (
        [String] $token_name,
        [String] $pat_url,
        [System.Object] $headers
    )

    $tokens = Get-Pats -pat_url $pat_url -headers $headers
    foreach ($token in $tokens) {
        if ($token.displayName -eq $token_name) {
            return $token.authorizationId
        }
    }
}

function Update-Pat {
    param (
        [String] $token_name,
        [String] $pat_url,
        [System.Object] $headers
    )

    Revoke-Pat -token_name $token_name -pat_url $pat_url -headers $headers
    $pat = Add-Pat -token_name $token_name -pat_url $pat_url -headers $headers
    return $pat
}

function Add-Pat {
    param (
        [String] $token_name,
        [String] $pat_url,
        [System.Object] $headers
    )

    $body = @{
        "displayName" = $token_name;
        "scope" = "app_token";
        "validTo" = (Get-Date ((Get-Date).AddDays(30)) -Format "MM/dd/yyyy HH:mm:ss");
        "allOrgs" = $false
    }

    $pat = Invoke-RestMethod -Uri $pat_url -Headers $headers -Method POST -Body (ConvertTo-Json $body)
    return $pat.patToken.token
}

function Revoke-Pat {
    param (
        [String] $token_name,
        [String] $pat_url,
        [System.Object] $headers
    )

    $authorizationId = Get-PatId -token_name $token_name -pat_url $pat_url -headers $headers
    $token_url = "https://vssps.dev.azure.com/StealthDev/_apis/tokens/pats?authorizationId=$($authorizationId)&api-version=7.1-preview.1"
    Invoke-RestMethod -Uri $token_url -Headers $headers -Method DELETE
}

Export-ModuleMember -Function *

