# ==========================================
# Herdr Integration
# ==========================================
if [ -z "$HERDR_ENV" ] && [ -z "$HERDR_RAN" ]; then
  export HERDR_RAN=1
  herdr
fi
