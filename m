Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753A718661A;
	Tue, 10 Sep 2024 09:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961802; cv=none; b=FWlZb1ECwi0RLCWVAQJ/eu6+GpltTKQ1LTNC3KcsDN0sKR425IfTf0dJ3PNoAEdll62zOk8Fg8ayDphd6om2oKXKwelAfqWqk0zK2e3KecW/1yVNAQBahm57P/C5zjsA8OYCMAi1tzSq0wxiHFcTBpCxQqlb/r9LlretHOZgHiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961802; c=relaxed/simple;
	bh=CXdXhbgmZrdXIY62dfyzjLhiYe0eJA2xkohaK2i7vFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5XdzIzIqNifwpBDKwhR/9l+eSNi/Rb6n4V5vnx5W1egcOa57RfodjrMShiBi/j9S99p4R0kgwdcibSd9MkODcokYrCMw4556JGzmberXdni2D2p49oClutdGP0PBPjJhcauCOpzK6eV+An49G9MWUeJauNK1XrvTPeTuRCdwRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ykpe17mq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ykpe17mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F046AC4CEC3;
	Tue, 10 Sep 2024 09:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961802;
	bh=CXdXhbgmZrdXIY62dfyzjLhiYe0eJA2xkohaK2i7vFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ykpe17mqusYOZT/dr5JAF5cSxug0NfukkHAIPUXDBElh+AKaPJmpZj2XaaxCvZaPh
	 QdmJ8wOKyW92qmfDTOrFlO+ZMcp45kRKRK2OayRP/cgx+209oO85f38cLOPhQvsN4n
	 CIU1a8csvcUCTHEoZhfrh1bGieYTUVWFirqpuYK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 167/375] can: kvaser_pciefd: Rename board_irq to pci_irq
Date: Tue, 10 Sep 2024 11:29:24 +0200
Message-ID: <20240910092628.094124740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3ac18dd0a022..a026ea2f5b35 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1691,17 +1691,17 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
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



