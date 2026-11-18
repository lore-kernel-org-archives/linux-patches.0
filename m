Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024152;
	b=fQdMyCJFBQMWEzdu7lOc2xauqpbFU66ChlinJAE0XYO1iRkXNBXHlFfCDzQn31gA+l2J
	 Mfncp9mdLMAmmcYZJKNbOqvjB+/wcKfM2XSfyCWP1dfDOMKAEZmYVoM6TqqevkmkC7pT1
	 FWB7D1hJTAgsLZG1miKp4TdR28PN+NxB31zum7fpYwMmDT+B6reBBWs3IaM8A4B4MBkeP
	 t3KeLzMh8kRYo/C7vs9Uhd4wjM3weZltDzO8uvS+O4uHOHJi2CHiQzu8Am3aGGrI8MzQK
	 NHLfuGJAotMJSxsCo1z6rjdUm7nXtKpVeUX6SGm01P0+x1FcU3VfNVU9B0J+ytjUj+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=laYjpdCK7JSz5J4nKTSQQYxXKw4bqjsfuWYHFbzOkcU=;
	b=MDyLfQzIYLtW934QI29IpV2f07hdh2PDMx+osya9J/IzckFPxwQm2UqYgPi1Dktl8A3t
	 XZqCEGUJUeksRHW6Ev5Fxvgo7od7a/wTYGGqv0R/rwVne0ZUPA1H2pVDBnzWnp3xdTPSc
	 QKI2bjAVFp5YPxnsXjhdXwYhf4ubjF0NzXWLaOsBUGQB4t+qz8jo0FkoWwGV2KDOHnJNS
	 7b8cmXU12IqeBnxPUpS+B908gEROnBJTQLuIetSDJmZYCahvTAd0wlK4F0hSRdIO+tS0Z
	 Ddz3lt69CFDRVVVEshcjfv5sCxg/obnCOKIfh0U+yXhV/Xg/rwAurJ0Xig37GjVpV8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Der3+EqQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD181606A320;
	Wed, 18 Nov 2026 17:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Der3+EqQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA3B1F000C4;
	Wed, 18 Nov 2026 17:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024152;
	bh=laYjpdCK7JSz5J4nKTSQQYxXKw4bqjsfuWYHFbzOkcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Der3+EqQvRFOZrFLpogJwBddN65+f12LShACLrCaxQCCYrTN53ukCbIU8341WuumQ
	 Jl4gt+uPHSBrTIIFG05G/kGdqEiVtXFVpwg0il5gLo7R7N6E6U8nI8Hdjex7lEA2kg
	 xG9buhuNf3wyDHwLIH/RUHdWkXE3P4iS74Z2FkmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0624/2151] crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH
Date: Wed, 18 Nov 2026 15:39:19 +0100
Message-ID: <20261118150144.639508722@linuxfoundation.org>
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
index af5d10add106c..7d478f45ebb80 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1419,8 +1419,6 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	if (unlikely(dma_mapping_error(dev, dma)))
 		return;
 
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
 	if (dst)
 		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
 }
-- 
2.53.0



