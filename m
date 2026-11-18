Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018765;
	b=MqfH1SJGFXCvFFbv4XlOzDxIdMx48Ks0XrKe5hbaD2V4FHjV3Ew/SHmoIE50bDRT/1JP
	 t0y3pKpj17Mwq5JN6VE1gEakD50Gz3PK/jBN7W4TOAXOF3gzrby/qGpg1xrfEcleY8AgL
	 L2VZd/Hguq0GeRdnIpplL/PoxC2MuPfHA/a9rCp2cU3612MxBu02SMz/09d/B+Y2zlZh9
	 +Rs0r1xh8O9A/irgeFfpJinS3tEgoM+2nauoh78qBGtS97pqcGB9uSh9vq/+AGjHXvRQ7
	 YCkCochVTaauL/AeavJDEOMlr7+RLqofmlmgCGqoDt8mP5hJOgg37CeOBffEpxPDCYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JDPBnXSiNCWljsyy8kCs1OqfR94/9DzK35yT4usGL4E=;
	b=3ZxaiTGNmb6DKcsV52rzRhJTGVlZYO26CcFYPAez4ubXIMKOq/7hwXkRKwf/kYCGOdvN
	 aVWG2GuPpc1d5cxjMbBiCUZ0y8OJMnwKf7M83PDLGClowbU4WgB10HffrgfAFR2ZJumU2
	 GmHZNieUzrTkjFbl5jKAslm3WFyhfxNcgdVPaaclkKsqjJ1/jbRqpHqvajO69rdBurUv9
	 vJSC6dtYQfDzVUZPs8oguqTxduFNYvwGcuhhx7v+ukKTihhs9Nv58ckbj5FWIPgqfkS5t
	 DpY5mvVC62sOV5Cs7uiMRqt5Lb4fpivHBhpUnQP59SkH5JEYhRVLEzoLOA47yGzKGtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DtXROuwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D334606A320;
	Wed, 18 Nov 2026 16:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DtXROuwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3461F000C8;
	Wed, 18 Nov 2026 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018764;
	bh=JDPBnXSiNCWljsyy8kCs1OqfR94/9DzK35yT4usGL4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtXROuwavDRVdP0L0KpSiSu0GuJEy8GDaczEuYx6E3sy12N7chq/WNoVbO4nqlLfs
	 2d0wC3/W8tuok2LZ0ajyUCLswWXclLldtFZkHq82I66gR5slM+Jxxx3Sfwu5hmV4pA
	 Ble+JFn2IMVLvEbUeliOJHMpSxpsklJkh9S3R/6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1349/2651] dmaengine: ste_dma40: Reject direction changes after allocation
Date: Wed, 18 Nov 2026 15:43:09 +0100
Message-ID: <20261118150336.588738896@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 77ebc64f40717b8501793b5f5ee717a141e62e8e ]

Logical channel allocation uses the configured direction to select the
source or destination allocation mask, derive the logical channel number,
and choose the LCPA location.

d40_set_runtime_config_write() nevertheless overwrites the configured
direction when a transfer is prepared for the opposite direction.
d40_free_dma() then clears the wrong allocation mask, leaking the original
resource and potentially releasing one used by another client.

Reject directions that differ from the direction used during allocation
and propagate runtime configuration errors to callers. Skip slave runtime
configuration for memcpy transfers, which also use d40_prep_sg() but do
not require it.

Fixes: 95e1400fa131 ("DMAENGINE: add runtime slave config to DMA40 v3")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-18-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 479e69313e4a4..1b1edcb724804 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2410,7 +2410,13 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 		return NULL;
 	}
 
-	d40_set_runtime_config_write(dchan, &chan->slave_config, direction);
+	if (direction != DMA_MEM_TO_MEM) {
+		ret = d40_set_runtime_config_write(dchan,
+						   &chan->slave_config,
+						   direction);
+		if (ret)
+			return NULL;
+	}
 
 	spin_lock_irqsave(&chan->lock, flags);
 
@@ -2886,6 +2892,13 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
 		return -EINVAL;
 	}
 
+	if (direction != cfg->dir) {
+		chan_err(d40c,
+			 "transfer direction %d differs from allocated direction %d\n",
+			 direction, cfg->dir);
+		return -EINVAL;
+	}
+
 	src_addr_width = config->src_addr_width;
 	src_maxburst = config->src_maxburst;
 	dst_addr_width = config->dst_addr_width;
@@ -2894,13 +2907,6 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
 	if (direction == DMA_DEV_TO_MEM) {
 		config_addr = config->src_addr;
 
-		if (cfg->dir != DMA_DEV_TO_MEM)
-			dev_dbg(d40c->base->dev,
-				"channel was not configured for peripheral "
-				"to memory transfer (%d) overriding\n",
-				cfg->dir);
-		cfg->dir = DMA_DEV_TO_MEM;
-
 		/* Configure the memory side */
 		if (dst_addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
 			dst_addr_width = src_addr_width;
@@ -2910,13 +2916,6 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
 	} else if (direction == DMA_MEM_TO_DEV) {
 		config_addr = config->dst_addr;
 
-		if (cfg->dir != DMA_MEM_TO_DEV)
-			dev_dbg(d40c->base->dev,
-				"channel was not configured for memory "
-				"to peripheral transfer (%d) overriding\n",
-				cfg->dir);
-		cfg->dir = DMA_MEM_TO_DEV;
-
 		/* Configure the memory side */
 		if (src_addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
 			src_addr_width = dst_addr_width;
-- 
2.53.0



