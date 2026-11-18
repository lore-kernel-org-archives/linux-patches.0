Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060055;
	b=bZtUSHlc4ye8HUdFH4EFJvubE4mtQmSXM92d+zY0q0N1R8yUZkb6jAU5NPrh3wS+8aiX
	 niAAsxCBk56t2wY3Xrs2AwQJSDWgaEw/V8O3OQ+KjYxUXf4ClyMADFkIOkYG9hbadcHVU
	 TMqH1R2yHZJBzlWM1/0lVUbaEdZHw12r2juXYRbmUh/Fl24b4KeuwqSyHvwAq6Y3EZo1Y
	 Q/3NYOYl2999qiLgn9G19Q35oUSQu1KxTZjkqsUhBvG2/ljFhcomYrslVpXvmFNF5qdzh
	 4/oguIeVL38ZW4qdISMYfKfgeQyOox08aLUW0i2cqS3FrVY/r2YwaAXh3kE3O5Es5+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1aiV2GRZcdo3uJTSp2ku5qhxsiaXQCKxHws7kRdG8Yg=;
	b=su+1VcuZNQHRcR/uWnrFLGp1y8xG5M3Qn1Y9IkGJp+YXBbOuSvvmBEtgUPX5x0BwM3nd
	 SHXh3D1xOUudH9Dy+D1DnE/+qi3lGT8TxrGRDzhtQc/VfEZRyu+VmgJkixwNfHZzJiOLN
	 T1m+MlyVK/DcdKoGe86HAVhm6HUHKHTRsB/pz5jB/lf85KDCEQDNPioI1p2bDGPbGjASU
	 Qg1QIoe1zJNHe/k+yq0CPxXQIh9XfF4AqwGxjfdiOF5MsxndE0dAQPat9J5uPPcB+BkYB
	 B3jcKiHG5/ISBAAQLorl8oMFgbVOYRGW7PdvbcvV/S7mR+HmxWmVH6l+gXT5k2PwR+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJxFhURn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826A0606A320;
	Thu, 19 Nov 2026 03:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJxFhURn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB0A1F000C5;
	Thu, 19 Nov 2026 03:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060055;
	bh=1aiV2GRZcdo3uJTSp2ku5qhxsiaXQCKxHws7kRdG8Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJxFhURnohZt9fKIO+9btmkGkeptufjTi6K64Hl9qmBXNOBXtyNua6aDa4RXZJeQ2
	 FtzE6EGkaVdkno7safl+ijr5oevQIM4UieluSAO6vcNaGN4VKqGdHbKAKiiRsyzeNa
	 1wCe9kWbFVEovYwRJcMAS++VsPSyD3/hAojs27iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1060/1848] KVM: arm64: vgic-its: Dont map an LPI from more than one event
Date: Wed, 18 Nov 2026 15:51:38 +0100
Message-ID: <20261118150001.893458675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the scoped_guard-based mapping helper with inline code using explicit raw spinlock calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 40 ++++++++++++++++++++++++++++++++--
 include/kvm/arm_vgic.h         |  1 +
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 07b8ca72111f3..15f3afc71b9d1 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -821,13 +821,20 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 /* Requires the its_lock to be held. */
 static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 {
+	unsigned long flags;
+
 	list_del(&ite->ite_list);
 
 	/* This put matches the get in vgic_add_lpi. */
 	if (ite->irq) {
+		raw_spin_lock_irqsave(&ite->irq->irq_lock, flags);
 		if (ite->irq->hw)
 			WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
 
+		ite->irq->hw = false;
+		ite->irq->mapped = false;
+		raw_spin_unlock_irqrestore(&ite->irq->irq_lock, flags);
+
 		vgic_put_irq(kvm, ite->irq);
 	}
 
@@ -1074,6 +1081,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
 	struct vgic_irq *irq;
+	unsigned long flags;
 	int lpi_nr;
 
 	device = find_its_device(its, device_id);
@@ -1114,13 +1122,27 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
+	if (!IS_ERR(irq)) {
+		/* Mapping one LPI from two events is UNPREDICTABLE: the first ITE keeps it. */
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		if (!irq->mapped) {
+			irq->mapped = true;
+			irq->target_vcpu = vcpu;
+			ite->irq = irq;
+		}
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+		if (!ite->irq) {
+			vgic_put_irq(kvm, irq);
+			irq = ERR_PTR(-EEXIST);
+		}
+	}
 	if (IS_ERR(irq)) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
 		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
 	}
-	ite->irq = irq;
 
 	return 0;
 }
@@ -2186,6 +2208,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	struct vgic_irq *irq;
 	u32 coll_id, lpi_id;
 	struct its_ite *ite;
+	unsigned long flags;
 	u32 offset;
 
 	val = *p;
@@ -2219,7 +2242,20 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
 	if (IS_ERR(irq))
 		return PTR_ERR(irq);
-	ite->irq = irq;
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	if (!irq->mapped) {
+		irq->mapped = true;
+		irq->target_vcpu = vcpu;
+		ite->irq = irq;
+	}
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* Drop an ITE whose LPI another ITE maps, as MAPTI does. */
+	if (!ite->irq) {
+		vgic_put_irq(kvm, irq);
+		its_free_ite(kvm, ite);
+	}
 
 	return offset;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 92348c085c0c7..7c2a70265aac2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -113,6 +113,7 @@ struct vgic_irq {
 	bool active;			/* not used for LPIs */
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
+	bool mapped;			/* LPIs: mapped by an ITE */
 	struct kref refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
-- 
2.53.0



