Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020856;
	b=T/av2zyzgxSUC+EH3GiBDF1gu2kq58z4s3NMgIt6c5FpLSoekYGkcLDRhrjED4zoprP4
	 vD3LgzANTxIxIBV5pMYiyC2NWikLT0uICgznt2nfumyfzhu6lZ/2dqzjWSAQq25e3f6Bd
	 gvTX3DuAgv9o7K5nELUAAhh6BA9lxpcQK4bcL1JAcAqIxGMrJLFzd6hRTbmQgvob0dx27
	 UeMHNlmd3iRqt26xkIytvvh6drHF4r45m2592nih6/9o3GZ8aJiDMLZCz6cIio/EmsDyw
	 wmM1F5HwVYrhOR8P4s1pMsfVnbaJQR0e4ZTD+AHTBOQVykjaQHu2i2JT4LM2OZlmn9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TPWTtlD2bL8e+5dB0PEYcBLdgmhu3P5F89SbrVcX6WQ=;
	b=F2fXf+TyiMvvyHzqTIS39/ncYKiYLf7p14dA/D/T5ATOTeOqjWAvrqrdmK9eOdaGqtze
	 Jj+4/I62UVDulkE+8P/tThDm6G1iR2BzzuQQ1XIPlcoXp/38iDWmHrhDIelDZ1wHA5Cvl
	 K+5lHwbtkdMb/ZIQEBR/pMg8gv1D9TDrXO/yH2vhNp70A3PAuIMKMjRiSrz7jxvOeL4l9
	 fJ/GSA0kKLyUDiBFdIH9ZtyY9d5/jbEwLuOcoSByJhXAGPhS9lg9LtHDUvUYzlUxit4BS
	 hUTfpdEVjAAsqicpK7Pd1T+wejXYJW2RLzwkOXDPgXBNuy3sgtUYHtKxvd41TcqL0bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2H+Rwtk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DF8606B591;
	Wed, 18 Nov 2026 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2H+Rwtk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E421F000C4;
	Wed, 18 Nov 2026 16:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020855;
	bh=TPWTtlD2bL8e+5dB0PEYcBLdgmhu3P5F89SbrVcX6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2H+RwtkWeGAScedyok7qM5Wo7LsuEBWs++hYt+N+8zQS8mJ8ymkeUldbJMN8CQkn
	 EbydTz+DgN/5I1w4KPUtgxTMKE1w2MmnNRUCmvADa6h6Kzk32m93ggHeeAdNPNhE22
	 SF2a6vzTEmtD8bR8iww4gwI7KsW5IVPYJgNXvIWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Alan Maguire (Oracle)" <almagui@kernel.org>
Subject: [PATCH 7.3 2058/2651] ARC: Strip libgcc debug information when generating BTF
Date: Wed, 18 Nov 2026 15:54:58 +0100
Message-ID: <20261118150400.151475710@linuxfoundation.org>
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

[ Upstream commit ca201ad6e92a1924138e83ff966f7a091e3bbe6e ]

ARC links against the compiler's libgcc archive. The ARC GNU 2023.03
toolchain ships this library with debug information, including complex
floating-point types in integer arithmetic helpers such as __udivdi3.
These types reach vmlinux even though the kernel does not use complex
floating-point arithmetic.

When floating-point BTF encoding is enabled, pahole rejects those types:

  Complex, interval and imaginary float types are not supported
  Error while encoding BTF.
  FAILED: load BTF from .tmp_vmlinux1.BTF.1: No such file or directory

KernelCI's upgrade to pahole 1.31 exposed this long-standing problem as
failed ARC builds. As of 1.32, pahole still rejects these types, and
older versions will stay in use, so the kernel build has to keep them
out of vmlinux. Commit f122668ddcce ("ARC: Add eBPF JIT support")
documented the same failure along with a workaround of disabling
floating-point BTF encoding, but that also discards supported
floating-point types from kernel BTF.

For CONFIG_DEBUG_INFO_BTF, generate a debug-stripped copy of the selected
libgcc archive in the output tree and link that copy. Preserve the archive
structure so that only needed helpers are linked, and use the normal
Kbuild objcopy rule to track input and command changes. The trade-off is
that vmlinux in BTF-enabled builds no longer carries DWARF for the libgcc
helpers. Debug information for kernel code, the installed toolchain and
non-BTF builds stay unchanged.

Reproduced and tested with ARC GCC 12.2.1 and pahole 1.31 and 1.32 using
an ARCv2 tinyconfig with BPF_SYSCALL and DWARF4/BTF enabled. Before and
after vmlinux.o files are identical after stripping debug information.

Fixes: db16c1fe92d7 ("bpf: Generate BTF_KIND_FLOAT when linking vmlinux")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Alan Maguire (Oracle) <almagui@kernel.org>
Link: https://github.com/kernelci/kernelci-core/commit/e71b8c9f42253180596e734c18965a5aad80c8c5
Link: https://patch.msgid.link/20261015154044.4058618-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile     | 9 ++++++++-
 arch/arc/lib/Makefile | 8 ++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 868805ffcfeab..4ea705a331c7c 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -86,7 +86,14 @@ core-$(CONFIG_ARC_PLAT_TB10X)	+= arch/arc/plat-tb10x/
 core-$(CONFIG_ARC_PLAT_AXS10X)	+= arch/arc/plat-axs10x/
 core-$(CONFIG_ARC_SOC_HSDK)	+= arch/arc/plat-hsdk/
 
-libs-y		+= arch/arc/lib/ $(LIBGCC)
+libs-y		+= arch/arc/lib/
+
+ifdef CONFIG_DEBUG_INFO_BTF
+export LIBGCC := $(LIBGCC)
+libs-y		+= arch/arc/lib/libgcc.a
+else
+libs-y		+= $(LIBGCC)
+endif
 
 boot		:= arch/arc/boot
 
diff --git a/arch/arc/lib/Makefile b/arch/arc/lib/Makefile
index 30158ae69fd4a..2807ee24f27e6 100644
--- a/arch/arc/lib/Makefile
+++ b/arch/arc/lib/Makefile
@@ -13,3 +13,11 @@ lib-$(CONFIG_ISA_ARCV2)		+=memcpy-archs-unaligned.o
 else
 lib-$(CONFIG_ISA_ARCV2)		+=memcpy-archs.o
 endif
+
+# libgcc can contain complex floating-point debug types unsupported by BTF.
+# Strip only the debug information from a local copy of the selected archive.
+always-$(CONFIG_DEBUG_INFO_BTF) += libgcc.a
+OBJCOPYFLAGS_libgcc.a := --strip-debug
+
+$(obj)/libgcc.a: $(LIBGCC) FORCE
+	$(call if_changed,objcopy)
-- 
2.53.0



