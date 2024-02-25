if(NOT PLUGIN_INSTALLDIR)
  if(APPLE)
    set(PLUGIN_INSTALLDIR "/Library/OFX/Plugins")
  elseif(WIN32)
    set(PLUGIN_INSTALLDIR "C:/Program Files/Common Files/OFX/Plugins")
  elseif(UNIX)
    set(PLUGIN_INSTALLDIR "/usr/OFX/Plugins")
  else()
    set(PLUGIN_INSTALLDIR "/unknown-os")
  endif()
endif()

if(APPLE)
  set(ARCHDIR "MacOS")
elseif(WIN32)
  set(ARCHDIR "Win64")
elseif(UNIX)
  set(ARCHDIR "Linux-x86-64")
else()
  set(ARCHDIR "unknown-arch")
endif()

# Add a new OFX plugin target
# Arguments: TARGET
# Optional argument: DIR, defaults to same as TARGET (use when renaming TARGET)
function(add_ofx_plugin TARGET)
  if(${ARGC} GREATER 1)
    set(DIR ${ARGN})
  else()
    set(DIR ${TARGET})
  endif()
  if(APPLE)
    add_library(${TARGET} MODULE) # build as an OSX bundle
  else()
    add_library(${TARGET} SHARED) # build as shared lib/DLL
  endif()
  set_target_properties(${TARGET} PROPERTIES SUFFIX ".ofx" PREFIX "")

	# Set symbol visibility hidden. Individual symbols are exposed via
	# __declspec(dllexport) or __attribute__((visibility("default")))
	set_target_properties(${TARGET} PROPERTIES
	  C_VISIBILITY_PRESET hidden
	  CXX_VISIBILITY_PRESET hidden)

	# To install plugins: cmake --install Build
	install(TARGETS ${TARGET} DESTINATION "${PLUGINDIR}/${TARGET}.ofx.bundle/Contents/${ARCHDIR}")
	install(FILES ${DIR}/Info.plist DESTINATION "${PLUGINDIR}/${TARGET}.ofx.bundle/Contents")
endfunction()
