Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045097;
	b=18Pm+1oXHO7VG474/a7wceINuhGyvzLdjM/kMte1aYUbzEsRiMKedML+ok3XHqZ8nD21
	 VmG+Rn9SQbzXxa4nxfQTZeQhZPx+VBozj7mwb8uHGn+YgUIBBMipFpjXENfbMcCnm8XzO
	 7ndqvBl4a/Pc3PqHlHWHHx0g/Wysd2Jebw6cjD/ZCWe3Kpv1CzzlUgwpm+m1ZXeaCcHUX
	 aqeSX0o/rW+DzW4mQ3eOvw6z8eM5tXeCW5BGjUt6+V/bUTnGhAKWkB42GDqyd7t3LIwPj
	 Yp8vFtcJCy4D/y+/IocPVxSECrOAhsG7SZdL7r0/A5XcwrACrS96ihi0l3pBaBwdZFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MJY+W5Fxwmw0DFjEsa4y6UmHVmWL+HVMTR38vT683qs=;
	b=Sx4JdmdNOGmYw2LuTHX5eF8lmR+hlNQ5qKS5Ev81kb5ptSf3h5fP7PTMougHam/AHaoy
	 BZSp16yFVLeIJXbndGysKKlQjVo4HnHnpgszORJWxRjM9vrT5/84AlXLxcx084twmGaO2
	 53WNBKTyIv0LvGI/qbaNCnOdZzZw17SXZes+C/Cble0/ZGsxUgiYHQR4SjgmY1D+3WD2V
	 Uta/4ysK/rw5H7SUpnbBTlc4WdChlsErxj1heTyyggXpQWm0XKjr8QF229vzpvVq2Se4w
	 O0pt9WbgTrPlnEhLHqXBuAyQhFdO9h5gANQnEFOnMAzCRNO5qdq6Ja7LGElfhZA0xRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6uxUFVp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C537606A335;
	Wed, 18 Nov 2026 23:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6uxUFVp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455131F000C9;
	Wed, 18 Nov 2026 23:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045096;
	bh=MJY+W5Fxwmw0DFjEsa4y6UmHVmWL+HVMTR38vT683qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6uxUFVpAF9vTObhTri53GegeXVreORSvHr5Tc/Xr979xJLUrgYQvlwJ6NV2zErtm
	 SZId/IaVrSrpO7dTvwSpxqsrm70bHA+cDgnWUBH1XTNNWNGinjWmVX7EQCI2pty2kL
	 vd6OG2Qj8uKnpY8Q5EUkjfzJ3qiaMEPv7mKQNNpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0802/2857] crypto: hisilicon/hpre - fix ECDH destination DMA mapping
Date: Wed, 18 Nov 2026 15:30:36 +0100
Message-ID: <20261118150230.449934242@linuxfoundation.org>
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

[ Upstream commit 12d8edda8cdb41d18c4891851e25bf58be6be995 ]

hpre_ecdh_dst_data_init() rejects valid requests whose output length
does not equal ctx->key_sz << 1, and maps the user buffer using the
user-provided len instead of the hardware transfer size. Drop the
redundant length check and use ctx->key_sz << 1 for dma_map_single()
so the whole hardware output is mapped.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 7aada55a9c6f6..f107425348464 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1546,13 +1546,13 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
 	struct device *dev = ctx->dev;
 	dma_addr_t dma;
 
-	if (unlikely(!data || !sg_is_last(data) || len != ctx->key_sz << 1)) {
-		dev_err(dev, "data or data length is illegal!\n");
+	if (unlikely(!data || !sg_is_last(data))) {
+		dev_err(dev, "data is illegal!\n");
 		return -EINVAL;
 	}
 
 	hpre_req->dst = NULL;
-	dma = dma_map_single(dev, sg_virt(data), len, DMA_FROM_DEVICE);
+	dma = dma_map_single(dev, sg_virt(data), ctx->key_sz << 1, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(dev, dma))) {
 		dev_err(dev, "dma map data err!\n");
 		return -ENOMEM;
-- 
2.53.0



