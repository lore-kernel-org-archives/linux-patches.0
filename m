Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D3E258CF7;
	Tue,  8 Jul 2025 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993843; cv=none; b=q+0lkEl7UzgjiIcJmAIMuxl6D2UxZts6eW6UEPoTjhj7k72saHiwZlXPO3FT0qYpRh1NWRyqTCsh43Hy9GxfWGbCDZjliztCxuWaJOAj9I9YYqpfS13DT0LrZR2ZEoAs9/XA/1rpOrRAmU4s5MifF/4IEiAfrO1lvo5Wu20Dd70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993843; c=relaxed/simple;
	bh=EOhv8cxKc2R4NXGvmAT5mXoz04v4lQSu3YQx2y9gvvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfOhWpuX16XcZjigCkxGdZwLDEwZ6/A/XiIztEzPmGQ6f4KjTmAVPzRKhFmyPdoch3i1Ss6bixfobRtbNtGPJTMor04eXWHnYzsLPsdTEWoLvrlPgCnodhlT+kjgxxhrwr6MlVTOCJAur567RT1mhACmXE2RMAn8s31KdLub7ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSFu5790; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSFu5790"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C33C4CEED;
	Tue,  8 Jul 2025 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993843;
	bh=EOhv8cxKc2R4NXGvmAT5mXoz04v4lQSu3YQx2y9gvvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSFu5790bkrzehC0KnIi0BpRYumoTWSSuH0FTQZcAf+tjcczZIQZlFg+7h52zYDMg
	 lrC9gIHyn4d1CO5AmUy1/Leazyr6E5yN6sUf71ELksLh4h6JBFnZPYOOmD9Ar+AqEs
	 8v0UdgXvsHDrxMOSix1sxrIvt8c4xp1Pr4ZYqE4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/160] dmaengine: xilinx_dma: Set dma_device directions
Date: Tue,  8 Jul 2025 18:20:46 +0200
Message-ID: <20250708162231.766712561@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index edc2bb8f0523c..48ac51447baee 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2861,6 +2861,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = irq_of_parse_and_map(node, chan->tdest);
 	err = request_irq(chan->irq, xdev->dma_config->irq_handler,
-- 
2.39.5



