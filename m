Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062034;
	b=j9zdlDxTEMubnp9yCKMcivkfm0v2GTXdtUBeG0B9DIm+/UNnoy1zraCnP/sn1bE7zAKc
	 YyDPnH+xiJ/9spZdbX7gdYgcEio1plutslOpmoNpPShygYNi0g1g3JYG54GYMmHO5QLu1
	 2k3gfaxfV/jUPFxMiVU560iubaNW/log+0e0oCv/axxeT24av4UQOy94zJlHZgP9PN49T
	 KR29XxWt4v3n8MgafucVnnXBTIGAcePJYoguKH9zRZQww2tvbyDVgwJmku/Uk1vctCIOg
	 JIlwmw2Sig6cmDGtuOkDdDAiVBE9DDF2l7KjJPWbdHxf/wzbRCkK2fVnagNGuY77jRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/os9Kkdqk7hzU0bYG4nQIFcDvLpZ596aOM4irxFY5z4=;
	b=xtBiBMdFoBixcJpp2qXXPMPpmK/nAX6HuKCFPEmmC0HpFF5eY74cDEmz/MzlwLvgJt2n
	 N3obcQ03sV7yNzfplwoRmI+hqgq4aUiKxa2zscZ23MsrFwoBXpI9FnS9A6CCOYfcrDMnM
	 RQMoFTKI+rfYH0lrzy57MNwj3QYJ+DtRvPG123XTUUXsu1lJ83Gz02hrQLbpOuktrUiPF
	 70xzuY4RswqGYYMi9EUc+MmAy+nrSjWgMyf7lOJ4zVlDz6AmZmusLFfKSPePU6YUZgI00
	 iDWYYc8a9SbdVCAsSUrPiaBN+IaJMDoIUwFzma8tGAjXBK6vt46g3wTIqw3ftdZgDqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fq9NRAe2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D432606A332;
	Sat,  7 Nov 2026 14:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fq9NRAe2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB321F0089F;
	Sat,  7 Nov 2026 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062033;
	bh=/os9Kkdqk7hzU0bYG4nQIFcDvLpZ596aOM4irxFY5z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq9NRAe24vTGnRJrrkS7XQ0oZsBJpBq7GT6QtejFJBuO64bAYVS2XUquZ70FshwAm
	 LNR76U1M1aEfBIY3xM7bbSnaVPm6K2rMJdkRxf7/SSqhVLK2MQ/Yszie7sR4/0JgbM
	 k4cFmOSa5HGO5LoHS3J71/eYqF35STN3y1hy4Xyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0991/1536] crypto: atmel-tdes - sync output bounce buffer before DMA
Date: Sat,  7 Nov 2026 08:50:07 -0500
Message-ID: <20261107135025.492060206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 360f5ef930322..3195605ef1c2d 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -373,6 +373,8 @@ static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
@@ -405,6 +407,8 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.53.0



