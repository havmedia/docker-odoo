variable "REGISTRY" {
    default = "ghcr.io/havmedia/docker-odoo"
}

variable "VERSION" {
    default = "19.0"
}

variable "LOCAL_GEOIP_PATH" {
    default = "."
}

function "version2target" {
    params = [string]
    result = trimsuffix(string, ".0")
}

group "default" {
    targets = ["${version2target(VERSION)}"]
}

group "all" {
    targets = ["17", "18", "19", "master"]
}

target "_local" {
    tags = ["${REGISTRY}:${VERSION}"]
}

target "docker-metadata-action" {
}

target "_common" {
    inherits = ["_local", "docker-metadata-action"]
    args = {
        LOCAL_GEOIP_PATH = LOCAL_GEOIP_PATH
    }
}

target "18" {
    inherits = ["_common"]
    platforms = ["linux/amd64", "linux/arm64"]
    args = {
        ODOO_VERSION="18.0"
        DISTRIBUTION="bookworm"
        PYTHON_VERSION="3.12"
        WKHTMLTOPDF_VERSION="0.12.6"
    }
}


target "19" {
    inherits = ["_common"]
    platforms = ["linux/amd64", "linux/arm64"]
    args = {
        ODOO_VERSION="19.0"
        DISTRIBUTION="trixie"
        PYTHON_VERSION="3.12"
        WKHTMLTOPDF_VERSION="0.12.6"
    }
}

target "master" {
    inherits = ["_common"]
    platforms = ["linux/amd64", "linux/arm64"]
    args = {
        ODOO_VERSION="master"
        DISTRIBUTION="trixie"
        PYTHON_VERSION="3.12"
        WKHTMLTOPDF_VERSION="0.12.6"
    }
}
