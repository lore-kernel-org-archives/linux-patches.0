Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059692;
	b=a5//qz8uQDmI68BeuXge917kISRjEtGYGef6G1lZnFrJtThNq1ZtTpnud8rbXLKR5iPg
	 MK1DFcOvK4at0LrStzoxmpmmXiaGATQms5ITYbUAS0kuyiVyoqZmCmHdabz6F2hS3ejGb
	 rM1p9ANwt6pZ+GOk7FkbtEWl2hfjfb28XeGz4ulFvTvZ+vZn9+qHovK8WNfHBtHEHFgH2
	 XLW4LplR4hrVES3Dz2AeZKwj5yQVkZd3chvCerLVYflHDs6fHy9oypbOi0BypO9BPVnbH
	 viZDFFDuGr2rH5WGy8IoPJXvVQYKRchccRQushZaU/33nSH9dwccPX1x2fVFDS9e39w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NNleXgr9LLJUFa3kDo5RQ5EVAaLQHxaUzSeBuzSi9Oo=;
	b=Q/OH3Z3OwjYlgt8CbaYtSDLdKUrCDnyeeVZhAXiCOFSDNkOBQtSEW4rqtFQBJJ0r0qJB
	 Qe3zPwSofFfNnZnzWA5qXUQ/rUwuc4/6HKfQEW0HMGAwcApgsl3B3PPDZLUVv5ub4a8yP
	 HC+1WhScdwt37qkI1TtmZYqxXlYoS8gx20hEZ6xBdPXRxrrZ8v40drR3O4D4b0zMCbsAB
	 rNcqixMoKBabTVvdsA3Asw4N1+mQhqI7l56MkY2PzMjO0b8vQmPdmieeq3kqCLdj1v2nd
	 mWDhSA6pdTvJHchKVd+FUPV5Hva446mmEM0GQZdllbMjvkQd/sYlWnHcTRA7sBd6y+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=imJQ3AkU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4D0606A334;
	Thu, 19 Nov 2026 03:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=imJQ3AkU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED301F000C4;
	Thu, 19 Nov 2026 03:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059691;
	bh=NNleXgr9LLJUFa3kDo5RQ5EVAaLQHxaUzSeBuzSi9Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=imJQ3AkUIBgW2XOQtDvxSEm3IxxByKMiI5SLO0B1aznzSVhvvuXFD8qhagcVIpphN
	 N8pQRIY41O6BNTsS5/X1g+wLJcpLIFMaqCSBLKGbHYxgAAOa3oaHae4IXQx/l2q6S9
	 T6xnjwRhsv486woWG4kEJ9Plcv4lBegeeMI4iKtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0891/1848] KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded
Date: Wed, 18 Nov 2026 15:48:49 +0100
Message-ID: <20261118145953.810249328@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 22b6557ad05bf05c73246f62c19af3e04017270e ]

IN_GUEST_MODE is advertised too late, when state has already been moved
onto CPU registers and cannot be observed by another CPU anymore.

Move the IN_GUEST_MODE publication ahead of the state being loaded, and
immediately check for pending request. This ensures that there is no
window of opportunity for another CPU to observe OUTSIDE_GUEST_MODE and
yet for state to be loaded.

This also simplifies the "state rollback", which solely amounts to
synchronising the timer when no irqchip is present.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-4-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: adapted guest-entry changes to existing inline exit checks instead of kvm_vcpu_exit_request() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 528229636c635..ccf31a749c827 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -716,8 +716,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
-		kvm_vgic_flush_hwstate(vcpu);
-
 		/*
 		 * Exit if we have a signal pending so that we can deliver the
 		 * signal to user space.
@@ -747,22 +745,27 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * interrupts and before the final VCPU requests check.
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
 		 * Documentation/virt/kvm/vcpu-requests.rst
+		 *
+		 * Requests to self must be posted before this point, or
+		 * won't be taken into account until the next exit. No state
+		 * loading other than what happens at vcpu_load() time can
+		 * be done before we have checked for pending requests.
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
-			isb(); /* Ensure work in x_flush_hwstate is committed */
-			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
 				kvm_timer_sync_user(vcpu);
-			kvm_vgic_sync_hwstate(vcpu);
 			local_irq_enable();
 			preempt_enable();
 			continue;
 		}
 
+		/* From here onwards, we are commited to entering the guest */
+		kvm_vgic_flush_hwstate(vcpu);
+
 		kvm_arm_setup_debug(vcpu);
 
 		/**************************************************************
-- 
2.53.0



