Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6932D31F9BC;
	Mon, 13 Apr 2026 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099360; cv=none; b=OOzpmp96IwIIGq8jkc3dnU2AO+Or9nYY+ZWPzVg0IFyyVbRRpJRRSKlX3JnNNbkmn9/JJ115SK6CYIe6SDJQ2JzQLltWC332ZcIaoBxT8iK9MNHxZrDZwBKToZRg9N0cd4m62zLMWmfP8WpoQk5Knd5IbxfYV94gowvAIwPqcB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099360; c=relaxed/simple;
	bh=nVLC9X90jTrefsg2lUArP4RN3KTIaCD1th5RICPekQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AA+R3JypgvYc9+Rzl9KDp5AbcTVgTs/ORPphdq59/RlvG95Qj5DArpUcIZCcOAWWrlUNq16AQnH3vjTcdp+sC7KgTKmN4kTH0veIDMy5H5LxLbHktcZ0oC/L8mXZylJ6rK9gohNX76jssSy6PSoB9ahjmtK86yo6oqxyJyntQNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbJ+c2PB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbJ+c2PB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCE3C2BCB0;
	Mon, 13 Apr 2026 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099360;
	bh=nVLC9X90jTrefsg2lUArP4RN3KTIaCD1th5RICPekQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbJ+c2PB467PDIw6q0e7mO3mCyBrdRa3yhwsf/Tj/vHMAh9gGTDlM1s9LighrYpxj
	 T4y00UNhbOMd58VmRZcI5NXZSyKj0dM18AnvaAwgPWBczVnm6WevUQuqxrordc9wEh
	 mTEX9V5BKMTipcFUZ9T1/vvKqq1Kf2E4eTp2W034=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/491] dmaengine: xilinx: xilinx_dma: Fix dma_device directions
Date: Mon, 13 Apr 2026 17:59:14 +0200
Message-ID: <20260413155830.608862361@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit e9cc95397bb7da13fe8a5b53a2f23cfaf9018ade ]

Unlike chan->direction , struct dma_device .directions field is a
bitfield. Turn chan->direction into a bitfield to make it compatible
with struct dma_device .directions .

Fixes: 7e01511443c3 ("dmaengine: xilinx_dma: Set dma_device directions")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260316221728.160139-1-marex@nabladev.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 12e9ba5b114db..0d0f3df71245d 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2845,7 +2845,7 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
-	xdev->common.directions |= chan->direction;
+	xdev->common.directions |= BIT(chan->direction);
 
 	/* Request the interrupt */
 	chan->irq = irq_of_parse_and_map(node, chan->tdest);
-- 
2.53.0



