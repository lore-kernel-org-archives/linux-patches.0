Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826782;
	b=TRg8iaq3JrvkpsFUI5t2iaN1d+clHz8Epp1cJzBgZKx7rf4+zWeyDtIg0KrwNYMtqjHh
	 S5u8r4K3QzK3lBg79fNn4e9LT+TuaCyax8AEethdDeM5sxmLtaWMcTa3/w4znuuc+hXUK
	 sbeW/AUkrgdE3U24AuWNkJ1gtKfn/A47FwRxpY2eg27/u6VMdpXZaKSVi5H7w6GBbFjX/
	 /4YfHjHe82OHHgwdfv3UQXx+XJEPE3OWm3+iFhQtj84BvieRNJm0Twbfbv5Q1qYrO8VGz
	 OfHiyWGh0dBgDrfr8jrKDKx9Cvuci3KPuW8sMSW8ROmco+zSoNqgDafTEn7jjZLeDGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1818rrR736d5bmU1SmG9J2CXGX8XeoJcaZnQztLvTkI=;
	b=BsS3BeQtMaBzv7CPP5883qAzk0QOpcdUi10UL/W64MS9ENskkjn+yLxlbhgaPt/0FJpN
	 hxfwoK8gVDysts84tNJ8S/woo0J605ojo486yTZMv7uvFYZG0ZaQfah3G9QnYPZ9F+6G8
	 kTyg/8Thnylvvybi3BSKlx9Hs98IOJJL8Heod5yChS+JDme7NUj8nn0eZ1sBrFoZD2u3X
	 WZOS7aNuD0mrfOkPjClm9n3902vHHN3JLZLkUF1/QB6Zl6dhwnSfJ1gPr9qsP9yY50vNS
	 4upJmHPjtfncbBhiJ95grysFX1gki8ZIZMe5iD6rseMBcLRhGP5g73WtZVoGNwx6l0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PoxvCera;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C816071A04;
	Wed,  4 Nov 2026 21:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PoxvCera
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313BD1F00A02;
	Wed,  4 Nov 2026 21:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826781;
	bh=1818rrR736d5bmU1SmG9J2CXGX8XeoJcaZnQztLvTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PoxvCeragv0/j8yDi1dp2yiDzLELJPhVpIDh/xv0YqYsTkyYluoM7qN3YViAkQY2n
	 lxvWEnYR4EVJQg9mxFeRsV8leJ7q3VgeTVm8Kodk3sGfY5CuNBo7InLtE2zUXRSUuI
	 D6jdIiLfr7uuvLXlK0Edz1Wl64cZJxwUd2kQ7PrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 009/547] wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
Date: Wed,  4 Nov 2026 16:03:13 -0500
Message-ID: <20261104211038.651685808@linuxfoundation.org>
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

[ Upstream commit d57f90669269fad2dd9ca98cd32b7412ceccb0b0 ]

Replace DP_RXDMA_MONITOR_BUF_RING_SIZE macro with
ath12k_dp_rxdma_monitor_buf_ring_size() static inline helper. Pass the DP
profile parameters explicitly to improve type safety and make the interface
explicit.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260820054804.3222296-4-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.h    | 8 ++++++--
 drivers/net/wireless/ath/ath12k/dp_rx.c | 4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 6540b3453cc69..9081655eae77e 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -216,8 +216,6 @@ struct ath12k_pdev_dp {
 #define DP_RXDMA_REFILL_RING_SIZE	2048
 #define DP_RXDMA_ERR_DST_RING_SIZE	1024
 #define DP_RXDMA_MON_STATUS_RING_SIZE	1024
-#define DP_RXDMA_MONITOR_BUF_RING_SIZE(ab) \
-	((ab)->profile_param->dp_params.rxdma_monitor_buf_ring_size)
 #define DP_RXDMA_MONITOR_DST_RING_SIZE(ab) \
 	((ab)->profile_param->dp_params.rxdma_monitor_dst_ring_size)
 #define DP_RXDMA_MONITOR_DESC_RING_SIZE	4096
@@ -692,6 +690,12 @@ ath12k_dp_tx_comp_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->tx_comp_ring_size;
 }
 
+static inline u32
+ath12k_dp_rxdma_monitor_buf_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->rxdma_monitor_buf_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b45316..efc419d41d210 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1692,6 +1692,8 @@ int ath12k_dp_rx_htt_setup(struct ath12k_base *ab)
 
 int ath12k_dp_rx_alloc(struct ath12k_base *ab)
 {
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
+	u32 monitor_buf_ring_size = ath12k_dp_rxdma_monitor_buf_ring_size(dp_params);
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	struct dp_srng *srng;
 	int i, ret;
@@ -1736,7 +1738,7 @@ int ath12k_dp_rx_alloc(struct ath12k_base *ab)
 		ret = ath12k_dp_srng_setup(ab,
 					   &dp->rxdma_mon_buf_ring.refill_buf_ring,
 					   HAL_RXDMA_MONITOR_BUF, 0, 0,
-					   DP_RXDMA_MONITOR_BUF_RING_SIZE(ab));
+					   monitor_buf_ring_size);
 		if (ret) {
 			ath12k_warn(ab, "failed to setup HAL_RXDMA_MONITOR_BUF\n");
 			return ret;
-- 
2.53.0



