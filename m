Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049202;
	b=ZNjZeQwRQumN9tJrAmgKzgmAT89Kmj8F2fnn9s9WSndZhRH9awgJ6cJb8xKm1LIxzr7i
	 KDhMdzStBvOtzjkBvBtkUJFbC/YJn4U3NWm97QrY1jLBwH4I4CbOnUj3cptmi2+o6Xfop
	 YXnoYtqp4nppliDXdCnQ75OCSr4UhR3vG+/pPBrru7WbDYrgLYK2GToT7Wg+LKB8ujbsr
	 8qKVSz1Amy472IPWl0Z7uDVbx/cG78rwXSE83hV6u4edtsFNVLbWjCkM1IQYalKBzEA6N
	 zD1WOp8LwxgJ0CzpHTKwsW8+d4/1YgyIQtTD6Gb4XCU+ZYFhqo24/vCVknlsbgtJOLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kV009iWM4SgNFGTqpe3DEXSk9hFHO9/F/TYsrVbFI8w=;
	b=lSJbmUHS1VjfQvUUg5BcjZFxUNXhZiaDia7wLaTeM5/yF/1LXpMHnfbqUy21+rN8fuN8
	 OLXZU1dF3KrhyHWvlNGAdzktkIkJF8F+eWR0HfTROl41C211hpVZ3bzKayg/tmMG8Vkmn
	 Uf8h8pnPdiyebhsa5RDg0/AyuaJaCm/seh0PuO82lN205xgLtFpxPqXADI+BAVnf3OCCZ
	 mO6WpIMxfWQmAz0q5vceZ/Rjk8qadomKicp06DNaajPZFmtgNUOimgwlL3Ct61MtMDn/1
	 /Bil8m3INM2/qIQWMMkoZi3OuozzpqNWGscCMrlK/Wpib6bq43GMg6LzyX7SBN5YFyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7Lel3vP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B7D606A320;
	Thu, 19 Nov 2026 00:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7Lel3vP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAB51F000C4;
	Thu, 19 Nov 2026 00:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049202;
	bh=kV009iWM4SgNFGTqpe3DEXSk9hFHO9/F/TYsrVbFI8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7Lel3vPE6EQg1v7UHS3gUIVmW7O585HJc9bO04JQblV9MFqpWExjWxGMuhbYNa9m
	 9yMZiJWEBz/dHotiNI87Rp71SpZZGbnG5HOAAu42wGBQ5Az3o5nr/PVWIec/e7idr3
	 pQUs2PKXkQ32cwaogCUV1TTmXYkz4Uj7Qq5urduI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2266/2857] dmaengine: ste_dma40: Reject direction changes after allocation
Date: Wed, 18 Nov 2026 15:55:00 +0100
Message-ID: <20261118150323.040181870@linuxfoundation.org>
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
index 6bdc1ce0d779e..2749e343527f4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2270,7 +2270,13 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
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
 
@@ -2725,6 +2731,13 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
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
@@ -2733,13 +2746,6 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
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
@@ -2749,13 +2755,6 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
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



