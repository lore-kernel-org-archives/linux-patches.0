Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020439;
	b=TLlu8apwXZPAr/tFjHP8cP1a8TO/9eORCCqFoRMAAcc4AeGIzJlWHgFHuxQwi6qL4M+z
	 GmMdtk/TKXSHa+T3mMlmogewrOkpe7/q36xvIo9ePR70ukfNy1sU3668ty0NpYRbbA+cg
	 reu46Wj1xhO2oQcpJme2kq+gpdjxe1hofeLHwzbjw1FAPJrWAOv6wXTsa0Fp8sNH+hNdw
	 wmkMSDRHwpaueFgzl1KL6ZrFZjs+UMC50YpRHGGM9jzxITXkA9AUvy0seDVT0MmZ4A+nG
	 XkVgWierV8HEGNjVr5sEte+c/cUwJVGbrITrUGvaZIMdXGGXBRFJeLUvnxFnUNVDYZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jiUd/b83nLlMCwJPVSnVTU+rV7Y3O/XNnawgLkecrX4=;
	b=wuydZ6L9qYYIIcbDg8uEiJsTI2/EqyEg3wD/Xlv+2rrCFNwo+04dMB5hcCsGYDNLRLSN
	 A+nsZmzKjS/8IY4/pMy8vmOxODS/Tlk18mG2YPz0+bzAIbQ60qxelGyumAhys2kxAePKs
	 0M/yiS35bQOGHVmEwQHvX0HHBAedHBJBd2+/fw9NwznGQyTZXzDjoOEdtAKQ8o/qEGw5M
	 rAr51KLZCgiSYlGpGvCV+MMAFmoAH1Te4nT4ZpVoDWFVK3wGsQE0r/mVVLsSE6UFvJ5+Q
	 iatIvcSAfJbl4NqcAF5UQmf7/ns1s/mSsNcvoDjgC+7aqQBZnhwLEzCdlQV11tAuBRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAMBtGP3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17531606A330;
	Wed, 18 Nov 2026 16:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAMBtGP3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682EA1F000C4;
	Wed, 18 Nov 2026 16:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020439;
	bh=jiUd/b83nLlMCwJPVSnVTU+rV7Y3O/XNnawgLkecrX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HAMBtGP3t4cNJ9P8BWvtJM4TFm5FVXsKPcKngrvPPOmBZVPfuxxPJs0USWrRAVCYD
	 T3zbC6tp0dw/od7avfnXVpyMxc2C3BYe56fy1TzMo/UqUcCUeKQRcgtIv+hkRmk7I4
	 t+Wf7QQEv7AArnY5dVSdfqy0LJ0HyJkdc/B0Xtd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1951/2651] irqchip/mips-gic: Transfer interrupt mask state across clusters
Date: Wed, 18 Nov 2026 15:53:11 +0100
Message-ID: <20261118150356.810013760@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Monin <benoit.monin@bootlin.com>

[ Upstream commit a5f0dc656e89d0eb140547823a36212902cdf673 ]

When an interrupt's affinity is moved to a CPU in another cluster,
gic_set_affinity() updates the routing (GIC_SH_MAP_VP) and trigger type
in the destination cluster, but never touched the interrupt's mask state.

The interrupt mask is per-cluster. After such a move the interrupt may
be left disabled in the destination cluster, so it never fires despite
being correctly routed to its new VP.

Move the mask state along with the interrupt: disable it in the old
cluster while clearing the route so it is no longer delivered, then
configure the trigger type in the new cluster and re-enable it there
if it was enabled in the old cluster.

Fixes: 322a90638768 ("irqchip/mips-gic: Multi-cluster support")
Signed-off-by: Benoît Monin <benoit.monin@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Link: https://patch.msgid.link/20260929-sync-gic-counters-v4-3-ec70c4b60434@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index f2ae60d39d66d..be38989d8e73e 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -368,6 +368,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 	unsigned int irq = GIC_HWIRQ_TO_SHARED(d->hwirq);
 	unsigned int cpu, cl, old_cpu, old_cl;
 	unsigned long flags;
+	bool enabled;
 
 	/*
 	 * The GIC specifies that we can only route an interrupt to one VP(E),
@@ -389,15 +390,20 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 	raw_spin_lock_irqsave(&gic_lock, flags);
 
 	/*
-	 * If we're moving affinity between clusters, stop routing the
-	 * interrupt to any VP(E) in the old cluster.
+	 * If we're moving affinity between clusters, save the interrupt's
+	 * mask state, stop routing it to any VP(E) in the old cluster and
+	 * disable it there so it is no longer delivered.
 	 */
 	if (cl != old_cl) {
 		if (gic_irq_lock_cluster(d)) {
+			enabled = read_gic_redir_mask(irq);
 			write_gic_redir_map_vp(irq, 0);
+			write_gic_redir_rmask(irq);
 			mips_cm_unlock_other();
 		} else {
+			enabled = read_gic_mask(irq);
 			write_gic_map_vp(irq, 0);
+			write_gic_rmask(irq);
 		}
 	}
 
@@ -409,10 +415,20 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 
 	/*
 	 * If we're moving affinity between clusters, configure the interrupt
-	 * trigger type in the new cluster.
+	 * trigger type and, if it was enabled in the old cluster, enable it
+	 * in the new one.
 	 */
-	if (cl != old_cl)
+	if (cl != old_cl) {
 		gic_set_type_locked(d, irqd_get_trigger_type(d));
+		if (enabled) {
+			if (gic_irq_lock_cluster(d)) {
+				write_gic_redir_smask(irq);
+				mips_cm_unlock_other();
+			} else {
+				write_gic_smask(irq);
+			}
+		}
+	}
 
 	/* Route the interrupt to its new VP(E) */
 	if (gic_irq_lock_cluster(d)) {
-- 
2.53.0



