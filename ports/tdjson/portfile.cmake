include(vcpkg_common_functions)

if(NOT VCPKG_LIBRARY_LINKAGE STREQUAL static)
  message( FATAL_ERROR "Only static build is supported" )
endif()

set(VERSION 1.2.0)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/tdlib-${VERSION})

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tdlib/td
    REF v${VERSION}
    SHA512 02b2870f8b868fb9f026a1210a50c788481711ff8658d50ab87ec614253342f1902e89a2e15343d9e6cd4d994ba67e389b1dec790e71e6025a2048033bb5c973
    HEAD_REF master
)
vcpkg_find_acquire_program(GPERF)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/tdjson_static.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DGPERF_EXECUTABLE:FILEPATH="${GPERF}"
)
vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/Td)

file(INSTALL ${SOURCE_PATH}/LICENSE_1_0.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/tdjson RENAME copyright)

vcpkg_copy_pdbs()