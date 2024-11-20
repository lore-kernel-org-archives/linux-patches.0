Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80341AB508;
	Wed, 20 Nov 2024 12:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107514; cv=none; b=JDy2eP4tdJC4c4nC+jkk0SjmIRL27+VAoRJcTCPTNUDgXuOjZYsO+nJs+G+bHNfKUNGAxoZbpR/L2tt/xQg0mlcJ6fF8UeVSjJKo6JnWstSNAcJ9p+SIihTnVZVm6g2tdgJ8lu4/xn2pXo1ezf2FkomEI5SWOE2SesWkRi6rpis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107514; c=relaxed/simple;
	bh=XgwtryoODoYrOJEchyfBzGtwAF2pYs8oBcBVpn6xlvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xu34KR3AiswO8sr5UondsUgx0A74lCb5KUOrWHsU7EItH3/vkQuP/HJid/6yC5fkzl5FstzQN8s+t2qx2RnHgTecg/Mu9WS7tKnWLcFtXUNIJ2GkTypkkyQkkR2R0z9KIcc5gJzT97AwangQ4jzjJOHDvkZIDHEwLBJTD7K53Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOXzY3Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOXzY3Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8047EC4CED1;
	Wed, 20 Nov 2024 12:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107514;
	bh=XgwtryoODoYrOJEchyfBzGtwAF2pYs8oBcBVpn6xlvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOXzY3RnWLs1mTRhI1q+xz5wCBgOqJCNWu8+4oI44xW5irfpSse5Fu1BfOpYLdEVc
	 0yawYUQ/rZaofHBBp0+vP1W/uX71BywGDjByBF6S9/4x+OsgHbbOPp2U8E/8WMQX6G
	 sL3XHIzfGLTb+H0hbvk4oswW3VZUwrHKKRav/jz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Vasilevsky <dave@vasilevsky.ca>,
	=?UTF-8?q?Reimar=20D=C3=B6ffinger?= <Reimar.Doeffinger@gmx.de>,
	Baoquan He <bhe@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.11 044/107] crash, powerpc: default to CRASH_DUMP=n on PPC_BOOK3S_32
Date: Wed, 20 Nov 2024 13:56:19 +0100
Message-ID: <20241120125630.672823639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Vasilevsky <dave@vasilevsky.ca>

commit 31daa34315d45d3fe77f2158d889d523d78852ea upstream.

Fixes boot failures on 6.9 on PPC_BOOK3S_32 machines using Open Firmware.
On these machines, the kernel refuses to boot from non-zero
PHYSICAL_START, which occurs when CRASH_DUMP is on.

Since most PPC_BOOK3S_32 machines boot via Open Firmware, it should
default to off for them.  Users booting via some other mechanism can still
turn it on explicitly.

Does not change the default on any other architectures for the
time being.

Link: https://lkml.kernel.org/r/20240917163720.1644584-1-dave@vasilevsky.ca
Fixes: 75bc255a7444 ("crash: clean up kdump related config items")
Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
Reported-by: Reimar Döffinger <Reimar.Doeffinger@gmx.de>
Closes: https://lists.debian.org/debian-powerpc/2024/07/msg00001.html
Acked-by: Michael Ellerman <mpe@ellerman.id.au>	[powerpc]
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Reimar Döffinger <Reimar.Doeffinger@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig       |    3 +++
 arch/arm64/Kconfig     |    3 +++
 arch/loongarch/Kconfig |    3 +++
 arch/mips/Kconfig      |    3 +++
 arch/powerpc/Kconfig   |    4 ++++
 arch/riscv/Kconfig     |    3 +++
 arch/s390/Kconfig      |    3 +++
 arch/sh/Kconfig        |    3 +++
 arch/x86/Kconfig       |    3 +++
 kernel/Kconfig.kexec   |    2 +-
 10 files changed, 29 insertions(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1597,6 +1597,9 @@ config ATAGS_PROC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config AUTO_ZRELADDR
 	bool "Auto calculation of the decompressed kernel image address" if !ARCH_MULTIPLATFORM
 	default !(ARCH_FOOTBRIDGE || ARCH_RPC || ARCH_SA1100)
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1559,6 +1559,9 @@ config ARCH_DEFAULT_KEXEC_IMAGE_VERIFY_S
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 	def_bool CRASH_RESERVE
 
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -599,6 +599,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_SELECTS_CRASH_DUMP
 	def_bool y
 	depends on CRASH_DUMP
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2881,6 +2881,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded"
 	default "0xffffffff84000000"
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -682,6 +682,10 @@ config RELOCATABLE_TEST
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool PPC64 || PPC_BOOK3S_32 || PPC_85xx || (44x && !SMP)
 
+config ARCH_DEFAULT_CRASH_DUMP
+	bool
+	default y if !PPC_BOOK3S_32
+
 config ARCH_SELECTS_CRASH_DUMP
 	def_bool y
 	depends on CRASH_DUMP
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -884,6 +884,9 @@ config ARCH_SUPPORTS_KEXEC_PURGATORY
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 	def_bool CRASH_RESERVE
 
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -275,6 +275,9 @@ config ARCH_SUPPORTS_CRASH_DUMP
 	  This option also enables s390 zfcpdump.
 	  See also <file:Documentation/arch/s390/zfcpdump.rst>
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 menu "Processor type and features"
 
 config HAVE_MARCH_Z10_FEATURES
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -549,6 +549,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool BROKEN_ON_SMP
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_SUPPORTS_KEXEC_JUMP
 	def_bool y
 
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2087,6 +2087,9 @@ config ARCH_SUPPORTS_KEXEC_JUMP
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool X86_64 || (X86_32 && HIGHMEM)
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_SUPPORTS_CRASH_HOTPLUG
 	def_bool y
 
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -97,7 +97,7 @@ config KEXEC_JUMP
 
 config CRASH_DUMP
 	bool "kernel crash dumps"
-	default y
+	default ARCH_DEFAULT_CRASH_DUMP
 	depends on ARCH_SUPPORTS_CRASH_DUMP
 	depends on KEXEC_CORE
 	select VMCORE_INFO


