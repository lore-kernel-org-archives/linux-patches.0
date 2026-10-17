Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308613BB9F7;
	Sat, 17 Oct 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259566; cv=none; b=H2HEk3rXrmW5xcFiSQii9nqBfIYhoRe1TJeNB5pYGojy9mtAAilB5tKkJjaDciTu7ONa+F6HRVYjlJ/1jxhLtCE+CYN7rb+5UUGI/zM1AJi52H1s8Acnlffqxw1hPZSPB7QhOqTCnIhnnTvXzUvbfNGHpb9RdzWaQctQdgWb6Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259566; c=relaxed/simple;
	bh=WUITDk3iVaboFanAKvpuYxpqnbdcc60ZYwbZgDm9rXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OohSNHsBHOLJMGiEb6XiKKxpNdnLlmzcUdLXzZu8F/ekSmOeszV2+kbD/8X0IN/C6Gpem/+kEPzwsGqGM53AxDn8wJ1/Wvckx0pQbiycM6zC8oEo1/5Chm2t4IrfhFrYCLCBEkeHlx5o89BHIiEOXkhgmSZtBFQO3Tya07ew7no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioJ6trPb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioJ6trPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4C91F000C4;
	Sat, 17 Oct 2026 17:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259565;
	bh=fw3ajt1h5ym9PdNMpjZT2BhrB343PW3fHE4y/TMyRZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioJ6trPb70F7thSvqP6F/tEFOvZIBNX1KPOQeyMY9mPRJccJSj90W2ftbQ5ECOEhF
	 9iELsUm6yD8+tq+JIVPMKIj4FVgjYtH5LR7BggER6zPbV8RUtgxBciNmDj+sBip0DD
	 Af+YmF+NVx1vRt9Sct5Ybt1cw9KL/F0JlxjQaSM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1256/1674] wifi: mt76: mt7915: set correct background radar capability
Date: Sat, 17 Oct 2026 17:58:48 +0200
Message-ID: <20261017160503.381931270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 888208d1ccc41bebe97744445787183b17bb3ea4 ]

Some of the variants do not support background radar, so add a
helper to report background radar capability.
For mt7916, only the variant of 5G 2T2R + 1R supports background
radar.

Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Reviewed-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250320015909.3948612-1-StanleyYP.Wang@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 44b5adfe4949 ("wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/debugfs.c   |  5 +++
 .../wireless/mediatek/mt76/mt7915/eeprom.c    | 33 ++++++++++++++++++-
 .../wireless/mediatek/mt76/mt7915/eeprom.h    |  1 +
 .../net/wireless/mediatek/mt76/mt7915/init.c  |  7 ++--
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   |  8 +++--
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  3 +-
 6 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 450f4d221184b..1646328bde9c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -444,6 +444,11 @@ mt7915_rdd_monitor(struct seq_file *s, void *data)
 
 	mutex_lock(&dev->mt76.mutex);
 
+	if (!mt7915_eeprom_has_background_radar(dev)) {
+		seq_puts(s, "no background radar capability\n");
+		goto out;
+	}
+
 	if (!cfg80211_chandef_valid(chandef)) {
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 0425cf8b5650f..cf9fe6b533fc2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -136,7 +136,7 @@ static int mt7915_eeprom_load(struct mt7915_dev *dev)
 		/* read eeprom data from efuse */
 		block_num = DIV_ROUND_UP(eeprom_size, eeprom_blk_size);
 		for (i = 0; i < block_num; i++) {
-			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size);
+			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size, NULL);
 			if (ret < 0)
 				return ret;
 		}
@@ -353,6 +353,37 @@ s8 mt7915_eeprom_get_power_delta(struct mt7915_dev *dev, int band)
 	return val & MT_EE_RATE_DELTA_SIGN ? delta : -delta;
 }
 
