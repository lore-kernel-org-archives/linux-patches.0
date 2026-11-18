Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047976;
	b=xoAonbUTEzDO4Ml7/HHnOADK6EUGT0qjOlF/2GTEIIxJWsbzAqJEQ6L3/6PzhuewzSMR
	 Hhdz5qBJWvgg0poY1DuyIQeByq067ZjcRUpl+9Gn9NgJ99mVAIeod8QEwBK+bUds4htpz
	 JRghOawnlLgLFafUBf+0vHUxQRpnX6fb7IvEELCcZuZecye+T6vWdLW4x8jG6KBAbU1kl
	 R+OpZbMz04PsYrNPs8LWb9gxvkXzMubaEcYvRYWeY3EF9jyaT7Y5ylOu8Hy93r5aBbgna
	 B9bUCKr21onO0GB+TJXdgUdqUoWlIyR5f5MPHw5njYi0r7vBV5arI06ApjgiDq44Y8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FfS08mZovyfvx3Xx5oOwIDD9u6q9iZnCxH8DNC6lX6g=;
	b=GBmhwRQFKS6jxxB+9gBMd/V3aKdskIQ3oYqRRW2O4ZUXFmlEA9jPdInRkSz514QnMmI7
	 mQDjev8ib7ABehxayxPwj45KgIPBBsYTn0NQ8nHec0VawCPe80Z2RuPU4z4/Y+N44uTqW
	 92HDvqxTL5rO7YHBzB9sL8/BbsYWIQUM5+H5vnU+5YYsH8EIEYWFMABqRMevdXvt08Fsc
	 Z3ecLxd01I5EyuvwIcNkkOvQ/hsEml2KuSe2uZwYfk5QaHVyph2GHZGf4zq7Y9b0GxZlv
	 tZR5eC9P3vqBhTYu1+1KQsnlYIusspGbKBg4AYNj9FLEZkr0e3wid5x1+bX7XdXmiGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+dFl+zf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3256606A325;
	Thu, 19 Nov 2026 00:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+dFl+zf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BBB1F000C4;
	Thu, 19 Nov 2026 00:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047975;
	bh=FfS08mZovyfvx3Xx5oOwIDD9u6q9iZnCxH8DNC6lX6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+dFl+zfHV0UeGWzHA6Zk3Yetto8VqJ6KD9ZsHEF3qf/77PwEwp+2tuhJJSJgFibG
	 XippobAiUu3ODdqUCxGe3vXFm3GEhgztPlNnHi5Tn9wyvzH1Uz5bRdVNuITbGWg8QC
	 Uv4JoK+1HtvAu9WFfgjS6T6LepLESk6JCI3/O8CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Srinivas Neeli <srinivas.neeli@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1831/2857] dmaengine: xilinx_dma: Move descriptors to done list based on completion bit
Date: Wed, 18 Nov 2026 15:47:45 +0100
Message-ID: <20261118150307.178934569@linuxfoundation.org>
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

From: Srinivas Neeli <srinivas.neeli@amd.com>

[ Upstream commit 5b585cc8778185ae7a7c9903f8cd70d562b91282 ]

In AXI MCDMA, xilinx_dma_complete_descriptor() walks the channel's
active_list and unconditionally moves every entry to the done_list. The
MCDMA IOC interrupt handler invokes this function on every
interrupt-on-completion, but with interrupt coalescing (IRQThreshold > 1)
an IOC interrupt may fire after only a subset of the queued descriptors
have actually been processed by the hardware. As a result, descriptors
whose completion bit is not yet set in the BD status were being reported
as completed to client drivers.

Add a check for the descriptor completion bit before moving entries from
the active list to the done list, using the appropriate direction-
specific status field (s2mm_status for DMA_DEV_TO_MEM, mm2s_status for
DMA_MEM_TO_DEV).

This mirrors the AXIDMA fix in commit 7bcdaa658102 ("dmaengine:
xilinx_dma: Freeup active list based on descriptor completion bit").

Fixes: 6ccd692bfb7f ("dmaengine: xilinx_dma: Add Xilinx AXI MCDMA Engine driver support")
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Srinivas Neeli <srinivas.neeli@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260818174151.1608971-3-srinivas.neeli@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index fe1256a114612..75d64f86ede5b 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1738,6 +1738,17 @@ static void xilinx_dma_complete_descriptor(struct xilinx_dma_chan *chan)
 					      struct xilinx_axidma_tx_segment, node);
 			if (!(seg->hw.status & XILINX_DMA_BD_COMP_MASK) && chan->has_sg)
 				break;
+		} else if (chan->xdev->dma_config->dmatype == XDMA_TYPE_AXIMCDMA) {
+			struct xilinx_aximcdma_tx_segment *seg;
+			u32 status;
+
+			seg = list_last_entry(&desc->segments,
+					      struct xilinx_aximcdma_tx_segment,
+					      node);
+			status = (chan->direction == DMA_DEV_TO_MEM) ?
+				seg->hw.s2mm_status : seg->hw.mm2s_status;
+			if (!(status & XILINX_DMA_BD_COMP_MASK))
+				break;
 		}
 		if (chan->has_sg && chan->xdev->dma_config->dmatype !=
 		    XDMA_TYPE_VDMA)
-- 
2.53.0



