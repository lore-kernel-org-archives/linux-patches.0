Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620007;
	b=Wzk82zVrMdnxZpRkhp9QE5Lssa+RSW3dsFZ12K+u+ZmaDTlEVyLcymRUkx4h/s6rFqCb
	 4ORQPYR3QlahiheY6miuJZEIIyRjs1x9/PaEXwrRglSxuGPakirdyK6lPOftGB6xcEVGa
	 thznnxM9lTLMoCD4dVu8Nt8By1TGFh7JraglRNQ4ODLwa/EWIgodFwO6xxjrhx1eGuQY4
	 5hRZBuOG2Btj7RCEExec7T7c8aYKQLamaF8Ujlin+3vFXNxSzBVOpm3RfkajsCiXLmYNs
	 vFMmzjkMNpcU34rig7deP4P766Gv6/nQg+AFp33tMqpQ1fGLfls1FpBrQs49K4uUWcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VqW20fjntJNEY8sXOms7FE3/ILvzxq+fGPajv4P5y/Y=;
	b=GsPv3hcDnhnHJ4xC7J0vX33brG4VXQbwIvxnEZCbiUEjnignIZsZTGUxXe7/dYAQUXgV
	 R7BCxfu1TboDMARgRzxRM9LDTJbGo60vJ30LPCMPvl4qCpp5bCvhdEfCAWA6thwCKdjM9
	 DsQeowXKX3C6Pb0sddG324XDqpe8qI6kjOgFaVHTK+CV0Vl0D0yQnbM15c+mWwr1UVxrC
	 yAPQtB9QYa8iju4hfLpfFlB9rUifJeM5/3DK/zkGY1HJwJ+qBjE0dxwwq30XTxF7JB3OB
	 BSf2rHcg8pYOxeQEVeEHXDf8RtBsKJ/4EQ3lfFusSS6vrLIgrp+TeiPmI1vreNO4yog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qagUxQqV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D547606A32D;
	Wed, 25 Nov 2026 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qagUxQqV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0901F000C0;
	Wed, 25 Nov 2026 15:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620007;
	bh=VqW20fjntJNEY8sXOms7FE3/ILvzxq+fGPajv4P5y/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qagUxQqV0cr1zmyIPyghVIPChgHaSi9k8GxdRZSNP7TmWIvDiyM8NVzKrG98mkqKI
	 /hDHe5arkzkVVKGFmPiDCEhf2bDIDZGyBG3pgd9Ko3FBYdd3WOUG+ArEvT1bxW4LeE
	 MYdqqgNu9gyvHkYKXCBItGsDjgH+Wx3a/NObqG7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.3 0777/1005] LoongArch: Restore KFENCE pages through DMW on resume
Date: Wed, 25 Nov 2026 15:35:15 +0100
Message-ID: <20261125143839.943347263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit 40d7a3e63c3d88b43e9115d23d9937dd506bbd02 upstream.

With KFENCE enabled, resume from hibernation triggers KFENCE reports
while swsusp_asm_resume() copies the image pages, for example:

  BUG: KFENCE: use-after-free write in swsusp_asm_resume+0x20/0x94

  Use-after-free write at 0x00000000a57ee925 (in kfence-#254):
   swsusp_asm_resume+0x20/0x94
   hibernation_restore+0x128/0x1a0
   load_image_and_restore+0x6c/0xc8
   software_resume+0x240/0x260
   do_one_initcall+0x68/0x200
   kernel_init_freeable+0x26c/0x304
   kernel_init+0x20/0x134
   ret_from_kernel_thread+0x24/0x1d0
   ret_from_kernel_thread_asm+0xc/0x98

During resume from hibernation, the image pages that occupy physical
pages used by the restore kernel are first loaded into free pages and
then, as the very last step, swsusp_asm_resume() copies them to their
final location pointed to by pbe->orig_address, which the hibernation
core sets to page_address() of the page in the restore kernel.

The early KFENCE pool is allocated from memblock and normally occupies
the same physical pages in the restore kernel and in the image kernel,
so these pages are usually copied by swsusp_asm_resume().

The KFENCE pool is remapped into the KFENCE area above vm_map_base and
set_page_address() adjusts page->virtual so that page_address() returns
the page-table mapped alias rather than the DMW virtual address of the
pool pages.

Hence, pbe->orig_address of KFENCE pages points to that alias and
swsusp_asm_resume() writes them through the page tables. But:

* the copy loop overwrites the kernel page tables, so a TLB refill for
  the KFENCE alias may use a partially restored page table
* the KFENCE pool pages that are protected in the restore kernel fault
  in the middle of the copy

Convert pbe->orig_address to DMW addresses before starting the copy.

Cc: stable@vger.kernel.org
Fixes: 0ca84aeaee15 ("LoongArch: Make {virt, phys, page, pfn} translation work with KFENCE")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/power/hibernate.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/loongarch/power/hibernate.c
+++ b/arch/loongarch/power/hibernate.c
@@ -59,6 +59,12 @@ extern int swsusp_asm_resume(void);
 
 int swsusp_arch_resume(void)
 {
+#ifdef CONFIG_KFENCE
+	struct pbe *pbe;
+
+	for (pbe = restore_pblist; pbe; pbe = pbe->next)
+		pbe->orig_address = __va(virt_to_phys(pbe->orig_address));
+#endif
 	/* Avoid TLB mismatch during and after kernel resume */
 	local_flush_tlb_all();
 	return swsusp_asm_resume();


