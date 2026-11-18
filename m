Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054575;
	b=VyLvonmwnANQ+bxkVRnckmJXh5pluaIegcymVZcrw+RhTJJqqSt6JMx3YjEBdvx+Tm3C
	 MUvR/VLYa6szRQBoNr1kuh75Cx7+cFEWcTohCaZfaCikPjwLQCDhu8yyGspWBkoE3i3tR
	 5vRMTxU/MFx8yG7PyhGBhmqu0z/nSpup3g4LkbQc/GFeeZDHHOeJjyXMdc1lblhBErcEG
	 cs+ajHepB1UqIPujrn8iPLkeio+5g5wnrJO+Aa43559iOZDXgPcOGjBNhOObTLOqL8mns
	 MLTzKDsnat25VjjYppXFp4Ff4OrRXFSOF8D5gpONywqEwPvQKJ+T4EdAcxjw7Lu6gNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Spv5q76Qkfsnq4DvVHcJUnrB+P7dYLLTGpDBwQOgNcE=;
	b=sicX+ZeIGNE1D23P9ut1gRPNBBn1xYfiy7BIUDFdt41Tx3QV9kbFXVPKSuo5EcaeRusH
	 k+NPO90goF/P5HGCz+Zip7XaYfI2yelYfsDObbolOH0Eec+TVulQ2/WD3iam/HZB8tr/C
	 8mdQ6qEWpvQ/9iFy1FkaAa3BtOsKLQcK/W+Sf+JzuPyl1vgb2wblBVCvxuYw2JA17Wcf8
	 jzjiL0H5iuBr77vQmbnP4Msr8xe19OMdcWY64Kwa9kcJ6ZhdfeypmvYqNhEDcQQ4lkVdK
	 3oTpJEoD105oeQVk9fmsud0ASbXBLQI/nAsbtYxBOYrfiGCCffqXOLMQ8ihSp6CvhoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R3de2/Lw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA6C606A335;
	Thu, 19 Nov 2026 02:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R3de2/Lw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9AE1F000C5;
	Thu, 19 Nov 2026 02:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054574;
	bh=Spv5q76Qkfsnq4DvVHcJUnrB+P7dYLLTGpDBwQOgNcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3de2/Lw6dxEiVBCCD+6EoBQxO0Ll9EjMfpgJ0RghYwIvJBXZb9m4fBXn/fk6NDuP
	 HynVynRo/LUOGNHTRtvNzRXuikCkE0boncBrxS8otSXGilxX3KVataibHBOhNdAtTz
	 pcj4nTfO20wDIxwbHAvxNxL5zBUiEOi8Laj0DBMA=
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
Subject: [PATCH 5.15 1322/2214] sign-file,extract-cert: move common SSL helper functions to a header
Date: Wed, 18 Nov 2026 15:49:58 +0100
Message-ID: <20261118150104.342078893@linuxfoundation.org>
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

commit 300e6d4116f956b035281ec94297dc4dc8d4e1d3 upstream.

Couple error handling helpers are repeated in both tools, so
move them to a common header.

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[luca.weiss@fairphone.com: Backport to 5.15]
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS            |    1 +
 scripts/extract-cert.c |   37 ++-----------------------------------
 scripts/sign-file.c    |   37 ++-----------------------------------
 scripts/ssl-common.h   |   39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 70 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4347,6 +4347,7 @@ F:	Documentation/admin-guide/module-sign
 F:	certs/
 F:	scripts/extract-cert.c
 F:	scripts/sign-file.c
+F:	scripts/ssl-common.h
 
 CFAG12864B LCD DRIVER
 M:	Miguel Ojeda <ojeda@kernel.org>
--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -23,6 +23,8 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+#include "ssl-common.h"
+
 /*
  * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
  *
@@ -40,41 +42,6 @@ void format(void)
 	exit(2);
 }
 
-static void display_openssl_errors(int l)
-{
-	const char *file;
-	char buf[120];
-	int e, line;
-
-	if (ERR_peek_error() == 0)
-		return;
-	fprintf(stderr, "At main.c:%d:\n", l);
-
-	while ((e = ERR_get_error_line(&file, &line))) {
-		ERR_error_string(e, buf);
-		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
-	}
-}
-
-static void drain_openssl_errors(void)
-{
-	const char *file;
-	int line;
-
-	if (ERR_peek_error() == 0)
-		return;
-	while (ERR_get_error_line(&file, &line)) {}
-}
-
-#define ERR(cond, fmt, ...)				\
-	do {						\
-		bool __cond = (cond);			\
-		display_openssl_errors(__LINE__);	\
-		if (__cond) {				\
-			err(1, fmt, ## __VA_ARGS__);	\
-		}					\
-	} while(0)
-
 static const char *key_pass;
 static BIO *wb;
 static char *cert_dst;
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -29,6 +29,8 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+#include "ssl-common.h"
+
 /*
  * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
  *
@@ -83,41 +85,6 @@ void format(void)
 	exit(2);
 }
 
-static void display_openssl_errors(int l)
-{
-	const char *file;
-	char buf[120];
-	int e, line;
-
-	if (ERR_peek_error() == 0)
-		return;
-	fprintf(stderr, "At main.c:%d:\n", l);
-
-	while ((e = ERR_get_error_line(&file, &line))) {
-		ERR_error_string(e, buf);
-		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
-	}
-}
-
-static void drain_openssl_errors(void)
-{
-	const char *file;
-	int line;
-
-	if (ERR_peek_error() == 0)
-		return;
-	while (ERR_get_error_line(&file, &line)) {}
-}
-
-#define ERR(cond, fmt, ...)				\
-	do {						\
-		bool __cond = (cond);			\
-		display_openssl_errors(__LINE__);	\
-		if (__cond) {				\
-			err(1, fmt, ## __VA_ARGS__);	\
-		}					\
-	} while(0)
-
 static const char *key_pass;
 
 static int pem_pw_cb(char *buf, int len, int w, void *v)
--- /dev/null
+++ b/scripts/ssl-common.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: LGPL-2.1+ */
+/*
+ * SSL helper functions shared by sign-file and extract-cert.
+ */
+
+static void display_openssl_errors(int l)
+{
+	const char *file;
+	char buf[120];
+	int e, line;
+
+	if (ERR_peek_error() == 0)
+		return;
+	fprintf(stderr, "At main.c:%d:\n", l);
+
+	while ((e = ERR_get_error_line(&file, &line))) {
+		ERR_error_string(e, buf);
+		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
+	}
+}
+
+static void drain_openssl_errors(void)
+{
+	const char *file;
+	int line;
+
+	if (ERR_peek_error() == 0)
+		return;
+	while (ERR_get_error_line(&file, &line)) {}
+}
+
+#define ERR(cond, fmt, ...)				\
+	do {						\
+		bool __cond = (cond);			\
+		display_openssl_errors(__LINE__);	\
+		if (__cond) {				\
+			errx(1, fmt, ## __VA_ARGS__);	\
+		}					\
+	} while (0)


