Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063996;
	b=3PKvLvW9M9a/MkS3C/o0yZMFX8vNyAIcOwGwsqz3ueAZdJkuGyeTxPkG0q5o4OMN063k
	 DH83ts7s/3rOYSd8VOPyqf2YL388TgclSuknY+ittKtj0vsuLOHt1cunqUtPzHrJ6fpG6
	 fmBR08qLEA4bW0LT+Ik1kAPp72Rp6ojDDPHOrfezfYsSzrS0W63XrAoKIAThhQUbKbG8B
	 iHgUgmiZ62/vOU9xlc6BE/ATY9saGsV2XNqy1VKmsu6tpFr2EeCo2S7HzNbg1a+tk7ilj
	 2IIdOC1ZT7IGJk08152rsuB++Z6UAoqcj9YFvlTZlr7djgmCSIV/L+8/e26i5ARRAjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1P8zq4qaZWonbRZWw72xVf84Rfngu29alJR65AOViFU=;
	b=AZw0oiTAcnqkyyKzl6M72UU1hyAHClgGcm5P/Fy/89nbvSZa9D3wjQBs/fmMbCYtKKBO
	 zg5f5gBqPvOoAZH+ycoHIAQtvuJZeriXdE2VrsebmHcF/ww5GAh26jc7T1LuC3lkwYwfu
	 +ZJVEJshn/p/HL77E/Z6nCN+8bkc4u7goZ1VT45oCNjTYsY2nDMSV6gijI9ikP1pH/gvP
	 AOIszMZWVmCOmQt9qDuigXWFcEVc36bh1KJBOrApI9OZ7dObC7gJhQ/j5t1XSW2PgQvlu
	 QZ2vGJ44+IaXKY09CqFku0fMtvYK8p/MO0D5u3KfHPlWMyn0hITfwlpq9nbixwigK4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BHQnFmtw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A46606A332;
	Sat,  7 Nov 2026 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BHQnFmtw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988291F008A1;
	Sat,  7 Nov 2026 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063995;
	bh=1P8zq4qaZWonbRZWw72xVf84Rfngu29alJR65AOViFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHQnFmtwMFXQH33ktAppvz5kuI9leLR6QoDQ5zO9331s8s3wJNQka6BJbkiNlRUiT
	 52w39XgZa2UrWa5U4aaIg2IwzCYK9Jx/EshyhKFO7rgpJEoGMIlUnZYtAjnnxEwCQV
	 X1MCLuoQZMITlwDsA/oe/BGnGN9b4iH52yeEErJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0178/1257] crypto: atmel-tdes - sync output bounce buffer before DMA
Date: Sat,  7 Nov 2026 08:41:14 -0500
Message-ID: <20261107134944.373547605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a38fdcb9c944525ca71e6aaf35e708586d0ae87d ]

The slow path maps its output bounce buffer once at probe time with
dma_map_single() and DMA_FROM_DEVICE, then reuses the mapping for every
request.  After the CPU copies a result from the buffer,
dma_sync_single_for_device() must hand the buffer back to the device before
the next DMA transfer.  The driver omits this call, so cache lines from the
previous result can remain valid while the device writes the next one.

This bug was masked by the completion paths calling
dma_sync_single_for_device() immediately before the CPU copied the output,
where dma_sync_single_for_cpu() was required.  For DMA_FROM_DEVICE on
ARM926, dma_sync_single_for_device() invokes arm926_dma_map_area(), which
invalidates the cache lines.  The misplaced call therefore discarded the
stale lines before every copy-out.

Commit c8a9a647532f ("crypto: atmel-tdes - fix DMA sync direction")
correctly changed the completion paths to call dma_sync_single_for_cpu().
On ARM926, that function invokes arm926_dma_unmap_area(), which is a no-op.
The missing pre-DMA dma_sync_single_for_device() was therefore exposed on
ARM926-based SAM9X60 and SAM9X7 SoCs.

With CONFIG_CRYPTO_SELFTESTS=y all four DES/TDES algorithms fail on
SAM9X75:

  alg: skcipher: atmel-ecb-tdes encryption test failed (wrong result) on
  test vector 2, cfg="unaligned buffer, offset=1"

Call dma_sync_single_for_device() for the output buffer before starting DMA
in both atmel_tdes_crypt_pdc() and atmel_tdes_crypt_dma().

Fixes: c8a9a647532f ("crypto: atmel-tdes - fix DMA sync direction")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 2756dab3f4c7f..ed80423b4209c 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -370,6 +370,8 @@ static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
@@ -402,6 +404,8 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.53.0



