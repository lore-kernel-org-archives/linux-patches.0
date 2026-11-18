Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060318;
	b=41gwn3+0ihTMhTHQ+JId1fHMYfGT3/HqKAl/9BqL7m71bOYVp6VYx1jOibCSFkUuMhsS
	 CLcbCUaOA0OkUD+asS4OTJC3P4765cNZJwSUnY5a/MpRX8D3E5+tv5CcG4IRja9UNEg/o
	 tPXVZd2HP/krxNgTV43FW52IMu584UNILL5FpHkfOIMBBlU2j1JV/NBnGAKJ+45w1MtPs
	 xiNM/ayJ/EuE+jLw1FrCa3eFgcrM54sUO9OS4SiV0/m8KnPMfOIWe4RyhpjeRIQBe9K8V
	 N5rzyPnhsun2IN8TILvUfD8AvjaMFyoar0/ac2b7BjJpIeVKAlfSMUzSU0omMlfqYaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EZHrJrFmxRwajG5GiyO3T5m/LkRZzssOmj9xkVJiYzQ=;
	b=y5a+P7YJl9gm0BYr2v4MbZPi94dc9DSuXKPTY9EeSJxQZyItBrX9gtMDIoi6pGzqQ3ux
	 vzNF6sM0K1BzpyYoOeXgm6MRxDo+8HhgPPia5Idu9ryvlMxIs59uzMwTNVjBCDle6W+DM
	 6CGI3cMO8mctA5aXUEJaMHRVMaAR2RF0QPWElbO6Ipa8kCuz3HcsjWKqopGda6+qDMkE5
	 gTjNMPurrBl93oue0QxQc46KUvIKb1LRWgUcPlYXy6QLtLgfYKAtFBTIzDSn3TykjTyky
	 r+FkeDrrqzLZS80YpdV01CzLz5GulEJraqTWG2bWiSkqWmx7tXLS9bKy5BeBISIFMvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFDF6Ho8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A1A606A320;
	Thu, 19 Nov 2026 03:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFDF6Ho8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF54B1F000C4;
	Thu, 19 Nov 2026 03:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060318;
	bh=EZHrJrFmxRwajG5GiyO3T5m/LkRZzssOmj9xkVJiYzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFDF6Ho8S3hL/z9CxdRBSc/D3jkoSA8DQeqySMa0p+esPYKH8I1nYfAczZEhHWOla
	 4PaDhK3xZqcLH4V3gy5jRKdhDuVjUfxBMprmUhaBgOP4Xu7MuX7PAH0XZ+3UEk3ahi
	 WpjOs8pMbpljjY3RP0SE9B/aGnrqGqNa90QglFxM=
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
Subject: [PATCH 5.10 1115/1848] sign-file,extract-cert: avoid using deprecated ERR_get_error_line()
Date: Wed, 18 Nov 2026 15:52:33 +0100
Message-ID: <20261118150006.007528522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

commit 467d60eddf55588add232feda325da7215ddaf30 upstream.

ERR_get_error_line() is deprecated since OpenSSL 3.0.

Use ERR_peek_error_line() instead, and combine display_openssl_errors()
and drain_openssl_errors() to a single function where parameter decides
if it should consume errors silently.

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
 scripts/extract-cert.c |    4 ++--
 scripts/sign-file.c    |    6 +++---
 scripts/ssl-common.h   |   23 ++++++++---------------
 3 files changed, 13 insertions(+), 20 deletions(-)

--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -96,11 +96,11 @@ int main(int argc, char **argv)
 		parms.cert = NULL;
 
 		ENGINE_load_builtin_engines();
-		drain_openssl_errors();
+		drain_openssl_errors(__LINE__, 1);
 		e = ENGINE_by_id("pkcs11");
 		ERR(!e, "Load PKCS#11 ENGINE");
 		if (ENGINE_init(e))
-			drain_openssl_errors();
+			drain_openssl_errors(__LINE__, 1);
 		else
 			ERR(1, "ENGINE_init");
 		if (key_pass)
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -114,11 +114,11 @@ static EVP_PKEY *read_private_key(const
 		ENGINE *e;
 
 		ENGINE_load_builtin_engines();
-		drain_openssl_errors();
+		drain_openssl_errors(__LINE__, 1);
 		e = ENGINE_by_id("pkcs11");
 		ERR(!e, "Load PKCS#11 ENGINE");
 		if (ENGINE_init(e))
-			drain_openssl_errors();
+			drain_openssl_errors(__LINE__, 1);
 		else
 			ERR(1, "ENGINE_init");
 		if (key_pass)
@@ -273,7 +273,7 @@ int main(int argc, char **argv)
 
 		/* Digest the module data. */
 		OpenSSL_add_all_digests();
-		display_openssl_errors(__LINE__);
+		drain_openssl_errors(__LINE__, 0);
 		digest_algo = EVP_get_digestbyname(hash_algo);
 		ERR(!digest_algo, "EVP_get_digestbyname");
 
--- a/scripts/ssl-common.h
+++ b/scripts/ssl-common.h
@@ -3,7 +3,7 @@
  * SSL helper functions shared by sign-file and extract-cert.
  */
 
-static void display_openssl_errors(int l)
+static void drain_openssl_errors(int l, int silent)
 {
 	const char *file;
 	char buf[120];
@@ -11,28 +11,21 @@ static void display_openssl_errors(int l
 
 	if (ERR_peek_error() == 0)
 		return;
-	fprintf(stderr, "At main.c:%d:\n", l);
+	if (!silent)
+		fprintf(stderr, "At main.c:%d:\n", l);
 
-	while ((e = ERR_get_error_line(&file, &line))) {
+	while ((e = ERR_peek_error_line(&file, &line))) {
 		ERR_error_string(e, buf);
-		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
+		if (!silent)
+			fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
+		ERR_get_error();
 	}
 }
 
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
 #define ERR(cond, fmt, ...)				\
 	do {						\
 		bool __cond = (cond);			\
-		display_openssl_errors(__LINE__);	\
+		drain_openssl_errors(__LINE__, 0);	\
 		if (__cond) {				\
 			errx(1, fmt, ## __VA_ARGS__);	\
 		}					\


