Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017364;
	b=vpWe7eJnTQ8dR+H6DlQTnTv8x4Zr5SoxoTk5qBFV8PmBUSK8ukapmJTae10qOb+qekvo
	 4HczVL77RDrzB4hPCg/Gw5RIoCf4I92M/0zoG/hKN2lb2LSVpyZKVwxINzS+FjzKksx2C
	 Q8APzcXAhUAZYvF2+Uvo7Z1qx6mnw07l65F46441Lq4Yw/LLFSD6Rg1hIHa2mKvUcJgBy
	 tncfjsqnMWkBBSNPgT1a+fYaPqrNLunZ6gcgOuv1+irg6e89exW6MQ/EP2Tp8cIdtbweB
	 ufEN73F3zZ3jTJn5ikOuzkMQGmUQgX8vI7q9sVl7aikSEgQbcPHF12MNcGZcIocXoLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YydNy9Bziv3FsIgQzDSt+V0yctxZ3ECO5O7bT/zVR1E=;
	b=HU2PApsxJgEzf1dEHMrjjYUWwHxancekjIbPANUAcbGXKy2uiJjum48rCKtNbCf/GEXi
	 ML2RodaB8Y4g8wUawHkaKT+HHhM1Qg8lOHnsFHd0plJJWLC17yY9w/Cc9xq6G+M23ZQWM
	 H6nLPM29R/3e8orFIPGo94/v7H44NB5P/5mEhnmHOpkMPqtewbyaegqEC8UZtMXj4+rtc
	 AB9iLt1Du3UZc413umLsBYST3Ndgzw8R6R0lIOfsXOGqflCq68+legFQxnS6nfzD22IEK
	 soOfRwR6xTgQBKI+g89c24wifPL8Fh+thRrsnhmPy48Ooy/S+xI3l4vAy47gW7yXqIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMrRoGgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53958606A31C;
	Wed, 18 Nov 2026 15:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMrRoGgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5592F1F000C4;
	Wed, 18 Nov 2026 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017363;
	bh=YydNy9Bziv3FsIgQzDSt+V0yctxZ3ECO5O7bT/zVR1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMrRoGgT6rqkPw+iyTPNjhFdyOY1OLNaEJzP/2qPk9lcj1m6OeaisX0k+l2MQv3XR
	 DBuqYnjjB5JW5NmZhtlXFneePvnwSQ7mQyE5RQcS5jOpXDNvxrhxnOBzp52eqDU2sz
	 FS7IaWvpJ3WdJ/MeSkIsR2jQURpXDh4a6plO6Q2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0857/2651] wifi: ath12k: avoid double DMA unmap of held monitor RX buffers
Date: Wed, 18 Nov 2026 15:34:57 +0100
Message-ID: <20261118150318.721785797@linuxfoundation.org>
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
index 779529d189f8a..eee9ab7921158 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1002,10 +1002,11 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
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



