j!/bin/bash
ip=$(hostname -I | awk '{print $1}')
echo "🌍$ip"

