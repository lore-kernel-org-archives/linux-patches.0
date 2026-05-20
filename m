Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0603A3E9C;
	Wed, 20 May 2026 16:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294783; cv=none; b=hTpSO1wAi/4Z32K3r5rSXrRLXImlQgSU9zhFLXj7fSZVA5m+VMIM4v90EScnVvjlbzLzE2scNE7gZnZjg/f4ZSR6iTHkzWmK637ShRActaaFIOePBKTHAInZjd7afWPZZ57SXA4pGZHaBq8iZbAn+Di/2BJMQ9OClAn72WPBCcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294783; c=relaxed/simple;
	bh=cdQzdCpFAgMc2Wj+8JD9IUYhkKHMg6izUvnGLeTfZ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJA/enyaAsxNwUJMmEuQj49vc4qzqSE2/F7Oznfjirj2bOrWJAEma0WQG5+rYqvTOS/Q+XlC4tjutDIGdJ81Cbstkycw16SrPmiI+Jx5uhj17LWzfz9pX6JnI24og8V7smNEvC+ARVYEkW9m+QS4RQwPdU5ZVhKpYTvaCjod/5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeRVgheT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeRVgheT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3361F000E9;
	Wed, 20 May 2026 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294782;
	bh=2KzXhfL1yNvsqO+EVr8udgfs8ZoQPrx43UCUhlFKhDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DeRVgheTC9AyEjxm2aNt1PZtSOPQsds/Fy/nC89nTChzPj2ysaU5lZBJ6u63VADGz
	 H5YtWW8dDBVJq0w5kfAFQk0Cu50Yzx9qWnM4EwcMMpIyRG9WKy7hc2hPjSt5e3M3c/
	 itSKZjRrZQTugVSXzrwiV766JsghwgLRaQkM3VE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0130/1146] wifi: mt76: mt7996: fix RRO EMU configuration
Date: Wed, 20 May 2026 18:06:20 +0200
Message-ID: <20260520162151.266708611@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 73b46379e5231138025b271ce8e158d2a8aa0768 ]

Use the correct helper to update specific bitfields instead of
overwriting the entire register.

Fixes: eedb427eb260 ("wifi: mt76: mt7996: Enable HW RRO for MT7992 chipset")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260312095724.2117448-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index ca671dabf00ab..fca2d84493b9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -858,8 +858,7 @@ void mt7996_rro_hw_init(struct mt7996_dev *dev)
 			}
 		} else {
 			/* set emul 3.0 function */
-			mt76_wr(dev, MT_RRO_3_0_EMU_CONF,
-				MT_RRO_3_0_EMU_CONF_EN_MASK);
+			mt76_set(dev, MT_RRO_3_0_EMU_CONF, MT_RRO_3_0_EMU_CONF_EN_MASK);
 
 			mt76_wr(dev, MT_RRO_ADDR_ARRAY_BASE0,
 				dev->wed_rro.addr_elem[0].phy_addr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index bf3fb9b734e85..fc08ef94df637 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2599,7 +2599,7 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	mt7996_dma_start(dev, false, false);
 
 	if (!is_mt7996(&dev->mt76) && dev->mt76.hwrro_mode == MT76_HWRRO_V3)
-		mt76_wr(dev, MT_RRO_3_0_EMU_CONF, MT_RRO_3_0_EMU_CONF_EN_MASK);
+		mt76_set(dev, MT_RRO_3_0_EMU_CONF, MT_RRO_3_0_EMU_CONF_EN_MASK);
 
 	if (mtk_wed_device_active(&dev->mt76.mmio.wed)) {
 		u32 wed_irq_mask = MT_INT_TX_DONE_BAND2 |
-- 
2.53.0



