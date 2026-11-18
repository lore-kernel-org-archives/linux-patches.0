Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024578;
	b=cT61d0k8neuB683zpcfyjZbh/7VIBKUUBk4mWM1DLDedffHd+pDeTzyDVi9Gy9BZprIb
	 jwyXvoTl2ST4HNw7owliU5TSw1r6oF1eKNd+98lS95sIfb2Z5c3ZNNL0ZVO2paHlIUXJS
	 SDtZBF6g6RIzv5rj0R2afDZWAkntSkvnKLqRRRHd6IWdQrlqdWsIc2jQMRDI5/BiO2a3Q
	 HAn92I4nXLx2sZOx+IriBUcbGDiCsHslq2LPBm/nsYPokTTH6yss2MCYFrxOYN55Q7i4S
	 bJgNTfgwm0nXQjzuJTxkIYItDCdXg79xaMbqYTxSjk6Q9CEL4IhpORQAPsuxODR96hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=12o8EsHw0IAVSPvSQBN8iWuudqg1veVOG5ElzYNXKTk=;
	b=DcF5XsNssQmLOncX4UDWEMjSKWKJerqikm3jWl1+kNI6CkbKj9B/+sKUOAzNc1UYRBnp
	 qW427BmtjGum/64Xw7AQNKQGtUcLQfirekYY6iFpusT7LiRK0m6n9mBJsJ1rq8XeBCjFX
	 BH0q33N0PuPTldUdFUcZ7S829XPCndFUIVpeHchTOQsfX7oxDodMm0D8IYwGCXh48YARs
	 nhCeNfy0vH8SwCQGrvJYeMG6izxuRMi0PwefFqqkW27YVz1xCcjfNpBLY09SehP0SPpwz
	 0qUyc4h4OP+xZPN5/Nw0SddBJk4j41qVr3w9hc0VXCjxnMubbHnnS+VF9jyetb/1+3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqkW0tSb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C883606A320;
	Wed, 18 Nov 2026 17:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqkW0tSb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5671F000CC;
	Wed, 18 Nov 2026 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024578;
	bh=12o8EsHw0IAVSPvSQBN8iWuudqg1veVOG5ElzYNXKTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqkW0tSbIYAJUiCfX4Fcm3G7iQEVzdboXhECgdYVoU7Ix2HznYzYRfXNULPOh/W8O
	 FDsqqi76WFkzNvq9suYq/REr9LnD3GU/gCNC38NQnkYTXTWHAYnKX/4Sb14/g7L8zu
	 G7krq771dDrD6Ns8iPxIxfr1bBJdfBtc0NClTPuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0773/2151] kbuild: do not allocate .modinfo in vmlinux
Date: Wed, 18 Nov 2026 15:41:48 +0100
Message-ID: <20261118150150.295707911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index f60238b0b8918..3c62b1ef31800 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -838,7 +838,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		.shstrtab 0 : { *(.shstrtab) }
 
 #define MODINFO								\
-		.modinfo : { *(.modinfo) }
+		.modinfo (INFO) : { *(.modinfo) }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 77b9969842e00..c9990f6a0d93e 100644
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



