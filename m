Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD69718C931;
	Tue, 30 Jul 2024 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356068; cv=none; b=Zpx3u06CFa7Hq6OvkGtyZWi10kivjaDFC7Hcvo+KGNOlkcxzxpYVAZYZvmscwWTbjnuFXSCwAIffrrElsgjoPnBTk2yAus0YQ4MBVS4V/t0FFPc5nZeMT/vnxpB71xqrC7sOUMBLg+zc9nUzkNvwLeUezoIDDdwtiRe2i3b2wS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356068; c=relaxed/simple;
	bh=JAmAP+oRiQJI+3YTaEMcVehtYcKUSKO5ITMgLWd/O/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksJ1oqMMSrWrwxUhd1vd9zmrCZx72nYQY+TVHSoIMLb63HnS4/Q/jKPCH/Dp9xvMHhNXCdHvfwWpNUiJeNdF2goPQpx7ScGvYi5wBVQhR7mz3cQWuBVEmJ3i/W/4+gcoF4+As3RsEESLSjCvMh1OAtsMnc/98pXVW9GQuK4d8O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+E4SBNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+E4SBNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A0CC32782;
	Tue, 30 Jul 2024 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356067;
	bh=JAmAP+oRiQJI+3YTaEMcVehtYcKUSKO5ITMgLWd/O/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+E4SBNVIW5XmpZwYEphITuszJIcW92pVIbDjqaLv/HdaU06Iowdj6ZHgEZN7EcLs
	 /XxWUGAh8JSaXFgiu/86EbdFVR5aOwetz+49qvLD7+Kkx47nfNkmIUFw3Ycsj2DYj1
	 tkVHDX4gPEz3GbXyHb1F1z4B2RfzuHn3LDhMqJkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/568] wifi: ath12k: Correct 6 GHz frequency value in rx status
Date: Tue, 30 Jul 2024 17:43:38 +0200
Message-ID: <20240730151644.214516728@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>

[ Upstream commit c3c84a74bd797f76d7da036c9fef947d674bbc18 ]

The frequency in the rx status is currently being filled
incorrectly for the 6 GHz band. The channel number received is
invalid in this case, resulting in packet drops. Fix this
issue by correcting the frequency calculation.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240508173655.22191-3-quic_pradeepc@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c |  9 ++++++---
 drivers/net/wireless/ath/ath12k/wmi.c   | 10 +++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index dbcbe7e0cd2a7..a2d1ee1d51884 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2376,8 +2376,10 @@ void ath12k_dp_rx_h_ppdu(struct ath12k *ar, struct hal_rx_desc *rx_desc,
 	channel_num = meta_data;
 	center_freq = meta_data >> 16;
 
-	if (center_freq >= 5935 && center_freq <= 7105) {
+	if (center_freq >= ATH12K_MIN_6G_FREQ &&
+	    center_freq <= ATH12K_MAX_6G_FREQ) {
 		rx_status->band = NL80211_BAND_6GHZ;
+		rx_status->freq = center_freq;
 	} else if (channel_num >= 1 && channel_num <= 14) {
 		rx_status->band = NL80211_BAND_2GHZ;
 	} else if (channel_num >= 36 && channel_num <= 173) {
@@ -2395,8 +2397,9 @@ void ath12k_dp_rx_h_ppdu(struct ath12k *ar, struct hal_rx_desc *rx_desc,
 				rx_desc, sizeof(*rx_desc));
 	}
 
-	rx_status->freq = ieee80211_channel_to_frequency(channel_num,
-							 rx_status->band);
+	if (rx_status->band != NL80211_BAND_6GHZ)
+		rx_status->freq = ieee80211_channel_to_frequency(channel_num,
+								 rx_status->band);
 
 	ath12k_dp_rx_h_rate(ar, rx_desc, rx_status);
 }
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index cd89032fa25e1..21399ad233c02 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -5772,8 +5772,10 @@ static void ath12k_mgmt_rx_event(struct ath12k_base *ab, struct sk_buff *skb)
 	if (rx_ev.status & WMI_RX_STATUS_ERR_MIC)
 		status->flag |= RX_FLAG_MMIC_ERROR;
 
-	if (rx_ev.chan_freq >= ATH12K_MIN_6G_FREQ) {
+	if (rx_ev.chan_freq >= ATH12K_MIN_6G_FREQ &&
+	    rx_ev.chan_freq <= ATH12K_MAX_6G_FREQ) {
 		status->band = NL80211_BAND_6GHZ;
+		status->freq = rx_ev.chan_freq;
 	} else if (rx_ev.channel >= 1 && rx_ev.channel <= 14) {
 		status->band = NL80211_BAND_2GHZ;
 	} else if (rx_ev.channel >= 36 && rx_ev.channel <= ATH12K_MAX_5G_CHAN) {
@@ -5794,8 +5796,10 @@ static void ath12k_mgmt_rx_event(struct ath12k_base *ab, struct sk_buff *skb)
 
 	sband = &ar->mac.sbands[status->band];
 
-	status->freq = ieee80211_channel_to_frequency(rx_ev.channel,
-						      status->band);
+	if (status->band != NL80211_BAND_6GHZ)
+		status->freq = ieee80211_channel_to_frequency(rx_ev.channel,
+							      status->band);
+
 	status->signal = rx_ev.snr + ATH12K_DEFAULT_NOISE_FLOOR;
 	status->rate_idx = ath12k_mac_bitrate_to_idx(sband, rx_ev.rate / 100);
 
-- 
2.43.0



