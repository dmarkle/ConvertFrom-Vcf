param($fileName = "c:\users\dmarkle\downloads\All Contacts.vcf")

function New-Card {
    return [PSCustomObject][ordered]@{'Full Name'="";'Categories'='';'Organization'='';'Address'='';'Phone1'='';'Phone2'='';'Phone3'='';'Phone4'='';'Note'=''}
}


$content = Get-Content $fileName
$cardCount = 0;
$currentCard = New-Card
$state = 'out'
foreach ($line in $content) {
    if ($line -match "^PRODID.*") {
        $state = 'in'
        $cardCount++;
        $telephones = 0;
        $currentCard = New-Card
        continue;
    }
    if ($line -match "^END:VCARD.*") {
        $state = 'out'
        $currentCard
        continue;
    }

    if ($line -match "^PHOTO;.*") {
        $state = 'photo'
        continue;
    }

    if ($line -match "FN:.*") {
        $tokens = $line -split ":"
        $currentCard."Full Name" = $tokens[1] -replace "\\,", ","
    }

    if ($line -match "ORG:.*") {
        $tokens = $line -split ":"
        $currentCard."Organization" = (($tokens[1] -split ';') -join "`n") -replace "\\,", ","
    }

    if ($line -match "^ADR.*:.*" -or $line -match "^item1.ADR.*:.*") {
        $tokens = $line -split ":"
        $currentCard."Address" = (($tokens[1] -split ';').Where({-not [string]::IsNullOrWhitespace($_)}) -join "`n") -replace "\\,", "," -replace "\\n", "`n"
    }

    if ($line -match "TEL;") {
        $telephones++;
        $tokens = $line -split ":"
        $currentCard."Phone$telephones" = (($tokens[1] -split ';') -join "`n") -replace "\\,", ","
    }

    if ($line -match "NOTE:") {
        $telephones++;
        $tokens = $line -split ":"
        $currentCard."Note" = (($tokens[1] -split ';') -join "`n") -replace "\\,", ","
    }

    if ($line -match "CATEGORIES.*") {
        $tokens = $line -split ":"
        $currentCard."Categories" = $tokens[1]
    }
    
}

