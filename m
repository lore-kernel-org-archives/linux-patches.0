Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017998;
	b=hqPFBZxj9KQjX+FvGbDsr5FvUJoJ97AmaAV84+A/7kgOY3Uy/zkBaaLuZ718xQV5cvin
	 PkDIPrenglHC0+GZYLPnU13BNKoE/qDfK1T2uSWKi5dHep4fAcKkTfY3ZyXp55lkXTroC
	 1EjY0CPRv7PVhFdBZ1l8gqcnVRLu3HwM9fV2w/XCqVBmifsYnHAZnVR28+r8quPtYDR+A
	 fil6LtlR/3lGckhspYHH/I7eVbriPk24QHc2GhVLwtkTeDlJM+eCmDaFxCkHFZxQaT/mY
	 f0DO3X17Q+0Wl6YlBvGkU88sVBXcuZXCSMss+7huq13GRh/N5wc3olUS03G7aWXMUgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aEu5JFW/sazKyuNzSb7CxRc4j2cAHM8VVqTVM11sEXI=;
	b=wv4kqAdOa4djyHg4hRRciwQeWoHiOkO+P8CR+99NsVbBfhvIWc8bDXP4CKJBd8etm8Yv
	 GQLns7RZ1H13CNxHDGLekYlK5lHPXBpDYbYP4T4PnoMHKgPP4mEhC0Qa72A0xJxbUq7J3
	 /PEgNyrGBDbG7+UmemhMkzNMGZiLXzn6yOLRzx9S1Ag9I5Ded3yuKVwTAjJfk5+RpmOcf
	 jd3aQ4NuRtUJuSqVA8RtAEzf2wLG8RN/bF7owI4PDLj6azIo/vYj5dEwyClBH4Am/KCfo
	 H6On9dyMpD5YPU8MkVPZlf5N2XkGOBipuhGg21B6vRt4fskosoF0Gp11DO1E/R5pb0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYmWi4xQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA06606A33D;
	Wed, 18 Nov 2026 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYmWi4xQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5541F000C8;
	Wed, 18 Nov 2026 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017998;
	bh=aEu5JFW/sazKyuNzSb7CxRc4j2cAHM8VVqTVM11sEXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYmWi4xQVi2/mUegLrdK+DIkld33wP7aOYcy8UmiSyy/j+99n8ujg0mg1IpXN4YCF
	 tljUiVQrOaPi16dGHaPXpf/V+yCA1GnTbvJnPaqQRVw64u8fwNMW+RaivIb77zuozc
	 jt4IhsbyjsmCSV0KHewc0VH2m7WW01a5XXlKHJj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1082/2651] ice: extract __ice_vsi_free_stats()
Date: Wed, 18 Nov 2026 15:38:42 +0100
Message-ID: <20261118150326.950934461@linuxfoundation.org>
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

[ Upstream commit db61b199031c614d1a98e844af00e3c426fc9d5f ]

Record the length of each ring stats array in struct ice_vsi_stats, so
that freeing the array entries no longer needs the owning VSI. Keep the
new fields in sync in both places that size the arrays.

With that, the body of ice_vsi_free_stats() becomes independent of the
VSI and can be split out as __ice_vsi_free_stats(). The @free_entries
parameter is always true here; a later commit adds a caller that frees
only the array container, after its entries have been handed over to a
freshly allocated stats structure.

