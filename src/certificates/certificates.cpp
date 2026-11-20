#include <SDL3_plus/flags/flags.hpp>
#if SDL3PLUS_ENABLE_HTTP

#include <SDL3_plus/certificates/certificates.hpp>
#include <battery/embed.hpp>

#ifndef SDL3PLUS_CERTIFICATE_KEY
#error Certificate macro missing. Build is incomplete.
#endif

namespace SDL3_plus {

    const std::string& get_ca_certificate() {
        static std::string cert;
        if (!cert.empty()) return cert;

        const auto embed = b::embed<SDL3PLUS_CERTIFICATE_KEY>();
        cert = embed.str();
        return cert;
    }

    void apply_ca_certificate_on(httplib::Client& cli) {
        const auto& cert = get_ca_certificate();
        cli.load_ca_cert_store(cert.data(), cert.size());
    }

}

#endif