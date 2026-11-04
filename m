Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826875;
	b=Cvkvs9ZpEts8iUpoK7f2nZzQWQXzLc8DhD5yxXNOzEbeHqJ9ZSGv9R8A6pUfRq+zYACc
	 0sq/mWdcyt4rwIW9F502qmAmTVfa6xeJxmMyWIu/xXDUnnMqUFs8WZRtGHQ7EShJ/UWlL
	 jcuWM3Io/uLUJoXGcj6lu0tWGH7L5Cl8kEG61WMot4941pkDzVD+a2OqoPcelxsuasMj6
	 NfyaY+ZXzGUPZdp7fchaKZXIkQN3jqmVenP6hpU8+9zXXPhzCYPcYWBROBhxjQcrjvUXm
	 KsVX8nzMnUXU+ou1D1B/ON1FC1FRfnL7sB9ZSEWA7UlELIGfblGQmK76NlUqGEZsB4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=crukz6ftDEex0HrsKotrYr5TwY10va/vrFLJ6iozd7w=;
	b=QA07gsiId4jZoo65tWpl2z7aZsHQ1KVajtaWhqb4FVR8rD+VKPAjX5dWcweXWii3uq0i
	 IXiOkOeGCdb/OUNkHQsLDg8ab0vc4NHIxoP1/kw5hItWmr5xyzgq27PJi7YoiP8G/7urY
	 pypdPXNHthwdoRxexAJG0U5EAQhVri2oAzwggDtGMVTV5YTyw0tmrqWnpWkHtyDZvGmXj
	 +fwIHs2wvlT7QhLdg/kDlVCUdlS55yR/CCIbPObWYLah7lHadH2FLxNihnMRL3JFUAHVe
	 SLVOhkPz2Ti8pcvjTBw3DxyMzmVdjnq0B1AYPCzhrhdPDzYpeTEtrnpCD+V32E/9Sew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GosqbJeX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310616072669;
	Wed,  4 Nov 2026 21:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GosqbJeX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98CF1F000C1;
	Wed,  4 Nov 2026 21:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826875;
	bh=crukz6ftDEex0HrsKotrYr5TwY10va/vrFLJ6iozd7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GosqbJeXzrRqGGIrromZvFRpUpWxFoXpp93+0C5EvChIfffiHXBzrntEGj85EN/MB
	 hMSi2nJKy3yjDeNroiqDnFRTCX7B/Sn6iCsGOUD8e0w9FYibbwLKH/XZ3+US/0O4Dq
	 vlrcaYq9FsH0Fj/KABIkqWU0eh24fmrCRTFtPB2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 014/547] wifi: ath12k: Make RXDMA buffer ring size configurable per memory profile
Date: Wed,  4 Nov 2026 16:03:18 -0500
Message-ID: <20261104211038.784783485@linuxfoundation.org>
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

[ Upstream commit 643f0bf936176c114d5631da7547e991b5d99f10 ]

Currently, the RXDMA buffer ring size is hardcoded to 4096 and shared
across all memory profiles. This prevents individual profiles from tuning
the ring size based on their memory and performance requirements.

Add the RXDMA buffer ring size to the memory profile configuration and
implement ath12k_dp_rxdma_buf_ring_size() static inline function to
access the configured value. This allows different memory profiles to
select an appropriate ring size based on available system resources.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261007-mpp_ws-v1-1-739b1fb87d24@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c  | 2 ++
 drivers/net/wireless/ath/ath12k/dp.h    | 8 +++++++-
 drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index b0107cde99ff3..a4e4abfb46e60 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -54,6 +54,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.num_pool_tx_desc = 32768,
 			.rx_desc_count = 12288,
 			.rx_release_ring_size = 16384,
+			.rxdma_buf_ring_size = 4096,
 		},
 	},
 [ATH12K_QMI_MEMORY_MODE_LOW_512_M] = {
@@ -68,6 +69,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.num_pool_tx_desc = 16384,
 			.rx_desc_count = 6144,
 			.rx_release_ring_size = 8192,
+			.rxdma_buf_ring_size = 4096,
 		},
 	},
 };
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index ff62773cfa9ab..842d8cdbaeb55 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -30,6 +30,7 @@ struct ath12k_dp_profile_params {
 	u32 num_pool_tx_desc;
 	u32 rx_desc_count;
 	u32 rx_release_ring_size;
+	u32 rxdma_buf_ring_size;
 };
 
 #define DP_MON_PURGE_TIMEOUT_MS     100
@@ -209,7 +210,6 @@ struct ath12k_pdev_dp {
 #define DP_REO_EXCEPTION_RING_SIZE	128
 #define DP_REO_CMD_RING_SIZE		256
 #define DP_REO_STATUS_RING_SIZE		2048
-#define DP_RXDMA_BUF_RING_SIZE		4096
 #define DP_RX_MAC_BUF_RING_SIZE		4096
 #define DP_RXDMA_REFILL_RING_SIZE	2048
 #define DP_RXDMA_ERR_DST_RING_SIZE	1024
@@ -720,6 +720,12 @@ ath12k_dp_rx_release_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->rx_release_ring_size;
 }
 
+static inline u32
+ath12k_dp_rxdma_buf_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->rxdma_buf_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 31e7d47f77341..3628344f3593c 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1708,7 +1708,7 @@ int ath12k_dp_rx_alloc(struct ath12k_base *ab)
 	ret = ath12k_dp_srng_setup(ab,
 				   &dp->rx_refill_buf_ring.refill_buf_ring,
 				   HAL_RXDMA_BUF, 0, 0,
-				   DP_RXDMA_BUF_RING_SIZE);
+				   ath12k_dp_rxdma_buf_ring_size(dp_params));
 	if (ret) {
 		ath12k_warn(ab, "failed to setup rx_refill_buf_ring\n");
 		return ret;
-- 
2.53.0



