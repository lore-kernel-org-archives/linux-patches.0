Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028769;
	b=wZG/f9+rs9r5RK6NMm/KCbAvSm9h1HJRLG3B+b6FrfbzY0UuS8LRixWqyDWqfSkTV0ak
	 JbEwmoZ3wbGxCrQ/qzsByj+YUcBgASxFENjcVJwCXck7waf5teZgY50esPr9Iz66xwgXF
	 t4/ml5JzYI72vIuJFqm+N9XztDYGy5VdzDH7JAMgoCCQStwXOVkY6xwyiIEkljupJkoZC
	 3Rv1fSiUcRSD3f3SRR7kBia3ahajbLQ5rVm+6N1fuamAXVBJLWz5RAfnmhhpl4Fzu45fS
	 oMNNs+jj0gEkoYDtgw5RjZoK7ytSAOsxIJNoN7KWoNIF1C5qV4QxCkcQ2qcrleKikiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CUvRLm/DYmFu963IJxvvuOO3rcbNcNk8UVC24sTa4q8=;
	b=aBW2CIUepwEMSzyfKRZLTN6aO/hp//HPwFXokynetTpgPqUJj3TNshD9nA5XXKEGVNy5
	 YBLK7c9iX/wzRAOMEdWph2wUp6wHpk6YBHQH1Fdnw8yICdn0qccVKP4EMWtm10U6OyBIy
	 ZCteXm6OtvrscYhq6A9liN9h2fIeNzCxusDy3e9db7Kge/0LVi1wZmpemfpx6NlH6AtB4
	 Zx3c9d0RvRSySissB1oqREZ3qVDEYwN4lbtiDTzYfeQnOZMeaAjCL/Bw1MWSKnTzIKtTC
	 SgZ1mrIm+9NlZ+Hoom4XznfNuVXHXl9B1btyznzkjeKgl9WMK8MNUDXXaq7TU3diIfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X1kseYI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F49606A339;
	Wed, 18 Nov 2026 19:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1kseYI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAE41F000C4;
	Wed, 18 Nov 2026 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028769;
	bh=CUvRLm/DYmFu963IJxvvuOO3rcbNcNk8UVC24sTa4q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1kseYI/sj2S06VhVABtfMv+imzMhLlm5mPtfuAjUHJn1SEGQBu+/Z5mo3aqhjvbQ
	 69wjZMrxls/OiFgIF1E4G0W8/xEkqhTwPu4Sw5ysz4JhX+Mw4nZxb1o0/80tShduEz
	 u4bw9UaOSq4YWbGEUyQD8vU09fwh/N4EpZlLIi/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0072/1756] KVM: arm64: vgic-its: Dont map an LPI from more than one event
Date: Wed, 18 Nov 2026 15:36:39 +0100
Message-ID: <20261118150011.179151542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit de81b28f0b83b22163d7d9a9b708d7aa912e0ef7 ]

KVM keeps one vgic_irq per LPI. A MAPTI of an LPI whose vgic_irq
already exists reuses it for the new ITE and leaves its target vCPU as
it was. Mapping one LPI from two events is UNPREDICTABLE (IHI 0069H.b,
5.2.10), but nothing stops a guest from doing it. If the first MAPTI
names a collection the guest never maps and the second a mapped one,
the LPI translates through the second event with a NULL target vCPU.

When the VMM routes an assigned device's MSI to that event on a host
with GICv4 enabled, kvm_vgic_v4_set_forwarding() takes the vPE from the
NULL target vCPU and the host oopses:

  Unable to handle kernel paging request at virtual address 0000000000001980
  [...]
  Call trace:
   its_build_vmapti_cmd (drivers/irqchip/irq-gic-v3-its.c:943) (P)
   its_irq_set_vcpu_affinity (drivers/irqchip/irq-gic-v3-its.c:1380)
   irq_set_vcpu_affinity (kernel/irq/manage.c:670)
   its_map_vlpi (drivers/irqchip/irq-gic-v4.c:326)
   kvm_vgic_v4_set_forwarding (arch/arm64/kvm/vgic/vgic-v4.c:485)
   kvm_arch_irq_bypass_add_producer (arch/arm64/kvm/arm.c:2977)
   irq_bypass_register_consumer (virt/lib/irqbypass.c:44)
   kvm_irqfd (arch/arm64/kvm/../../../virt/kvm/eventfd.c:496)
   kvm_vm_ioctl (arch/arm64/kvm/../../../virt/kvm/kvm_main.c:5270)

Track in each vgic_irq whether an ITE maps it. Drop a MAPTI of an LPI
that is already mapped, as a failed MAPTI already is. Restoring the ITS
tables keeps the first ITE it reads for each LPI and drops any later
one, so a guest saved with a double mapping still restores. Key the
check on the mapping, not on the vgic_irq. A vgic_irq outlives its ITE
while anything holds a reference to it, such as the vCPU it was last
queued on. A later MAPTI of such an LPI succeeds as before, and now
retargets it to its collection.

Fixes: 196b136498b35 ("KVM: arm/arm64: GICv4: Wire mapping/unmapping of VLPIs in VFIO irq bypass")
Suggested-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20261013081646.933312-2-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: added the missing irq_lock cleanup while retaining the unmap WARN_ON() and defining mapped as a plain bool. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 37 +++++++++++++++++++++++++++++-----
 include/kvm/arm_vgic.h         |  1 +
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e13e25dddd528..cff18e79a3ac5 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -786,12 +786,18 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 /* Requires the its_lock to be held. */
 static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 {
+	struct vgic_irq *irq = ite->irq;
 	list_del(&ite->ite_list);
 
 	/* This put matches the get in vgic_add_lpi. */
-	if (ite->irq) {
-		if (ite->irq->hw)
-			WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
+	if (irq) {
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->hw)
+				WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
+
+			irq->hw = false;
+			irq->mapped = false;
+		}
 
 		vgic_put_irq(kvm, ite->irq);
 	}
@@ -799,6 +805,23 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 	kfree(ite);
 }
 
+/* Mapping one LPI from two events is UNPREDICTABLE: the first ITE keeps it. */
+static bool vgic_its_map_lpi(struct kvm *kvm, struct its_ite *ite,
+			     struct vgic_irq *irq, struct kvm_vcpu *vcpu)
+{
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+		if (!irq->mapped) {
+			irq->mapped = true;
+			irq->target_vcpu = vcpu;
+			ite->irq = irq;
+			return true;
+		}
+	}
+
+	vgic_put_irq(kvm, irq);
+	return false;
+}
+
 static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 {
 	return (le64_to_cpu(its_cmd[word]) >> shift) & (BIT_ULL(size) - 1);
@@ -1108,13 +1131,14 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		vcpu = collection_to_vcpu(kvm, collection);
 
 	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
+	if (!IS_ERR(irq) && !vgic_its_map_lpi(kvm, ite, irq, vcpu))
+		irq = ERR_PTR(-EEXIST);
 	if (IS_ERR(irq)) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
 		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
 	}
-	ite->irq = irq;
 
 	return 0;
 }
@@ -2223,7 +2247,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
 	}
-	ite->irq = irq;
+
+	/* Drop an ITE whose LPI another ITE maps, as MAPTI does. */
+	if (!vgic_its_map_lpi(kvm, ite, irq, vcpu))
+		its_free_ite(kvm, ite);
 
 	return offset;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f5172549f9ba0..6c2b1ac1e9671 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -139,6 +139,7 @@ struct vgic_irq {
 	bool active;			/* not used for LPIs */
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
+	bool mapped;			/* LPIs: mapped by an ITE */
 	struct kref refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
-- 
2.53.0



