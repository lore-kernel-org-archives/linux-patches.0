Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49D816F84F;
	Wed,  2 Oct 2024 13:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875301; cv=none; b=KGuiD3ptDd8sYLOIX2doLo4Ui3QRRRyM33VMXLIfGQ627Y/4Kq22almtcexs0qGTmjUndPVF61kgua8nRyFen3cjBm4smAv+fdGtRlZLlaX9PnWTGX6FNTREDNkvzQ1VqbiremnPR62M/dvn7j0DML2Tu0+9gYCudKVn+kZYJng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875301; c=relaxed/simple;
	bh=UvyU5MScQ2E/PfvTgH93QY5wzNNehZgE+pW5yaz7WSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Isvn7nmq18939bq77273H8CkmEGouhxSwOBjZ8uUsAQJltTW8BvI+4olSUyFD6bJw97JIPNfnsp0RYUSZwnxvYC5thZK5Pz+tGRoR64tl5dcUOs1jZ08K/yXZ1f37WI+KZ9GWz8CUxu6wcQl3Li8oOomKt7V/93puW2zSAdiwOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMU1sK1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMU1sK1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A287C4CEC5;
	Wed,  2 Oct 2024 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875300;
	bh=UvyU5MScQ2E/PfvTgH93QY5wzNNehZgE+pW5yaz7WSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMU1sK1uNm8AXR1TTbuwL0aq0PdgL8QtF58JwY28B8qGUj/Qneki+MtUArOQDSRvv
	 7OYEcaF/e+4hVd9bgBq0vQ/miTefACCP0sErRkdqyuH9zbPiWaqTKweW0tqeYzUJ1w
	 3QUyw2ud9fpGNudNN+JwlQ2xu7ybg3bvFZE01Vlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 014/695] wifi: ath12k: match WMI BSS chan info structure with firmware definition
Date: Wed,  2 Oct 2024 14:50:12 +0200
Message-ID: <20241002125823.059790696@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9f4c2f026b4c1..6a913f9b83158 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -4086,7 +4086,6 @@ struct wmi_vdev_stopped_event {
 } __packed;
 
 struct wmi_pdev_bss_chan_info_event {
-	__le32 pdev_id;
 	__le32 freq;	/* Units in MHz */
 	__le32 noise_floor;	/* units are dBm */
 	/* rx clear - how often the channel was unused */
@@ -4104,6 +4103,7 @@ struct wmi_pdev_bss_chan_info_event {
 	/*rx_cycle cnt for my bss in 64bits format */
 	__le32 rx_bss_cycle_count_low;
 	__le32 rx_bss_cycle_count_high;
+	__le32 pdev_id;
 } __packed;
 
 #define WMI_VDEV_INSTALL_KEY_COMPL_STATUS_SUCCESS 0
-- 
2.43.0



