Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479FF136338;
	Mon, 12 Aug 2024 16:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479260; cv=none; b=EfSjbmiqGwWQZ3HXim+uwQV5wAR3UfSGoL9DrC0quhIKa4+I683dAsiXoHXwA/7DOEflNuVT9xf4z4VHMPntkfzwtlf+PvVF7Awqk6D77RyuNqML6vuYcYI2zsp8PCHGUJ+mQkQdGpIqgT8LU2ras/3i1KZFiPVfZkjbN40v5aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479260; c=relaxed/simple;
	bh=rYWtaAJ8GzHlOEJcAEc7SPGMOvOhLtNETb2kC1xNjmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8dncHY7mbN7DxatbyaomuY1lix1bZlsaKk1xZ4W8ccolnZamAF5J0EukJJu6nmuQtVKxmBPGVe1VWramzyNfXBxjYt4rpWCmVBH8BhQZtjSJ/YnF3vzKWj9vw+IjzfvKac1hMCofG9ZTfGsIEHuzjqNs+0AGGWsjYETBrMdmF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZVGUyqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZVGUyqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF0FC4AF0D;
	Mon, 12 Aug 2024 16:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479260;
	bh=rYWtaAJ8GzHlOEJcAEc7SPGMOvOhLtNETb2kC1xNjmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZVGUyqoca5+oBmSxCQAtlXMo44wagdtPXqg0k1MjEz7f0s5UIsndHWqrKnBMjSYw
	 pwc5niFSFFRuapaUB5s+8Z/9peF3RLpcJY9RNjJnlGdnetLV46f+fx5i2LsblOYvEW
	 470VBvYmp2nxQi/tc2kkolNKrWfo/747Jae2KPSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/189] wifi: ath12k: rename the sc naming convention to ab
Date: Mon, 12 Aug 2024 18:01:05 +0200
Message-ID: <20240812160132.498418484@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit cda8607e824b8f4f1e5f26fef17736c8be4358f8 ]

In PCI and HAL interface layer module, the identifier sc is used
to represent an instance of ath12k_base structure. However,
within ath12k, the convention is to use "ab" to represent an SoC
"base" struct. So change the all instances of sc to ab.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00125-QCAHKSWPL_SILICONZ-1

Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231018153008.29820-3-quic_periyasa@quicinc.com
Stable-dep-of: a47f3320bb4b ("wifi: ath12k: fix soft lockup on suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hif.h | 18 +++++++++---------
 drivers/net/wireless/ath/ath12k/pci.c |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hif.h b/drivers/net/wireless/ath/ath12k/hif.h
index 4cbf9b5c04b9c..c653ca1f59b22 100644
--- a/drivers/net/wireless/ath/ath12k/hif.h
+++ b/drivers/net/wireless/ath/ath12k/hif.h
@@ -10,17 +10,17 @@
 #include "core.h"
 
 struct ath12k_hif_ops {
-	u32 (*read32)(struct ath12k_base *sc, u32 address);
-	void (*write32)(struct ath12k_base *sc, u32 address, u32 data);
-	void (*irq_enable)(struct ath12k_base *sc);
-	void (*irq_disable)(struct ath12k_base *sc);
-	int (*start)(struct ath12k_base *sc);
-	void (*stop)(struct ath12k_base *sc);
-	int (*power_up)(struct ath12k_base *sc);
-	void (*power_down)(struct ath12k_base *sc);
+	u32 (*read32)(struct ath12k_base *ab, u32 address);
+	void (*write32)(struct ath12k_base *ab, u32 address, u32 data);
+	void (*irq_enable)(struct ath12k_base *ab);
+	void (*irq_disable)(struct ath12k_base *ab);
+	int (*start)(struct ath12k_base *ab);
+	void (*stop)(struct ath12k_base *ab);
+	int (*power_up)(struct ath12k_base *ab);
+	void (*power_down)(struct ath12k_base *ab);
 	int (*suspend)(struct ath12k_base *ab);
 	int (*resume)(struct ath12k_base *ab);
-	int (*map_service_to_pipe)(struct ath12k_base *sc, u16 service_id,
+	int (*map_service_to_pipe)(struct ath12k_base *ab, u16 service_id,
 				   u8 *ul_pipe, u8 *dl_pipe);
 	int (*get_user_msi_vector)(struct ath12k_base *ab, char *user_name,
 				   int *num_vectors, u32 *user_base_data,
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 58cd678555964..a6a5f9bcffbd6 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -424,12 +424,12 @@ static void ath12k_pci_ext_grp_disable(struct ath12k_ext_irq_grp *irq_grp)
 		disable_irq_nosync(irq_grp->ab->irq_num[irq_grp->irqs[i]]);
 }
 
-static void __ath12k_pci_ext_irq_disable(struct ath12k_base *sc)
+static void __ath12k_pci_ext_irq_disable(struct ath12k_base *ab)
 {
 	int i;
 
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
-		struct ath12k_ext_irq_grp *irq_grp = &sc->ext_irq_grp[i];
+		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
 		ath12k_pci_ext_grp_disable(irq_grp);
 
-- 
2.43.0



