Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CB88F54;
	Mon, 13 Oct 2025 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369853; cv=none; b=NusiIlTQe7fq/nAq4bZ+MmAjs1nOe0O4XYFTp0rnGe/meykDjwzw5TnES09xKrHf7KV95ZktSMtpiSHrhp1FTR8tAx2j96uPM1aFe4ETl/cC9tkE+4xY5/Pw5fLLPHMB+gFGrNUciId/AGka1b+4Yi1aIVdcsJOYgKokh9qoJ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369853; c=relaxed/simple;
	bh=E6q3H2YJOp1Nr5+gl+DrvlvL6wan9JJWSAjBhu9Y4g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q73xd3Y+ESELlV1n2xwQb+nwGBfyTIDd5NCQ0dB/Ha8lOd512QNdwfAFFq4TEJ3CDPEaOOXajfQs57ylmz+Hfamz5y2SDXnI+ZBCXa67lMBGWAeDgaT62sYNN5soiOBJCiwtWTvd0mWyqCWRQPxQuTQuxe9XFdYaZ3/916ya1ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKwROPT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKwROPT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B00C4CEE7;
	Mon, 13 Oct 2025 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369853;
	bh=E6q3H2YJOp1Nr5+gl+DrvlvL6wan9JJWSAjBhu9Y4g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKwROPT3UC07cYQtCb3Hdtc1BTqxl+QWMxUZEoavteQQHS5phxYwCzF6Hb8IVC1jM
	 d0GMPFE4cURbnupMS7JbmIGjZcyXOQ68jY6HRaLEyhPqZcDT06b0RcE8GKsJaCRbZC
	 cPih98I1xK1bo+bNQrl5q3xTM0X0HdujTNm6jOL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 392/563] wifi: ath12k: fix signal in radiotap for WCN7850
Date: Mon, 13 Oct 2025 16:44:13 +0200
Message-ID: <20251013144425.485056094@linuxfoundation.org>
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

[ Upstream commit cf412ae7b7124e2b3bfe472616ec24b117b6008a ]

Currently host will add ATH12K_DEFAULT_NOISE_FLOOR to rssi_comb to
convert RSSI from dB to dBm.

For WCN7850, this conversion is unnecessary because the RSSI value is
already reported in dBm units.

No longer convert for those firmware that already support dBM conversion.

This patch won't affect QCN chips.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250722095934.67-2-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 8189e52ed0071..ec1587d0b917c 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2154,8 +2154,12 @@ static void ath12k_dp_mon_update_radiotap(struct ath12k *ar,
 	spin_unlock_bh(&ar->data_lock);
 
 	rxs->flag |= RX_FLAG_MACTIME_START;
-	rxs->signal = ppduinfo->rssi_comb + noise_floor;
 	rxs->nss = ppduinfo->nss + 1;
+	if (test_bit(WMI_TLV_SERVICE_HW_DB2DBM_CONVERSION_SUPPORT,
+		     ar->ab->wmi_ab.svc_map))
+		rxs->signal = ppduinfo->rssi_comb;
+	else
+		rxs->signal = ppduinfo->rssi_comb + noise_floor;
 
 	if (ppduinfo->userstats[ppduinfo->userid].ampdu_present) {
 		rxs->flag |= RX_FLAG_AMPDU_DETAILS;
-- 
2.51.0



