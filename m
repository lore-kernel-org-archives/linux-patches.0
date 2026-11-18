Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059345;
	b=MJhVJF5EBxXJ2pSdj9gIF3PG+lfUPNNGxZYA5u0q5EZRzI78ZWSyfcY1YULkMj+wyPsT
	 EXiX3aqeHBQlnlfxN4FFbyjGG5h/n3J4zMJCq7KW3U93Q+KVBhl7QTJGH5LmdelqdS55i
	 qxPJT8M+G+i+gz6HR8+OLAwdKTMkouhGAgK4KjUpdyCYIAWhyicDSzUk6osnNQDQVoxLA
	 xynlq78/c9N1szfLGWao4E9TJnuAVWzHKfL6LD0CpLIqGBt7RK0AV2Km254b5Mu+udQoK
	 hYmqkLzJUwcwbtF0MSf2bTtk093hWWWgSGFUT0IlOArUs2Fj6qasaDNfhXN4kLdysUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tys/Tbjej0PXIbabandivLqGLqWNrbbvsercIV8AA8o=;
	b=scx1QzST5R8RI0uWYiPOayF+Iw40UoG1Yh9lXdqWkyfBqdHzxssAjUCjwPThCP0HBf6C
	 ZPOFEfEM8FN27Ycrsu98LAWq9EluDnyhRZ62u1vL5uTLqHYKVe7gfkmbAYpdkM6mJI7dj
	 tiX24I1Q+u5dd/9anuKRnkX/RvWbgoZkeIV7RmccKNHHzHkEyHjF6XQAOPbqG0PrgepoX
	 0t3kbyVMFc1MkraIV/pSmNtMWu89x8s8r9C/IMU2O17d0NS5IjNptxdB4aeO0GGhh8FkQ
	 3+z7TCIlw5YTEDjuh70/AD3NY23uoTLfb8jVd+nx0BnK9P2Bu+nzMrVRrD0t9YHtXoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxSvw1gi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D876606A31C;
	Thu, 19 Nov 2026 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxSvw1gi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7141F000C4;
	Thu, 19 Nov 2026 03:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059345;
	bh=tys/Tbjej0PXIbabandivLqGLqWNrbbvsercIV8AA8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxSvw1gim0xgKvPRE51vNOuzw78+lv1HYMTYTgoyPb06TfajtuC3GViF9C03LxwwE
	 0pdTA2OBom9dmEBjRLsz25vcqq2Mgn5I3Q8Jz8r1UV9c6lZ0yVeWW4rMu99w2OXYq/
	 8azDCfBVAXmqRq0fK5ZiIcne6l0vXSaq2njNuquA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0809/1848] crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent
Date: Wed, 18 Nov 2026 15:47:27 +0100
Message-ID: <20261118145950.181404202@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 40ec9605cb195e065470f8f23ef94b1b541411a3 ]

The HPRE driver hard-codes GFP_ATOMIC for RSA/DH and GFP_KERNEL for
ECDH. This may cause "scheduling while atomic" in atomic context or
unnecessary allocation failures under memory pressure.

Select GFP flags dynamically based on CRYPTO_TFM_REQ_MAY_SLEEP and
store them in hpre_asym_request::flags. The areq field is a union of
rsa/dh/ecdh request pointers; reading base.flags through any union
member other than the one that was written would be type-punning, so
a dedicated flags field avoids that.

Fixes: 98dfa9343f37 ("crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc mem during softirq")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: Omitted ECDH changes because the driver lacks ECDH support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 4477a781bc3f9..742bca5d6a146 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -96,6 +96,7 @@ struct hpre_asym_request {
 	int req_id;
 	hpre_cb cb;
 	struct timespec64 req_time;
+	u32 flags;
 };
 
 static int hpre_alloc_req_id(struct hpre_ctx *ctx)
@@ -201,6 +202,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 				struct scatterlist *data, unsigned int len,
 				int is_src, dma_addr_t *tmp)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = HPRE_DEV(ctx);
 	void *ptr;
@@ -210,7 +212,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_ATOMIC);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
@@ -455,6 +457,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 		h_req->cb = hpre_rsa_cb;
 		h_req->areq.rsa = akreq;
+		h_req->flags = akreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 	} else {
@@ -469,6 +472,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 		h_req->cb = hpre_dh_cb;
 		h_req->areq.dh = kreq;
+		h_req->flags = kreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
-- 
2.53.0



