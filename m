Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591380;
	b=Vr0i05mnx8BMTc6y5pGD8xXwO1uAOOktb7//Boqg2NAgmkR6IHO+ldXq+rzexxIfel7H
	 psEgzl+MONe8yZXuydLsMxpNJEyXm4zMyQqRHQgtySeWpOuJhrCBPVF8a9SBOfobATraR
	 2pgSRbTafiO/HvEL+hx9MtJ0nUJsVRKC1fj1x+QcITxsCc4SpGj05Btq1yv/Rx7aTqQoI
	 /tqqX+Bc9rGoUveXmJUcBka6iioD3CBT243UusHvFmXbsAN0eqWUChc8SfcFeGk0AkLoC
	 QkVMUJa8zqp53q2Y7lt/QbC6qsUvEvAfibJyQDoT5Vp0+U62w+rSLiLeVPtnxV7ZmgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3TRsmox0QrenmIObWn+j1RT8zIpiUK3XY+4T5pT+OBE=;
	b=lEmUKwiOmRFAFG1FvTYOAR+PH+UZ+fEBxYjTJLVoV0WxKO+aI09hWvtkZrLk3Mbam4an
	 9aTjRABe0es0FLaI/PJIxmQsndQhB79uTgHmHQfDOP0/68bNEZBPxDC1AW7IGHFFSquRF
	 7eaUozAhpzYE7EGccZHD3YkyWV2S9wbQRZbYoeYcs0g5NkQ8PCSqCITEVsooXuwr8p25O
	 GkhPUFEh1/Ae6cM5SPb/TClFFQ66Hj9Orqo2s5aegJf5Ddk7cEpqdcKR47mPw4+zqMpD2
	 LXdsBN8SSuUuocc2StrUuavqjpWkX4t2/zMIc4b75zGIhZhShKzdTgRNjraTzeKbMcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEEs2wDi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3214F606B234;
	Fri, 13 Nov 2026 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEEs2wDi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959A01F000C4;
	Fri, 13 Nov 2026 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591379;
	bh=3TRsmox0QrenmIObWn+j1RT8zIpiUK3XY+4T5pT+OBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEEs2wDie1ly0DwHt+NpeBarKllHOzB7/NEF0+uXrpo1AMWR4cyCYKko+C4xezWAN
	 gyiCb8Mv6Utz8vTx+HI3aNaP+vTU4ttCj1dGmjZRMLxaB6k53UI4/NRKd2ZAMweHZn
	 J05ShiitOnyz+e7OaIEXuU9ey3Y5jFbQyIT+ZZ5w=
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
Subject: [PATCH 6.12 482/670] KVM: arm64: Validate the host vCPUs VM before reading it under pKVM
Date: Fri, 13 Nov 2026 10:50:46 -0500
Message-ID: <20261113153828.278876389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Replaced pkvm_get_loaded_hyp_vcpu() with a lookup through the existing host_ctxt->__hyp_running_vcpu pointer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/exception.c             |  5 ++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 28 +++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |  2 ++
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 42 ++++++++++++++++++++++
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 424a5107cddb5..e20979138305a 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -92,6 +92,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 			      enum exception_type type)
 {
 	unsigned long sctlr, vbar, old, new, mode;
+	struct kvm *kvm;
 	u64 exc_offset;
 
 	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
@@ -131,8 +132,10 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
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
index 24a9a8330d190..1a9dc0c3b7db1 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -69,5 +69,7 @@ int __pkvm_teardown_vm(pkvm_handle_t handle);
 struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
+struct kvm *pkvm_vcpu_get_kvm(struct kvm_vcpu *vcpu);
+void pkvm_vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm);
 
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 7c464340bcd07..ba7d6280efa49 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -262,6 +262,48 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_spin_unlock(&vm_table_lock);
 }
 
+static struct pkvm_hyp_vm *pkvm_get_loaded_hyp_vm(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu *running_vcpu = host_data_ptr(host_ctxt)->__hyp_running_vcpu;
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+
+	if (!running_vcpu)
+		return NULL;
+
+	hyp_vcpu = container_of(running_vcpu, struct pkvm_hyp_vcpu, vcpu);
+
+	if (vcpu == &hyp_vcpu->vcpu || vcpu == hyp_vcpu->host_vcpu)
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
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 {
 	if (host_vcpu)
-- 
2.53.0



