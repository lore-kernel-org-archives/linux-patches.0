Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590793;
	b=miFp0uijb5vhuh/uagSrYk49TCkIFr7EMN+tWj/8TSIcfYjw1ea8YB6GBrpU4LUfN2GJ
	 O8r/nDCeTiDLhCuA7p4+ipEnnD7eib7CeJgDxmKKL4+S79F57bdwwSfIK0BzBqhsgIk3I
	 28IeZTFXikve4W5C4sDrjWghcMoaKz8QY18cTKT1xA8VvWn0xfKKQ5AUhwz6sk23AK7A7
	 ofPBnhCrvBbUR0Txeu2B1LfMRDi7wMBVb9zepHGni6xCIl7TOKLymqHfun1bEX1ZOWk8m
	 Twog3i6F2ld+tmt5OL/UeAa8RPFtMQsKfn3cQyRZsi/KBHqeNqeztvjfozUIBq18BUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X4TqxWE+Uv3hx6kARlMmJHBefVjz12MT9y+EiYVIqTA=;
	b=yj6fldzUtBIoHbOxBmFnbC3MqeiHXdzAY2zemOU6KbvVfhOGFYVUZA1Mm+sfZUhZ6rkG
	 ozonM1xCmuB4fPGYk2d6Cqk79BmsroLtvV5qn4TzLwhUJTsMogedqP6iNe4/SqmydrkpT
	 Z62vig1oxFRyOPuAN6UNfQgJlXriDL/Ylcnw+UMmkkQOIMrM92HfxS03sdGBqySphBai6
	 FLB3gTl2dq0mw6HSEx4uj5kFBDmHY/Sh+MOX71rV7gx38mYySv1efQGjcDnvJ2C5DARxE
	 bbTRmyVyE9Y1v85UJPwv2JES3BxOhSujO1S978leJNE422EuiPg3Wy2qd+UG0l3IN4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TwcXliL/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E52607D2CD;
	Fri, 13 Nov 2026 17:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwcXliL/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7483B1F000C6;
	Fri, 13 Nov 2026 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590793;
	bh=X4TqxWE+Uv3hx6kARlMmJHBefVjz12MT9y+EiYVIqTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwcXliL/Y7blAndok8HxqJKdU5PbY4O6x7ZxaSPHdfHeWt856zHEpoFtBtDbobJPV
	 CaXArvB2FXk1c0y1gindMgOx4c0l2DpbV5m0uebXs7HWbOXYxx5ScUKgiP55U5GG7/
	 l/MIwi4Kj7iY8BtukoV3KdX9xh7XN2TVeqO4g2jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 649/686] Documentation/kernel-parameters: Move the kernel build options
Date: Fri, 13 Nov 2026 10:53:02 -0500
Message-ID: <20261113153843.764696135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit f690e07859e67505e7106ef5b4fae5e8b71b2109 ]

Move the kernel build options abbreviations to the .txt file so that
they are together instead of one having to go hunt them in the .rst
file.

