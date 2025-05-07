#!/bin/bash

SERIES_LIST="$HOME/.config/tv_series.txt"
DAYS=7
TODAY=$(date +%s)
CUTOFF=$(date -d "$DAYS days ago" +%s)

# Count of shows with new episodes
new_count=0
details=""

while IFS= read -r series; do
    # Get show ID
    show_json=$(curl -s "https://api.tvmaze.com/singlesearch/shows?q=$(echo "$series" | sed 's/ /%20/g')")
    show_id=$(echo "$show_json" | jq -r '.id')

    [[ -z "$show_id" || "$show_id" == "null" ]] && continue

    # Get episodes
    episodes_json=$(curl -s "https://api.tvmaze.com/shows/$show_id/episodes")

    latest=$(echo "$episodes_json" | jq -c '.[]' |
        jq -r --arg cutoff "$CUTOFF" '
            select(.airdate != null) |
            select((.airdate | strptime("%Y-%m-%d") | mktime) >= ($cutoff | tonumber)) |
            "\(.season)x\(.number) \(.name) (\(.airdate))"
        ')

    if [[ -n "$latest" ]]; then
        new_count=$((new_count + 1))
        details+="$series: $latest\n"
    fi
done < "$SERIES_LIST"

# Output for i3blocks
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    # Left click: show notification
    notify-send "📺 TV Updates" "${details:-No new episodes found.}"
else
    echo "📺 $new_count show(s)"
fi

