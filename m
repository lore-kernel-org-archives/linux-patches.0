Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031400;
	b=lKKm79yUtQ0U3xLv0GOP//0jijEbo8TCmprMMR6JZebaXpmfxAUORGe9GTLtkAjksyuL
	 KdT1ESZi8XWcyqFmo9Z4dnkG2xmtPC1tlc9XDzOrtSIjW+tg0ee0ok8iqPQWs19KRjtrb
	 YI1ILxK5HscLbuq8kcwWC2Jl9qZXZ6s+MjP/gWYMbvFtK8WuRtFA8NMTf5yot0oV0tF02
	 ZAZatBiVJBeEWMeyK4UgKe6K9z6+ipyiDRJsasSuhF4CUFOlcy/q8Z79g4CrX3jOps/gW
	 w0v4FowysddWhTWW+Pnomz99GmiM3vAYlPFxD1mi9EaFRPd9URorPIkjJwR5BLnJD/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MbRRfDh5SbGs/+na7uo1oJ8pIkgNu3aFnROnVUwzY8M=;
	b=j9XJAD2AxCyZypfhI9Mix4koXPNpYz9PSdtjgBRnnvOkexXfimMjMtDsa4I3d/ImVka6
	 VfHf1cXrTa4BzUKA7OPwIguRcjavKJj31Bbjo5Yk8LHfLz01z/Tk3SkkfvhFbP85XOE+0
	 VoMqmvLslUklg4jKSsk/vs2T8ptqhoUL7xLSPRBH5BXEe7/KtxPE8Z5PzFCSLqc6Nq6V6
	 2rL+P37Wr7412qsWpfXlQd1ltQlF77fjlbvkk+gNT6xCb5Gxn29FgFsmQwVstx6FTxWrk
	 t9bWNW2AG1OeOmiuNzS2Plu6zO7UjM114h87lSLDs+IFc52Y18RbXhhIeGoC5GsKZDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kO9kfL0w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1EF606A320;
	Wed, 18 Nov 2026 19:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kO9kfL0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E351F000C9;
	Wed, 18 Nov 2026 19:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031399;
	bh=MbRRfDh5SbGs/+na7uo1oJ8pIkgNu3aFnROnVUwzY8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kO9kfL0woavH0qBJ9t3lWZCrI0mCJmDZJa0xfml5CQPWYyh/vfgTMdw70u9IIIKrw
	 sBZXwQBwNXoOtPk/YSj1Sf5PV38hXtx66QRTWMc4FisHnEMUxdtqzXFR+we8oT8+FE
	 FR6bQhvyKZ/hxdkq0GcSsZbyFSJYMnjN+m2A5Xyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Schier <n.schier@fritz.com>,
	Kees Cook <kees@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1044/1756] kbuild: Mark the initcall ordering recipe as recursive
Date: Wed, 18 Nov 2026 15:52:51 +0100
Message-ID: <20261118150051.618892182@linuxfoundation.org>
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
index 0b6e2ebf60dc1..020ca994d149f 100644
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



