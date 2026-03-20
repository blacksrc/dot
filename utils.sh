#!/usr/bin/env bash

log_info()    { echo -e "• $*"; }
log_success() { echo -e "• ✅ $*"; }
log_warning() { echo -e "• ⚠️ $*" >&2; }
log_error()   { echo -e "• ❌ $*" >&2; }
