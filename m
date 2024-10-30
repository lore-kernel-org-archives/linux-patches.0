Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE4419CC24;
	Wed, 30 Oct 2024 18:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730313706; cv=none; b=pFjZsxSg3Nex3AI7fbAqmSpMONCkI6QQVpgtiZ/geLom9/gjxcjhQaea4HaAeDd49xIswdS2L7Cgbgs9K7YSGmMmT+vcKnGpj5SKMbC5K7Z72GhX/d6EKjHzelWDWJ4U1qes0uNXXT7q6QVX22JyhNNcz09TT0/AbiaKmPC5+u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730313706; c=relaxed/simple;
	bh=bFayy90KzO6wEJgJAEKS9naOm6gN2b1q5QrHLnmsrsU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=M55KU8/owhDPlaBHjFUWGnH3xrxD4dUDZOp5UDqxoMKhk3vgrpeGVtmlWu0Qd+vspkT3SanoxRVFI2k5ILsDMOc/WUkviSCN+JjyMcD6SyH4+pOgyQUJe3sDeVdGxQPVWXAR4y/zPCnbSeyyJvxsN8bSIEwmhqWqW3EzNT0fowo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5t5cJZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5t5cJZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD84C4CECE;
	Wed, 30 Oct 2024 18:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730313706;
	bh=bFayy90KzO6wEJgJAEKS9naOm6gN2b1q5QrHLnmsrsU=;
	h=From:Date:Subject:To:Cc:From;
	b=L5t5cJZSSE1D8wzp9BT8EDMwrUSVuuquiCE2au4879x2xxjsMRFDQgtjF2Sb9/Ipr
	 NrlG+KfNmOVvHt51q0de6luqL/Wx1o56fgghSI7mTzj0NzpBAQybuMWIv3AOimXM+b
	 HpUiRuNQBS2j8yH7IGsYnx+DpxHRcT56S5MRYECS9mTelbRss9CUdnsA5dx8OWvT1U
	 1A0KC84y+djeM/G4iKcIDoN3Ph4g942LAUryPsBIv+C+uNt+uvAW3aOIQ+VRMiOvrL
	 4DIO2hEA/pbJiicVZFXK/sVLrDGjRTTv0uGZ59e/4cNRMDM0EpAQQeb9PLxuwNikb4
	 5qK7pHFFqotJw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 30 Oct 2024 11:41:37 -0700
Subject: [PATCH] powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit
 files with clang
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOB9ImcC/x2NQQrCQAwAv1JyNrBdRcGviId1k9Rg6YZEqlD6d
 xePc5iZDYJdOeA6bOC8amhbOoyHAeqzLBOjUmfIKZ/GdExo7cNuFVeKhuTNMN6lvgxlLlNgnbu
 ERPKQzJIv5Qw9Zc6i3//mdt/3Hx8h+5h2AAAA
X-Change-ID: 20241030-powerpc-vdso-drop-stackp-flags-clang-ddfbf2ef27a6
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3454; i=nathan@kernel.org;
 h=from:subject:message-id; bh=bFayy90KzO6wEJgJAEKS9naOm6gN2b1q5QrHLnmsrsU=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlKtS8NJ2Q626/gSb+x2bvsUUj9Rludh///vP1Xkf5XM
 WOKpb9iRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZiI+TeG/9HCsif+b5AUK8pY
 MZ11cVXPscSUeewSqVVznxpeePRz4kVGhmfvq2xn52TytUvnLwu/+2bOmTz5DdctBXTPbA1uLH9
 wkBsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Under certain conditions, the 64-bit '-mstack-protector-guard' flags may
end up in the 32-bit vDSO flags, resulting in build failures due to the
structure of clang's argument parsing of the stack protector options,
which validates the arguments of the stack protector guard flags
unconditionally in the frontend, choking on the 64-bit values when
targeting 32-bit:

  clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
  clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
  make[3]: *** [arch/powerpc/kernel/vdso/Makefile:85: arch/powerpc/kernel/vdso/vgettimeofday-32.o] Error 1
  make[3]: *** [arch/powerpc/kernel/vdso/Makefile:87: arch/powerpc/kernel/vdso/vgetrandom-32.o] Error 1

Remove these flags by adding them to the CC32FLAGSREMOVE variable, which
already handles situations similar to this. Additionally, reformat and
align a comment better for the expanding CONFIG_CC_IS_CLANG block.

Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
I say "Under certain conditions" because I am not entirely sure what
they are. I cannot reproduce this error in my host environment but I can
reproduce it in TuxMake's environment, which our CI uses:

https://storage.tuxsuite.com/public/clangbuiltlinux/continuous-integration2/builds/2o9p6AV0oOjkNTPVHNoVckfOf5V/build.log

  $ tuxmake \
        -a powerpc \
        -k ppc64_guest_defconfig \
        -r podman \
        -t clang-nightly \
        LLVM=1 \
        config default
  ...
  clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
  clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2

I suspect that make 4.4 could play a difference here but the solution is
quite simple here (since it is already weird with reusing flags) so I
figured it was just worth doing this regardless of what the underlying
reason is.
---
 arch/powerpc/kernel/vdso/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 31ca5a5470047e7ac0a0f8194fd59c6a3b453b4d..c568cad6a22e6b8a8bcb04463b7c850306364804 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -54,10 +54,14 @@ ldflags-y += $(filter-out $(CC_AUTO_VAR_INIT_ZERO_ENABLER) $(CC_FLAGS_FTRACE) -W
 
 CC32FLAGS := -m32
 CC32FLAGSREMOVE := -mcmodel=medium -mabi=elfv1 -mabi=elfv2 -mcall-aixdesc
-  # This flag is supported by clang for 64-bit but not 32-bit so it will cause
-  # an unused command line flag warning for this file.
 ifdef CONFIG_CC_IS_CLANG
+# This flag is supported by clang for 64-bit but not 32-bit so it will cause
+# an unused command line flag warning for this file.
 CC32FLAGSREMOVE += -fno-stack-clash-protection
+# -mstack-protector-guard values from the 64-bit build are not valid for the
+# 32-bit one. clang validates the values passed to these arguments during
+# parsing, even when -fno-stack-protector is passed afterwards.
+CC32FLAGSREMOVE += -mstack-protector-guard%
 endif
 LD32FLAGS := -Wl,-soname=linux-vdso32.so.1
 AS32FLAGS := -D__VDSO32__

---
base-commit: bee08a9e6ab03caf14481d97b35a258400ffab8f
change-id: 20241030-powerpc-vdso-drop-stackp-flags-clang-ddfbf2ef27a6

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

