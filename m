Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75299172BCF;
	Fri,  5 Apr 2024 19:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712345491; cv=none; b=q8fRIolxYrdWJiYz1YVC1+mAy+G6m1gdAkB79wHJgjODh448VTsS9Hs9fERyDhmB3HeXOOTh5VKp/n4SYezVOHTflKiZSDSuIT0/fNsY2UAfORQ6mtRTNn614FUaCJCX5fZFpEeOYWPbLlzxtWGHmjWMEUC8tDSAaxpEiCdyI1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712345491; c=relaxed/simple;
	bh=mcHa8E2wMvHirG3Mz0WBJUwRUj2+EY6b29WpKMTq2oo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=MIBhgBhj0hBUfSwwLhIoBim31YQ3E4DzJO8nPqT7DII7mY9db4uXE5A1YAvqdo1/WFzuMmNHbcrG6QMGwomCRZ4bjHTTGt0xqlB5vsuzCVgTB6dqHsyq3hJ9ocYhX8ZVtsZUf4AKOYGxJE9yLZ66k1+Sa6L2C/uck5g5XVJN/rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=la9buEdi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="la9buEdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2D5C433F1;
	Fri,  5 Apr 2024 19:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712345491;
	bh=mcHa8E2wMvHirG3Mz0WBJUwRUj2+EY6b29WpKMTq2oo=;
	h=From:Date:Subject:To:Cc:From;
	b=la9buEdiiWXnCF+EY1rlq48u/vV8KcmM3HksMr7eGGWuWgB0vQX+9hVTplQne7rEu
	 XJeZdkV95kXtn13j7qH70nmG+YJEwJmUe1NH8TZEo3899vyRHYsteYm3zbNfBwEzva
	 OCUMPPR+5UVI/QopysTEERQSuwRvCrlnQ1gRjDLcPXek7V8MhivuOxPRJNwu6HNSDb
	 kKl7FYr9pk58FHv6oxog/+bTn+HNXgr4/n5+Y8DQC3A5I/kAyHHxfrRxZFMSfFdJCO
	 luEiIT2SoIPUaEaWyrM44M/wLp98BGwZJeZ6gOx8MpEyBgspsjYJFWxmb/IN/DNCdK
	 JkU4BkjcnCDUg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 05 Apr 2024 12:31:22 -0700
Subject: [PATCH] powerpc: Fix fatal warnings flag for LLVM's integrated
 assembler
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240405-ppc-fix-wa-fatal-warnings-clang-v1-1-bdcd969f2ef0@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIlREGYC/x2NQQqAMAwEvyI5G4hWPfgV8VBrqgGppRUVxL8bv
 O3AMPtA5iScoS8eSHxKlj0oVGUBbrVhYZRZGWqqG2qoxRgdernxsujtYTcdKUhYMrpNfezIeOJ
 posoY0EpMrPr/MIzv+wFxgQ4KcQAAAA==
To: mpe@ellerman.id.au
Cc: morbo@google.com, justinstitt@google.com, ajd@linux.ibm.com, 
 bgray@linux.ibm.com, linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1225; i=nathan@kernel.org;
 h=from:subject:message-id; bh=mcHa8E2wMvHirG3Mz0WBJUwRUj2+EY6b29WpKMTq2oo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkCgZP8buuU9mXWO53Qqd4Qz1AmZMvTckLlQoZcyuLve
 wuLy191lLIwiHExyIopslQ/Vj1uaDjnLOONU5Ng5rAygQxh4OIUgImcvMLwV0i5d+lrn9C1+WK/
 wop1RXa2dB7YVdY6+/sdg9hpNysYHjH8d63360lLENe61FK3++fXyH+hng8r2duEL9lpfdkpqGb
 CBQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with LLVM_IAS=1, there is an error because
'-fatal-warnings' is not recognized as a valid flag:

  clang: error: unsupported argument '-fatal-warnings' to option '-Wa,'

Use the double hyphen version of the flag, '--fatal-warnings', which
works with both the GNU assembler and LLVM's integrated assembler.

Fixes: 608d4a5ca563 ("powerpc: Error on assembly warnings")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/Kbuild | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kbuild b/arch/powerpc/Kbuild
index da862e9558bc..571f260b0842 100644
--- a/arch/powerpc/Kbuild
+++ b/arch/powerpc/Kbuild
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror -Wa,-fatal-warnings
-subdir-asflags-$(CONFIG_PPC_WERROR) := -Wa,-fatal-warnings
+subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror -Wa,--fatal-warnings
+subdir-asflags-$(CONFIG_PPC_WERROR) := -Wa,--fatal-warnings
 
 obj-y += kernel/
 obj-y += mm/

---
base-commit: bfe51886ca544956eb4ff924d1937ac01d0ca9c8
change-id: 20240405-ppc-fix-wa-fatal-warnings-clang-603f0ebb0133

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

