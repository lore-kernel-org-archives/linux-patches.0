Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055776;
	b=mFbN1Rx5gxF1AqMCirWJfVX+Y12ho5Sbi2oxcMSOyrD3b5dcbUqknYXtuMDixiwKptJI
	 NE/Cgxr7OgNKxWAYk9d8sg7R/BH4weqY39eKXNcTTv8m8rbM/d7yra7GTvFJm5VMozvtc
	 LLt2lu0Ed4x8vOzm3sdeMlmCVWUt9TBFHiRil1l0O9Z4pdLyObWXF8q84P6Bw+Gc7SX1Q
	 W0q2SaasdBjleZ/Bg+QV/EW1h31+1Jwy5AODo0BjpuN/uKCbib9K5fmrxrfjcIPoRc8AW
	 7/ZbVEacx3wAN1pKBdR6jv5Gnn4nF6KumTNncQnasrER4AUuQqxy3i4WvTE7RF2KAbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KnLtUSpLBNUpsLvms6mjXbm6SrSG6k1O1jILPXRZg0Y=;
	b=WZpTKo7X0Lntg1Xv3JtM6EoJM/gZ067q/a9oCtZsQJ88AqwDyU/OVs49IlosYawmHY4w
	 3wfSGOIXg4bY44vVfRrhBKf7K+DsTy/ClE6jyFQJnV/yRZ1Hfpo34FnfqcPp71ug20Thf
	 UgknupA/kCVT30LEE2muWfRuo4jfVLNLtVDtVbadRJSsgTYy+onJJeX9h6ecZphCtlccR
	 kE/WxzXKKIlCpDIO0Vf7ut9rIexNkku5r5+IrogU+EmeQNxkRWCRIbSVTQnA/eTIzkshf
	 /mQMn+4VKhJJNMPW2eCjLRsyzGDidRCbtAv7rHUx0pFxBCSD2/E6k/lIgdYzXE//JMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZaAWjaN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50091606A338;
	Thu, 19 Nov 2026 02:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZaAWjaN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6C61F000C4;
	Thu, 19 Nov 2026 02:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055776;
	bh=KnLtUSpLBNUpsLvms6mjXbm6SrSG6k1O1jILPXRZg0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZaAWjaNnPHuxkl1MVuy+YdJTfmCjXY2hBhrfZpomsRozlw/uXUrIz2opkD6q0uFe
	 iCLVFqhujsWdtw/V0qiQ3TNY13BE7KAd63511nF1JQjbQHMBASN89dahZDC4OV3/IW
	 YmuHJv5Kinef+Zw/Drur6W7SnZ1/9ACtIsL/VAcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1752/2214] dmaengine: ste_dma40: Fix physical cyclic capability
Date: Wed, 18 Nov 2026 15:57:08 +0100
Message-ID: <20261118150121.668894978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 11101a8e3e42273a5910a149f6324040b88f4747 ]

d40_dmaengine_init() configures dma_both for physical channels that can
handle both slave and memcpy transfers. Physical DMA40 channel setup has
supported cyclic LLIs since cyclic transfer support was added, but the
DMA_CYCLIC capability is set on dma_slave a second time instead of
dma_both.

Set DMA_CYCLIC on dma_both so d40_ops_init() installs
device_prep_dma_cyclic and physical channels advertise cyclic support.

Fixes: 0c842b551063 ("dma40: cyclic xfer support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-1-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0e9cb01682647..c9097dc6748a7 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2885,7 +2885,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_both.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
-	dma_cap_set(DMA_CYCLIC, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, base->dma_both.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
 	err = dmaenginem_async_device_register(&base->dma_both);
-- 
2.53.0



