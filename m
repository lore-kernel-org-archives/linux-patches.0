Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025855;
	b=ryUExmzv4WXpyRZEVIY2ZOjGmRcUJkyGpEfO4VwhrQf9rWqh9Wi24OkyL7yS7YYIy460
	 AGqZ7GhoRYF15h3SVDRP3jHLzqX+WVTiDzR7cZV48xbhPO6/o7w/pZpMGaZTHcx8pPoXk
	 RXA7ZL2DLJ8l1MB+0fLn+NBOuq3jK+8Jxcv1uR3PzIU+mG+Xjknb4TUPsvKA/CsTBCJ6J
	 Y95Mz717z3S+j/jA9NvU4v8F2h9JMggofTbSA0iMG7RCn0IkIOJ9L4qEpxnRq+wvr9XOl
	 WykF91WnjOLO0SHDirEh6OaSA1vNEvzorAKSZTCHjJOfopveK4j9DdsglZK1i+N2jkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XiQIy+CFWinnAwMqvu/tKa0Z6LwwuAYyryHEZaRB/TQ=;
	b=VRzHCpGwuUfOs6Qqyi66xjKsmsXZynm1vcH0RUTA7zcZj/DlWQQzuV13V4npEwybXrtE
	 ZtFhVlwpRo2tmfe82+5j6WQrPfzN8BjJakdpszrzjfCX/vrxOM/BmQyY34D9Zij0ByQaA
	 OCLpUxugvDavtNFT2vltSVbF3u89jq75pYb0S5IuBW0KINSfkB0N52r3WYHeU76kvqhQQ
	 0PojATcNn+qR1M2f8jjgnvme95NK4y4EPY0jXT9hCuOoGivVc5m4tV0V1xn3YMpnYmUk3
	 +KhFQTT1h4is+8t8pnSrmbzVVoVWdOZXzubxqUwXFIufTxjmXGOnm2IoVPtUli07WPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGFacoWJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10183606A325;
	Wed, 18 Nov 2026 18:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGFacoWJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9171F000C5;
	Wed, 18 Nov 2026 18:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025854;
	bh=XiQIy+CFWinnAwMqvu/tKa0Z6LwwuAYyryHEZaRB/TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGFacoWJygyXUn7OEgGV62zypf/8hgyHyxQC39j35iX+4my05w4BfLg1jQAC7XTyK
	 kxQAs7BXtF9aKcelOnzEuCA/zZvmahFcfpppk2kB48FTRjxXKfi22/8EIs1X+GGyvi
	 nzYysIwB2SwnYJCnLtJkDqKOUAHwdDjQf/UDCrJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1226/2151] wifi: mt76: mt7996: enable the SKU power limit table
Date: Wed, 18 Nov 2026 15:49:21 +0100
Message-ID: <20261118150206.847154834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 267424ac63aa65fb28b7f3cff1e1a7d0098c4d6f ]

mt7996_mcu_set_txpower_sku() uploads the per-rate power limit table, but
the firmware applies it only after the driver enables the SKU power
limit. mt7915 does that in mt7915_mcu_set_sku_en(); mt7996 never does,
so the radio keeps the EEPROM target power and the configured tx power
has no effect.

Add the power control command and enable the table per band in
mt7996_run(), as the MediaTek vendor driver does.

The backoff table stays disabled. This driver does not build the
per-path limits; it pads that part of the message with zeros.

Fixes: f75e4779d215 ("wifi: mt76: mt7996: add txpower setting support")
Link: https://patch.msgid.link/20261006205936.669125-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  5 +++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 34 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   | 23 +++++++++++++
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 4 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 8aa443e768796..48f22df0cd714 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -34,6 +34,11 @@ int mt7996_run(struct mt7996_phy *phy)
 	if (ret)
 		return ret;
 
+	ret = mt7996_mcu_set_tx_power_ctrl(phy, UNI_TXPOWER_SKU_POWER_LIMIT_CTRL,
+					   true);
+	if (ret)
+		return ret;
+
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
 
 	ieee80211_queue_delayed_work(dev->mphy.hw, &phy->mt76->mac_work,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 3a7d19da7f7fb..21efb45abb3e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -5012,6 +5012,40 @@ int mt7996_mcu_set_sniffer_mode(struct mt7996_phy *phy, bool enabled)
 				 sizeof(req), true);
 }
 
+int mt7996_mcu_set_tx_power_ctrl(struct mt7996_phy *phy, u8 power_ctrl_id, u8 data)
+{
+	struct mt7996_dev *dev = phy->dev;
+	struct tx_power_ctrl req = {
+		.tag = cpu_to_le16(power_ctrl_id),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.power_ctrl_id = power_ctrl_id,
+		.band_idx = phy->mt76->band_idx,
+	};
+
+	switch (power_ctrl_id) {
+	case UNI_TXPOWER_SKU_POWER_LIMIT_CTRL:
+		req.sku_enable = !!data;
+		break;
+	case UNI_TXPOWER_PERCENTAGE_CTRL:
+		req.percentage_ctrl_enable = !!data;
+		break;
+	case UNI_TXPOWER_PERCENTAGE_DROP_CTRL:
+		req.power_drop_level = data;
+		break;
+	case UNI_TXPOWER_BACKOFF_POWER_LIMIT_CTRL:
+		req.bf_backoff_enable = !!data;
+		break;
+	case UNI_TXPOWER_ATE_MODE_CTRL:
+		req.ate_mode_enable = !!data;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_WM_UNI_CMD(TXPOWER),
+				 &req, sizeof(req), false);
+}
+
 int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy)
 {
 #define TX_POWER_LIMIT_TABLE_RATE	0
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index dab900c98154e..e8ec47fe114f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -904,8 +904,31 @@ enum {
 	UNI_CMD_THERMAL_PROTECT_DUTY_CONFIG,
 };
 
+struct tx_power_ctrl {
+	u8 _rsv[4];
+
+	__le16 tag;
+	__le16 len;
+
+	u8 power_ctrl_id;
+	union {
+		bool sku_enable;
+		bool ate_mode_enable;
+		bool percentage_ctrl_enable;
+		bool bf_backoff_enable;
+		u8 power_drop_level;
+	};
+	u8 band_idx;
+	u8 rsv[1];
+} __packed;
+
 enum {
+	UNI_TXPOWER_SKU_POWER_LIMIT_CTRL = 0,
+	UNI_TXPOWER_PERCENTAGE_CTRL = 1,
+	UNI_TXPOWER_PERCENTAGE_DROP_CTRL = 2,
+	UNI_TXPOWER_BACKOFF_POWER_LIMIT_CTRL = 3,
 	UNI_TXPOWER_POWER_LIMIT_TABLE_CTRL = 4,
+	UNI_TXPOWER_ATE_MODE_CTRL = 6,
 };
 
 enum {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index e371b2f174e58..f1c11615f5c13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -749,6 +749,7 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy);
 int mt7996_mcu_set_thermal_throttling(struct mt7996_phy *phy, u8 state);
 int mt7996_mcu_set_thermal_protect(struct mt7996_phy *phy, bool enable);
 int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy);
+int mt7996_mcu_set_tx_power_ctrl(struct mt7996_phy *phy, u8 power_ctrl_id, u8 data);
 int mt7996_mcu_rdd_resume_tx(struct mt7996_phy *phy);
 int mt7996_mcu_rdd_cmd(struct mt7996_dev *dev, int cmd, u8 rdd_idx, u8 val);
 int mt7996_mcu_rdd_background_enable(struct mt7996_phy *phy,
-- 
2.53.0



