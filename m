Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0C54BD373;
	Tue, 13 Oct 2026 12:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893910; cv=none; b=JfN6wZy+IAOHnQH3Qk3avyjQSXhtI/WIZTO7fgGiEozzkbALFS45eQD2TGDuf/qruvO3xowD89yqhNpBDZuw/eF27yjN1s9W9ASSewKlCc0a4GJ9849CaNE7ssLmQa8PgcJk3o1k5BPzSJezgaty7WxuQiapBaVPfzFvoVODeuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893910; c=relaxed/simple;
	bh=QTMNUXE01n+NBIqT5BnmH/mDVleNjxDs8cgyjq8iUdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKZb5/cdRv3fp5QEd9QMII0GwR1FAaGhb8N8RIpNuV0+AO9qjzWehLyoIxJKrf2yaVHmmGX87LQRpXPUBGdcxPAMhYAIUKPoYnPxjtolXODJHnk45s8M8ZP0tj9h2AlBzN8JOcOu+lXsWujDzFAqK1ULzBv1v92e5f+97pYXnbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6XBvcZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6XBvcZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A53C1F000FF;
	Tue, 13 Oct 2026 12:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893909;
	bh=06H7kr4ap1UDF++vHEAZDLvUZjB7b50lXcoICrbgX6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6XBvcZhByN/kFklRcyklWEC5Xd/cn2DxIZpIC/VXP5CqvhAJ1l8LHMsBJZIM6iHx
	 uzWpWma1INNKjlk4EO/L6qijLDxG0Xwc7UeC9+BYJJtk6D6chMqoGsvIboC4XqUEhj
	 ZSyw4g1WH5kz79Dl10QZYGIvCuwBtbSEaTdmj0TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 346/621] eth: bnxt: decrease indent in bnxt_request_irq()
Date: Tue, 13 Oct 2026 13:35:41 +0200
Message-ID: <20261013112929.062563369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0fd562c7b9e48e7958f7405e54bf98e8e22ad184 ]

bnxt_request_irq() has unnecessary level of indentation.
Use continue instead. No need to re-fetch NUMA node for
each IRQ, move to the function level.

No functional changes.

Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260803193135.2030368-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 51e96fa31f7e ("eth: bnxt: avoid deadlock when canceling IRQ affinity notifier")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 46 +++++++++++------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4738c0b510bdf..35c8684d1b4ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11768,6 +11768,7 @@ static void bnxt_free_irq(struct bnxt *bp)
 
 static int bnxt_request_irq(struct bnxt *bp)
 {
+	const int numa_node = dev_to_node(&bp->pdev->dev);
 	struct cpu_rmap *rmap = NULL;
 	int i, j, rc = 0;
 	unsigned long flags = 0;
@@ -11792,6 +11793,7 @@ static int bnxt_request_irq(struct bnxt *bp)
 	for (i = 0, j = 0; i < bp->cp_nr_rings; i++) {
 		int map_idx = bnxt_cp_num_to_irq_num(bp, i);
 		struct bnxt_irq *irq = &bp->irq_tbl[map_idx];
+		u16 tag;
 
 		if (IS_ENABLED(CONFIG_RFS_ACCEL) &&
 		    rmap && bp->bnapi[i]->rx_ring) {
@@ -11810,33 +11812,31 @@ static int bnxt_request_irq(struct bnxt *bp)
 		netif_napi_set_irq_locked(&bp->bnapi[i]->napi, irq->vector);
 		irq->requested = 1;
 
-		if (zalloc_cpumask_var(&irq->cpu_mask, GFP_KERNEL)) {
-			int numa_node = dev_to_node(&bp->pdev->dev);
-			u16 tag;
+		if (!zalloc_cpumask_var(&irq->cpu_mask, GFP_KERNEL))
+			continue;
 
-			irq->have_cpumask = 1;
-			irq->msix_nr = map_idx;
-			irq->ring_nr = i;
-			cpumask_set_cpu(cpumask_local_spread(i, numa_node),
-					irq->cpu_mask);
-			rc = irq_update_affinity_hint(irq->vector, irq->cpu_mask);
-			if (rc) {
-				netdev_warn(bp->dev,
-					    "Update affinity hint failed, IRQ = %d\n",
-					    irq->vector);
-				break;
-			}
+		irq->have_cpumask = 1;
+		irq->msix_nr = map_idx;
+		irq->ring_nr = i;
+		cpumask_set_cpu(cpumask_local_spread(i, numa_node),
+				irq->cpu_mask);
+		rc = irq_update_affinity_hint(irq->vector, irq->cpu_mask);
+		if (rc) {
+			netdev_warn(bp->dev,
+				    "Update affinity hint failed, IRQ = %d\n",
+				    irq->vector);
+			break;
+		}
 
-			bnxt_register_irq_notifier(bp, irq);
+		bnxt_register_irq_notifier(bp, irq);
 
-			/* Init ST table entry */
-			if (pcie_tph_get_cpu_st(irq->bp->pdev, TPH_MEM_TYPE_VM,
-						cpumask_first(irq->cpu_mask),
-						&tag))
-				continue;
+		/* Init ST table entry */
+		if (pcie_tph_get_cpu_st(irq->bp->pdev, TPH_MEM_TYPE_VM,
+					cpumask_first(irq->cpu_mask),
+					&tag))
+			continue;
 
-			pcie_tph_set_st_entry(irq->bp->pdev, irq->msix_nr, tag);
-		}
+		pcie_tph_set_st_entry(irq->bp->pdev, irq->msix_nr, tag);
 	}
 	return rc;
 }
-- 
2.53.0



