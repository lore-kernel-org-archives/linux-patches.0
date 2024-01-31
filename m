Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A12FBF1;
	Wed, 31 Jan 2024 03:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706670883; cv=none; b=FsHpgqchRmUGRX++Zqn1yrp7WZUSwDPd5bQrI4qJYPJnkTIoiPJK4+MNCOAOlPIPnVWyD1O3rZwB91UKkbkCuG37KoHXqBAeqnlGa3NWo+rIg/OPxJ8Ot4kIk2afaKvPO16qz8vCrIHkN/ia9mCephAlwuFOLfhwd1jiOZf8Uvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706670883; c=relaxed/simple;
	bh=tJ2dUkJ5sOLupiUg5PutQKOOu3G9r0/nV8y2CDLHKM0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=uBqWiJ/qjgWBMMFNWIh69/POmJguqvBpnKeRrh+KPb3cTid7v2pfHJU+Fxt+RvPhXUug5wx3TjEZEK1MLaSpc+xZE5z6dUkEqWs5aXzixaB7S5du6GdypO7yUgH+DAHU5CFuAiCLddCBUU6gRi07VE8Suoh7omagmGEZWrfm39A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixQJLM/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixQJLM/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554EFC433F1;
	Wed, 31 Jan 2024 03:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706670883;
	bh=tJ2dUkJ5sOLupiUg5PutQKOOu3G9r0/nV8y2CDLHKM0=;
	h=From:Date:Subject:To:Cc:From;
	b=ixQJLM/dFC3+Ctil12iIuKW9k6FWDi+WPZQKhauqw9UB9akAP/FTjWkWK+W6Bs5RW
	 fsWbPBC7SjZuoNAKefXQdrCwuUDiJKiYJYPtSCLKe5uBnMNvzEqgMVt5z866uOqOqz
	 M2TCMCUtrIVIEUaYBQX7vo49mcZRWoQEYf8LIgPfASt8c5rDQjHvpiKRflJsD1rePE
	 7AckL+moV932p8eB2JEgcd4KHcAE1hDQu/EXx6Cnm8SWhJgVhO2/opA+a8jlju7fzw
	 VRz3SIWpGp7FKP6Q0s3I3fWPUlZpbJQTwh8GuWx89luGWcK02uVbxxMTAK2oCh/uzk
	 e1l9bzqyeu05Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 30 Jan 2024 20:14:28 -0700
Subject: [PATCH] s390: vDSO: Drop '-fPIC' from LDFLAGS
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240130-s390-vdso-drop-fpic-from-ldflags-v1-1-094ad104fc55@kernel.org>
X-B4-Tracking: v=1; b=H4sIABO7uWUC/x3NQQqDQAxA0atI1g1Eo6XtVUoXOpOxAesMCUhBv
 LuDy7f5fwcXU3F4NTuYbOqa14r21kD4jussqLEaOup6apnQ+Um4Rc8YLRdMRQMmyz9cYlrG2ZG
 YH3wfpn4KA9RMMUn6vxbvz3GcHrtBrXIAAAA=
To: hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, ndesaulniers@google.com, 
 morbo@google.com, justinstitt@google.com, linux-s390@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2881; i=nathan@kernel.org;
 h=from:subject:message-id; bh=tJ2dUkJ5sOLupiUg5PutQKOOu3G9r0/nV8y2CDLHKM0=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKk7dyuditb8t9L+pvPFPQ43KrXeJhpfjFe7yMi0VcFlw
 oH9DO0tHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAizFIM/wuWBKoe+c2+dbV5
 SoXXzbNti6uTJ3fxNghE3P9ulH/ndRojw/n2/3PLlavVtL8t2CrFo5pYGa/K0RLko3GxQipbqJm
 XGQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

'-fPIC' as an option to the linker does not do what it seems like it
should. With ld.bfd, it is treated as '-f PIC', which does not make
sense based on the meaning of '-f':

  -f SHLIB, --auxiliary SHLIB Auxiliary filter for shared object symbol table

When building with ld.lld (currently under review in a GitHub pull
request), it just errors out because '-f' means nothing and neither does
'-fPIC':

  ld.lld: error: unknown argument '-fPIC'

'-fPIC' was blindly copied from CFLAGS when the vDSO stopped being
linked with '$(CC)', it should not be needed. Remove it to clear up the
build failure with ld.lld.

Fixes: 2b2a25845d53 ("s390/vdso: Use $(LD) instead of $(CC) to link vDSO")
Link: https://github.com/llvm/llvm-project/pull/75643
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Hi all,

The LLVM folks are working on SystemZ support in ld.lld and this issue
came up from my initial testing. There are also some other issues that I
have come across in testing that I note in the GitHub pull request
linked above. If they seem like kernel issues, any expertise or help
would be greatly appreciated towards getting this working.

Cheers,
Nathan
---
 arch/s390/kernel/vdso32/Makefile | 2 +-
 arch/s390/kernel/vdso64/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index caec7db6f966..b12a274cbb47 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -22,7 +22,7 @@ KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin
 
-LDFLAGS_vdso32.so.dbg += -fPIC -shared -soname=linux-vdso32.so.1 \
+LDFLAGS_vdso32.so.dbg += -shared -soname=linux-vdso32.so.1 \
 	--hash-style=both --build-id=sha1 -melf_s390 -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index e3c9085f8fa7..caa4ebff8a19 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -26,7 +26,7 @@ KBUILD_AFLAGS_64 += -m64
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_64 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 += -m64 -fPIC -fno-common -fno-builtin
-ldflags-y := -fPIC -shared -soname=linux-vdso64.so.1 \
+ldflags-y := -shared -soname=linux-vdso64.so.1 \
 	     --hash-style=both --build-id=sha1 -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_64)

---
base-commit: 41bccc98fb7931d63d03f326a746ac4d429c1dd3
change-id: 20240130-s390-vdso-drop-fpic-from-ldflags-0338365b4bc5

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

