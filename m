Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017347;
	b=WINKbvJRQRBj+1+dtMAF77bWyDpT3b0rL63T7MHwiBv3u9Ysm2At41TZxFPi4GAExiGJ
	 K8gcF3MEZtqZOB712hU8lR2+r1LgPi4dADF4RLFzj83IrLeM7C8H6b9lnKWNkgGMMal16
	 RgAVO/QpDmZM0qwdPMTr0N9pbdllTYUyoJhmvANJPB3cGkvOsNHp2OnTvsKlp3NpdxkXM
	 zQLgQip8xd6LGaOrUOro/R5Ku68aqxO9MNBa10V5OQTJvH7h3KwWWrR89JsquFkuBhJag
	 65CXx8UCh8uY/hK9L9WnnRvk316mDmWhwywljw03Jmaql6HZebZPFSFsZIhTCm5O7Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZbvGNno7R9JRD7rZJasUsvEl3ygKuZngAkayjzokkrc=;
	b=kT/X7BrrSi0ZiNi/ZersYh6aoDv39a7ga8wtZHFvnj3QZrCSMULcoXO3/AfjyuoxX2CN
	 zUX9HuY23+ZMWI6uutCI0UkZs9WRkNzvMdh73+Vs4lS6N4OmTJhr+w/lUf+RawSMuExGS
	 XyphAo0IqUhfcILBZpaaW//+KnQjuMcmLSnYljD/Pqu8foAy0ckljyj0aXqAkMnvV5Y0d
	 60lk4zztsZ1IUrXun98jcvwTxDNcUAQ0XrRTTbqk+PpXrZ2DNfE9+viGRV7ASCkUXdu5q
	 f7rsWhmXwGtOcrQgNcH5cUM7jPMfPRt6K8Qdxj/+GoDLt5JbIHxHA4/qu5rpaSUD2iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JSf60hGm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29877606A31C;
	Wed, 18 Nov 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JSf60hGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4331F000C4;
	Wed, 18 Nov 2026 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017347;
	bh=ZbvGNno7R9JRD7rZJasUsvEl3ygKuZngAkayjzokkrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSf60hGmgehJ9iXMA0YMbictruPw5gk1FJ5ilB9bcmMOtmJG7AQADIJJSalC+WbF1
	 oOyYpO5QoXzr2Xj8Gok2d7rHNoW/CH9rg3i78JdK9i60fLWmPs3Ljv35+yRFcdG0G6
	 H/Cewn9t7M0DoL25hgpBZ1/K+CGNKcF8ELN9rA00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0852/2651] wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
Date: Wed, 18 Nov 2026 15:34:52 +0100
Message-ID: <20261118150318.544618844@linuxfoundation.org>
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

[ Upstream commit 4dfe8e3ac731c3372b5c1f1f73b0676c301c3916 ]

When rxcb->paddr does not match the MSDU-list paddr reported by
the link descriptor, ath12k_wifi7_dp_rx_mon_mpdu_pop() sets
drop_mpdu = true and continues to the next MSDU. At that point
the skb is still attached to the descriptor via desc_info->skb;
the local msdu variable only holds a copy of that pointer. The
continue skips the rest of the loop body, which would normally
DMA-unmap the buffer, free the skb, clear desc_info->skb, and
append the descriptor to used_list in the next_msdu block.

The descriptor therefore stays in_use with the skb attached
forever. The skb is never DMA-unmapped, delivered, freed or
replaced, and HW does not write into it either because the
descriptor is no longer posted to any SRNG. The descriptor is
also never returned to used_list, so
ath12k_dp_rx_bufs_replenish() cannot allocate a fresh buffer
for it and the RX refill ring gradually drains.

The skb is still reachable via dp->rxbaddr[][].skb and is
reclaimed at teardown by ath12k_dp_cc_cleanup(), so this is not
a kmemleak-style unreachable leak. Nevertheless, both the
descriptor slot and the skb memory are wasted for the module
lifetime, and under sustained mismatches monitor RX stalls.

Remove the continue so drop_mpdu remains true, execution reaches
the DMA unmap and dev_kfree_skb_any() below, and the descriptor
is returned to used_list via the next_msdu block for replenish.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916060325.854-2-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index ded7d56cd79b0..ed66867466056 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2718,7 +2718,6 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 					   i, (unsigned long)rxcb->paddr,
 					   (unsigned long)msdu_list.paddr[i]);
 				drop_mpdu = true;
-				continue;
 			}
 			if (!rxcb->unmapped) {
 				dma_unmap_single(ar->ab->dev, rxcb->paddr,
-- 
2.53.0



