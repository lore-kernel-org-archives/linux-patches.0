Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029458;
	b=3STnf7s9qT/jK0qVYPaXh1V4GD4rm2yW+vb2YQAoY2oils/WLSlnKeTAWA8UcW+whZLM
	 2qeu7uItySNGeizVCESoVdvDhavTcnjKhiNnztzq5EGmhJZVRxQ3egPuslGrU59nyVsJC
	 l7QFGMJ83COyrT4U1u7zWwjHDXnOcX9jxDk3/qDqOt23VJE/Tg9FstceQNLclmfQgBQB2
	 YfoN0SdlkXC03xOPlVTL6Cnq7R3Iy/DValEh1I6uh8aWLQ9nfu930aV4NTkhLp7EL8W9p
	 pyhFHXSW90u0yfor3r3VMnZ+g5TqiDTfllHzu5N+XQgUoufnChHNe+H8pNIml2S8ebA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rRNWWkVO44roZrpWilIB7YjeBtY6wgqeyAZMq7z74hI=;
	b=1YyPKOkz04QUUU49RBc6jXhJklXQz6jfx3C1+AuvIj/LIaFWcHQ9s6G47TTmjjREt6Cc
	 4jhkTGJznCvpheEJnNZA4YFiaVn1RR3a0djbJbWBGAcLnUo8FJy9WvuyeVTG27MkL9t1c
	 +Z/Z2Ei89/Y/TUvGlO1Z3nwcAz4IlOQRDkUXNGDrDLSeZWVIdn7UWQVzP2u/r7/SJ4ITF
	 8laCm5BqQH3Scuo5MKKVDR1REB3lV5i3RMQHyhy4nPdl+CoeuNK3OyGpO9j2Rxh3ob0s9
	 sx2IBJR4t+lpKiPMzIhdnHXdtA60OolMmO1RcJOw15bYohJ0dzdbKMXASilSePR16cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrfMzb4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4425D606A320;
	Wed, 18 Nov 2026 19:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrfMzb4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957EF1F000C5;
	Wed, 18 Nov 2026 19:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029458;
	bh=rRNWWkVO44roZrpWilIB7YjeBtY6wgqeyAZMq7z74hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrfMzb4cdlsgUc+e+BZy9UoDItxkEdWviaH/I+Evu7pDYrY+mUXvq+bFbNPfDI9S5
	 uHaheua9clcMqULETO0xPWrXSq+79fQoerFmoeE0NJAXLf//Al5+GOy17LrHeKvRtP
	 aR38j7Om+ZU5KwQEODwj0TFUlanJlCd3pIyD66cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0356/1756] crypto: mxs-dcp - handle zero-length skcipher requests
Date: Wed, 18 Nov 2026 15:41:23 +0100
Message-ID: <20261118150022.515207054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit ac1d6a65a1e1f069f119df42c6b57dbdff5f6be8 ]

Zero-length skcipher requests are valid no-ops, but MXS-DCP queues them.
When such a request reaches the worker, last_out_len remains zero. The
CBC completion path then subtracts AES_BLOCK_SIZE from this unsigned
value when updating the IV, causing the offset to underflow. On
decryption, the resulting source address precedes aes_in_buf.

Return success before enqueueing zero-length requests. This avoids the
invalid source access and leaves the IV unchanged for a no-op.

Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 123f64e8460dc..eb80556c94b6e 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -473,6 +473,9 @@ static int mxs_dcp_aes_enqueue(struct skcipher_request *req, int enc, int ecb)
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	int ret;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(actx->key_len != AES_KEYSIZE_128 && !actx->key_referenced))
 		return mxs_dcp_block_fallback(req, enc);
 
-- 
2.53.0



