Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018976;
	b=bUIg77jPaKDoySvv9LDYETgIkYrp8PCo3Vly2LxGn0IGeUHVzqIOsKtzIjPqndb1BvjU
	 KY5AtDePYcZsUrrt9WpS3590b2qi7YHosJV4dqo9XIFysGf6CNSrHqEioxOBteIAAz/L1
	 1gIkwrjXyrEymT1HrmcSqbfBDLPsaZ3uqC+aXfRPjzhMvJnnZh2cLbbYhJS+Y2KH1L+37
	 wkbGBKTZ9aJfxT1/uGShQA8+/0xLNvnh05nvOq/HuXVJZbjjKqJbqc8bNxb3zEsYOun1R
	 6a9rihQ6w7Cgq41uqWo1WlJrQFXDtCLz/ByON7zj/+e1KtG2e+z5PrwvJGG2q0ttlmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nDHqofuEcV47RgWOBCyIX2cBSYjlNmXE4g8NSNtGu+c=;
	b=c37cXLK6GqY9YIKRHtb4+12+ao995+Ko+F2SHNcqJlPF73GDaqW+b7srjwl4tOgN3bbV
	 K9XlFs2Yf9BGIaiSBrHvLRjl0xqpvxsGMQ8uQHXwgvJV7yvYRMj49qz202XunPQ4dALNY
	 r0RB+PitxT9VW1B0qfSOAK/1CuWVzhzh2+Gx82zY2++TERQRkwMmRkz7ox4ItcLqjMcDC
	 5BA06kqE2vInfDtbw7BC6rdPcLkOSVcL55reLxzYWuo7oWpuwJRhvk0E4MCIvko5QxtXv
	 EbS5D4Eld5vskPo0JlzjTnOCTRwGeGt/Zv88Hq6Nc9tycACOBZ/kbQzxbtW3GWloo1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNRT1zxp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FE7606A31C;
	Wed, 18 Nov 2026 16:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNRT1zxp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93181F000C4;
	Wed, 18 Nov 2026 16:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018976;
	bh=nDHqofuEcV47RgWOBCyIX2cBSYjlNmXE4g8NSNtGu+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNRT1zxpRUt6duC2Koce8cE9n8aPNs5HA2MfqDBSycH9DxWMU8QJuDLv27+2E0yPX
	 +RGqKNRoC41AqDU9Zin9K24oZbZpKm7uCGEkH9vs4PBd2qaH2If02gSa0OYVK+qHJK
	 Bii1DE3h8iDexHrrgwpX5lowtBgDdS5AW7VhMLCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1430/2651] wifi: mt76: mt7925: configure NAN PHY setting on enable
Date: Wed, 18 Nov 2026 15:44:30 +0100
Message-ID: <20261118150339.529448856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stella Liu <yu-ching.liu@mediatek.com>

[ Upstream commit bbb8334e63824c941dbe685e62345d4c41afeb69 ]

Implement NAN_UNI_CMD_UPDATE_PHY_SETTING (tag=18) to configure the
BSS-level PHY parameters that the FW NAN scheduler uses when it
switches channels.

The command carries separate 2G and 5G PHY settings, each with its
own phy type, rate sets and protection modes.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-14-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  6 +-
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 74 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/nan.h   | 29 ++++++++
 3 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index be416244108e1..9fee131bf6381 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2607,8 +2607,12 @@ static int mt7925_start_nan(struct ieee80211_hw *hw,
 		goto out;
 
 	err = mt7925_nan_enable(vif, dev, conf);
-	if (err)
+	if (err) {
 		mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf, NULL, false);
+		goto out;
+	}
+
+	err = mt7925_nan_update_phy_setting(dev);
 
 out:
 	mt792x_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index bfb1e6de5757b..445b8bbd77779 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -193,6 +193,80 @@ mt7925_nan_sync_rssi_tlv(struct sk_buff *skb, struct cfg80211_nan_conf *conf)
 	return 0;
 }
 
