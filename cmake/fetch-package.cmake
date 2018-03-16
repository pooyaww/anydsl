function(fetch_anydsl_package _pkg_path _pkg_name _pkg_fullname _pkg_url)
    # TODO: make this consistent
    # set(_pkg_fullname "AnyDSL_${_pkg_name}")
    set(_pkg_branch "AnyDSL_${_pkg_name}_BRANCH")
    if(NOT ${_pkg_branch})
        set(${_pkg_branch} ${AnyDSL_DEFAULT_BRANCH} CACHE STRING "follow branch of repository ${_pkg_url}")
    endif()
    string(TOLOWER ${_pkg_fullname} _pkg_fullname_lower)
    find_path(${_pkg_path}
        NAMES ${_pkg_fullname}-config.cmake ${_pkg_fullname_lower}-config.cmake
        PATHS
            ${${_pkg_path}}
            $ENV{${_pkg_path}}
            ${CMAKE_CURRENT_SOURCE_DIR}/${_pkg_name}/build
            ${ARGN}
        PATH_SUFFIXES
            share/${_pkg_fullname}/cmake
            share/anydsl/cmake
    )
    if(NOT ${_pkg_path} AND NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${_pkg_name})
        find_package(Git REQUIRED)
        execute_process(COMMAND ${GIT_EXECUTABLE} clone --branch ${${_pkg_branch}} --recursive ${_pkg_url} ${_pkg_name} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif()
    add_subdirectory(${_pkg_name})
    find_path(${_pkg_path}
        NAMES ${_pkg_fullname}-config.cmake ${_pkg_fullname_lower}-config.cmake
        PATHS ${${_pkg_path}} ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR} ${ARGN}
        PATH_SUFFIXES share/${_pkg_fullname}/cmake share/anydsl/cmake
        DOC "path to package ${_pkg_fullname}")
endfunction()
