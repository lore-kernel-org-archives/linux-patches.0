Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017358;
	b=xCXh7LadWCiiQas2dFkmqTbLW4lfYsanwPzd8Yk+Uo2UY+iajzwib14M31JyEoLGoi4j
	 +v7VuA5ueN6495GW4MoFdca5PxlEideYbi3FLiGnoQhz3ZwXARaoCyg+tTBAC1AxMSN2y
	 cqAeDmHX7OIeo9OFat2PI5H2A937/YioRTMolx6KpyMVolYPn8a+TWnq+EmuJGJ0r8lu4
	 eNmvYSrZH/hbuH797Ce4+6uujLkT1H+r4EfNdCJXd48jDVdbfdgBEiRUd1mGIqjuba0N5
	 BjSkufNnBr13FcLycy+bKz92TiPfaSvkLZZ2Mvq5uCHsnw6ZB3gly1z6DHjc3yXAufQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lz8y82AjOGrKeQnhxrqMVm9Zx96WZnO8SE2cjtqIMpk=;
	b=prQB5C7KrFeHbsbeVwh7wZUVAx+t6RbAxMhvPqSu+1FiDtlRBWUlNaE2kXvHhuVg84OA
	 UJCW2uj71FRLnhU9otuGvI/+/7nmghDxSoN2hUqsB6Bzd2JHpP7BUXxpbJn7XU3Xc5bDu
	 /DVgEuX4b20gtFz5fwD6YmmfPHETxxPMenca1IdV8KSW4lN/jOWbsC6aWXymr8gQ+R+he
	 J8pp6oaeo08mEoQoAW9bErNh5Ow/qR+gcCr9cVgIDp9VBMI2CeGBJapjnN8XCvlOKQmX6
	 egohx26aefoArMzdTLXZa7SjDBuyYe2Jt+bWXcg3TAVFikav8QRSPa5EcN7wgtDXGYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DIj/EliX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B68606A31C;
	Wed, 18 Nov 2026 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIj/EliX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FBA1F000C4;
	Wed, 18 Nov 2026 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017358;
	bh=Lz8y82AjOGrKeQnhxrqMVm9Zx96WZnO8SE2cjtqIMpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIj/EliXX04fkhaP1MuJ437lsORAZ7NhL3KUciO3TZb6sVfUG7PHdhp26GWSI+u6e
	 jFUn4RKAF/VV4UtXZFOt3vtZh21ZfRQH01FpUhQkuiYQTMKM0gvEacrmXGSUX3s6QA
	 ajSxgJksrmjoWpxKF3wNfxxVwypUBQcpe2fVrcGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0855/2651] wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
Date: Wed, 18 Nov 2026 15:34:55 +0100
Message-ID: <20261118150318.649409124@linuxfoundation.org>
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

[ Upstream commit 8b1d2f4c3805b9f1bddd5dc3bd241edd1f9ab2d9 ]

ath12k_wifi7_dp_rx_mon_dest_process() allocates a dp_mon_mpdu with
kzalloc(GFP_ATOMIC) for each delivered MPDU. On allocation failure
it breaks out of the reap loop without calling
ath12k_hal_srng_dst_get_next_entry(), leaving the destination ring
tail pointer parked on the current entry -- the same entry will
be peek()ed on every subsequent NAPI schedule, stalling monitor
RX until the mon_dest_ring_stuck_cnt recovery path resyncs the
PPDU ID. The head_msdu chain accumulated for this iteration is
also orphaned since the break bypasses both the delivery and
the cleanup paths.

kmemleak reports these skbs in field testing:
  kmemleak_alloc()
  __netdev_alloc_skb()
  ath12k_dp_rx_bufs_replenish()
  ath12k_wifi7_dp_rx_mon_dest_process()

dp_mon_mpdu is used only within a single reap loop iteration and
is passed synchronously to ath12k_wifi7_dp_mon_rx_deliver(); the
callee does not retain the pointer. Place it on the stack instead
of using kzalloc(GFP_ATOMIC). This eliminates the allocation
failure path (and the ring stall it caused) and saves a
kzalloc/kfree pair per delivered MPDU.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916060325.854-5-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 8fca777041d18..1e29c13ad66d9 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2827,7 +2827,6 @@ ath12k_wifi7_dp_rx_mon_dest_process(struct ath12k *ar, int mac_id,
 	struct ath12k_base *ab = ar->ab;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	void *ring_entry, *mon_dst_srng;
-	struct dp_mon_mpdu *tmp_mpdu;
 	LIST_HEAD(rx_desc_used_list);
 	struct hal_srng *srng;
 
@@ -2893,18 +2892,16 @@ ath12k_wifi7_dp_rx_mon_dest_process(struct ath12k *ar, int mac_id,
 		}
 
 		if (head_msdu && tail_msdu) {
-			tmp_mpdu = kzalloc_obj(*tmp_mpdu, GFP_ATOMIC);
-			if (!tmp_mpdu)
-				break;
-
-			tmp_mpdu->head = head_msdu;
-			tmp_mpdu->tail = tail_msdu;
-			tmp_mpdu->err_bitmap = pmon->err_bitmap;
-			tmp_mpdu->decap_format = pmon->decap_format;
-			ath12k_wifi7_dp_mon_rx_deliver(&ar->dp, tmp_mpdu,
+			struct dp_mon_mpdu tmp_mpdu = {
+				.head = head_msdu,
+				.tail = tail_msdu,
+				.err_bitmap = pmon->err_bitmap,
+				.decap_format = pmon->decap_format,
+			};
+
+			ath12k_wifi7_dp_mon_rx_deliver(&ar->dp, &tmp_mpdu,
 						       &pmon->mon_ppdu_info, napi);
 			rx_mon_stats->dest_mpdu_done++;
-			kfree(tmp_mpdu);
 		}
 
 		ring_entry = ath12k_hal_srng_dst_get_next_entry(ar->ab,
-- 
2.53.0



