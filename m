Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045099;
	b=RAztROhD7aB2g9pDpyDSCU+LglDQsNVSKwj6MEAf/5mM3Oln6gdDcq6dwIlG3hsE5d3H
	 QmOjFdE7JKPZ9tpc72MmMJc0/MnAEU1abLovBoX7jz3QUmccKa9s8Z08/nr9Tb/xq0RDt
	 7G/lhoYrdPlOR5T2/sN2CQ9qqIfHhTieAl3lmmIhoLrdXZH53n7+TOCj496KhhrbQNY5w
	 An/A5wlK4ovuMdGRWe0rlyz2NlscoGcaMmiP4II67o6vgGDe0RxFkZHELbnwsLT9AJWhI
	 RwAL6q0cuHKnwcpDdYGV2YJwAkRfr0f3v590mIbGOiYbV9krKL7offRV6xCniLiR/0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zL+Pupm9zh9frYEcNYPzsoesHlansmwMjzo7fsDrZGc=;
	b=lq+Q6lIPGquQXQ4AwZuQZJOHEi4vCzZ+9xf8dQLDj8dsKWNXchtIxYjpo5UY11GFuPPL
	 7MWWnFFQhhvoVdsyZ5nHWCPpg7BZSoy7Hb58ITpTU/IublA6sYx7o1j01L5+Bgw6Yresj
	 yVo3ATbvrv6aPVM3GdepE1ECOUd5C44xHtskQo3dfufWARW+xSRgZtDmaMyU0XINhXZtl
	 h1k3AZAi0lZIRFc7vtGlIdMWApFaUk/6a/M1OZbqfJ7c1Z0tEzydKASoOYbQaINU8GETe
	 h+j9sOdwm59XDsW0BvZdT13XHeY4zXa5I+xfZcWPAQh5hm/wzDUYk5Y1kkR5nDZ04Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=doD39wru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3F60A2601;
	Wed, 18 Nov 2026 23:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=doD39wru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327011F000C5;
	Wed, 18 Nov 2026 23:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045099;
	bh=zL+Pupm9zh9frYEcNYPzsoesHlansmwMjzo7fsDrZGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=doD39wru+tOdblMkzZ/3/POi7EdGRAlQYszWex4XMpEhtcLONTFmHHAQ2jpAkhP7S
	 XIyuKkO1/wdmg7Z2PLN1gmrBiNs1WuMpoBKNmA91vboCgNEeiXe3JBu9QxSNxLXk3R
	 dnrCR2H0tNoVa6YvIvRFluw+0bA9ojHcvF0eHInY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0803/2857] crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent
Date: Wed, 18 Nov 2026 15:30:37 +0100
Message-ID: <20261118150230.484415107@linuxfoundation.org>
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
index f107425348464..d13e8c228b702 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -145,6 +145,7 @@ struct hpre_asym_request {
 	int req_id;
 	hpre_cb cb;
 	struct timespec64 req_time;
+	u32 flags;
 };
 
 static int hpre_alloc_req_id(struct hpre_ctx *ctx)
@@ -249,6 +250,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 				struct scatterlist *data, unsigned int len,
 				int is_src, dma_addr_t *tmp)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
 	void *ptr;
@@ -258,7 +260,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_ATOMIC);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
@@ -520,6 +522,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 		h_req->cb = hpre_rsa_cb;
 		h_req->areq.rsa = akreq;
+		h_req->flags = akreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 	} else {
@@ -534,6 +537,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 		h_req->cb = hpre_dh_cb;
 		h_req->areq.dh = kreq;
+		h_req->flags = kreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
@@ -1490,6 +1494,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 	h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 	h_req->cb = hpre_ecdh_cb;
 	h_req->areq.ecdh = req;
+	h_req->flags = req->base.flags;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
 	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
@@ -1511,6 +1516,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 				   struct scatterlist *data, unsigned int len)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
@@ -1524,7 +1530,7 @@ static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, GFP_KERNEL);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
-- 
2.53.0



