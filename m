Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617688;
	b=Ml2w20HuqCkBL7vQe+GZ+e14N+nVkX1W3kow2InRdjKjabTzmeyf1QKX/Cq6c4H09Pmw
	 1OYNfJtylc1wwCCIOINkiXzFUNE3dNc/0D8a+y5hiAz159QyAQscukHNs8RLOtaSoPUW7
	 VlDL1YsMA//eDWKekEcsVLh4gDiPFqqtrLox+XfrK6VtS/TwqjmJtNl22dL2SDEKV+PrN
	 1Sp7cAn5teHvGoB+rwk9i/1k1uV4088N/IcPi7xadinjB1hkCNLg5pjaTIgLfPmDiIF5b
	 TsAh2FHDP+1sBJLwQySG5+GbmXZUTNWZQxwFpFeQJyLeVwpXzQs5VIXNxU33p0270vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NuX2ZEhQ3c19K2DIDSKDYasHydnmFg0qDTzoGVSdogE=;
	b=gMFyhyNFO6GVZEEbGZ3ShFjjF64ESLPY7J9ypzxJUhasZLbaOeu7gO3VnuaiU+dvWWcf
	 m0QTAbHelR5HIKXmqffhf7Ms+wInbDdCYKGYJdEwK5w+dCErK7NxFubH2bT4jxMI5HXOV
	 yCRedP+y+nAXbTe7qPUz6yVUnkEg9RsT1Z8Ibc8PK/pQisYDVmYYcA2+PshMl/VN0z16g
	 KMIJrpjfAzZ2aPYv0VeYiSw0ggC1FBPhFIQo1fGscZE0Y87+nWAwubx6si2TGPpEip7iR
	 hUXOInyFSz7KzsLPsWjadzr9Q+gjspAjRP9hPrKYAdeuzZfOH3wL1HFr2jnw5bvZ9Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/LbHkTG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61347606A31E;
	Wed, 25 Nov 2026 14:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/LbHkTG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA9B1F000C4;
	Wed, 25 Nov 2026 14:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617688;
	bh=NuX2ZEhQ3c19K2DIDSKDYasHydnmFg0qDTzoGVSdogE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/LbHkTG/ifBMxhMVxVdg/NJ9a6XMqsrMdnvZgWpBK31AWrBShg8em2fG7UsAFHY/
	 6souTfITsRHthLwAy5TCDfZRAo4v0fqlJPyaa361xkuHFUamJK4bb7G3oppqfLEx2o
	 +kb81PUdZxhXq3EzwzujzF1ASV+8PHwOEEl1HhS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0043/1005] wifi: ath12k: fix decap of MSDUs spanning multiple RX buffers
Date: Wed, 25 Nov 2026 15:23:01 +0100
Message-ID: <20261125143822.749457257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 1e678e37ff13e45f22d78d802fcefa8f9a0d9395 ]

When a MSDU is split across multiple RX buffers, the msdu_end TLV is
populated only in the last buffer. Since commit e8a1e49c6328
("wifi: ath12k: Add new infra for the rx path"), the RX info
extraction in ath12k_hal_extract_rx_desc_data_*() helpers runs before
the MSDU is coalesced, so the msdu_end-derived fields (decap_type,
mesh_ctrl_present, is_from_ds, is_to_ds, is_mcbc, is_decrypted, sgi,
rate_mcs, bw, phy_meta_data, pkt_type, nss, checksum flags and
err_bitmap, plus tid on QCN9274) were read from the first buffer, where
that TLV is not valid.

As a result decap_type was reported as DP_RX_DECAP_TYPE_RAW and the
frame was handed to mac80211 with a raw 802.11 header instead of being
converted to an ethernet frame, breaking reception of any frame larger
than the single RX buffer.

Fix it by parsing the msdu_end fields from the last buffer (ldesc) in
ath12k_hal_extract_rx_desc_data_{wcn7850,qcn9274,qcc2072}(), keeping the
mpdu_start fields (enctype, seq_no, peer_id and addr2) on the first
buffer (rx_desc). The tid field is read from mpdu_start on WCN7850 and
QCC2072, and from msdu_end on QCN9274. For single-buffer MSDUs rx_desc
and ldesc point to the same descriptor so the behavior is unchanged.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: e8a1e49c6328 ("wifi: ath12k: Add new infra for the rx path")
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261015-ath12k-fix-descap-multiple-rx-buf-v2-1-4cde055677ed@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/ath/ath12k/wifi7/hal_qcc2072.c   | 30 ++++++++---------
 .../wireless/ath/ath12k/wifi7/hal_qcn9274.c   | 32 +++++++++----------
 .../wireless/ath/ath12k/wifi7/hal_wcn7850.c   | 30 ++++++++---------
 3 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
