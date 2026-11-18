Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015853;
	b=hGY6QOMIyVW02c/x1uUJh8zP/sUN4cYF5NpNq00t1ghapoyMhDylW2YicbeZeJ2huRe0
	 misKOP48ajCbJzLQrB/DQF28OhcirxtyLe+Dhg5PFuZc2KuuU6oviIubyW3tltB2Qy1jv
	 b4BdWDojvhOMA7+8N/F7shebUSGJVctD543j+9UE5ekPzMeuVFVSNBboNtagawk3FNHcC
	 z0g8hRlp5P4VAdUEAA6BwZvmKr5tdoLn6edHWaadQfg5fs2l/p+f2X7yJrpHE/YjLPAHM
	 hKaVrQQip1zL0vaEu/xYnbZz9NZgfw9htGVptrQW+Ou9uYPhT3wDTCsQGTEGncKg3zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgJVB9A5zUIg55IjHIIdDhRQiA1GvcZ1nnL0+HxCKrw=;
	b=DXHRxfmYkylqQ+7hvIhPKP+Mt3Sv88swZbY/JJYkDpwBDtgkhZPLAzbGHBgvG2Kd3hiN
	 zbM6I63GO8anA69tKcFbfWU14QnGdIgNpN8YpT/auOv0Lbu6wquLCAQOt0y7fP5wvroHI
	 FnmQigu6XCmgncs7Km/ExFn5xCRvuWu9rYfshY2EV908DWyP8yUmPyd3YlfBMigDhN0zw
	 Gj8esHmatcF1WgZE2MFDDav9hg787K1GcJgTwZgtYr21kyafm2pqKZOfnKWsyhgeGquXG
	 Q4b8tg8py5BFX7cLTymq2w4c4qj2tDD1KGSFPK+zIUGcRGUxTNuThZORg0dNX4dsv/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtPpT7oe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C6460A2600;
	Wed, 18 Nov 2026 15:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtPpT7oe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013821F000C5;
	Wed, 18 Nov 2026 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015853;
	bh=sgJVB9A5zUIg55IjHIIdDhRQiA1GvcZ1nnL0+HxCKrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtPpT7oeG2Ou/JeOlGPBuk1YsEzHdD5kAgSBvkPjK1rC4IwkwHdZMwuhhmxBR8TtS
	 QoEA1pEDZIwTw5+kg8FAEt6YxnbLqQlRrLWoeOfotwWTYIsXhOycU3vhoG//e5jTEb
	 myu4YpBsY1MammG8c1acBrQvY35YgR5jPQzuK0Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0321/2651] wifi: ath12k: preserve PPDU state across monitor status buffers
Date: Wed, 18 Nov 2026 15:26:01 +0100
Message-ID: <20261118150259.429239901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit 69b2d06dafa4a61b718704d655dd370ba660052a ]

A monitor PPDU may span multiple status buffers. However,
__ath12k_wifi7_dp_mon_process_ring() clears mon_ppdu_info before
processing every buffer.

As a result, continuation buffers lose PPDU state collected from
earlier buffers, including ppdu_id and PHY metadata.

This can cause monitor RX processing to fail when
ath12k_wifi7_dp_rx_mon_dest_process() observes a PPDU ID mismatch
between status and destination rings, preventing MSDUs from being
delivered. It can also produce incomplete EHT metadata that triggers
warnings from mac80211:
	Rate marked as an EHT rate but data is invalid: MCS:0, NSS:0

ath12k_wifi7_dp_mon_srng_process() already tracks status TLV
continuations via ppdu_continuation. Apply the same logic here and
only reinitialize mon_ppdu_info when starting a new PPDU.

mon_ppdu_info persists across ar->monitor_started transitions. If
monitor mode stops while a PPDU is mid-continuation, ppdu_continuation
stays set and could leak into the next monitor session. Reset it
when monitor mode starts.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 78d3d907d0f1 ("wifi: ath12k: add support to reap and process monitor status ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Link: https://patch.msgid.link/20260828065534.1537-1-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c         |  7 ++++++
 .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 23 +++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index a997e888feb56..815be25b33c4a 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1506,6 +1506,13 @@ static int ath12k_mac_monitor_start(struct ath12k *ar)
 		return ret;
 	}
 
+	/*
+	 * A previous monitor session may have stopped mid-PPDU, leaving
+	 * ppdu_continuation set. Clear it so the first status buffer of
+	 * this session is not merged with stale state from before.
+	 */
+	ar->dp.mon_data.mon_ppdu_info.ppdu_continuation = false;
+
 	ar->monitor_started = true;
 	ar->num_started_vdevs++;
 
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 016b0c38e51e2..ded7d56cd79b0 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -3211,18 +3211,23 @@ __ath12k_wifi7_dp_mon_process_ring(struct ath12k *ar, int mac_id,
 		goto exit;
 
 	while ((skb = __skb_dequeue(&skb_list))) {
-		memset(ppdu_info, 0, sizeof(*ppdu_info));
-		ppdu_info->peer_id = HAL_INVALID_PEERID;
+		if (!ppdu_info->ppdu_continuation)
+			ath12k_wifi7_dp_mon_rx_memset_ppdu_info(ppdu_info);
 
 		hal_status = ath12k_wifi7_dp_mon_parse_rx_dest(&ar->dp, pmon, skb);
 
-		if (ar->monitor_started &&
-		    pmon->mon_ppdu_status == DP_PPDU_STATUS_START &&
-		    hal_status == HAL_TLV_STATUS_PPDU_DONE) {
-			rx_mon_stats->status_ppdu_done++;
-			pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
-			ath12k_wifi7_dp_rx_mon_dest_process(ar, mac_id, *budget, napi);
-			pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
+		if (hal_status == HAL_TLV_STATUS_PPDU_DONE) {
+			ppdu_info->ppdu_continuation = false;
+			if (ar->monitor_started &&
+			    pmon->mon_ppdu_status == DP_PPDU_STATUS_START) {
+				rx_mon_stats->status_ppdu_done++;
+				pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
+				ath12k_wifi7_dp_rx_mon_dest_process(ar, mac_id,
+								    *budget, napi);
+				pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
+			}
+		} else {
+			ppdu_info->ppdu_continuation = true;
 		}
 
 		dev_kfree_skb_any(skb);
-- 
2.53.0



