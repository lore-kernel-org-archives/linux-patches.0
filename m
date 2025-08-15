Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAA81D90DD;
	Fri, 15 Aug 2025 01:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755221521; cv=none; b=EOjGN5pHOBZvVk5VGQua1xJeYYlIgUdFuo4fXbar71FVOrk39PkkWcN4ae8641X7O1D6iWNHSIASWNfs5uT9UrW8paJvEaDikAJJnFREHHaxg5Yv97smsnvAgIm4h8b6EjdsqVwt1gjEyFCWeBgAMMtLp+NkDxLNFmj3aKRs2qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755221521; c=relaxed/simple;
	bh=2LiwU3rKNVfQm7cDElYzRKByvRhLx0N2Of74XMmo2eY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PkjcTsLel7iP49qbtH1HIC/MToqRJiuK8bxOldtMKAK4FP/pOqUu/PXPG0A6bsuS6k0LxAwifgx9U8T/5ilaN9oUpgnej3ZHIhz/B/8ZdcLLwcZqGLAOooAMIke8u+39tGLPV/icLhf5huqrvc4THr9KZhC2H6L4IG25HkyHmmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5Yi8a1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5Yi8a1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00B8C4CEED;
	Fri, 15 Aug 2025 01:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755221520;
	bh=2LiwU3rKNVfQm7cDElYzRKByvRhLx0N2Of74XMmo2eY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=j5Yi8a1iN6W2uL+kkTuODZsGctpofF1xA8V1c7cmasOm4+EpHAQLUgeFWuZKnEf5N
	 iCGvmrtihuJ6MT3nNpIZipDXmhJDTE4MVSL5b92h4Fewk0AF8yEwZUOESUEFyrYBhO
	 4DP6SD+Y2bDgthrrBPZfffbiOpUYKkPmoqKJHgjBijGjbb/j4NWqJpEyiyLLpfpKkF
	 eKzD2x8okdYCzDJFJutgiL5HWIIQQa08gOViC7bM6YfVqcod7OUkbgZ5WndvQzYZ+P
	 F3pcrw1n/gPiFu0o82AC426jMM+zqUGFMU/EtTJBk54ElE6+LAogubXtZWniW1/MvO
	 VxPokFp1pzSnA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Aug 2025 18:31:41 -0700
Subject: [PATCH 5/6] x86/build: Remove cc-option from -mskip-rax-setup
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-x86-min-ver-cleanups-v1-5-ff7f19457523@kernel.org>
References: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
In-Reply-To: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1022; i=nathan@kernel.org;
 h=from:subject:message-id; bh=2LiwU3rKNVfQm7cDElYzRKByvRhLx0N2Of74XMmo2eY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnz+pgv3Jl28cLssxkqF0OyRHUzjSfOOrol9s1Kf3HDO
 VXGcSnrOkpZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBE+nkYGfZtyjWbLhbvG7Pg
 jPUpRy+OecI/mo07UwPTM0/+8BQVZ2X4zerQ8ivHb8Pyb/Pmxuqb68z1iKm2ksiXcZm5oObHTd8
 kHgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

This has been supported in GCC since 5.1 and clang since 14.0. Now that
x86 requires LLVM 15 or newer since commit 7861640aac52 ("x86/build:
Raise the minimum LLVM version to 15.0.0"), this flag can be
unconditionally added, saving a compiler invocation.

Link: https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=fbe575b652f5bdcc459f447a0e6f0e059996d4ef
Link: https://github.com/llvm/llvm-project/commit/a9fba2be35db674971382e38b99a31403444d9bf
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1bbf943fe9e1..4b4e2a3ac6df 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -160,7 +160,7 @@ else
         KBUILD_CFLAGS += $(cc_stack_align8)
 
 	# Use -mskip-rax-setup if supported.
-	KBUILD_CFLAGS += $(call cc-option,-mskip-rax-setup)
+	KBUILD_CFLAGS += -mskip-rax-setup
 
 ifdef CONFIG_X86_NATIVE_CPU
         KBUILD_CFLAGS += -march=native

-- 
2.50.1

