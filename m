Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215847;
	b=vSd4jz770MTB/p8fGIGZyLMC8c3WOmGKiTy3PLDlnNVCC9DuGtEvq4yzQRojqHBcmM2L
	 LvUGyTmtzk/fpt+EAF1WgucchSpZsbGQl8iCAzysjP+4SDEum4OpxNG6+DVwAWekXbLUh
	 h/n3tu5ySCBxGcSan9Xxh8VQG2s38Vwj1F16kZ7d/QfGuOlXfpwF93SpBwUba2vySgp2E
	 oGxdvLNzDZDqBc5Y7Cun3kcpoIISnZMocpWuJOgXcuoWMt3p2VUcwJr6hhMwx3g9yx9LO
	 S3sxBe/0g9oIBNSuWq+M9bLK45NMyefSCzMYuf7PgMOrL3IuieZuSNoz5pLgXn31jiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PAwYTBWn3WiFXvjLY9jfEUSPqZDtZprUELr9lmWVLaA=;
	b=I+5bkHjqAAANTY2qR5hHH5FghsVuEcxmtk7zbxQ2etxkq5WHoCNexWDz47CNd3DzIxr8
	 ZDNquOIksQKUQ+EMBzz+Og5QbqPs48CCnRY7Tys2o4eV4fjTWCAuvNT2x6lwk2lCEZckR
	 FCdpafea2243h/4aw0T9ZkJmrDCD+KF4ifd6F6Zo81hswSxZxwfyqbhwdek+TBDoFvP50
	 zdH2gOqp1LnbJbeakm1tiF857O15TspXWwYJ8eUBqSKZMuko0Kvpuq3Eq0b7W82/DeyKT
	 vyrzfzAuWlxr+E2gxFygivnwTT7mwzDkQvrxQJDz3mTkil4bj0XyEv+XH66PI9AY6MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTcIIGuc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C793606A31A;
	Wed, 28 Oct 2026 19:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTcIIGuc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5C71F01825;
	Wed, 28 Oct 2026 19:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215847;
	bh=PAwYTBWn3WiFXvjLY9jfEUSPqZDtZprUELr9lmWVLaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTcIIGucOWP48qxgod4zo7VLewUbO6A9OK1Mp3loI5spmAyjG7JVfDWjP/olqh4vC
	 A3qtaI1Vof8UnSEWWlH4tQ4bzAxuKUMggLRAnMfTMhurTCX3L7QbJoBMQ6AviR0QPS
	 +PeKEOFRlIPT+Coeet8eyKIt2a5kfa9LRUQcdHbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1352/1887] crypto: virtio - Drop superfluous [as]kcipher_req pointer
Date: Wed, 28 Oct 2026 17:57:28 +0100
Message-ID: <20261028170530.206883609@linuxfoundation.org>
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

[ Upstream commit 62d027fb49c76475c5256ab69059752f42c3730f ]

The request context virtio_crypto_{akcipher,sym}_request contains a
pointer to the [as]kcipher_request itself.

The pointer is superfluous as it can be calculated with container_of().

Drop the superfluous pointer.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f77a956f6a19 ("crypto: virtio - bound the akcipher result length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 9 ++++-----
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 8 +++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index f110d9a72f6bf..db3817f5ab46e 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -36,7 +36,6 @@ struct virtio_crypto_akcipher_ctx {
 
 struct virtio_crypto_akcipher_request {
 	struct virtio_crypto_request base;
-	struct akcipher_request *akcipher_req;
 	void *src_buf;
 	void *dst_buf;
 	uint32_t opcode;
@@ -68,7 +67,9 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 {
 	struct virtio_crypto_akcipher_request *vc_akcipher_req =
 		container_of(vc_req, struct virtio_crypto_akcipher_request, base);
-	struct akcipher_request *akcipher_req;
+	struct akcipher_request *akcipher_req =
+		container_of((void *)vc_akcipher_req, struct akcipher_request,
+			     __ctx);
 	int error;
 
 	switch (vc_req->status) {
@@ -87,8 +88,7 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 		break;
 	}
 
-	akcipher_req = vc_akcipher_req->akcipher_req;
-	/* actual length maybe less than dst buffer */
+	/* actual length may be less than dst buffer */
 	akcipher_req->dst_len = len - sizeof(vc_req->status);
 	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
 			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
@@ -320,7 +320,6 @@ static int virtio_crypto_rsa_req(struct akcipher_request *req, uint32_t opcode)
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_akcipher_callback;
-	vc_akcipher_req->akcipher_req = req;
 	vc_akcipher_req->opcode = opcode;
 
 	return crypto_transfer_akcipher_request_to_engine(data_vq->engine, req);
diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index c93df8a8f67bc..40d8d95a0f7a4 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -31,7 +31,6 @@ struct virtio_crypto_sym_request {
 
 	/* Cipher or aead */
 	uint32_t type;
-	struct skcipher_request *skcipher_req;
 	uint8_t *iv;
 	/* Encryption? */
 	bool encrypt;
@@ -59,7 +58,9 @@ static void virtio_crypto_dataq_sym_callback
 {
 	struct virtio_crypto_sym_request *vc_sym_req =
 		container_of(vc_req, struct virtio_crypto_sym_request, base);
-	struct skcipher_request *ablk_req;
+	struct skcipher_request *ablk_req =
+		container_of((void *)vc_sym_req, struct skcipher_request,
+			     __ctx);
 	int error;
 
 	/* Finish the encrypt or decrypt process */
@@ -79,7 +80,6 @@ static void virtio_crypto_dataq_sym_callback
 			error = -EIO;
 			break;
 		}
-		ablk_req = vc_sym_req->skcipher_req;
 		virtio_crypto_skcipher_finalize_req(vc_sym_req,
 							ablk_req, error);
 	}
@@ -483,7 +483,6 @@ static int virtio_crypto_skcipher_encrypt(struct skcipher_request *req)
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
-	vc_sym_req->skcipher_req = req;
 	vc_sym_req->encrypt = true;
 
 	return crypto_transfer_skcipher_request_to_engine(data_vq->engine, req);
@@ -507,7 +506,6 @@ static int virtio_crypto_skcipher_decrypt(struct skcipher_request *req)
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
-	vc_sym_req->skcipher_req = req;
 	vc_sym_req->encrypt = false;
 
 	return crypto_transfer_skcipher_request_to_engine(data_vq->engine, req);
-- 
2.53.0



