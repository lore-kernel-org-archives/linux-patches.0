Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062938;
	b=Jmymk7WfdhFCbviBK2C6pGF3yQNQMkx2u1Na53xm4kDPtWBmD74EuYCWAf0JayQmditG
	 0BMPdjSXhry62VZpTfK2CQ5VHhP+cK4gRU8EnTekAVkeSU44YmU0t2b/4NPIfDjA4EVSP
	 dLuCLA28l+P+eyi7+aJoG86ZXRj7XfqQ1Wx/+HDnjYx+gEvv7vsCYIgB7CwBSsjHBkkkg
	 I++N0gpgQ+8k4ndUQMk+6BRBfcf6qhfPmAxQywAGhRObtRQ+Ha8fQKKJPGX9z4e48ThqT
	 UpaJz4QX0HL9hNhMetPQdMxwC9mylLu93EoLn+ulcEk6FwgTWG8CSFkuxmOs8qr7LNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8p6nMbohj6A9BXWfsf3Plk6pdziQTdQiUnBFrbXpVQk=;
	b=krPOR80ghZWga5QV/xJ0sBG0EPMlTiEPnvfgBKPu8WvKI4BuknNu09t5FCiyl/8skMbK
	 Q8UHVh6BBWI7KtL8o31IKlZjJLSRd/J8HhxNOWTuyw6kivwUNpQWz//hLToOItpIp3liN
	 TWIrWo3iZVbARUcb1sPPemM10h2NbOdB+/jYDJ7Co6LM4mB5GLmMxNUPLErHoCe9KvEJ6
	 OFirRzLdAZRX4UxqTMvv48uuG0DMt7Un/ATaWFQKJvBdnJyM8cLFepw2QSVuNN2bdeCUi
	 Bviket89lk5q3cOOZ0o4sjzwq6zJ6DfOA4uNm/wj+EZzMeGJ6OptuWSgWYQ2ODHKa6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZevyImL7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F98606A32C;
	Sat,  7 Nov 2026 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZevyImL7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6674A1F0089F;
	Sat,  7 Nov 2026 14:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062937;
	bh=8p6nMbohj6A9BXWfsf3Plk6pdziQTdQiUnBFrbXpVQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZevyImL7+rQP2a4cZtTbNtzECEr/drvJezBvU5LCSctwacZ7gxelF+aeczs87S930
	 8e6RVSebzli/YRbzbgSjGd+WCVw/tzgfc96slLziydgbM6vM2fyLWq/ehrBNaMwytx
	 pVereLx3sYt52ilb+PGEZSdyvCaeV3nagMp1s2jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/869] crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent
Date: Sat,  7 Nov 2026 08:48:08 -0500
Message-ID: <20261107134858.976161196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 41fa978079780..af5d10add106c 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -138,6 +138,7 @@ struct hpre_asym_request {
 	int err;
 	hpre_cb cb;
 	struct timespec64 req_time;
+	u32 flags;
 };
 
 static inline unsigned int hpre_align_sz(void)
@@ -186,6 +187,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 				struct scatterlist *data, unsigned int len,
 				int is_src, dma_addr_t *tmp)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
 	void *ptr;
@@ -195,7 +197,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_ATOMIC);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
@@ -419,6 +421,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, hpre_align_sz());
 		h_req->cb = hpre_rsa_cb;
 		h_req->areq.rsa = akreq;
+		h_req->flags = akreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 	} else {
@@ -433,6 +436,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, hpre_align_sz());
 		h_req->cb = hpre_dh_cb;
 		h_req->areq.dh = kreq;
+		h_req->flags = kreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
@@ -1467,6 +1471,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 	h_req = PTR_ALIGN(tmp, hpre_align_sz());
 	h_req->cb = hpre_ecdh_cb;
 	h_req->areq.ecdh = req;
+	h_req->flags = req->base.flags;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
 	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
@@ -1485,6 +1490,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 				   struct scatterlist *data, unsigned int len)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
@@ -1498,7 +1504,7 @@ static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, GFP_KERNEL);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
-- 
2.53.0



