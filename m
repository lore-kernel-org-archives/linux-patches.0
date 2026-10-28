Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215844;
	b=qAtJ6ZwgIxUS0a37JB6d+RC3mOLPGn91nlX0tNQmzUxhB22EpCrgvulFCv1nbuZGC7NJ
	 4jKkPK+bt34e+4kavDHCvzvboj1eVv2aKaXEK0edOQg8Kfg/E/kqexi7KNI0UJzW1Wkcf
	 j/ZXIpX+pVDIw2g6bT/K6iAYuafJU/0Je4ePvhIIOg/vI813yETeTU0KIzOeGMLwFM5jq
	 wHXV7i6Gz07U9YyfwYAQDxzR+AZWeCf3Opc7yCidguPf0uZk/aWquxdI7R3ZgM8uhkIts
	 L8qBbvGSn4vIUTh0w6KCJBP3X6GZ3jVhkRqXYtqdnqKBQFQcoB+BSO1esZhyQV3/Nzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cs5Jw3Bs67wUZPa7TEn5WAhk4Mfot3bk1dAaZZjVmq8=;
	b=Xt+kAFjnZ942OLNpUlpJ36C1xM9mI8Vfy5rb57cdYhYp9untKu6/+6eolLPVvuUnjFM5
	 e7DtxnOqgkj5n0IS+U1x7HU4sJmceydPQp5iNHuzIYZsCvak9ARL8rNI2Rgpuafin15h5
	 bLQzeRCMEnN5cw7GItz1Xj4vVYsF0561Tp8yHnv8yRgosfrHB7wt4WG9EIXflbb+8kri8
	 Y7R+uvGwjT5F7ubfiAVF1ddVzBEE/1ga8pX6zuoFfb7fen8SHadz+mAUNzqWB/GxGNUzr
	 2HObLLC9sSNLlCejqHcwis56QogYum4FkxeQxo7yZFyxk4Pdi0Dd4L2VD2pwxvZ5frg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcPjqD1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726D3606A31E;
	Wed, 28 Oct 2026 19:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcPjqD1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D8C1F01825;
	Wed, 28 Oct 2026 19:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215844;
	bh=cs5Jw3Bs67wUZPa7TEn5WAhk4Mfot3bk1dAaZZjVmq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcPjqD1B3RLeqbkRidMiuf4D5h4Fz+h38QPYoDGVC3HFg7/3PG38lp5Vwj/V0beCx
	 qJ1W+X+VtmHjhZ3EDmz1vg/+0wIw4/XPuphGF1nHdIJB/iJuL7PM/5mBNDnB31Cwbo
	 7C7BMKUJWXk7Hz8ANDkUt6YfSiwWvKjsDyWUbCMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1351/1887] crypto: virtio - Drop superfluous [as]kcipher_ctx pointer
Date: Wed, 28 Oct 2026 17:57:27 +0100
Message-ID: <20261028170530.182856539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit dc91d858fb9251b25828ab63ac7220145cef282c ]

The request context virtio_crypto_{akcipher,sym}_request contains a
pointer to the transform context virtio_crypto_[as]kcipher_ctx.

The pointer is superfluous as it can be calculated with the cheap
crypto_akcipher_reqtfm() + akcipher_tfm_ctx() and
crypto_skcipher_reqtfm() + crypto_skcipher_ctx() combos.

Drop the superfluous pointer.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f77a956f6a19 ("crypto: virtio - bound the akcipher result length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 8 ++++----
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 5 +----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index ab284f38fd3cd..f110d9a72f6bf 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -36,7 +36,6 @@ struct virtio_crypto_akcipher_ctx {
 
 struct virtio_crypto_akcipher_request {
 	struct virtio_crypto_request base;
-	struct virtio_crypto_akcipher_ctx *akcipher_ctx;
 	struct akcipher_request *akcipher_req;
 	void *src_buf;
 	void *dst_buf;
@@ -213,7 +212,8 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 static int __virtio_crypto_akcipher_do_req(struct virtio_crypto_akcipher_request *vc_akcipher_req,
 		struct akcipher_request *req, struct data_queue *data_vq)
 {
-	struct virtio_crypto_akcipher_ctx *ctx = vc_akcipher_req->akcipher_ctx;
+	struct crypto_akcipher *atfm = crypto_akcipher_reqtfm(req);
+	struct virtio_crypto_akcipher_ctx *ctx = akcipher_tfm_ctx(atfm);
 	struct virtio_crypto_request *vc_req = &vc_akcipher_req->base;
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	struct virtio_crypto_op_data_req *req_data = vc_req->req_data;
@@ -273,7 +273,8 @@ static int virtio_crypto_rsa_do_req(struct crypto_engine *engine, void *vreq)
 	struct akcipher_request *req = container_of(vreq, struct akcipher_request, base);
 	struct virtio_crypto_akcipher_request *vc_akcipher_req = akcipher_request_ctx(req);
 	struct virtio_crypto_request *vc_req = &vc_akcipher_req->base;
-	struct virtio_crypto_akcipher_ctx *ctx = vc_akcipher_req->akcipher_ctx;
+	struct crypto_akcipher *atfm = crypto_akcipher_reqtfm(req);
+	struct virtio_crypto_akcipher_ctx *ctx = akcipher_tfm_ctx(atfm);
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	struct data_queue *data_vq = vc_req->dataq;
 	struct virtio_crypto_op_header *header;
@@ -319,7 +320,6 @@ static int virtio_crypto_rsa_req(struct akcipher_request *req, uint32_t opcode)
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_akcipher_callback;
-	vc_akcipher_req->akcipher_ctx = ctx;
 	vc_akcipher_req->akcipher_req = req;
 	vc_akcipher_req->opcode = opcode;
 
diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index f7b8715b50744..c93df8a8f67bc 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -31,7 +31,6 @@ struct virtio_crypto_sym_request {
 
 	/* Cipher or aead */
 	uint32_t type;
-	struct virtio_crypto_skcipher_ctx *skcipher_ctx;
 	struct skcipher_request *skcipher_req;
 	uint8_t *iv;
 	/* Encryption? */
@@ -328,7 +327,7 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 		struct data_queue *data_vq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct virtio_crypto_skcipher_ctx *ctx = vc_sym_req->skcipher_ctx;
+	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
@@ -484,7 +483,6 @@ static int virtio_crypto_skcipher_encrypt(struct skcipher_request *req)
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
-	vc_sym_req->skcipher_ctx = ctx;
 	vc_sym_req->skcipher_req = req;
 	vc_sym_req->encrypt = true;
 
@@ -509,7 +507,6 @@ static int virtio_crypto_skcipher_decrypt(struct skcipher_request *req)
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
-	vc_sym_req->skcipher_ctx = ctx;
 	vc_sym_req->skcipher_req = req;
 	vc_sym_req->encrypt = false;
 
-- 
2.53.0



