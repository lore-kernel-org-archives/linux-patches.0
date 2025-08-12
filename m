Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6BD2FF143;
	Tue, 12 Aug 2025 18:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023961; cv=none; b=biQANh21Ooy2NgJI9qicDLzz1TJkUU50EWvfKXVeGGHYdezM03on/KV9OiFCaVB+/V0prPaPjy3en/fIYnEs2F9BKQRvl9gxTZAR1MKSmI8TsFtybQcDQaP/42kyBqwRBrsVReMvtjEYKEBAXlxTUVlTNuDYBmyeEDO7QELLtFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023961; c=relaxed/simple;
	bh=UAIEPWvZfQEVaWUJ86nDvPZ93J4EMbDL4oncZiZVLU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRMlR+GA/rGlK7bS+Trxy/0VQZw4ghxf3Ep/wvFd0h0qDcit4lOOeXy82O9ZVqTZbjE1ErfEH0recL069dHANr/OZ2EdQEuxcIqyI0bKqnO/zT6FVc6kxFR7fM8mhDLrl+uWGNAh9KC/nrj5CM+7AOjCEUPSuAp67duUHh2Oy3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=120p8p3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="120p8p3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EC0C4CEF0;
	Tue, 12 Aug 2025 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023960;
	bh=UAIEPWvZfQEVaWUJ86nDvPZ93J4EMbDL4oncZiZVLU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=120p8p3ITHATzho90FirsFaRSnucb8kcIOfB/4/yiOHvhO0M+eItA1c/IhFGAju/M
	 XOwpRUV6SMnV8CmE5o7xlc5MJX89PI1wSzyV4uke2Qgia6w5o+NUxX56SXLipru7rm
	 e7784YKLWgST7HQLe7Qw42C7Vj2eWluf2Rwa1lpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 205/627] wifi: ath12k: pack HTT pdev rate stats structs
Date: Tue, 12 Aug 2025 19:28:20 +0200
Message-ID: <20250812173427.082558981@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit fee9b1f6691120182136edacf590f52d62d9de7f ]

In order to ensure the HTT DebugFS structs shared with firmware have
matching alignment, the structs should be packed. Most of the structs
are correctly packed, however the following are not:

ath12k_htt_tx_pdev_rate_stats_tlv
ath12k_htt_rx_pdev_rate_stats_tlv
ath12k_htt_rx_pdev_rate_ext_stats_tlv

So pack those structs.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: ba42b22aa336 ("wifi: ath12k: Dump PDEV transmit rate HTT stats")
Fixes: a24cd7583003 ("wifi: ath12k: Dump PDEV receive rate HTT stats")
Fixes: 7a3e8eec8d18 ("wifi: ath12k: Dump additional PDEV receive rate HTT stats")
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250702-debugfs_htt_packed-v1-1-07bd18b31e79@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.h b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.h
index c2a02cf8a38b..db9532c39cbf 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.h
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.h
@@ -470,7 +470,7 @@ struct ath12k_htt_tx_pdev_rate_stats_tlv {
 			   [ATH12K_HTT_TX_PDEV_STATS_NUM_EXTRA_MCS_COUNTERS];
 	__le32 tx_mcs_ext_2[ATH12K_HTT_TX_PDEV_STATS_NUM_EXTRA2_MCS_COUNTERS];
 	__le32 tx_bw_320mhz;
-};
+} __packed;
 
 #define ATH12K_HTT_RX_PDEV_STATS_NUM_LEGACY_CCK_STATS		4
 #define ATH12K_HTT_RX_PDEV_STATS_NUM_LEGACY_OFDM_STATS		8
@@ -550,7 +550,7 @@ struct ath12k_htt_rx_pdev_rate_stats_tlv {
 	__le32 rx_ulofdma_non_data_nusers[ATH12K_HTT_RX_PDEV_MAX_OFDMA_NUM_USER];
 	__le32 rx_ulofdma_data_nusers[ATH12K_HTT_RX_PDEV_MAX_OFDMA_NUM_USER];
 	__le32 rx_mcs_ext[ATH12K_HTT_RX_PDEV_STATS_NUM_EXTRA_MCS_COUNTERS];
-};
+} __packed;
 
 #define ATH12K_HTT_RX_PDEV_STATS_NUM_BW_EXT_COUNTERS		4
 #define ATH12K_HTT_RX_PDEV_STATS_NUM_MCS_COUNTERS_EXT		14
@@ -580,7 +580,7 @@ struct ath12k_htt_rx_pdev_rate_ext_stats_tlv {
 	__le32 rx_gi_ext_2[ATH12K_HTT_RX_PDEV_STATS_NUM_GI_COUNTERS]
 		[ATH12K_HTT_RX_PDEV_STATS_NUM_EXTRA2_MCS_COUNTERS];
 	__le32 rx_su_punctured_mode[ATH12K_HTT_RX_PDEV_STATS_NUM_PUNCTURED_MODE_COUNTERS];
-};
+} __packed;
 
 #define ATH12K_HTT_TX_PDEV_STATS_SCHED_PER_TXQ_MAC_ID	GENMASK(7, 0)
 #define ATH12K_HTT_TX_PDEV_STATS_SCHED_PER_TXQ_ID	GENMASK(15, 8)
-- 
2.39.5



