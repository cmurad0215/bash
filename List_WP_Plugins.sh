#!/bin/bash

counter=1;

wp_config_paths=$(find / -name "wp-config.php" 2>/dev/null);

if [ -z "$wp_config_paths" ]; then
    echo "No WordPress installations found.";
else
    while IFS= read -r path; do

        OUTPUT_FILE="$(hostname)_wordpress_plugins_$counter.csv";
        wpath="${path%/*}";
        echo "$wpath" > "$OUTPUT_FILE";
        echo "Plugin Name,Version,Status,Auto Update" >> "$OUTPUT_FILE";
        wp plugin list --allow-root --format=json --path=$wpath | jq -r '.[] | [.name, .version, .status, .auto_update] | @csv' >> "$OUTPUT_FILE";
        ((counter++));

    done <<< "$wp_config_paths"
fi