+bool
+mt7915_eeprom_has_background_radar(struct mt7915_dev *dev)
+{
+	u8 val, buf[MT7915_EEPROM_BLOCK_SIZE];
+	u8 band_sel, tx_path, rx_path;
+	int offs = MT_EE_WIFI_CONF + 1;
+
+	switch (mt76_chip(&dev->mt76)) {
+	case 0x7915:
+		return true;
+	case 0x7906:
+		/* read efuse to check background radar capability */
+		if (mt7915_mcu_get_eeprom(dev, offs, buf))
+			break;
+
+		val = buf[offs % MT7915_EEPROM_BLOCK_SIZE];
+		band_sel = u8_get_bits(val, MT_EE_WIFI_CONF0_BAND_SEL);
+		tx_path = u8_get_bits(val, MT_EE_WIFI_CONF0_TX_PATH);
+		rx_path = u8_get_bits(val, MT_EE_WIFI_CONF0_RX_PATH);
+
+		return (band_sel == MT_EE_V2_BAND_SEL_5GHZ &&
+			tx_path == rx_path && rx_path == 2);
+	case 0x7981:
+	case 0x7986:
+	default:
+		break;
+	}
+
+	return false;
+}
+
 const u8 mt7915_sku_group_len[] = {
 	[SKU_CCK] = 4,
 	[SKU_OFDM] = 8,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
index adc26a222823b..ca0506df1ef39 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
@@ -45,6 +45,7 @@ enum mt7915_eeprom_field {
 #define MT_EE_CAL_DPD_SIZE			(54 * MT_EE_CAL_UNIT)
 
 #define MT_EE_WIFI_CONF0_TX_PATH		GENMASK(2, 0)
+#define MT_EE_WIFI_CONF0_RX_PATH		GENMASK(5, 3)
 #define MT_EE_WIFI_CONF0_BAND_SEL		GENMASK(7, 6)
 #define MT_EE_WIFI_CONF1_BAND_SEL		GENMASK(7, 6)
 #define MT_EE_WIFI_CONF_STREAM_NUM		GENMASK(7, 5)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ba8da7e2e7e6f..c5f4ced8f4b11 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -377,9 +377,10 @@ mt7915_init_wiphy(struct mt7915_phy *phy)
 	if (!is_mt7915(&dev->mt76))
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_STA_TX_PWR);
 
-	if (!mdev->dev->of_node ||
-	    !of_property_read_bool(mdev->dev->of_node,
-				   "mediatek,disable-radar-background"))
+	if (mt7915_eeprom_has_background_radar(phy->dev) &&
+	    (!mdev->dev->of_node ||
+	     !of_property_read_bool(mdev->dev->of_node,
+				    "mediatek,disable-radar-background")))
 		wiphy_ext_feature_set(wiphy,
 				      NL80211_EXT_FEATURE_RADAR_BACKGROUND);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index e74ff483f2e18..ce51bb27f7a4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2840,7 +2840,7 @@ int mt7915_mcu_set_eeprom(struct mt7915_dev *dev)
 				 &req, sizeof(req), true);
 }
 
-int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
+int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf)
 {
 	struct mt7915_mcu_eeprom_info req = {
 		.addr = cpu_to_le32(round_down(offset,
@@ -2848,8 +2848,8 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
 	};
 	struct mt7915_mcu_eeprom_info *res;
 	struct sk_buff *skb;
+	u8 *buf = read_buf;
 	int ret;
-	u8 *buf;
 
 	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
 					MCU_EXT_QUERY(EFUSE_ACCESS),
@@ -2858,8 +2858,10 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
 		return ret;
 
 	res = (struct mt7915_mcu_eeprom_info *)skb->data;
-	buf = dev->mt76.eeprom.data + le32_to_cpu(res->addr);
+	if (!buf)
+		buf = dev->mt76.eeprom.data + le32_to_cpu(res->addr);
 	memcpy(buf, res->data, MT7915_EEPROM_BLOCK_SIZE);
+
 	dev_kfree_skb(skb);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 19e3a773d9c2a..94dbe3045260a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -439,6 +439,7 @@ int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
 				   struct ieee80211_channel *chan,
 				   u8 chain_idx);
 s8 mt7915_eeprom_get_power_delta(struct mt7915_dev *dev, int band);
+bool mt7915_eeprom_has_background_radar(struct mt7915_dev *dev);
 int mt7915_dma_init(struct mt7915_dev *dev, struct mt7915_phy *phy2);
 void mt7915_dma_prefetch(struct mt7915_dev *dev);
 void mt7915_dma_cleanup(struct mt7915_dev *dev);
@@ -490,7 +491,7 @@ int mt7915_mcu_set_fixed_rate_ctrl(struct mt7915_dev *dev,
 				   struct ieee80211_sta *sta,
 				   void *data, u32 field);
 int mt7915_mcu_set_eeprom(struct mt7915_dev *dev);
-int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset);
+int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf);
 int mt7915_mcu_get_eeprom_free_block(struct mt7915_dev *dev, u8 *block_num);
 int mt7915_mcu_set_mac(struct mt7915_dev *dev, int band, bool enable,
 		       bool hdr_trans);
-- 
2.53.0



