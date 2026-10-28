Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215842;
	b=CNa8akA6rxdspCR376Rq5a46mO1vzG9+59YRvhTxfJX0ePeJkTPnQL/2SWJFkbyvmfQw
	 RQ1v50Q7hzFEj41pwVFxy0wYpgJxulmM87KoEYr3i/yXwKLLpa5+pDptSv5vmbR/I9Hp7
	 tDawKxK1DqYvQeupw1/LNjVick5odKtw0+bnNMyAViZsiM7TQ2W3tLI3pcI4XYa3hP6im
	 rmyaqqROxFZMF6hmHwpcujQmaXCQbDVtj2L3+WJgesyZMeDFucUk5hT5FWV4Mo7X2dw/J
	 hwX0zuveL1hOxIbyBbEuJpoLfoS+PevaeauxBqRspF3I09e44BRyQyDnziMwgXhNPhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y39+xfhuT67Aav5GCOTHevQb0/SYbHRhcehyvFDnt1o=;
	b=VkmOTsTaKKMJ/lRuR79ywERlsvlXHXt+S45j8coIpOw/2e7ykJZWdn6ZFflhN3shS49x
	 PNL0ZwvkvpvLwxY31gFJRAsm2f6jvkJDi1FKFxTileSD6/CQo18h4Lz9VhOBVhCYvYIo1
	 eFARAQQ1YFFIPQq7Ftggc0fx5LT5VDsm6apR3lpqae6zp+BR936aMZ5ghcr16HhKKqrMu
	 0VnXp8pGSJoarbZuMvQG+Apzt0OOzvg+mmaS/dPdT1RDwvZrfPUdtIqnfRY6GkW2Iw4Kx
	 3jt2YhjsW2sVgQ0RZFMGsEDdzyfHLIErjSmEfhoq0XHwjy+z5mLkM36r0IHcIW0H/PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zd4VehZv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFCD606A31E;
	Wed, 28 Oct 2026 19:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zd4VehZv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D133C1F01825;
	Wed, 28 Oct 2026 19:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215841;
	bh=y39+xfhuT67Aav5GCOTHevQb0/SYbHRhcehyvFDnt1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zd4VehZvCljWjQCt92lx314L7Xay1jPNNxL9YfQN+TyjPGU8VhAE18ZAfugKEN6OS
	 2ImK5w0Uh3BlKxtGy16G9dTSXJ4Q/aMQd6NZ79+eAiMCXbFlvxvuL244ryAXALHdPs
	 5rvjy7DJNNpj5z7dkz4lnqiHHc9CaEf0NuFJiHkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1350/1887] crypto: virtio - Drop sign/verify operations
Date: Wed, 28 Oct 2026 17:57:26 +0100
Message-ID: <20261028170530.161659772@linuxfoundation.org>
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

[ Upstream commit 5b553e06b3215fa97d222ebddc2bc964f1824c5b ]

The virtio crypto driver exposes akcipher sign/verify operations in a
user space ABI.  This blocks removal of sign/verify from akcipher_alg.

Herbert opines:

   "I would say that this is something that we can break.  Breaking it
    is no different to running virtio on a host that does not support
    these algorithms.  After all, a software implementation must always
    be present.

    I deliberately left akcipher out of crypto_user because the API
    is still in flux.  We should not let virtio constrain ourselves."
    https://lore.kernel.org/all/ZtqoNAgcnXnrYhZZ@gondor.apana.org.au/

   "I would remove virtio akcipher support in its entirety.  This API
    was never meant to be exposed outside of the kernel."
    https://lore.kernel.org/all/Ztqql_gqgZiMW8zz@gondor.apana.org.au/

Drop sign/verify support from virtio crypto.  There's no strong reason
to also remove encrypt/decrypt support, so keep it.

A key selling point of virtio crypto is to allow guest access to crypto
accelerators on the host.  So far the only akcipher algorithm supported
by virtio crypto is RSA.  Dropping sign/verify merely means that the
PKCS#1 padding is now always generated or verified inside the guest,
but the actual signature generation/verification (which is an RSA
decrypt/encrypt operation) may still use an accelerator on the host.

Generating or verifying the PKCS#1 padding is cheap, so a hardware
accelerator won't be of much help there.  Which begs the question
whether virtio crypto support for sign/verify makes sense at all.

It would make sense for the sign operation if the host has a security
chip to store asymmetric private keys.  But the kernel doesn't even
have an asymmetric_key_subtype yet for hardware-based private keys.
There's at least one rudimentary driver for such chips (atmel-ecc.c for
ATECC508A), but it doesn't implement the sign operation.  The kernel
would first have to grow support for a hardware asymmetric_key_subtype
and at least one driver implementing the sign operation before exposure
to guests via virtio makes sense.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f77a956f6a19 ("crypto: virtio - bound the akcipher result length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../virtio/virtio_crypto_akcipher_algs.c      | 65 ++++++-------------
 include/uapi/linux/virtio_crypto.h            |  1 +
 2 files changed, 22 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index b1953aec93945..ab284f38fd3cd 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -83,23 +83,16 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 	case VIRTIO_CRYPTO_BADMSG:
 		error = -EBADMSG;
 		break;
-
-	case VIRTIO_CRYPTO_KEY_REJECTED:
-		error = -EKEYREJECTED;
-		break;
-
 	default:
 		error = -EIO;
 		break;
 	}
 
 	akcipher_req = vc_akcipher_req->akcipher_req;
-	if (vc_akcipher_req->opcode != VIRTIO_CRYPTO_AKCIPHER_VERIFY) {
-		/* actuall length maybe less than dst buffer */
-		akcipher_req->dst_len = len - sizeof(vc_req->status);
-		sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
-				    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
-	}
+	/* actual length maybe less than dst buffer */
+	akcipher_req->dst_len = len - sizeof(vc_req->status);
+	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
+			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
 	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);
 }
 
