Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215749;
	b=lRNq5xF9e4j5Wfn14BT0ZEnL24/HP5Ln6xdVylNTSch95gVF6CEG9SKrke9cb0O0ea2P
	 Ak5HZ7uRxUXay00PsTDQjl+gc6enT20JX8pVKqo+5l7vOEqDhzfkeKmFRsVwiEc9yBH5a
	 FOjwJhSk/D33DGXw+yq/Q4VYLdahZ+bw0pSu81JOEkl68sDoPYfgB0pq5CjlHBZqKb/KQ
	 oG30Zbl6GXP6h5QrZp1uYbWyJtHsSANHU0uTLdKbA+ErE+9h59GCjCckYOFu3WJRrtSon
	 pigppaaI42H7NNoxmpB11U7IN0RGX82zusvXHX+o/ua3i9QZ6r9VBOFpN9OwcaUmidw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0FywTvhFPDVf5E3sdEli/TC46j3AAFd15DmdCwLO0Oc=;
	b=IeeS/mp3Mw8IQCm5QHTWZVRSLrsS5E392YQ7XEjogyV6EwC23ixkM+vb/bIgVm3XRzrh
	 U7KYnV4COMt+rlXZsyAqBSnfzZyGldUkRA1Mq5tA03OvQfYO6T0b4sGNRBMpFqrOs/TEt
	 gDznK7hGpHKZGKmcFIYUyP1Al2RrTgfOjYB7zMw2KxpglcUSdhH8/uFouWKdGNyZ7cEOc
	 0U895lzWAR4KI74eihvA2ObH/8RrvoJfV3jPOGgkAj33h2jVlwIMtKG8DznwPZ5V/eE+i
	 djv6WpJ79mjKGPDML2v1edU6eRTb0MCLAl/Cc+9wfad3/ujUjrZSzD9ucvV78V9Xzog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zQssp+/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77EB606A325;
	Wed, 28 Oct 2026 19:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQssp+/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019071F01829;
	Wed, 28 Oct 2026 19:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215748;
	bh=0FywTvhFPDVf5E3sdEli/TC46j3AAFd15DmdCwLO0Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQssp+/faqdSYLFUwwiVdN+IqJ5NPKttuMNtUovL2dtDKA20l4HGrGfsbFIL2ft+R
	 YUJNrXHj6AQE/aqjRw58Prir/WuCoLM/8tahu5n6hrLSQF5qTnsKqpoQMzstwct03N
	 mEQsyRfybFEafRZeFlikZ2UOFwbGTigxJwQY414o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Zhang <wei.zhang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1276/1887] wifi: ath11k: cancel SSR work items during PCI shutdown
Date: Wed, 28 Oct 2026 17:56:12 +0100
Message-ID: <20261028170528.458427805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Zhang <wei.zhang@oss.qualcomm.com>

[ Upstream commit 8c79aac429b583301f387374ff37c59be671df87 ]

A reboot can crash the kernel if it overlaps with WLAN firmware crash
recovery (SSR). The crash is a NULL pointer dereference in the MHI teardown
path while freeing DMA-backed MHI contexts.

Simplified trace:
  dma_free_attrs
  mhi_deinit_dev_ctxt [mhi]
  ath11k_pci_power_down [ath11k_pci]
  ath11k_pci_shutdown [ath11k_pci]
  device_shutdown
  kernel_restart

On the host side, SSR is driven by the MHI RDDM callback, which queues
reset_work to perform device recovery. reset_work power-cycles the device
by calling ath11k_hif_power_down() followed by ath11k_hif_power_up(). The
power-down phase deinitializes MHI and frees DMA resources.

Shutdown/reboot runs fully asynchronously with this RDDM-driven SSR
recovery flow. As a result, the shutdown path
(ath11k_pci_shutdown() -> ath11k_pci_power_down()) can race with the SSR
recovery sequence.

Fix this by canceling SSR-related work items during PCI shutdown, marking
the device as unregistering, and serializing the RDDM callback path that
checks and queues reset_work. This ensures that no new SSR recovery work
can be queued once teardown has started, and that any in-flight recovery
work is fully synchronized before device power-down, preventing MHI
teardown and DMA resource freeing from running more than once.

Note: This issue only affects PCI/MHI-based devices. AHB-based ath11k
devices do not queue reset_work in normal SSR flows.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-04866.5-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Fixes: 13da397f884d ("ath11k: add support for device recovery for QCA6390/WCN6855")
Fixes: 5edbb148bc57 ("wifi: ath11k: Add firmware coredump collection support")
Signed-off-by: Wei Zhang <wei.zhang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260404043050.3433754-1-wei.zhang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 2 ++
 drivers/net/wireless/ath/ath11k/pci.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 0e838721aafb2..7d53baa28f4fb 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -329,8 +329,10 @@ static void ath11k_mhi_op_status_cb(struct mhi_controller *mhi_cntrl,
 		ath11k_warn(ab, "firmware crashed: MHI_CB_SYS_ERROR\n");
 		break;
 	case MHI_CB_EE_RDDM:
+		spin_lock_bh(&ab->base_lock);
 		if (!(test_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags)))
 			queue_work(ab->workqueue_aux, &ab->reset_work);
+		spin_unlock_bh(&ab->base_lock);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index b50361490b9b2..3a92ac80d8aef 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -972,6 +972,13 @@ static void ath11k_pci_shutdown(struct pci_dev *pdev)
 	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
 
 	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
+
+	spin_lock_bh(&ab->base_lock);
+	set_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags);
+	spin_unlock_bh(&ab->base_lock);
+
+	cancel_work_sync(&ab->reset_work);
+
 	ath11k_pci_power_down(ab);
 }
 
-- 
2.53.0



