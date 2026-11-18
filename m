Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044214;
	b=PfIKaNzCvCb0m3zkGcreq67YepA/nFnQgBQmgxA2Y2b1Qwn6i0rG2tJXJ+YxfYinxsdK
	 8w5QYpr4YRYQITSDyQ5D5G4GJb2EncUZJN7/qgKAlhMQ3MXQsvcPJGOeqeipASMJiYpYt
	 XrIjb5VU6PyXBvz9i8nA/uDpw7waRdgk51xwX9T16OdRwaYnf0G+Jt7NsQoWJGDgrD4GA
	 hyK/UizxOAJE1SrLrVRlI2pkUvZP4e0UCvPu45NvXciYKz6Qd/eLdSQqUut5l2EbQ0jtf
	 c8pZd8ZbJvH+T+bb/HzG3fJsYEOnqVdi3NJ1k383dwcTVYCrpuonyyOt6QlJE1JTY6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iDhS2Ymg0rzz6o0GvGBYb3M9vEArS66/cQYAvxuO9Vk=;
	b=cUJ2iEdc8acqjFyo079G6tVxatPxMLZpxvkAqvM4jUahFk9XneMDxFJMSiH9ed3BgGB/
	 4wv81abHSu0rnGSi7VhGMEsWzfhw3SNAbdqq1yF93IV2BflYHXa0p5JcsoCSZjctlIHt5
	 Yb5GLScH4/muLmaN6ONVG8Z/rI+fPfW7zPBNBn/pUq0z0FD9wE/EmfwJIUzeQrRW8D5Pg
	 gg1sZhVSdY27XLnPSQduV7BNpBFaPe94JUHZG2TpI7hz0RG1dYXx7/+bKvevqiTKjZ1y0
	 /zyKWRJs735Zlhl53y8HrkYuFbUCrTXY1ktpKXAHNPCGOjBHvwZGJA2ktvgt97sZrRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8UfWHk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A991B606A31C;
	Wed, 18 Nov 2026 23:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8UfWHk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013B21F000C4;
	Wed, 18 Nov 2026 23:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044214;
	bh=iDhS2Ymg0rzz6o0GvGBYb3M9vEArS66/cQYAvxuO9Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8UfWHk9dddcdPr+sAsQsskgjKW3vu/Wd28l6rnOkZPMaWN5/pcuFdUy8J75Wf5vn
	 7ffZ/krIvIa9ECtkT+UF243Ur583M8Ei8tCJ2N6a4AxeO+8kIZTbID8BXoy2iQZ+9C
	 xD+j02YMJx3iw8bfT7O6VFMXcASFzAR355nOj3u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0488/2857] x86/kvm: Use separate percpu variable to track the enabling of asyncpf
Date: Wed, 18 Nov 2026 15:25:22 +0100
Message-ID: <20261118150219.022237676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit ccb2280ec2f9e805d70f57a3a1c5deff0d532cb3 ]

Refer to commit fd10cde9294f ("KVM paravirt: Add async PF initialization
to PV guest") and commit 344d9588a9df ("KVM: Add PV MSR to enable
asynchronous page faults delivery"). It turns out that at the time when
asyncpf was introduced, the purpose was defining the shared PV data 'struct
kvm_vcpu_pv_apf_data' with the size of 64 bytes. However, it made a mistake
and defined the size to 68 bytes, which failed to make fit in a cache line
and made the code inconsistent with the documentation.

Below justification quoted from Sean[*]

  KVM (the host side) has *never* read kvm_vcpu_pv_apf_data.enabled, and
  the documentation clearly states that enabling is based solely on the
  bit in the synthetic MSR.

  So rather than update the documentation, fix the goof by removing the
  enabled filed and use the separate percpu variable instread.
  KVM-as-a-host obviously doesn't enforce anything or consume the size,
  and changing the header will only affect guests that are rebuilt against
  the new header, so there's no chance of ABI breakage between KVM and its
  guests. The only possible breakage is if some other hypervisor is
  emulating KVM's async #PF (LOL) and relies on the guest to set
  kvm_vcpu_pv_apf_data.enabled. But (a) I highly doubt such a hypervisor
  exists, (b) that would arguably be a violation of KVM's "spec", and
  (c) the worst case scenario is that the guest would simply lose async
  #PF functionality.

[*] https://lore.kernel.org/all/ZS7ERnnRqs8Fl0ZF@google.com/T/#u

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://lore.kernel.org/r/20231025055914.1201792-2-xiaoyao.li@intel.com
[sean: use true/false instead of 1/0 for booleans]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 81d99abe2bd8 ("x86/kvm: Don't consume async #PF flags on a kernel #PF in NMI context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/x86/msr.rst   |  1 -
 arch/x86/include/uapi/asm/kvm_para.h |  1 -
 arch/x86/kernel/kvm.c                | 11 ++++++-----
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 9315fc385fb0b..f6d70f99a1a73 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -204,7 +204,6 @@ data:
 		__u32 token;
 
 		__u8 pad[56];
-		__u32 enabled;
 	  };
 
 	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1ee..605899594ebb8 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -142,7 +142,6 @@ struct kvm_vcpu_pv_apf_data {
 	__u32 token;
 
 	__u8 pad[56];
-	__u32 enabled;
 };
 
 #define KVM_PV_EOI_BIT 0
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 99e0768ccaae7..014bfe7fb91cc 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -65,6 +65,7 @@ static int __init parse_no_stealacc(char *arg)
 
 early_param("no-steal-acc", parse_no_stealacc);
 
+static DEFINE_PER_CPU_READ_MOSTLY(bool, async_pf_enabled);
 static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
 static int has_steal_clock = 0;
@@ -244,7 +245,7 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
 {
 	u32 flags = 0;
 
-	if (__this_cpu_read(apf_reason.enabled)) {
+	if (__this_cpu_read(async_pf_enabled)) {
 		flags = __this_cpu_read(apf_reason.flags);
 		__this_cpu_write(apf_reason.flags, 0);
 	}
@@ -295,7 +296,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 
 	inc_irq_stat(irq_hv_callback_count);
 
-	if (__this_cpu_read(apf_reason.enabled)) {
+	if (__this_cpu_read(async_pf_enabled)) {
 		token = __this_cpu_read(apf_reason.token);
 		kvm_async_pf_task_wake(token);
 		__this_cpu_write(apf_reason.token, 0);
@@ -362,7 +363,7 @@ static void kvm_guest_cpu_init(void)
 		wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
 
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
-		__this_cpu_write(apf_reason.enabled, 1);
+		__this_cpu_write(async_pf_enabled, true);
 		pr_debug("setup async PF for cpu %d\n", smp_processor_id());
 	}
 
@@ -383,11 +384,11 @@ static void kvm_guest_cpu_init(void)
 
 static void kvm_pv_disable_apf(void)
 {
-	if (!__this_cpu_read(apf_reason.enabled))
+	if (!__this_cpu_read(async_pf_enabled))
 		return;
 
 	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
-	__this_cpu_write(apf_reason.enabled, 0);
+	__this_cpu_write(async_pf_enabled, false);
 
 	pr_debug("disable async PF for cpu %d\n", smp_processor_id());
 }
-- 
2.53.0



