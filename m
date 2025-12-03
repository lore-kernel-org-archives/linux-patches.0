Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC434321C;
	Wed,  3 Dec 2025 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777470; cv=none; b=nj8XAIEo/cCTRLHeHN7a7gj4PnKeSiOlYduK8fNjWzyygVCFLHpJiAi/7gf6e8zEmy9V5ViWqfkxcJzbT0yUKJkTVDg9nHikMA9OKl4/IgM3kv2TYvzDL78kSSLs9Pn3m1Qr9w0grdncS3UQig0t50KRU1XyudNhhjIpnG9MOjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777470; c=relaxed/simple;
	bh=SBdQEKr4Xqzkxu9vl1t5OfYdRasHW2ck+Ixq8XV0dko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBRmd7B4RIXCc17GqV1nr0DaemW61svTDWv3TGnV3Nt6mQ7RGphq0dG9cN/bPE7oJCZc/T7aTw6IjTbZdXpcfOZJ+7FpPUsnkT45prGLvM692beI2tgWYgs1aDbOyKRoFpAY0/wkfQIUFZ0AaMA87KCmQEJGXZW4pqus95IQcBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwIQ9yvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwIQ9yvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633F2C4CEF5;
	Wed,  3 Dec 2025 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777469;
	bh=SBdQEKr4Xqzkxu9vl1t5OfYdRasHW2ck+Ixq8XV0dko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwIQ9yvZW8DolnfoIFGyecOlEww2TnhwIrsL+9F1abC/9DoruO+x0d0WDJAwsqECs
	 2DChggO/UjSaqGZseUYQ6t2c8OyaCJrF0NF2MJgac+as2oCYTT6pOxf6Ly138R3W8x
	 ZpeS+BPQo9SxG/ngLUi/Hiyr1RV2xQLEJYk7KDSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 047/392] arch: back to -std=gnu89 in < v5.18
Date: Wed,  3 Dec 2025 16:23:17 +0100
Message-ID: <20251203152415.842177300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

Recent fixes have been backported to < v5.18 to fix build issues with
GCC 5.15. They all force -std=gnu11 in the CFLAGS, "because [the kernel]
requests the gnu11 standard via '-std=' in the main Makefile".

This is true for >= 5.18 versions, but not before. This switch to
-std=gnu11 has been done in commit e8c07082a810 ("Kbuild: move to
-std=gnu11").

For a question of uniformity, force -std=gnu89, similar to what is done
in the main Makefile.

Note: the fixes tags below refers to upstream commits, but this fix is
only for kernels not having commit e8c07082a810 ("Kbuild: move to
-std=gnu11").

Fixes: 7cbb015e2d3d ("parisc: fix building with gcc-15")
Fixes: 3b8b80e99376 ("s390: Add '-std=gnu11' to decompressor and purgatory CFLAGS")
Fixes: b3bee1e7c3f2 ("x86/boot: Compile boot code with -std=gnu11 too")
Fixes: ee2ab467bddf ("x86/boot: Use '-std=gnu11' to fix build with GCC 15")
Fixes: 8ba14d9f490a ("efi: libstub: Use '-std=gnu11' to fix build with GCC 15")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/boot/compressed/Makefile  |    2 +-
 arch/s390/Makefile                    |    2 +-
 arch/s390/purgatory/Makefile          |    2 +-
 arch/x86/Makefile                     |    2 +-
 arch/x86/boot/compressed/Makefile     |    2 +-
 drivers/firmware/efi/libstub/Makefile |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/parisc/boot/compressed/Makefile
+++ b/arch/parisc/boot/compressed/Makefile
@@ -22,7 +22,7 @@ KBUILD_CFLAGS += -fno-PIE -mno-space-reg
 ifndef CONFIG_64BIT
 KBUILD_CFLAGS += -mfast-indirect-calls
 endif
-KBUILD_CFLAGS += -std=gnu11
+KBUILD_CFLAGS += -std=gnu89
 
 OBJECTS += $(obj)/head.o $(obj)/real2.o $(obj)/firmware.o $(obj)/misc.o $(obj)/piggy.o
 
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -23,7 +23,7 @@ endif
 aflags_dwarf	:= -Wa,-gdwarf-2
 KBUILD_AFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -D__ASSEMBLY__
 KBUILD_AFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),$(aflags_dwarf))
-KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2 -std=gnu11
+KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2 -std=gnu89
 KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-delete-null-pointer-checks -msoft-float -mbackchain
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-asynchronous-unwind-tables
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -21,7 +21,7 @@ UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
 
-KBUILD_CFLAGS := -std=gnu11 -fno-strict-aliasing -Wall -Wstrict-prototypes
+KBUILD_CFLAGS := -std=gnu89 -fno-strict-aliasing -Wall -Wstrict-prototypes
 KBUILD_CFLAGS += -Wno-pointer-sign -Wno-sign-compare
 KBUILD_CFLAGS += -fno-zero-initialized-in-bss -fno-builtin -ffreestanding
 KBUILD_CFLAGS += -c -MD -Os -m64 -msoft-float -fno-common
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -24,7 +24,7 @@ endif
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386;
 # that way we can complain to the user if the CPU is insufficient.
-REALMODE_CFLAGS	:= -std=gnu11 -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
+REALMODE_CFLAGS	:= -std=gnu89 -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
 		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -33,7 +33,7 @@ targets := vmlinux vmlinux.bin vmlinux.b
 # avoid errors with '-march=i386', and future flags may depend on the target to
 # be valid.
 KBUILD_CFLAGS := -m$(BITS) -O2 $(CLANG_FLAGS)
-KBUILD_CFLAGS += -std=gnu11
+KBUILD_CFLAGS += -std=gnu89
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIE
 KBUILD_CFLAGS += -Wundef
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -7,7 +7,7 @@
 #
 cflags-$(CONFIG_X86_32)		:= -march=i386
 cflags-$(CONFIG_X86_64)		:= -mcmodel=small
-cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -std=gnu11 \
+cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -std=gnu89 \
 				   -fPIC -fno-strict-aliasing -mno-red-zone \
 				   -mno-mmx -mno-sse -fshort-wchar \
 				   -Wno-pointer-sign \


