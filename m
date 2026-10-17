Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE82438654F;
	Sat, 17 Oct 2026 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253278; cv=none; b=hN4Ji6ZCz9bRvDUOj4KZbufd/Mm6AL9jfqsXRu3+9XZYBlGrtZ25Caf06gyFjTM8+OMd5zdT2c8GvQQn13B324DIxNCcPKlmLr7PqdHin8mQLzaRxjNoF/i7mog4t5QYwb5N1925v9UrA+fHYOydt0clzwxKMQDl6LlomfgMq1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253278; c=relaxed/simple;
	bh=WIT4Yf6IAvWQ1lUAAz36ZftlTZ5yDphsGQY32HGVy9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zghyzn6Sk2I93HjlmyL+apAn+2sBQdjxXZMbTbENQFGa7qMl0Y07APFaFOsL8mz/mn8XXDP0oI0z56/g+6aQJWKTIT8+64pfBFxBMkFvh+pRH6T1bT9nuXH7AwBC4yXmCgrNzhgy4FQC0p+A1R7F9pz2LXZT39u/ypbePgBuaDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnlftGls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnlftGls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11821F000C4;
	Sat, 17 Oct 2026 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253274;
	bh=ZrHteGo1LJ7qbnNO7tE56zZ9anb5A7hFC5pyBD4/yv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnlftGlsqKNqr1grb6t54MR+nhuzI0z5aeGkabLFGiiwlbd1AtKTb+RAqMnQ0lvYy
	 nD094du2Hm4XbW2NmPxnP8ZnMi22YUjWPXkIHxu+439LgPP3DgXA3I3u24ANt3oVwo
	 K8wfYdwJ7bpml+A71TUMaMKE00i7QSf2J4MGGrow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/869] wifi: ath12k: fix incorrect TID updation in DP monitor status path
Date: Sat, 17 Oct 2026 17:48:24 +0200
Message-ID: <20261017160038.638822656@linuxfoundation.org>
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

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit ebee84cc961cd3947015efbf4a5dbea63b11c5d3 ]

Currently, an incorrect TID value gets populated in the monitor status Rx
path due to an incorrect bitmap value given to the ffs() built-in helper
function. Therefore, avoid the decrement and directly provide the TID
bitmap to the ffs() built-in helper function for the correct TID update
in the monitor status Rx path.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241217084511.2981515-6-quic_periyasa@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Stable-dep-of: ecfc13138992 ("wifi: ath12k: Avoid memory leak while enabling statistics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 95e9d652c611d..f1377e186518a 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -612,6 +612,7 @@ ath12k_dp_mon_rx_parse_status_tlv(struct ath12k_base *ab,
 	case HAL_RX_PPDU_END_USER_STATS: {
 		struct hal_rx_ppdu_end_user_stats *eu_stats =
 			(struct hal_rx_ppdu_end_user_stats *)tlv_data;
+		u32 tid_bitmap;
 
 		info[0] = __le32_to_cpu(eu_stats->info0);
 		info[1] = __le32_to_cpu(eu_stats->info1);
@@ -624,10 +625,9 @@ ath12k_dp_mon_rx_parse_status_tlv(struct ath12k_base *ab,
 			u32_get_bits(info[2], HAL_RX_PPDU_END_USER_STATS_INFO2_AST_INDEX);
 		ppdu_info->fc_valid =
 			u32_get_bits(info[1], HAL_RX_PPDU_END_USER_STATS_INFO1_FC_VALID);
-		ppdu_info->tid =
-			ffs(u32_get_bits(info[6],
-					 HAL_RX_PPDU_END_USER_STATS_INFO6_TID_BITMAP)
-					 - 1);
+		tid_bitmap = u32_get_bits(info[6],
+					  HAL_RX_PPDU_END_USER_STATS_INFO6_TID_BITMAP);
+		ppdu_info->tid = ffs(tid_bitmap) - 1;
 		ppdu_info->tcp_msdu_count =
 			u32_get_bits(info[4],
 				     HAL_RX_PPDU_END_USER_STATS_INFO4_TCP_MSDU_CNT);
-- 
2.53.0



