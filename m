Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036006;
	b=ur3GW1tb412FmksQwAZFSxSWzL7sVQq/GG4RDMFJBB1tT9WwzYFWrib0QfTF3D2c8yWW
	 fWOrsE6JZGeOdOVTvK/5G4zxmNaM7Y1NcJBCs/Wzex/m1a9WDFBRKZtjYqLwYQlK5HlAN
	 5/DfLbTiK2hO2dzcUHuxe6btm2uf1ht+TePgxba6YxK4qwLHb2SmIOlk+j8FH7QwwerTa
	 zTQFMIy9zKAnPv8tHJSu8NZzfXYWUpGp1bhqsRo40RzrxPkNfNRv9Istb78i5EnTKgHq+
	 aTD313c+Cg+YO6JYSnbzUD/FAsFEQsnxNEdRF7PFx9LyE5TZpowFxbCYBj21qQfblcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tB42ndD2v+kwSqnVyO9goMKFgpeL8MYxLqPGXN+XudY=;
	b=EvKJveZCLgQfx4cyQ8ReJAvzodhSVGN3Qh1qDobkRf/8OA2oyoYAdu0M4HZF3+lGrCPp
	 Y7SuCWk11tBL9GfCkdujOjDDFucmehZ34T230N9hQ9CXK4Wx2WfifeUQ52HvHQKO2L2tI
	 QogQVDY8Lh7QLBrYr0REPD2IjBNL/jxAe6jAhs/D47u939ioVnzlr1HX0+bTz/Sfd0kfr
	 bmk038ZkoWrHeBALOBKvPYvOGMY2Ur0kYSZNfXQcXo6LfsqcR6ftMQMGdcGUb5fO/XsbS
	 xu+zkS0Gc4XtzSq+HDboiRSjMegrrz5UY1cCNlFAjFSAg5oQm1aEbBg/o0HXtS3Mtbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=avE9s5VI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F0A60A2601;
	Wed, 18 Nov 2026 21:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=avE9s5VI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85AD1F000C5;
	Wed, 18 Nov 2026 21:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036006;
	bh=tB42ndD2v+kwSqnVyO9goMKFgpeL8MYxLqPGXN+XudY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avE9s5VISc9eJBLM11znwqnhQ9Krd0m002um1e2HzLI5e6wt07Rqn0gTzBJsVNexr
	 sinbsZgV5e6UP/BVLoT7enks89TwwoLyoFOtudTblptAMlaMUElkTrbmWJuFW4qy77
	 dWN7KfzXTGIJcUx+gD4HFTYE+q5m++nw0ufEOBfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0878/3318] crypto: atmel-tdes - sync output bounce buffer before DMA
Date: Wed, 18 Nov 2026 15:25:00 +0100
Message-ID: <20261118150345.652183585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0d47022db9488..002a05d73aeb7 100644
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



