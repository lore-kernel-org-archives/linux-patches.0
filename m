Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050467;
	b=DSBOg9D7SL7IAr0qmNJrXKCKbiqPVozGcrih69NCmrxWRdDVOYeZpjNvCCvIZZWfNDbv
	 ilrYo7VRyta4pV57WcdZIJq7Z9JXp2Gv/BWMxyAmaqEMVuuaC7bItklBgRwVO8JEecylg
	 W88+u9Nz0eS1YMWkJait+5XlX7QZc1MsjFs0pQM0hQMgoIdv0eQJ7kBjWudNHIF0D2L6A
	 gHRlrPMa2u2GhvOiyHZE7KwjgldxTvb6Oo/Au7bYNq1ub1/XgbpGvZOJPiV9kGTpiZf3n
	 wEqx/DWgH2Xm2Nvmnpj33G3MHpdyn2KEivOXPYUW6A0tPJ7G1Eu7SgULn8kL5ZFWwiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zDpty1OjYnm9Z9aJT83EwH8OVhEgocXUFBYXFY/2k9A=;
	b=3uWucRco78O+KYlxk8/cN7ASS0BrVSPmRI5Q7CKbbNNwwur/y/z8/h9aHaDnIuQYaWkh
	 saRuMH3xudbFpug/8uPZLDB2PRcguOsXfG0ukCKZCU0st+59wHONQVNNM7HEieIrqxDS7
	 noFXO8mNrGXTou4tseAgG25T5pyqtiJfs4CladzztaqgMF3LzlUKIW3ZOnoLGQhS+Wdc3
	 ikhA1XEj45dOST97EWhA3Xpi/h1U8UPpF433V8Lo2kNYQrL5JWEU1CRnuPNbczVBdUduI
	 VjdiBzMsgWYPuv+iDhWbF+jI4CthAzkZv71/olAjVV5emG+AkQID2DmPsqKiLC+Wslg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nS8KZhap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93406606A31C;
	Thu, 19 Nov 2026 01:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nS8KZhap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82C81F000C5;
	Thu, 19 Nov 2026 01:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050467;
	bh=zDpty1OjYnm9Z9aJT83EwH8OVhEgocXUFBYXFY/2k9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nS8KZhap1iUCbMbRQTUZoFIKDUe30NxT5l3HirSKhV3zfcVW3D+WeK4HR8Pj6u2Og
	 MepWsMsDBFJNJDFGg2ZdCpxU7DVnl1qA5xwCkwdUG4eKzz26YZU7FFSCuVuZzL5N5t
	 Rsnfu4Awm9zr4qmujHtNbX1OdRrwVrKPkmK4mWPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2719/2857] net: tls: Pass union tls_crypto_context pointer to memzero_explicit
Date: Wed, 18 Nov 2026 16:02:33 +0100
Message-ID: <20261118150339.514767566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 0d9e699d3421b5db83eb0cb7a708882440ee78ef ]

Pass union tls_crypto_context pointer, rather than struct
tls_crypto_info pointer, to memzero_explicit().

The address of the pointer is the same before and after.
But the new construct means that the size of the dereferenced pointer type
matches the size being zeroed. Which aids static analysis.

As reported by Smatch:

  .../tls_main.c:842 do_tls_setsockopt_conf() error: memzero_explicit() 'crypto_info' too small (4 vs 56)

No functional change intended.
Compile tested only.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240708-tls-memzero-v2-1-9694eaf31b79@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c43c1c24f3cd ("tls: avoid field-spanning write when copying crypto info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 42d4266aec70c..1555b67e45a61 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -687,6 +687,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	struct tls_crypto_info *alt_crypto_info;
 	struct tls_context *ctx = tls_get_ctx(sk);
 	const struct tls_cipher_desc *cipher_desc;
+	union tls_crypto_context *crypto_ctx;
 	int rc = 0;
 	int conf;
 
@@ -705,13 +706,15 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 		return -EINVAL;
 
 	if (tx) {
-		crypto_info = &ctx->crypto_send.info;
+		crypto_ctx = &ctx->crypto_send;
 		alt_crypto_info = &ctx->crypto_recv.info;
 	} else {
-		crypto_info = &ctx->crypto_recv.info;
+		crypto_ctx = &ctx->crypto_recv;
 		alt_crypto_info = &ctx->crypto_send.info;
 	}
 
+	crypto_info = &crypto_ctx->info;
+
 	/* Currently we don't support set crypto info more than one time */
 	if (TLS_CRYPTO_INFO_READY(crypto_info))
 		return -EBUSY;
@@ -814,7 +817,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	return 0;
 
 err_crypto_info:
-	memzero_explicit(crypto_info, sizeof(union tls_crypto_context));
+	memzero_explicit(crypto_ctx, sizeof(*crypto_ctx));
 	return rc;
 }
 
-- 
2.53.0