Tweak the formatting so that the inclusion of kernel-parameters.txt
still keeps the whole thing somewhat presentable in the html output too.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20251112114641.8230-1-bp@kernel.org>
Stable-dep-of: 799203afd298 ("nvme-tcp: validate the TLS handshake timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.rst         | 97 +-----------------
 .../admin-guide/kernel-parameters.txt         | 98 +++++++++++++++++++
 2 files changed, 99 insertions(+), 96 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index 7bf8cc7df6b54..02a725536cc50 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -110,102 +110,7 @@ The parameters listed below are only valid if certain kernel build options
 were enabled and if respective hardware is present. This list should be kept
 in alphabetical order. The text in square brackets at the beginning
 of each description states the restrictions within which a parameter
-is applicable::
-
-	ACPI	ACPI support is enabled.
-	AGP	AGP (Accelerated Graphics Port) is enabled.
-	ALSA	ALSA sound support is enabled.
-	APIC	APIC support is enabled.
-	APM	Advanced Power Management support is enabled.
-	APPARMOR AppArmor support is enabled.
-	ARM	ARM architecture is enabled.
-	ARM64	ARM64 architecture is enabled.
-	AX25	Appropriate AX.25 support is enabled.
-	CLK	Common clock infrastructure is enabled.
-	CMA	Contiguous Memory Area support is enabled.
-	DRM	Direct Rendering Management support is enabled.
-	DYNAMIC_DEBUG Build in debug messages and enable them at runtime
-	EARLY	Parameter processed too early to be embedded in initrd.
-	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
-	EFI	EFI Partitioning (GPT) is enabled
-	EVM	Extended Verification Module
-	FB	The frame buffer device is enabled.
-	FTRACE	Function tracing enabled.
-	GCOV	GCOV profiling is enabled.
-	HIBERNATION HIBERNATION is enabled.
-	HW	Appropriate hardware is enabled.
-	HYPER_V HYPERV support is enabled.
-	IMA     Integrity measurement architecture is enabled.
-	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
-	IPV6	IPv6 support is enabled.
-	ISAPNP	ISA PnP code is enabled.
-	ISDN	Appropriate ISDN support is enabled.
-	ISOL	CPU Isolation is enabled.
-	JOY	Appropriate joystick support is enabled.
-	KGDB	Kernel debugger support is enabled.
-	KVM	Kernel Virtual Machine support is enabled.
-	LIBATA  Libata driver is enabled
-	LOONGARCH LoongArch architecture is enabled.
-	LOOP	Loopback device support is enabled.
-	LP	Printer support is enabled.
-	M68k	M68k architecture is enabled.
-			These options have more detailed description inside of
-			Documentation/arch/m68k/kernel-options.rst.
-	MDA	MDA console support is enabled.
-	MIPS	MIPS architecture is enabled.
-	MOUSE	Appropriate mouse support is enabled.
-	MSI	Message Signaled Interrupts (PCI).
-	MTD	MTD (Memory Technology Device) support is enabled.
-	NET	Appropriate network support is enabled.
-	NFS	Appropriate NFS support is enabled.
-	NUMA	NUMA support is enabled.
-	OF	Devicetree is enabled.
-	PARISC	The PA-RISC architecture is enabled.
-	PCI	PCI bus support is enabled.
-	PCIE	PCI Express support is enabled.
-	PCMCIA	The PCMCIA subsystem is enabled.
-	PNP	Plug & Play support is enabled.
-	PPC	PowerPC architecture is enabled.
-	PPT	Parallel port support is enabled.
-	PS2	Appropriate PS/2 support is enabled.
-	PV_OPS	A paravirtualized kernel is enabled.
-	RAM	RAM disk support is enabled.
-	RDT	Intel Resource Director Technology.
-	RISCV	RISCV architecture is enabled.
-	S390	S390 architecture is enabled.
-	SCSI	Appropriate SCSI support is enabled.
-			A lot of drivers have their options described inside
-			the Documentation/scsi/ sub-directory.
-        SDW     SoundWire support is enabled.
-	SECURITY Different security models are enabled.
-	SELINUX SELinux support is enabled.
-	SERIAL	Serial support is enabled.
-	SH	SuperH architecture is enabled.
-	SMP	The kernel is an SMP kernel.
-	SPARC	Sparc architecture is enabled.
-	SUSPEND	System suspend states are enabled.
-	SWSUSP	Software suspend (hibernation) is enabled.
-	TPM	TPM drivers are enabled.
-	UMS	USB Mass Storage support is enabled.
-	USB	USB support is enabled.
-	USBHID	USB Human Interface Device support is enabled.
-	V4L	Video For Linux support is enabled.
-	VGA	The VGA console has been enabled.
-	VMMIO   Driver for memory mapped virtio devices is enabled.
-	VT	Virtual terminal support is enabled.
-	WDT	Watchdog support is enabled.
-	X86-32	X86-32, aka i386 architecture is enabled.
-	X86-64	X86-64 architecture is enabled.
-	X86	Either 32-bit or 64-bit x86 (same as X86-32+X86-64)
-	X86_UV	SGI UV support is enabled.
-	XEN	Xen support is enabled
-	XTENSA	xtensa architecture is enabled.
-
-In addition, the following text indicates that the option::
-
-	BOOT	Is a boot loader parameter.
-	BUGS=	Relates to possible processor bugs on the said processor.
-	KNL	Is a kernel start-up parameter.
+is applicable.
 
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 362ff32252209..5bf1df91607eb 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1,3 +1,101 @@
+	ACPI	ACPI support is enabled.
+	AGP	AGP (Accelerated Graphics Port) is enabled.
+	ALSA	ALSA sound support is enabled.
+	APIC	APIC support is enabled.
+	APM	Advanced Power Management support is enabled.
+	APPARMOR AppArmor support is enabled.
+	ARM	ARM architecture is enabled.
+	ARM64	ARM64 architecture is enabled.
+	AX25	Appropriate AX.25 support is enabled.
+	CLK	Common clock infrastructure is enabled.
+	CMA	Contiguous Memory Area support is enabled.
+	DRM	Direct Rendering Management support is enabled.
+	DYNAMIC_DEBUG Build in debug messages and enable them at runtime
+	EARLY	Parameter processed too early to be embedded in initrd.
+	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
+	EFI	EFI Partitioning (GPT) is enabled
+	EVM	Extended Verification Module
+	FB	The frame buffer device is enabled.
+	FTRACE	Function tracing enabled.
+	GCOV	GCOV profiling is enabled.
+	HIBERNATION HIBERNATION is enabled.
+	HW	Appropriate hardware is enabled.
+	HYPER_V HYPERV support is enabled.
+	IMA     Integrity measurement architecture is enabled.
+	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
+	IPV6	IPv6 support is enabled.
+	ISAPNP	ISA PnP code is enabled.
+	ISDN	Appropriate ISDN support is enabled.
+	ISOL	CPU Isolation is enabled.
+	JOY	Appropriate joystick support is enabled.
+	KGDB	Kernel debugger support is enabled.
+	KVM	Kernel Virtual Machine support is enabled.
+	LIBATA  Libata driver is enabled
+	LOONGARCH LoongArch architecture is enabled.
+	LOOP	Loopback device support is enabled.
+	LP	Printer support is enabled.
+	M68k	M68k architecture is enabled.
+			These options have more detailed description inside of
+			Documentation/arch/m68k/kernel-options.rst.
+	MDA	MDA console support is enabled.
+	MIPS	MIPS architecture is enabled.
+	MOUSE	Appropriate mouse support is enabled.
+	MSI	Message Signaled Interrupts (PCI).
+	MTD	MTD (Memory Technology Device) support is enabled.
+	NET	Appropriate network support is enabled.
+	NFS	Appropriate NFS support is enabled.
+	NUMA	NUMA support is enabled.
+	OF	Devicetree is enabled.
+	PARISC	The PA-RISC architecture is enabled.
+	PCI	PCI bus support is enabled.
+	PCIE	PCI Express support is enabled.
+	PCMCIA	The PCMCIA subsystem is enabled.
+	PNP	Plug & Play support is enabled.
+	PPC	PowerPC architecture is enabled.
+	PPT	Parallel port support is enabled.
+	PS2	Appropriate PS/2 support is enabled.
+	PV_OPS	A paravirtualized kernel is enabled.
+	RAM	RAM disk support is enabled.
+	RDT	Intel Resource Director Technology.
+	RISCV	RISCV architecture is enabled.
+	S390	S390 architecture is enabled.
+	SCSI	Appropriate SCSI support is enabled.
+			A lot of drivers have their options described inside
+			the Documentation/scsi/ sub-directory.
+        SDW     SoundWire support is enabled.
+	SECURITY Different security models are enabled.
+	SELINUX SELinux support is enabled.
+	SERIAL	Serial support is enabled.
+	SH	SuperH architecture is enabled.
+	SMP	The kernel is an SMP kernel.
+	SPARC	Sparc architecture is enabled.
+	SUSPEND	System suspend states are enabled.
+	SWSUSP	Software suspend (hibernation) is enabled.
+	TPM	TPM drivers are enabled.
+	UMS	USB Mass Storage support is enabled.
+	USB	USB support is enabled.
+	USBHID	USB Human Interface Device support is enabled.
+	V4L	Video For Linux support is enabled.
+	VGA	The VGA console has been enabled.
+	VMMIO   Driver for memory mapped virtio devices is enabled.
+	VT	Virtual terminal support is enabled.
+	WDT	Watchdog support is enabled.
+	X86-32	X86-32, aka i386 architecture is enabled.
+	X86-64	X86-64 architecture is enabled.
+	X86	Either 32-bit or 64-bit x86 (same as X86-32+X86-64)
+	X86_UV	SGI UV support is enabled.
+	XEN	Xen support is enabled
+	XTENSA	xtensa architecture is enabled.
+
+In addition, the following text indicates that the option
+
+	BOOT	Is a boot loader parameter.
+	BUGS=	Relates to possible processor bugs on the said processor.
+	KNL	Is a kernel start-up parameter.
+
+
+Kernel parameters
+
 	accept_memory=  [MM]
 			Format: { eager | lazy }
 			default: lazy
-- 
2.53.0



