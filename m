Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034843;
	b=r/S+qWwKo2nzeoYI1pjwf4PaCY2tTqVV76DdNRLXeO+b7E03ODUQMH89C/w1awhXR8aI
	 1m7kk9r9P5IpRIAtj+OLKdCFhCIHvoxjJBfeI3Okgv8mzYoWWbQEkqii7F/1viNdxNPqD
	 luaP0s/KjWWasFbwRSj5a47YvYlp/Fz5tFTGlbxb3yEEHZK0ZfVhfzKP34JwadoRX3cpd
	 +qD1mze7cjd6ONG0aeeQ56JqaozAmhQHH5nf4DVckoz1MRuzaMfnNUgZznw9sj5daGax4
	 6JVIurHOO81CJQ6W9lLDq+6bV26auGZnTCfk9KnrjryKHp/V2RKFTnuVb5uMLwuO/xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hUv7hiNRSMeRiIP7kf8b1Mg0VKu9HtOHqRMLwoYODCI=;
	b=atsQeHWLR1frehjIxRrS+sM6B7u571vPqK/t7biZSuF/MmyODP6jm+gVYPiRrA4JTsfG
	 cnDabV+EK5Ceu0Usx3AiVd3gubW13DwvoBoLaOOPDt60uzrt700lHPdFEDD+FKccaDyXE
	 yhpr46sIWZwe0O7Wb8XigWGPHOwLbTiByTUtY/X+GZRFRF+6pYexIuqWpKrB/o3mLUAX3
	 H+cGGIjaeeWIKWaPSGRxRIOal6BJRb6ujG6sG0OTT4uQGgnsaSTUNGnGnn/AFE3kC6Ww3
	 +8i0jQDoM5FRYVeQgdzXlgkOHTAkIFSxfQfDOWkB0qR+AYi3z2Mwg3SrQHr27eicjqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+wNn7BJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE9D606A320;
	Wed, 18 Nov 2026 20:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+wNn7BJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410681F000C4;
	Wed, 18 Nov 2026 20:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034843;
	bh=hUv7hiNRSMeRiIP7kf8b1Mg0VKu9HtOHqRMLwoYODCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+wNn7BJYWHs9ODQNPxobpB7JUeHYPQ3xOfXyV1tg+kcrSChb3INr0E0+ZgyN07aq
	 2qvdbF7bEBUQzRT/6BErMRwBVXDQaNxVB08vUiJGPFNTZbHI2S/Hm3zb8JIuMy5+ON
	 D7E7ep7O3Lq7rBVMvt88rwryhawUjWK1e6MqBmUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hao <flyingpeng@tencent.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0513/3318] KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XEN=n
Date: Wed, 18 Nov 2026 15:18:55 +0100
Message-ID: <20261118150332.520083662@linuxfoundation.org>
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

From: Peng Hao <flyingpeng@tencent.com>

[ Upstream commit ee11ab6bb04e1093d3cc5f5bea9779799ce1d2c7 ]

When CONFIG_KVM_XEN=n, the size of kvm_vcpu_arch can be reduced
from 5100+ to 4400+ by adding macro control.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Link: https://lore.kernel.org/all/CAPm50aKwbZGeXPK5uig18Br8CF1hOS71CE2j_dLX+ub7oJdpGg@mail.gmail.com
[sean: fix whitespace damage]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 2abb25273c82 ("KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 5 ++++-
 arch/x86/kvm/cpuid.c            | 2 ++
 arch/x86/kvm/x86.c              | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d79b8f7a39913..b2aa5b455e1d6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -679,6 +679,7 @@ struct kvm_hypervisor_cpuid {
 	u32 limit;
 };
 
+#ifdef CONFIG_KVM_XEN
 /* Xen HVM per vcpu emulation context */
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
@@ -701,6 +702,7 @@ struct kvm_vcpu_xen {
 	struct timer_list poll_timer;
 	struct kvm_hypervisor_cpuid cpuid;
 };
+#endif
 
 struct kvm_queued_exception {
 	bool pending;
@@ -931,8 +933,9 @@ struct kvm_vcpu_arch {
 
 	bool hyperv_enabled;
 	struct kvm_vcpu_hv *hyperv;
+#ifdef CONFIG_KVM_XEN
 	struct kvm_vcpu_xen xen;
-
+#endif
 	cpumask_var_t wbinvd_dirty_mask;
 
 	unsigned long last_retry_eip;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2c0bc6a93ec3e..861bfefc110f4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -470,7 +470,9 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_nent = nent;
 
 	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
+#ifdef CONFIG_KVM_XEN
 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
+#endif
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d5aa251547e5..19d2170994f43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3246,11 +3246,13 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
+#ifdef CONFIG_KVM_XEN
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
 					offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
+#endif
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
-- 
2.53.0



