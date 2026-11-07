Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064354;
	b=U+gZcat5FQ4HtWVUbvn/oAmrt+SBcs8wkeKuP47jJx3TiVm/VVD7Jdz4A+F7F8Vo+YeJ
	 53brr+RZMERYctnctD4fojZQLtWAzxqTmFW1OcXgLPNjMa+LbWHKqOSYr6vCtqB55k1bU
	 a+fseVL1++/bZHq9vAXlfNGrbd28HWjRziMX4zNVDvOSCUgYKNZXTH2DmHPdinJKcVFoo
	 f+IWkv6BkjecCjWrHwnFG99rK9nePIJ9eYtcVSKWJEVhTinzEDeG+atusz16MVtmkHj+9
	 gjGa81kn3xItiejfmCdRGSLa2bbqdAO8tBFcCcRIhomz5HMFsjZxRgRBBwARrQQzNqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uhVAbk30fKmCdWf5FkhCvmH6V8MZK3Y08Iycdy91bjw=;
	b=whOT7ncr0pQIHSjo15kg4JhCkVbpPfjlGRZoobLSnZ41fxPUkldK6J2l0F7yCIGrLhdh
	 QMMxskcRFBomS1iv3m3v4p7+C4q/60PXErPoVJn8mftG1UCUX+QaHipy2Ay+9DYwLI2ZM
	 FKB8zGX4w3k0U3lcq24zB6pM6AY0bQJ/Ij4ywrSyMBEUQp8f9rbPEnFygsJEVvLLVQfXz
	 1n17aUibKgaEKI+JvhCrmd0X4+sYFl7vkib8Ifui1h77DHBJLdL5PJd07V1I80ZwwVP0I
	 AMJJDWoYaSITGC9Vhujulcobitb/+it7f2ZBut4lJXeLev1TfZT/xQeuB2ldEonYaEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mapCfNK6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0165606B88D;
	Sat,  7 Nov 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mapCfNK6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1864A1F0089F;
	Sat,  7 Nov 2026 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064353;
	bh=uhVAbk30fKmCdWf5FkhCvmH6V8MZK3Y08Iycdy91bjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mapCfNK63WKTn05kXp3CN+aevK1sfX6pmbgVXM2D/dXW7PXsTuNv1oY8ZMQRh6JgO
	 tPz5uqWZRYSoq3y9HBP7/t2P/BvEuIVIPpiJoga2fsvY2awSsultGpcd4O0wKsM99G
	 9Y2UtM4uN3eMWtKBZ9dvotP2ZfIQHN9cSfESee9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0437/1257] KVM: arm64: Validate the host vCPUs VM before reading it under pKVM
Date: Sat,  7 Nov 2026 08:45:33 -0500
Message-ID: <20261107134951.554563638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit cf533b4d3630b229d78ad55567c5db2f365052a2 ]

On an MTE-capable host under pKVM, enter_exception64() reads the VM's
MTE flag through vcpu->kvm, which for a host vCPU is a host-writable
pointer nothing validates. The host can point it at any address in the
hyp linear map and read back bit 1 of that word through PSR_TCO in the
vCPU's CPSR, or panic the hypervisor with an unmapped one.

Get the VM through a get/put pair around the read: a loaded vCPU's is
the hyp VM, an unloaded host vCPU's is read once and pinned, and a
pointer the host never shared leaves TCO clear.

Fixes: ea7fc1bb1cd1b ("KVM: arm64: Introduce MTE VM feature")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260914070536.877D91F000FF@smtp.kernel.org/
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261001135711.1640520-3-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/exception.c             |  5 ++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 28 ++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |  2 ++
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 37 ++++++++++++++++++++++
 4 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 754e2dc1df54a..6e60d890afa4a 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -70,6 +70,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 			      enum exception_type type)
 {
 	unsigned long sctlr, vbar, old, new, mode;
+	struct kvm *kvm;
 	u64 exc_offset;
 
 	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
@@ -109,8 +110,10 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);
 
-	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
+	kvm = vcpu_get_kvm(vcpu);
+	if (kvm && kvm_has_mte(kvm))
 		new |= PSR_TCO_BIT;
+	vcpu_put_kvm(vcpu, kvm);
 
 	new |= (old & PSR_DIT_BIT);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 4fdfeabefeb43..f55950ee2a7e4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -13,6 +13,34 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/pkvm.h>
+
+/* Under pKVM a host vCPU's ->kvm is host-writable. */
+static inline struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu)
+{
+	if (is_protected_kvm_enabled())
+		return pkvm_vcpu_get_kvm(vcpu);
+
+	return kern_hyp_va(vcpu->kvm);
+}
+
+static inline void vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm)
+{
+	if (is_protected_kvm_enabled())
+		pkvm_vcpu_put_kvm(vcpu, kvm);
+}
+#else
+static inline struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm;
+}
+
+static inline void vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm)
+{
+}
+#endif
+
 static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 5c050f21066ab..5cd8b2769cba7 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -92,6 +92,8 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void);
+struct kvm *pkvm_vcpu_get_kvm(struct kvm_vcpu *vcpu);
+void pkvm_vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm);
 
 struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle);
 struct pkvm_hyp_vm *get_np_pkvm_hyp_vm(pkvm_handle_t handle);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 6290c4b62659b..1a17ab23ddfe8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -311,6 +311,43 @@ struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void)
 
 }
 
+static struct pkvm_hyp_vm *pkvm_get_loaded_hyp_vm(struct kvm_vcpu *vcpu)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+
+	if (hyp_vcpu &&
+	    (vcpu == &hyp_vcpu->vcpu || vcpu == hyp_vcpu->host_vcpu))
+		return pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+
+	return NULL;
+}
+
+/*
+ * A loaded vCPU's VM is the hyp VM. An unloaded host vCPU's is mapped at
+ * EL2 only while pinned, so it's read once and pinned; the pin fails for
+ * memory the host isn't sharing.
+ */
+struct kvm *pkvm_vcpu_get_kvm(struct kvm_vcpu *vcpu)
+{
+	struct pkvm_hyp_vm *hyp_vm = pkvm_get_loaded_hyp_vm(vcpu);
+	struct kvm *kvm;
+
+	if (hyp_vm)
+		return &hyp_vm->kvm;
+
+	kvm = kern_hyp_va(READ_ONCE(vcpu->kvm));
+	if (hyp_pin_shared_mem(kvm, kvm + 1))
+		return NULL;
+
+	return kvm;
+}
+
+void pkvm_vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm)
+{
+	if (kvm && !pkvm_get_loaded_hyp_vm(vcpu))
+		hyp_unpin_shared_mem(kvm, kvm + 1);
+}
+
 struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
-- 
2.53.0



