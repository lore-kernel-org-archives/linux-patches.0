Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042030;
	b=47RVfbHKqmdCDCzu20E9KzjucimiC0K1eLZLA9/Au2jmbAvCksYfFjMHAkLOwQo3jW1y
	 9R2UjY/mTz/jd3grxz0OR6JzdDlMtap2562HUXdrU7A8jwVJud6+vxGIxqZR/dgOhNXSk
	 3gHxK6cTigAfof3rTkAr6vIIvHRoAMZzlXt0pDTgmIsxx9cX3tplXFFxnno7LhCQGMYn/
	 NyK1JxzAg3LD4cxZ+YXtk9Zb2PbY+bQQG3XVGLgnzqixTFdQAbJMQC6gsD+Z1wsMBZXGw
	 dGWNNYtUHR5fd5YNMCUzSdR4sQJI0q3vJbUnQsp0H0CDXtzzEN+VBSCUQImg+eyW8jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xq4Bv0IEbCdUy9YMTXaWReHhRuemtGJF5AiLlrh7rW8=;
	b=IlKL7Wr9VCceW7gvuuA7HC20Ogk8AqAaqqyA0fQ1m8WOnRBNF8q6FnWgdLs00M7iWW/i
	 6XWqEGOCuuJrkeT2F15FitX/YvS9P2+ZeHbYI5dsATp6v//SZkSZubJB77NVmairmlDlA
	 wIVqMkxShoenSUqjd0CPlFG6GnI7lRuy1a37mCMefQX3tJVOmyCNoxxMGeN4uQm40OFOQ
	 SwuyKGfYZZn16IQxTXnsX/Xmfz+NuxYhaCt/r4w0dhDoJmU7K2xih8phdj1EcYL2yB0M1
	 HakUtJhi0hALmZP21rnNJnpoTECDT/HZZV5sEOR10idr2EbBUA8GWr3uzb1TIvcLtGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QRlMRFj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884B9606A325;
	Wed, 18 Nov 2026 22:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QRlMRFj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE98E1F000C4;
	Wed, 18 Nov 2026 22:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042030;
	bh=xq4Bv0IEbCdUy9YMTXaWReHhRuemtGJF5AiLlrh7rW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QRlMRFjJfsoOxBfORaKxR5px5jHmxuZjwwGTwCHXDwwxWyaJX67mfsBoBtsBTOZC
	 WzBIjIxtELfgzINshZPIakBMDo9hVHFlniAgWqoqouGwpxbgnTgUmdt6IL2UsFIyw4
	 14mzzNqkjVWuu6aHtmzMTy3koGRAsZ5NmV5A5g5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Alan Maguire (Oracle)" <almagui@kernel.org>
Subject: [PATCH 6.6 2984/3318] ARC: Strip libgcc debug information when generating BTF
Date: Wed, 18 Nov 2026 16:00:06 +0100
Message-ID: <20261118150449.794090164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fb98478ed1ab0..aa75d96e82b80 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -90,7 +90,14 @@ core-$(CONFIG_ARC_PLAT_TB10X)	+= arch/arc/plat-tb10x/
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



