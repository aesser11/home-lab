## Parameters 
- `PROTON_ENABLE_WAYLAND` - for hdr
- `PROTON_DLSS_UPGRADE` - easy enable for latest models of dlss
- `PROTON_ENABLE_NGX_UPDATER` - enable for specific setting of dlss versions (allows specifying certian modles granularly) 
- `DXVK_NVAPI_DRS_SETTINGS` - DRS settings here - example for model `L` - `DXVK_NVAPI_DRS_SETTINGS=NGX_DLSS_SR_OVERRIDE=on,NGX_DLSS_RR_OVERRIDE=on,NGX_DLSS_FG_OVERRIDE=on,NGX_DLSS_SR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_l,NGX_DLSS_RR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_l`

Not certain of all of these are GE proton only or which ones are usable in regular proton
## Sources
- Valve Proton list - https://github.com/ValveSoftware/Proton#runtime-config-options
- Glorious Eggroll Proton Fork list - https://github.com/GloriousEggroll/proton-ge-custom#options