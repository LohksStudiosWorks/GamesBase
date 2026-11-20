#pragma once

#include <httplib.h>

#include <string>

namespace SDL3_plus {
    const std::string& get_ca_certificate();
    void apply_ca_certificate_on(httplib::Client& cli);
}