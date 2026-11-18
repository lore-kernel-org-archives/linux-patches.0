Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019439;
	b=w1lzGeYiZTsH/GfkNDPXjHa4atTnMVU5VredAdMxJkodxiHngYleUKZAe2hn3riJdsi0
	 8VMAOMYA78XEKcPf6RAZ0+IFT/t8eOzccoSBQdjatjA0nkAiqmk9SkOvYFUjPLxPXZ92O
	 5YEbU7UPr29oczTvFcdLeuAh2v546+oJYTGcJbOg8gixmvpG8G3YjjGtW/SB4MhcgwTJg
	 kgjgLnmvpbM57SFdPPfj55JJzI1mEMsknTZtnD3Oxf70ALnccXkFrBq6xHMA0v6tIxLkB
	 6Z04dIxeS2e4hy0vZ0S6rqRsRquFdkTK7/BNpgfoYx8g0dh9qQBZeKN+mpUZBuvk4Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WBPg6zRU7we71ChsFY0rt6H1VrWbOJeG1bdKIzcXj+U=;
	b=MkvXiXoeZrHeU6/WVIEYKkmc6fPOvVe0HeLrFvIu8huy32nQlc19kYiNiCRVdeOwUYtf
	 ap+Y75d2pgytq1zUl6q3fNKyuw9fqzvjDumYQR9pJPgEqiuYuved7Xm0FjnYIpCR4ku/d
	 abAXjC0yCylvvTIDU7B/cRQyJDlPcoA6MxDSWDBjhhhgBzd5rvkFEmw4FcG02KIiiFzvj
	 6uLyuwp7ZvWczReb8jGV/sp1PXMEBQPbOO4MdW8punan54EbCfqU8G6jeOVb0gj30B3Ef
	 hYDk7CBZgr5GYRObssGKZvTprhbGLXB/lLaYy7x/mQRRnlnjc2KzD5TdQNYlUtuQtKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xz9LWCOG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F41760A263F;
	Wed, 18 Nov 2026 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xz9LWCOG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542B51F000C5;
	Wed, 18 Nov 2026 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019438;
	bh=WBPg6zRU7we71ChsFY0rt6H1VrWbOJeG1bdKIzcXj+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xz9LWCOGJv1xuDUnCSSnuuC35QmkuF6Y7kKOfJInYNUrOfHMEqCSeBBe4/6BV3cNI
	 eZWKi1KFTgIhJIyS/eVkLazwkZl4Vvq0b8BfKsIx2J8UK7or+Lnjk/cY8NJ3+bcrYx
	 MPdxJsfqc9lMMdad944+93r6GOOy7xZyyJZNppVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Schier <n.schier@fritz.com>,
	Kees Cook <kees@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1596/2651] kbuild: Mark the initcall ordering recipe as recursive
Date: Wed, 18 Nov 2026 15:47:16 +0100
Message-ID: <20261118150345.341403390@linuxfoundation.org>
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
index 24a3a4fd271c2..0b37bd5dc3a49 100644
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



