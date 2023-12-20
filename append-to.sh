#!/bin/bash

read -p "Enter something: " PACKAGE_NAME
read -p "Use Builder bob: " INPUT
mkdir $PACKAGE_NAME && cd $PACKAGE_NAME
touch package.json

is_rn_Builder_BOB() {
cat <<EOF
    "react-native-builder-bob": {
        "source": "src",
        "output": "lib",
        "targets": [
        "commonjs",
        "module",
        [
            "typescript",
            {
            "tsc": "../../../node_modules/.bin/tsc"
            }
        ]
        ]
    }
EOF
}

modify_package_json() {
cat < package.json <<EOF
   {
    "name": "${PACKAGE_NAME}",
    "description": "${PACKAGE_NAME}",
    "version": "0.0.1",
    "packageManager": "yarn@3.6.4",
    "license": "UNLICESEND",
    "main": "lib/commonjs/index.js",
    "module": "lib/module/index.js",
    "react-native": "src/index.ts",
    "types": "lib/typescript/index.d.ts",
    "source": "index.ts",
    "publishConfig": {
        "access": "public"
    },
    "files": [
        "lib",
        "src"
    ],
    "scripts": {
        "build": "bob build",
        "lint": "eslint \"**/*.{js,ts,tsx}\""
    },

EOF

    if [[ $INPUT == "yes" ]]; then
        is_rn_Builder_BOB >> package.json
    fi

    # Finish the JSON structure
    echo "}" >> package.json
}

modify_package_json