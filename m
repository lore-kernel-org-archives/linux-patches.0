Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B391B3ACEEA;
	Sat, 30 May 2026 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162587; cv=none; b=MueNAA3NJXINlD1/DcYWksy7zgNvMwy0++w2GvTfesU3IZ1nW+FmXaHA3LQQJtZm4//u1oFMy0/PLZrF7+wA8o4mYUy27yo5QOP8fNcROqL62dBIk33UThCbmzeXWCU9Y9hniqqJsyrUpoyzrM3Icp/Am8c/p4qiZ3AgDMYMHtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162587; c=relaxed/simple;
	bh=MKA/dBzrgta5IUA9llrDP1vziLRAbx2kJTuaD3pqYE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoryjaKk1IIhGPglJLmj1o1WY7FepE3Z7IhlplAJ/13JBM+Lw1stDi9V7OTykYCzosDEyVGWZeYjZoyWoFghBYjZVhhRjdwcP80gLwsa/0LqTsHD1CX5QmhCmTUC7Gwwvwe3x/WcfQJUVZEjR1EPdzPILnffURgsekIjLUNtXEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUJ2hLOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUJ2hLOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7101F00893;
	Sat, 30 May 2026 17:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162583;
	bh=IorSZpIfV13xM0jqYFFHh7zHkxtux9BWyXpklUK2awo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUJ2hLOzcBVdby7d0lgrXC5FaC3wgsI1mAzpUUmKAfySl3szYArfucD8LNMVPcPdR
	 MVUaiHkI1mjV3bQBNV6JI73AR7GhzVZw+zRDdK41e8NBU8H6MkPOf0asufcaZtglP7
	 aOmjDE3GO0bSDG8ZmYtDtiSMyGwdx9DxQVtfVAbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram R <quic_srirrama@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 948/969] wifi: ath11k: add new hw ops for IPQ5018 to get rx dest ring hashmap
Date: Sat, 30 May 2026 18:07:52 +0200
Message-ID: <20260530160326.936499918@linuxfoundation.org>
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

[ Upstream commit 69968f88f1770d61cae0febef805fd00d66cf6a1 ]

The Destination ring control register is different
for IPQ5018 when compared to IPQ8074/IPQ6018/QCN9074.
Hence create a new hw ops to fetch the hash ring map
for different device variants. ipq5018 hw ops
is similar to qcn9074 except for this change, so reuse
all the qcn9074 ops for ipq5018.

Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.6.0.1-00861-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Co-developed-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221122132152.17771-8-quic_kathirve@quicinc.com
Stable-dep-of: 2a2451a34afd ("wifi: ath11k: fix peer resolution on rx path when peer_id=0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/hw.c | 44 ++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index 7632220469dab..60ac215e06786 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -792,6 +792,49 @@ static void ath11k_hw_wcn6855_reo_setup(struct ath11k_base *ab)
 			   ring_hash_map);
 }
 
+static void ath11k_hw_ipq5018_reo_setup(struct ath11k_base *ab)
+{
+	u32 reo_base = HAL_SEQ_WCSS_UMAC_REO_REG;
+	u32 val;
+
+	/* Each hash entry uses three bits to map to a particular ring. */
+	u32 ring_hash_map = HAL_HASH_ROUTING_RING_SW1 << 0 |
+		HAL_HASH_ROUTING_RING_SW2 << 4 |
+		HAL_HASH_ROUTING_RING_SW3 << 8 |
+		HAL_HASH_ROUTING_RING_SW4 << 12 |
+		HAL_HASH_ROUTING_RING_SW1 << 16 |
+		HAL_HASH_ROUTING_RING_SW2 << 20 |
+		HAL_HASH_ROUTING_RING_SW3 << 24 |
+		HAL_HASH_ROUTING_RING_SW4 << 28;
+
+	val = ath11k_hif_read32(ab, reo_base + HAL_REO1_GEN_ENABLE);
+
+	val &= ~HAL_REO1_GEN_ENABLE_FRAG_DST_RING;
+	val |= FIELD_PREP(HAL_REO1_GEN_ENABLE_FRAG_DST_RING,
+			HAL_SRNG_RING_ID_REO2SW1) |
+		FIELD_PREP(HAL_REO1_GEN_ENABLE_AGING_LIST_ENABLE, 1) |
+		FIELD_PREP(HAL_REO1_GEN_ENABLE_AGING_FLUSH_ENABLE, 1);
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_GEN_ENABLE, val);
+
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_AGING_THRESH_IX_0(ab),
+			   HAL_DEFAULT_REO_TIMEOUT_USEC);
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_AGING_THRESH_IX_1(ab),
+			   HAL_DEFAULT_REO_TIMEOUT_USEC);
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_AGING_THRESH_IX_2(ab),
+			   HAL_DEFAULT_REO_TIMEOUT_USEC);
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_AGING_THRESH_IX_3(ab),
+			   HAL_DEFAULT_REO_TIMEOUT_USEC);
+
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_DEST_RING_CTRL_IX_0,
+			   ring_hash_map);
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_DEST_RING_CTRL_IX_1,
+			   ring_hash_map);
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_DEST_RING_CTRL_IX_2,
+			   ring_hash_map);
+	ath11k_hif_write32(ab, reo_base + HAL_REO1_DEST_RING_CTRL_IX_3,
+			   ring_hash_map);
+}
+
 static u16 ath11k_hw_ipq8074_mpdu_info_get_peerid(u8 *tlv_data)
 {
 	u16 peer_id = 0;
@@ -1118,6 +1161,7 @@ const struct ath11k_hw_ops ipq5018_ops = {
 	.rx_desc_get_mpdu_ppdu_id = ath11k_hw_qcn9074_rx_desc_get_mpdu_ppdu_id,
 	.rx_desc_set_msdu_len = ath11k_hw_qcn9074_rx_desc_set_msdu_len,
 	.rx_desc_get_attention = ath11k_hw_qcn9074_rx_desc_get_attention,
+	.reo_setup = ath11k_hw_ipq5018_reo_setup,
 	.rx_desc_get_msdu_payload = ath11k_hw_qcn9074_rx_desc_get_msdu_payload,
 	.mpdu_info_get_peerid = ath11k_hw_ipq8074_mpdu_info_get_peerid,
 	.rx_desc_mac_addr2_valid = ath11k_hw_ipq9074_rx_desc_mac_addr2_valid,
-- 
2.53.0



