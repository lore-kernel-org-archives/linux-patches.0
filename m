Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622550;
	b=HUevBgKL6ikGNBk1SqtXgG32fw+ErfHtLizTUzR+O07ok9EnBStVougPm1nXNaOCCAN9
	 cCzxH+D5/20AQ6VI7dIR2sRFIf0aAMOxuoL0B7Qy7n61w1Ctm/RQZhcKbuKbo69gemWhH
	 4xIhl3oZQc5Jsq5hnbOPAlXAeEVjtDqB2B4w0ry60BWUZdrp/kxPMxiHfGTkpYEr1kD57
	 EdbcLHD+1nV7N3NgPmbTgco/MYq5RfkS2H88iAGa6O3oyTkmsli8QSd6fGLFOtOzapGL1
	 MJqRQEZmxcrQdaBoWP5DzEBOUTH01yw+ZHpdqO6Mq+lsazp5YZll+f7KksZs36au01Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUDg/DhHBg4PzGNBGh9v6GXtfdMNOt3RDLyjAhYbMeE=;
	b=PwVKAuuRLhWD4rYgDALPJJCVleXXZ5UiMS+ERxcAb+spn9O5AXcoXZmL7Z+UxEHvJ/Td
	 Ku4HU1Y3qciaX1OK7vUk0A3ML/xrBvq3n1dK/Z1TtWPrcPZ1ycL5L7wUX5M50oqcuUfqw
	 fdOj+AUrUxx1wJKz/B/UZVMz4RMj21D5IrFS7+YyQipzg8fZwFBiYLoyJYqH3BVGTdjKS
	 g02/5F6qNSA3dRPetaqMRzj/IDlzOV5m3RffRZdF96FinDKep9tJuzyDpgW41WVpEyCfe
	 IeTvMcx9M4/nGgsReAvPQ5WqOcGM9LRXtMNdLem0zehAW84T1WCLNlazvzBy/t9Acqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmiL7LCP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4347606A321;
	Wed, 25 Nov 2026 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmiL7LCP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED99E1F000CA;
	Wed, 25 Nov 2026 16:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622549;
	bh=nUDg/DhHBg4PzGNBGh9v6GXtfdMNOt3RDLyjAhYbMeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmiL7LCPCQTCsxCJaG+7vzgUzjBaaDuNOF+L7fHITFV5mu4ESOnbK4UgPVmXKXdPo
	 N8/THb697INjpvr0/Ppl9V8yVsSVjXueYZB/PC6ToX9h3fgO3vgleN8aZEmB6A9MOT
	 vijs8FpqEs/YH6q5EPXOxFgI8gQTNq0xxVTZhJnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 546/990] wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
Date: Wed, 25 Nov 2026 15:31:53 +0100
Message-ID: <20261125143834.887530908@linuxfoundation.org>
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

[ Upstream commit d8e8eac3fcffc114a79f7d07d7cb73cc16645381 ]

ath12k_wifi7_dp_rx_mon_mpdu_pop() aborts processing when a duplicate
monitor link descriptor is detected.

Previous iterations may already have linked MSDUs onto *head_msdu
and detached the corresponding RX buffers from their descriptors.
Returning without completing or freeing the chain leaves those
skbs orphaned, resulting in a memory leak.

kmemleak reports these skbs in field testing:
  kmemleak_alloc()
  __netdev_alloc_skb()
  ath12k_dp_rx_bufs_replenish()
  ath12k_wifi7_dp_rx_mon_dest_process()

Free the accumulated MSDU chain before returning and clear
*head_msdu so callers observe a consistent state.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916060325.854-3-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ sashal: Applied to the pre-split monitor RX file with the function name ath12k_dp_rx_mon_mpdu_pop() instead of the wifi7 path and name; the two-line change itself is identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index a7cb7ba62f2d4..0e9b02f1140fc 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -4130,6 +4130,8 @@ ath12k_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 		if (pmon->mon_last_linkdesc_paddr == paddr) {
 			pmon->rx_mon_stats.dup_mon_linkdesc_cnt++;
 			spin_unlock_bh(&pmon->mon_lock);
+			kfree_skb_list(*head_msdu);
+			*head_msdu = NULL;
 			return rx_bufs_used;
 		}
 
-- 
2.53.0



