Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AA01A6192;
	Tue, 30 Jul 2024 16:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357050; cv=none; b=dVa+2lMJXerVGJuJB2WnNe8/COPuR9tGftppzNWsYuiuTwX6sck3tdlKV3CExgZPZ9PMbSulJEgACTteCpb/Hu76Df7XaUyqPnv6sTMgBYwqnAIi2ZVd+G/M146DcgI4rRzD3j2AwI1v0/FAtrEvohTWGDntErv3NIjLngEUcPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357050; c=relaxed/simple;
	bh=wMTqZtLa9NPhptlfLQzGOS6NDJwg86/RQspCqMkmzsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWJOG/cP1IsiFYX9qD0IlNyF7gxPS4BVbyYyhz+KGMcoVR1jo4GNSfPIa9CytxQpFTO2kNAcgqRIFcbI7KwaQ73ncnPCinK1ZDOa/32Ooql2x8yAWWPTLMjMEHvfeaDda4hISB34j0Ib+sFOx1Fz4wm6NfY+cIZcznFLiTGpUhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtrvVJeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtrvVJeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F95EC32782;
	Tue, 30 Jul 2024 16:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357049;
	bh=wMTqZtLa9NPhptlfLQzGOS6NDJwg86/RQspCqMkmzsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtrvVJeB3LZeCgjCU+s1E5wD5wwj+gUcv+KOmKmIMuo3sRpJnR/wYD+PzCDnO3w3V
	 do4Ky3qCOnFTprP892NaRaHSzx5iAXBILGGFPXeLm+G70wGS3Npbag2naYo6JvBk8z
	 2cCvxW2YdTSZDX9gQXeJLqkdlDMcSVIzxHdQlD00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 213/809] wifi: ath12k: advertise driver capabilities for MBSSID and EMA
Date: Tue, 30 Jul 2024 17:41:29 +0200
Message-ID: <20240730151733.017167096@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <quic_alokad@quicinc.com>

[ Upstream commit 519a545cfee790024c623c7aacd165f7431773d5 ]

Advertise the driver support for multiple BSSID (MBSSID) and
enhanced multi-BSSID advertisements (EMA) by setting extended
capabilities.

Configure mbssid_max_interfaces and ema_max_profile_periodicity
fields in structure wiphy which are used to advertise maximum number
of interfaces and profile periodicity supported by the driver.

Add new WMI fields to configure maximum vdev count supported for
MBSSID and profile periodicity in case of EMA.

