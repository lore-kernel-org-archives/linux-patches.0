Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881A049890A;
	Wed,  9 Sep 2026 14:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962554; cv=none; b=r2ZhMfXrTVllUTk7tEfgLlvoTSI1L4EwzPYQLza1QdzyUI3eGVP4LAjfDQfqxzlEV5gde8pvGR6AiTH9wYR21CkiTU5kdVK/AHpXnD2nHo/Jm9R8wO2vRrWYMCIWtvG+bkCI02hqLOmK9Z39qCxYmayIyPigFGd+AJeS0IyviEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962554; c=relaxed/simple;
	bh=BoRybibS8S8jQOefJ7T8VgM3ul2fOIHsQNONwlrB/lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXSW+F+zRH0y+kliji9oiA84DFeDL7Wo4nwwd9vZtTAaMsq1X4cjlFHXezLsvuaPBBl2ZeM2ZHG5qa1ay/XN+S2h3JzbqZ6AaZ0qfYj9DYvWMXAe9XsNsuIlrMhqefFPKyIMNuOZmKPNaoWcBT8LHPhGpOkXNFg0s18PKDbix0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDCKr4Jh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDCKr4Jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915EA1F00A3A;
	Wed,  9 Sep 2026 14:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962553;
	bh=7ldL15DT6MCGPRCKzfzNySRKqXUE3BOJfpffWYK37Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDCKr4Jh5mDzu6A53NSqaFKjF/t5cw7L82v1Tm5CL3cVoTRmW3hJ2SuJ9iC5WKAt1
	 c95qMTacAgZzBDpp3hQsHTH7dk4Cc9Qcsxea31pa1r97gQJ0nx3nVzgr2yz+E8NIal
	 K/1B3X5dJFVKvpBAd2RndnApYiZAKlOfBSt4bekU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 329/556] LoongArch: KVM: Add unregister helpers for the KVM interrupt devices
Date: Wed,  9 Sep 2026 15:40:09 +0200
Message-ID: <20260909134242.228529426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

commit 4af22177032ab2357bf551fbfcdebc8fd9f2502d upstream.

The IPI/EIOINTC/PCH-PIC/DMSINTC KVM devices each have a helper that
registers their kvm_device_ops, but there is no counterpart to remove
them, so a caller that needs to undo a registration has to open-code
kvm_unregister_device_ops() with the matching device type.

Add kvm_loongarch_unregister_{ipi,eiointc,pch_pic,dmsintc}_device()
next to the existing register helpers. kvm_unregister_device_ops() is a
no-op when the corresponding device type is not currently registered.

No functional change, as there are no callers yet.

Cc: stable@vger.kernel.org
Suggested-by: Bibo Mao <maobibo@loongson.cn>
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/kvm_dmsintc.h |    1 +
 arch/loongarch/include/asm/kvm_eiointc.h |    1 +
 arch/loongarch/include/asm/kvm_ipi.h     |    1 +
 arch/loongarch/include/asm/kvm_pch_pic.h |    1 +
 arch/loongarch/kvm/intc/dmsintc.c        |    5 +++++
 arch/loongarch/kvm/intc/eiointc.c        |    5 +++++
 arch/loongarch/kvm/intc/ipi.c            |    5 +++++
 arch/loongarch/kvm/intc/pch_pic.c        |    5 +++++
 8 files changed, 24 insertions(+)

--- a/arch/loongarch/include/asm/kvm_dmsintc.h
+++ b/arch/loongarch/include/asm/kvm_dmsintc.h
@@ -20,6 +20,7 @@ struct dmsintc_state {
 };
 
 int kvm_loongarch_register_dmsintc_device(void);
+void kvm_loongarch_unregister_dmsintc_device(void);
 void dmsintc_inject_irq(struct kvm_vcpu *vcpu);
 int dmsintc_set_irq(struct kvm *kvm, u64 addr, int data, int level);
 int dmsintc_deliver_msi_to_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 vector, int level);
--- a/arch/loongarch/include/asm/kvm_eiointc.h
+++ b/arch/loongarch/include/asm/kvm_eiointc.h
@@ -79,6 +79,7 @@ struct loongarch_eiointc {
 };
 
 int kvm_loongarch_register_eiointc_device(void);
+void kvm_loongarch_unregister_eiointc_device(void);
 void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level);
 
 #endif /* __ASM_KVM_EIOINTC_H */
--- a/arch/loongarch/include/asm/kvm_ipi.h
+++ b/arch/loongarch/include/asm/kvm_ipi.h
@@ -41,5 +41,6 @@ struct ipi_state {
 #define IOCSR_ANY_SEND		0x158
 
 int kvm_loongarch_register_ipi_device(void);
+void kvm_loongarch_unregister_ipi_device(void);
 
 #endif
--- a/arch/loongarch/include/asm/kvm_pch_pic.h
+++ b/arch/loongarch/include/asm/kvm_pch_pic.h
@@ -70,6 +70,7 @@ struct loongarch_pch_pic {
 
 struct kvm_kernel_irq_routing_entry;
 int kvm_loongarch_register_pch_pic_device(void);
+void kvm_loongarch_unregister_pch_pic_device(void);
 void pch_pic_set_irq(struct loongarch_pch_pic *s, int irq, int level);
 int pch_msi_set_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e, int level);
 
--- a/arch/loongarch/kvm/intc/dmsintc.c
+++ b/arch/loongarch/kvm/intc/dmsintc.c
@@ -179,3 +179,8 @@ int kvm_loongarch_register_dmsintc_devic
 {
 	return kvm_register_device_ops(&kvm_dmsintc_dev_ops, KVM_DEV_TYPE_LOONGARCH_DMSINTC);
 }
+
+void kvm_loongarch_unregister_dmsintc_device(void)
+{
+	kvm_unregister_device_ops(KVM_DEV_TYPE_LOONGARCH_DMSINTC);
+}
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -691,3 +691,8 @@ int kvm_loongarch_register_eiointc_devic
 {
 	return kvm_register_device_ops(&kvm_eiointc_dev_ops, KVM_DEV_TYPE_LOONGARCH_EIOINTC);
 }
+
+void kvm_loongarch_unregister_eiointc_device(void)
+{
+	kvm_unregister_device_ops(KVM_DEV_TYPE_LOONGARCH_EIOINTC);
+}
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -466,3 +466,8 @@ int kvm_loongarch_register_ipi_device(vo
 {
 	return kvm_register_device_ops(&kvm_ipi_dev_ops, KVM_DEV_TYPE_LOONGARCH_IPI);
 }
+
+void kvm_loongarch_unregister_ipi_device(void)
+{
+	kvm_unregister_device_ops(KVM_DEV_TYPE_LOONGARCH_IPI);
+}
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -500,3 +500,8 @@ int kvm_loongarch_register_pch_pic_devic
 {
 	return kvm_register_device_ops(&kvm_pch_pic_dev_ops, KVM_DEV_TYPE_LOONGARCH_PCHPIC);
 }
+
+void kvm_loongarch_unregister_pch_pic_device(void)
+{
+	kvm_unregister_device_ops(KVM_DEV_TYPE_LOONGARCH_PCHPIC);
+}


