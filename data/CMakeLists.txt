install (FILES com.github.artemanufrij.metronome.desktop DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/applications)
install (FILES com.github.artemanufrij.metronome.appdata.xml DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/metainfo)

install (FILES icons/artemanufrij.metronome.svg DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/icons/hicolor/)
install (FILES icons/48/artemanufrij.metronome.svg DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/icons/hicolor/32x32/apps/)
install (FILES icons/48/artemanufrij.metronome.svg DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/icons/hicolor/48x48/apps/)
install (FILES icons/artemanufrij.metronome.svg DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/icons/hicolor/64x64/apps/)
install (FILES icons/artemanufrij.metronome.svg DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/icons/hicolor/128x128/apps/)


install (FILES icons/symbol_crotchet.png DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/icons)
install (FILES icons/symbol_minim.png DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/icons)
install (FILES icons/symbol-quaver.png DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/icons)
install (FILES icons/symbol_semibreve.png DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/icons)
install (FILES icons/led_gray.png DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/icons)
install (FILES icons/led_green.png DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/icons)
install (FILES icons/led_red.png DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/icons)

install (FILES sounds/click_1.wav DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/sounds)
install (FILES sounds/click_2.wav DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/sounds)
install (FILES sounds/click_4.wav DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/sounds)
install (FILES sounds/click_8.wav DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/sounds)
install (FILES sounds/beat.wav DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/${CMAKE_PROJECT_NAME}/sounds)
