Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622352;
	b=zoQYRw/8iHFziBrXHau9r/5Rjq6AGxyQcgSv3KQSBWndyOqnAXaix3qv2mapeEs2VjLM
	 2OBM8SdrTNckjjzbUPq0QYBkl0p9JLZVd8z+SkHHkN7ve3FhRnzBD2luFlYgEpxSHAqV7
	 RgRwuFEKfEirJPImQxj6AzxFVolVAyYs2n4uJKvCpjY8BkIWO/Ds5a1VZjiyH8FLI7UQV
	 w9GKw76+W71/EBBaeY4voJ2FMIub6H56SbUihAOZMyuZ9+mRg0DRR0xNxaDZ9F7hsSqBE
	 8+8tfc9VyXtd9RzsZO6DUmaBVjgCudDNQZdzL64KfaR76jk6fr1+H10PaChUDS7YrbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WjkorCGvLlnnDSjT5HxrhZ3j+0dJbdPJVBi+26fQpng=;
	b=qdly9D3RPSKFU0sjHE8Ar+k0081WS6+rEld90sUao/XEYoq2w814PolB0nLlOXFLDA7P
	 jwt4Kv9ebjoSgg5OA5z0/xxliKMd1RfxRNKFGcdRg0jBo1yR2+eDsGfhKhAGEkEe2ch65
	 rNftrzENvr6b83WJSsfoKBoGgUO/hQ19f0UphRMfGz9S2Hb0GEYZI8Le0+nj286CdZLI2
	 TIcyOYE482znS/ODjTXfFFJkZZUrTB+SPGMUF8b9yQo5mqIfA8GDIK+0l0WtJvj5RYyn4
	 3gKRaozm64fjeOY7oIWjl5gSReCK1vu/PGQft/As3czu/u1MDUEQq5WPKvcSaTFvpJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2aqQrQz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E3606A326;
	Wed, 25 Nov 2026 15:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2aqQrQz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2160B1F000F0;
	Wed, 25 Nov 2026 15:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622351;
	bh=WjkorCGvLlnnDSjT5HxrhZ3j+0dJbdPJVBi+26fQpng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2aqQrQzQeL5NT+Lrzc2xJWUA/jMj5T60TCGCP+5McuOb7PkgvN2G8zsNEwmb5H5U
	 ddIAWrEzT8r7H0Psua9/Rpq1wOvuQahBoNK8lvXyu1nYJYsYjhjq+U6999yIbuGBVg
	 EzSiFMqeJ0JiEk8r9QQ8WQ0Nb/qncY4FfywlG648=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 511/990] wifi: ath12k: preserve PPDU state across monitor status buffers
Date: Wed, 25 Nov 2026 15:31:18 +0100
Message-ID: <20261125143834.068566432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted to the older ath12k layout: edited dp_mon.c instead of wifi7/dp_mon.c and dropped the wifi7_ prefix from helper names, with the dp_mon_parse_rx_dest call taking ar instead of &ar->dp. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 23 ++++++++++++++---------
 drivers/net/wireless/ath/ath12k/mac.c    |  7 +++++++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 4aaaccca9412d..3752fa0eed30b 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -4390,18 +4390,23 @@ __ath12k_dp_mon_process_ring(struct ath12k *ar, int mac_id,
 		goto exit;
 
 	while ((skb = __skb_dequeue(&skb_list))) {
-		memset(ppdu_info, 0, sizeof(*ppdu_info));
-		ppdu_info->peer_id = HAL_INVALID_PEERID;
+		if (!ppdu_info->ppdu_continuation)
+			ath12k_dp_mon_rx_memset_ppdu_info(ppdu_info);
 
 		hal_status = ath12k_dp_mon_parse_rx_dest(ar, pmon, skb);
 
-		if (ar->monitor_started &&
-		    pmon->mon_ppdu_status == DP_PPDU_STATUS_START &&
-		    hal_status == HAL_TLV_STATUS_PPDU_DONE) {
-			rx_mon_stats->status_ppdu_done++;
-			pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
-			ath12k_dp_rx_mon_dest_process(ar, mac_id, *budget, napi);
-			pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
+		if (hal_status == HAL_TLV_STATUS_PPDU_DONE) {
+			ppdu_info->ppdu_continuation = false;
+			if (ar->monitor_started &&
+			    pmon->mon_ppdu_status == DP_PPDU_STATUS_START) {
+				rx_mon_stats->status_ppdu_done++;
+				pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
+				ath12k_dp_rx_mon_dest_process(ar, mac_id,
+							      *budget, napi);
+				pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
+			}
+		} else {
+			ppdu_info->ppdu_continuation = true;
 		}
 
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index c3f761cc35558..b9c943b219546 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1387,6 +1387,13 @@ static int ath12k_mac_monitor_start(struct ath12k *ar)
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
 
-- 
2.53.0



