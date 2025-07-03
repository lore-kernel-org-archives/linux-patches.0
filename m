Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9777B1E9B3D;
	Thu,  3 Jul 2025 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555453; cv=none; b=Y6t6WBREyv12LWBqILoQophMQO+Pun16T1HKTayP6N2pJCPUGBqANpN2eIsASwzEBU7UeCgS49StZ8VV5jPjTBIlkWeRipp6WkJGRcN3pFgeBmn0Btm0KdBSbAXEMk+NTKaiE/YmkHhCsmDu2wbzWLYgHo4TiBRTz7b6AVvKDS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555453; c=relaxed/simple;
	bh=Po9+SBe4tpf2HBnmrIRZwSGLUFSJ7JGeBlpM2uRlUzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjJkB+wYz8427QT+gbySXcIOs4o8OnJYUuQB9SoIgLc3e0inYu+MRhYayArlHoMkBgWBH6YY9NA9TUDt3IPFg1gcM04FUxRC+XbZsEjza3P1BrWNnKLo7aXIgprhZz/UwxgwxSx0KL+e/H99id0lxwxj70xcevORbHgEOHNyUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kis3PMcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kis3PMcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07908C4CEE3;
	Thu,  3 Jul 2025 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555453;
	bh=Po9+SBe4tpf2HBnmrIRZwSGLUFSJ7JGeBlpM2uRlUzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kis3PMcJM0pnVNE2ri9LV8ZcpMVxhZNBaJ/wdk+JHf5gYBq5rm/Q8jHLAAQgW2P6V
	 z1kfhPoUFMJV+xAbtWEFAbzE5dzE16Lk8gNSIlH1ylQEEj7yBsRt9MY+lcPOt1ITom
	 ppm9Vw/oG10tGF/iZm6L04n4qLayNxC3hX/mxo44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/139] dmaengine: xilinx_dma: Set dma_device directions
Date: Thu,  3 Jul 2025 16:41:22 +0200
Message-ID: <20250703143941.925518041@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0a3b2e22f23db..14c4c5031b556 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2900,6 +2900,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = of_irq_get(node, chan->tdest);
 	if (chan->irq < 0)
-- 
2.39.5



