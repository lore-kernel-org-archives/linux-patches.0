Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026116;
	b=Kr4plaGHDFwk7YImUosuCidK76HA8O0uUYYHzOSXpFoBn+I5dDoPcmV80OtXoVd+g7b6
	 rFEiJ1G8OAgYxQrxPqrN+j9M/ogJoETHnfbS+rxQlrKHwFrjP6BaTFsY0QHLMOt6iUD+a
	 eVd6gIP2nV9fT0Iz0LDe1xeT7xq0cwHlSlsLT03iHNQ/Bmpmlom9nX/tmGRx5zknJZUIj
	 jbBFtSsodj+efCsI5h043uW7snCgsGKixlgGSDyUsHue+ylnuCe0BZCBQnVpjohuyRwRc
	 5lPEycdx7WUWVyvId/lIN0x9808TkDQ+NPIl17G/rWrsRPF5+r9MSMoouq2TsqNgQow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RXdBgaKpG7762VOp19R1q73PO9ReAQM1toYZwjmHDqA=;
	b=pGw396vVNSq5J0gKCGlp0K2mkibuiCQJUS/GGO8cHemndIPcEOU0c419XAUQKaxOYKyq
	 hHGiT7vQnEFZ/2DUVEmdEfFKUtJZTOh8aLnzSbStvnnW9lUTfBiHGGQFBEpOwOrmgeVA8
	 NiwD8JaQhJV5WNiryOxHsGajkIlmhavVo3KPIdt099+mrlF8HwblvQ80+4owlFOdzHLuC
	 Qt4VgCoss7fIduHerNCRd1WasIwGR7ERiFYKHmB7H4gEGJ4YsX/9aQA0BHAIVa212HUKp
	 Gi/t+1o2z0KV6Es3pfPh3nf3nWL5bZzsDlKJ3HA/BzCxYY6dTBTw4prsdlMz9O70H0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6x22q6e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4142C606A31C;
	Wed, 18 Nov 2026 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6x22q6e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965761F000C5;
	Wed, 18 Nov 2026 18:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026116;
	bh=RXdBgaKpG7762VOp19R1q73PO9ReAQM1toYZwjmHDqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6x22q6eXPaC4h44e0J6CchRZjpIsUCpUOHnjeBz+7qGICUDfZhFmDUNejRsFJH5X
	 TeETkgDVMcfbs48txn2W9VmyUY2e+E0Hz4ifX8v12+HE5bW3vVXg5NeTDIjiQehO4L
	 DJ0Ab8QVkZj5Uz1YcKRUuexWXuBipegUgjRP66vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Schier <n.schier@fritz.com>,
	Kees Cook <kees@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1319/2151] kbuild: Mark the initcall ordering recipe as recursive
Date: Wed, 18 Nov 2026 15:50:54 +0100
Message-ID: <20261118150210.141058160@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit ae5f6044c4cdffe2b3361b15c1d6fc67b339f2a4 ]

generate_initcall_order.pl, which orders initcalls for Clang LTO, forks
a child per input file, up to the job count scripts/jobserver-exec
passes it in PARALLELISM. It used to run from link-vmlinux.sh, which
the top-level Makefile invokes as a recursive recipe, but
commit 5d45950dfbb15 ("kbuild: move vmlinux.o link to
scripts/Makefile.vmlinux_o") moved it into a recipe without "+".

GNU Make passes the jobserver pipe only to recipes it treats as
recursive, and the make 4.3 in CentOS Stream 9 also hides it in
sub-makes (a backport of the fix for GNU Make bug 58232), so
jobserver-exec cannot open it and prints:

  WARNING: Unable to reopen jobserver read-side pipe: FileNotFoundError(2, 'No such file or directory')

PARALLELISM is then left unset, and the script caps its children at the
number of online CPUs instead of the free job slots.

Mark the recipe as recursive again (this makes "make -n" runs the script
again too, as it did from link-vmlinux.sh). Masahiro posted the same
change and withdrew it because the script was given only vmlinux.a, and
so never ran more than one child [1]. But on arm64, LoongArch, and RISC-V
with CONFIG_EFI_STUB, KBUILD_VMLINUX_LIBS also gives it the EFI stub's
lib.a. Either way, the warning is silenced.

Tested ARCH=x86_64 defconfig with CONFIG_LTO_CLANG_THIN=y, LLVM=1
(Clang 24.0.0git), and GNU Make 4.3 plus CentOS Stream 9's
make-4.3-cloexec.patch.

Fixes: 5d45950dfbb15 ("kbuild: move vmlinux.o link to scripts/Makefile.vmlinux_o")
Link: https://lore.kernel.org/all/CAK7LNARCM=rUm8mA8GRQ7ufeyfneGf4OEvHmESKt=zuxs2KrHw@mail.gmail.com/ [1]
Assisted-by: LLM
Reviewed-by: Nicolas Schier <n.schier@fritz.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://patch.msgid.link/20261010081914.540611-2-kees@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.vmlinux_o | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
index 23c8751285d79..2929def904925 100644
--- a/scripts/Makefile.vmlinux_o
+++ b/scripts/Makefile.vmlinux_o
@@ -19,7 +19,7 @@ quiet_cmd_gen_initcalls_lds = GEN     $@
 
 .tmp_initcalls.lds: $(srctree)/scripts/generate_initcall_order.pl \
 		vmlinux.a $(KBUILD_VMLINUX_LIBS) FORCE
-	$(call if_changed,gen_initcalls_lds)
+	+$(call if_changed,gen_initcalls_lds)
 
 targets := .tmp_initcalls.lds
 
-- 
2.53.0



