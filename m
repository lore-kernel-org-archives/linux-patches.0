Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624202;
	b=PrnZuyjUpvfMlNm9VchCzxpBP/Pt1l1ToazqdA4q10F6WRQtDL9skhFcvBcSuXAeV79B
	 KG9cXrxBHrfxnqb/k6ExndwMGf1Ww8x99SMIGZQTiFH/+Cp/tNYYKVrwmNW9B7zGOplcN
	 P7a8Nb9ZnvbFky3/ZRn1G7qe+FEl45nkMlLqapNBxRL3577Fi8IsT60xM5NX0Tgltq+O1
	 UECj41Cj4lToHw7Q8bCWi0xMiX5W70mvLgyJ9FbrOX0saDM3dKS2CjcyyBB787iRyZ/oI
	 R2IlaxN/pg9NUtEEjHGaMs+Lw5OUoiMJwtsp6mMxZsfnM2gTtiOCNBfjQzU9l+XBL5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M7LdqRznYVOpuXdbVv881VroFHE8A0/wYZYQTABFB+M=;
	b=sBuQ8yHmQeX5G/WjcpbPCUo7BuMZ50MUFz8ry1N1KNKKbIdoyTjdyl/kZNASHVcL0U0/
	 JvP6ihBK2Rk7KtVgadJiRbMns/lqDAig7uDZ9LOKJmmI4cf2veYQnh5P4OXRMgVNOINoW
	 aJR6h6e9EcN20UFhSyGWG8DAdKP8czT42i/kT1ABwfN+dlIjZffQDzhwl/yNkVyXUGoKu
	 iuDPL7or5uJHn+8CgOTZVIOOWL/VkE2l086n4GFV3U4yyn0OI64PSzWmyc9dk5i0LDNp+
	 n+9jyyJVK/0qjbL7CoB+Z1zhZq7HaYJe12Pz3WOU5v5rT6/WK+4qs6dcYSJjHdwHqnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ftbo17jv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740FC606A680;
	Wed, 25 Nov 2026 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ftbo17jv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF371F000C4;
	Wed, 25 Nov 2026 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624202;
	bh=M7LdqRznYVOpuXdbVv881VroFHE8A0/wYZYQTABFB+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ftbo17jvQS/yPoU6mf7wxYwtTlMuoKcGHJyy09dnqLJ/JhfhDfb6+7Uel7VKlKl7J
	 bmKuN/ZOhQB/sW2w85IHBjlCpMB4bprNlRK+CvF1/GkIHZevahgovX4KtCKA7K4rdN
	 LuQXkmHgWLa7Qr0ET8lRZjnWpyBaTFVHO4jIxg5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Preece <apreece@meta.com>,
	Vlad Poenaru <vlad.wing@gmail.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/816] bnxt_en: Dont keep MSI-X vectors added before FW reserves them
Date: Wed, 25 Nov 2026 15:27:44 +0100
Message-ID: <20261125143851.896692025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Poenaru <vlad.wing@gmail.com>

[ Upstream commit af449230bd8de936d6e4f759240e787b9aad7cc0 ]

When dynamic MSI-X is supported, bnxt_check_rings() grows the MSI-X
vectors with bnxt_change_msix() once FW says the new rings would fit,
and keeps them.  FW only reserves the extra IRQs later, when
bnxt_reserve_rings() calls __bnxt_reserve_rings().  The MSI-X table
entries beyond the function's reserved IRQs are not backed until then:
the MSI message written when the new vectors are activated is lost, and
the entries read back as zero.  After FW reserves them they are live but
still zero, so the NQ rings bound to them signal address 0 and every
completion on those rings is lost.  The next ring change (for example
ethtool -G) then times out freeing each of those rings and the TX
watchdog fires:

  bnxt_en 0002:01:00.0 eth0: Resp cmpl intr err msg: 0x51
  bnxt_en 0002:01:00.0 eth0: hwrm_ring_free type 1 failed. rc:fffffff0 err:0
  ...
  bnxt_en 0002:01:00.0 eth0: NETDEV WATCHDOG: CPU: 17: transmit queue 18 timed out 5716 ms

