Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CA829429;
	Sat, 27 Jan 2024 18:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706378869; cv=none; b=nA2ECl+oX2dN91BcZahTSjrS0gqICujIghKy/k0RFoHPzVu8+a890tH56deq8SlHvM1/t/12IP+7mDIH7usDWSkkJxuufqGx3PZWkmEqfq9j4vUmAP9PBQL41Oczztqd4EUPmj9GbaHQDEi4CmOgqOFFS+bRfVJzP5DR+dCHaC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706378869; c=relaxed/simple;
	bh=qtNyFxcBkmUTCmrI3w7d91OiAWcSyJmp5wFzXkJnfgU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mzpxmDGDGil08d1aQ7bxVFMj86qKczBWn5ZM13Tymv/sS9qnRlNdL2gB6I/Zyn3xmznQCqU+0cQfq05W674OBcvxpfz8MCGLpKxNR3yw+ZxqmSTjw/d2Jx6CbusTVZB94eB2b1gY4Cn++nE+YLUWJaOP+uHa56/XIlHVf/fSUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d57GkvdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d57GkvdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74D9C433F1;
	Sat, 27 Jan 2024 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706378868;
	bh=qtNyFxcBkmUTCmrI3w7d91OiAWcSyJmp5wFzXkJnfgU=;
	h=From:Date:Subject:To:Cc:From;
	b=d57GkvdTT9GzIuvTC7jRsYQ+SvmHJ52/jRZXK/P+rCS43j+eyxu4wVgwp4dgAfxL4
	 yQmoj/kWH6qed1J5imgzEhN86fwDZhMdEXyRgfHMza9QaH3G7LYzouri7I9v1W2IAr
	 N2vuE335kezdqO/WNlTsV0QlLf0DMDnLkdjo5p+2EoMBL6Fs7ZxcLRzOOAOM6PKOa9
	 QlFXE6HQRiopY5Hxn/mnghXRunvudA4dDMgO228A90S9f8S7vmlbiJbW/R/JQyNKHB
	 W27MLiv508K5dmU5F3Q296hYqMhH5Kmw3UEcvgxCii6W3XILZLnoFYvTkXm+pwlIcc
	 s/AJQ26MNlG9Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Sat, 27 Jan 2024 11:07:43 -0700
Subject: [PATCH] powerpc: xor_vmx: Add '-mhard-float' to CFLAGS
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240127-ppc-xor_vmx-drop-msoft-float-v1-1-f24140e81376@kernel.org>
X-B4-Tracking: v=1; b=H4sIAG5GtWUC/x3MUQqDMAwA0KtIvhfQTlS8ioxR23QG1JRUpCDe3
 bLP9/MuSKRMCcbqAqWTE8te0LwqcIvdf4Tsi8HUpq0b02OMDrPo99wyepWIW5JwYFjFHmh9N8z
 tuw9D56AUUSlw/vfT574fW3QHpW4AAAA=
To: mpe@ellerman.id.au
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org, 
 naveen.n.rao@linux.ibm.com, morbo@google.com, justinstitt@google.com, 
 linuxppc-dev@lists.ozlabs.org, patches@lists.linux.dev, 
 llvm@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1691; i=nathan@kernel.org;
 h=from:subject:message-id; bh=qtNyFxcBkmUTCmrI3w7d91OiAWcSyJmp5wFzXkJnfgU=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKlb3YqnZ6/+dz2C5YNv4empdqc5Cq5OfGkX+pf7Wc2mB
 NXvbCumdJSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJvGxi+O/i6GD82yvIZuIf
 1Xu/dq6Y/2SD/bO/f//+s8t7kLfsk3ECI8PKA4zulfevxsQ3h909xy8fuCHzMUPihb7EvVcfb7w
 bNJcHAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

arch/powerpc/lib/xor_vmx.o is built with '-msoft-float' (from the main
powerpc Makefile) and '-maltivec' (from its CFLAGS), which causes an
error when building with clang after a recent change in main:

  error: option '-msoft-float' cannot be specified with '-maltivec'
  make[6]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] Error 1

Explicitly add '-mhard-float' before '-maltivec' in xor_vmx.o's CFLAGS
to override the previous inclusion of '-msoft-float' (as the last option
wins), which matches how other areas of the kernel use '-maltivec', such
as AMDGPU.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/1986
Link: https://github.com/llvm/llvm-project/commit/4792f912b232141ecba4cbae538873be3c28556c
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 6eac63e79a89..0ab65eeb93ee 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -76,7 +76,7 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
 
 obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
-CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec)
+CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
 # Enable <altivec.h>
 CFLAGS_xor_vmx.o += -isystem $(shell $(CC) -print-file-name=include)
 

---
base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
change-id: 20240127-ppc-xor_vmx-drop-msoft-float-ad68b437f86c

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

