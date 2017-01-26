$health = Get-StorageSubSystem Cluster* | Get-StorageHealthReport 
$datetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$nameLength = 0
$valueLength = 0
$values = @()

foreach($r in $health.ItemValue.Records) {

if ($r.Name.Length -gt $nameLength) {
    $nameLength = $r.Name.Length
}

$localValue=""

switch($r.Units) {
    0{
        $values += $r.Value
      }
    1{
        $values += $r.Value
    }
    2{
        #$localValue = "{0}" -f [System.Math]::Round($r.Value,2)
        $values += $r.Value
    }
    3{ 
        $values += $r.Value
    }
    4{
        [double]$localValue = [System.Math]::Round($r.Value,2)
        $values += $localValue
    }
    default
    {
        $values += $r.Value
    }
}
                    
    if($localValue.Length -gt $valueLength) {
        $valueLength = $localValue.Length
    }
}

$j=0;

$obj = new-object PSObject
$obj | add-member -membertype NoteProperty -name 'DateTime' -value $datetime

foreach($r in $health.ItemValue.Records) {
    $obj | add-member -membertype NoteProperty -name $r.Name -value $values[$j]
    $j++
}

$obj | export-csv C:\temp\s2d_perf_output.csv -notypeinformation -Append -Encoding UTF8