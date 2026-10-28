Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215839;
	b=s4yzRpRYs3w76mo/T+3qyOCdiUOFDd20FdRDNFIPb7xIKhPJ0iZ3sIas7oQXCd36SVf3
	 4XZSMfrs3oNqFgiT1IUzitqRoh3/RMM7t0asn2GOmDuG4IUnGUOCkjSXR/Qn2N4ZvvcV+
	 UsarAvn6V2lKLaF0UdW0Wpc/E3/ni/hyoJA07qb2UKgHYIK8EW5zXbUiQaItORP/Dx4/S
	 YTHFNwfFh0tT7S/ZrQiFtc0JwsK+JPdqhaFokqG+pxYpRJGGEUAi/Fn618A/n3mENsVD9
	 kv77P7PeOgpYP+JSTotnDXebeYBgE4M8tIt9WhtzqoB83Qq7NDJ6STCyXiAs4HAirLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZ9vDBbM5LhjoTdCwcM2udxwzj/Up9soCdaxnrlJW/I=;
	b=qx3C2w/hgkDeAWVTFxKZLGZjAMwDee7oiB/kDJQSotkvHmMTEkgSSSu91e5bqFR4LB00
	 6tsuIAPfiZuJlp/MDO+oyXPco6wK4HXJKM/C0lC7WaUhLuCRbWaMj4fGyk7oaJcgnCDP8
	 7j6/WPawNJMw6oOs33jmK4GZpqKnOiPLKdEw7+W/o46FVVb7bd1yCV57f9tsbZLuCa/vA
	 435oXdhm9aTf8+eHStwRRLrw4txEaXFJLohWJiS5Qfn4WB9WircsaQVMW38u/LG0joG6f
	 GgdjsH02pVk3xrjqQ3d3qMczKsggokP3eV6eeCbl2Q3KQy5GjlljwMPQp4kcOf7WRgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyKR1gxD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79F3606A31A;
	Wed, 28 Oct 2026 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyKR1gxD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4C91F01825;
	Wed, 28 Oct 2026 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215838;
	bh=KZ9vDBbM5LhjoTdCwcM2udxwzj/Up9soCdaxnrlJW/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyKR1gxDHsY9MzDp0FluA6h4vC7pwoD+TuSEfv/jaErfOUEbRy7t/DpOgnqLmFgCu
	 okPwZ9BZcBk4jxeKseCyHpNKQb9aPaVCDpdKaCZvZNNPk8wqwlN9oY95vCgiH4ar9J
	 bQZwwL5rosX2z9C0MSKgeErgw3J/4zkI3xu7FBwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Gonglei <arei.gonglei@huawei.com>,
	Justin Stitt <justinstitt@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1349/1887] crypto: virtio - Less function calls in __virtio_crypto_akcipher_do_req() after error detection
Date: Wed, 28 Oct 2026 17:57:25 +0100
Message-ID: <20261028170530.138916847@linuxfoundation.org>
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

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit e01966e643c97eb8916bbbbbeceb687afb11f345 ]

The kfree() function was called in up to two cases by the
__virtio_crypto_akcipher_do_req() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

* Adjust jump targets.

* Delete two initialisations which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f77a956f6a19 ("crypto: virtio - bound the akcipher result length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index d2df97cfcb294..b1953aec93945 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -225,11 +225,11 @@ static int __virtio_crypto_akcipher_do_req(struct virtio_crypto_akcipher_request
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	struct virtio_crypto_op_data_req *req_data = vc_req->req_data;
 	struct scatterlist *sgs[4], outhdr_sg, inhdr_sg, srcdata_sg, dstdata_sg;
-	void *src_buf = NULL, *dst_buf = NULL;
+	void *src_buf, *dst_buf = NULL;
 	unsigned int num_out = 0, num_in = 0;
 	int node = dev_to_node(&vcrypto->vdev->dev);
 	unsigned long flags;
-	int ret = -ENOMEM;
+	int ret;
 	bool verify = vc_akcipher_req->opcode == VIRTIO_CRYPTO_AKCIPHER_VERIFY;
 	unsigned int src_len = verify ? req->src_len + req->dst_len : req->src_len;
 
@@ -240,7 +240,7 @@ static int __virtio_crypto_akcipher_do_req(struct virtio_crypto_akcipher_request
 	/* src data */
 	src_buf = kcalloc_node(src_len, 1, GFP_KERNEL, node);
 	if (!src_buf)
-		goto err;
+		return -ENOMEM;
 
 	if (verify) {
 		/* for verify operation, both src and dst data work as OUT direction */
@@ -255,7 +255,7 @@ static int __virtio_crypto_akcipher_do_req(struct virtio_crypto_akcipher_request
 		/* dst data */
 		dst_buf = kcalloc_node(req->dst_len, 1, GFP_KERNEL, node);
 		if (!dst_buf)
-			goto err;
+			goto free_src;
 
 		sg_init_one(&dstdata_sg, dst_buf, req->dst_len);
 		sgs[num_out + num_in++] = &dstdata_sg;
@@ -278,9 +278,9 @@ static int __virtio_crypto_akcipher_do_req(struct virtio_crypto_akcipher_request
 	return 0;
 
 err:
-	kfree(src_buf);
 	kfree(dst_buf);
-
+free_src:
+	kfree(src_buf);
 	return -ENOMEM;
 }
 
-- 
2.53.0



