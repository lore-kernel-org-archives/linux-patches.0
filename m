Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016980;
	b=lhyhXEDNyV8xW5lsUv9MV8degFj6ZsS2EoYljxc4Zhh5+p7+XzO7CmXgcvTxURYTwKnQ
	 O3AD7FD0S6/iaiaovlPd/gZ3yESE/pg3opY4TUA5ZtY4vBy+0X7nCsRPi7vpaSSaw2L4k
	 oxhGVc+KCx0H4bD0HsPuB16ObtSblK4pdYHarnRfuDHMudWvEfIKfSnmrYbHvnCBHCQ18
	 SG3Pq0C246qKGV88iaeuZWvuSCa2yCzUdBPb1YQWw5kohsnqLE+TgSmDUuA6KIDFeKCrW
	 ctvEPHuSIuaUKE5d3jbn6dgRENNOVu8st8SmlX+z3KU0TzHn91kgGGJmKgSFGHvH3WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1U2H6eDKmWM8x09hR4AyhjCzd7L6gA313OlUEjmXhKc=;
	b=zKWbQWVuq/jl5Ku7lAUg74cr604EGd3RV6LztxUESWnHA5OuQK6IlAddYbXAP0Vyso37
	 jSICZQ+2apLKjZwdUMFOZHaPYw8ioYfgSS1HLRSdfaThGbcQ3eaY9SPA4veDyxpI3yExA
	 7jvswuczCgtZ6FI1Onzo8ch5QHkT4uQcn10nfS6u6W3RypuL7dOo6fg/37wQJ0jlT55LN
	 BVj9b/qaJbJdmGlBVjblso/asRfKhn/Bjn1qditMP65S4bf9d/T2tgzYfIMHvsqgxYXyn
	 vHZi03/vdNxdMQVcRHkOjRSjUJlQbenuaB0f65BwJF395xVNvBq/hChAloSPYm9eQSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z/yA2nAW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADE6606A320;
	Wed, 18 Nov 2026 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z/yA2nAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808491F000C4;
	Wed, 18 Nov 2026 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016980;
	bh=1U2H6eDKmWM8x09hR4AyhjCzd7L6gA313OlUEjmXhKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/yA2nAW5ErAomY1E+smdWtVR/PXCYIV0zST4O+6COrLQJAI5jB/CNLpwyjgAH5Hq
	 1J/QIdX9D5aOuQTobg+jYNxHYMAHg8tDOacl2ASv+ZOVlbrCezWEvTZRlZVq5oCyD+
	 zFCdweZnPD1aeIzCfoQXlp+teNf74bXNiuwFsFCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0694/2651] crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH
Date: Wed, 18 Nov 2026 15:32:14 +0100
Message-ID: <20261118150312.830638953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 5b87f619cc5c0a55dcd85ce97974e3f5b9333b7b ]

In hpre_ecdh_hw_data_clr_all(), req->dst is always NULL because
hpre_ecdh_dst_data_init() sets hpre_req->dst = NULL before mapping
the user buffer with dma_map_single(). The dma_free_coherent() call
on req->dst is therefore dead code. Remove it.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 0861f06da8eea..6ca34f3bf9ffc 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1411,8 +1411,6 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	if (unlikely(dma_mapping_error(dev, dma)))
 		return;
 
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
 	if (dst)
 		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
 }
-- 
2.53.0



