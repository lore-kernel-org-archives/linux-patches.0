Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA492EE272;
	Thu,  3 Jul 2025 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553917; cv=none; b=mjjqdsrFj0IF0Qa3Dgo/c9CubXhE8RxOVNc2W6YOnfkbzouUAU028ngSFPKFdp92R6yySCQRy83mOsfGNYtE4FWp3PHkqqg6NRBXi5j0CEGDMi6ZlA3vQB2pqraGjQZQUGWsKwoa4CIAiW1fWTR2uVpDVcp0X7FJdyQk0gK9IJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553917; c=relaxed/simple;
	bh=YT+UqOiIQXM0Z/CYkVquMTKWNbzIyOMfUz9G8miuhx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2Jj7w27pUw1zIrKt13BLAymjCA7Qa9mtb1/xxuOREuFc88+NaZd5SOWigBBu6XtKFrMkZGlBoeIwPIW1CXqI6sjR1kbTr53oC+gAZGG2PwQHe/MWgpJnKYlkvse+taZWAVxe6558JW+av6ix/SI0WqV13Ze/6O9u2uTQeKdS+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNohjOXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNohjOXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6139EC4CEE3;
	Thu,  3 Jul 2025 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553916;
	bh=YT+UqOiIQXM0Z/CYkVquMTKWNbzIyOMfUz9G8miuhx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNohjOXCrGis0tcAY17XPBCy5nDQaRQ4RcOmjddXbOo69diHtNI/ODnAI4CoZsPQg
	 jMfZc/B0c+2POZjV5bX71meCSQd91q2W5NmVKnrg0goISu20cWR4+GR/958X5382uX
	 zkBgLZGYDksyAx0UCTmbzm5Ry7nlmS7DaiwV4428=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/218] dmaengine: xilinx_dma: Set dma_device directions
Date: Thu,  3 Jul 2025 16:39:30 +0200
Message-ID: <20250703143956.849195792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5eb51ae93e89d..aa59b62cd83fb 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2906,6 +2906,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = of_irq_get(node, chan->tdest);
 	if (chan->irq < 0)
-- 
2.39.5



