Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2071591E3;
	Wed,  5 Feb 2025 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763938; cv=none; b=mGkdvUyCJVOUB8Ty7ymUPA1+gHe3KlI/TK0KIVJR2+TwAFAn4HqHLV3HyJa/i1IenxDCcCEiiZB10d5AmsAfuiyOIV+KDJb6Sn4qhE4fvmWEqgaOPLdtjC/srZurIHdivfKMCN10zjy+VwZwhNGp8sH6dKF/jSGxb/q/8ejLyPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763938; c=relaxed/simple;
	bh=0re4m+KD77G0jDjk1+pNEjEwIlaGttovquFDPs6wCtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1RyQkth4oeKc5Eeq9t44mghEsfjVbkLQBzsRb40MONj4kN8tdGNwmNvb4B+H1iFjRWhhtaOZV08AjqTOrQp5x6tN2sO84qJaWyurwg5rP0AH3ZiSkU0QDP+IAwX7+UNOb8mlhqUkUb1Vik4NhyeZh7odR3h5iG443ni1f1uEWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgzLKAjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgzLKAjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0CBC4CEE4;
	Wed,  5 Feb 2025 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763938;
	bh=0re4m+KD77G0jDjk1+pNEjEwIlaGttovquFDPs6wCtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgzLKAjPlOuWYWQyQBK8BYTjo1je61q63rZt4ZPsLBO+P6Kl+nIG8sA4UCueSRBFY
	 eZLnHM2Wu7JQMhyUTXf9p0vZ/SdVx/aQbupbvVGrqOX46+AuPUUrM2va4ZPxAr3wD+
	 5aY+Fo+NGdwJd1IKA3supnljEjg+q5kQV6hWNPdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/393] wifi: mt76: connac: move mt7615_mcu_del_wtbl_all to connac
Date: Wed,  5 Feb 2025 14:40:40 +0100
Message-ID: <20250205134424.925722924@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b2141eadf8be6285ff8980cab153079231cab4fd ]

Preparation for reusing it in mt7915

Link: https://patch.msgid.link/20240827093011.18621-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: cd043bbba6f9 ("wifi: mt76: mt7915: fix omac index assignment after hardware reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c     |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c      | 10 ----------
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h   |  1 -
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 11 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h |  1 +
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index f22a1aa885052..129350186d5d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -325,7 +325,7 @@ void mt7615_init_work(struct mt7615_dev *dev)
 	mt7615_mcu_set_eeprom(dev);
 	mt7615_mac_init(dev);
 	mt7615_phy_init(dev);
-	mt7615_mcu_del_wtbl_all(dev);
+	mt76_connac_mcu_del_wtbl_all(&dev->mt76);
 	mt7615_check_offload_capability(dev);
 }
 EXPORT_SYMBOL_GPL(mt7615_init_work);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 955974a82180f..e92040616a1f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1876,16 +1876,6 @@ int mt7615_mcu_set_dbdc(struct mt7615_dev *dev)
 				 sizeof(req), true);
 }
 
-int mt7615_mcu_del_wtbl_all(struct mt7615_dev *dev)
-{
-	struct wtbl_req_hdr req = {
-		.operation = WTBL_RESET_ALL,
-	};
-
-	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(WTBL_UPDATE),
-				 &req, sizeof(req), true);
-}
-
 int mt7615_mcu_set_fcc5_lpn(struct mt7615_dev *dev, int val)
 {
 	struct {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index a20322aae9672..fa83b255e180c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -399,7 +399,6 @@ void mt7615_mac_set_rates(struct mt7615_phy *phy, struct mt7615_sta *sta,
 			  struct ieee80211_tx_rate *rates);
 void mt7615_pm_wake_work(struct work_struct *work);
 void mt7615_pm_power_save_work(struct work_struct *work);
-int mt7615_mcu_del_wtbl_all(struct mt7615_dev *dev);
 int mt7615_mcu_set_chan_info(struct mt7615_phy *phy, int cmd);
 int mt7615_mcu_set_wmm(struct mt7615_dev *dev, u8 queue,
 		       const struct ieee80211_tx_queue_params *params);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 998cfd73764a9..7420d91bef0de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2926,6 +2926,17 @@ int mt76_connac_mcu_restart(struct mt76_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_restart);
 
+int mt76_connac_mcu_del_wtbl_all(struct mt76_dev *dev)
+{
+	struct wtbl_req_hdr req = {
+		.operation = WTBL_RESET_ALL,
+	};
+
+	return mt76_mcu_send_msg(dev, MCU_EXT_CMD(WTBL_UPDATE),
+				 &req, sizeof(req), true);
+}
+EXPORT_SYMBOL_GPL(mt76_connac_mcu_del_wtbl_all);
+
 int mt76_connac_mcu_rdd_cmd(struct mt76_dev *dev, int cmd, u8 index,
 			    u8 rx_sel, u8 val)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 4543e5bf0482d..27391ee3564a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1914,6 +1914,7 @@ void mt76_connac_mcu_wtbl_smps_tlv(struct sk_buff *skb,
 				   void *sta_wtbl, void *wtbl_tlv);
 int mt76_connac_mcu_set_pm(struct mt76_dev *dev, int band, int enter);
 int mt76_connac_mcu_restart(struct mt76_dev *dev);
+int mt76_connac_mcu_del_wtbl_all(struct mt76_dev *dev);
 int mt76_connac_mcu_rdd_cmd(struct mt76_dev *dev, int cmd, u8 index,
 			    u8 rx_sel, u8 val);
 int mt76_connac_mcu_sta_wed_update(struct mt76_dev *dev, struct sk_buff *skb);
-- 
2.39.5



