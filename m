Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215966;
	b=TzMr+RtbMwb+bWUfKwlBcoUJRDs8pcGSHvbF4vWf85F6CDcEaq53gYlWmI2JXKgQKDfQ
	 m2LUvi1U2tnlHFM9Ve1wDg+e+C6OJKvFVkJJLTPKorEXJev7LdA2SJ7ps7yw1/yKWM7rA
	 aK1WbLgEQ+X1D6JSk2PlzwgbFEKGsCvCbsWyZM39HfCK8KnhgaqR/O22aD13ruv6MHSA6
	 tsrnLwkHSYm0C8gdbM7m1Lk3cZKTV8b09WFd3F1vmVEQFZb888oP3Jjb71rnGcVBgoxLd
	 7EzQD8b/ljZGpFgfAhPnjQrg+AsdRPXgkk8vexepCm0bK6Pzih0zQWHfttFetqQOgzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G3qNTyYmB0FXCasYFr85nzAWZ5HseHwBFtYMx4TFdeQ=;
	b=F0fVZGXPLQur36ff25x5HfWfJ3LLzwbGRTH1zpGMW22JPegsEZm9nBKl0Rh+qzHEZeje
	 ORGpZxWpVErdCzMJTsevGbkTvqJ4jHmnSZ7NJlrHhVujydwQx8h1NojF19/p/2H1cTcgV
	 +KC77RoI6vE3ouRhsllpY4cM5TjKHu6nzgkhBxHd03AGJMpffloAsLfaY9mm1/IOlp6NT
	 nCMInlPhp30Bt3NCNZXyffgLQQ0W87CIU/eogF1R6SWK+kJWNgVlz3sHzldB4AoZht29P
	 JCUXmU9Q97v0kDfK0uUV5zLLvVcNyS0ieIHSqUltogQ7l5IR6efbC7NlmI776U6LvHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+UggAC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F2C606A320;
	Wed, 28 Oct 2026 19:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+UggAC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E151F01825;
	Wed, 28 Oct 2026 19:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215965;
	bh=G3qNTyYmB0FXCasYFr85nzAWZ5HseHwBFtYMx4TFdeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+UggAC5hzBtgMlT7iP+oGlJW/da/3JLXk3BJAEzxHta2BW8HnJL+rEM23u1oCBQE
	 tiwcV84iS+Ihx6JGKUITgtJLhGNo/Jb0jWa1hCBYXZVUNSKyxmntur3A1haSzUGHDZ
	 qWY8Tn0YYXLrvY7oaAsMPBowFc4+r9dPP0lxUJAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1367/1887] wifi: mt76: mt7915: set correct background radar capability
Date: Wed, 28 Oct 2026 17:57:43 +0100
Message-ID: <20261028170530.556248535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 80f0488871df7..b6fe6da68feb1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -452,6 +452,11 @@ mt7915_rdd_monitor(struct seq_file *s, void *data)
 
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
index f0ec000d46cf7..8b43fb6418088 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -123,7 +123,7 @@ static int mt7915_eeprom_load(struct mt7915_dev *dev)
 		/* read eeprom data from efuse */
 		block_num = DIV_ROUND_UP(eeprom_size, eeprom_blk_size);
 		for (i = 0; i < block_num; i++) {
-			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size);
+			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size, NULL);
 			if (ret < 0)
 				return ret;
 		}
@@ -326,6 +326,37 @@ s8 mt7915_eeprom_get_power_delta(struct mt7915_dev *dev, int band)
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
index f3e56817d36e9..ddb771ba45d25 100644
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
index 7d1e2aa732897..782ce83bdab96 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -353,9 +353,10 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_UNSOL_BCAST_PROBE_RESP);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_FILS_DISCOVERY);
 
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
index f1f6bcc499494..9074ebae752d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2751,7 +2751,7 @@ int mt7915_mcu_set_eeprom(struct mt7915_dev *dev)
 				 &req, sizeof(req), true);
 }
 
-int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
+int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf)
 {
 	struct mt7915_mcu_eeprom_info req = {
 		.addr = cpu_to_le32(round_down(offset,
@@ -2759,8 +2759,8 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
 	};
 	struct mt7915_mcu_eeprom_info *res;
 	struct sk_buff *skb;
+	u8 *buf = read_buf;
 	int ret;
-	u8 *buf;
 
 	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
 					MCU_EXT_QUERY(EFUSE_ACCESS),
@@ -2769,8 +2769,10 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
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
index ebe1cb0429d01..c2b3a28d71691 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -465,6 +465,7 @@ int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
 				   struct ieee80211_channel *chan,
 				   u8 chain_idx);
 s8 mt7915_eeprom_get_power_delta(struct mt7915_dev *dev, int band);
+bool mt7915_eeprom_has_background_radar(struct mt7915_dev *dev);
 int mt7915_dma_init(struct mt7915_dev *dev, struct mt7915_phy *phy2);
 void mt7915_dma_prefetch(struct mt7915_dev *dev);
 void mt7915_dma_cleanup(struct mt7915_dev *dev);
@@ -511,7 +512,7 @@ int mt7915_mcu_set_fixed_rate_ctrl(struct mt7915_dev *dev,
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



