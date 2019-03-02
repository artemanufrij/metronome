icon_size = ['32', '48']

foreach i : icon_size
    install_data(
        join_paths('icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
    )
endforeach

icon_size_large = ['64', '128']

foreach l : icon_size_large
    install_data(
        join_paths('icons', meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', l + 'x' + l, 'apps')
    )
endforeach

misc_icons = ['symbol_crotchet', 'symbol_minim', 'symbol-quaver', 'symbol_semibreve', 'led_gray', 'led_green', 'led_red']

foreach m : misc_icons
    install_data(
        join_paths('icons', m + '.png'),
        install_dir: join_paths(get_option('datadir'), meson.project_name(), 'icons')
    )
endforeach

sounds = ['click_1', 'click_2', 'click_4', 'click_8', 'beat']

foreach s : sounds
    install_data(
        join_paths('sounds', s + '.wav'),
        install_dir: join_paths(get_option('datadir'), meson.project_name(), 'sounds')
    )
endforeach

i18n.merge_file(
    input: 'com.github.artemanufrij.metronome.appdata.xml.in',
    output: 'com.github.artemanufrij.metronome.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po', 'extra'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

i18n.merge_file(
    input: 'com.github.artemanufrij.metronome.desktop.in',
    output: 'com.github.artemanufrij.metronome.desktop',
    po_dir: join_paths(meson.source_root(), 'po', 'extra'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)
