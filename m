Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042382;
	b=xIwmxr0f2hrDLN6A3XRKqKUzEwuBHh3cdf5RJiLRZdmWtGCYhg3HSGpjTOEmieGhvrIe
	 +J2vokR/tlrIDDWkZEnTKDVWApCXqGHTr0fjG9i/N065LB5BJpfIKfcP9NsHYoRV9JcN9
	 C4PtDdTJT3eFLt2M3oq631dgT4zH+JOS7HaWehAPFiDn8cuk0Cwtwinz+OsMRLg5UVqt0
	 pnpTT/NPE8TI/PYIdNaQUT+YqiS9z1BMlRvy9uocaFVkvIQSp1SC4YEEbFbO+CezAnKQ+
	 xnnLRT+lZd4BzIXYNtDcTi7o7/JJrvOozl7KmTC6oexBT5OuJC1bdWDX5LH88s+dpmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJ7Rt/9bo8NepgnHsHeUv5+zMtPsRNPILTPlx9df+1I=;
	b=QLZQSVOM52WHFF8JSO6FJeQKMAt9cSExLRsdZ5o32FHqMZM+84HfQ7q3CBE4/DuJyvWW
	 vCIX3IcFPG/q8CvaINBgJBC0V2kwJga5X7jaglWGnnkDisuMwMhNDHi8Xv435wJvwHCkX
	 6ByoadN3jkQCbRWi9KPUvCchllyUZl4yqpZbEBpq8/nSS5XcmIkN6AvquOjOSi7I++isO
	 1asau0TX/cegscVdJoDZHT1WhxuPzAi3ILUiyelF18IInD7Rdoa8DsPuMLSmHu4N/CkEw
	 FdzD16Y4Rz5fCaykEU/dL5AOcmDIQG/KzgSA9Ivm6hg8BQg/l0Ak7qKLe4dDCUhf+2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRbQW+UZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7D3606A31C;
	Wed, 18 Nov 2026 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRbQW+UZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185441F000C4;
	Wed, 18 Nov 2026 22:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042382;
	bh=jJ7Rt/9bo8NepgnHsHeUv5+zMtPsRNPILTPlx9df+1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRbQW+UZlfiwiGUoz6MvZrZIVtgICayYw9lx6FTbdh6aF7+1Y6v7X9OjswUJGVp2A
	 CtKwlEgXnn6k5oQ/7IUB896icwgcjStWhH+Hef9Z9tcB8WjKV/Xg1tUlxixneisN3Y
	 CwV7wJHdWSrxjAmIwy4lHmhJXblQnnfe9UJuFJ2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3150/3318] net: tls: Pass union tls_crypto_context pointer to memzero_explicit
Date: Wed, 18 Nov 2026 16:02:52 +0100
Message-ID: <20261118150454.364488799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d57336820ef0b..9d5c99f1e4e7c 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -589,6 +589,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	struct tls_crypto_info *alt_crypto_info;
 	struct tls_context *ctx = tls_get_ctx(sk);
 	const struct tls_cipher_desc *cipher_desc;
+	union tls_crypto_context *crypto_ctx;
 	int rc = 0;
 	int conf;
 
@@ -607,13 +608,15 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
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
@@ -716,7 +719,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	return 0;
 
 err_crypto_info:
-	memzero_explicit(crypto_info, sizeof(union tls_crypto_context));
+	memzero_explicit(crypto_ctx, sizeof(*crypto_ctx));
 	return rc;
 }
 
-- 
2.53.0



