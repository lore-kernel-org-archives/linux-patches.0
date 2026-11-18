Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031051;
	b=bxJscYkQ0velFQFsJ7zv78njg55NGMJHCPTHafzy5/SZT4cuGr48r1q4UPU/7I4dSQbC
	 kGmH3xiYYyfdCuuf2+0Lg0iq9dma+HY/38z5SCYNEYVkbxUBaueyieLtyjrdzpK9bQ1fj
	 ecyuwu5rbZgp+DmCO/vPllW/blx4lEEqLuIec/LhGrx1MzqEPUtFzKvWkOIZPqXemrbkj
	 VpHaJYwsE6r9xDMb8uAS6M2kM1LaJxdGSaNm4Qhf3OuSB3dg34VsTiih/rwanW+6t0Na0
	 BJDT3t82pu3CahIRa4LnMkVRgO6J8kvSIE6BIbwIqyfOYlqVZC4HTvTiuoCTZzc8TsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6nF6/FlQNXhy85/FlchRfCHbmfvfzM/9V20XvRu9G8E=;
	b=jaMpzoSHO83IVeJr3z6EfXDj4j+rh5EW2DgtQf/V+Hs23mOaq54ySpdEwA8sTKkHdTVE
	 u6aWhYccw30SOid0D/oWvMFcYAcGCaWgAzg3KPZwPDog5CVZ90/1Zcwd9VAicC3fRYnlc
	 uD0sq6w29IAYfBNSW0Esmtwsz6KhBn6q+mjucaUpGtA2R2cX9lFulWMy+G4aKiTAQntOX
	 Y8Rcrc5r4Su4eaCr2SC14v1W9ENSRr1ZHg2AO5AAoMeNvyZdUS7SZQZ6JkpFieAxp7TxC
	 DBeYNdy4J+DA58QyvCRoWwiL3ZDlOoPVVO2E0zF/Ev7bYwZHZ5eTObdoqXT7+fMtnlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oULxKdu0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3751E606A31C;
	Wed, 18 Nov 2026 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oULxKdu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8671F000C4;
	Wed, 18 Nov 2026 19:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031051;
	bh=6nF6/FlQNXhy85/FlchRfCHbmfvfzM/9V20XvRu9G8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oULxKdu00OKlPwbealr9Nm0+1TERnOfcm+q1k/nakf/iDUOdT1hw0GozXFU1H3qvT
	 SQGqXCpx+R+pgBqsn2uY203na5bM40d4YcEtd+/LJXMQHkQ+E3jvkp5+9xKxzTcXKh
	 AXtMa2jXB0y1Evel+Y4Ao2cj/+4eeivSL57ypyl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0919/1756] x86/efistub: Merge PE and handover entrypoints
Date: Wed, 18 Nov 2026 15:50:46 +0100
Message-ID: <20261118150046.570346473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit dac628e9563640e2de7878decc03a508b1ba319a ]

The difference between the PE and handover entrypoints in the EFI stub
is that the former allocates a struct boot_params whereas the latter
expects one from the caller. Currently, these are two completely
separate entrypoints, duplicating some logic and both relying of
efi_exit() to return straight back to the firmware on an error.

Simplify this by making the PE entrypoint call the handover entrypoint
with NULL as the argument for the struct boot_params parameter. This
makes the code easier to follow, and removes the need to support two
different calling conventions in the mixed mode asm code.

While at it, move the assignment of boot_params_ptr into the function
that actually calls into the legacy decompressor, which is where its
value is required.

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Stable-dep-of: 8ea857a2bb54 ("efi/libstub: Free cmdline_ptr in efi_pe_entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/efi_mixed.S    | 16 +-------
 drivers/firmware/efi/libstub/x86-stub.c | 52 ++++++++++++++-----------
 2 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/arch/x86/boot/compressed/efi_mixed.S b/arch/x86/boot/compressed/efi_mixed.S
index 876fc6d46a131..d681e30c6732c 100644
--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -56,22 +56,8 @@ SYM_FUNC_START(startup_64_mixed_mode)
 	movl	efi32_boot_sp(%rip), %esp
 	andl	$~7, %esp
 
-#ifdef CONFIG_EFI_HANDOVER_PROTOCOL
 	mov	8(%rdx), %edx		// saved bootparams pointer
-	test	%edx, %edx
-	jnz	efi_stub_entry
-#endif
-	/*
-	 * efi_pe_entry uses MS calling convention, which requires 32 bytes of
-	 * shadow space on the stack even if all arguments are passed in
-	 * registers. We also need an additional 8 bytes for the space that
-	 * would be occupied by the return address, and this also results in
-	 * the correct stack alignment for entry.
-	 */
-	sub	$40, %rsp
-	mov	%rdi, %rcx		// MS calling convention
-	mov	%rsi, %rdx
-	jmp	efi_pe_entry
+	call	efi_stub_entry
 SYM_FUNC_END(startup_64_mixed_mode)
 
 SYM_FUNC_START(__efi64_thunk)
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index d54454cbab1c3..2d7c6817af4b7 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -401,17 +401,13 @@ static void __noreturn efi_exit(efi_handle_t handle, efi_status_t status)
 		asm("hlt");
 }
 