+/* FW rate set bit definitions (matches FW wlan_def_cmm.h) */
+#define NAN_RATE_SET_BIT_1M	BIT(0)
+#define NAN_RATE_SET_BIT_2M	BIT(1)
+#define NAN_RATE_SET_BIT_5_5M	BIT(2)
+#define NAN_RATE_SET_BIT_11M	BIT(3)
+#define NAN_RATE_SET_BIT_6M	BIT(6)
+#define NAN_RATE_SET_BIT_9M	BIT(7)
+#define NAN_RATE_SET_BIT_12M	BIT(8)
+#define NAN_RATE_SET_BIT_18M	BIT(9)
+#define NAN_RATE_SET_BIT_24M	BIT(10)
+#define NAN_RATE_SET_BIT_36M	BIT(11)
+#define NAN_RATE_SET_BIT_48M	BIT(12)
+#define NAN_RATE_SET_BIT_54M	BIT(13)
+
+#define NAN_RATE_SET_ALL_A	(NAN_RATE_SET_BIT_6M | NAN_RATE_SET_BIT_9M | \
+				 NAN_RATE_SET_BIT_12M | NAN_RATE_SET_BIT_18M | \
+				 NAN_RATE_SET_BIT_24M | NAN_RATE_SET_BIT_36M | \
+				 NAN_RATE_SET_BIT_48M | NAN_RATE_SET_BIT_54M)
+
+/* 5G basic: 6M+12M+24M (OFDM) */
+#define NAN_BASIC_RATE_SET_5G	(NAN_RATE_SET_BIT_6M | NAN_RATE_SET_BIT_12M | \
+				 NAN_RATE_SET_BIT_24M)
+
+/* GF_MODE_DISALLOWED = 2, RIFS_MODE_DISALLOWED = 1 */
+#define NAN_GF_MODE_DISALLOWED		2
+#define NAN_RIFS_MODE_DISALLOWED	1
+
+int mt7925_nan_update_phy_setting(struct mt792x_dev *dev)
+{
+	struct mt76_phy *mphy = &dev->mphy;
+	struct ieee80211_supported_band *sband_5g;
+	struct mt7925_nan_phy_setting *phy;
+	struct {
+		u8 rsv[4];
+		struct mt7925_nan_update_phy_setting_tlv tlv;
+	} req = {};
+
+	sband_5g = mphy->hw->wiphy->bands[NL80211_BAND_5GHZ];
+
+	req.tlv.tag = cpu_to_le16(NAN_UNI_CMD_UPDATE_PHY_SETTING);
+	req.tlv.len = cpu_to_le16(sizeof(req.tlv));
+
+	/* 2G: ERP + HT (no CCK/HR_DSSS - NAN uses OFDM only) */
+	phy = &req.tlv.phy_2g;
+	phy->phy_type_set = PHY_TYPE_BIT_ERP | PHY_TYPE_BIT_HT;
+	phy->non_ht_basic_phy_type = PHY_TYPE_ERP_INDEX;
+	phy->use_short_preamble = 1;
+	phy->use_short_slot_time = 1;
+	phy->operational_rate_set = cpu_to_le16(NAN_RATE_SET_ALL_A);
+	phy->bss_basic_rate_set = cpu_to_le16(NAN_BASIC_RATE_SET_5G);
+	phy->gf_operation_mode = cpu_to_le32(NAN_GF_MODE_DISALLOWED);
+	phy->rifs_operation_mode = cpu_to_le32(NAN_RIFS_MODE_DISALLOWED);
+
+	/* 5G: OFDM + HT + VHT (NAN_MODE_11A) */
+	phy = &req.tlv.phy_5g;
+	phy->phy_type_set = PHY_TYPE_BIT_OFDM | PHY_TYPE_BIT_HT |
+			    PHY_TYPE_BIT_VHT;
+	phy->non_ht_basic_phy_type = PHY_TYPE_OFDM_INDEX;
+	phy->use_short_preamble = 1;
+	phy->use_short_slot_time = 1;
+	phy->operational_rate_set = cpu_to_le16(NAN_RATE_SET_ALL_A);
+	phy->bss_basic_rate_set = cpu_to_le16(NAN_BASIC_RATE_SET_5G);
+	phy->gf_operation_mode = cpu_to_le32(NAN_GF_MODE_DISALLOWED);
+	phy->rifs_operation_mode = cpu_to_le32(NAN_RIFS_MODE_DISALLOWED);
+
+	/* VHT basic MCS set from sband capability */
+	if (sband_5g && sband_5g->vht_cap.vht_supported)
+		phy->vht_basic_mcs_set =
+			sband_5g->vht_cap.vht_mcs.rx_mcs_map;
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(NAN),
+				 &req, sizeof(req), true);
+}
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index a0da16adf182c..08c13768b3573 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -84,6 +84,7 @@ enum nan_uni_cmd_tag {
 	NAN_UNI_CMD_MANAGE_PEER_SCH_RECORD	= 12,
 	NAN_UNI_CMD_MAP_STA_RECORD		= 13,
 	NAN_UNI_CMD_UPDATE_ULW			= 16,
+	NAN_UNI_CMD_UPDATE_PHY_SETTING		= 18,
 	NAN_UNI_CMD_UPDATE_AVAILABILITY_CTRL	= 20,
 	NAN_UNI_CMD_UPDATE_PEER_CAPABILITY	= 21,
 	NAN_UNI_CMD_CHANGE_NMI_ADDRESS		= 24,
@@ -440,6 +441,34 @@ struct mt7925_nan_sched_map_sta_rec_tlv {
 	u8 reserved[2];
 } __packed __aligned(4);
 
+/* Matches FW NAN_PHY_SETTING_T (enum fields are 4 bytes on ARM) */
+struct mt7925_nan_phy_setting {
+	u8 phy_type_set;
+	u8 non_ht_basic_phy_type;
+	u8 use_short_preamble;
+	u8 use_short_slot_time;
+	__le16 operational_rate_set;
+	__le16 bss_basic_rate_set;
+	__le16 vht_basic_mcs_set;
+	u8 erp_protect_mode;
+	u8 ht_op_info1;
+	__le16 ht_op_info2;
+	__le16 ht_op_info3;
+	__le32 ht_protect_mode;
+	__le32 gf_operation_mode;
+	__le32 rifs_operation_mode;
+} __packed;
+
+/* Matches FW NAN_SCHED_CMD_UPDATE_PHY_PARAM_T */
+struct mt7925_nan_update_phy_setting_tlv {
+	__le16 tag;
+	__le16 len;
+	struct mt7925_nan_phy_setting phy_2g;
+	struct mt7925_nan_phy_setting phy_5g;
+} __packed __aligned(4);
+
+int mt7925_nan_update_phy_setting(struct mt792x_dev *dev);
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf);
-- 
2.53.0



