Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170842F5E;
	Tue, 12 Aug 2025 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023923; cv=none; b=DPB7VPX/z/TDCOxfwcRPeiLX3PydXw0KP39kzYkssTYyC8yM3M9wHZzQhJMm7vdC9myhUS5w5yxtKZXVu1DHKEzc9VJye/Jbguh6FkoGdKEeRgD2amn6KmMmuxR80hSxvghw6dGv28IKubnfmn/TU9LKYfc+lvUYgBiUBgWMjrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023923; c=relaxed/simple;
	bh=JOBSHtg74LFGLT0EzlADvK2tLLfszUYLIl/5GpRLlQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5xTxfNeEHEN+YQEPC95vwrJuB6ehdZVjTYx+zUAxIfa/Jmc7DpR1dTYBoXmZymhCWXqtcLDF9DgiLxNZ48q7CU5PRkY/z432RdOwPkEKGf030XbgwEPbErWoLz/U5QiHlSqWVqcnWXP+0c13pFoof6MY1H1gzfWgTz7pEprZd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xb+a5b/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xb+a5b/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728BCC4CEF0;
	Tue, 12 Aug 2025 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023922;
	bh=JOBSHtg74LFGLT0EzlADvK2tLLfszUYLIl/5GpRLlQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xb+a5b/eqaMC8FpFkTkk+iwwACw2WldCcNuY4G9jwv5+7AnQrZJOahJSGI6A+Ofjr
	 cIlvnQ3duXhAOpBx0pli51PyvDzenttmYS3HSLwll79luDDb/aLyV3H1brn8AHA65N
	 1ezypNL2ACzcX9W5rlcXpFRUOpncIpe1dvhIbzTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshitha Prem <quic_hprem@quicinc.com>,
	Amith A <quic_amitajit@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 204/627] wifi: ath12k: update unsupported bandwidth flags in reg rules
Date: Tue, 12 Aug 2025 19:28:19 +0200
Message-ID: <20250812173427.045175625@linuxfoundation.org>
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

From: Harshitha Prem <quic_hprem@quicinc.com>

[ Upstream commit 2109e98503bc1c01c399feac68cc8b7faf6d0a4a ]

The maximum bandwidth an interface can operate in is defined by the
configured country. However, currently, it is able to operate in
bandwidths greater than the allowed bandwidth. For example,
the Central African Republic (CF) supports a maximum bandwidth of 40 MHz
in both the 2 GHz and 5 GHz bands, but an interface is still able to
operate in bandwidths higher than 40 MHz. This issue arises because the
regulatory rules in the regd are not updated with these restrictions
received from firmware on the maximum bandwidth.

Hence, update the regulatory rules with unsupported bandwidth flags based
on the maximum bandwidth to ensure compliance with country-specific
regulations.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Harshitha Prem <quic_hprem@quicinc.com>
Signed-off-by: Amith A <quic_amitajit@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250701135902.722851-1-quic_amitajit@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/reg.c | 31 ++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
index 0fc7f209956d..743552abf149 100644
--- a/drivers/net/wireless/ath/ath12k/reg.c
+++ b/drivers/net/wireless/ath/ath12k/reg.c
@@ -398,6 +398,29 @@ ath12k_map_fw_dfs_region(enum ath12k_dfs_region dfs_region)
 	}
 }
 
+static u32 ath12k_get_bw_reg_flags(u16 max_bw)
+{
+	switch (max_bw) {
+	case 20:
+		return NL80211_RRF_NO_HT40 |
+			NL80211_RRF_NO_80MHZ |
+			NL80211_RRF_NO_160MHZ |
+			NL80211_RRF_NO_320MHZ;
+	case 40:
+		return NL80211_RRF_NO_80MHZ |
+			NL80211_RRF_NO_160MHZ |
+			NL80211_RRF_NO_320MHZ;
+	case 80:
+		return NL80211_RRF_NO_160MHZ |
+			NL80211_RRF_NO_320MHZ;
+	case 160:
+		return NL80211_RRF_NO_320MHZ;
+	case 320:
+	default:
+		return 0;
+	}
+}
+
 static u32 ath12k_map_fw_reg_flags(u16 reg_flags)
 {
 	u32 flags = 0;
@@ -676,7 +699,7 @@ ath12k_reg_build_regd(struct ath12k_base *ab,
 			reg_rule = reg_info->reg_rules_2g_ptr + i;
 			max_bw = min_t(u16, reg_rule->max_bw,
 				       reg_info->max_bw_2g);
-			flags = 0;
+			flags = ath12k_get_bw_reg_flags(reg_info->max_bw_2g);
 			ath12k_reg_update_freq_range(&ab->reg_freq_2ghz, reg_rule);
 		} else if (reg_info->num_5g_reg_rules &&
 			   (j < reg_info->num_5g_reg_rules)) {
@@ -690,13 +713,15 @@ ath12k_reg_build_regd(struct ath12k_base *ab,
 			 * BW correction if required and applies flags as
 			 * per other BW rule flags we pass from here
 			 */
-			flags = NL80211_RRF_AUTO_BW;
+			flags = NL80211_RRF_AUTO_BW |
+				ath12k_get_bw_reg_flags(reg_info->max_bw_5g);
 			ath12k_reg_update_freq_range(&ab->reg_freq_5ghz, reg_rule);
 		} else if (reg_info->is_ext_reg_event && reg_6ghz_number &&
 			   (k < reg_6ghz_number)) {
 			reg_rule = reg_rule_6ghz + k++;
 			max_bw = min_t(u16, reg_rule->max_bw, max_bw_6ghz);
-			flags = NL80211_RRF_AUTO_BW;
+			flags = NL80211_RRF_AUTO_BW |
+				ath12k_get_bw_reg_flags(max_bw_6ghz);
 			if (reg_rule->psd_flag)
 				flags |= NL80211_RRF_PSD;
 			ath12k_reg_update_freq_range(&ab->reg_freq_6ghz, reg_rule);
-- 
2.39.5



