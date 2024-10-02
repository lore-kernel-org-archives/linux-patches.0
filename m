Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600F51D0797;
	Wed,  2 Oct 2024 13:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877230; cv=none; b=pJFBn6fm8kn71DeDvn8Jo48lL3CDPvxFBwJSBg/jq/Yreibk8Zwt++PSTmHetqMzy4vwtngsWWKR1opjMcX7jfwEFp/LcS2IECE0h/c7Fdd63ucMgJuDOX8KoG3N1WlguOLyO65rVY63snAhqL9skrS7q0HQ2MMgODhMnKoRgVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877230; c=relaxed/simple;
	bh=IH5G0wn9ZO6+ijL3Dq0MgqENY2KpvChGd/SY3khDeYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngJOrpX35G/uPXiaSm5y0O47v4lhWz2d5Byezx6BmliWr2Y06PmmGYjr29ADEeTk8u7baa31X2aNcq7xGRV/GrUr8bJFVz/wPSp0IIsLtKA3c6LOLZAvdhzs0R8THhVgbL1OI1Ie0Q86ESHZMtm+cKzX4oSu5OKNDFpoB3s+1T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WESxv3qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WESxv3qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C02C4CED5;
	Wed,  2 Oct 2024 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877230;
	bh=IH5G0wn9ZO6+ijL3Dq0MgqENY2KpvChGd/SY3khDeYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WESxv3qwZ9Ak1x346GcrW7TW+zNYbL8cpR23I61O2x2AYIA6xyPbsC092CIgdN3QB
	 Vpq+V8R0LI37tUP7IoNySQeiFzR0dL0IlG5ar3747DrkiISfaRhPa/q78NZbxHKH0c
	 BMENHItW5sFN4gQBfg+v5WbUlEaBV2c1B83XLFWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 013/634] wifi: ath12k: match WMI BSS chan info structure with firmware definition
Date: Wed,  2 Oct 2024 14:51:53 +0200
Message-ID: <20241002125811.617331543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit dd98d54db29fb553839f43ade5f547baa93392c8 ]

struct wmi_pdev_bss_chan_info_event is not similar to the firmware
struct definition, this will cause some random failures.

Fix by matching the struct wmi_pdev_bss_chan_info_event with the
firmware structure definition.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240331183232.2158756-3-quic_kathirve@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index e26fe504ce28b..e947d646353c3 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -4054,7 +4054,6 @@ struct wmi_vdev_stopped_event {
 } __packed;
 
 struct wmi_pdev_bss_chan_info_event {
-	__le32 pdev_id;
 	__le32 freq;	/* Units in MHz */
 	__le32 noise_floor;	/* units are dBm */
 	/* rx clear - how often the channel was unused */
@@ -4072,6 +4071,7 @@ struct wmi_pdev_bss_chan_info_event {
 	/*rx_cycle cnt for my bss in 64bits format */
 	__le32 rx_bss_cycle_count_low;
 	__le32 rx_bss_cycle_count_high;
+	__le32 pdev_id;
 } __packed;
 
 #define WMI_VDEV_INSTALL_KEY_COMPL_STATUS_SUCCESS 0
-- 
2.43.0



