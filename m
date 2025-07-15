Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C3E2D028A;
	Tue, 15 Jul 2025 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586354; cv=none; b=iFnHKpF3hZo2seJnJpTh2YrpxVuGKEoz0S6KanowuDxFG5h8TpB6E4yPRrKDRgwHLebKVtOKLK5R/MHFit0kqd981LS1MKYMO84KA8vfuFIMmvsIXEEmwR2czfFkgLqavKLoicm7zD03j/XRZgNas/qSNK2Nv8BN9lJbhkc/6C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586354; c=relaxed/simple;
	bh=/RIFg4gUoDaEt9629DFVdfG226PEfXT2SSwD7vivUeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAL8XxEDloLinaMwkjfaVQuEAfThYB8pjmEfXqdaQWcfoIfZ7bsvKCiQmhLlynF07F7LR3mSTYHn7iGCFOFwE626mzPLdOJnnmE46qYYiIZP2olMe4eAP3LZHNSAQXlkfSVpSvPDJHvUAvcjsRjgU+rrx4STbU3esL4cZ3RPHdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAZCFDOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAZCFDOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90086C4CEE3;
	Tue, 15 Jul 2025 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586353;
	bh=/RIFg4gUoDaEt9629DFVdfG226PEfXT2SSwD7vivUeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAZCFDOD+nJdqyJYH8FJN7WDUEkFsY+nBzTNSsioSm6OCRbw9SfcnzMzSD128M+XN
	 8wc0RgiWfy7ArGdJNBRnLqK/oi/UD1mHneekFTUU8j0dXas605cLtmxaVYdC4Ac1aE
	 my+VtWuJ24f+B1Byh/TLp+ZwTeMLIz5zxJx7bL2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/148] dmaengine: xilinx_dma: Set dma_device directions
Date: Tue, 15 Jul 2025 15:12:06 +0200
Message-ID: <20250715130800.475332165@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>

[ Upstream commit 7e01511443c30a55a5ae78d3debd46d4d872517e ]

Coalesce the direction bits from the enabled TX and/or RX channels into
the directions bit mask of dma_device. Without this mask set,
dma_get_slave_caps() in the DMAEngine fails, which prevents the driver
from being used with an IIO DMAEngine buffer.

Signed-off-by: Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>
Reviewed-by: Suraj Gupta <suraj.gupta2@amd.com>
Tested-by: Folker Schwesinger <dev@folker-schwesinger.de>
Link: https://lore.kernel.org/r/20250507182101.909010-1-thomas.gessler@brueckmann-gmbh.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index be44c86a1e037..5b5cbea997ff7 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2490,6 +2490,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = irq_of_parse_and_map(node, 0);
 	err = request_irq(chan->irq, xilinx_dma_irq_handler, IRQF_SHARED,
-- 
2.39.5



