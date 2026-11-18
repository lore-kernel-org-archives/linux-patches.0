Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034855;
	b=fkPpbsxKKvDLGfRGH4xNk+nZBPE2uXTmlsxTgvbnJO64HJABWgiWQQjz3eLOBNkaAmbG
	 zLCrVtMzOPu1ijPz8LZPojgpTHoeYWe7FyU2AXQmLWrrFckqtpmg5CrZxPvo0abUDH7i/
	 aYAimD9L4jTHBuqb3FZUaCcWWoHJm5VpqvfhkY6MSRH5wYLY0l9Yhvbmq7oZ5UiSCpxHJ
	 lgR7ufJd4Lq/R7fy1gP4s8KC24Z+7qFm8AogQr2VMgV1NzNlrMNvPG/ZrbT6FxaMvTv+F
	 piMvAiaDMg7DNoLok3CB/DKLOA4NjogTZnw9LIJJMIYuBoFc/+kg76pPdjg7kjMiPgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rxPLpv2A2r1uXdyanyE1brMZC6Mzyn8nqlA4bmBTxmY=;
	b=rcRoxpEwDcTtbeEzSYU1Om+rEPVD25NgMxluKIQmFs86RhSRnWk5cafO6neSeZoGHi/o
	 wrlflwkBAMyggEo/+D5vlppCscrG7C+e9u32MK/GerQjkIbxKCp1TlVCKDnuIWRIvQY9d
	 /nqv8CrnkSddOHCbxiJeYnIlnyPTOMVkhG1V71287V6rqlxjw0zfcBSSyj1yFu7pWN3S1
	 uddy9na13VR/KUoAWQo+bVj9+pj90WDVZHvk112GOHqfwcoN/t5fbGroYRJy0FBq7vAOE
	 U5A6eCIeyXkHcFgyp9am26zO7PLYq/XVlpjmyuIMbSqLtD85qEs228oZ0L7SDlZQMeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=epN593Kv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457B1606A31C;
	Wed, 18 Nov 2026 20:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=epN593Kv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E291F000C4;
	Wed, 18 Nov 2026 20:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034855;
	bh=rxPLpv2A2r1uXdyanyE1brMZC6Mzyn8nqlA4bmBTxmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epN593KvbmQSEJuy/oL4gZT1vl1pdPm/lH0fx7KnKTI0g5cZVOA1xFA5Nw7CDLK0Y
	 tjL/AuHM2t7lToMHBGsMO97nXKD7mZWtCIUblgdphWjIQWnDEy9s6T9eWLEoc51Z25
	 phYyPYO9cGUMLUS+d/S6kvmQ9RjB4KZjjChV20zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0517/3318] KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h
Date: Wed, 18 Nov 2026 15:18:59 +0100
Message-ID: <20261118150332.663181633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit f97314626734deaef49564a429c6f8eee3846bd3 ]

In preparation for making Hyper-V emulation optional, move Hyper-V specific
guest_cpuid_has_evmcs() to hyperv.h.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Link: https://lore.kernel.org/r/20231205103630.1391318-12-vkuznets@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 2abb25273c82 ("KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/hyperv.h | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.h    | 10 ----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index d4ed99008518c..6e1ee951e3606 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 #include "vmcs12.h"
+#include "vmx.h"
 
 #define EVMPTR_INVALID (-1ULL)
 #define EVMPTR_MAP_PENDING (-2ULL)
@@ -20,6 +21,16 @@ enum nested_evmptrld_status {
 	EVMPTRLD_ERROR,
 };
 
+static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
+	 * eVMCS has been explicitly enabled by userspace.
+	 */
+	return vcpu->arch.hyperv_enabled &&
+	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
+}
+
 u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ed611a9ccbc2d..86b9f218374fc 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -770,14 +770,4 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
 	return  lapic_in_kernel(vcpu) && enable_ipiv;
 }
 
-static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
-	 * eVMCS has been explicitly enabled by userspace.
-	 */
-	return vcpu->arch.hyperv_enabled &&
-	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
-}
-
 #endif /* __KVM_X86_VMX_H */
-- 
2.53.0



