#!/bin/bash

#VENV_PATH=../.venv
#ROOT_PASSWORD=

#API_URL=http://localhost:3000/wizard-api
#API_KEY=eyJhbGciOiJSUzI1NiJ9.eyJleHAiOjM0ODE4MDQ4MDAsInRlbmFudFV1aWQiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJ0b2tlblV1aWQiOiI3MTUxYjQwZi05NmFmLTQ4MjQtOTJiMi0xZWJkNmFmYWM4NDQiLCJ1c2VyVXVpZCI6ImVjNmY4ZTkwLTJhOTEtNDllYy1hYTNmLTllYWIyMjY3ZmM2NiIsInZlcnNpb24iOjR9.HysexHnp6nBypWpqdzWhe2-VjQFv6TCR-MbtbF0BmwiOjg_6LaDlM0_pkjsh3fwNbPqhS_fDROwTQnNXX5L6duUjxGD4nxpfPtg0TpbkJAE2llmM_cmbAzOv26NCCtUGtSwoxce9R2G7NbO033UEKSf79LXW61YL3p9A8RFUokAaqAZC6G9mMWbhREVRQYSipopSpklJv18n_gggffcd8I6j3xu-kT8uVwLsO2X_j5DrInDQ8jLsvxMSlOzjZgKbV26pnTC_GVwYRs6Q1OaSTDkCDVr6uj-eHjgcN2U-Pzk5MiO-HlK6o6MiAXieQlHB94OYgQWg3VQ1g40ztNB5s6KgQ8XBq-NYj9_sHuSbwvT64WulEqkmTSRNemomZvP_2hpRbmKzWxPdhkxceCbnFrnqhOib5YyUUW-uO1UEUuJdZuaaVLqOZDFid9QYCwWRPGIQ9IeuMGFWOvHPcshk0f6g4Mfa8c2syfvhVpqbuj52L4KYiJFf9EwsshBD_-6bqLitE54AEW8ENf9ybwDlCHcDtbKt4Ksj7AhgYxMIHleOkuFMxGFngC_EvpphSqh-x3biVxlN86EVP0OqAEWOpEC6xh5eE87TpEBIFlo2E2YgWCVKE_zaDoM3sO9xBnZ-f9YzCuILmym40-8nx3gkQG4iA3vcUmp8ZUCVntQB61E

#TEMPLATE_ID=myorg:zh_tw_eu:1.0.0
#TEMPLATE_DIR="./${TEMPLATE_ID}"

function help() {
	echo "Usage: source run.sh [activate|deactivate]"
	echo "  activate   - Activate the virtual environment"
	echo "  deactivate - Deactivate the virtual environment"
	echo "  list       - List available TDKs from the local API"
}

function activate() {
	UPDATE=0
	if [ ! -f $VENV_PATH ] || [ "$1" == "--force" ]; then
		UPDATE=1
	fi
	if [ $UPDATE -eq 1 ]; then
		deactivate
		rm -rf $VENV_PATH
		python3 -m venv $VENV_PATH
	fi

	source "$VENV_PATH/bin/activate"

	if [ $UPDATE -eq 1 ]; then
		echo $ROOT_PASSWORD | sudo -S apt install -y python3-pip
		pip3 install dsw-tdk
	fi
}

function list() {
	echo "Using API URL: $API_URL"
	echo "Using API Key: $API_KEY"
	dsw-tdk list --api-url "$API_URL" --api-key "$API_KEY"
}

function get() {
	echo "Using API URL: $API_URL"
	echo "Using API Key: $API_KEY"
	echo "Using Template ID: $TEMPLATE_ID"
	echo "Using Template Directory: $TEMPLATE_DIR"
	dsw-tdk get --api-url "$API_URL" --api-key "$API_KEY" "${TEMPLATE_ID}" "$TEMPLATE_DIR"
}

function put() {
	echo "Using API URL: $API_URL"
	echo "Using API Key: $API_KEY"
	echo "Using Template Directory: $TEMPLATE_DIR"
	dsw-tdk put --api-url "$API_URL" --api-key "$API_KEY" --watch "$TEMPLATE_DIR"
}

main() {
	. example.env
	if [ "$#" -lt 1 ]; then
		help
		return
	fi
	if [ "$1" == "activate" ]; then
		activate "${@:2}"
	fi
	if [ "$1" == "deactivate" ]; then
		deactivate
	fi
	if [ "$1" == "list" ]; then
		list
	fi
	if [ "$1" == "get" ]; then
		get
	fi
	if [ "$1" == "put" ]; then
		put
	fi
}

main "$@"
