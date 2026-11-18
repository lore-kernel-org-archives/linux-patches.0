Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023476;
	b=xXSAGYvFh84dNfuMLjU81q6b/yoWX5EJ2gjE9R2Og5ZqXhrtRpgg6j+/DE9QCZgaUL1+
	 FPtstPOjFL7D8DnpefQBZ4alvBAjIgpzC4ThwGfJiw36JLp5xsJ2rOpj/n6QNQhsnYqnn
	 6uiudqKL2neQkkqFFeVFVvZIFlcUle1W4MXtC0mPiBvsTG04+lKK5A1MUALT5DlNsZDGO
	 EdGC4oZN0EGNIJDG/Iv8Tqush7VXlNqqMNNJk0xt6H9WIH5gfiCYiFxQdrpHAjS8GHBIN
	 W11cBCcLFomAcJMF6Irsiz3aehmzc59+OZUYoTlkfdpf2nKuMB8cAmGx9DW/VBxd24g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XiOeJeDDuuFQ3o93bhjblkU3+Py5WLdBqOQukm8mYTs=;
	b=T+06swg+EHms/vsrjq4k3L0peRLec1G1MIm1V+4GrX0cIycuijpDz19rmeBd+xNWhNO1
	 WLyHKis9m9bb7GkTQKUQNCPlKIrjNrhzM99925aDbFZt25BFAqyzCBZ7kJdBDf7TLs/8i
	 5lrhy+P+LZ29QzUkOjxGyiDLCnU9apn6vRYab0fJnh2n/IYFG5K7VXZJXun/gsva2ctCK
	 Hiz1f9K4UiP74lmNNuRdQK0W5rGRaVGMBXtZmAuC1SLYBDv6eoQ4CNhjmo6QFcZoUYeTw
	 D/JHDmWMpfz0UjuQhOdEd6NoShloHr8pCAIi1A72Nv05LCjZG7uB+ZO0nTFdY7IzI9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=inoqqhQI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1081606A31C;
	Wed, 18 Nov 2026 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=inoqqhQI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92BC1F000C4;
	Wed, 18 Nov 2026 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023476;
	bh=XiOeJeDDuuFQ3o93bhjblkU3+Py5WLdBqOQukm8mYTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inoqqhQIcx7bABSV3CiGgJT5ekV+Hz7hF3/nlr9Ka8oC23C1a225RyU3+VNeCHvHQ
	 XTFZutq/m3D4tfwDmn2iNQwkCfBdlw2qP+FLvrMtUh9/oMWcBcnlDfHSJ3E6TXugtu
	 wK/KI6juSYV+Rxt0j6Y6jMqaFQKrYCFRVa5PZxOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0381/2151] crypto: amlogic - Fix DMA memory leak in cipher error path
Date: Wed, 18 Nov 2026 15:35:16 +0100
Message-ID: <20261118150135.959768300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

[ Upstream commit 6c2373dd818b777d0a81eb02acebc03940552dcd ]

A DMA memory leak occurs in meson_cipher() on the mapping error paths.
The driver jumps to the end of the function without unmapping the
previously mapped source scatterlist and key/IV buffer when the
destination apping fails.

Additionally, a memory leak occurs when a scatterlist mapping succeeds
but the returned count exceeds the driver's MAXDESC limit. In this case,
the driver rejects the mapping without unmapping it. The BIDIRECTIONAL
mapping branch also lacks the required 'MAXDESC -3' upper bound check.

Fix this by introducing proper error labels, error_src and error_keyiv
and unmap resources immediately inside the calidation checks to ensure
all successfully mapped resources are cleaned up before returning the
error.

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 25 ++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 29048da6f50a7..d78815b0547d8 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -177,10 +177,13 @@ static int meson_cipher(struct skcipher_request *areq)
 	if (areq->src == areq->dst) {
 		nr_sgs = dma_map_sg(mc->dev, areq->src, sg_nents(areq->src),
 				    DMA_BIDIRECTIONAL);
-		if (!nr_sgs) {
-			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
+		if (!nr_sgs || nr_sgs > MAXDESC - 3) {
+			dev_err(mc->dev, "Invalid BIDIR SG count %d\n", nr_sgs);
 			err = -EINVAL;
-			goto theend;
+
+			if (nr_sgs)
+				dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_BIDIRECTIONAL);
+			goto error_keyiv;
 		}
 		nr_sgd = nr_sgs;
 	} else {
@@ -189,14 +192,20 @@ static int meson_cipher(struct skcipher_request *areq)
 		if (!nr_sgs || nr_sgs > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
 			err = -EINVAL;
-			goto theend;
+
+			if (nr_sgs)
+				dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+			goto error_keyiv;
 		}
 		nr_sgd = dma_map_sg(mc->dev, areq->dst, sg_nents(areq->dst),
 				    DMA_FROM_DEVICE);
 		if (!nr_sgd || nr_sgd > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgd);
 			err = -EINVAL;
-			goto theend;
+
+			if (nr_sgd)
+				dma_unmap_sg(mc->dev, areq->dst, sg_nents(areq->dst), DMA_FROM_DEVICE);
+			goto error_src;
 		}
 	}
 
@@ -251,6 +260,12 @@ static int meson_cipher(struct skcipher_request *areq)
 						 ivsize, 0);
 		}
 	}
+	goto theend;
+
+error_src:
+	dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+error_keyiv:
+	dma_unmap_single(mc->dev, phykeyiv, keyivlen, DMA_TO_DEVICE);
 theend:
 	kfree_sensitive(bkeyiv);
 	kfree_sensitive(backup_iv);
-- 
2.53.0



