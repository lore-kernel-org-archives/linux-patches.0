Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826783;
	b=o6iKEuMu/m6Mw8wQc9AvxzGfj9ibJqxY2k4W41LIEk7aYm4668R+nw1hCYAon7qgLeny
	 GPqgH5zy4PiH1vDGV0X6ab1VT0QfSidZy0F3QDKnxkyo0dRYFahQI/THxOgH/TMLwofaB
	 tTs0qAKFISy/ZMUuSx3BG7tNBSBz+lv+hoVf1dtBnD8aiWt7X3vcOOF2FHOz4xNa5TVND
	 CXFAvEObrGbGCqi1Nky22hpKFM1bFt4pyDNQ0/RmJ9l8IxiGrKkwM9f7bOY86bbh3Kj9v
	 UMLZHYUkmt1wpYDE5whQwopvPblWHDzCXAAci8IUQ/yYv/1RI2sgQ3Rls8yEk4Lvr8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPn6MW2O/9yuqznaM+EZagORgSPJ1JfFLIvuU/c9y2w=;
	b=Oi2Hw08An6KcRPlcrMlOwO5DJRsFD9hU4F6tMvMfcy+pj7vtDBWZOW4GDkI8zsd2T1Gg
	 Fo7JNcWkodgI8zKQarMKMR4joOAx5CniXjJo+WCHvWK8/iStF+lUXZNnognylrP4ZVlSh
	 Mqa+w/xAJvwzUjV35Z/6BZ1EYPF3qgDdeoWDUEAkhNreG6VlG/GeWUgEkUJEF6YCW6NmB
	 tQN2NcuZ+il9plFrSYnXxwY9c5fd/fquNctQ3qz/UIHJVS3C0/66Oi0btz6Cmcq07fFg3
	 wBf/3IpurqHB1LRKBJM+GoHRefwTIZbj0S/8QcrZbmLMiA8Ed+OHXK8rfNPAqnG5kAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMq+20O5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B3F6071A0B;
	Wed,  4 Nov 2026 21:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMq+20O5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68451F00A16;
	Wed,  4 Nov 2026 21:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826783;
	bh=HPn6MW2O/9yuqznaM+EZagORgSPJ1JfFLIvuU/c9y2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMq+20O5+aVrbtB+eM0LZp10kfVsJekwbMluPfPWhcpSwZHXCPaEJUX2LkfMlmqPt
	 mFimxVFmLbxF/XoTEUdqyvQlY/U2QROl4rqDdGaSNGmd+9EmowIhwNyWowiXtdOQYL
	 vVWf/t2PXXXOkJh8q4MHNy6q/7CJmtADU5C4m9VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 010/547] wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
Date: Wed,  4 Nov 2026 16:03:14 -0500
Message-ID: <20261104211038.677608694@linuxfoundation.org>
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

[ Upstream commit 62e2758d17d307753457bd51af074be5f8265c03 ]

Replace DP_RXDMA_MONITOR_DST_RING_SIZE macro with
ath12k_dp_rxdma_monitor_dst_ring_size() static inline helper.

Pass the DP profile parameters explicitly to improve type safety and
make the interface explicit.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260820054804.3222296-5-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.h    | 8 ++++++--
 drivers/net/wireless/ath/ath12k/dp_rx.c | 8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 9081655eae77e..a7cd2535866bd 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -216,8 +216,6 @@ struct ath12k_pdev_dp {
 #define DP_RXDMA_REFILL_RING_SIZE	2048
 #define DP_RXDMA_ERR_DST_RING_SIZE	1024
 #define DP_RXDMA_MON_STATUS_RING_SIZE	1024
-#define DP_RXDMA_MONITOR_DST_RING_SIZE(ab) \
-	((ab)->profile_param->dp_params.rxdma_monitor_dst_ring_size)
 #define DP_RXDMA_MONITOR_DESC_RING_SIZE	4096
 #define DP_TX_MONITOR_BUF_RING_SIZE	4096
 #define DP_TX_MONITOR_DEST_RING_SIZE	2048
@@ -696,6 +694,12 @@ ath12k_dp_rxdma_monitor_buf_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->rxdma_monitor_buf_ring_size;
 }
 
+static inline u32
+ath12k_dp_rxdma_monitor_dst_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->rxdma_monitor_dst_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index efc419d41d210..31e7d47f77341 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -330,16 +330,20 @@ static int ath12k_dp_rx_pdev_srng_alloc(struct ath12k *ar)
 {
 	struct ath12k_pdev_dp *dp = &ar->dp;
 	struct ath12k_base *ab = ar->ab;
+	u32 monitor_dst_ring_size;
+	u32 mac_id = dp->mac_id;
 	int i;
 	int ret;
-	u32 mac_id = dp->mac_id;
+
+	monitor_dst_ring_size =
+		ath12k_dp_rxdma_monitor_dst_ring_size(&ab->profile_param->dp_params);
 
 	for (i = 0; i < ab->hw_params->num_rxdma_per_pdev; i++) {
 		ret = ath12k_dp_srng_setup(ar->ab,
 					   &dp->rxdma_mon_dst_ring[i],
 					   HAL_RXDMA_MONITOR_DST,
 					   0, mac_id + i,
-					   DP_RXDMA_MONITOR_DST_RING_SIZE(ab));
+					   monitor_dst_ring_size);
 		if (ret) {
 			ath12k_warn(ar->ab,
 				    "failed to setup HAL_RXDMA_MONITOR_DST\n");
-- 
2.53.0



