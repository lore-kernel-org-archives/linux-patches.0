Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEF851CF7E;
	Wed, 30 Sep 2026 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789799; cv=none; b=YQCp/9OJGnxSn55GJQXCRmXeiH4bZdtfs9qNJ/XP+62VR81QkJ74AsIespnxBD7wkO5hMqgMbgLin3IdEcnMlSMZXfQL+IPC/HpgUd/c3zgquZZvah6SFQD3XfRJd88HGMrzYbTBJuBw/g8tKDiT36SJjvci650/ZRVUhcW/b14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789799; c=relaxed/simple;
	bh=tp7Q7fEALNaFbgTqJ9U0W7DvclattTLfGwCfeWh8PX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao+SKhvtCTGMRhkPhZUdt5MaRf85aZiegtUmx0eJA8TatmmHKBrVnp9kof2v1IIMOXVquBvMDWtVUno5JnBKmbwN5FlVHKVE03cAwWGxfiFAmhPtaUCKlR1kDRr8HEsVNop0d/24LWaaSQwDCLFJu45LPzAp14OyhnkkQw3MIAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auQ0c0zb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auQ0c0zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9621F000FF;
	Wed, 30 Sep 2026 17:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789797;
	bh=P5M39J9oeKBnLjdOLv7257aUrwmfddopLj9SzMccrnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auQ0c0zbKsfiEGZHeKn9IVbrchhBbryvBqRm2yr/FFGcXhrSLSfo86y2iz6Wyosn/
	 wteNLvCvEu2c3pAr7klBvDa94AxRPTBlg3shPBRm9Hv2UJFTdcJTD3OCvN8J423Ozw
	 0dpgAQfKj8ZpnhVPnUSbwDjnBZZQmOIb3CLGuCzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 605/877] wifi: mt76: mt7915: set correct background radar capability
Date: Wed, 30 Sep 2026 17:25:16 +0200
Message-ID: <20260930152427.712117358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c |    5 +++
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c  |   33 +++++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h  |    1 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c    |    7 ++--
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c     |    8 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h  |    3 +
 6 files changed, 49 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -444,6 +444,11 @@ mt7915_rdd_monitor(struct seq_file *s, v
 
 	mutex_lock(&dev->mt76.mutex);
 
+	if (!mt7915_eeprom_has_background_radar(dev)) {
+		seq_puts(s, "no background radar capability\n");
+		goto out;
+	}
+
 	if (!cfg80211_chandef_valid(chandef)) {
 		ret = -EINVAL;
 		goto out;
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -147,7 +147,7 @@ static int mt7915_eeprom_load(struct mt7
 		/* read eeprom data from efuse */
 		block_num = DIV_ROUND_UP(eeprom_size, eeprom_blk_size);
 		for (i = 0; i < block_num; i++) {
-			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size);
+			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size, NULL);
 			if (ret < 0)
 				return ret;
 		}
@@ -359,6 +359,37 @@ s8 mt7915_eeprom_get_power_delta(struct
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
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
@@ -55,6 +55,7 @@ enum mt7915_eeprom_field {
 #define MT_EE_CAL_DPD_SIZE_V2			(300 * MT_EE_CAL_UNIT)
 
 #define MT_EE_WIFI_CONF0_TX_PATH		GENMASK(2, 0)
+#define MT_EE_WIFI_CONF0_RX_PATH		GENMASK(5, 3)
 #define MT_EE_WIFI_CONF0_BAND_SEL		GENMASK(7, 6)
 #define MT_EE_WIFI_CONF1_BAND_SEL		GENMASK(7, 6)
 #define MT_EE_WIFI_CONF_STREAM_NUM		GENMASK(7, 5)
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -389,9 +389,10 @@ mt7915_init_wiphy(struct mt7915_phy *phy
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
 
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2853,7 +2853,7 @@ int mt7915_mcu_set_eeprom(struct mt7915_
 				 &req, sizeof(req), true);
 }
 
-int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
+int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf)
 {
 	struct mt7915_mcu_eeprom_info req = {
 		.addr = cpu_to_le32(round_down(offset,
@@ -2861,8 +2861,8 @@ int mt7915_mcu_get_eeprom(struct mt7915_
 	};
 	struct mt7915_mcu_eeprom_info *res;
 	struct sk_buff *skb;
+	u8 *buf = read_buf;
 	int ret;
-	u8 *buf;
 
 	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
 					MCU_EXT_QUERY(EFUSE_ACCESS),
@@ -2871,8 +2871,10 @@ int mt7915_mcu_get_eeprom(struct mt7915_
 		return ret;
 
 	res = (struct mt7915_mcu_eeprom_info *)skb->data;
-	buf = dev->mt76.eeprom.data + le32_to_cpu(res->addr);
+	if (!buf)
+		buf = dev->mt76.eeprom.data + le32_to_cpu(res->addr);
 	memcpy(buf, res->data, MT7915_EEPROM_BLOCK_SIZE);
+
 	dev_kfree_skb(skb);
 
 	return 0;
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -445,6 +445,7 @@ int mt7915_eeprom_get_target_power(struc
 				   struct ieee80211_channel *chan,
 				   u8 chain_idx);
 s8 mt7915_eeprom_get_power_delta(struct mt7915_dev *dev, int band);
+bool mt7915_eeprom_has_background_radar(struct mt7915_dev *dev);
 int mt7915_dma_init(struct mt7915_dev *dev, struct mt7915_phy *phy2);
 void mt7915_dma_prefetch(struct mt7915_dev *dev);
 void mt7915_dma_cleanup(struct mt7915_dev *dev);
@@ -495,7 +496,7 @@ int mt7915_mcu_set_fixed_rate_ctrl(struc
 				   struct ieee80211_sta *sta,
 				   void *data, u32 field);
 int mt7915_mcu_set_eeprom(struct mt7915_dev *dev);
-int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset);
+int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf);
 int mt7915_mcu_get_eeprom_free_block(struct mt7915_dev *dev, u8 *block_num);
 int mt7915_mcu_set_mac(struct mt7915_dev *dev, int band, bool enable,
 		       bool hdr_trans);