index 7cf00fda996f3..7ea7559e882c2 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
@@ -402,32 +402,32 @@ static void ath12k_hal_extract_rx_desc_data_qcc2072(struct hal_rx_desc_data *rx_
 	rx_desc_data->is_last_msdu = ath12k_hal_rx_desc_get_last_msdu_qcc2072(ldesc);
 	rx_desc_data->l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_qcc2072(ldesc);
 	rx_desc_data->enctype = ath12k_hal_rx_desc_get_encrypt_type_qcc2072(rx_desc);
-	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_qcc2072(rx_desc);
+	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_qcc2072(ldesc);
 	rx_desc_data->mesh_ctrl_present =
-				ath12k_hal_rx_desc_get_mesh_ctl_qcc2072(rx_desc);
+				ath12k_hal_rx_desc_get_mesh_ctl_qcc2072(ldesc);
 	rx_desc_data->seq_ctl_valid =
 				ath12k_hal_rx_desc_get_mpdu_seq_ctl_vld_qcc2072(rx_desc);
 	rx_desc_data->fc_valid = ath12k_hal_rx_desc_get_mpdu_fc_valid_qcc2072(rx_desc);
 	rx_desc_data->seq_no = ath12k_hal_rx_desc_get_mpdu_start_seq_no_qcc2072(rx_desc);
 	rx_desc_data->msdu_len = ath12k_hal_rx_desc_get_msdu_len_qcc2072(ldesc);
-	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_qcc2072(rx_desc);
-	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_qcc2072(rx_desc);
-	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_qcc2072(rx_desc);
-	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_qcc2072(rx_desc);
-	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_qcc2072(rx_desc);
-	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_qcc2072(rx_desc);
-	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_qcc2072(rx_desc);
-	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_qcc2072(rx_desc));
+	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_qcc2072(ldesc);
+	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_qcc2072(ldesc);
+	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_qcc2072(ldesc);
+	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_qcc2072(ldesc);
+	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_qcc2072(ldesc);
+	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_qcc2072(ldesc);
+	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_qcc2072(ldesc);
+	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_qcc2072(ldesc));
 	rx_desc_data->tid = ath12k_hal_rx_desc_get_mpdu_tid_qcc2072(rx_desc);
 	rx_desc_data->peer_id = ath12k_hal_rx_desc_get_mpdu_peer_id_qcc2072(rx_desc);
 	rx_desc_data->addr2_present = ath12k_hal_rx_desc_mac_addr2_valid_qcc2072(rx_desc);
 	rx_desc_data->addr2 = ath12k_hal_rx_desc_mpdu_start_addr2_qcc2072(rx_desc);
-	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_qcc2072(rx_desc);
+	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_qcc2072(ldesc);
 	rx_desc_data->msdu_done = ath12k_hal_rx_h_msdu_done_qcc2072(ldesc);
-	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_qcc2072(rx_desc);
-	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_qcc2072(rx_desc);
-	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_qcc2072(rx_desc);
-	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_qcc2072(rx_desc);
+	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_qcc2072(ldesc);
+	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_qcc2072(ldesc);
+	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_qcc2072(ldesc);
+	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_qcc2072(ldesc);
 }
 
 static int ath12k_hal_srng_create_config_qcc2072(struct ath12k_hal *hal)
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
index 052b59265af85..355cf50d2785f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
@@ -922,32 +922,32 @@ void ath12k_hal_extract_rx_desc_data_qcn9274(struct hal_rx_desc_data *rx_desc_da
 	rx_desc_data->is_last_msdu = ath12k_hal_rx_desc_get_last_msdu_qcn9274(ldesc);
 	rx_desc_data->l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_qcn9274(ldesc);
 	rx_desc_data->enctype = ath12k_hal_rx_desc_get_encrypt_type_qcn9274(rx_desc);
-	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_qcn9274(rx_desc);
+	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_qcn9274(ldesc);
 	rx_desc_data->mesh_ctrl_present =
-		ath12k_hal_rx_desc_get_mesh_ctl_qcn9274(rx_desc);
+		ath12k_hal_rx_desc_get_mesh_ctl_qcn9274(ldesc);
 	rx_desc_data->seq_ctl_valid =
 		ath12k_hal_rx_desc_get_mpdu_seq_ctl_vld_qcn9274(rx_desc);
 	rx_desc_data->fc_valid = ath12k_hal_rx_desc_get_mpdu_fc_valid_qcn9274(rx_desc);
-	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_qcn9274(rx_desc);
-	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_qcn9274(rx_desc);
+	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_qcn9274(ldesc);
+	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_qcn9274(ldesc);
 	rx_desc_data->seq_no = ath12k_hal_rx_desc_get_mpdu_start_seq_no_qcn9274(rx_desc);
 	rx_desc_data->msdu_len = ath12k_hal_rx_desc_get_msdu_len_qcn9274(ldesc);
-	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_qcn9274(rx_desc);
-	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_qcn9274(rx_desc);
-	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_qcn9274(rx_desc);
-	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_qcn9274(rx_desc);
-	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_qcn9274(rx_desc);
-	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_qcn9274(rx_desc));
-	rx_desc_data->tid = ath12k_hal_rx_desc_get_mpdu_tid_qcn9274(rx_desc);
+	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_qcn9274(ldesc);
+	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_qcn9274(ldesc);
+	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_qcn9274(ldesc);
+	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_qcn9274(ldesc);
+	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_qcn9274(ldesc);
+	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_qcn9274(ldesc));
+	rx_desc_data->tid = ath12k_hal_rx_desc_get_mpdu_tid_qcn9274(ldesc);
 	rx_desc_data->peer_id = ath12k_hal_rx_desc_get_mpdu_peer_id_qcn9274(rx_desc);
 	rx_desc_data->addr2_present = ath12k_hal_rx_desc_mac_addr2_valid_qcn9274(rx_desc);
 	rx_desc_data->addr2 = ath12k_hal_rx_desc_mpdu_start_addr2_qcn9274(rx_desc);
