Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB7E1E5206;
	Mon, 23 Jun 2025 21:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715341; cv=none; b=KKxVyKxfr2nxfQUgC9JQggUo15POm4uLiEyVWNQDAbDWXqrgAnRGpaSr8tkPtJ3nciFeU0htDoUkaE33DZi9eP19kJcA5ThGaN023jIUR9gULn1r2mseaWdmaBMHbLbVLlVJiSzyZDMmPBXoafiZ+UEDuGt6VvdsQpe3FWiQJOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715341; c=relaxed/simple;
	bh=jVo35ozL7J+SSPglZkDvFBiBwtCtrqqLQ/R6GaMSUAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQ9WYqF2V2B/TPHmQyAJ0+xivLPGk9BTvhLXA897rpiuRtAsdYmJAlxuWyVw35btNtiednWc/5v7dLXE3uJ+lkvSRjjp0RNa8vlTtgN6LiFrVCsiqxqpQX+2Pklvd6D1bQQFkDkJ2BBZE6GQBUggpH651LJMgoRl9Au0VdnDeyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfzQjJZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfzQjJZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A48CC4CEEA;
	Mon, 23 Jun 2025 21:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715341;
	bh=jVo35ozL7J+SSPglZkDvFBiBwtCtrqqLQ/R6GaMSUAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfzQjJZ76MMkDvzIkWNaj7OVX2gr5PfGex37s0Vj2DMp0+/t5Tqs9z+t2qq26MRhx
	 PxTfFCBLNaN/XbzArek1bcYAr29NixiNwWukemNLrDEwy+67QN9OAafw0TvkRxpgPG
	 8c0mQIh7Ccn2k+QJ4eu6uoqyuHZRTAErCb/G2sRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj P Kizhakkethil <quic_surapk@quicinc.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/290] wifi: ath12k: Pass correct values of center freq1 and center freq2 for 160 MHz
Date: Mon, 23 Jun 2025 15:07:34 +0200
Message-ID: <20250623130632.662528414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj P Kizhakkethil <quic_surapk@quicinc.com>

[ Upstream commit b1b01e46a3db5ad44d1e4691ba37c1e0832cd5cf ]

Currently, for 160 MHz bandwidth, center frequency1 and
center frequency2 are not passed correctly to the firmware.
Set center frequency1 as the center frequency
of the primary 80 MHz channel segment and center frequency2 as
the center frequency of the 160 MHz channel and pass the values
to the firmware.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1

Signed-off-by: Suraj P Kizhakkethil <quic_surapk@quicinc.com>
Reviewed-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250304095315.3050325-2-quic_surapk@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 31af940bc5722..958ac4ed5c349 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -951,14 +951,24 @@ int ath12k_wmi_vdev_down(struct ath12k *ar, u8 vdev_id)
 static void ath12k_wmi_put_wmi_channel(struct ath12k_wmi_channel_params *chan,
 				       struct wmi_vdev_start_req_arg *arg)
 {
+	u32 center_freq1 = arg->band_center_freq1;
+
 	memset(chan, 0, sizeof(*chan));
 
 	chan->mhz = cpu_to_le32(arg->freq);
-	chan->band_center_freq1 = cpu_to_le32(arg->band_center_freq1);
-	if (arg->mode == MODE_11AC_VHT80_80)
+	chan->band_center_freq1 = cpu_to_le32(center_freq1);
+	if (arg->mode == MODE_11BE_EHT160) {
+		if (arg->freq > center_freq1)
+			chan->band_center_freq1 = cpu_to_le32(center_freq1 + 40);
+		else
+			chan->band_center_freq1 = cpu_to_le32(center_freq1 - 40);
+
+		chan->band_center_freq2 = cpu_to_le32(center_freq1);
+	} else if (arg->mode == MODE_11BE_EHT80_80) {
 		chan->band_center_freq2 = cpu_to_le32(arg->band_center_freq2);
-	else
+	} else {
 		chan->band_center_freq2 = 0;
+	}
 
 	chan->info |= le32_encode_bits(arg->mode, WMI_CHAN_INFO_MODE);
 	if (arg->passive)
-- 
2.39.5



