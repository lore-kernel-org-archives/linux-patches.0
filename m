Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060207;
	b=gZpdeXiS566FrfYxU/dobPwhMGDbTq9jfFgagvSTcMx0zRvh6NYH0upuehqwVp6rT3la
	 Egrqj0cCdmUH7AAFYVQf674i4fwfZpJ2fgL1thyWx3gF7rVEJmr+ScCbnmrHM3YyRaBDI
	 EiLu3IXrb3DMw2JQBg5zei6tycWy3+aKVBvE47uO4E59ad7CHG4havNvb7/JGFJBOceco
	 AxBv6g8VCN8G2FeNaLGLZEMaQhxeTjjVjRZvM1yKoeIzEl2pRcYS0aYHt9XtH/1p5zyBE
	 kWYTVBuO6LrMTvko2n4R0f5dNYk/fbs1BZ2Bctb27JhPR2E7fifJDLC86osVFJ7dPCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=piHWxKEMQPiDEZmunb59WBjcZSTLs08ojleLseMaQ+A=;
	b=u++GD/nQYIFRmmBhROc+K5Od49oHF4sSroNydtrwui4VaFDyOW+OOnkf7J2sDrSC2gyI
	 RFCAXH5PddkBeduDbpbbLaTml5WhPbFoa3DfBGnqqjfA2sTPqKrqM0Bd3tbPSC+wqjWb6
	 FfXnMh1SfWWZAtGGbjAAyVlTA9QLpYlvNp+W2zMerorSZpyKvIwb4+jAwTe8zkvBhOosc
	 vVF95wVYdLSgIrrhqHGZ4nAM1sGrBoXkDAy0d1vHCxrESZHb5YkL7PyY7OuLzhciCn43c
	 6Dgx15ozrzNMoCYGT4BhTbZQzz/iNk0WgJ8NlT6aOvS38tRG61+I2Gz2yjadG189vqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2aa6Exz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FA7606A320;
	Thu, 19 Nov 2026 03:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2aa6Exz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7A71F000C4;
	Thu, 19 Nov 2026 03:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060207;
	bh=piHWxKEMQPiDEZmunb59WBjcZSTLs08ojleLseMaQ+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2aa6ExztqgdBkvUZr4A6C4lRqFT3bl4OvM7D3EWYHq0nFixgoeHhEWIA7rc66R5c
	 OTiHlBFMrSIfUZpEaO8PZ8n2lfsLGYt4WlI1dMdMa5T/aLWxtSzYgsAqvqBpTmVkxX
	 GvNoDXabJnEj9ulfhv7NfxRATO+zzWG5xdnwxlj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 5.10 1117/1848] extract-cert: Wrap key_pass with #ifdef USE_PKCS11_ENGINE
Date: Wed, 18 Nov 2026 15:52:35 +0100
Message-ID: <20261118150006.085507655@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 4f96b7c68a9904e01049ef610d701b382dca9574 upstream.

A recent strengthening of -Wunused-but-set-variable (enabled with -Wall)
in clang under a new subwarning, -Wunused-but-set-global, points out an
unused static global variable in certs/extract-cert.c:

  certs/extract-cert.c:46:20: error: variable 'key_pass' set but not used [-Werror,-Wunused-but-set-global]
     46 | static const char *key_pass;
        |                    ^

After commit 558bdc45dfb2 ("sign-file,extract-cert: use pkcs11 provider
for OPENSSL MAJOR >= 3"), key_pass is only used with the OpenSSL engine
API, not the new provider API. Wrap key_pass's declaration and
assignment with '#ifdef USE_PKCS11_ENGINE' so that it is only included
with its use to clear up the warning. While this is a little uglier than
just marking key_pass with the unused attribute, this will make it
easier to clean up all code associated with the use of the engine API if
it were ever removed in the future. While in the area, use a tab for
the key_pass assignment line to match the rest of the file.

Cc: stable@vger.kernel.org
Fixes: 558bdc45dfb2 ("sign-file,extract-cert: use pkcs11 provider for OPENSSL MAJOR >= 3")
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://patch.msgid.link/20260325-certs-extract-cert-key_pass-unused-but-set-global-v1-1-ecf94326d532@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/extract-cert.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -43,7 +43,9 @@ void format(void)
 	exit(2);
 }
 
+#ifdef USE_PKCS11_ENGINE
 static const char *key_pass;
+#endif
 static BIO *wb;
 static char *cert_dst;
 static int kbuild_verbose;
@@ -132,7 +134,9 @@ int main(int argc, char **argv)
 
 	kbuild_verbose = atoi(getenv("KBUILD_VERBOSE")?:"0");
 
-        key_pass = getenv("KBUILD_SIGN_PIN");
+#ifdef USE_PKCS11_ENGINE
+	key_pass = getenv("KBUILD_SIGN_PIN");
+#endif
 
 	if (argc != 3)
 		format();


