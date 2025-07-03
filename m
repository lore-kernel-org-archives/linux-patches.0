Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FA51C68A6;
	Thu,  3 Jul 2025 15:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555901; cv=none; b=XALToEtT2Hat0G/qLJArOTf+YOsTr5en0m0gx49vjE7qgcDTrQ8LY1aE7NR8+Gv9Yp1xUj5HVTjvI10Qz8NsLpWWVG1QqaaTojLL+TVqJDa9IJxZeWdEOUYp+EqePrG+8Rn9w/gwXZmk2SG3D4vdBPMPmd23jcJqvXCTGLQQnB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555901; c=relaxed/simple;
	bh=cXoxnBVpPPm+scZWH5ge5U4lDEYUZA5KReRpUDjNpS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUFTlZ6yvPkW0dy5+AedgofBF6DfJVB+Din/W9LxRQjgjtniegZrJVSJKSGRAcdmKEvZvsCmUNfrXz5yniMqPR4YtsK1ErbLnp2OySNqH+i0n/jW2VS8ywN2Om71oSVTZl7O6jqeqIMJFrvZ3JNbjn4J7iYwmGhEltk9tzjcwtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5LwY9rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5LwY9rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D696C4CEE3;
	Thu,  3 Jul 2025 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555900;
	bh=cXoxnBVpPPm+scZWH5ge5U4lDEYUZA5KReRpUDjNpS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5LwY9rqT/yEk4VWTi7wqzoF3e7xaXFC/xu/6nz3T43EHDw3ic8ZyDIjAMWKi3wgv
	 Nyhr+i6A5Xt/I1FscK6+7VxfwyPAmrtzuDYihm+CCjIO8LtceZoFzl567tjo56mUTG
	 zJ5CCCTY5tfWM6Meta6rdX2VS/oJEOSXr1r+tNoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/132] dmaengine: xilinx_dma: Set dma_device directions
Date: Thu,  3 Jul 2025 16:41:42 +0200
Message-ID: <20250703143939.913873888@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7660175704883..e2175651f9795 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2859,6 +2859,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = of_irq_get(node, chan->tdest);
 	if (chan->irq < 0)
-- 
2.39.5