On x86 this is hidden: GENERIC_IRQ_RESERVATION_MODE makes the PCI MSI
domains MSI_FLAG_MUST_REACTIVATE, so the message is composed and written
again when the IRQ is requested, after FW has reserved the vector.
Since commit 0d6a7c417983 ("irqchip/gic-v3-its: Enable dynamic MSI-X
allocation"), arm64 GICv3 systems take the dynamic path as well, but
write the message only once, at allocation.  On an NVIDIA Grace system
with a BCM57508, raising the channel count from 18 to 32 left MSI-X
entries 18-31 all zero, and the 14 rings using them lost their
interrupts.

Keep the allocation in bnxt_check_rings() as a check that enough vectors
are available, but free the new vectors again right away when FW manages
IRQ reservations (BNXT_NEW_RM).  bnxt_reserve_rings() then allocates
them after __bnxt_reserve_rings() has reserved them.  Without
BNXT_NEW_RM there is no IRQ reservation and bnxt_reserve_rings() does
not grow the vectors, so keep the current behaviour there.

In bnxt_reserve_rings(), size that allocation from the rings FW actually
reserved (bnxt_get_num_msix()) instead of the count computed before the
reservation, so that a partial grant does not activate unreserved
entries either, at least while no RoCE driver is registered.

The allocation can now fail after FW has committed the reservation.  A
later open would then find nothing to reserve and return before growing
the vectors, and bnxt_request_irq() would use irq_tbl[] entries past
bp->total_irqs, which still hold the freed virqs.  Grow the vectors in
that case as well, and clear irq_tbl[].vector when trimming.

Fixes: 2d51eb0bd81c ("bnxt_en: Add MSIX check in bnxt_check_rings()")
Reported-by: Andrew Preece <apreece@meta.com>
Closes: https://lore.kernel.org/all/20261022193620.2152038-1-vlad.wing@gmail.com/
Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 34 ++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f30777268a59a..5d6f24044fb63 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10947,6 +10947,7 @@ static int bnxt_change_msix(struct bnxt *bp, int total)
 		map.index = i - 1;
 		map.virq = bp->irq_tbl[i - 1].vector;
 		pci_msix_free_irq(bp->pdev, map);
+		bp->irq_tbl[i - 1].vector = 0;
 		bp->total_irqs--;
 	}
 	return bp->total_irqs;
@@ -11124,8 +11125,23 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 	int irqs_required;
 	int rc;
 
-	if (!bnxt_need_reserve_rings(bp))
+	if (!bnxt_need_reserve_rings(bp)) {
+		/* FW may already hold the reservation from an earlier
+		 * reservation that was not followed by growing the dynamic
+		 * MSI-X vectors, e.g. because the allocation failed.
+		 */
+		if (irq_re_init && BNXT_NEW_RM(bp) && bp->irq_tbl &&
+		    pci_msix_can_alloc_dyn(bp->pdev)) {
+			irqs_required = bnxt_get_num_msix(bp);
+			if (irqs_required > bp->total_irqs &&
+			    bnxt_change_msix(bp, irqs_required) != irqs_required) {
+				netdev_err(bp->dev, "Unable to allocate %d MSIX vectors, maximum available %d\n",
+					   irqs_required, bp->total_irqs);
+				return -ENOSPC;
+			}
+		}
 		return 0;
+	}
 
 	if (BNXT_NEW_RM(bp) && !bnxt_ulp_registered(edev)) {
 		int ulp_msix = bnxt_get_avail_msix(bp, bp->ulp_num_msix_want);
@@ -11151,6 +11167,10 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
 	} else if (irq_change && !rc) {
+		/* Size the vectors from what FW actually reserved, which
+		 * can be less than what was requested.
+		 */
+		irqs_required = bnxt_get_num_msix(bp);
 		if (bnxt_change_msix(bp, irqs_required) != irqs_required)
 			rc = -ENOSPC;
 	}
@@ -14181,6 +14201,7 @@ int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 			hwr.cp = min_t(int, hwr.cp, bnxt_get_max_func_irqs(bp));
 		}
 		if (hwr.cp > bp->total_irqs) {
+			int old_total = bp->total_irqs;
 			int total_msix = bnxt_change_msix(bp, hwr.cp);
 
 			if (total_msix < hwr.cp) {
@@ -14188,6 +14209,17 @@ int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 					    hwr.cp, total_msix);
 				rc = -ENOSPC;
 			}
+			/* FW has not reserved the new vectors yet, and writes to
+			 * MSI-X table entries beyond the reserved IRQs don't
+			 * stick (seen on BCM57508).  Free them again;
+			 * bnxt_reserve_rings() allocates them after
+			 * __bnxt_reserve_rings().  Without the new resource
+			 * manager there is no IRQ reservation and
+			 * bnxt_reserve_rings() does not grow the vectors, so
+			 * keep them.
+			 */
+			if (BNXT_NEW_RM(bp))
+				bnxt_change_msix(bp, old_total);
 		}
 	}
 	return rc;
-- 
2.53.0



