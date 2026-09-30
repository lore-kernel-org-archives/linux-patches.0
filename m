Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9435230BDB;
	Wed, 30 Sep 2026 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788099; cv=none; b=qpaj0nBiXkWB1wc8XddADzKwHaijgRuYi/8S+VjG8a5jXGN+NLvw2N2DcBgHarrm5Hxqixs4TIAy2c2E2uGtQzdNF87WJbbHZ736zkuZ7VxX8sOwt4CW/DWhL93WhslUFTK+//Mi9WZ29nR3d88zL4Djox4avoMJrr9Q7TzSItc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788099; c=relaxed/simple;
	bh=ukLXPTORDYbKuvT5S4nUUtS/SHNy9GdEPPJ2EukswvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0F4j51Cu33wSuwu2pylHD1wpLLgH6L5nBy3wtUHTXEYQs0Q7KAvvONnaELM/gSITWVx7XJt7fJYHFdh0XMx9KssdGsMQS8VU4jJoLmRIMyv5gwlGF6d1LXSlKKAhDm2f1I/iuB2CkwgAfxTjXTC8FiK3OXPU6GO7XqKs3K6/Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7OFcKSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7OFcKSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F29D1F000FF;
	Wed, 30 Sep 2026 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788097;
	bh=IUAOHlayQlaQXBK7NoCD1mF4UUhhYG6sTaC0+onjg6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7OFcKSCsjn+3sgBqt5alDUhfBwzMppyWRqqNJH+KSfqPdu/4AuTGMfysDd4sEKPf
	 6dU9YxJTkXZAu8aDaXQqheEGalp7dRA+uS8j9hT8QWJoW5JMYS9W6UJvcniS45NwWP
	 nffKCK9QZmmDDxsuT9FpuNcRO6J2yFaPoOMhAbkY=
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
Subject: [PATCH 7.2 450/457] KVM: x86: Move IRQ-related helper declarations from kvm_host.h => irq.h
Date: Wed, 30 Sep 2026 17:29:15 +0200
Message-ID: <20260930152355.717163090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2462,12 +2462,7 @@ enum {
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


