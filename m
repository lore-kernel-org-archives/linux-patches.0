Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE818F44;
	Mon,  4 Mar 2024 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709592178; cv=none; b=RW4o0mIPaAh2gbK+nqBy9jJeT8HRxNLkX1ZkDeJ8n2cr5CpSo+C9oNacEmVipDebxCsmK9DgeRoOg5oPlh4oH/ozyxThKYp4w7OTqVT52B+HnvnGowUqWq+k3QPA6MShvehKnq1hxYJJbH8WvuMi3sRQ2IB9msZB3hl9DjOpyyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709592178; c=relaxed/simple;
	bh=m9jgqjDNt6c65g0zN4cv1FHVWbiB7XhYSMR89OHNNr0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Vn0N06wZ32PdKhIf9PrnczROVqJCpyvXR47WcbfTnOZ2fyghs3H+X+qKPNcIeuZpNbCBvFpNsqKi8SmxGvXrJvnlKz2FvF0Gh+l7e6IfIPG6ofuI0e2ehxO/9w50uCcYYygXoMg58RC/9JN3zu3vlsePc+dld8TDlIgi7yzLxh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=CZ4ygw+3; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="CZ4ygw+3"
Received: from [IPv6:::1] ([172.58.89.104])
	(authenticated bits=0)
	by mail.zytor.com (8.17.2/8.17.1) with ESMTPSA id 424MgkFC728348
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 4 Mar 2024 14:42:47 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 424MgkFC728348
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024021201; t=1709592167;
	bh=a0Yz9vFnFfuKE1gy6lBQhzes8lkaVvz6UlYRcSGrdmQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=CZ4ygw+3aIPhrIJEwNmvIFkiyTc01oSZX8zHOqD2UGKEI+QiHeUQV0laZgK2Z7a5F
	 3ud85mp/SrVRVl7G38nMMD3a2GjiCYorR0TuED3lQG6NLs9QPuZaCmv+EUe4ZTCyJp
	 YEyJO6IJxPXNiL5+zlpva0eKse3yrIxeeCQQA5BtDn3oYGIbjsuuXMGAGhmd+ye0sS
	 WkSg5o0M0n0BzNyRexlWhqVSaqePL0bWETzpqIauDxyRkP77QmiSk/YvgCprB60E0Z
	 LY80bBlWuDJ+Mah8BUAPIES1fapuyxwZwMZ+MZnlN4W0yrYNi8eAMtfXRWZTY1szPX
	 g23r7CawUhTWA==
Date: Mon, 04 Mar 2024 14:42:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
CC: patches@lists.linux.dev, Alexander Lobakin <alexandr.lobakin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_6=2E1_128/215=5D_x86/boot=3A_Robustify_call?= =?US-ASCII?Q?ing_startup=5F=7B32=2C64=7D=28=29_from_the_decompressor_code?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20240304211601.130294874@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org> <20240304211601.130294874@linuxfoundation.org>
Message-ID: <E57FF738-3527-45F3-891D-FD54E6E7E217@zytor.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On March 4, 2024 1:23:11 PM PST, Greg Kroah-Hartman <gregkh@linuxfoundation=
=2Eorg> wrote:
>6=2E1-stable review patch=2E  If anyone has any objections, please let me=
 know=2E
