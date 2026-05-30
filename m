Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D3F33A9DA;
	Sat, 30 May 2026 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162548; cv=none; b=DkH7TWhs+PJWrHOa63gugkNwGwpFgYqh8q9iVdDvFIdj9w78bLpeMh+/biHpM4hWWpg9lofQxriaIK8WETzl103PBbUUv6GSpUH4RcKoyjfuvKbI3geTEqdi+YPnJy2gxlEV9SDcvqe2XL6STukZ6WM1dqOtAQbxLRunVQ9P+Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162548; c=relaxed/simple;
	bh=mB8CQ17SvYFtai/nXlO+ak6X03g4p405YvRKGaq06fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5Sy63sGpV5eWfKXtAVRymtA8swGowi3Sh7h3ocnTNAa15VXJK5xMJginDDI7TSt6dDbHgFVY8K/O2u/O4p4vBgr6P43mLAOZkFY0074825D8sFb4dXaijXWhXYokNxxpx1B+DKAjUEx+6rTdc1sUXCYWl1OTfcMg5C4GtbVuTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9C+l9zH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9C+l9zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBB51F00893;
	Sat, 30 May 2026 17:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162546;
	bh=LdBrnc26VLIZf98btGZ02B0IlCSFl1NN3QKVYb3517U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9C+l9zHjrTAAO4CYBXnGATn/2gj6FdUDvOOf2QODGmuZ9PLicpaOoSo3+vTIyNVj
	 QqJWHcz74h49kqEFCbTj7qbOETZ+8vCvGNG9++7JmneRFDYErEwFIJplQ8YfXMHeXV
	 mCxwUqL823kq8EDAZ+hoGYqTm6ISlzIEa66iWqH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram R <quic_srirrama@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 947/969] wifi: ath11k: initialize hw_ops for IPQ5018
Date: Sat, 30 May 2026 18:07:51 +0200
Message-ID: <20260530160326.910137068@linuxfoundation.org>
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

[ Upstream commit ba60f2793d3a37a00da14bb56a26558a902d2831 ]

The ipq5018_ops is initialized for IPQ5018. This is different from
other platforms.

Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.6.0.1-00861-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Co-developed-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221122132152.17771-7-quic_kathirve@quicinc.com
Stable-dep-of: 2a2451a34afd ("wifi: ath11k: fix peer resolution on rx path when peer_id=0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c |  1 +
 drivers/net/wireless/ath/ath11k/hw.c   | 40 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/hw.h   |  1 +
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index a5a9b485a50d2..be7d0644a6e8f 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -635,6 +635,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		},
 		.internal_sleep_clock = false,
 		.regs = &ipq5018_regs,
+		.hw_ops = &ipq5018_ops,
 		.host_ce_config = ath11k_host_ce_config_qcn9074,
 		.ce_count = CE_CNT_5018,
 		.target_ce_config = ath11k_target_ce_config_wlan_ipq5018,
diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index 6135a45f255d1..7632220469dab 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -1085,6 +1085,46 @@ const struct ath11k_hw_ops wcn6750_ops = {
 	.get_ring_selector = ath11k_hw_wcn6750_get_tcl_ring_selector,
 };
 
