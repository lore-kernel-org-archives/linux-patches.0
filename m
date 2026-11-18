Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049294;
	b=XeCmy0rWA2+BlJ7TzQgITsyPsX87CevjubS66nsOhWPVgGxZY5ACph5hD+658QU8eN58
	 dBdbUXSkKo5MfRdeuJXdYJTRTJzyfTt8ukjyfzKYXkn4MMYI9yQ7IVEfWN5Fug0q/ryzD
	 5lUvx31XBe8VMSdY8nPWblQhMe57bTYsajDtVEYSMj29AdSoMr97IyjKnvHnjIHTHTpsZ
	 uEGcj+9kDDXAgQq6SZeyA9GWHICR2F4tuzR1+4ovP3u6P/U7vi9o0rkfTJ8DzKSnEme5Q
	 2BKC+iCEqThtLsZgfN0tPRrWRI1spR8Lm07VZ533ueC94ES5ZIxzjiTBaNmQt6gvLyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LyBTlQBC25Yb0dfpbcYjMpVVxQ/p8aC1+TSP7LWnSRM=;
	b=p9zO0f2gnSSXvhv7l+GPtvgep3Jxwi6taSdx74+gYw6Uza0MtwpREDfRt08Si1ClpV0k
	 FGscXUYPK2OcVW95fENQc8WfaPYprtEt9CBjQOSVmxzLnOcrXFKbjhdB23F/XzCraKsO9
	 Oj8Tu+J23YP8jWuRcE1dulvHhHTbpOX0nKC+ZaY+x2vhDkMyfD2LBUxJ1McIf9vYhSylB
	 FYGZhplH18ICyzl8F2z91dFg+H+9HTPlsGntjEYwd64UmvlsSzuL5A9aOJcea3i6lq/08
	 IEATpRDtOlCpmOOSz0ibFH8OoDVcVqd1sVVfv1lDNNACrbLI8xbsXlD3qOv2S+Pg/ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GiTJstO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E83606A339;
	Thu, 19 Nov 2026 00:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GiTJstO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8091F000C5;
	Thu, 19 Nov 2026 00:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049293;
	bh=LyBTlQBC25Yb0dfpbcYjMpVVxQ/p8aC1+TSP7LWnSRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GiTJstOWreY8eP+vSIpdkWcNqpr8MPMYTemZNFgrD7PgP2v0WRxoI7PRt++PfDH6
	 M7rC1vaissPq6ecSkiAvFWb0GgkuiDu40bnJfX9QvPgvUy/eOTkqdGyYRNH3tQCF6C
	 BSu7+xQny0j8pmelrIEOPYOm91cp/u1j48mQtBj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Deren Wu <deren.wu@mediatek.com>,
	Neil Chen <yn.chen@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2300/2857] wifi: mt76: mt7921: fix rx filter incorrect by drv/fw inconsistent
Date: Wed, 18 Nov 2026 15:55:34 +0100
Message-ID: <20261118150324.297644036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Neil Chen <yn.chen@mediatek.com>

[ Upstream commit c222f77fd421bd1a44c395960867cd75273943f1 ]

The rx filter, in mt7921 series, may be changed in fw operation. There is
a racing problem if rx filter controlled by both driver and firmware at
the same time. To avoid this issue, let mt7921 driver set rx filter by new
command MCU_CE_CMD_SET_RX_FILTER and allow the firmware controlling it
only.

Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Co-developed-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Neil Chen <yn.chen@mediatek.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 3dcb98c5cb51 ("wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_mtx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  1 +
 .../net/wireless/mediatek/mt76/mt7921/init.c  |  2 -
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 48 ++-----------------
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 36 +++++++++++++-
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  2 +
 .../wireless/mediatek/mt76/mt7921/testmode.c  |  1 -
 6 files changed, 40 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 718f427d8f6b2..f0f8aac016e1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1173,6 +1173,7 @@ enum {
 	MCU_CE_CMD_TEST_CTRL = 0x01,
 	MCU_CE_CMD_START_HW_SCAN = 0x03,
 	MCU_CE_CMD_SET_PS_PROFILE = 0x05,
+	MCU_CE_CMD_SET_RX_FILTER = 0x0a,
 	MCU_CE_CMD_SET_CHAN_DOMAIN = 0x0f,
 	MCU_CE_CMD_SET_BSS_CONNECTED = 0x16,
 	MCU_CE_CMD_SET_BSS_ABORT = 0x17,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index c997b8d3ea590..e23f531011676 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -147,8 +147,6 @@ int mt7921_mac_init(struct mt7921_dev *dev)
 	for (i = 0; i < 2; i++)
 		mt7921_mac_init_band(dev, i);
 
-	dev->mt76.rxfilter = mt76_rr(dev, MT_WF_RFCR(0));
-
 	return mt76_connac_mcu_set_rts_thresh(&dev->mt76, 0x92b, 0);
 }
 EXPORT_SYMBOL_GPL(mt7921_mac_init);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 2283682aec65c..2576548957096 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -583,7 +583,6 @@ static int mt7921_config(struct ieee80211_hw *hw, u32 changed)
 		ieee80211_iterate_active_interfaces(hw,
 						    IEEE80211_IFACE_ITER_RESUME_ALL,
 						    mt7921_sniffer_interface_iter, dev);
-		dev->mt76.rxfilter = mt76_rr(dev, MT_WF_RFCR(0));
 	}
 
 out:
