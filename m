Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024595;
	b=wz/0YGVFrofNHQcwXViqo9C5oj4I7W5hJF59yx44ZwL+6nxvfuP6bsg6aEu96hW7Dm0n
	 TldpZSTMXceQ8NuSlSNP0PAAUXu3Y/09ZgxufYWv6FeSJ21KzVbX5IIa4/b7iY5hTc2vc
	 IQgRVY1xmhd1rGSM7juX44y3azG62DrUmYxs/g7yVkFcvxjQ0XpP35Y1meUk93RHkU5fU
	 957uaSgYCWnSJQtVkWRsXOWa29hg03tr98U78RwPS5FaEvQxbDhmK6HF8E+aLg5O7lVCv
	 R+zO3DSL6USTLLcNASsdvnnn503alHkMOckhGFcvPDJrS2UwvetsEvViHJ9tFYloIFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jP5QSwDtKLD6WK26wmN4mNpFDinIrg2OxP35ROZCe5M=;
	b=Yie/kdsTrl83OgUzls7RToX+Qc6TAOH5WrZUT0ZsX6SSJhvH0c9x0VQ3+5knFiJ2uW4/
	 p5nfqLxP1wgt+WqQe4aFO/6XJvvHFXDYvesu0FMLNTncOuwtIXUEMuC0gybZV1ufXg73k
	 cZWa1QapBjmzarqvzNm6wjgnWx0sSlFJGwypkkKy7Bzy5BQ0cP8OouI1X++l1HCs24S/m
	 Bc8/AAozKY1U8iEUmGsLYK47X0d5NntpBGNQqFp3DdS3ZAhI7Bz0aIkBbga9sz1nRDSBq
	 z/RvzMGvcLU2OZx94XW/DM7ohSulEey+iKOEQSfulXMixmiyGV0SUOS+8udOB4vO3sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNN0dX7T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E37606A320;
	Wed, 18 Nov 2026 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNN0dX7T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B801F000C4;
	Wed, 18 Nov 2026 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024595;
	bh=jP5QSwDtKLD6WK26wmN4mNpFDinIrg2OxP35ROZCe5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNN0dX7TSdeVvsdV2fV7qk31GKaUThAHQOut1oSwoCoJ/oFlaE2e/svPVgRdy5uyT
	 +gtyqUlRjvFGqrWJQ6f4ICqt/q7iniU5suUqPTNHs9jLH1BItF2L3/qcyBpNW4iN0m
	 O7EhedGM0xMTTrpXPaftkzoo3Kp7+5+FHk9xl74s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0740/2151] wifi: ath12k: avoid double DMA unmap of held monitor RX buffers
Date: Wed, 18 Nov 2026 15:41:15 +0100
Message-ID: <20261118150148.999956654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit febe1f8cbccc3434790bfc4d94d40c9dbd803065 ]

ath12k_dp_cc_cleanup() assumes that every rx_desc_info entry with a
non-NULL skb still has an active DMA mapping and therefore always
calls dma_unmap_single() before freeing the skb.

This assumption is not true for the monitor RX path.
ath12k_wifi7_dp_rx_mon_mpdu_pop() may DMA-unmap a buffer and mark
rxcb->unmapped before returning early to hold the MSDU for later
reprocessing. In that state desc_info->skb remains populated, so
module removal can trigger a second dma_unmap_single() from
ath12k_dp_cc_cleanup().

IOMMU reports the issue as:
  dma_unmap_phys()
  dma_unmap_page_attrs()
  ath12k_dp_cc_cleanup()
  ath12k_dp_cmn_device_deinit()
  ath12k_core_stop()

Skip dma_unmap_single() when rxcb->unmapped is already set and free
the skb directly.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916060325.854-7-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 4a54b8c353111..f89dd62a117a0 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1180,10 +1180,11 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 				if (!skb)
 					continue;
 
-				dma_unmap_single(ab->dev,
-						 ATH12K_SKB_RXCB(skb)->paddr,
-						 skb->len + skb_tailroom(skb),
-						 DMA_FROM_DEVICE);
+				if (!ATH12K_SKB_RXCB(skb)->unmapped)
+					dma_unmap_single(ab->dev,
+							 ATH12K_SKB_RXCB(skb)->paddr,
+							 skb->len + skb_tailroom(skb),
+							 DMA_FROM_DEVICE);
 				dev_kfree_skb_any(skb);
 			}
 
-- 
2.53.0



