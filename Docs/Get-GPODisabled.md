# Get-GPODisabled

## SYNOPSIS

Get Disabled GPO in your forest.

## SYNTAX

```powershell
Get-GPODisabled -GPO <String>
```

### GPO

```powershell
Get-GPODisabled -GPO <String>
```

## DESCRIPTION

The Get-GPODisabled function run on all GPO's in the forest and look for those with Disabled switch for Users or Computers
policy, or Both.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

Get-GPODisabled

This command get all GPO in the forest and check to see if there is any GPO with disabled settings for User, Computer or both.

### -------------------------- EXAMPLE 2 --------------------------

Get-GPODisabled -GPO "WSUS-Server"

This command only check the GPO provided to see if there is any  disabled settings for User, Computer or both.

### -------------------------- EXAMPLE 3 --------------------------

Get-GPO -Name "WSUS-Server" | Get-GPODisabled 

This command get the gpo from the pipeline, to see if there is any disabled settings for User, Computer or both.


## PARAMETERS

### -GPO

The GPO name to test. It's optional.

```yaml
Type: String
Parameter Sets:
Aliases:
Accepted values:

Required: 
Position: Named
Default value:
Accept pipeline input: True
Accept wildcard characters: False
```

## OUTPUTS

## NOTES

## RELATED LINKS

