Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB97C30E853;
	Sat, 30 May 2026 17:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162517; cv=none; b=F9tc5xuCDSRHqxf+o3xZG2TgHc2vsGyCn+gcR101810CeexDa/np487AN2Y3Jg+iBy7U/a9DQ5jjBYj9VSHlmml2pKpmUwWU6r3VJ5RjeudzHtsO5ZkHaOBy1ngle9Ephyaz2/kA+ZSwEAE+uv0biWnfmgQTDVJSr37GjqG0zzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162517; c=relaxed/simple;
	bh=23Y4ndvAbPYN+ZAfCL4pW99W6Oxm3feu4KbFQgFr82A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9nC4eYey0A2Pv1LTAZUlgh2hXHkwrPtsLxHT2jgwMDyiDYt71yZZ30dznGYk0jKE1cctqDPcxyxC0mWOlSGI6ArDiQ86wq+f9mLk9kEuTwsVq09AVfHbcFWak3zEeN3zY6k5S27qfl0PxBiduXy8f+DUiZ+bcnsBI2xcLg7m8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s372N3qO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s372N3qO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B90A1F00893;
	Sat, 30 May 2026 17:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162516;
	bh=59i1rM/C2QTdzYY8CwrLvy1lLr/9Ca+BZX1Yk/1Rg7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s372N3qOIWHVCj8GnCbOUAGnskoFMdvNdGtQBthixcSp8tQoNzBX+gt7zrDWXX0RD
	 dNgS9XAhu+jHZbpZ3BUyybklgjZOfBVueG6oj1en+qgAGbh/7DryTSEPpocHZ301ql
	 ieRg6C2BX4RCFtl6S9ZKeA76YLZEoj2xK0ZN3jOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram R <quic_srirrama@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 943/969] wifi: ath11k: update hw params for IPQ5018
Date: Sat, 30 May 2026 18:07:47 +0200
Message-ID: <20260530160326.797311334@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sriram R <quic_srirrama@quicinc.com>

[ Upstream commit 8dfe875aa24aec68baf6702018633c84c2c1feca ]

Add new compatible string for IPQ5018 and add
required hw params for IPQ5018. The hw descriptors size and
datapath ops are similar to QCN9074, hence reuse the same.

Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.6.0.1-00861-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Co-developed-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221122132152.17771-3-quic_kathirve@quicinc.com
Stable-dep-of: 2a2451a34afd ("wifi: ath11k: fix peer resolution on rx path when peer_id=0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 71 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/core.h |  8 +++
 2 files changed, 79 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 7a61c84939cb3..c8fb72d9613fa 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -604,6 +604,77 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.smp2p_wow_exit = true,
 		.support_fw_mac_sequence = true,
 	},
+	{
+		.hw_rev = ATH11K_HW_IPQ5018_HW10,
+		.name = "ipq5018 hw1.0",
+		.fw = {
+			.dir = "IPQ5018/hw1.0",
+			.board_size = 256 * 1024,
+			.cal_offset = 128 * 1024,
+		},
+		.max_radios = MAX_RADIOS_5018,
+		.bdf_addr = 0x4BA00000,
+		/* hal_desc_sz and hw ops are similar to qcn9074 */
+		.hal_desc_sz = sizeof(struct hal_rx_desc_qcn9074),
+		.qmi_service_ins_id = ATH11K_QMI_WLFW_SERVICE_INS_ID_V01_IPQ8074,
+		.ring_mask = &ath11k_hw_ring_mask_ipq8074,
+		.credit_flow = false,
+		.max_tx_ring = 1,
+		.spectral = {
+			.fft_sz = 2,
+			.fft_pad_sz = 0,
+			.summary_pad_sz = 16,
+			.fft_hdr_len = 24,
+			.max_fft_bins = 1024,
+		},
+		.internal_sleep_clock = false,
+		.host_ce_config = ath11k_host_ce_config_qcn9074,
+		.ce_count = CE_CNT_5018,
+		.rxdma1_enable = true,
+		.num_rxmda_per_pdev = RXDMA_PER_PDEV_5018,
+		.rx_mac_buf_ring = false,
+		.vdev_start_delay = false,
+		.htt_peer_map_v2 = true,
+		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_MESH_POINT),
+		.supports_monitor = false,
+		.supports_sta_ps = false,
+		.supports_shadow_regs = false,
+		.fw_mem_mode = 0,
+		.num_vdevs = 16 + 1,
+		.num_peers = 512,
+		.supports_regdb = false,
+		.idle_ps = false,
+		.supports_suspend = false,
+		.hal_params = &ath11k_hw_hal_params_ipq8074,
+		.single_pdev_only = false,
+		.cold_boot_calib = true,
+		.fix_l1ss = true,
+		.supports_dynamic_smps_6ghz = false,
+		.alloc_cacheable_memory = true,
+		.supports_rssi_stats = false,
+		.fw_wmi_diag_event = false,
+		.current_cc_support = false,
+		.dbr_debug_support = true,
+		.global_reset = false,
+		.bios_sar_capa = NULL,
+		.m3_fw_support = false,
+		.fixed_bdf_addr = true,
+		.fixed_mem_region = true,
+		.static_window_map = false,
+		.hybrid_bus_type = false,
+		.fixed_fw_mem = false,
+		.support_off_channel_tx = false,
+		.supports_multi_bssid = false,
+
+		.sram_dump = {},
+
+		.tcl_ring_retry = true,
+		.tx_ring_size = DP_TCL_DATA_RING_SIZE,
+		.smp2p_wow_exit = false,
+		.support_fw_mac_sequence = false,
+	},
 };
 
 static inline struct ath11k_pdev *ath11k_core_get_single_pdev(struct ath11k_base *ab)
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a46fe85e592d8..09e40ff461730 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -142,6 +142,7 @@ enum ath11k_hw_rev {
 	ATH11K_HW_WCN6855_HW20,
 	ATH11K_HW_WCN6855_HW21,
 	ATH11K_HW_WCN6750_HW10,
+	ATH11K_HW_IPQ5018_HW10,
 };
 
 enum ath11k_firmware_mode {
@@ -230,6 +231,13 @@ struct ath11k_he {
 
 #define MAX_RADIOS 3
 
+/* ipq5018 hw param macros */
+#define MAX_RADIOS_5018	1
+#define CE_CNT_5018	6
+#define TARGET_CE_CNT_5018	9
+#define SVC_CE_MAP_LEN_5018	17
+#define RXDMA_PER_PDEV_5018	1
+
 enum {
 	WMI_HOST_TP_SCALE_MAX   = 0,
 	WMI_HOST_TP_SCALE_50    = 1,
-- 
2.53.0