-	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_qcn9274(rx_desc);
+	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_qcn9274(ldesc);
 	rx_desc_data->msdu_done = ath12k_hal_rx_h_msdu_done_qcn9274(ldesc);
-	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_qcn9274(rx_desc);
-	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_qcn9274(rx_desc);
-	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_qcn9274(rx_desc);
-	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_qcn9274(rx_desc);
+	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_qcn9274(ldesc);
+	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_qcn9274(ldesc);
+	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_qcn9274(ldesc);
+	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_qcn9274(ldesc);
 }
 
 static u16 ath12k_hal_reo_status_dec_tlv_hdr_qcn9274(void *tlv, void **desc)
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
index 61be8443e46ee..abe982faeb2b7 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
@@ -604,32 +604,32 @@ void ath12k_hal_extract_rx_desc_data_wcn7850(struct hal_rx_desc_data *rx_desc_da
 	rx_desc_data->is_last_msdu = ath12k_hal_rx_desc_get_last_msdu_wcn7850(ldesc);
 	rx_desc_data->l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_wcn7850(ldesc);
 	rx_desc_data->enctype = ath12k_hal_rx_desc_get_encrypt_type_wcn7850(rx_desc);
-	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_wcn7850(rx_desc);
+	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_wcn7850(ldesc);
 	rx_desc_data->mesh_ctrl_present =
-		ath12k_hal_rx_desc_get_mesh_ctl_wcn7850(rx_desc);
+		ath12k_hal_rx_desc_get_mesh_ctl_wcn7850(ldesc);
 	rx_desc_data->seq_ctl_valid =
 		ath12k_hal_rx_desc_get_mpdu_seq_ctl_vld_wcn7850(rx_desc);
 	rx_desc_data->fc_valid = ath12k_hal_rx_desc_get_mpdu_fc_valid_wcn7850(rx_desc);
 	rx_desc_data->seq_no = ath12k_hal_rx_desc_get_mpdu_start_seq_no_wcn7850(rx_desc);
 	rx_desc_data->msdu_len = ath12k_hal_rx_desc_get_msdu_len_wcn7850(ldesc);
-	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_wcn7850(rx_desc);
-	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_wcn7850(rx_desc);
-	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_wcn7850(rx_desc);
-	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_wcn7850(rx_desc);
-	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_wcn7850(rx_desc);
-	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_wcn7850(rx_desc);
-	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_wcn7850(rx_desc);
-	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_wcn7850(rx_desc));
+	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_wcn7850(ldesc);
+	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_wcn7850(ldesc);
+	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_wcn7850(ldesc);
+	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_wcn7850(ldesc);
+	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_wcn7850(ldesc);
+	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_wcn7850(ldesc);
+	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_wcn7850(ldesc);
+	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_wcn7850(ldesc));
 	rx_desc_data->tid = ath12k_hal_rx_desc_get_mpdu_tid_wcn7850(rx_desc);
 	rx_desc_data->peer_id = ath12k_hal_rx_desc_get_mpdu_peer_id_wcn7850(rx_desc);
 	rx_desc_data->addr2_present = ath12k_hal_rx_desc_mac_addr2_valid_wcn7850(rx_desc);
 	rx_desc_data->addr2 = ath12k_hal_rx_desc_mpdu_start_addr2_wcn7850(rx_desc);
-	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_wcn7850(rx_desc);
+	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_wcn7850(ldesc);
 	rx_desc_data->msdu_done = ath12k_hal_rx_h_msdu_done_wcn7850(ldesc);
-	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_wcn7850(rx_desc);
-	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_wcn7850(rx_desc);
-	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_wcn7850(rx_desc);
-	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_wcn7850(rx_desc);
+	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_wcn7850(ldesc);
+	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_wcn7850(ldesc);
+	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_wcn7850(ldesc);
+	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_wcn7850(ldesc);
 }
 
 int ath12k_hal_srng_create_config_wcn7850(struct ath12k_hal *hal)
-- 
2.53.0



