Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064027;
	b=MULMrcc4iS2Bk3DhFM92DkTGEBrzf3uiA+/t4K6VqcCC5/o+B1+8C8yBIDBN6X6Y2tlR
	 +eg+dKRgGEuDUQKTj8SuqEmlspqFoO0H+A3vHILReDA4WBPmCrHcmOdCB2D3ucVSoj/TN
	 Axuvggoz7F0KpUCycAJjURr+p/zzD4anR8T8AVw1qKrtrrgkuXyIi5slE8E8U/k+sLNA/
	 GjoTOf9kxoqd38UWR8JdV4u872U+a8Dl3P+tUHHzPuDOvxJ5vVRkD9vSNCGh9Am2EpLeZ
	 /Yz6oMBjUFR1wma8Dafp5g4B9Bqe1JPtUni71U1AnDWxrcq94zyuci0QTHJpGRemeHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kc3f2yVm/TfsGW/ypbkeGf7+pVHZdvZQHEq9axFZYOQ=;
	b=ixIrSj06de5Q57LcQbIhpoP9GManeE6hwlwJLpkgiN/EW9OrKHRd4rxe/AxejRZjDJ+F
	 Q5NlXOnyS5NcSxeBt7PfzZiklbcq1mLF5v79l9P4V6ncH0ZjLCTVdjOc/iAqRmXT2MBND
	 fbVj8QukLzb25qyPvEibv+AbEEpoueCHNUVa42XJd7l7UdgOmBZZWbjQ+AgWtF9vU3IXH
	 Rau/aW5dbtCkh7mhmdja1b4P6XW/DzvXRSyKFe/GECe3Lf1AXJ9GroNO1uETZvZuzMIvv
	 a2c+NxNdbzEmo6yMg4yU+tFR5MSlPlEo4FGtwN3ono3YLRuz/seeEa7L7lMNLHskQ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yILGtJkO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6A9606A9D3;
	Sat,  7 Nov 2026 15:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yILGtJkO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277071F008A1;
	Sat,  7 Nov 2026 15:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064027;
	bh=Kc3f2yVm/TfsGW/ypbkeGf7+pVHZdvZQHEq9axFZYOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yILGtJkOH66iYNBtS1ezsPYc9bVuKQ8z85Rt2lM3b1324C3kEJ5g8WyK9QeGN9BS+
	 jURlDej0ixmAsnuPDiCLZ/wNf0r8wXxZMQ2TsOa3W1eLNjWDytgr+/V571PFUdA9Wu
	 35PcE92nB9cFX/ouWuhzsC+UckhCUpd3qv2AoRgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0202/1257] crypto: xilinx - clear AES key buffer before freeing it
Date: Sat,  7 Nov 2026 08:41:38 -0500
Message-ID: <20261107134945.134564233@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 1e4d31c4eb86982319245d8973473a621a256842 ]

In xilinx_aes_aead_exit(), the AES key buffer is freed without being
cleared, which allows key material to remain in memory. Use
kfree_sensitive() to clear the buffer before freeing it.

Fixes: c315cb0005be ("crypto: xilinx - Change coherent DMA to streaming DMA API")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index d54c268dfe34a..ebee37dddb1f0 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -766,7 +766,7 @@ static void xilinx_aes_aead_exit(struct crypto_aead *aead)
 	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 
 	dma_unmap_single(tfm_ctx->dev, tfm_ctx->key_dma_addr, AES_KEYSIZE_256, DMA_TO_DEVICE);
-	kfree(tfm_ctx->key);
+	kfree_sensitive(tfm_ctx->key);
 	if (tfm_ctx->fbk_cipher) {
 		crypto_free_aead(tfm_ctx->fbk_cipher);
 		tfm_ctx->fbk_cipher = NULL;
-- 
2.53.0