@@ -230,36 +223,27 @@ static int __virtio_crypto_akcipher_do_req(struct virtio_crypto_akcipher_request
 	int node = dev_to_node(&vcrypto->vdev->dev);
 	unsigned long flags;
 	int ret;
-	bool verify = vc_akcipher_req->opcode == VIRTIO_CRYPTO_AKCIPHER_VERIFY;
-	unsigned int src_len = verify ? req->src_len + req->dst_len : req->src_len;
 
 	/* out header */
 	sg_init_one(&outhdr_sg, req_data, sizeof(*req_data));
 	sgs[num_out++] = &outhdr_sg;
 
 	/* src data */
-	src_buf = kcalloc_node(src_len, 1, GFP_KERNEL, node);
+	src_buf = kcalloc_node(req->src_len, 1, GFP_KERNEL, node);
 	if (!src_buf)
 		return -ENOMEM;
 
-	if (verify) {
-		/* for verify operation, both src and dst data work as OUT direction */
-		sg_copy_to_buffer(req->src, sg_nents(req->src), src_buf, src_len);
-		sg_init_one(&srcdata_sg, src_buf, src_len);
-		sgs[num_out++] = &srcdata_sg;
-	} else {
-		sg_copy_to_buffer(req->src, sg_nents(req->src), src_buf, src_len);
-		sg_init_one(&srcdata_sg, src_buf, src_len);
-		sgs[num_out++] = &srcdata_sg;
+	sg_copy_to_buffer(req->src, sg_nents(req->src), src_buf, req->src_len);
+	sg_init_one(&srcdata_sg, src_buf, req->src_len);
+	sgs[num_out++] = &srcdata_sg;
 
-		/* dst data */
-		dst_buf = kcalloc_node(req->dst_len, 1, GFP_KERNEL, node);
-		if (!dst_buf)
-			goto free_src;
+	/* dst data */
+	dst_buf = kcalloc_node(req->dst_len, 1, GFP_KERNEL, node);
+	if (!dst_buf)
+		goto free_src;
 
-		sg_init_one(&dstdata_sg, dst_buf, req->dst_len);
-		sgs[num_out + num_in++] = &dstdata_sg;
-	}
+	sg_init_one(&dstdata_sg, dst_buf, req->dst_len);
+	sgs[num_out + num_in++] = &dstdata_sg;
 
 	vc_akcipher_req->src_buf = src_buf;
 	vc_akcipher_req->dst_buf = dst_buf;
@@ -352,16 +336,6 @@ static int virtio_crypto_rsa_decrypt(struct akcipher_request *req)
 	return virtio_crypto_rsa_req(req, VIRTIO_CRYPTO_AKCIPHER_DECRYPT);
 }
 
-static int virtio_crypto_rsa_sign(struct akcipher_request *req)
-{
-	return virtio_crypto_rsa_req(req, VIRTIO_CRYPTO_AKCIPHER_SIGN);
-}
-
-static int virtio_crypto_rsa_verify(struct akcipher_request *req)
-{
-	return virtio_crypto_rsa_req(req, VIRTIO_CRYPTO_AKCIPHER_VERIFY);
-}
-
 static int virtio_crypto_rsa_set_key(struct crypto_akcipher *tfm,
 				     const void *key,
 				     unsigned int keylen,
@@ -522,8 +496,11 @@ static struct virtio_crypto_akcipher_algo virtio_crypto_akcipher_algs[] = {
 		.algo = {
 			.encrypt = virtio_crypto_rsa_encrypt,
 			.decrypt = virtio_crypto_rsa_decrypt,
-			.sign = virtio_crypto_rsa_sign,
-			.verify = virtio_crypto_rsa_verify,
+			/*
+			 * Must specify an arbitrary hash algorithm upon
+			 * set_{pub,priv}_key (even though it's not used
+			 * by encrypt/decrypt) because qemu checks for it.
+			 */
 			.set_pub_key = virtio_crypto_p1pad_rsa_sha1_set_pub_key,
 			.set_priv_key = virtio_crypto_p1pad_rsa_sha1_set_priv_key,
 			.max_size = virtio_crypto_rsa_max_size,
@@ -531,8 +508,8 @@ static struct virtio_crypto_akcipher_algo virtio_crypto_akcipher_algs[] = {
 			.exit = virtio_crypto_rsa_exit_tfm,
 			.reqsize = sizeof(struct virtio_crypto_akcipher_request),
 			.base = {
-				.cra_name = "pkcs1pad(rsa,sha1)",
-				.cra_driver_name = "virtio-pkcs1-rsa-with-sha1",
+				.cra_name = "pkcs1pad(rsa)",
+				.cra_driver_name = "virtio-pkcs1-rsa",
 				.cra_priority = 150,
 				.cra_module = THIS_MODULE,
 				.cra_ctxsize = sizeof(struct virtio_crypto_akcipher_ctx),
diff --git a/include/uapi/linux/virtio_crypto.h b/include/uapi/linux/virtio_crypto.h
index 71a54a6849ca9..2fccb64c9d6bf 100644
--- a/include/uapi/linux/virtio_crypto.h
+++ b/include/uapi/linux/virtio_crypto.h
@@ -329,6 +329,7 @@ struct virtio_crypto_op_header {
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x00)
 #define VIRTIO_CRYPTO_AKCIPHER_DECRYPT \
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x01)
+	/* akcipher sign/verify opcodes are deprecated */
 #define VIRTIO_CRYPTO_AKCIPHER_SIGN \
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x02)
 #define VIRTIO_CRYPTO_AKCIPHER_VERIFY \
-- 
2.53.0



