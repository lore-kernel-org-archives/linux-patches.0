Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025582;
	b=g7/vlxq2bUxF/FhxhLlkpPG1e0jnHhoU22xo7RJnFacaPVOFtLdIXSPC2XNIDleVondT
	 e3HdzhXHS0pr/r6PLgKHwVV+kZ5FjtWFKOsxKM6z4UFgALWF7D3IwV3Dek6PzcZLHF4vJ
	 8LD8AeSHZsfMhSFAFMe3MejXy9VjFFgUBDN/Vr/JlO0wcLCn+LDc7dHBU2fGfJvexX2yI
	 C7nmexc4QHROnGhSXBeOkOZ38TCl/dgt5+f//qRGzi07Stt6uaXxyOSSAxmxX7Ymb+7Hg
	 jsPeIhA922YSqHmLAvQcsrSVb7R+5wwnjtoeHnVo3wpXSnxQJ8DqDi1W9JllH5OmL8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bmlLRNmV1r0TmG9AAryzncxBz9z76ZDYW+chOnvhYBg=;
	b=K6t/DNo4omfO7El5c+pFEDxflReptdxgL1HTtZ8HBkUoEWaushNW9itZ4JThDcQTEhK+
	 F0fRqSGD2M1/VRcQJzNm3lU+hRhDa+f58vDeBRC7HrtVmosk4w0Du34+NIAR4mHwvtv/M
	 gMvBkLlTf7WrlDI7iNYAoZuvGigovet9apEmQ1HnFy5+fDmH9gOmMV/e7MmknEutCFdLC
	 P3dq8FdiNBCJJQvZEy8JJdAXNpZr9QobrAOKR73q0dUQa4uC1lEuCzFyXaG/AARucckUj
	 pMPYKF3eG5ZY7ndNviOkSjhuE9Y8H0GlvXlydnRm3I4ML3mxxbuUPgCTFZ+trgW7lYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y8qeUcDq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D207606A331;
	Wed, 18 Nov 2026 18:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y8qeUcDq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5871F000C6;
	Wed, 18 Nov 2026 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025581;
	bh=bmlLRNmV1r0TmG9AAryzncxBz9z76ZDYW+chOnvhYBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8qeUcDqRpSOs0tu3vHTKr7XLiicSqnNOfW8bJz9Aw9v+c+ndjEC32beY68tWWP9E
	 iGHvV11XpjQ/l6nawtXQ3CToGHB8XX6+HvDPCiLz/HAfExHK22F45YB1m44H6QtKfw
	 RPmgRxWoOs1b5KOg9meTmsuG4cPvb0shkW7w4t7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1130/2151] dmaengine: ste_dma40: Reject direction changes after allocation
Date: Wed, 18 Nov 2026 15:47:45 +0100
Message-ID: <20261118150203.362172305@linuxfoundation.org>
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
index bc4e30d46bdc9..5c2a13b2f826d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2268,7 +2268,13 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
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
 
@@ -2723,6 +2729,13 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
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
@@ -2731,13 +2744,6 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
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
@@ -2747,13 +2753,6 @@ static int d40_set_runtime_config_write(struct dma_chan *chan,
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



