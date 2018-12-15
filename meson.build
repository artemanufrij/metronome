project('com.github.artemanufrij.metronome', 'vala', 'c')

i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

subdir('data')
subdir('po')
subdir('schemas')
subdir('src')

executable(
    meson.project_name(),
    sources,
    config_header,
    dependencies: [
        dependency('granite'),
        dependency('gstreamer-1.0'),
        dependency('gtk+-3.0'),
    ],
    install: true
)

meson.add_install_script('meson/post_install.py')
