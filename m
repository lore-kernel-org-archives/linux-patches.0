Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026880;
	b=GQ0MxUIb6z1NAt9NKXIb55/3Wv7U8yahWOciLTDXr0742dYgpF+wf47SiT2HphZD0PmD
	 /Kzzwq2LsnFZTJuSmKSwVXXhohbOzcrGZ4KQq6u6Frns2ayNAtCgUedGSHr33jxyTAM2Z
	 AFY6nnlxOGoK6bNv/zmN+IlMUF1367Iw1XoLBgyyxCcjInjiJZt4AN5khjQU4CCd7Vqb6
	 Leszvo4XydfMFi/Mgv4AUcaSF/b8OlWJSOkgdwICl4KRznimG5fXYOsm4lipNjWTJKEHu
	 ZFSGJsID50LP2iTfJ2vI9iHVH0r2+W0PTQBK2J4Wk0IJkJW/qnyYmf4vPR2RxCNeSUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3KyMY4iIRFRqRoU4DHkHvOdnGSGmPReb3W449Nm2BXc=;
	b=cQlsbuT7x3QsaP3r4IO4OrIr+iUG4zIUVerHRxCetoQJNeR18y464TpGzX2Xf5WSnHds
	 K/9ezaMk8vPrCfO40KzgRK5BKgXgZqTeykUyegKNbWSTYe0CKL43Dm7y0GTbdvBLKDnCL
	 OT2Sl68vQrnbA3VCc7lWakOeAYvWqHXpBw6pb4kEqQWLX2AVNYvKYnTViZYDW80wEsip9
	 m+uzkgqz1GwJKciFgScmrkPOhhqQ3lzi8pWwN0xgkNOIOD91OAH/p46vlpbcrcAV3A13k
	 ixePLwwzB83yXFHX9RWSZ/hJazt7l2AH3CNLfKRDoWPrD2bFMyBKixxsaxeBO0sEy+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JO7uPNF6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04184606A31C;
	Wed, 18 Nov 2026 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JO7uPNF6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADEF1F000C4;
	Wed, 18 Nov 2026 18:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026879;
	bh=3KyMY4iIRFRqRoU4DHkHvOdnGSGmPReb3W449Nm2BXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JO7uPNF6O0UX5DXf2v1LYKcEVPzq70Z3+KdhF33r5gS3pR12sFy7eV+HxZ4dakkG2
	 fUoaq6iW3/prGKsZr/0p9XpPWCDVX6wLgjwPkC85H6iUpewU36JHLPeiXEsl86t9wB
	 LmAS/K8MUk4VHS/BVAv4bH93Ny29IqbFjVTsz9Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1591/2151] irqchip/mips-gic: Transfer interrupt mask state across clusters
Date: Wed, 18 Nov 2026 15:55:26 +0100
Message-ID: <20261118150219.840157338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



