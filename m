Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062177;
	b=HXpLzX9mE4dn/Z/Ifvx0MKU3QRs90v79eHWXsB3CgXgwmM/frHoii4xhcUEvJzNoRMIp
	 EpkakTX83yx0V8XDjHr2B8yLCeiO9c8K+2N0bpQ7+3anNLCut52LfM6jO9ROrCjGGCfJN
	 9l3K9ZAmIA8s8g8md1bI9j3QqJhRVmDNOlvdxgJVynIl31v5gx6D2Z/YKIVsjGxV3OooT
	 fGoLqyPe4mBKjuvhbDzt5zau7wYni3/jJWLhHWMWJdQWggwIYZ3f2BqIsz8v7WJU0Bc6s
	 /UD7xTLbyfa0skGyiOYyLtgRsAkt6ia3bCbf3p26EhT+PHRGQTYJcxKMMhDwnxsaGJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CY+rwDJaCsoehkksMsJdJJfGvsl4oWYlhGx1qclJjUQ=;
	b=AXhX7/7ZgkRjAEXFhWH0BwxahmEWCfHQS6pRoaBJwGZEs2C8gepGUI56zLZmlTloLaNV
	 zrQJ8zQXp32pWf9WIfoM7dVKbwcjlQcaz3HujrNvaRhoni9I7QCT9D7AoFg0QJgLGZPgb
	 d/UC7/KGLK4M6iUW2+CLP+2PVqaz2yVFXWTOmn41zxjfu+TjaxOO/ZA7apOr0wBbvO6U6
	 tMtp8GUuQxcx0SihbDopuI8u4KLE3pctdoo0urePw4fBNbmlM4hWj4VBz3u7RyecfVRvC
	 j45GDqZ9X0JNBH2hvpYcle9qxRiKSe+C61jbKAmWvHPjIK+beyHMhDLLvgfliIFMEUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+Af1WkA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BA8606A326;
	Sat,  7 Nov 2026 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+Af1WkA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E56B1F008A4;
	Sat,  7 Nov 2026 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062177;
	bh=CY+rwDJaCsoehkksMsJdJJfGvsl4oWYlhGx1qclJjUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+Af1WkAvM0uFU4it/Fxng60J260SIpSQ2loUMzJuYPLYNWkPQkaiVQVdiGDJBv+k
	 86IRBoU84LbtCbdsdlWworEVOjvyHufoYCdiGxz2KHMli9hDx72nMYX9BP66tDWq1k
	 K3/fvo3DNdvQkr+WM951e+24wkdDwNK8x8mPH6YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1137/1536] KVM: arm64: vgic-v3: Roll back assignments from the new region
Date: Sat,  7 Nov 2026 08:52:33 -0500
Message-ID: <20261107135029.649841492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a32c01324eb494dda811912eb847b0e907cd7270 ]

A failed REDIST_REGION write unregisters the redistributor iodevs of every
vCPU processed before the failure. This includes vCPUs assigned to older
regions. Their assignments remain cached, so a retry does not register the
iodevs again.

The vCPU whose registration fails has no assignment to roll back. For vCPUs
processed earlier, limit rollback to those assigned to the new region. The
region is removed on failure, so its free_index does not need restoring.

Resetting assignments from older regions is unsafe because a vCPU can own
one before kvm_for_each_vcpu() can see it. Rollback could then move
free_index behind that live assignment.

kvm_vgic_addr() holds slots_lock across the REDIST_REGION write. vCPU
creation takes the same lock before assigning a redistributor. A concurrent
vCPU cannot acquire an assignment from the new region before rollback
completes. The lock also keeps rdreg valid across the config_lock drop
required by MMIO-bus registration.

Fixes: c011f4ea106b ("KVM: arm/arm64: Check vcpu redist base before registering an iodev")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260831081005.41346-3-kmehltretter@gmail.com
[maz: moved helper into the sole caller]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index eddc70e519290..6e157b0b21adf 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -819,7 +819,8 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
 }
 
-static int vgic_register_all_redist_iodevs(struct kvm *kvm)
+static int vgic_register_all_redist_iodevs(struct kvm *kvm,
+					   struct vgic_redist_region *rdreg)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long c;
@@ -839,7 +840,14 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 
 		for (i = 0; i < c; i++) {
 			vcpu = kvm_get_vcpu(kvm, i);
+			if (vcpu->arch.vgic_cpu.rdreg != rdreg)
+				continue;
+
 			vgic_unregister_redist_iodev(vcpu);
+
+			guard(mutex)(&vcpu->kvm->arch.config_lock);
+			vcpu->arch.vgic_cpu.rdreg = NULL;
+			vcpu->arch.vgic_cpu.rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 		}
 	}
 
@@ -948,10 +956,13 @@ void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdre
 
 int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 {
+	struct vgic_redist_region *rdreg;
 	int ret;
 
 	mutex_lock(&kvm->arch.config_lock);
 	ret = vgic_v3_alloc_redist_region(kvm, index, addr, count);
+	if (!ret)
+		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
 	mutex_unlock(&kvm->arch.config_lock);
 	if (ret)
 		return ret;
@@ -960,12 +971,9 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	 * Register iodevs for each existing VCPU.  Adding more VCPUs
 	 * afterwards will register the iodevs when needed.
 	 */
-	ret = vgic_register_all_redist_iodevs(kvm);
+	ret = vgic_register_all_redist_iodevs(kvm, rdreg);
 	if (ret) {
-		struct vgic_redist_region *rdreg;
-
 		mutex_lock(&kvm->arch.config_lock);
-		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
 		vgic_v3_free_redist_region(kvm, rdreg);
 		mutex_unlock(&kvm->arch.config_lock);
 		return ret;
-- 
2.53.0