The free path now stops at the recorded length instead of the VSI queue
count, so it follows the real allocation rather than a number that can
disagree with it. Sizing still does not: "ice: rebuild ring stats arrays
instead of reallocating them in place" starts using the lengths to carry
entries over, and only "ice: size ring stats arrays from the final queue
count" makes them authoritative for the allocation path.

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20260925132636.123300-3-przemyslaw.kitszel@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1c3b87896e6 ("ice: size ring stats arrays from the final queue count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h     |  2 +
 drivers/net/ethernet/intel/ice/ice_lib.c | 52 ++++++++++++++----------
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index db3c7015c56c4..fadfe94bf1c8c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -328,6 +328,8 @@ enum ice_vsi_state {
 struct ice_vsi_stats {
 	struct ice_ring_stats **tx_ring_stats;  /* Tx ring stats array */
 	struct ice_ring_stats **rx_ring_stats;  /* Rx ring stats array */
+	u16 tx_ring_stats_len;  /* Length of the Tx ring stats array */
+	u16 rx_ring_stats_len;  /* Length of the Rx ring stats array */
 };
 
 /* struct that defines a VSI, associated with a dev */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 31af378aa0e7a..1414127d32cd8 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -330,6 +330,32 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 	vsi->rxq_map = NULL;
 }
 
+/* free single stats memory */
+static void __ice_vsi_free_stats(struct ice_vsi_stats *vsi_stat, bool free_entries)
+{
+	if (!vsi_stat)
+		return;
+
+	if (free_entries) {
+		for (int i = 0; i < vsi_stat->tx_ring_stats_len; i++) {
+			if (vsi_stat->tx_ring_stats[i]) {
+				kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
+				WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
+			}
+		}
+		for (int i = 0; i < vsi_stat->rx_ring_stats_len; i++) {
+			if (vsi_stat->rx_ring_stats[i]) {
+				kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
+				WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
+			}
+		}
+	}
+
+	kfree(vsi_stat->tx_ring_stats);
+	kfree(vsi_stat->rx_ring_stats);
+	kfree(vsi_stat);
+}
+
 /**
  * ice_vsi_free_stats - Free the ring statistics structures
  * @vsi: VSI pointer
@@ -338,7 +364,6 @@ static void ice_vsi_free_stats(struct ice_vsi *vsi)
 {
 	struct ice_vsi_stats *vsi_stat;
 	struct ice_pf *pf = vsi->back;
-	int i;
 
 	if (vsi->type == ICE_VSI_CHNL)
 		return;
@@ -346,26 +371,7 @@ static void ice_vsi_free_stats(struct ice_vsi *vsi)
 		return;
 
 	vsi_stat = pf->vsi_stats[vsi->idx];
-	if (!vsi_stat)
-		return;
-
-	ice_for_each_alloc_txq(vsi, i) {
-		if (vsi_stat->tx_ring_stats[i]) {
-			kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
-			WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
-		}
-	}
-
-	ice_for_each_alloc_rxq(vsi, i) {
-		if (vsi_stat->rx_ring_stats[i]) {
-			kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
-			WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
-		}
-	}
-
-	kfree(vsi_stat->tx_ring_stats);
-	kfree(vsi_stat->rx_ring_stats);
-	kfree(vsi_stat);
+	__ice_vsi_free_stats(vsi_stat, true);
 	pf->vsi_stats[vsi->idx] = NULL;
 }
 
@@ -539,11 +545,13 @@ static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
 		kzalloc_objs(*vsi_stat->tx_ring_stats, vsi->alloc_txq);
 	if (!vsi_stat->tx_ring_stats)
 		goto err_alloc_tx;
+	vsi_stat->tx_ring_stats_len = vsi->alloc_txq;
 
 	vsi_stat->rx_ring_stats =
 		kzalloc_objs(*vsi_stat->rx_ring_stats, vsi->alloc_rxq);
 	if (!vsi_stat->rx_ring_stats)
 		goto err_alloc_rx;
+	vsi_stat->rx_ring_stats_len = vsi->alloc_rxq;
 
 	pf->vsi_stats[vsi->idx] = vsi_stat;
 
@@ -3055,6 +3063,7 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi)
 		vsi_stat->tx_ring_stats = tx_ring_stats;
 		return -ENOMEM;
 	}
+	vsi_stat->tx_ring_stats_len = req_txq;
 
 	if (req_rxq < prev_rxq) {
 		for (i = req_rxq; i < prev_rxq; i++) {
@@ -3074,6 +3083,7 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi)
 		vsi_stat->rx_ring_stats = rx_ring_stats;
 		return -ENOMEM;
 	}
+	vsi_stat->rx_ring_stats_len = req_rxq;
 
 	return 0;
 }
-- 
2.53.0



