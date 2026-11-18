Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052486;
	b=w3Ym3c2/A5W+lAoUwsCRI9+7CClMbFxFwp+zdJqlYKpZCgiMHAeZHMQodNXGfsUiYYKZ
	 kjqNFlJgjj5e2sFINE0PEQ2SOX21RFEjbkdxiFe2eH9N5IW7EYTjj3K4va8AioIIblAeF
	 0vn8Q5Luoi/Ked5X+L328MJkWzPdudPtRKUaiaePrw+SP6ISD+MUUzMBVPGm4WYroJGgi
	 o2Js8P0eHJvZMb5hWWplbkQaneXH20RY3NdmBuVeSwb7OPACiouLWqK2zpy7UjTewWFtr
	 fYggXtEK3XhIa5KwCUK8vItjLhi2pQUD2dJ/+CoMoxpwxyFC4xqS4IbXvAsjMRYlQiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BZHNg7eL01XIukBSmBohPosneeoi7MZXpg8yGt1VNpY=;
	b=fMM/o2Z7AvGXI8dnlIOnC+pini/OGwABCxFwb9g+5f6xnIokhFsFCNMd+5dakAjGwZzZ
	 Ox746f+6Or1oiTSY422l1MCay9vSPqhb30a6Ttq+lx2PIPdgR8dwirt0dtPuytpL/BWCt
	 TVhO3DrWsb4lXcJfwQdZ6cg8/Gi7rvov61VAYwX9J+AaEJdj/SQ0SZRoEO7tftb9F5BL/
	 BLDRJbejeVLmCiHfl9ZtQNI0RlxZE9N0Y+fNJEq46UxnOB4VesatKM5h2IQVQP1mgBhnQ
	 bS3MbnF1zwD/ovJQwuxTvT+WHiM+F7TmFsuhbVLRPoCNt/H6KPb2BHUYP7UOF/S+K4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fKbOBwUx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFD9606A31C;
	Thu, 19 Nov 2026 01:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fKbOBwUx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00D31F000C4;
	Thu, 19 Nov 2026 01:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052486;
	bh=BZHNg7eL01XIukBSmBohPosneeoi7MZXpg8yGt1VNpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKbOBwUxuT0h9LR+lHharHLzYuxvk7d7WvnAhZKKHKFKsO2o2bh60rQbqrOjPjALI
	 WmpfGKICIWfeo0T0MKiXfh6x9WEspfWoKrNANwn4IvmXSKW1ZIb6a/SH1fstXoqhnR
	 Gx4V9zUBUEv3lKidAfQHscL4iugq4IsL7Z4YeucA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0521/2214] crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent
Date: Wed, 18 Nov 2026 15:36:37 +0100
Message-ID: <20261118150031.928260734@linuxfoundation.org>
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
index 72b6a7452ccaa..d77056178d7ff 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -139,6 +139,7 @@ struct hpre_asym_request {
 	int req_id;
 	hpre_cb cb;
 	struct timespec64 req_time;
+	u32 flags;
 };
 
 static int hpre_alloc_req_id(struct hpre_ctx *ctx)
@@ -243,6 +244,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 				struct scatterlist *data, unsigned int len,
 				int is_src, dma_addr_t *tmp)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
 	void *ptr;
@@ -252,7 +254,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_ATOMIC);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
@@ -514,6 +516,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 		h_req->cb = hpre_rsa_cb;
 		h_req->areq.rsa = akreq;
+		h_req->flags = akreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 	} else {
@@ -528,6 +531,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 		h_req->cb = hpre_dh_cb;
 		h_req->areq.dh = kreq;
+		h_req->flags = kreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
@@ -1487,6 +1491,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 	h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 	h_req->cb = hpre_ecdh_cb;
 	h_req->areq.ecdh = req;
+	h_req->flags = req->base.flags;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
 	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
@@ -1508,6 +1513,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 				   struct scatterlist *data, unsigned int len)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
@@ -1521,7 +1527,7 @@ static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, GFP_KERNEL);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
-- 
2.53.0