-void __noreturn efi_stub_entry(efi_handle_t handle,
-			       efi_system_table_t *sys_table_arg,
-			       struct boot_params *boot_params);
-
 /*
  * Because the x86 boot code expects to be passed a boot_params we
  * need to create one ourselves (usually the bootloader would create
  * one for us).
  */
-efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
-				   efi_system_table_t *sys_table_arg)
+static efi_status_t efi_allocate_bootparams(efi_handle_t handle,
+					    struct boot_params **bp)
 {
 	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
 	struct boot_params *boot_params;
@@ -421,21 +417,15 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	unsigned long alloc;
 	char *cmdline_ptr;
 
-	efi_system_table = sys_table_arg;
-
-	/* Check if we were booted by the EFI firmware */
-	if (efi_system_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		efi_exit(handle, EFI_INVALID_PARAMETER);
-
 	status = efi_bs_call(handle_protocol, handle, &proto, (void **)&image);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
-		efi_exit(handle, status);
+		return status;
 	}
 
 	status = efi_allocate_pages(PARAM_SIZE, &alloc, ULONG_MAX);
 	if (status != EFI_SUCCESS)
-		efi_exit(handle, status);
+		return status;
 
 	boot_params = memset((void *)alloc, 0x0, PARAM_SIZE);
 	hdr	    = &boot_params->hdr;
@@ -451,14 +441,14 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	cmdline_ptr = efi_convert_cmdline(image, &options_size);
 	if (!cmdline_ptr) {
 		efi_free(PARAM_SIZE, alloc);
-		efi_exit(handle, EFI_OUT_OF_RESOURCES);
+		return EFI_OUT_OF_RESOURCES;
 	}
 
 	efi_set_u64_split((unsigned long)cmdline_ptr, &hdr->cmd_line_ptr,
 			  &boot_params->ext_cmd_line_ptr);
 
-	efi_stub_entry(handle, sys_table_arg, boot_params);
-	/* not reached */
+	*bp = boot_params;
+	return EFI_SUCCESS;
 }
 
 static void add_e820ext(struct boot_params *params,
@@ -745,13 +735,16 @@ static efi_status_t parse_options(const char *cmdline)
 	return efi_parse_options(cmdline);
 }
 
-static efi_status_t efi_decompress_kernel(unsigned long *kernel_entry)
+static efi_status_t efi_decompress_kernel(unsigned long *kernel_entry,
+					  struct boot_params *boot_params)
 {
 	unsigned long virt_addr = LOAD_PHYSICAL_ADDR;
 	unsigned long addr, alloc_size, entry;
 	efi_status_t status;
 	u32 seed[2] = {};
 
+	boot_params_ptr	= boot_params;
+
 	/* determine the required size of the allocation */
 	alloc_size = ALIGN(max_t(unsigned long, output_len, kernel_total_size),
 			   MIN_KERNEL_ALIGN);
@@ -782,7 +775,7 @@ static efi_status_t efi_decompress_kernel(unsigned long *kernel_entry)
 			seed[0] = 0;
 		}
 
-		boot_params_ptr->hdr.loadflags |= KASLR_FLAG;
+		boot_params->hdr.loadflags |= KASLR_FLAG;
 	}
 
 	status = efi_random_alloc(alloc_size, CONFIG_PHYSICAL_ALIGN, &addr,
@@ -820,20 +813,27 @@ static void __noreturn enter_kernel(unsigned long kernel_addr,
 void __noreturn efi_stub_entry(efi_handle_t handle,
 			       efi_system_table_t *sys_table_arg,
 			       struct boot_params *boot_params)
+
 {
 	efi_guid_t guid = EFI_MEMORY_ATTRIBUTE_PROTOCOL_GUID;
-	struct setup_header *hdr = &boot_params->hdr;
 	const struct linux_efi_initrd *initrd = NULL;
 	unsigned long kernel_entry;
+	struct setup_header *hdr;
 	efi_status_t status;
 
-	boot_params_ptr = boot_params;
-
 	efi_system_table = sys_table_arg;
 	/* Check if we were booted by the EFI firmware */
 	if (efi_system_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		efi_exit(handle, EFI_INVALID_PARAMETER);
 
+	if (!IS_ENABLED(CONFIG_EFI_HANDOVER_PROTOCOL) || !boot_params) {
+		status = efi_allocate_bootparams(handle, &boot_params);
+		if (status != EFI_SUCCESS)
+			efi_exit(handle, status);
+	}
+
+	hdr = &boot_params->hdr;
+
 	if (have_unsupported_snp_features())
 		efi_exit(handle, EFI_UNSUPPORTED);
 
@@ -875,7 +875,7 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 	if (efi_mem_encrypt > 0)
 		hdr->xloadflags |= XLF_MEM_ENCRYPTION;
 
-	status = efi_decompress_kernel(&kernel_entry);
+	status = efi_decompress_kernel(&kernel_entry, boot_params);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to decompress kernel\n");
 		goto fail;
@@ -945,6 +945,12 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 	efi_exit(handle, status);
 }
 
+efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
+				   efi_system_table_t *sys_table_arg)
+{
+	efi_stub_entry(handle, sys_table_arg, NULL);
+}
+
 #ifdef CONFIG_EFI_HANDOVER_PROTOCOL
 void efi_handover_entry(efi_handle_t handle, efi_system_table_t *sys_table_arg,
 			struct boot_params *boot_params)
-- 
2.53.0



