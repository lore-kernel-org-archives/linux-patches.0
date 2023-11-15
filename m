Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71D73BB48
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qelKMC8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5341CC433CA;
	Wed, 15 Nov 2023 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078276;
	bh=rX8E1fvzWWxWQeuXauIAIP5FaGSHWJqYdDh5tgaWGT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qelKMC8jHVH7wVmaHfQ3mW3SQl/7YKPj0SxXQKKUo2BPuQa+ASeij6SehFtkOF1pZ
	 Oj74xYnnOgch1qObckJ8j6uXVfOeXaVt69TdMJ801z4qDQD82D8W4taB6Gkk6cbN+9
	 UoggHtSEKkoao8HjoGKCDZsw2IwrwSRP+8t+aKBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/379] crypto: qat - rename bufferlist functions
Date: Wed, 15 Nov 2023 14:24:32 -0500
Message-ID: <20231115192656.761124464@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit b0cd997f35598c4fc01bf22061e1eb88fc10afad ]

Rename the functions qat_alg_sgl_to_bufl() and qat_alg_free_bufl() as
qat_bl_sgl_to_bufl() and qat_bl_free_bufl() after their relocation into
the qat_bl module.

This commit does not implement any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 20 ++++++++++----------
 drivers/crypto/qat/qat_common/qat_bl.c   | 14 +++++++-------
 drivers/crypto/qat/qat_common/qat_bl.h   | 14 +++++++-------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index d4e4bdb25c16e..ae83ba0cf1d93 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -673,7 +673,7 @@ static void qat_aead_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	u8 stat_filed = qat_resp->comn_resp.comn_status;
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
-	qat_alg_free_bufl(inst, qat_req);
+	qat_bl_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EBADMSG;
 	areq->base.complete(&areq->base, res);
@@ -743,7 +743,7 @@ static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	u8 stat_filed = qat_resp->comn_resp.comn_status;
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
-	qat_alg_free_bufl(inst, qat_req);
+	qat_bl_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EINVAL;
 
@@ -799,7 +799,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	if (cipher_len % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
+	ret = qat_bl_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -821,7 +821,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_bl_free_bufl(ctx->inst, qat_req);
 
 	return ret;
 }
@@ -842,7 +842,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
+	ret = qat_bl_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -866,7 +866,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_bl_free_bufl(ctx->inst, qat_req);
 
 	return ret;
 }
@@ -1027,7 +1027,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	if (req->cryptlen == 0)
 		return 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
+	ret = qat_bl_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1048,7 +1048,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_bl_free_bufl(ctx->inst, qat_req);
 
 	return ret;
 }
@@ -1093,7 +1093,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	if (req->cryptlen == 0)
 		return 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
+	ret = qat_bl_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1115,7 +1115,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_bl_free_bufl(ctx->inst, qat_req);
 
 	return ret;
 }
diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index 6d0a39f8ce109..8f7743f3c89b9 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -10,8 +10,8 @@
 #include "qat_bl.h"
 #include "qat_crypto.h"
 
-void qat_alg_free_bufl(struct qat_crypto_instance *inst,
-		       struct qat_crypto_request *qat_req)
+void qat_bl_free_bufl(struct qat_crypto_instance *inst,
+		      struct qat_crypto_request *qat_req)
 {
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	struct qat_alg_buf_list *bl = qat_req->buf.bl;
@@ -50,11 +50,11 @@ void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 	}
 }
 
-int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
-			struct scatterlist *sgl,
-			struct scatterlist *sglout,
-			struct qat_crypto_request *qat_req,
-			gfp_t flags)
+int qat_bl_sgl_to_bufl(struct qat_crypto_instance *inst,
+		       struct scatterlist *sgl,
+		       struct scatterlist *sglout,
+		       struct qat_crypto_request *qat_req,
+		       gfp_t flags)
 {
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	int i, sg_nctr = 0;
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 7a916f1ec645f..ed4c200ac6197 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -6,12 +6,12 @@
 #include <linux/types.h>
 #include "qat_crypto.h"
 
-void qat_alg_free_bufl(struct qat_crypto_instance *inst,
-		       struct qat_crypto_request *qat_req);
-int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
-			struct scatterlist *sgl,
-			struct scatterlist *sglout,
-			struct qat_crypto_request *qat_req,
-			gfp_t flags);
+void qat_bl_free_bufl(struct qat_crypto_instance *inst,
+		      struct qat_crypto_request *qat_req);
+int qat_bl_sgl_to_bufl(struct qat_crypto_instance *inst,
+		       struct scatterlist *sgl,
+		       struct scatterlist *sglout,
+		       struct qat_crypto_request *qat_req,
+		       gfp_t flags);
 
 #endif
-- 
2.42.0



