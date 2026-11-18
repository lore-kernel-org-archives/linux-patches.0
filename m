Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045019;
	b=blrSoWKuzxTk+YjMqG0y9f8y3jpd0luJ6en+m4G6quf9CMkSWRwc85FdiJQG2WFGI8Nn
	 I7gTa5k4zR4VaNAdH86FlrahnnQb6NToDaOHZ6Kp6DrXo3ILVIOW96YRqAvJWOBLlgApB
	 rAPOzIqlt8yW7mGokddD1NSwK7SSe4CF4HMFBBQBzHrISnhmFj5Af66IOJ3FLlN2FOJjD
	 eKmYZjrIa/eLisUDR8cNBNUKHQdPY7FQXdNjkcFNRKG/4ItDL8DlfJPFwHbZ5h6tECvzL
	 CfmvndRsU9rCkdAFE30Tkre/z6+r0Q5qfPBtnn7uEg6+zM7hRQFQb5fkfyWMOMfwZOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOe8d7OI8sMuWhrQ7lexIkHiJU2z47zDcbuz3d/qWoA=;
	b=rYIPBTyq8TQFbl3RORqgCIguxuykUFnSX8afsjWZ6SVruhvOWbhO1T+2y3lt+OphSXp6
	 fflG5/Y0Xfxpz4O8A2dvk7kw0uqY5DKTvIXQMGJt5kpscrpnYoWtJ0zJSo1C/JCtDRJ7c
	 Hxu93NkiY2IJLjhRdvOIQIUnnpOK22dZNAYzaJ1snrHxbW3sygpIBwcI1ljcgZnhlhuBc
	 HgsHK/9lQM4ZO0NVO1LX8ZqGLpfnzsZALAGpKtvKWFFNrdFPlwnKEgX/n2pXuh+jRB+Ou
	 4+2H/duLIfodqdhB+AHp1PO/IAgHFzZZRE+xW/OhDMhmuBWle52pqvIV+KD+ZteTsLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTYhe3zb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268A7606A32C;
	Wed, 18 Nov 2026 23:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTYhe3zb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6FE1F000C4;
	Wed, 18 Nov 2026 23:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045018;
	bh=vOe8d7OI8sMuWhrQ7lexIkHiJU2z47zDcbuz3d/qWoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTYhe3zbIXb+BIs9qgwfCGtXcQhnVW7Av29pqfWVNYj3VKAA3z7Gu+2fKQtomseAM
	 m0RehSv5CvuI6MywaIcgVmeFyoBf4ZVjIvRha6hl8FIr1zeFCEQ6noOGzD0JDIoIT5
	 KQOt4doWFr1RMc3+qSXs3Bc3wL3KXRhTsPypM3Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0772/2857] crypto: atmel-tdes - sync output bounce buffer before DMA
Date: Wed, 18 Nov 2026 15:30:06 +0100
Message-ID: <20261118150229.366213610@linuxfoundation.org>
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
index abc2049fa6be5..dc6fa4b3e01da 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -384,6 +384,8 @@ static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
@@ -429,6 +431,8 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
-- 
2.53.0



