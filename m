Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF63B3839B8;
	Sat, 12 Sep 2026 08:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200810; cv=none; b=bk3Ztezs7xVjfrD04KvtjIM6KzUQvv5f25QLC6gFRLiIKH4LpiHMvKfTp1mBYrjZGFWE72nApJNq0RnExTYeN6ifAvQBKwfPXYNT1N4yOR1ypuWxmyVGDaGUoutXddAwtzr2P4JDDwZ04tm7QBO1cWCxI98wLrX2uCttbEhlFWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200810; c=relaxed/simple;
	bh=GPPDfMUbKyVq7uELMiSUwQJcY5yZS3fJGVz5CA0OQio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O23ZWS8ULo2QJaulCytmC7HOraMRHacdw6Pc9p0XzllWTW2K9+k83wDtb6IlyFwrg3kaf/DayBQxv7ayPDQPAKw6Oe2pExeeV38/PbEBuH+PcpTQ2ZV0+g0mtY7LdTkFXEmfTh6encgLW6jni4NZgooKLxDMpIIe/S//S/z2c+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wi2YDjIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wi2YDjIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905E61F000FF;
	Sat, 12 Sep 2026 08:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200807;
	bh=mCDQRd8z8RpTOEtHGvuKKqtv2gLSKQ1Pf7lxvV63Y+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wi2YDjIgD0zxkGRTnl1TJQU/qv8Hh//AZ1oVwOl/1sMU3fI11qlC2ES8cIO0iLcg5
	 nsl80aIbb4CNazVjIyhPch0qBACO32KaJ2maW1+/Voxbx5U5WY4AUjGE5jyRSRVle8
	 htRjvqHMcz1UjaOTYxhDTnq/y/J6/Rbfy/Q9fftM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Jeremy Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0864/1815] wifi: mt76: connac: add NAN connection type
Date: Sat, 12 Sep 2026 08:43:34 +0200
Message-ID: <20260912065709.205865531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit b7ab9f780dc8f6cc9ce30333e9f131ed3419c6b3 ]

Introduce a dedicated NAN connection type for connac firmware and use it
for NAN interface device, BSS and station records.

Add the common NAN MCU command and event IDs used by mt7925.

Co-developed-by: Stella Liu <yu-ching.liu@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Co-developed-by: Jeremy Yu <chengwei.yu@mediatek.com>
Signed-off-by: Jeremy Yu <chengwei.yu@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20260625001834.475094-4-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 217f9e7bb025 ("wifi: mt76: mt792x: fix use-after-free in mt76_rx_poll_complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   | 14 ++++++++++++++
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 58b0b15e4fd6f..69a2f5398404d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -422,6 +422,10 @@ void mt76_connac_mcu_sta_basic_tlv(struct mt76_dev *dev, struct sk_buff *skb,
 		basic->conn_type = cpu_to_le32(CONNECTION_IBSS_ADHOC);
 		basic->aid = cpu_to_le16(link_sta->sta->aid);
 		break;
+	case NL80211_IFTYPE_NAN:
+	case NL80211_IFTYPE_NAN_DATA:
+		basic->conn_type = cpu_to_le32(CONNECTION_NAN);
+		break;
 	default:
 		WARN_ON(1);
 		break;
@@ -1217,6 +1221,11 @@ int mt76_connac_mcu_uni_add_dev(struct mt76_phy *phy,
 	case NL80211_IFTYPE_ADHOC:
 		basic_req.basic.conn_type = cpu_to_le32(CONNECTION_IBSS_ADHOC);
 		break;
+	case NL80211_IFTYPE_NAN:
+	case NL80211_IFTYPE_NAN_DATA:
+		basic_req.basic.conn_type = cpu_to_le32(CONNECTION_NAN);
+		basic_req.basic.conn_state = !enable;
+		break;
 	default:
 		WARN_ON(1);
 		break;
@@ -1627,6 +1636,11 @@ int mt76_connac_mcu_uni_add_bss(struct mt76_phy *phy,
 	case NL80211_IFTYPE_ADHOC:
 		basic_req.basic.conn_type = cpu_to_le32(CONNECTION_IBSS_ADHOC);
 		break;
+	case NL80211_IFTYPE_NAN:
+	case NL80211_IFTYPE_NAN_DATA:
+		basic_req.basic.conn_type = cpu_to_le32(CONNECTION_NAN);
+		basic_req.basic.active = enable;
+		break;
 	default:
 		WARN_ON(1);
 		break;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 78f633ad81a07..a9a4a87ae0a76 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -876,6 +876,7 @@ enum {
 #define NETWORK_P2P			BIT(17)
 #define NETWORK_IBSS			BIT(18)
 #define NETWORK_WDS			BIT(21)
+#define NETWORK_NAN			BIT(22)
 
 #define SCAN_FUNC_RANDOM_MAC		BIT(0)
 #define SCAN_FUNC_RNR_SCAN		BIT(3)
@@ -888,6 +889,7 @@ enum {
 #define CONNECTION_IBSS_ADHOC		(STA_TYPE_ADHOC | NETWORK_IBSS)
 #define CONNECTION_WDS			(STA_TYPE_WDS | NETWORK_WDS)
 #define CONNECTION_INFRA_BC		(STA_TYPE_BC | NETWORK_INFRA)
+#define CONNECTION_NAN			(NETWORK_NAN)
 
 #define CONN_STATE_DISCONNECT		0
 #define CONN_STATE_CONNECT		1
@@ -1074,6 +1076,7 @@ enum {
 	MCU_UNI_EVENT_THERMAL = 0x35,
 	MCU_UNI_EVENT_RSSI_MONITOR = 0x41,
 	MCU_UNI_EVENT_NIC_CAPAB = 0x43,
+	MCU_UNI_EVENT_NAN = 0x56,
 	MCU_UNI_EVENT_WED_RRO = 0x57,
 	MCU_UNI_EVENT_PER_STA_INFO = 0x6d,
 	MCU_UNI_EVENT_ALL_STA_INFO = 0x6e,
@@ -1313,6 +1316,7 @@ enum {
 	MCU_UNI_CMD_FIXED_RATE_TABLE = 0x40,
 	MCU_UNI_CMD_RSSI_MONITOR = 0x41,
 	MCU_UNI_CMD_TESTMODE_CTRL = 0x46,
+	MCU_UNI_CMD_NAN	= 0x56,
 	MCU_UNI_CMD_RRO = 0x57,
 	MCU_UNI_CMD_OFFCH_SCAN_CTRL = 0x58,
 	MCU_UNI_CMD_PER_STA_INFO = 0x6d,
-- 
2.53.0