@@ -612,53 +611,12 @@ static void mt7921_configure_filter(struct ieee80211_hw *hw,
 				    u64 multicast)
 {
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
-	u32 ctl_flags = MT_WF_RFCR1_DROP_ACK |
-			MT_WF_RFCR1_DROP_BF_POLL |
-			MT_WF_RFCR1_DROP_BA |
-			MT_WF_RFCR1_DROP_CFEND |
-			MT_WF_RFCR1_DROP_CFACK;
-	u32 flags = 0;
-
-#define MT76_FILTER(_flag, _hw) do {					\
-		flags |= *total_flags & FIF_##_flag;			\
-		dev->mt76.rxfilter &= ~(_hw);				\
-		dev->mt76.rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
-	} while (0)
 
 	mt7921_mutex_acquire(dev);
-
-	dev->mt76.rxfilter &= ~(MT_WF_RFCR_DROP_OTHER_BSS |
-				MT_WF_RFCR_DROP_OTHER_BEACON |
-				MT_WF_RFCR_DROP_FRAME_REPORT |
-				MT_WF_RFCR_DROP_PROBEREQ |
-				MT_WF_RFCR_DROP_MCAST_FILTERED |
-				MT_WF_RFCR_DROP_MCAST |
-				MT_WF_RFCR_DROP_BCAST |
-				MT_WF_RFCR_DROP_DUPLICATE |
-				MT_WF_RFCR_DROP_A2_BSSID |
-				MT_WF_RFCR_DROP_UNWANTED_CTL |
-				MT_WF_RFCR_DROP_STBC_MULTI);
-
-	MT76_FILTER(OTHER_BSS, MT_WF_RFCR_DROP_OTHER_TIM |
-			       MT_WF_RFCR_DROP_A3_MAC |
-			       MT_WF_RFCR_DROP_A3_BSSID);
-
-	MT76_FILTER(FCSFAIL, MT_WF_RFCR_DROP_FCSFAIL);
-
-	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
-			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
-
-	*total_flags = flags;
-	mt76_wr(dev, MT_WF_RFCR(0), dev->mt76.rxfilter);
-
-	if (*total_flags & FIF_CONTROL)
-		mt76_clear(dev, MT_WF_RFCR1(0), ctl_flags);
-	else
-		mt76_set(dev, MT_WF_RFCR1(0), ctl_flags);
-
+	mt7921_mcu_set_rxfilter(dev, *total_flags, 0, 0);
 	mt7921_mutex_release(dev);
+
+	*total_flags &= (FIF_OTHER_BSS | FIF_FCSFAIL | FIF_CONTROL);
 }
 
 static void mt7921_bss_info_changed(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index d0e93707b9787..33ca603b4d7ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -893,6 +893,8 @@ int mt7921_mcu_set_beacon_filter(struct mt7921_dev *dev,
 				 struct ieee80211_vif *vif,
 				 bool enable)
 {
+#define MT7921_FIF_BIT_CLR		BIT(1)
+#define MT7921_FIF_BIT_SET		BIT(0)
 	int err;
 
 	if (enable) {
@@ -900,7 +902,11 @@ int mt7921_mcu_set_beacon_filter(struct mt7921_dev *dev,
 		if (err)
 			return err;
 
-		mt76_set(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
+		err = mt7921_mcu_set_rxfilter(dev, 0,
+					      MT7921_FIF_BIT_SET,
+					      MT_WF_RFCR_DROP_OTHER_BEACON);
+		if (err)
+			return err;
 
 		return 0;
 	}
@@ -909,7 +915,11 @@ int mt7921_mcu_set_beacon_filter(struct mt7921_dev *dev,
 	if (err)
 		return err;
 
-	mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
+	err = mt7921_mcu_set_rxfilter(dev, 0,
+				      MT7921_FIF_BIT_CLR,
+				      MT_WF_RFCR_DROP_OTHER_BEACON);
+	if (err)
+		return err;
 
 	return 0;
 }
@@ -1135,3 +1145,25 @@ int mt7921_mcu_set_clc(struct mt7921_dev *dev, u8 *alpha2,
 	}
 	return 0;
 }
+
+int mt7921_mcu_set_rxfilter(struct mt7921_dev *dev, u32 fif,
+			    u8 bit_op, u32 bit_map)
+{
+	struct {
+		u8 rsv[4];
+		u8 mode;
+		u8 rsv2[3];
+		__le32 fif;
+		__le32 bit_map; /* bit_* for bitmap update */
+		u8 bit_op;
+		u8 pad[51];
+	} __packed data = {
+		.mode = fif ? 1 : 2,
+		.fif = cpu_to_le32(fif),
+		.bit_map = cpu_to_le32(bit_map),
+		.bit_op = bit_op,
+	};
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_RX_FILTER),
+				 &data, sizeof(data), false);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 1e2f914558a2e..9f9085cae8338 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -325,6 +325,8 @@ int mt7921_mcu_get_rx_rate(struct mt7921_phy *phy, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta, struct rate_info *rate);
 int mt7921_mcu_fw_log_2_host(struct mt7921_dev *dev, u8 ctrl);
 void mt7921_mcu_rx_event(struct mt7921_dev *dev, struct sk_buff *skb);
+int mt7921_mcu_set_rxfilter(struct mt7921_dev *dev, u32 fif,
+			    u8 bit_op, u32 bit_map);
 
 static inline void mt7921_irq_enable(struct mt7921_dev *dev, u32 mask)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
index bdec8684ce94c..7f408212e7163 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
@@ -59,7 +59,6 @@ mt7921_tm_set(struct mt7921_dev *dev, struct mt7921_tm_cmd *req)
 		cancel_work_sync(&pm->wake_work);
 		__mt7921_mcu_drv_pmctrl(dev);
 
-		mt76_wr(dev, MT_WF_RFCR(0), dev->mt76.rxfilter);
 		phy->test.state = MT76_TM_STATE_ON;
 	}
 
-- 
2.53.0



