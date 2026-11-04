Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831213;
	b=BEwL3Dg5jomNHAGQs9IprnF7hQwvWnKFr073FCNzofoC7Y9+hPrXsFnIGqf6fxix3VvP
	 AGU7w/0Haooy6FR3QE7japKmRMI/gAuAA79Zqyc4Q65NptXUpaax8/L8kk8uTfTm4TFii
	 EK8xWckgcvmNu0PBi5l54RC6Lz+NANl6uDOFKs9VZNGau18KXR8DxNTjvzpwCerBXnhtt
	 uV/6ZIlAV1MszzG1D/tcbdhfwkchTzPNs5l2EiW+gaLyx44OTFVpSfOOKUNv+qNVuYmk4
	 b+g/Zpd2I/OejQR1wHLULK+sIzhBVfKd0hH6w0Hls5iD0dDmdTxGmg9OJwsZBAi1d0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r86535Krq0SZSkS2T/qHWqk2l2QculiMlk8dOEeTZQU=;
	b=gNcP1lTTuv8Be4mp0M4F50XvU4OBDjPBN7h6rllkbWBcK9+JN7GwgU+ifmVHOdRhIeDC
	 hENwwWEwlVBtz5Sh6atEDJ28SJ+bto6p7OacuUKZs6FTruJy0HSaRIH2ljT5KquUuc0sF
	 InnH6LR3Rx/R7MrwTsdHeR6HxImKtqGrXimaCdZPlHYyePO4VJO0v+awPCzRcyoX1iT7G
	 jq7KZ42bipcO4UsJ3ndg9nQR6N/IlGRgiYhPGBv9dNLoUVqbTiTUafEBa2/X5XNBmJajI
	 1OD0qq1/3FSJV2beSe+A2ByEYw/THOc85E2ZhzWxnX99AKK39b2qEuajjDY1/1SbCDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMM3oxdW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BA8606AB04;
	Wed,  4 Nov 2026 22:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMM3oxdW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0249E1F000C1;
	Wed,  4 Nov 2026 22:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831213;
	bh=r86535Krq0SZSkS2T/qHWqk2l2QculiMlk8dOEeTZQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMM3oxdWrRQ6xDkeLFm/YIPQUtnMOcl4Rp/VoDdJsBW+aK49ho5G5dPncqQYbP7gY
	 QP94rlY3PY0mqMz25e9U6M5eXr6WykZIeobJ/JTJZI7Q3XqwMxH6pE3Htz5hUUEn9u
	 m7KwCNuDAwl8wH+CVHvxxDJ2M35cEJzuL5KeyJQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0568/1005] LoongArch: KVM: Add unregister helpers for the KVM interrupt devices
Date: Wed,  4 Nov 2026 16:05:01 -0500
Message-ID: <20261104211059.786850765@linuxfoundation.org>
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

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit 4af22177032ab2357bf551fbfcdebc8fd9f2502d ]

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
[ sashal: Dropped the DMSINTC hunks and files because this tree has no DMSINTC support, leaving only the IPI, EIOINTC and PCH-PIC unregister helpers, with context adjusted for older surrounding code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/kvm_eiointc.h | 1 +
 arch/loongarch/include/asm/kvm_ipi.h     | 1 +
 arch/loongarch/include/asm/kvm_pch_pic.h | 1 +
 arch/loongarch/kvm/intc/eiointc.c        | 5 +++++
 arch/loongarch/kvm/intc/ipi.c            | 5 +++++
 arch/loongarch/kvm/intc/pch_pic.c        | 5 +++++
 6 files changed, 18 insertions(+)

diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/include/asm/kvm_eiointc.h
index a3a40aba8acf2..1cac3d4989580 100644
--- a/arch/loongarch/include/asm/kvm_eiointc.h
+++ b/arch/loongarch/include/asm/kvm_eiointc.h
@@ -118,6 +118,7 @@ struct loongarch_eiointc {
 };
 
 int kvm_loongarch_register_eiointc_device(void);
+void kvm_loongarch_unregister_eiointc_device(void);
 void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level);
 
 #endif /* __ASM_KVM_EIOINTC_H */
diff --git a/arch/loongarch/include/asm/kvm_ipi.h b/arch/loongarch/include/asm/kvm_ipi.h
index 060163dfb4a38..d1d72d4bb8d15 100644
--- a/arch/loongarch/include/asm/kvm_ipi.h
+++ b/arch/loongarch/include/asm/kvm_ipi.h
@@ -41,5 +41,6 @@ struct ipi_state {
 #define IOCSR_ANY_SEND		0x158
 
 int kvm_loongarch_register_ipi_device(void);
+void kvm_loongarch_unregister_ipi_device(void);
 
 #endif
diff --git a/arch/loongarch/include/asm/kvm_pch_pic.h b/arch/loongarch/include/asm/kvm_pch_pic.h
index 7f33a30392728..c0aa2727587d6 100644
--- a/arch/loongarch/include/asm/kvm_pch_pic.h
+++ b/arch/loongarch/include/asm/kvm_pch_pic.h
@@ -69,6 +69,7 @@ struct loongarch_pch_pic {
 };
 
 int kvm_loongarch_register_pch_pic_device(void);
+void kvm_loongarch_unregister_pch_pic_device(void);
 void pch_pic_set_irq(struct loongarch_pch_pic *s, int irq, int level);
 void pch_msi_set_irq(struct kvm *kvm, int irq, int level);
 
diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 1380186fd5aed..771d63f8cfa42 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -700,3 +700,8 @@ int kvm_loongarch_register_eiointc_device(void)
 {
 	return kvm_register_device_ops(&kvm_eiointc_dev_ops, KVM_DEV_TYPE_LOONGARCH_EIOINTC);
 }
+
+void kvm_loongarch_unregister_eiointc_device(void)
+{
+	kvm_unregister_device_ops(KVM_DEV_TYPE_LOONGARCH_EIOINTC);
+}
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 0e2840f75673f..0dd1e2c857a33 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -476,3 +476,8 @@ int kvm_loongarch_register_ipi_device(void)
 {
 	return kvm_register_device_ops(&kvm_ipi_dev_ops, KVM_DEV_TYPE_LOONGARCH_IPI);
 }
+
+void kvm_loongarch_unregister_ipi_device(void)
+{
+	kvm_unregister_device_ops(KVM_DEV_TYPE_LOONGARCH_IPI);
+}
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index ab336cde24f6d..d019788185197 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -495,3 +495,8 @@ int kvm_loongarch_register_pch_pic_device(void)
 {
 	return kvm_register_device_ops(&kvm_pch_pic_dev_ops, KVM_DEV_TYPE_LOONGARCH_PCHPIC);
 }
+
+void kvm_loongarch_unregister_pch_pic_device(void)
+{
+	kvm_unregister_device_ops(KVM_DEV_TYPE_LOONGARCH_PCHPIC);
+}
-- 
2.53.0



