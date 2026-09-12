Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD627331203;
	Sat, 12 Sep 2026 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230454; cv=none; b=Q+QiYszzN4Wi03zFNWjCHBuTIuSm5rHphEpjyTDAvYLIQMJ0gPjTzBxSiqxVtJrh52sGqq4OYMSYHNOSIHM8QJ7+G5BGO+Dqs01IZRjBhqnxI+7vQe81eeIRmVGLGZ7RcWazzd2LKhkLX7LcM4Qoc42kBuZf9Q5y3VrJRAV4thY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230454; c=relaxed/simple;
	bh=kRmnblH2Hte8xiQIUhjJ25pRgDazxr4qI8ubRihSxgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=it7i4/e7XjlOIMjNKNIuEfrrMxiltDZWaZ1ANxqBBrFyTkCk3Lqad/n5Z/kdAcpsoNSomRKlgrkqyHekRkvXEWDeILgB+NlrFgv3Ft1DUIH653ACLex9RSl6LDkoLpy91Zqxm2/4MjGvtE1KR4sQFVEGHrFbJr7Vp9S64PXaLGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yT6diJ9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yT6diJ9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E5C1F000FF;
	Sat, 12 Sep 2026 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230453;
	bh=gYAZcMAzJ7AZruyYKKaayhSao5EhrjD8LUszE62U/SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yT6diJ9pesvydK3sTl5lAww7kKAHmE/gKi9YRmVUdfyASzNZ02tqI9XMY94KZP9gV
	 ctc8/G8QXLqyyuLwqGSfzzClztnFUf2C9BGN1sBK5XT/jz4ITtw/EvULVLrblikx61
	 Ftun5XMvvfZ+/iaHl5mynkDVfSV1zw+vICZS8byc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0798/1191] wifi: mt76: mt7915: enable wed for mt7986 chipset
Date: Sat, 12 Sep 2026 08:58:46 +0200
Message-ID: <20260912065606.195861807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit b7ebf46e2526c860d46f98ab93cab547069461f6 ]

Introduce wed tx support for MT7986 chipset

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: bade0d238b60 ("wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c  |  1 +
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c | 11 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h |  8 ++++++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index 00aafc2422f3b..90a89cf493a9d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -324,6 +324,7 @@ static int mt7915_dma_enable(struct mt7915_dev *dev)
 
 		wed_irq_mask |= MT_INT_TX_DONE_BAND0 | MT_INT_TX_DONE_BAND1;
 		mt76_wr(dev, MT_INT_WED_MASK_CSR, wed_irq_mask);
+		mt76_wr(dev, MT_INT_MASK_CSR, wed_irq_mask);
 		mtk_wed_device_start(&dev->mt76.mmio.wed, wed_irq_mask);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index 08031ebd6907b..cc6bb61452544 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -541,7 +541,18 @@ int mt7915_mmio_wed_init(struct mt7915_dev *dev, struct pci_dev *pdev,
 	wed->wlan.pci_dev = pdev;
 	wed->wlan.wpdma_phys = pci_resource_start(pdev, 0) +
 			       MT_WFDMA_EXT_CSR_BASE;
+	wed->wlan.wpdma_int = pci_resource_start(pdev, 0) +
+			      MT_INT_WED_SOURCE_CSR;
+	wed->wlan.wpdma_mask = pci_resource_start(pdev, 0) +
+			       MT_INT_WED_MASK_CSR;
+	wed->wlan.wpdma_tx = pci_resource_start(pdev, 0) +
+			     MT_TXQ_WED_RING_BASE;
+	wed->wlan.wpdma_txfree = pci_resource_start(pdev, 0) +
+				 MT_RXQ_WED_RING_BASE;
 	wed->wlan.nbuf = 4096;
+	wed->wlan.tx_tbit[0] = MT_WED_TX_DONE_BAND0;
+	wed->wlan.tx_tbit[1] = MT_WED_TX_DONE_BAND1;
+	wed->wlan.txfree_tbit = MT_WED_TX_FREE_DONE;
 	wed->wlan.token_start = MT7915_TOKEN_SIZE - wed->wlan.nbuf;
 	wed->wlan.init_buf = mt7915_wed_init_buf;
 	wed->wlan.offload_enable = mt7915_mmio_wed_offload_enable;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index bf569aa0057a7..071720b0a83bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -596,6 +596,7 @@ enum offs_rev {
 #define MT_PCIE_RECOG_ID_MASK		GENMASK(30, 0)
 #define MT_PCIE_RECOG_ID_SEM		BIT(31)
 
+#define MT_INT_WED_SOURCE_CSR		MT_WFDMA_EXT_CSR(0x200)
 #define MT_INT_WED_MASK_CSR		MT_WFDMA_EXT_CSR(0x204)
 
 #define MT_WED_TX_RING_BASE		MT_WFDMA_EXT_CSR(0x300)
@@ -642,6 +643,13 @@ enum offs_rev {
 #define MT_TXQ_EXT_CTRL(q)		(MT_Q_BASE(__TXQ(q)) + 0x600 +	\
 					 MT_TXQ_ID(q)* 0x4)
 
+#define MT_TXQ_WED_RING_BASE		0xd7300
+#define MT_RXQ_WED_RING_BASE		0xd7410
+
+#define MT_WED_TX_DONE_BAND0		4
+#define MT_WED_TX_DONE_BAND1		5
+#define MT_WED_TX_FREE_DONE		1
+
 #define MT_INT_SOURCE_CSR		__REG(INT_SOURCE_CSR)
 #define MT_INT_MASK_CSR			__REG(INT_MASK_CSR)
 
-- 
2.53.0



