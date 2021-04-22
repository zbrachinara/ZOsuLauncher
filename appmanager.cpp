#include <QDebug>

#include <iostream>
#include <fstream>
#include <experimental/filesystem>
#include <curl/curl.h>
#include "rapidjson.h"

#include "appmanager.h"

using namespace rapidjson;
using namespace std;
namespace fs = std::experimental::filesystem;

CURL* AppManager::curl;
Document AppManager::github_latest;
Document AppManager::config;
string AppManager::w_directory;

void AppManager::init(void) {

    qDebug() << "running init()";

    w_directory = (std::string) getenv("HOME") + "/.local/share/ZOsuLauncher";

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "ZOsuLauncher/1.0");
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
    } else {
        cout << "failed to init curl" << endl;
    }

    init_working_dir();
    check_updates();


}

void AppManager::cleanup(void) {

    qDebug() << "running cleanup()";

    curl_easy_cleanup(curl);

}

bool AppManager::check_updates(void) {

    qDebug() << "running check_updates()";

    string github_request;

    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/ppy/osu/releases/latest");
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_string);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &github_request);

    int res = curl_easy_perform(curl);

    qDebug() << &(github_request[0]);
    github_latest.Parse(&(github_request[0]));

    if (res != CURLE_OK) {
        throw res;
    }

    string latest_version = github_latest["tag_name"].GetString();
    string current_version = config["version"].GetString();
    if (latest_version.compare(current_version) != 0) {
         update();
    }

    ofstream tmpa(w_directory + "/config.json");
    OStreamWrapper tmpb(tmpa);
    Writer<OStreamWrapper> writer(tmpb);
    config.Accept(writer);

    return 0;

}

int AppManager::update(void) {

    qDebug() << "running update()";

    string target = "osu.AppImage";
    string exec_path = w_directory + "/osu.AppImage";
    string exec_source;

    // from github_latest: Get correct executable
    const Value &assets = github_latest["assets"];
    for (auto &asset : assets.GetArray()) {
        if (target.compare(asset["name"].GetString()) == 0) {
            exec_source = asset["browser_download_url"].GetString();
        }
    }

    FILE* exec_file = fopen(&(exec_path[0]), "wb");
    curl_easy_setopt(curl, CURLOPT_URL, &(exec_source[0]));
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_file);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, exec_file);
    int res = curl_easy_perform(curl);

    if (res == CURLE_OK) {
        string new_ver_str = github_latest["tag_name"].GetString();
        Value new_ver(github_latest["tag_name"].GetString(), config.GetAllocator());

        config["version"].Swap(new_ver);
    }

    fclose(exec_file);

    return res;

}

size_t AppManager::write_string(void* contents, size_t size, size_t nmemb, void* userp) {

    ((string*) userp)->append((char*) contents, size * nmemb);
    return size * nmemb;

}

size_t AppManager::write_file(void* contents, size_t size, size_t nmemb, FILE* userp) {

    size_t written = fwrite(contents, size, nmemb, userp);
    return written;

}

void AppManager::init_working_dir(void) {

    qDebug() << "running init_working_dir()";

    if (!fs::exists(w_directory)) {
        fs::create_directory(w_directory);
    }

    string config_path = w_directory + "/config.json";
    if (!fs::exists(config_path)) {
        config.SetObject();

        // add elements
        Value version("unknown");
        config.AddMember("version", version, config.GetAllocator());

        ofstream tmpa(config_path);
        OStreamWrapper tmpb(tmpa);
        Writer<OStreamWrapper> writer(tmpb);
        config.Accept(writer);

    } else { // config exists
        ifstream tmpa(config_path);
        IStreamWrapper tmpb(tmpa);
        config.ParseStream(tmpb);
    }

    string exec_path = w_directory + "/osu.AppImage"; //TODO cross platform?
    if (!fs::exists(exec_path)) {
        check_updates();
    }

}
