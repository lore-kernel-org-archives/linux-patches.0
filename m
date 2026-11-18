Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058236;
	b=0/LuTdHLjGfSSbRBf6QvdBak2UNoR80mqkxk1a8D+Z23TxLpRdF0r7xegBpugAfvQC+e
	 HNAp1WC2YJzgEVKoAPeKiLemGKdPdTuS6u8vsY+ofMLTlRNnerkjfW+C9NcaEy5r8rCJC
	 q+wv6kwGyKLqvwvzJDv4OZFA1/ZEUsF9d3+BnTzTR1RDdyuz6MOy8cVmlv7JgWkH8yWq0
	 xdK2seZ0wLRLrXE5kHBqfBzsXZrZpfW01utfwtXl++FcHR+rizhhDSCJSKzdcpk/vSviZ
	 HcLAQz+QVSYVx01X6WdOr5uo6EcGJo5alhjk26nbTEkS/juvwD8xaR+k9590OKDXAyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YLSsNz+7mOOjwyM4lfcaQzIRk3dAIpEFpjI8I19Xe3E=;
	b=Ma01SSC8uiJk1ADOhlQ7F3ZYeO7fA3rVXOvcqqCGtod0NFsHZEMVtykDnNZokO1CiEvF
	 kS6CZu1GtTAvGczos5c6SYKUR3BrXL6FOy8Ft6fV8mQN2G7Bz+x3lagJ+Ak7/izd+P05D
	 I+QpH5f19tjnv3RYjpBd/L2N4Wfln3YeLiEIouLURwENyZgBAoIz69KFfWXNIyf0lnM0o
	 yZO/UGxPJQCwpNfDHtJdFxyeAey0UTqeVfVZMGTaemENEve9W7p4lxLJCflj8Yl/RqGQc
	 sh6NhslYXKi7hvuFfkDZ+9BJCo/FQJEwAZKvhWc0ge/s8TcaKBxIyjCKLaCjmGvL4WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0AS3Pj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D79606A31C;
	Thu, 19 Nov 2026 03:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0AS3Pj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5FD1F000C4;
	Thu, 19 Nov 2026 03:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058235;
	bh=YLSsNz+7mOOjwyM4lfcaQzIRk3dAIpEFpjI8I19Xe3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0AS3Pj+Y3whL1xw4Jw9/OlBPYrsokOnT1i2iln6pKDcNR9NulVXyo+51GdjAqgcw
	 xBJWuJTntHQkRoTO4MlwTSED054McAuzHN3lMQ6ZLcPexSQgz0LCCz+Tpm+H8iZ7Yg
	 uK+YzqU/2SY2xkClO3yXpP9//MCERqJkT2RavXsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0397/1848] crypto: atmel-tdes - sync output bounce buffer before DMA
Date: Wed, 18 Nov 2026 15:40:35 +0100
Message-ID: <20261118145930.418865622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 72e3e7d2083ab..e9c63056180a2 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -394,6 +394,8 @@ static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
@@ -439,6 +441,8 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
-- 
2.53.0



