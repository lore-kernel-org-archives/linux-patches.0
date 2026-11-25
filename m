Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622613;
	b=4VnYV0CJlcC7dsM341idz+qtnHeZ7YK1QixmjkQCRi53+28GDWc6kTsIOCCnGkev0Ora
	 eaxv1HYBo3fuuA0xyjzUT/cX4pC4QjjVz497Fu+qd0YHm1CliDhOueuoIK9gk4OT+2kV1
	 Lc478U0LTK0+FhO2qdhKyqzqsHxYflZq3X7gczTJLUJWAb1HJkJGCMCdtwWTGXG4tQ5CJ
	 p1VMqPtpUp+l+cLYlBIj8oeYvELG/UjaYZ9HqOxTNJGFgHwIaTSMN/GfOi5Xsb4yNbAc8
	 3ey5AecfSm8XQ/fRau2OXo8spKOBX5O4BcHwkZhPg1Os79njChp3VoYHx9oIyvjHoJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ezxC6V/LObDoDAt9rZcWFbS6FJnfeYRh6SQmSWEQ/U4=;
	b=Ma3wKV6s9mrOtQvKanAk4Fvhc2ILuj4S2bL3foMHwuXFH9/CN4Q03aei49n+UtSiErVD
	 5hbfDY8se7ab8/PgHrgi8CmYuMECwGc/mrbNFPhI5Gf7mnm/RIS6LQESycesvv2QLy0LQ
	 0dKWY6zShqOKqydQLmhZGOSVnFy7obVlgLXxqsWi7SURK13Ruha83XYzzrb46uf5X7N8Z
	 EaLcSy1PNvMG/4jFpcX2cikFI2z/fLpXuyqBRh2FM7javTfKz1oau6/hoTnoduORer+s5
	 mNVK/EBFn0YapoQHzmNMxiTtT9m6YrpP8LMMqfV7ylfRVYbYcoy44lgHymwqr2HMutw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TmQNJkZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502BF606A32E;
	Wed, 25 Nov 2026 16:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TmQNJkZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276D1F0093E;
	Wed, 25 Nov 2026 16:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622613;
	bh=ezxC6V/LObDoDAt9rZcWFbS6FJnfeYRh6SQmSWEQ/U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmQNJkZCkwpMM1JR5dzKgdrfuJK8nlQjMl0vEScmh1WxYIXnC1GkNmVD/8cRRXkOy
	 S+m2B5BgPb7jk+kYwSHuUUy4plVLEAVJy5vdQRY4G2A/xstwijqAhA9ez7zxqwRL3g
	 RxQYBD2s+h4J22e1+f9uoeh23/otPYn1QiupQP8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 548/990] wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
Date: Wed, 25 Nov 2026 15:31:55 +0100
Message-ID: <20261125143834.935811597@linuxfoundation.org>
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
[ sashal: Replaced the kzalloc'd dp_mon_mpdu with a stack variable, adapted to the pre-wifi7-split file path and function names (ath12k_dp_mon_rx_deliver(ar, ...)). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index a9ba30c330833..cfd9ea83887aa 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -4278,7 +4278,6 @@ static void ath12k_dp_rx_mon_dest_process(struct ath12k *ar, int mac_id,
 	struct ath12k_dp *dp = &ar->ab->dp;
 	struct ath12k_base *ab = ar->ab;
 	void *ring_entry, *mon_dst_srng;
-	struct dp_mon_mpdu *tmp_mpdu;
 	LIST_HEAD(rx_desc_used_list);
 	struct hal_srng *srng;
 
@@ -4341,18 +4340,16 @@ static void ath12k_dp_rx_mon_dest_process(struct ath12k *ar, int mac_id,
 		}
 
 		if (head_msdu && tail_msdu) {
-			tmp_mpdu = kzalloc(sizeof(*tmp_mpdu), GFP_ATOMIC);
-			if (!tmp_mpdu)
-				break;
-
-			tmp_mpdu->head = head_msdu;
-			tmp_mpdu->tail = tail_msdu;
-			tmp_mpdu->err_bitmap = pmon->err_bitmap;
-			tmp_mpdu->decap_format = pmon->decap_format;
-			ath12k_dp_mon_rx_deliver(ar, tmp_mpdu,
+			struct dp_mon_mpdu tmp_mpdu = {
+				.head = head_msdu,
+				.tail = tail_msdu,
+				.err_bitmap = pmon->err_bitmap,
+				.decap_format = pmon->decap_format,
+			};
+
+			ath12k_dp_mon_rx_deliver(ar, &tmp_mpdu,
 						 &pmon->mon_ppdu_info, napi);
 			rx_mon_stats->dest_mpdu_done++;
-			kfree(tmp_mpdu);
 		}
 
 		ring_entry = ath12k_hal_srng_dst_get_next_entry(ar->ab,
-- 
2.53.0



