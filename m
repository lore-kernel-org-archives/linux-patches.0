Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A3C3AA1B7;
	Tue,  3 Feb 2026 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770130285; cv=none; b=NJupQ4xtgZ97le8rEtMXJV0rkMnxxstLU7kwNWlsypgGj02F3YulCv77As8MyG0YvsHbG950IknlfKV2nohq2/woUaVH0dxZNEEL6bvTS3r6Vqmp0JbYEaF/0WAHno0upxoG7C+5gOOAImB+sE1dZPMQY803Yl+r4owq6T/CUgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770130285; c=relaxed/simple;
	bh=YB/RU1C6OMA2a53Y71sJlu8dn1ACh98l/eWG3E4Feyc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=rr+QHhl7raY03xzpdBd5bdpzUQWfTjEudj5dygDFB3RYebHNJJSw32rxRjK03xAv/6jNjMlRRbulUe6nvVRYqNbLmXqw+wdTVRvxFhE0kA1OX1QDFv3LqSEnLSZKQwZFnRI9cDKulKIFBtEKxG8IknYqw4ktX+YITfG9/Gui+W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xn1T3ffX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xn1T3ffX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F0FC116D0;
	Tue,  3 Feb 2026 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770130285;
	bh=YB/RU1C6OMA2a53Y71sJlu8dn1ACh98l/eWG3E4Feyc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Xn1T3ffXCaV9BTpUtvMCPFjFb9ZC1kqjgMSIIKYBD9ZQLrFUNitVf0irENo6voX87
	 XbBOnTMk4bNbZDXlALVoseBi3/4Xh5qs7Z0IkN+W9joz6QqTgQpdcU4O6KT6wdi5wQ
	 tweLAer/WagNDGVq7U+64pPiv7Sr719K5xGM5X1k=
Subject: Patch "wifi: ath11k: add srng->lock for ath11k_hal_srng_* in monitor mode" has been added to the 6.6-stable tree
To: 1468888505@139.com,ath11k@lists.infradead.org,gregkh@linuxfoundation.org,gseset@codeaurora.org,jeff.johnson@oss.qualcomm.com,jjohnson@kernel.org,kvalo@kernel.org,patches@lists.linux.dev,quic_jjohnson@quicinc.com,quic_kangyang@quicinc.com,quic_msinada@quicinc.com,quic_vnaralas@quicinc.com,quic_vthiagar@quicinc.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 15:50:39 +0100
In-Reply-To: <20260203031345.1357063-1-1468888505@139.com>
Message-ID: <2026020339-animating-laxative-394a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    wifi: ath11k: add srng->lock for ath11k_hal_srng_* in monitor mode

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     wifi-ath11k-add-srng-lock-for-ath11k_hal_srng_-in-monitor-mode.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-213159-greg=kroah.com@vger.kernel.org Tue Feb  3 04:14:07 2026
From: Li hongliang <1468888505@139.com>
Date: Tue,  3 Feb 2026 11:13:45 +0800
Subject: wifi: ath11k: add srng->lock for ath11k_hal_srng_* in monitor mode
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, quic_kangyang@quicinc.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, kvalo@kernel.org, jjohnson@kernel.org, quic_vthiagar@quicinc.com, quic_vnaralas@quicinc.com, quic_msinada@quicinc.com, gseset@codeaurora.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, quic_jjohnson@quicinc.com, jeff.johnson@oss.qualcomm.com
Message-ID: <20260203031345.1357063-1-1468888505@139.com>

From: Kang Yang <quic_kangyang@quicinc.com>

[ Upstream commit 63b7af49496d0e32f7a748b6af3361ec138b1bd3 ]

ath11k_hal_srng_* should be used with srng->lock to protect srng data.

For ath11k_dp_rx_mon_dest_process() and ath11k_dp_full_mon_process_rx(),
they use ath11k_hal_srng_* for many times but never call srng->lock.

