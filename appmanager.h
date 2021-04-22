#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <curl/curl.h>
#include <rapidjson/document.h>
#include <experimental/filesystem>

class AppManager {

public:
    AppManager() = delete;

    static void init(void);
    static void cleanup(void);

    static bool check_updates(void);
    static int update(void); // Precondition: check_updates was run

    static std::string w_directory;

private:
    static CURL* curl;
    static rapidjson::Document github_latest;
    static rapidjson::Document config;

    static size_t write_string(void*, size_t, size_t, void*);
    static size_t write_file(void*, size_t, size_t, FILE*);
    static int progress_func(void*, curl_off_t, curl_off_t, curl_off_t, curl_off_t);

    static void init_working_dir(void);

};

#endif // APPMANAGER_H
