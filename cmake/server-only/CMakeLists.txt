cmake_minimum_required(VERSION 3.21)
project(SokuLobbiesServerOnly LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(SFML 3 CONFIG REQUIRED COMPONENTS Network)

set(ROOT "${CMAKE_CURRENT_LIST_DIR}/../..")
add_executable(SokuLobbiesServer
  "${ROOT}/src/Server/main.cpp"
  "${ROOT}/src/Server/Connection.cpp"
  "${ROOT}/src/Server/Server.cpp"
  "${ROOT}/src/Common/Packet.cpp"
  "${ROOT}/src/Common/Socket.cpp"
  "${ROOT}/src/Common/GuardedMutex.cpp"
  "${ROOT}/src/Common/Utils.cpp"
  "${ROOT}/src/Common/encodingConverter.cpp"
)
target_include_directories(SokuLobbiesServer PRIVATE
  "${ROOT}/src/Common"
  "${ROOT}/src/Server"
)
target_compile_definitions(SokuLobbiesServer PRIVATE SFML3 NDEBUG WINVER=0x0601 _WIN32_WINNT=0x0601)
target_link_libraries(SokuLobbiesServer PRIVATE SFML::Network ws2_32)
if(MSVC)
  target_compile_options(SokuLobbiesServer PRIVATE /utf-8)
endif()
