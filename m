Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041203;
	b=JJKh1lsWN3mOdJEufG8M6+sObywK9pfZRVwFNOz1k0apZ6YgxFD1gbj0S0gLQl+0e8WB
	 zdAC8zhw4+5N+7OgMrwzFKOoiy6W/cxYbUfLz1guYtDYlDPGg/bpMmEi9pGoUBb53iKZu
	 XZ5ojRxrG4QFIokEP3MPKfovuGG1fznTG6+FgoNOtCtOuTDK0frxWq/xMZQGrxJbxSqWW
	 DdHMLtpiLMwVpuSVOefFfn6gedGd2+na1gJpm5W5hggqzrmViuAyC0/B/pPJAoJeBqm24
	 KY0mPgmug684/9mXjdORjjVLs9wcjWeCquXd9Bz+9WXeUh7G2ydwiZj6YtIxio5nhdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vj2/vSLZJ3ykNSUoAAOGjoYBRT0+Me09IEUed0abr0c=;
	b=l3LH3ql+Yko6u76sS6m0VOHCAYWqIe81MO2RZUPvnNNSwiZ6IHTi88kXkqPN+MZ550Lf
	 j7P3d8LnduybOEMYQpsg4Lh7SKtUbTYYg/0oPiE/X3xkw0McoaLCWapY1C9jJ0uckTDHZ
	 D23CBIxZ1K6Y0xgi7eorMCsb9vAP9CbCAe+vaFdUAxIx1FsQM10qRxQN49WyrFhn+0AF0
	 QYjenVJ7QZ8GM2p28CZX/TPA5GvhJLwW0EliL/myIZgj1ahorAG2ATSmq1nJR/GZZ7kQQ
	 9L3ZR3WH7zfllBy4uRmWwm5pFinfIWwfx/pEuKw01uF7EyheLopz192Xau58TdCcHzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYpN33a6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A60606A320;
	Wed, 18 Nov 2026 22:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYpN33a6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D261F000C4;
	Wed, 18 Nov 2026 22:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041202;
	bh=Vj2/vSLZJ3ykNSUoAAOGjoYBRT0+Me09IEUed0abr0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYpN33a6z89CL/nFKxv07PiuwX8xjfbciVPwKUrUELFfpIHa6whufSNA1LI4VVk+U
	 jZzYy1FmgrM3YcOxFRwzvqunkdSICaLPjUplzx1Dwqn/DUmqJaTxahyA77E2R/aI2H
	 kRLZy3C3W1M87zQv3YOWfFjn1zrzVN/tGAWzAbxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Schier <n.schier@fritz.com>,
	Kees Cook <kees@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2730/3318] kbuild: Mark the initcall ordering recipe as recursive
Date: Wed, 18 Nov 2026 15:55:52 +0100
Message-ID: <20261118150442.718595702@linuxfoundation.org>
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
index 25b3b587d37c0..c4c9aa34a7c4b 100644
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



