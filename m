Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826785;
	b=tOYQbX3xVpH7EmrhVCobl3+WCwg7KpQxt7QRxm1fXSUo6qkLtC/Pec411zquOwYcTokw
	 /PLrqnot2EXvCD/e66GoyDIVt9ac0sqESya2xIdLtiALb3vog46z+TGwo8fJ10T1bW01S
	 qHYtFT2AzOHRwTHct3FRgRdiU7d3dMXuBDlhlUiLaBX8w7nZu/hj5/CnSJS4ypJZv4NBd
	 UdkZmRAYmMI2uU11uHOXtRa1qQijEwoaObegz5X/ymdoAlG4+z2l/sCsrMFukcuOlKDA5
	 FrNKZDzk/5Q26gxva86OU3SWQSk+2upsj7h7coOP9efVP2yG8/s568M2qBf1FIrURWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3G0i3HttT7GIGvSXDzvEWbdQoidQDV0qzb18AHasU90=;
	b=mYJQoaYMaGAochYpbctZxY8tOT+I/B2UkScGNtQdu3qjFIcaliR0TxwhXjPXCi82YGLv
	 c4KCZp/jvwLpOZj8PNjyi4yYY+93khlAGY2IVd+pwJF65mW/VWzWaHW4A0RHvsByUV53g
	 AwrvwOBx2e4yChFc3ls6ChZ/vb9tJAjfqbU9QSvSSpHOwbmn5tnVTxzmzoSIx1/7SjE4m
	 GJjAlYkvcf8yBljRZ3LfQ3eNhSIzS5o+YLJO3qL3tYIFCCvrTL1M65HVMhWq2z3TdXL2i
	 TtgG/SvxNkHdkBIb/o/iQg5JW6WcClYtuCOeK+5RcaYPi5yxj9BLUfOU6Oc57YD2TmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ioy7Hp+A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE1C6071A07;
	Wed,  4 Nov 2026 21:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ioy7Hp+A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5361F00A02;
	Wed,  4 Nov 2026 21:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826784;
	bh=3G0i3HttT7GIGvSXDzvEWbdQoidQDV0qzb18AHasU90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ioy7Hp+AB4Gl929Bzu2HyIL1iM9Ec+apNLXBLb+V7mGVD3agPoiieYo3HM3D2x2Kg
	 BlXPBSB+NYOg6n0ky5iCBrX0g8iVdfj6x3SBjgq4Zbd3N37FGLGChmdLmO773aJTZV
	 p6xSFWsrEFJWYX3SI19LTNsF9O2t8XULgrs3uH40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 007/547] wifi: ath12k: move dp_profile_params to dp.h
Date: Wed,  4 Nov 2026 16:03:11 -0500
Message-ID: <20261104211038.600583974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit bf7c19e231e2f48cafddbe3f4c2a2f5b6184b55f ]

Move struct ath12k_dp_profile_params from core.h to dp.h as it is
specifically used for Data Path operations. This improves code
organization by keeping DP-related structures in the DP header.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260820054804.3222296-2-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.h | 9 ---------
 drivers/net/wireless/ath/ath12k/dp.h   | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 93fd227b4d198..99d71dab7c04c 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -927,15 +927,6 @@ struct ath12k_wsi_info {
 	u32 hw_link_id_base;
 };
 
-struct ath12k_dp_profile_params {
-	u32 tx_comp_ring_size;
-	u32 rxdma_monitor_buf_ring_size;
-	u32 rxdma_monitor_dst_ring_size;
-	u32 num_pool_tx_desc;
-	u32 rx_desc_count;
-	u32 rx_release_ring_size;
-};
-
 struct ath12k_mem_profile_based_param {
 	u32 num_vdevs;
 	u32 max_client_single;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index bef0f2ba0560f..72d3de2db5d8e 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -23,6 +23,15 @@ struct ath12k_ext_irq_grp;
 struct ath12k_dp_rx_tid;
 struct ath12k_dp_rx_tid_rxq;
 
+struct ath12k_dp_profile_params {
+	u32 tx_comp_ring_size;
+	u32 rxdma_monitor_buf_ring_size;
+	u32 rxdma_monitor_dst_ring_size;
+	u32 num_pool_tx_desc;
+	u32 rx_desc_count;
+	u32 rx_release_ring_size;
+};
+
 #define DP_MON_PURGE_TIMEOUT_MS     100
 #define DP_MON_SERVICE_BUDGET       128
 
-- 
2.53.0



