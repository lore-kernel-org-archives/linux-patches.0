Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9A545A2BC;
	Fri,  9 Oct 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557362; cv=none; b=pM1rDmIPFDvgw4/VMufIIKrVP7Vtc7WablMbIu2HxHUH3R77F+oQkeKpwm30qb1tLUXOiqh6O5oH2ivYgcmqCGLJJcvCHm3PucPSufRekEDuy+o/Ozxh8TsOkjYSABW7+FBGGM70JRzgGVsD3KqcWRi7tYWWVdTDEaEUgn1E5Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557362; c=relaxed/simple;
	bh=3hS6wm0TLvaRelsvQrHdo3TzCfzVID1L0FIOOQSfGj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rishlRfnQ8V5IRVb9eYtJFhQXVumtKhiQyJsGGHo7puCsOL0lHBjKyc6PZ7d7wi8C9Hkd9Br/feHJlMSNBrVcSBcxlyPl40QV1rX+7E96itINbaBMwxv7KIw7F9UwFI61iJuGtl54PGLDDWVm1gT/KwDMzO6bbCgXGR+C4LeM4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMg11l7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMg11l7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFED51F000FF;
	Fri,  9 Oct 2026 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557361;
	bh=NHAEacThJ1xniSAwOU82g1mtZHKUjF981XvwsArjK2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMg11l7Gn+PqJfN3f7LQL9hcaOmCSS9nOWg/uPS8M0ds7LKDwFQK2w7J/G5XWxJNs
	 p9Bw+UY6vfQHjxTA6MhP6uDtjdL+RWPU7R3nnii6e3wn2UsTeY4AmyyGPNDEEwImpo
	 kAFcH6ZrQYxHg+wrM5tOyBn1RHr+TlbFvI+sbaZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 388/403] KVM: x86: Move IRQ-related helper declarations from kvm_host.h => irq.h
Date: Fri,  9 Oct 2026 16:12:29 +0200
Message-ID: <20261009141001.412907113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 0bdd2d6d7328a7debcf138a7d6ef95d01a26b1b8 ]

Move the function declaration for APIs to get/query pending IRQs from
kvm_host.h to irq.h, as the APIs are only used by KVM x86 code.

No functional change intended.

Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <20260613000329.732085-25-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 10180a277549 ("KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    5 -----
 arch/x86/kvm/irq.h              |    6 ++++++
 arch/x86/kvm/svm/nested.c       |    1 +
 arch/x86/kvm/vmx/nested.c       |    1 +
 4 files changed, 8 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2379,12 +2379,7 @@ enum {
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, 0)
 #endif
 
-int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
-int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
-int kvm_cpu_has_extint(struct kvm_vcpu *v);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
-int kvm_cpu_get_extint(struct kvm_vcpu *v);
-int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -112,6 +112,12 @@ static inline int irqchip_in_kernel(stru
 	return mode != KVM_IRQCHIP_NONE;
 }
 
+int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
+int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
+int kvm_cpu_has_extint(struct kvm_vcpu *v);
+int kvm_cpu_get_extint(struct kvm_vcpu *v);
+int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
+
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -23,6 +23,7 @@
 
 #include "kvm_emulate.h"
 #include "trace.h"
+#include "irq.h"
 #include "mmu.h"
 #include "x86.h"
 #include "smm.h"
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -11,6 +11,7 @@
 #include "x86.h"
 #include "cpuid.h"
 #include "hyperv.h"
+#include "irq.h"
 #include "mmu.h"
 #include "nested.h"
 #include "pmu.h"


