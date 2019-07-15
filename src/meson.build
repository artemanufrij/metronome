conf_data = configuration_data()
conf_data.set_quoted('PKGDATADIR', join_paths(get_option('prefix'), get_option('datadir'), meson.project_name()))
config_header = configure_file(
    input: 'Config.vala.in',
    output: 'Config.vala',
    configuration: conf_data
)

sources = files(
    'Objects/Click.vala',
    'Objects/Preset.vala',
    'Widgets/Presets.vala',
    'Widgets/PresetRow.vala',
    'Widgets/Volumes.vala',
    'Settings.vala',
    'Metronome.vala',
)
