Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6783317B50F;
	Tue, 10 Sep 2024 10:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964220; cv=none; b=q6B2vCWqEOsVJ03CTVdte51PxzYV3xexeQyfU498iIXJP9FLcgGjvheYVIKWK1QyojuAZHHHoukV8JORzzDADmtkj/RM/P6uwpfgI3SMgs3Fiz1Oj7jwz52T3QI65yrzhBiaCLsQlNrzuWHdtA6RfB9168v0ebHLl/DXnum9fD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964220; c=relaxed/simple;
	bh=x0VQgZsvTzNjQtDaOkDsXtLDyyqqbP4AxXAwO/VFqJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkYseA1gl+XnvnA0fwhD7dfuMjlx3gEdgAl0WYyv2q373GmjYhtE30XMU3GrJhVwBNIv2z/gc+FeMjtvHIevTksC5eDiNzXlKdmXAJYk/nkZnAc7jKYwfIcJhtCTD90dNp6JQJOxrTf7hbw6M42Sd1W6F0tYjSwhpQ4SWkVqCdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXWC+7wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXWC+7wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43EFC4CED7;
	Tue, 10 Sep 2024 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964220;
	bh=x0VQgZsvTzNjQtDaOkDsXtLDyyqqbP4AxXAwO/VFqJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXWC+7wb0xoNmeWCxJWu7ym6t/vFirshHBYFAcNqVXFzAkxaNpded+J+f0bMGiuuv
	 P2d7fqKka9cVwzXTIB3KXTj9ZMnbAU1FckR7e9MNkKfatl/iDGQwkqvQlLEdPbVz4I
	 2S13YYn3NWK5IBvT5VkR8c07qodtJiJloMBewGSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/269] can: kvaser_pciefd: Rename board_irq to pci_irq
Date: Tue, 10 Sep 2024 11:31:35 +0200
Message-ID: <20240910092612.048300058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin Jocic <martin.jocic@kvaser.com>

[ Upstream commit cbf88a6ba7bb6ce0d3131b119298f73bd7b18459 ]

Rename the variable name board_irq in the ISR to pci_irq to
be more specific and to match the macro by which it is read.

Signed-off-by: Martin Jocic <martin.jocic@kvaser.com>
Link: https://lore.kernel.org/all/20240614151524.2718287-7-martin.jocic@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: dd885d90c047 ("can: kvaser_pciefd: Use a single write when releasing RX buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 00cfa23a8dcf..a933b4c8165c 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1631,17 +1631,17 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 {
 	struct kvaser_pciefd *pcie = (struct kvaser_pciefd *)dev;
 	const struct kvaser_pciefd_irq_mask *irq_mask = pcie->driver_data->irq_mask;
-	u32 board_irq = ioread32(KVASER_PCIEFD_PCI_IRQ_ADDR(pcie));
+	u32 pci_irq = ioread32(KVASER_PCIEFD_PCI_IRQ_ADDR(pcie));
 	int i;
 
-	if (!(board_irq & irq_mask->all))
+	if (!(pci_irq & irq_mask->all))
 		return IRQ_NONE;
 
-	if (board_irq & irq_mask->kcan_rx0)
+	if (pci_irq & irq_mask->kcan_rx0)
 		kvaser_pciefd_receive_irq(pcie);
 
 	for (i = 0; i < pcie->nr_channels; i++) {
-		if (board_irq & irq_mask->kcan_tx[i])
+		if (pci_irq & irq_mask->kcan_tx[i])
 			kvaser_pciefd_transmit_irq(pcie->can[i]);
 	}
 
-- 
2.43.0



