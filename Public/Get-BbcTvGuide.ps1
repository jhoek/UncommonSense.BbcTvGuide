function Get-BbcTvGuide
{
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('bbc-first', 'bbc-one', 'bbc-two', 'bbc-four')]
        [string]$Channel,

        [ValidateNotNullOrEmpty()]
        [DateTime]$Date = (Get-Date)
    )

    $DateString = $Date.ToString("yyyy-MM-dd")
    $Url = "https://www.bbcbenelux.com/smapi/schedule/nederland/$($Channel)?timezone=Europe%2FLuxembourg&date=$($DateString)"

    Invoke-RestMethod -Uri $Url
    | ForEach-Object { $_ }
    | ForEach-Object {
        $StartUtc = [DateTime]::SpecifyKind([DateTime]::ParseExact($_.Start, 'yyyy-MM-dd HH:mm:ss', $null), [System.DateTimeKind]::Utc)
        $EndUtc = [DateTime]::SpecifyKind([DateTime]::ParseExact($_.End, 'yyyy-MM-dd HH:mm:ss', $null), [System.DateTimeKind]::Utc)

        [PSCustomObject]@{
            PSTypeName      = 'UncommonSense.BccTvGuide.Entry'
            Channel         = $Channel
            StartText       = $_.Start
            EndText         = $_.End
            StartUtc        = $StartUtc
            EndUtc          = $EndUtc
            StartLocal      = $StartUtc.ToLocalTime()
            EndLocal        = $EndUtc.ToLocalTime()
            ShowTitle       = $_.Show.Title
            ShowSynopsis    = $_.Show.Synopsis
            EpisodeNo       = $_.Episode.Number
            EpisodeTitle    = $_.Episode.Title
            EpisodeSynopsis = $_.Episode.Synopsis
        }
    }
}