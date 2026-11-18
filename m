Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053800;
	b=tiIv9aeOFM39s4pG9LjWuFDLVSGAcDx+HS3BNwwjrO1lmjcJQKkQk4Gy5BJ4TDsgoYa6
	 8aUE0es+w3Q8jSp7TpFSmtPibLnKPDK3bsp0WQVC15t9MK0VCGQVMuFRuejc1XyIwyfUg
	 VHDpkymIAL3ujXAk7WTyaE1kMorlokCxuBF+16AKNcbS+OUqKiJyEuh/Z8tH166g8tDfd
	 2xhku7t0/HvDv/8hVX+3S6L2WS+N9jjzNtZSLVxnEdThGqfcZXfkOSIXePhNGH1AlJaW8
	 gmzpBTV7B8mvzCt6eyR2W7tkAiKaV88QyYs+HEgUvDWqyfu7DDqploInNqX2fcWefqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F1fG7YvprbTOLw8mEqEXDsmlRtqY0sFqNJH+a05pc/o=;
	b=AvKZuzjNCHToqJHOYqoFvIajrUIdTeTcQozxsXhRJap9W4twvNyY5SZLQyBMxyFrFZQe
	 RVnawmDuQJbrRdtTPwC41WKp1LDK12K5QPdHKQt7FX2e/sU7XB3y110r0dvxJlmyKtNw2
	 lpUleDDARKAxcPwxj2U148bGRrz9zmoGcOBkr3aS+4rlNiFfvEWq2uV95oAtGZrtfW0JG
	 +BTU+cV09dux81L9jn600/ewYy8RulCTF5aemFvQIe4/jGWHsNfGA9MGzh4Phm3NH1USH
	 bTvC1la+Erz5Gk3Partu4uiBFK/xY+99ecC9xzi2TRxjXLzwJlVTOCTixVsTSBnEPFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciSe6MpF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39166606A31C;
	Thu, 19 Nov 2026 02:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciSe6MpF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895611F000C4;
	Thu, 19 Nov 2026 02:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053800;
	bh=F1fG7YvprbTOLw8mEqEXDsmlRtqY0sFqNJH+a05pc/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciSe6MpF0TTWIxNiDlv4GMCiGuWqGUusmGxlbIgdJKA7NhbTsFx270kxlVEFpD6st
	 RjlER+Zf1L6Oxq2wA03q23hLsKjW3Osq86IG9dtJIPr9AJxo53QSqPXS1o/pQGx9a3
	 BS90yR+4rLJiI2hdY1tCnBM5ro7b1vv1f6e1UsbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1047/2214] KVM: arm64: vgic-v3: Roll back assignments from the new region
Date: Wed, 18 Nov 2026 15:45:23 +0100
Message-ID: <20261118150054.215094803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted rollback to the existing reverse vCPU loop protected by slots_lock and kvm->lock ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index c3c0204b3eb1e..eafdb3b3e1114 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -763,7 +763,8 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
 }
 
-static int vgic_register_all_redist_iodevs(struct kvm *kvm)
+static int vgic_register_all_redist_iodevs(struct kvm *kvm,
+					   struct vgic_redist_region *rdreg)
 {
 	struct kvm_vcpu *vcpu;
 	int c, ret = 0;
@@ -779,7 +780,13 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 		mutex_lock(&kvm->slots_lock);
 		for (c--; c >= 0; c--) {
 			vcpu = kvm_get_vcpu(kvm, c);
+			if (vcpu->arch.vgic_cpu.rdreg != rdreg)
+				continue;
+
 			vgic_unregister_redist_iodev(vcpu);
+
+			vcpu->arch.vgic_cpu.rdreg = NULL;
+			vcpu->arch.vgic_cpu.rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 		}
 		mutex_unlock(&kvm->slots_lock);
 	}
@@ -876,21 +883,21 @@ void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg)
 
 int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 {
+	struct vgic_redist_region *rdreg;
 	int ret;
 
 	ret = vgic_v3_alloc_redist_region(kvm, index, addr, count);
 	if (ret)
 		return ret;
 
+	rdreg = vgic_v3_rdist_region_from_index(kvm, index);
+
 	/*
 	 * Register iodevs for each existing VCPU.  Adding more VCPUs
 	 * afterwards will register the iodevs when needed.
 	 */
-	ret = vgic_register_all_redist_iodevs(kvm);
+	ret = vgic_register_all_redist_iodevs(kvm, rdreg);
 	if (ret) {
-		struct vgic_redist_region *rdreg;
-
-		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
 		vgic_v3_free_redist_region(rdreg);
 		return ret;
 	}
-- 
2.53.0



