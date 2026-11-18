Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016062;
	b=QAKPoeZARlHe84s5WM/aaU21oiyFdzQqmXKMyo5m1m671/RazeaXSq8CgT9rvFao0f4X
	 jWOWHOKekgjLGY+2xjXD9KnRGLVB1QlggYsCNzHbkOmgdivpVHpv4371nPD+jZzf3rBjr
	 5NHM84/sqNn7f1fveTUxw62Lv2ANwJ5xeLlTQfZF3q6AdvZKAhsc3nsi0vXMP6wg4+TH0
	 JxLHYk0il3KkKmbbRiNIFGiBW9P70CrdM2IeSqkFGg1UOoTYme0O0IMgyHDaWD8wYUFfB
	 hF8PBfQiA59ji+4uHvuiVBcr2q0dIrFq1C5moQiECbhGao55+yv6lh8NWPEhq4hGKtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZxQmnvS7tsdTF6QfCfONpBZVsutUbtBxqfvS3kodu1Q=;
	b=tYDxrhmegqlPDc4bGCPlERnDQVF5akckm1UeFGG62QQ/5RQjSGoAvqnY4MVwNdfY6xI+
	 Y1u4GLmY1PSdNnmQeb8o8gxJuqMecUNXFGZ0OIm2rLfVreAMpnr6VP3//WO3BSrWVAb62
	 fskkH0KEIVuRFpQy2NeyWJ/BFWYwDE2caHaWmm9/OPM3/qKdiZbH1jAjb6bo+2+0Md3Kb
	 6uEtGV0C7dI4pWuhzyx3n8trIXkNdZqgxcJXG23ZO0Cl0n6SY2IiMM0zOx9GxgUfhrC0/
	 FCsE992ZXFBzelzW271/rD5l1p7om+mukwQgjcRbqQlZ0x14GP9lO7Gs29PiZHwegjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbcm15dG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B782606A336;
	Wed, 18 Nov 2026 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbcm15dG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129D11F000C4;
	Wed, 18 Nov 2026 15:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016061;
	bh=ZxQmnvS7tsdTF6QfCfONpBZVsutUbtBxqfvS3kodu1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbcm15dGCMDEivy0kkQ7tZFfgnqTH/1tIAOHbn1/CU/18yGcGKpFQrT7tY+kKEqV9
	 5OtKQNgeWtoSXKBFPw8QxCXgXDxYV+hqNbWix35rP5NUupSrv/z7r7pRvgykZ9eh3Y
	 i6JUwLA/tHt1MGnTVspwFf1L+kPoVWKs8rnj4Bwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0396/2651] crypto: mxs-dcp - handle zero-length skcipher requests
Date: Wed, 18 Nov 2026 15:27:16 +0100
Message-ID: <20261118150302.091333879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c75a069997876..d104d958cb61a 100644
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



