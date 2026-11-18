Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023431;
	b=X1Iqzdo9PVy+3Pv5ppTErRBdEVAZe8EdAEqyTFDiGSHOUZ+IZsjFnLm+tXj3t7E8f/JW
	 j8/87ezRqKQGJrMsdNy4jq4W1pk+ijdj/nHGMpw+hc81yokg/AK9yoMYfA5d7wLhaMLcq
	 Glz4xLzuTJHZe4u6qcF6Swz0H/ehsTUIyZ+Wsr84ur7B2yo4vnk7edY+6p/1zOoelErZ+
	 K9UiOT+5hV5q7GcPF9StfFRQO7WlUbr6uoSVAS5p9QSYtO0TdUWPEd3AyPf0XLSjJU3Tv
	 Yi8wWgp/DGfisut+EaJUFkGFV8dyvHram+zvj3gjJnQooYTXdcLMy934J7YEOWPzFWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sag5PB246WwLC5rKSP+sFLvcTYZRBOq1l3yQWVcXqqs=;
	b=fQks6h/0BMOJxLYp9jBgrPaMtwFPmAAbff7Nw5deL4oc93hc94VuSmCCAiKSElvmTPHf
	 rNAtCFb0tejUAzE2xeGxD2OKAd9eFUhVHdb77db/OZkdO/e4YaAvnVmZNzVoua0GRb9/b
	 EWh5w8MFcy+hxfYWyBmdcqM6P8XzRSNaVCHNgcJ1YIx0NK7SG5DUBkR4CKOhVLNtZZ4vu
	 fgui1krfQOcdVv9YXA1cs83Ztl0YWyWe0Db/2r1bPXdO6WDfW7V1eh4F5cEgLtLARLwHm
	 Q6PemrPUL2ImpJdMPWpmWrSiyOu+L6tJs/SQRAeggNnIBzK9H4t+EZdMPNAPFmImI9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMli7ncU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67898606A320;
	Wed, 18 Nov 2026 17:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMli7ncU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCFB1F000C9;
	Wed, 18 Nov 2026 17:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023431;
	bh=sag5PB246WwLC5rKSP+sFLvcTYZRBOq1l3yQWVcXqqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMli7ncUXweCLm07a9knj/IRc9Zk6MG969U60AgW5wBqUZ/zhS/aP5fvyHQEbXvOE
	 RCIslDQaUEwza75GTvoaKE1SEmePRTTEXgs0UQl4/VkWtKB+0bZx4GpAyWxKbmuTJw
	 7C2oMvqKmTbJYcLtXdc4O43JZhXCHFwzrtKjoacU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0367/2151] dmaengine: dw-axi-dmac: Fix AXI burst length encoding
Date: Wed, 18 Nov 2026 15:35:02 +0100
Message-ID: <20261118150135.456965478@linuxfoundation.org>
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

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit 0d59891c42e11c3840276d8a632dbc355d6ddc4f ]

The snps,axi-max-burst-len property describes the number of beats in an
AXI burst, while the ARLEN and AWLEN fields encode that value minus one.

The driver keeps axi_rw_burst_len as the actual burst length so that
dma_device.max_burst reports the correct value. However, it also programs
that unencoded value directly into the hardware fields. A value of 256
therefore overflows the 8-bit fields and can cause AXI decode errors.

Subtract one only when constructing hardware descriptors, while keeping
the actual value for dma_device.max_burst.

Fixes: c454d16a7d5a ("dmaengine: dw-axi-dmac: Burst length settings")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-1-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 9772a4fdd85e8..d4313d0a2a048 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -706,7 +706,7 @@ static int dw_axi_dma_set_hw_desc(struct axi_dma_chan *chan,
 	ctlhi = CH_CTL_H_LLI_VALID;
 
 	if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-		burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+		burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 		ctlhi |= CH_CTL_H_ARLEN_EN | CH_CTL_H_AWLEN_EN |
 			 burst_len << CH_CTL_H_ARLEN_POS |
 			 burst_len << CH_CTL_H_AWLEN_POS;
@@ -977,7 +977,7 @@ dma_chan_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst_adr,
 
 		reg = CH_CTL_H_LLI_VALID;
 		if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 
 			reg |= (CH_CTL_H_ARLEN_EN |
 				burst_len << CH_CTL_H_ARLEN_POS |
-- 
2.53.0