>
>------------------
>
>From: Alexander Lobakin <alexandr=2Elobakin@intel=2Ecom>
>
>commit 7734a0f31e99c433df3063bbb7e8ee5a16a2cb82 upstream=2E
>
>After commit ce697ccee1a8 ("kbuild: remove head-y syntax"), I
>started digging whether x86 is ready for removing this old cruft=2E
>Removing its objects from the list makes the kernel unbootable=2E
>This applies only to bzImage, vmlinux still works correctly=2E
>The reason is that with no strict object order determined by the
>linker arguments, not the linker script, startup_64 can be placed
>not right at the beginning of the kernel=2E
>Here's vmlinux=2Emap's beginning before removing:
>
>  ffffffff81000000         vmlinux=2Eo:(=2Ehead=2Etext)
>  ffffffff81000000                 startup_64
>  ffffffff81000070                 secondary_startup_64
>  ffffffff81000075                 secondary_startup_64_no_verify
>  ffffffff81000160                 verify_cpu
>
>and after:
>
>  ffffffff81000000         vmlinux=2Eo:(=2Ehead=2Etext)
>  ffffffff81000000                 pvh_start_xen
>  ffffffff81000080                 startup_64
>  ffffffff810000f0                 secondary_startup_64
>  ffffffff810000f5                 secondary_startup_64_no_verify
>
>Not a problem itself, but the self-extractor code has the address of
>that function hardcoded the beginning, not looking onto the ELF
>header, which always contains the address of startup_{32,64}()=2E
>
>So, instead of doing an "act of blind faith", just take the address
>from the ELF header and extract a relative offset to the entry
>point=2E The decompressor function already returns a pointer to the
>beginning of the kernel to the Asm code, which then jumps to it,
>so add that offset to the return value=2E
>This doesn't change anything for now, but allows to resign from the
>"head object list" for x86 and makes sure valid Kbuild or any other
>improvements won't break anything here in general=2E
>
>Signed-off-by: Alexander Lobakin <alexandr=2Elobakin@intel=2Ecom>
>Signed-off-by: Ingo Molnar <mingo@kernel=2Eorg>
>Tested-by: Jiri Slaby <jirislaby@kernel=2Eorg>
>Cc: "H=2E Peter Anvin" <hpa@zytor=2Ecom>
>Cc: Linus Torvalds <torvalds@linux-foundation=2Eorg>
>Link: https://lore=2Ekernel=2Eorg/r/20230109170403=2E4117105-2-alexandr=
=2Elobakin@intel=2Ecom
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation=2Eorg>
>---
> arch/x86/boot/compressed/head_32=2ES |    2 +-
> arch/x86/boot/compressed/head_64=2ES |    2 +-
> arch/x86/boot/compressed/misc=2Ec    |   18 +++++++++++-------
> 3 files changed, 13 insertions(+), 9 deletions(-)
>
>--- a/arch/x86/boot/compressed/head_32=2ES
>+++ b/arch/x86/boot/compressed/head_32=2ES
>@@ -187,7 +187,7 @@ SYM_FUNC_START_LOCAL_NOALIGN(=2ELrelocated
> 	leal	boot_heap@GOTOFF(%ebx), %eax
> 	pushl	%eax			/* heap area */
> 	pushl	%esi			/* real mode pointer */
>-	call	extract_kernel		/* returns kernel location in %eax */
>+	call	extract_kernel		/* returns kernel entry point in %eax */
> 	addl	$24, %esp
>=20
> /*
>--- a/arch/x86/boot/compressed/head_64=2ES
>+++ b/arch/x86/boot/compressed/head_64=2ES
>@@ -580,7 +580,7 @@ SYM_FUNC_START_LOCAL_NOALIGN(=2ELrelocated
> 	movl	input_len(%rip), %ecx	/* input_len */
> 	movq	%rbp, %r8		/* output target address */
> 	movl	output_len(%rip), %r9d	/* decompressed length, end of relocs */
>-	call	extract_kernel		/* returns kernel location in %rax */
>+	call	extract_kernel		/* returns kernel entry point in %rax */
> 	popq	%rsi
>=20
> /*
>--- a/arch/x86/boot/compressed/misc=2Ec
>+++ b/arch/x86/boot/compressed/misc=2Ec
>@@ -277,7 +277,7 @@ static inline void handle_relocations(vo
> { }
> #endif
>=20
>-static void parse_elf(void *output)
>+static size_t parse_elf(void *output)
> {
> #ifdef CONFIG_X86_64
> 	Elf64_Ehdr ehdr;
>@@ -293,10 +293,8 @@ static void parse_elf(void *output)
> 	if (ehdr=2Ee_ident[EI_MAG0] !=3D ELFMAG0 ||
> 	   ehdr=2Ee_ident[EI_MAG1] !=3D ELFMAG1 ||
> 	   ehdr=2Ee_ident[EI_MAG2] !=3D ELFMAG2 ||
>-	   ehdr=2Ee_ident[EI_MAG3] !=3D ELFMAG3) {
>+	   ehdr=2Ee_ident[EI_MAG3] !=3D ELFMAG3)
> 		error("Kernel is not a valid ELF file");
>-		return;
>-	}
>=20
> 	debug_putstr("Parsing ELF=2E=2E=2E ");
>=20
>@@ -328,6 +326,8 @@ static void parse_elf(void *output)
> 	}
>=20
> 	free(phdrs);
>+
>+	return ehdr=2Ee_entry - LOAD_PHYSICAL_ADDR;
> }
>=20
> /*
>@@ -356,6 +356,7 @@ asmlinkage __visible void *extract_kerne
> 	const unsigned long kernel_total_size =3D VO__end - VO__text;
> 	unsigned long virt_addr =3D LOAD_PHYSICAL_ADDR;
> 	unsigned long needed_size;
>+	size_t entry_offset;
>=20
> 	/* Retain x86 boot parameters pointer passed from startup_32/64=2E */
> 	boot_params =3D rmode;
>@@ -456,14 +457,17 @@ asmlinkage __visible void *extract_kerne
> 	debug_putstr("\nDecompressing Linux=2E=2E=2E ");
> 	__decompress(input_data, input_len, NULL, NULL, output, output_len,
> 			NULL, error);
>-	parse_elf(output);
>+	entry_offset =3D parse_elf(output);
> 	handle_relocations(output, output_len, virt_addr);
>-	debug_putstr("done=2E\nBooting the kernel=2E\n");
>+
>+	debug_putstr("done=2E\nBooting the kernel (entry_offset: 0x");
>+	debug_puthex(entry_offset);
>+	debug_putstr(")=2E\n");
>=20
> 	/* Disable exception handling before booting the kernel */
> 	cleanup_exception_handling();
>=20
>-	return output;
>+	return output + entry_offset;
> }
>=20
> void fortify_panic(const char *name)
>
>

I would be surprised if this *didn't* break some boot loader=2E =2E=2E