+/* IPQ5018 hw ops is similar to QCN9074 except for the dest ring remap */
+const struct ath11k_hw_ops ipq5018_ops = {
+	.get_hw_mac_from_pdev_id = ath11k_hw_ipq6018_mac_from_pdev_id,
+	.wmi_init_config = ath11k_init_wmi_config_ipq8074,
+	.mac_id_to_pdev_id = ath11k_hw_mac_id_to_pdev_id_ipq8074,
+	.mac_id_to_srng_id = ath11k_hw_mac_id_to_srng_id_ipq8074,
+	.tx_mesh_enable = ath11k_hw_qcn9074_tx_mesh_enable,
+	.rx_desc_get_first_msdu = ath11k_hw_qcn9074_rx_desc_get_first_msdu,
+	.rx_desc_get_last_msdu = ath11k_hw_qcn9074_rx_desc_get_last_msdu,
+	.rx_desc_get_l3_pad_bytes = ath11k_hw_qcn9074_rx_desc_get_l3_pad_bytes,
+	.rx_desc_get_hdr_status = ath11k_hw_qcn9074_rx_desc_get_hdr_status,
+	.rx_desc_encrypt_valid = ath11k_hw_qcn9074_rx_desc_encrypt_valid,
+	.rx_desc_get_encrypt_type = ath11k_hw_qcn9074_rx_desc_get_encrypt_type,
+	.rx_desc_get_decap_type = ath11k_hw_qcn9074_rx_desc_get_decap_type,
+	.rx_desc_get_mesh_ctl = ath11k_hw_qcn9074_rx_desc_get_mesh_ctl,
+	.rx_desc_get_ldpc_support = ath11k_hw_qcn9074_rx_desc_get_ldpc_support,
+	.rx_desc_get_mpdu_seq_ctl_vld = ath11k_hw_qcn9074_rx_desc_get_mpdu_seq_ctl_vld,
+	.rx_desc_get_mpdu_fc_valid = ath11k_hw_qcn9074_rx_desc_get_mpdu_fc_valid,
+	.rx_desc_get_mpdu_start_seq_no = ath11k_hw_qcn9074_rx_desc_get_mpdu_start_seq_no,
+	.rx_desc_get_msdu_len = ath11k_hw_qcn9074_rx_desc_get_msdu_len,
+	.rx_desc_get_msdu_sgi = ath11k_hw_qcn9074_rx_desc_get_msdu_sgi,
+	.rx_desc_get_msdu_rate_mcs = ath11k_hw_qcn9074_rx_desc_get_msdu_rate_mcs,
+	.rx_desc_get_msdu_rx_bw = ath11k_hw_qcn9074_rx_desc_get_msdu_rx_bw,
+	.rx_desc_get_msdu_freq = ath11k_hw_qcn9074_rx_desc_get_msdu_freq,
+	.rx_desc_get_msdu_pkt_type = ath11k_hw_qcn9074_rx_desc_get_msdu_pkt_type,
+	.rx_desc_get_msdu_nss = ath11k_hw_qcn9074_rx_desc_get_msdu_nss,
+	.rx_desc_get_mpdu_tid = ath11k_hw_qcn9074_rx_desc_get_mpdu_tid,
+	.rx_desc_get_mpdu_peer_id = ath11k_hw_qcn9074_rx_desc_get_mpdu_peer_id,
+	.rx_desc_copy_attn_end_tlv = ath11k_hw_qcn9074_rx_desc_copy_attn_end,
+	.rx_desc_get_mpdu_start_tag = ath11k_hw_qcn9074_rx_desc_get_mpdu_start_tag,
+	.rx_desc_get_mpdu_ppdu_id = ath11k_hw_qcn9074_rx_desc_get_mpdu_ppdu_id,
+	.rx_desc_set_msdu_len = ath11k_hw_qcn9074_rx_desc_set_msdu_len,
+	.rx_desc_get_attention = ath11k_hw_qcn9074_rx_desc_get_attention,
+	.rx_desc_get_msdu_payload = ath11k_hw_qcn9074_rx_desc_get_msdu_payload,
+	.mpdu_info_get_peerid = ath11k_hw_ipq8074_mpdu_info_get_peerid,
+	.rx_desc_mac_addr2_valid = ath11k_hw_ipq9074_rx_desc_mac_addr2_valid,
+	.rx_desc_mpdu_start_addr2 = ath11k_hw_ipq9074_rx_desc_mpdu_start_addr2,
+
+};
+
 #define ATH11K_TX_RING_MASK_0 BIT(0)
 #define ATH11K_TX_RING_MASK_1 BIT(1)
 #define ATH11K_TX_RING_MASK_2 BIT(2)
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index b8afd51d0c1ea..9f45d061d8265 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -275,6 +275,7 @@ extern const struct ath11k_hw_ops qca6390_ops;
 extern const struct ath11k_hw_ops qcn9074_ops;
 extern const struct ath11k_hw_ops wcn6855_ops;
 extern const struct ath11k_hw_ops wcn6750_ops;
+extern const struct ath11k_hw_ops ipq5018_ops;
 
 extern const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_ipq8074;
 extern const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_qca6390;
-- 
2.53.0



