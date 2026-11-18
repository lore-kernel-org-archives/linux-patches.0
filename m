Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054580;
	b=MmXN7P3jg8+b8QfEq4JFpv2b16nRscQYe8JLa2vMOeuUgO7nOnHnptonGan5QkhqzeEx
	 uTbOhaBxsO7ohUCSA7DcgFwGo/4ExdX5Dhmni4uUxuHK+j3n4stxuYwk4KZLnz5OgVLxV
	 C0NPPQGGrIMrgZELr8WENmiTpiuSuopSdi8k1RN+O6ch4ZDz+zBUAtX0GlZdiu9ELATB4
	 6il2JofY6BG1bc3k0KhmBe4QglwvdfOOiNTh9XtFUcQw6y6cuTCFGUzf/nhqAXdYlo6Jt
	 MVTrkux3VQlVdYpLwSBAzi9V81LsZj6ImNEpSYtHu479nAAW/HF+th9qhCRhR/CdltQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ytdOeU+nWKBTBTqf83HHQ8LzwKV74G1ytqZOmC2gF0=;
	b=IzACm/nWGzn9HODTsEIo8DOfWMVVTD0Z0MwzAw2ihWJ2HIfKKI6UiPvLCpGTWVkKXlXt
	 dsa6hnknx8sXegoJlJRrA9Lfe2ZZ0REgfe4/TjYpGEJWe1DMU1R0Ivahd7UP6dDfDU02e
	 wdjOUf+zS0uY3SPYDjhDv9jo3L9QpDcAG9UnDSwG+h5cqW3gAkhqEqKviXghOhCzmWLN4
	 LRFxzdNTCjw5zsiDzQn7Bzbe9jasifYcd16ahHA2JWnJqujQyfMgS1TDKQe7LvBJ8cMg+
	 lsSpYnhbFUVcV01Dbbd+BBD5B1C5nM2Dc7c1n++/2i4VIyqK5i0UbMHoHZXLx15I3Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjwl4wTY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB52606A320;
	Thu, 19 Nov 2026 02:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjwl4wTY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75761F000C4;
	Thu, 19 Nov 2026 02:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054580;
	bh=4ytdOeU+nWKBTBTqf83HHQ8LzwKV74G1ytqZOmC2gF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjwl4wTYv7JlCq7flCsR6Y3Gd9FyC85pk3YLhjD8P0yj8XCzS6c8TH1gNLxaJft05
	 77E5KkslIMRXQXtCzGZw9c/A4141bQxD+Cre/e00et5G9fc8TqbaECE6zcRDXYFhUY
	 3c4grhkK5ntrx8AyO+KhRoXCU6cQ9DGgQLCrYU7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Neal Gompa <neal@gompa.dev>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 5.15 1324/2214] sign-file,extract-cert: use pkcs11 provider for OPENSSL MAJOR >= 3
Date: Wed, 18 Nov 2026 15:50:00 +0100
Message-ID: <20261118150104.409065912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

commit 558bdc45dfb2669e1741384a0c80be9c82fa052c upstream.

ENGINE API has been deprecated since OpenSSL version 3.0 [1].
Distros have started dropping support from headers and in future
it will likely disappear also from library.

It has been superseded by the PROVIDER API, so use it instead
for OPENSSL MAJOR >= 3.

[1] https://github.com/openssl/openssl/blob/master/README-ENGINES.md

[jarkko: fixed up alignment issues reported by checkpatch.pl --strict]

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/extract-cert.c |  103 ++++++++++++++++++++++++++++++++++---------------
 scripts/sign-file.c    |   95 +++++++++++++++++++++++++++++++--------------
 2 files changed, 139 insertions(+), 59 deletions(-)

--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -21,17 +21,18 @@
 #include <openssl/bio.h>
 #include <openssl/pem.h>
 #include <openssl/err.h>
-#include <openssl/engine.h>
-
+#if OPENSSL_VERSION_MAJOR >= 3
+# define USE_PKCS11_PROVIDER
+# include <openssl/provider.h>
+# include <openssl/store.h>
+#else
+# if !defined(OPENSSL_NO_ENGINE) && !defined(OPENSSL_NO_DEPRECATED_3_0)
+#  define USE_PKCS11_ENGINE
+#  include <openssl/engine.h>
+# endif
+#endif
 #include "ssl-common.h"
 
