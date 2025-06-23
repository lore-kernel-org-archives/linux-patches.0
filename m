Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1899524A06B;
	Mon, 23 Jun 2025 13:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684461; cv=none; b=irFL3qJYCqiXbKE+NIuemNMCC0rLSVvHq86A/XiD8m5mMwvwDjcPmiB97K+UrBxUmvkYRe/ahKOBUdOIxu9LlFxqDLaJnZP/VRtPQKwbPWipLmSTDHaS6AsfjcIU5QMlyJ43tS2YbgnYZOIYXs1JUCQWkP9nLzBJ+PdtNKQxRgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684461; c=relaxed/simple;
	bh=6H4NkMzMhmR7ne3liX6xB40xq8sT6wrck+xmCXMK4wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xw52RBSt8IXwXsmow96haCMd3K20UpQGqrMyAbJ6La+aZ8aKxcJQE0O0Nv3Jnj5JOgP+ZP6TBpovoNH0rBbOXRLiXwDGnxGzyTDhVLvNzAT8oJRLnZ4FB0A67f0Vlmu0Y+G5C68SpN9bsZdzOgx8TSk7cH+nX3Nhyq9ty2Lm2Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZ+K1Qml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZ+K1Qml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07EFC4CEEA;
	Mon, 23 Jun 2025 13:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684461;
	bh=6H4NkMzMhmR7ne3liX6xB40xq8sT6wrck+xmCXMK4wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZ+K1QmlIe2N3zbKlkd0oDTINlfFMGPfECb7FL0LDReywfeTZAo9nXMWm3UQ+SLrM
	 JpDX9Pwudh7A69zL68mHxrA9qFdkiZMB4rS7Q+C63blRd+RwPDsn/CM5G9QFBW5FoD
	 mTATGc3g/Bd8cbyr688o8dy6FEJ+lVlV/civxHAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.15 032/592] wifi: mt76: mt7925: fix host interrupt register initialization
Date: Mon, 23 Jun 2025 14:59:50 +0200
Message-ID: <20250623130701.003086216@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Michael Lo <michael.lo@mediatek.com>

commit ca872e0ad97159375da8f3d05cac1f48239e01d7 upstream.

ensure proper interrupt handling and aligns with the hardware spec by
updating the register offset for MT_WFDMA0_HOST_INT_ENA.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250509083512.455095-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c  |    3 ---
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -490,9 +490,6 @@ static int mt7925_pci_suspend(struct dev
 
 	/* disable interrupt */
 	mt76_wr(dev, dev->irq_map->host_irq_enable, 0);
-	mt76_wr(dev, MT_WFDMA0_HOST_INT_DIS,
-		dev->irq_map->tx.all_complete_mask |
-		MT_INT_RX_DONE_ALL | MT_INT_MCU_CMD);
 
 	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0x0);
 
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
@@ -28,7 +28,7 @@
 #define MT_MDP_TO_HIF			0
 #define MT_MDP_TO_WM			1
 
-#define MT_WFDMA0_HOST_INT_ENA		MT_WFDMA0(0x228)
+#define MT_WFDMA0_HOST_INT_ENA		MT_WFDMA0(0x204)
 #define MT_WFDMA0_HOST_INT_DIS		MT_WFDMA0(0x22c)
 #define HOST_RX_DONE_INT_ENA4		BIT(12)
 #define HOST_RX_DONE_INT_ENA5		BIT(13)


