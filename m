Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017563;
	b=kwyc1BQ3wGSzSFe4ENWeHCtKyGOx6UpIFnavpAWT8hTtZJDRWoBTr9oU4w3xsJ/8zDqf
	 Kumn2I8PdyTAdz1Zn0HIb82g/vIUs3h7PYh671yvmvIhgs+6JU1qVMznWEisMYJr378u0
	 +36Gg8wxaQ+SRLBOVTBVq1HoFQ+MLZ1++vjmncJ3hM4e8exXuolzMroyXNMQgo/ZdPyon
	 jVWYTDrRCXo8vOfzWcV3MixzohpAjeJvneLJ8z6o5PqeUCkjQiIAFewqD3Yp8bMPOOVjt
	 85U2zFZHrXCkIOFZeyNWPkK12WjyXC5U3F1D0nXfRRDNIQQkVAKeoLRc0tI+W9uQGUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/PLOGO8MJ63S8LArrXwtg1TqhOcAQRmiL8l8JqI9XjQ=;
	b=zBxf2Gxl/D6/aCLfR2NXhMWkb3kvup5Pv5JO1YMOYKeqVloMQhYPORDjpDx0QiGIlAuq
	 cUARNQYv+agtYzWSGSRoBMHOjsudqPaYhJXv4mLZ0XNAxmIbml2GSvaWKvTEjfgvPR3a4
	 7ISyRBTL6aJhpfwVcoh7V1j8Qb6j0At4xgKSlLrnL2ptfvCyJij+5eB6VGBlzLMnSPACy
	 mdlQ56HXfrTMWiw8drev1fDMXe9BZdUUsH499HJ+giH4J+als7ekliANP0H6HjM8Rd+gT
	 cUAynb/ScmAN6UnY90bIcpORptEJ0WP5fgqnIykrcvyFvJOiB50iAj30Z+03qtvMULw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j/GHKiHx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E97606A336;
	Wed, 18 Nov 2026 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j/GHKiHx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D251F000C4;
	Wed, 18 Nov 2026 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017563;
	bh=/PLOGO8MJ63S8LArrXwtg1TqhOcAQRmiL8l8JqI9XjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/GHKiHxJKGUQs2cH5OWsZhKVcs2WR3KUiLwXN7uGS5x+ZF/5t92HVXam9Z9X5B9y
	 bLn8O93IpOcZJL4d9/mufdQD5vAb3IfZLgC/tn35aQiOidsH1Ibn94PT52fxi53kdf
	 IXuArjxT9BRq5lFLbCWP+y5gxE0yeHfTbSP4aeik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0912/2651] kbuild: do not allocate .modinfo in vmlinux
Date: Wed, 18 Nov 2026 15:35:52 +0100
Message-ID: <20261118150320.720360108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 5fe4dd59664105a9ea1a9468aa7391806b80364a ]

Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
placed MODULE_INFO() strings in the .modinfo section in vmlinux.unstripped,
however it left the section allocatable, so it gets assigned an address and
on arm64, arm and riscv, the section is tagged as PT_LOAD.

This is useless as the data is ultimately stripped anyway.

Doing this results in a lot of unnecessary work - each pass copies the
whole file, 450 MiB with relocations for an x86 allmodconfig build and 250
MiB for an arm64 allmodconfig build.

This adds ~0.7s on the serial tail of every build for arm64 and ~0.2s for
x86 (the tail is single-threaded work done after parallel work has
finished).

Nothing requires .modinfo to exist at an address, so mark the output
section (INFO) so that it's not allocated and use --dump-section to extract
it as -O only emits allocated sections.

The dump doesn't pick up the arch's OBJCOPYFLAGS any longer as they should
not impact the output of this section.

Image, bzImage, System.map and modules.builtin.modinfo are unchanged and
the stripped vmlinux differs only in its program headers.

The objcopy passes are on the serial tail of every build that links
vmlinux, no-op builds are unchanged.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, touch mm/vma.c, gcc       11.2s    11.1s    -0.15s (-1%)
  x86 defconfig, touch mm/vma.c, clang     11.3s    11.1s    -0.19s (-2%)
  x86 defconfig, clean, gcc                32.5s    32.3s    -0.16s (-1%)
  x86 defconfig, clean, clang              34.5s    34.2s    -0.26s (-1%)
  x86 allmodconfig, touch mm/vma.c, gcc    40.1s    39.7s    -0.44s (-1%)

Assisted-by: LLM
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Nicolas Schier <n.schier@fritz.com>
Link: https://patch.msgid.link/20260923-build-speedup-v4-1-73128809a4a4@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: a98db7418797 ("kbuild: keep .modinfo when vmlinux is linked with --gc-sections")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |  2 +-
 scripts/Makefile.vmlinux          | 10 ++--------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 26201821ea7ff..a6730d34e8c67 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -855,7 +855,7 @@
 		KLP_SYMID
 
 #define MODINFO								\
-		.modinfo : { *(.modinfo) }
+		.modinfo (INFO) : { *(.modinfo) }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 6833b517cacb6..95b523fe4f9ee 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -89,11 +89,8 @@ remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel.*'
 
 remove-symbols := -w --strip-unneeded-symbol='__mod_device_table__*'
 
-# To avoid warnings: "empty loadable segment detected at ..." from GNU objcopy,
-# it is necessary to remove the PT_LOAD flag from the segment.
 quiet_cmd_strip_relocs = OBJCOPY $@
-      cmd_strip_relocs = $(OBJCOPY) $(patsubst %,--set-section-flags %=noload,$(remove-section-y)) $< $@; \
-                         $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $(remove-symbols) $@
+      cmd_strip_relocs = $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $(remove-symbols) $< $@
 
 targets += vmlinux
 vmlinux: vmlinux.unstripped FORCE
@@ -103,10 +100,7 @@ vmlinux: vmlinux.unstripped FORCE
 # ---------------------------------------------------------------------------
 
 quiet_cmd_modules_builtin_modinfo = GEN     $@
-      cmd_modules_builtin_modinfo = $(cmd_objcopy); \
-                                    chmod -x $@
-
-OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
+      cmd_modules_builtin_modinfo = $(OBJCOPY) -O binary -j .modinfo --dump-section .modinfo=$@ $< /dev/null
 
 targets += modules.builtin.modinfo
 modules.builtin.modinfo: vmlinux.unstripped FORCE
-- 
2.53.0



