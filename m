Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022620;
	b=x5ps2A6+ooO73PklBGSdtfS3/MWJY4L4AFG43Vpbhz1C5y9MC0c8W567H9DyAroBI9gJ
	 VD8/l/glCereuNFz+iafBZU8WqD1cak7xcN7aDnrHYg/H6AkOOchpCSc9jjtniQK2nC9e
	 zdh5DP9AcwFeHOCjHr5sW2Qocfz5efHyjzxQHxzpgj88MM81keUWgwRx9nBdeGxBrPv+h
	 ARnnJUeIg40/dnfOjBJzUP/2H1KhgxaUMkqVDV+Nn8qtCdajrwFs1/WEyx0JtthD1qoz0
	 xIfLT1nRRx2In/jFkFO0Kyego70jqwQEHyOfia1XHrHPbidH5zgwwuzFiyiy4Q6ATIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iWpjLQLFiz4rgubR8oF78vK4vsDJZhVjpd/W6caYegk=;
	b=fa5H1lRZ0N/ryuvmwXzmiBYN4d6Rvzizg0OXNoqCBsLyCbsXfblV8UR9l7glgG/V7PZ6
	 8hSTFQAHPERY8RiZPKnUgyChY0zQjk6y5Pgvu5z5AXpn624c9DP910gQdVt6uBdEqzL/v
	 Vc9KBA9Aek2ziM8QCPBr4GLyGZfOi8SahC1gq9VtZMRjF9BD2lwTVCNNnR3w6MspVZ+M+
	 tpFpNlSAUgpaKog3onLAqRc3ZYT5RtPWPB14jGaPY8Kt7sflHX90cQbWcc8MPJay7d43C
	 qo34wkGu2F1HlWm4Xxs8DtCIQXmI/1H9WjxFyMB57Hah6V8D3hc8sBK4XsvNk6w4U9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WnS4NmUK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5AB606A325;
	Wed, 18 Nov 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WnS4NmUK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD841F000C4;
	Wed, 18 Nov 2026 17:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022620;
	bh=iWpjLQLFiz4rgubR8oF78vK4vsDJZhVjpd/W6caYegk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WnS4NmUKhIyQPoQFc0x5bpyXfPFNTK51RX+hRYRthlJO+6ImdPgTflTms/yihn+NN
	 BrY0hcpY2PWwgxKb2OW/rb/CU1ykeCVv/KHDTWUU6P3t6pefoct+dNIlmYs+9UU0oQ
	 LYrIfL+bpyHsZE43VUrQNK3AmcSXwX0hHt/FEyCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0077/2151] KVM: arm64: vgic-its: Dont map an LPI from more than one event
Date: Wed, 18 Nov 2026 15:30:12 +0100
Message-ID: <20261118150124.563866622@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Changed mapped from a boolean bitfield to a plain bool to match the existing vgic_irq layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 26 ++++++++++++++++++++++++--
 include/kvm/arm_vgic.h         |  1 +
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7ce07c8eb5b7e..0f77c755b16f9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -774,6 +774,7 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 				its_unmap_vlpi(ite->irq->host_irq);
 
 			irq->hw = false;
+			irq->mapped = false;
 		}
 
 		vgic_put_irq(kvm, ite->irq);
@@ -782,6 +783,23 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
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
@@ -1091,13 +1109,14 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
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
@@ -2208,7 +2227,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
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
index 25eb6ba9dd23c..e8c00881dc218 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -142,6 +142,7 @@ struct vgic_irq {
 	bool active;
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
+	bool mapped;			/* LPIs: mapped by an ITE */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
-- 
2.53.0