Set WMI_RSRC_CFG_FLAGS2_CALC_NEXT_DTIM_COUNT_SET flag to allow
firmware to track and update the DTIM counts for each nontransmitted
profile.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240508202912.11902-2-quic_alokad@quicinc.com
Stable-dep-of: 1eeafd64c7b4 ("wifi: ath12k: fix peer metadata parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hw.h  | 1 +
 drivers/net/wireless/ath/ath12k/mac.c | 7 +++++++
 drivers/net/wireless/ath/ath12k/wmi.c | 7 ++++++-
 drivers/net/wireless/ath/ath12k/wmi.h | 3 +++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 3f450ee93f34b..2745bde0502c6 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -80,6 +80,7 @@
 #define TARGET_RX_BATCHMODE		1
 #define TARGET_RX_PEER_METADATA_VER_V1A	2
 #define TARGET_RX_PEER_METADATA_VER_V1B	3
+#define TARGET_EMA_MAX_PROFILE_PERIOD	8
 
 #define ATH12K_HW_DEFAULT_QUEUE		0
 #define ATH12K_HW_MAX_QUEUES		4
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 2c68376a39fd3..0ed388a6fc804 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8489,19 +8489,23 @@ static int ath12k_mac_setup_iface_combinations(struct ath12k_hw *ah)
 
 static const u8 ath12k_if_types_ext_capa[] = {
 	[0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
+	[2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	[7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
 };
 
 static const u8 ath12k_if_types_ext_capa_sta[] = {
 	[0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
+	[2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	[7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
 	[9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
 static const u8 ath12k_if_types_ext_capa_ap[] = {
 	[0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
+	[2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	[7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
 	[9] = WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT,
+	[10] = WLAN_EXT_CAPA11_EMA_SUPPORT,
 };
 
 static const struct wiphy_iftype_ext_capab ath12k_iftypes_ext_capa[] = {
@@ -8740,6 +8744,9 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	wiphy->iftype_ext_capab = ath12k_iftypes_ext_capa;
 	wiphy->num_iftype_ext_capab = ARRAY_SIZE(ath12k_iftypes_ext_capa);
 
+	wiphy->mbssid_max_interfaces = TARGET_NUM_VDEVS;
+	wiphy->ema_max_profile_periodicity = TARGET_EMA_MAX_PROFILE_PERIOD;
+
 	if (is_6ghz) {
 		wiphy_ext_feature_set(wiphy,
 				      NL80211_EXT_FEATURE_FILS_DISCOVERY);
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index e88ec9e1201a9..bf33767af2c87 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -228,6 +228,9 @@ void ath12k_wmi_init_qcn9274(struct ath12k_base *ab,
 	config->peer_map_unmap_version = 0x32;
 	config->twt_ap_pdev_count = ab->num_radios;
 	config->twt_ap_sta_count = 1000;
+	config->ema_max_vap_cnt = ab->num_radios;
+	config->ema_max_profile_period = TARGET_EMA_MAX_PROFILE_PERIOD;
+	config->beacon_tx_offload_max_vdev += config->ema_max_vap_cnt;
 
 	if (test_bit(WMI_TLV_SERVICE_PEER_METADATA_V1A_V1B_SUPPORT, ab->wmi_ab.svc_map))
 		config->dp_peer_meta_data_ver = TARGET_RX_PEER_METADATA_VER_V1B;
@@ -3475,9 +3478,11 @@ ath12k_wmi_copy_resource_config(struct ath12k_wmi_resource_config_params *wmi_cf
 	wmi_cfg->twt_ap_sta_count = cpu_to_le32(tg_cfg->twt_ap_sta_count);
 	wmi_cfg->flags2 = le32_encode_bits(tg_cfg->dp_peer_meta_data_ver,
 					   WMI_RSRC_CFG_FLAGS2_RX_PEER_METADATA_VERSION);
-
 	wmi_cfg->host_service_flags = cpu_to_le32(tg_cfg->is_reg_cc_ext_event_supported <<
 				WMI_RSRC_CFG_HOST_SVC_FLAG_REG_CC_EXT_SUPPORT_BIT);
+	wmi_cfg->ema_max_vap_cnt = cpu_to_le32(tg_cfg->ema_max_vap_cnt);
+	wmi_cfg->ema_max_profile_period = cpu_to_le32(tg_cfg->ema_max_profile_period);
+	wmi_cfg->flags2 |= cpu_to_le32(WMI_RSRC_CFG_FLAGS2_CALC_NEXT_DTIM_COUNT_SET);
 }
 
 static int ath12k_init_cmd_send(struct ath12k_wmi_pdev *wmi,
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 496866673aead..e71e6c73f2495 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -2356,6 +2356,8 @@ struct ath12k_wmi_resource_config_arg {
 	u32 twt_ap_sta_count;
 	bool is_reg_cc_ext_event_supported;
 	u8  dp_peer_meta_data_ver;
+	u32 ema_max_vap_cnt;
+	u32 ema_max_profile_period;
 };
 
 struct ath12k_wmi_init_cmd_arg {
@@ -2410,6 +2412,7 @@ struct wmi_init_cmd {
 #define WMI_RSRC_CFG_HOST_SVC_FLAG_REG_CC_EXT_SUPPORT_BIT 4
 #define WMI_RSRC_CFG_FLAGS2_RX_PEER_METADATA_VERSION		GENMASK(5, 4)
 #define WMI_RSRC_CFG_FLAG1_BSS_CHANNEL_INFO_64	BIT(5)
+#define WMI_RSRC_CFG_FLAGS2_CALC_NEXT_DTIM_COUNT_SET      BIT(9)
 
 struct ath12k_wmi_resource_config_params {
 	__le32 tlv_header;
-- 
2.43.0



