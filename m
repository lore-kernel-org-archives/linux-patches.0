Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A3D3A5E77;
	Sat, 17 Oct 2026 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253276; cv=none; b=FqZHZvqBhg0jx1yK2oGApgS3EdWAZ/KLo1MiPmpF4acrAznvH72q9/Nkq1LK7r/hKE8kGoDK2bGlP2X716Azsk0EpqM6hG01UB+H9/X3nRRDwyP9AKK1njYTwNzHy//a7ZMk26UxGDKyl7uHwp+CbELUcwnodwgw4SqYOje9EYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253276; c=relaxed/simple;
	bh=30e3AE112q+UyxgBUz0VSpDqX8MF0LGsEodfppG/8b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ5rYw3223u5GDkH5PUCbODK6+vmt2a1h8I4uJmUWHgTg9+WQkn75//2CCctTm1cZ3aLk0HvRQxLbaO15Lcfo4ba9Df9sFc4rnq0Gp9cQkZsZt59FjqD1IJndbje9RO5YooBbptxaHdjEGSl9p745SlLoqxAXaG8r17yAxu9buM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL6OA0xe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL6OA0xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DEC1F000C5;
	Sat, 17 Oct 2026 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253271;
	bh=SpK0NlldIu8BV90+wVBQ7obrmU4SEnHSLTE0rIelwmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KL6OA0xeqyrP3NiCP26YHXTFftOgyJLFBqF0g7vyfs72OaiLqW73RrPQbzo0CzSym
	 ZuUj2feOfHuFL8oERX17X1zpPDjkPdlQMcrB9aE2+FVj9atuRvX3CBPmv2jrUp7Hnx
	 e4WqWRXTwDMqeGqfJjuCy/RmpKWyHMwOGzLi+yZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <quic_kangyang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/869] wifi: ath12k: fix struct hal_rx_phyrx_rssi_legacy_info
Date: Sat, 17 Oct 2026 17:48:23 +0200
Message-ID: <20261017160038.612057698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <quic_kangyang@quicinc.com>

[ Upstream commit 04f33114af00317dc3c494e60a7c42292e0ffd7e ]

Current struct hal_rx_phyrx_rssi_legacy_info in hal_rx.h is not matched
with hardware descriptor definition. This hardware descriptor definition
is determined by hardware. Host shall follow it.

So update struct hal_rx_phyrx_rssi_legacy_info and related code.

Both QCN9274 and WCN7850 need this modification.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00210-QCAHKSWPL_SILICONZ-1

Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20241022110831.974-5-quic_kangyang@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Stable-dep-of: ecfc13138992 ("wifi: ath12k: Avoid memory leak while enabling statistics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 25 ++++++------------------
 drivers/net/wireless/ath/ath12k/hal_rx.h |  9 ++++++---
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 7bfd323cdf244..95e9d652c611d 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -731,33 +731,20 @@ ath12k_dp_mon_rx_parse_status_tlv(struct ath12k_base *ab,
 	case HAL_PHYRX_RSSI_LEGACY: {
 		struct hal_rx_phyrx_rssi_legacy_info *rssi =
 			(struct hal_rx_phyrx_rssi_legacy_info *)tlv_data;
-		u32 reception_type = 0;
-		u32 rssi_legacy_info = __le32_to_cpu(rssi->rsvd[0]);
 
 		info[0] = __le32_to_cpu(rssi->info0);
+		info[1] = __le32_to_cpu(rssi->info1);
 
 		/* TODO: Please note that the combined rssi will not be accurate
 		 * in MU case. Rssi in MU needs to be retrieved from
 		 * PHYRX_OTHER_RECEIVE_INFO TLV.
 		 */
 		ppdu_info->rssi_comb =
-			u32_get_bits(info[0],
-				     HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RSSI_COMB);
-		reception_type =
-			u32_get_bits(rssi_legacy_info,
-				     HAL_RX_PHYRX_RSSI_LEGACY_INFO_RSVD1_RECEPTION);
-
-		switch (reception_type) {
-		case HAL_RECEPTION_TYPE_ULOFMDA:
-			ppdu_info->reception_type = HAL_RX_RECEPTION_TYPE_MU_OFDMA;
-			break;
-		case HAL_RECEPTION_TYPE_ULMIMO:
-			ppdu_info->reception_type = HAL_RX_RECEPTION_TYPE_MU_MIMO;
-			break;
-		default:
-			ppdu_info->reception_type = HAL_RX_RECEPTION_TYPE_SU;
-			break;
-		}
+			u32_get_bits(info[1],
+				     HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO1_RSSI_COMB);
+
+		ppdu_info->bw = u32_get_bits(info[0],
+					     HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RX_BW);
 		break;
 	}
 	case HAL_RXPCU_PPDU_END_INFO: {
diff --git a/drivers/net/wireless/ath/ath12k/hal_rx.h b/drivers/net/wireless/ath/ath12k/hal_rx.h
index 8c37cbc01b1c5..e12734fd56bca 100644
--- a/drivers/net/wireless/ath/ath12k/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/hal_rx.h
@@ -437,12 +437,15 @@ enum hal_rx_ul_reception_type {
 	HAL_RECEPTION_TYPE_FRAMELESS
 };
 
-#define HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RSSI_COMB	GENMASK(15, 8)
-#define HAL_RX_PHYRX_RSSI_LEGACY_INFO_RSVD1_RECEPTION   GENMASK(3, 0)
+#define HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RECEPTION	GENMASK(3, 0)
+#define HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RX_BW	GENMASK(7, 5)
+#define HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO1_RSSI_COMB	GENMASK(15, 8)
 
 struct hal_rx_phyrx_rssi_legacy_info {
-	__le32 rsvd[35];
 	__le32 info0;
+	__le32 rsvd0[39];
+	__le32 info1;
+	__le32 rsvd1;
 } __packed;
 
 #define HAL_RX_MPDU_START_INFO0_PPDU_ID	GENMASK(31, 16)
-- 
2.53.0



