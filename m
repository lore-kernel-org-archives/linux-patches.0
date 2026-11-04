Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831179;
	b=IxR5uakwmMcAYkMc/NLXRZZMJcGytr1YiQJLxMeLhul/BjETtNWkgNci1Lub1KsYG/oR
	 94wD+aK7umNYQFra2MPD69NpA3jbokQFLh3pCOp/UcNSvyg8PT6tTVuJCTXE6/7hnmzC3
	 oM/vilgRFXX8a8sZyi9E5nvXt7y6Z5Z5M88z2b4K9+XznLovujafgMQ5/CHdwbJEPK7v6
	 p7tvdor47Ea70WtOT7Bpuef0/SwPuyTtn4tV1OhMGDeBg9XxAdocfbDGAVO4a2AQAkptY
	 IGAyoYuqRMyvuDfwV/8tIhzq4/n+mGRaWwY2R7qDI0WaKs1kt8SPby5GfalBTGhAcFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VcJMW3NtXTC07ah8iYFYS6S0rPwBJcMrwPneOLfFEdA=;
	b=aJjJdvNkViHOLB9xuwwXX/pQR4FaUhx4hJe7NS/jCK+0K5C02BbYkmimHv5XHUc7JocK
	 09r4ZSHansnq+9xd9Vv91NJJ+BW/uY/okV8uQqqUamNBtwwpPMHcMsMII63Dpllrs0y9K
	 ENYrFroWqzKM8fNSSAmezEgdmabla3nE51LdpKLr8KgBut7n/1vwOBCCD7auflsZwOe9g
	 k1jPVemq3xeDNUafQH7QYv8AGEuKNk+7Ve3QjWV4DlY5OZAYjXm3aFhoRe6lg9AfT/ZOk
	 eZrdIzyGljf612MtI2BYjrBgphlo1OQSiG1xz/5GlVbGxIlW8ktOTUP9jGCIpSadjuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBtEIhLg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3A3606A332;
	Wed,  4 Nov 2026 22:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBtEIhLg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDE51F00A16;
	Wed,  4 Nov 2026 22:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831179;
	bh=VcJMW3NtXTC07ah8iYFYS6S0rPwBJcMrwPneOLfFEdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBtEIhLgWTqiLfcbWdq92cZUFkSJJlkZn8dsbl5cNQk+Gj3BfIPth+Ni5UPVFwq3u
	 /QcCR7f3zSQS2TdixRmTQJylc/XCIW8ycT8wNGKyZ1KLVxZkzuVyUoYroHrxOEByq6
	 Nq/HWMhLWWZCX7E1ZAMYtmUx1+WJEYxXuK59pxjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0544/1005] KVM: x86: Always initialize EFER reserved bits on vendor initialization
Date: Wed,  4 Nov 2026 16:04:37 -0500
Message-ID: <20261104211059.129374191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit a4b8acd428ba3f03952ef309d7f438dbc357557b ]

EFER reserved bits are statically initialized, and do not reset if a
vendor module is re-loaded. For example, loading kvm_amd with nested=1
removes EFER.SVME (and potentially EFER.LMSLE) from the reserved bits.
Reloading kvm_amd with nested=0 does not add them back, allowing
userspace to set EFER.SVME with nested=0.

Re-initializing EFER reserved bits before configuring them on vendor
initialization.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713181020.2735367-4-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Moved the EFER reserved-bits reset into a new static kvm_init_efer_bits() in x86.c, called from kvm_x86_vendor_init() before hardware_setup(), since the MSR split files and kvm_setup_efer_caps() don't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 907efeed6c91d..9493af5fa8275 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -106,8 +106,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_host);
 #define emul_to_vcpu(ctxt) \
 	((struct kvm_vcpu *)(ctxt)->vcpu)
 
-/* Enable syscall by default because its emulated by KVM */
-static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
+static u64 __read_mostly efer_reserved_bits;
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
@@ -1432,6 +1431,12 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
+static void kvm_init_efer_bits(void)
+{
+	/* Enable syscall by default because its emulated by KVM */
+	efer_reserved_bits = ~((u64)EFER_SCE);
+}
+
 void kvm_enable_efer_bits(u64 mask)
 {
        efer_reserved_bits &= ~mask;
@@ -9757,6 +9762,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrq(MSR_IA32_ARCH_CAPABILITIES, kvm_host.arch_capabilities);
 
+	kvm_init_efer_bits();
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		goto out_mmu_exit;
-- 
2.53.0



