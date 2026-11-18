Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060421;
	b=XH7Q3ZukvUSEFPpOOPGeKFT64586kaDuS1GHgOB70aVQwydXnB6yKq8K9PCVlkiwj7Mz
	 LJvO6QcPq96dvP+RRd7fQRtqg5YwY0gEr1uhy4xC9+XW5nrYMjSkaa2cPkTgvvOpgdn8b
	 hsSYp2/2cBxpRlE8LJq94ze6XDmU4HrNjdM4LTLnbPgGCbSq+Jqr+yddp8X4S2/ac73mo
	 WYV4r+wC9bvlRZL2yx1weEugts0l+q7zqilPx14ytJiz/tD9LJ7p758XIHfemPLeKkoiK
	 94dbF4hmOnbYHT5HlruqxHFKr+2iAEBHx4TWzyN656HzphdwGD9qZS8gzqPOMtX7HlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XXVFFnov3SwIsDq6jEbCGhSFiei4t9RKV+Kx7c8DnRA=;
	b=bLHm4JHmsuG5J5hiOllMW3kRnq8dXsU7dCKsoEw/wo8lm3H/tEzEu+ceM9YMzE4fR/5F
	 V1JKQu0BVg4yRlrOuKMv1lIAN6hLV62z+qSi6ojq51MJWlxbMAO6I5X/DLKjN6lRJEHiK
	 wXfjzTIoTQk+tkAR/2284zku0AN5ZgNS+vVRS3ahS9X/2nRFMhpOutJCWP/EeDW1DmMdM
	 gRFUfw3ayspjLNuX1dwABub1RMbLW8a4o4UKZIpXc9qJWRu6qxhpZHdpYp0dclVAm+cpE
	 NoUkZijl5is/Ba5u1tLWF8Im7H8fA6LFJU6KX6MCjV4qKKhhtW7azvTfmJp7MYfEnog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nd7bPbNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4DB606A326;
	Thu, 19 Nov 2026 03:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nd7bPbNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69E91F000C4;
	Thu, 19 Nov 2026 03:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060421;
	bh=XXVFFnov3SwIsDq6jEbCGhSFiei4t9RKV+Kx7c8DnRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nd7bPbNHA6wWHQR+OztzPfMnbrJ0bOA284i+iiVcS3TKkyBeF9t13ygTKyLN2+9O1
	 V1lMmHZyHuKK7JeptMzsKJeRx9RYb2NLZ0aK2FXsiMFAr1nSmWnnuTrIhVRyg1ZdA7
	 2YrwSnLfJ2jocEmVoPwGRAXbtZCuVwJ2kGSBmljc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Srinivas Neeli <srinivas.neeli@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1191/1848] dmaengine: xilinx_dma: Move descriptors to done list based on completion bit
Date: Wed, 18 Nov 2026 15:53:49 +0100
Message-ID: <20261118150009.356561031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f47ffb520b843..fc28755e25c99 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1725,6 +1725,17 @@ static void xilinx_dma_complete_descriptor(struct xilinx_dma_chan *chan)
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



