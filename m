Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623243;
	b=hkb7rRCW/uclb0GaqvCf/ufr9Hcm4FbUqKKhQ2IA7WyN4OwSvz00TIwCEnsLHOrhuoHk
	 CcAjh6i4nWOv/OBtphuj3SCwfQe220A84inIIlPmR6OIc+k5vZ6pvyKV19T849gPnpyIi
	 dYkIAUsG5UVv81vu6TELgGt0wf3xw2kGJIug2TItOx7bdf4Qmw/MHEq7/Ov3sIlsZip0R
	 RvtusaRuJPtmGOsKDYImY1erSGiOHjnH3n10rZCav6zZZNIbsoMjTUUglh5p/LL+1wXHg
	 9/6fDYJfFVhwy/SVxihUlMl0N4AeBvbLFnN2BOmyPFgAIemGrRuVaVeLhLOyzJ5BIhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7pzNLDFgGXnXb88ZEnPuGtJWsZy5w4EzC4KINUuBmA=;
	b=OkKTXiqndFPRC07rNryiy8yRcklmK9UNg1U1eyxnFjCHOm4ItlewmmO5M40gaYm5ChIn
	 PVu9WvXue8SXdHap67CduZtjEw3lwq6pFbqOyi7SD+mPT5kuXL9toGBEInO3b7yDungq3
	 Hg/1BpC6T/Ef5+7honUvqgo8duh26w57cC1pzQKjtBumulKMBucVu/kQtxXOwUQTySsoK
	 lERtGX7wTiZlkajUUDS6r4r8FJZh4JxmtATmjWa3sl4e5gx5bM79dtvBcAGQPeNHSiQ5i
	 RLtKF7e5noT/UO/8vBdEYzQCCdj0x1Z9I8Qs6aSAUuJjxz65UPXXEt1QpatVyKtSl6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YO11PPLI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A90606A31E;
	Wed, 25 Nov 2026 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YO11PPLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522421F000D3;
	Wed, 25 Nov 2026 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623242;
	bh=d7pzNLDFgGXnXb88ZEnPuGtJWsZy5w4EzC4KINUuBmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YO11PPLI1Bke2E1ijgyMve8SObWKfTo9oBy1FTD6V68R7n1YcL+vTwSWS+dAPb+Lh
	 Q5y8rmnXA4nSGtUKByNqgfX5fNtzcFx59nc1xQSwI24n8rGfZFI2DSVJssy47bksaN
	 yEWJz2UOjQCSxm/7VvmAQJwq58uI8Qn2aGLJ2jpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 797/990] LoongArch: Restore KFENCE pages through DMW on resume
Date: Wed, 25 Nov 2026 15:36:04 +0100
Message-ID: <20261125143840.713112431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


