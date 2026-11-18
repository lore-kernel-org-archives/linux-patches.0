Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017352;
	b=x59feUCzELVkqfPveNMDFpbADvgsf+g0EWM6f5wC0/cB4VZ6BqHvEmxZHcEkqsbsda3W
	 Sbqc1qBkjpT0CTf3hpB6YFpg+xDy1zVYoFCbiKD4sUDccCxgxonBJTcWAwgtqiBRXq/3v
	 uNg7OjFnTPZBX8ao0DeTsgUJx8mu+aSPIedI/Nr3YqjDcWfMsxUKdH6oFgoEIY/Kr5eJc
	 EuVxPtfVEZJhhqY59dT7UoFYkrRZrDGABqa6UQXhSnMCqS+bX25LW3JQpBRsPd6AVgrdk
	 LvglXw9n/6KVqUBoMOW0/6GCRewICGMDB0OWfEYSh+fll/Ulwh46/XidVcg4L64N+UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kfzbzgMjW21trUfOMkMPDgLrn7+5gzBopg8xkhZlskc=;
	b=qmmj1bvC1VJItdSaJAPVunWJelUVMoCWta0kri5c730ZJB9lHs73HeM+hifxhkn1yzrN
	 eueN91TXVZjZQvSRAMV9xQrL4WCZZqqhkIASZIvnKDbQ/+aEWM5LS8vSCVT4LyNPi1SRk
	 fuYDZUNP5ykihzxhJpBcZLXJlcC0+NSnT5UF/tkKs+Lfw5eue5SjbfETGDeTcmJMhdAjx
	 oeg+e85QcK/6aBI95ELz0YheFWOjd7ZC0gZPA2E585qTv7lf7PHiRCuV2n07IOdfK+W5F
	 Totn4PxgTams7Zk/X5u0M9AxtqRy3ph3TRwCusUBSW8sJLm2mbfnkNcFKm0gvJIFQIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvorVfpG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80AF60A2603;
	Wed, 18 Nov 2026 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvorVfpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D7D1F000C6;
	Wed, 18 Nov 2026 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017352;
	bh=kfzbzgMjW21trUfOMkMPDgLrn7+5gzBopg8xkhZlskc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvorVfpGzMuBBAQOjKq9k5FLCN+YCKUWn34Hiz9/kY9+tk7zGGlILUkjndEguKoJJ
	 anLOz3N6Q/7/vjzHC+6Jd1mvUmPkP38ONtsm2JHhdIUm/pviuCbEisCPiNtsB5Y39Z
	 2yO8F31Wq31UOlXrX8XSVXh7z5vpk09j2xr0S5r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0853/2651] wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
Date: Wed, 18 Nov 2026 15:34:53 +0100
Message-ID: <20261118150318.579135226@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index ed66867466056..08f2fba3e6807 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2675,6 +2675,8 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 		if (pmon->mon_last_linkdesc_paddr == paddr) {
 			pmon->rx_mon_stats.dup_mon_linkdesc_cnt++;
 			spin_unlock_bh(&pmon->mon_lock);
+			kfree_skb_list(*head_msdu);
+			*head_msdu = NULL;
 			return rx_bufs_used;
 		}
 
-- 
2.53.0



