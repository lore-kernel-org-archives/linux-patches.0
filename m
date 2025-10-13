Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7C42798FA;
	Mon, 13 Oct 2025 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369856; cv=none; b=afClSBG6FVLO6oHFJ4YlYhZAC5vH8Uz7haRWtyyfU6DMy/cVnbzyHhptNIRiE1JeTLUMfPdIlM9aSE97qCk1Bq9Hh8/2tsRL6rugpcoT+t/ruvhprmPBg3+rxU1kPjcmKpco4H8ml/RtZR6NxzkHO4KJL9JDVdnS/sDVnUGdtGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369856; c=relaxed/simple;
	bh=Wws//XBKsJFur0dZO17HfKDzTafFAHTuiP4WLtpi/Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPik9g6hPq42QpVm+kPAyzLQsiwBI8E5Z6fJnJOac7X2+v8Bpb5ZuxUyAJ84P/LR2aeskxHTiQ1SFJi53DrRa8l3QXAgmcva/+h8gIwgS62legsUWONWzMAMITL3ox6BZ35+NCSqHpHPsYgLzSCVu1onI5pM8nvNp+ucGUM6Esw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izi83aky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izi83aky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA367C4CEE7;
	Mon, 13 Oct 2025 15:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369856;
	bh=Wws//XBKsJFur0dZO17HfKDzTafFAHTuiP4WLtpi/Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izi83aky46IrWxGhMn3KBG/kOBGzA0YjhITw9TfkVwy/bojqnwhlPGqerJEFVZLBh
	 QTbNkEUxw7bQ/z28bu6mP9u1SvVTmBmH6w9oiv495M6cCqrrbO5gD2u9cR+9GHmWpz
	 gP6e/CmBnYBfjXvsym7aUd0xTlPGArphTfwyrAmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 393/563] wifi: ath12k: fix HAL_PHYRX_COMMON_USER_INFO handling in monitor mode
Date: Mon, 13 Oct 2025 16:44:14 +0200
Message-ID: <20251013144425.520886547@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit 6b46e85129185ec076f9c3bd2813dfd2f968522b ]

Current monitor mode will parse TLV HAL_PHYRX_OTHER_RECEIVE_INFO with
struct hal_phyrx_common_user_info.

Obviously, they do not match. The original intention here was to parse
HAL_PHYRX_COMMON_USER_INFO. So fix it by correctly parsing
HAL_PHYRX_COMMON_USER_INFO instead.

Also add LTF parsing and report to radiotap along with GI.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: d939919a36f4 ("wifi: ath12k: Add HAL_PHYRX_OTHER_RECEIVE_INFO TLV parsing support")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250722095934.67-3-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 35 ++++++++++++++++++++----
 drivers/net/wireless/ath/ath12k/hal_rx.h |  3 +-
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index ec1587d0b917c..e93ede5e6197c 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -1440,6 +1440,34 @@ static void ath12k_dp_mon_parse_rx_msdu_end_err(u32 info, u32 *errmap)
 		*errmap |= HAL_RX_MPDU_ERR_MPDU_LEN;
 }
 
+static void
+ath12k_parse_cmn_usr_info(const struct hal_phyrx_common_user_info *cmn_usr_info,
+			  struct hal_rx_mon_ppdu_info *ppdu_info)
+{
+	struct hal_rx_radiotap_eht *eht = &ppdu_info->eht_info.eht;
+	u32 known, data, cp_setting, ltf_size;
+
+	known = __le32_to_cpu(eht->known);
+	known |= IEEE80211_RADIOTAP_EHT_KNOWN_GI |
+		IEEE80211_RADIOTAP_EHT_KNOWN_EHT_LTF;
+	eht->known = cpu_to_le32(known);
+
+	cp_setting = le32_get_bits(cmn_usr_info->info0,
+				   HAL_RX_CMN_USR_INFO0_CP_SETTING);
+	ltf_size = le32_get_bits(cmn_usr_info->info0,
+				 HAL_RX_CMN_USR_INFO0_LTF_SIZE);
+
+	data = __le32_to_cpu(eht->data[0]);
+	data |= u32_encode_bits(cp_setting, IEEE80211_RADIOTAP_EHT_DATA0_GI);
+	data |= u32_encode_bits(ltf_size, IEEE80211_RADIOTAP_EHT_DATA0_LTF);
+	eht->data[0] = cpu_to_le32(data);
+
+	if (!ppdu_info->ltf_size)
+		ppdu_info->ltf_size = ltf_size;
+	if (!ppdu_info->gi)
+		ppdu_info->gi = cp_setting;
+}
+
 static void
 ath12k_dp_mon_parse_status_msdu_end(struct ath12k_mon_data *pmon,
 				    const struct hal_rx_msdu_end *msdu_end)
@@ -1641,11 +1669,8 @@ ath12k_dp_mon_rx_parse_status_tlv(struct ath12k *ar,
 					     HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RX_BW);
 		break;
 	}
-	case HAL_PHYRX_OTHER_RECEIVE_INFO: {
-		const struct hal_phyrx_common_user_info *cmn_usr_info = tlv_data;
-
-		ppdu_info->gi = le32_get_bits(cmn_usr_info->info0,
-					      HAL_RX_PHY_CMN_USER_INFO0_GI);
+	case HAL_PHYRX_COMMON_USER_INFO: {
+		ath12k_parse_cmn_usr_info(tlv_data, ppdu_info);
 		break;
 	}
 	case HAL_RX_PPDU_START_USER_INFO:
diff --git a/drivers/net/wireless/ath/ath12k/hal_rx.h b/drivers/net/wireless/ath/ath12k/hal_rx.h
index a3ab588aae19d..801a5f6d3458b 100644
--- a/drivers/net/wireless/ath/ath12k/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/hal_rx.h
@@ -695,7 +695,8 @@ struct hal_rx_resp_req_info {
 #define HAL_RX_MPDU_ERR_MPDU_LEN		BIT(6)
 #define HAL_RX_MPDU_ERR_UNENCRYPTED_FRAME	BIT(7)
 
-#define HAL_RX_PHY_CMN_USER_INFO0_GI		GENMASK(17, 16)
+#define HAL_RX_CMN_USR_INFO0_CP_SETTING			GENMASK(17, 16)
+#define HAL_RX_CMN_USR_INFO0_LTF_SIZE			GENMASK(19, 18)
 
 struct hal_phyrx_common_user_info {
 	__le32 rsvd[2];
-- 
2.51.0



