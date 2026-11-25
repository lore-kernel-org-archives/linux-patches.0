Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625334;
	b=HZAk7LSqJWAV9OoQgRS+aRCYxbTCeVBuZkpCR7X31+dWeW2qgnd9z+R4bWFl+dws0j0C
	 /+CSNvukzCz6OcJIqH5leUEM+sMA0wc/AQzO3VilJOY+HW3LEqK7rjEdJcXqqWmNew02B
	 Mn0dUNaeZVrixcMXXPiF6G+GMqGA3DpYPaVmuP6QJfF7ShGSCcqoCSWxNGpeUk2HyAzzQ
	 j5DB2ETt54n8sILdw9OOq7BYHaaXDDdWaf+5I6x/HRccrK5JmV0YkYKbwp5Pf5VN+hFNa
	 TuaHDVZ6S26CdLkk5kH7vvysVdWYBOiV66clrBrvvcbmwGvtP+cmeTpDr2F1x5DHzsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RWc0wfOPy+rWZ+EdRd3hYUMeD9jzHdXo7PGWBJZ1gzY=;
	b=EVbjIvtra4A/AbGLqyh5BJnVA5LrbpnC/9nDVa825BjPuT0zO60ClIEjdvzEMYjKi3LX
	 8LGoJE+ouvRWv1NZobjAV0dQGPILlgM//jkz28Wj9EiTvb5daO3BuaJ2BEcAe2iq05ZgX
	 qkk+p6FazbWWhtfWEzK2C62Sg4LLoc+Y9iEZoV5b/tSv7LQ9SHu4b9ik5TVhLJkhpn68C
	 aDajuV5I/6IvVPN+BuGMkYpCf6zo58MMkuiw0zbzCaozPtKnTl0JRituDjKJcMOA6YAxn
	 hzj6+PvYnPaeNhV8jnd2BeSbNILBAkU1GdXIzdsmw0v2lzdUXYe2XGy3OXfsieC5Qkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnK4gIE9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32116606A31E;
	Wed, 25 Nov 2026 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnK4gIE9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D121F000C4;
	Wed, 25 Nov 2026 16:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625334;
	bh=RWc0wfOPy+rWZ+EdRd3hYUMeD9jzHdXo7PGWBJZ1gzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnK4gIE9p8gYfz/8N3JHh7tfaVe+9nyC6MeHLpMvla/p99uWZ7qBOS75/PbzQPDAD
	 YWHX47Lf4RnFDRqXUDftqNDyiiElj/IKbAN9nnV0Q9AVKJsYg3MofmiP7uyR8U78CC
	 WV0uZEKpS8YeGoMBzqIKf7+evifE3IDNFrpX1jpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 465/816] wifi: mt76: mt7996: enable the SKU power limit table
Date: Wed, 25 Nov 2026 15:33:33 +0100
Message-ID: <20261125143859.966069005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Changed the return ret; in mt7996_run() to goto out;, and dropped the missing sniffer-mode and rdd_resume_tx context from the mcu.c and mt7996.h hunks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  5 +++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 34 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   | 23 +++++++++++++
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 4 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index bdb5e82d9f4e7..1074b677ebd81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -67,6 +67,11 @@ int mt7996_run(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
+	ret = mt7996_mcu_set_tx_power_ctrl(phy, UNI_TXPOWER_SKU_POWER_LIMIT_CTRL,
+					   true);
+	if (ret)
+		goto out;
+
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index edb825675408c..67fa3db3171f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4566,6 +4566,40 @@ int mt7996_mcu_wed_rro_reset_sessions(struct mt7996_dev *dev, u16 id)
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
index dd5b168c71f06..d56fdabd959af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -892,8 +892,31 @@ enum {
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
index 29e7289c3a169..6f7a10d6659e2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -496,6 +496,7 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy);
 int mt7996_mcu_set_thermal_throttling(struct mt7996_phy *phy, u8 state);
 int mt7996_mcu_set_thermal_protect(struct mt7996_phy *phy, bool enable);
 int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy);
+int mt7996_mcu_set_tx_power_ctrl(struct mt7996_phy *phy, u8 power_ctrl_id, u8 data);
 int mt7996_mcu_rdd_cmd(struct mt7996_dev *dev, int cmd, u8 index,
 		       u8 rx_sel, u8 val);
 int mt7996_mcu_rdd_background_enable(struct mt7996_phy *phy,
-- 
2.53.0



