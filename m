Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018001;
	b=i5NB+cZOZjDXKdh+/uHxXuAZinhvlnzGWWfc/XiAFKKbH6J3TKpu17AvaDdiXI4um3cT
	 VOu8W7louPR24wtVOfr7B8J0qthi7eZacztNKLQRSW+xDB/R739jFGBoiglXG6C/lyBJb
	 vqCSabTfhNNxdCR3K9/ctciKI9jwv4p6icl0orCNUBShkRI6Rjx8h/N06S3jk7RPUhvmu
	 WRa7gRJrIvTawItrR47Mf5K/YMR8YpaQCDN++wAH84rLXWCP0CtEsh28HeNRJbnS5EDB+
	 msIpgh71LSSIy2cyz8Vxo3gkOrXye5v+Yqx/Qu4zNn91eE6u/HFMlD3mVyBw7IZM36g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3WqVCUjqIwIbMY5baR/ktbKM2Ac6Jl5o2uVCBrE8n8=;
	b=l7JZS9fHz+L0zDc7hQpa8HqSJKTC9YQ2iPme0b5mEU1Hc1EQpGvBQCym6Ycupf3wxUw2
	 q6/S/5Y8OXlGZKe10XdpfwQljXxnL2XxnETdmklRwpOupG9I2BOkz5oc1rsCRuaiC5Lvo
	 JZmLskE/EceX4iu9Jwz1WlxipTZXQLb2UDu5IKoq92AEv3p1NFzdgMC/+F9z+A+9evf+P
	 YFMH1Woy6apS7EL+oMeJCiKLdNsn0Fy9i3nkbOXSK8GitXct9Ndqy+T9LdmXQLKY3moOg
	 e0obGPEkInKcNXiYM8letvjpvmrYOH7g6vS55mOzizDoI5V3zkVH6RTPBL3/R7qBilw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Txo//6cw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D398606A31C;
	Wed, 18 Nov 2026 16:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Txo//6cw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EB21F000C6;
	Wed, 18 Nov 2026 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018001;
	bh=X3WqVCUjqIwIbMY5baR/ktbKM2Ac6Jl5o2uVCBrE8n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Txo//6cwjis9OP3KAFcfHms3BCJEkNcX4qwSoFpvk3ZCRQXAAF9tE1uCid6hWAf6o
	 a6hFkvnStG6WUAhs2uzeG/1Bzj7r7YcQZf/6Mu9ebWoNoWLo/g6nMpnPKeQ8eafJSQ
	 3WNn7riOPdjye3B52iEWlDF7LXrOmRaOhMsfkBxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1083/2651] ice: extract ice_vsi_new_stat_arrays()
Date: Wed, 18 Nov 2026 15:38:43 +0100
Message-ID: <20261118150326.987711174@linuxfoundation.org>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit ed3cbc4430c2f365281623b8c9fa81e47f4e8d31 ]

Split the allocation of a struct ice_vsi_stats and its two ring stats
arrays out of ice_vsi_alloc_stat_arrays(), which is left with just the
lookup and the store into pf->vsi_stats[].

The sole caller keeps passing the very same queue counts as before,
vsi->alloc_txq and vsi->alloc_rxq. A later commit adds a second caller
in the rebuild path, which cannot use vsi->alloc_* because it has to
size the arrays before the VSI is reconfigured.

Note that the error path no longer clears pf->vsi_stats[vsi->idx]; the
early return above guarantees it is already NULL.

No functional change intended.

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20260925132636.123300-4-przemyslaw.kitszel@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1c3b87896e6 ("ice: size ring stats arrays from the final queue count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 47 +++++++++++++-----------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 1414127d32cd8..ed32ae2667c5f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -519,6 +519,30 @@ static irqreturn_t ice_msix_clean_rings(int __always_unused irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static struct ice_vsi_stats *ice_vsi_new_stat_arrays(int txq, int rxq)
+{
+	struct ice_ring_stats **tx_ring_stats;
+	struct ice_ring_stats **rx_ring_stats;
+	struct ice_vsi_stats *vsi_stat;
+
+	vsi_stat = kzalloc_obj(*vsi_stat);
+	tx_ring_stats = kzalloc_objs(*tx_ring_stats, txq);
+	rx_ring_stats = kzalloc_objs(*rx_ring_stats, rxq);
+	if (!vsi_stat || !tx_ring_stats || !rx_ring_stats) {
+		kfree(vsi_stat);
+		kfree(tx_ring_stats);
+		kfree(rx_ring_stats);
+		return NULL;
+	}
+
+	vsi_stat->tx_ring_stats = tx_ring_stats;
+	vsi_stat->rx_ring_stats = rx_ring_stats;
+	vsi_stat->tx_ring_stats_len = txq;
+	vsi_stat->rx_ring_stats_len = rxq;
+
+	return vsi_stat;
+}
+
 /**
  * ice_vsi_alloc_stat_arrays - Allocate statistics arrays
  * @vsi: VSI pointer
@@ -537,33 +561,12 @@ static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
 	/* realloc will happen in rebuild path */
 		return 0;
 
-	vsi_stat = kzalloc_obj(*vsi_stat);
+	vsi_stat = ice_vsi_new_stat_arrays(vsi->alloc_txq, vsi->alloc_rxq);
 	if (!vsi_stat)
 		return -ENOMEM;
 
-	vsi_stat->tx_ring_stats =
-		kzalloc_objs(*vsi_stat->tx_ring_stats, vsi->alloc_txq);
-	if (!vsi_stat->tx_ring_stats)
-		goto err_alloc_tx;
-	vsi_stat->tx_ring_stats_len = vsi->alloc_txq;
-
-	vsi_stat->rx_ring_stats =
-		kzalloc_objs(*vsi_stat->rx_ring_stats, vsi->alloc_rxq);
-	if (!vsi_stat->rx_ring_stats)
-		goto err_alloc_rx;
-	vsi_stat->rx_ring_stats_len = vsi->alloc_rxq;
-
 	pf->vsi_stats[vsi->idx] = vsi_stat;
-
 	return 0;
-
-err_alloc_rx:
-	kfree(vsi_stat->rx_ring_stats);
-err_alloc_tx:
-	kfree(vsi_stat->tx_ring_stats);
-	kfree(vsi_stat);
-	pf->vsi_stats[vsi->idx] = NULL;
-	return -ENOMEM;
 }
 
 /**
-- 
2.53.0