So when running (full) monitor mode, warning will occur:
RIP: 0010:ath11k_hal_srng_dst_peek+0x18/0x30 [ath11k]
Call Trace:
 ? ath11k_hal_srng_dst_peek+0x18/0x30 [ath11k]
 ath11k_dp_rx_process_mon_status+0xc45/0x1190 [ath11k]
 ? idr_alloc_u32+0x97/0xd0
 ath11k_dp_rx_process_mon_rings+0x32a/0x550 [ath11k]
 ath11k_dp_service_srng+0x289/0x5a0 [ath11k]
 ath11k_pcic_ext_grp_napi_poll+0x30/0xd0 [ath11k]
 __napi_poll+0x30/0x1f0
 net_rx_action+0x198/0x320
 __do_softirq+0xdd/0x319

So add srng->lock for them to avoid such warnings.

Inorder to fetch the srng->lock, should change srng's definition from
'void' to 'struct hal_srng'. And initialize them elsewhere to prevent
one line of code from being too long. This is consistent with other ring
process functions, such as ath11k_dp_process_rx().

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20241219110531.2096-3-quic_kangyang@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5093,7 +5093,7 @@ static void ath11k_dp_rx_mon_dest_proces
 	struct ath11k_mon_data *pmon = (struct ath11k_mon_data *)&dp->mon_data;
 	const struct ath11k_hw_hal_params *hal_params;
 	void *ring_entry;
-	void *mon_dst_srng;
+	struct hal_srng *mon_dst_srng;
 	u32 ppdu_id;
 	u32 rx_bufs_used;
 	u32 ring_id;
@@ -5117,6 +5117,7 @@ static void ath11k_dp_rx_mon_dest_proces
 
 	spin_lock_bh(&pmon->mon_lock);
 
+	spin_lock_bh(&mon_dst_srng->lock);
 	ath11k_hal_srng_access_begin(ar->ab, mon_dst_srng);
 
 	ppdu_id = pmon->mon_ppdu_info.ppdu_id;
@@ -5175,6 +5176,7 @@ static void ath11k_dp_rx_mon_dest_proces
 								mon_dst_srng);
 	}
 	ath11k_hal_srng_access_end(ar->ab, mon_dst_srng);
+	spin_unlock_bh(&mon_dst_srng->lock);
 
 	spin_unlock_bh(&pmon->mon_lock);
 
@@ -5564,7 +5566,7 @@ static int ath11k_dp_full_mon_process_rx
 	struct hal_sw_mon_ring_entries *sw_mon_entries;
 	struct ath11k_pdev_mon_stats *rx_mon_stats;
 	struct sk_buff *head_msdu, *tail_msdu;
-	void *mon_dst_srng = &ar->ab->hal.srng_list[dp->rxdma_mon_dst_ring.ring_id];
+	struct hal_srng *mon_dst_srng;
 	void *ring_entry;
 	u32 rx_bufs_used = 0, mpdu_rx_bufs_used;
 	int quota = 0, ret;
@@ -5580,6 +5582,9 @@ static int ath11k_dp_full_mon_process_rx
 		goto reap_status_ring;
 	}
 
+	mon_dst_srng = &ar->ab->hal.srng_list[dp->rxdma_mon_dst_ring.ring_id];
+	spin_lock_bh(&mon_dst_srng->lock);
+
 	ath11k_hal_srng_access_begin(ar->ab, mon_dst_srng);
 	while ((ring_entry = ath11k_hal_srng_dst_peek(ar->ab, mon_dst_srng))) {
 		head_msdu = NULL;
@@ -5623,6 +5628,7 @@ next_entry:
 	}
 
 	ath11k_hal_srng_access_end(ar->ab, mon_dst_srng);
+	spin_unlock_bh(&mon_dst_srng->lock);
 	spin_unlock_bh(&pmon->mon_lock);
 
 	if (rx_bufs_used) {


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.6/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.6/wifi-ath11k-add-srng-lock-for-ath11k_hal_srng_-in-monitor-mode.patch
queue-6.6/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
