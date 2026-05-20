Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B391335AC18;
	Wed, 20 May 2026 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297638; cv=none; b=JlzFQP/3gMOCtFTnh63Uoq/11mXBirnviULHbtyEz3cv6CEXWO13xUfQvv/Lpt9bmEBe7lwXm3H1s83+kjQYtIBaMpH2BAEf9xXQrHYI38himHC4hAqhObGYJuDlbwuizqFA9X2d6++zQ+KxCG4FStW28MnEqnTLL0MSZhBQQtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297638; c=relaxed/simple;
	bh=ztRcoxZAu8mIQdKfANVLOkWA2hwup68P+z97j4Clw1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7e6817pn7JMkEo1Gz8GCmDEHdBSB8mMv949o3cLCSimYMgNIR5izL/YJd4kK1NnovTMr0TCZV2ByUGdOAdxJGG537ArTw6lRH70el1ePVDFwHKtNYotVzokA5b/QLWGnbTKztFqeGKZOTf6kgOFevYWaYSdtde+QPPXrqbLyjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7LylQI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7LylQI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253301F000E9;
	Wed, 20 May 2026 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297637;
	bh=NgN95DBoUtr/9c9OrwUXT4lw4UKquZnB18W1hrN2Grc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7LylQI6ubnCb/53ifM1DIvMOw10SsghXf7BpwbbvCZcW+irf4nf9sAeCn81gcx/l
	 Jmj8G7POqXs9H/PoY+nER9/GaVqFEN7FYkdM153wKO81GfzgZk2Rs1BI2mg9ePai0b
	 7bUrnNFg7xXaZpPmXOnRKCzCLKkCxUZWArDO5pn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/957] wifi: mt76: mt7996: fix RRO EMU configuration
Date: Wed, 20 May 2026 18:09:50 +0200
Message-ID: <20260520162136.882148915@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 817acfad31d06..efbd46d649017 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -857,8 +857,7 @@ void mt7996_rro_hw_init(struct mt7996_dev *dev)
 			}
 		} else {
 			/* set emul 3.0 function */
-			mt76_wr(dev, MT_RRO_3_0_EMU_CONF,
-				MT_RRO_3_0_EMU_CONF_EN_MASK);
+			mt76_set(dev, MT_RRO_3_0_EMU_CONF, MT_RRO_3_0_EMU_CONF_EN_MASK);
 
 			mt76_wr(dev, MT_RRO_ADDR_ARRAY_BASE0,
 				dev->wed_rro.addr_elem[0].phy_addr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index c375b4dd68a20..149d8d711fc4c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2597,7 +2597,7 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	mt7996_dma_start(dev, false, false);
 
 	if (!is_mt7996(&dev->mt76) && dev->mt76.hwrro_mode == MT76_HWRRO_V3)
-		mt76_wr(dev, MT_RRO_3_0_EMU_CONF, MT_RRO_3_0_EMU_CONF_EN_MASK);
+		mt76_set(dev, MT_RRO_3_0_EMU_CONF, MT_RRO_3_0_EMU_CONF_EN_MASK);
 
 	if (mtk_wed_device_active(&dev->mt76.mmio.wed)) {
 		u32 wed_irq_mask = MT_INT_TX_DONE_BAND2 |
-- 
2.53.0



