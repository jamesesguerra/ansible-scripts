function Get-VarGrpId {
    param (
        [String] $var_grp_name,
        [System.Object] $headers
    )

    $var_url = "https://dev.azure.com/StealthDev/Stealth%20Development/_apis/distributedtask/variablegroups/?groupName=$($var_grp_name)&api-version=7.1-preview.2"
    $var_grp = Invoke-RestMethod -Uri $var_url -Headers $headers -Method GET
    $var_grp_id = $var_grp.value.id
    return $var_grp_id
}

function Update-Var {
    param (
        [String] $var_grp_name,
        [String] $var_grp_id,
        [String] $var_name,
        [String] $var_value,
        [Object] $headers
    )

    $var_url = "https://dev.azure.com/StealthDev/Stealth%20Development/_apis/distributedtask/variablegroups/$($var_grp_id)?api-version=7.1-preview.2"
    $var_grp = Invoke-RestMethod -Uri $var_url -Headers $headers -Method GET
    $var_grp.variables.$var_name.value = $var_value
    # $var_grp.variables.$var_name.isSecret = $true

    $body = @{
        "name" = $var_grp_name;
        "variables" = $var_grp.variables;
        "variableGroupProjectReferences" = @(
            @{
                "name" = $var_grp_name;
                "projectReference" = @{
                    "id" = "f7ebce0d-9650-4bc9-846b-18082e3d8312"
                }
            }
        )
    }

    Invoke-RestMethod -Uri $var_url -Headers $headers -Method PUT -Body (ConvertTo-Json -Depth 3 $body)
}

function Update-VarGrp {
    param (
        [String] $var_grp_name,
        [String] $var_name,
        [String] $var_value,
        [System.Object] $headers
    )

    $var_grp_id = Get-VarGrpId -var_grp_name $var_grp_name -headers $headers
    Update-Var -var_grp_name $var_grp_name -var_grp_id $var_grp_id -var_name $var_name -var_value $var_value -headers $headers
}

Export-ModuleMember -Function *

