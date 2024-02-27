Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0731854FA5;
	Tue, 27 Feb 2024 13:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040920; cv=none; b=MTj4IPGkPrCLXK8Gje43qnOrpLYXIpM6/qCz/hQdzkCMSR6OU7pFBSi8Js8bx5N4JdKWhUSyI2JQ8tVw9tvfaqn8etUhLrsPnludN7hkwI/7+Z5DAxgkSG0Zw5WFlpWxvtsNn1mO58z+P1iGndn7mAKUoOSiUZ5eiSq2ybkb0EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040920; c=relaxed/simple;
	bh=BjD48eO0ncryy69jvBn8vaB5qadO4+iBFiQpvSrfJsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJLaG1l8wNNcy3w7BT+bIG/Iyxz0vetCiRHzb3+MR2vQlDKfOo7Ed0FL1T+3xMwIm7w2gPvvb1Ew0DU+NWscx9HTsfulQL0Z4k16pFtqRUaayFt0epB19pqM2LFmt73/AQ7hibpJFt76dJUZzUWxY5qqAbQvmVaq1JRG9wgXqck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8gpb1B+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8gpb1B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C480C433F1;
	Tue, 27 Feb 2024 13:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040919;
	bh=BjD48eO0ncryy69jvBn8vaB5qadO4+iBFiQpvSrfJsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8gpb1B+H8iBJF+Lv29ymQMMYwWDSmB+NXpqqeGHs3Iw5UBUZCUXRTBIYkRuI9yur
	 GXc3e6Z/8xqpHONWA36jh2cQ14ld1yePRRUf3MsytjC4UBM1ZjsqCmFhvXzB5zbZTF
	 c2M1I7M6Y75hyEUPB08g+2enbziqC9M+iHl1ms5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Fangrui Song <maskray@google.com>,
	loongarch@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 117/334] LoongArch: vDSO: Disable UBSAN instrumentation
Date: Tue, 27 Feb 2024 14:19:35 +0100
Message-ID: <20240227131634.246209554@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit cca5efe77a6a2d02b3da4960f799fa233e460ab1 ]

The vDSO executes in userspace, so the kernel's UBSAN should not
instrument it. Solves these kind of build errors:

  loongarch64-linux-ld: arch/loongarch/vdso/vgettimeofday.o: in function `vdso_shift_ns':
  lib/vdso/gettimeofday.c:23:(.text+0x3f8): undefined reference to `__ubsan_handle_shift_out_of_bounds'

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401310530.lZHCj1Zl-lkp@intel.com/
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Fangrui Song <maskray@google.com>
Cc: loongarch@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/vdso/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index c74c9921304f2..f597cd08a96be 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -2,6 +2,7 @@
 # Objects to go into the VDSO.
 
 KASAN_SANITIZE := n
+UBSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 
 # Include the generic Makefile to check the built vdso.
-- 
2.43.0



