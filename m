Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054583;
	b=HqvY9SQV9zbzmVRZxkflq/1Jn2GjM2vnMIxInbU+gY2c5QGCQX1uMMplsXHVHEmgoC4a
	 +14ztAykL046gjB2rGA9tL5WDQS/oZS9Z3mPfaoK91Ndtv3oxOgdinFHDlxT1rxE1zblM
	 azDdFBe3lXQtVT/+lYUg70JIvAMe9tru7bueyI/mayc373Bf8J1ecGeUc3b0PLxPGmC8r
	 nlScaNpswOeyqQklIU7/5DVhRkkMEEWgpODluqR0aZasdPoh+g9DCldQl9KYUZx2gR+cY
	 VbIN3i4Kj28+/GtaDAUcb7JWIk+lO1W4X82YnpmnY9lcd9UivIDPSaSdy+eYB7/LkMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A/s8n8ZyfH3zw03NFT5JLSKBEtsHVnKBiOwFmBbLwLw=;
	b=f3O5IiXdrCQNOXWEiaeyNcK9n9ydwFlJdjft5xMDuYv8th85wNOaI7TPw/2QxoWxM96r
	 GOqjLvRElDDvTddm6X9NPXpy/tJLcXFzThmyIOe5Io3j3anr3P2Z0a6aWERgfLVun2axK
	 CtuMmpS5xwOUaAPsyBaVFeJY/ic2DOQgzQMTifDCRelxZbWK5GLjWVl5BjRCB2gU3+r0P
	 iTt2I2BRbDegGGL8ZcyYLZ77wLjw/lg9omPWu7/BuKwybkpKY0h79MvTUQYOKxFT9UoKH
	 hs6HR6jp0iQ4PBOBjE9OTANFiYlZY1gbaHWjoedhkx+T0g/j7yjgoSPOac4nu64AM4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysivRLOp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D648606A31C;
	Thu, 19 Nov 2026 02:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysivRLOp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776A21F000C4;
	Thu, 19 Nov 2026 02:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054583;
	bh=A/s8n8ZyfH3zw03NFT5JLSKBEtsHVnKBiOwFmBbLwLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysivRLOp0wkZEj9DXwkOgPYpFaIcvnHb3C0GaIeITqh4nSc2BAZ1P+/XjQJ8pWf5D
	 wud46Baduw2K/e+VPOXMaXLVX/HYnE04cDtqnyIwjYXiyazlDtrRRtCp1i+fIRzykJ
	 lFqjrolZ0PqZBIm/34Xv7hQJiaYpgRXi0eRUn1Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 5.15 1325/2214] extract-cert: Wrap key_pass with #ifdef USE_PKCS11_ENGINE
Date: Wed, 18 Nov 2026 15:50:01 +0100
Message-ID: <20261118150104.443875256@linuxfoundation.org>
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


