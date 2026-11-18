Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048468;
	b=2MsojE/wo3TLbolhxNe5P+9gui3+79a4dhVCHmKo2xpP+0WR6nncNLvgIfizkWv5o3N7
	 5S9ymmP6Tnfj1rocIpRdmXSytxBJyFL7U2MfK3u4IlOE3B/EqaSFkHkL+GmQmHLurJ6oy
	 ZK2PNzhzyhFwpQI+G+UqwdFV4QSmo1JsVqvqYLWPT0cAcYrjfyZ9fxWlGzUSc9nadnQgp
	 RslSNQLuWMOeupX9qFllMFaXqyUcm9ilcaJjlVaJu4dnHqXcbWaiU6nKCEyzLug8ZcWkq
	 WE8XMQVpeAHyF+bT1UzHb+KnIP+nRYcHXqJzRXEFheP+5MmeBAvhn3ZlBk3ZZU9YMgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VNOY6Y7zcM4zCW7jKb6bC4jse5T5ivA20/UdsK2z/ZM=;
	b=lt65Xc1UNnrWK03WeDTYDe73scmBblRJ4srFdtQcZ7wvO5aVT8flstbl6aTOZzx77lOO
	 WNqLGC7u3BEWoHFY/f8VxBPWg4AsV9BhaGTTel1lkZuMAqnC3s+zFX4i+Vhvvcp51Gs64
	 cQRqk+gsDVqSeXis5bqJ7RmF2jyO5M8agbWucJO5ECC2L1vkx5GWGIDzJBly7qBtWnnoZ
	 0PpExsTdQAwRM7RvLMB6P/xYMrV2asxcxkVVOWV1d+6spxB87yFOQYiBymXFnoUN3Z+sR
	 9jLOLSE4ec9wgZRatBSlL0I9mWqfbMOrFyEUWG0j2N3ERlqN+Tf9z4lacuD4iSQoS9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k3cMgEtR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B457606A31C;
	Thu, 19 Nov 2026 00:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k3cMgEtR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C48E1F000C4;
	Thu, 19 Nov 2026 00:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048468;
	bh=VNOY6Y7zcM4zCW7jKb6bC4jse5T5ivA20/UdsK2z/ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3cMgEtR57/VP+wQDMg3NxWCVtzkVPNU42KtDW6zQoMMxwjZI2j6iYo0yuSCyEPNJ
	 fh28G7GCdlEULh03CILuQ3QSXrOYjha66/bUPvtsMiOd3s3NveE5TktBB4CevKsPZh
	 xpqeIAjAy7Gj1Juzk7+rmq8WVqdiMt6cQAG7biJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2006/2857] crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH
Date: Wed, 18 Nov 2026 15:50:40 +0100
Message-ID: <20261118150313.628285838@linuxfoundation.org>
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
index d13e8c228b702..d874490180bfc 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1441,8 +1441,6 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	if (unlikely(dma_mapping_error(dev, dma)))
 		return;
 
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
 	if (dst)
 		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
 }
-- 
2.53.0



