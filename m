Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6C82EA730;
	Thu,  3 Jul 2025 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554724; cv=none; b=h1LJ+TgXWxqXtwg5ZRw/dAALOkrJmePXx+mF+b4/kN5/73sigTsLcEM6k92Ae59kZMwdKMMIemCkrAdHxEBLBOYK0XZCGfFY884tzD5m0jihj24PelB6PgMB+eNefWcdRed+Gce6+9QmrAZfKzp2pW96dbfIXumNBoemr6WX5lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554724; c=relaxed/simple;
	bh=AFsFVFmlTk06PV4bFSo4chy4dShkIz//nXzX/2odaG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgFVqdz1js/k7m6J7EZFkCDyESgoXJSFNnMSVGKUelwcbX5jL6WNQjKXypGBswrtfKzvDltihCVcbnay6oN1H9sKJbL3THSKadrqnUS6ghpXtm4hxqYZegwVeuurbYNizzSrasJYTi3biSDY0QQoD3xjCQLvke1GKXG47LAy8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjQDWsCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjQDWsCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09ACCC4CEE3;
	Thu,  3 Jul 2025 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554724;
	bh=AFsFVFmlTk06PV4bFSo4chy4dShkIz//nXzX/2odaG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjQDWsCei2Ye6tJ2WzlDHdoQ5oXgDYaDx47OEkyTO24LW7W54h0RQKYmljt8WsDJd
	 aI2ipWDeSneO9z6yR0FC997Qlbf2HObmkGUzBj5Obg8Gqj5eXTsIEwohUyXjtLSxgc
	 aMO8lUQ1VVFGLpbn70bPllshFYBaj5J8L0oY/BC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 028/263] dmaengine: xilinx_dma: Set dma_device directions
Date: Thu,  3 Jul 2025 16:39:08 +0200
Message-ID: <20250703144005.427368063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3ad44afd0e74e..8f26b6eff3f3e 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2909,6 +2909,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = of_irq_get(node, chan->tdest);
 	if (chan->irq < 0)
-- 
2.39.5