-/*
- * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
- *
- * Remove this if/when that API is no longer used
- */
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-
 #define PKEY_ID_PKCS7 2
 
 static __attribute__((noreturn))
@@ -61,6 +62,66 @@ static void write_cert(X509 *x509)
 		fprintf(stderr, "Extracted cert: %s\n", buf);
 }
 
+static X509 *load_cert_pkcs11(const char *cert_src)
+{
+	X509 *cert = NULL;
+#ifdef USE_PKCS11_PROVIDER
+	OSSL_STORE_CTX *store;
+
+	if (!OSSL_PROVIDER_try_load(NULL, "pkcs11", true))
+		ERR(1, "OSSL_PROVIDER_try_load(pkcs11)");
+	if (!OSSL_PROVIDER_try_load(NULL, "default", true))
+		ERR(1, "OSSL_PROVIDER_try_load(default)");
+
+	store = OSSL_STORE_open(cert_src, NULL, NULL, NULL, NULL);
+	ERR(!store, "OSSL_STORE_open");
+
+	while (!OSSL_STORE_eof(store)) {
+		OSSL_STORE_INFO *info = OSSL_STORE_load(store);
+
+		if (!info) {
+			drain_openssl_errors(__LINE__, 0);
+			continue;
+		}
+		if (OSSL_STORE_INFO_get_type(info) == OSSL_STORE_INFO_CERT) {
+			cert = OSSL_STORE_INFO_get1_CERT(info);
+			ERR(!cert, "OSSL_STORE_INFO_get1_CERT");
+		}
+		OSSL_STORE_INFO_free(info);
+		if (cert)
+			break;
+	}
+	OSSL_STORE_close(store);
+#elif defined(USE_PKCS11_ENGINE)
+		ENGINE *e;
+		struct {
+			const char *cert_id;
+			X509 *cert;
+		} parms;
+
+		parms.cert_id = cert_src;
+		parms.cert = NULL;
+
+		ENGINE_load_builtin_engines();
+		drain_openssl_errors(__LINE__, 1);
+		e = ENGINE_by_id("pkcs11");
+		ERR(!e, "Load PKCS#11 ENGINE");
+		if (ENGINE_init(e))
+			drain_openssl_errors(__LINE__, 1);
+		else
+			ERR(1, "ENGINE_init");
+		if (key_pass)
+			ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0), "Set PKCS#11 PIN");
+		ENGINE_ctrl_cmd(e, "LOAD_CERT_CTRL", 0, &parms, NULL, 1);
+		ERR(!parms.cert, "Get X.509 from PKCS#11");
+		cert = parms.cert;
+#else
+		fprintf(stderr, "no pkcs11 engine/provider available\n");
+		exit(1);
+#endif
+	return cert;
+}
+
 int main(int argc, char **argv)
 {
 	char *cert_src;
@@ -86,28 +147,10 @@ int main(int argc, char **argv)
 		fclose(f);
 		exit(0);
 	} else if (!strncmp(cert_src, "pkcs11:", 7)) {
-		ENGINE *e;
-		struct {
-			const char *cert_id;
-			X509 *cert;
-		} parms;
-
-		parms.cert_id = cert_src;
-		parms.cert = NULL;
+		X509 *cert = load_cert_pkcs11(cert_src);
 
-		ENGINE_load_builtin_engines();
-		drain_openssl_errors(__LINE__, 1);
-		e = ENGINE_by_id("pkcs11");
-		ERR(!e, "Load PKCS#11 ENGINE");
-		if (ENGINE_init(e))
-			drain_openssl_errors(__LINE__, 1);
-		else
-			ERR(1, "ENGINE_init");
-		if (key_pass)
-			ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0), "Set PKCS#11 PIN");
-		ENGINE_ctrl_cmd(e, "LOAD_CERT_CTRL", 0, &parms, NULL, 1);
-		ERR(!parms.cert, "Get X.509 from PKCS#11");
-		write_cert(parms.cert);
+		ERR(!cert, "load_cert_pkcs11 failed");
+		write_cert(cert);
 	} else {
 		BIO *b;
 		X509 *x509;
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -27,18 +27,19 @@
 #include <openssl/evp.h>
 #include <openssl/pem.h>
 #include <openssl/err.h>
-#include <openssl/engine.h>
-
+#if OPENSSL_VERSION_MAJOR >= 3
+# define USE_PKCS11_PROVIDER
+# include <openssl/provider.h>
+# include <openssl/store.h>
+#else
+# if !defined(OPENSSL_NO_ENGINE) && !defined(OPENSSL_NO_DEPRECATED_3_0)
+#  define USE_PKCS11_ENGINE
+#  include <openssl/engine.h>
+# endif
+#endif
 #include "ssl-common.h"
 
 /*
- * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
- *
- * Remove this if/when that API is no longer used
- */
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-
-/*
  * Use CMS if we have openssl-1.0.0 or newer available - otherwise we have to
  * assume that it's not available and its header file is missing and that we
  * should use PKCS#7 instead.  Switching to the older PKCS#7 format restricts
@@ -106,28 +107,64 @@ static int pem_pw_cb(char *buf, int len,
 	return pwlen;
 }
 
-static EVP_PKEY *read_private_key(const char *private_key_name)
+static EVP_PKEY *read_private_key_pkcs11(const char *private_key_name)
 {
-	EVP_PKEY *private_key;
+	EVP_PKEY *private_key = NULL;
+#ifdef USE_PKCS11_PROVIDER
+	OSSL_STORE_CTX *store;
+
+	if (!OSSL_PROVIDER_try_load(NULL, "pkcs11", true))
+		ERR(1, "OSSL_PROVIDER_try_load(pkcs11)");
+	if (!OSSL_PROVIDER_try_load(NULL, "default", true))
+		ERR(1, "OSSL_PROVIDER_try_load(default)");
+
+	store = OSSL_STORE_open(private_key_name, NULL, NULL, NULL, NULL);
+	ERR(!store, "OSSL_STORE_open");
+
+	while (!OSSL_STORE_eof(store)) {
+		OSSL_STORE_INFO *info = OSSL_STORE_load(store);
+
+		if (!info) {
+			drain_openssl_errors(__LINE__, 0);
+			continue;
+		}
+		if (OSSL_STORE_INFO_get_type(info) == OSSL_STORE_INFO_PKEY) {
+			private_key = OSSL_STORE_INFO_get1_PKEY(info);
+			ERR(!private_key, "OSSL_STORE_INFO_get1_PKEY");
+		}
+		OSSL_STORE_INFO_free(info);
+		if (private_key)
+			break;
+	}
+	OSSL_STORE_close(store);
+#elif defined(USE_PKCS11_ENGINE)
+	ENGINE *e;
+
+	ENGINE_load_builtin_engines();
+	drain_openssl_errors(__LINE__, 1);
+	e = ENGINE_by_id("pkcs11");
+	ERR(!e, "Load PKCS#11 ENGINE");
+	if (ENGINE_init(e))
+		drain_openssl_errors(__LINE__, 1);
+	else
+		ERR(1, "ENGINE_init");
+	if (key_pass)
+		ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0), "Set PKCS#11 PIN");
+	private_key = ENGINE_load_private_key(e, private_key_name, NULL, NULL);
+	ERR(!private_key, "%s", private_key_name);
+#else
+	fprintf(stderr, "no pkcs11 engine/provider available\n");
+	exit(1);
+#endif
+	return private_key;
+}
 
+static EVP_PKEY *read_private_key(const char *private_key_name)
+{
 	if (!strncmp(private_key_name, "pkcs11:", 7)) {
-		ENGINE *e;
-
-		ENGINE_load_builtin_engines();
-		drain_openssl_errors(__LINE__, 1);
-		e = ENGINE_by_id("pkcs11");
-		ERR(!e, "Load PKCS#11 ENGINE");
-		if (ENGINE_init(e))
-			drain_openssl_errors(__LINE__, 1);
-		else
-			ERR(1, "ENGINE_init");
-		if (key_pass)
-			ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0),
-			    "Set PKCS#11 PIN");
-		private_key = ENGINE_load_private_key(e, private_key_name,
-						      NULL, NULL);
-		ERR(!private_key, "%s", private_key_name);
+		return read_private_key_pkcs11(private_key_name);
 	} else {
+		EVP_PKEY *private_key;
 		BIO *b;
 
 		b = BIO_new_file(private_key_name, "rb");
@@ -136,9 +173,9 @@ static EVP_PKEY *read_private_key(const
 						      NULL);
 		ERR(!private_key, "%s", private_key_name);
 		BIO_free(b);
-	}
 
-	return private_key;
+		return private_key;
+	}
 }
 
 static X509 *read_x509(const char *x509_name)


