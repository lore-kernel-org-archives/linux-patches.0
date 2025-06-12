Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1892D4B40;
	Thu, 12 Jun 2025 19:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749758234; cv=none; b=X/uksQDRSkuZPcbzts3moC2lQWHqiPKvLwhRodU0+uNerFeaPcrt3rk3ChHtkInsDW2H80mDYGbHVfpa7ZqmfbIfa2Kz9WwzNJtDonqdMW0tvSw1fnigPKxncnZJC8hVVTUVt6bFRXJ9BBQiQjfUY5tijFW9SUDJFqrAiuJWhB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749758234; c=relaxed/simple;
	bh=RkICIPg0cPvp0gfftu+3DghfNr9uDYcet+Q6+1XpofQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=jhK7MZ6DrzwCHRhk3wVK/PuKdSHIStYk7OJvIrn1mCobTEX8Cq/9/VrhinfLsxgSltamWIhF8e/Yb4SaZK5s29b7w7HQlj3iwx4g5g3iMFmOYSA1QSw4aJ3DxzrwkGwFiEzFwXWV4tblP8MHucykT/U8jwdQM0ARa+CA1SB4/CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crIDHX2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crIDHX2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1462AC4CEEA;
	Thu, 12 Jun 2025 19:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749758233;
	bh=RkICIPg0cPvp0gfftu+3DghfNr9uDYcet+Q6+1XpofQ=;
	h=From:Date:Subject:To:Cc:From;
	b=crIDHX2M3du/SemSBGm2v6Hxcr0mu2qPZ2WtlBXrqnDWyIngAp/+g1FnXN2LOcE0t
	 iGHvonT1TlweSy3QTBYqxb19AWLjm/If+fjSjeGWz26mWSQY70scyP1fUwB7BDTWi4
	 +stSu1o5vv6vveaLROiJfaKt9nXPPYDOimPy+UhXhZPOvIAf4DOAHoJ3X/EbqfkcZn
	 UcVej2uvMj3IZ9TGR7Kfm3StZRejf0Uc2NZWIdtd16lCm7iJAyInHCafU9Uoc1ADsM
	 5/cET1Rmlvc3hGu7Rc/qpRm3RlhlvsLWuWiN0q+lWp+bHogLMwZdxMpxjCB0n3dndZ
	 gSX6JYN8gcaAA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 12 Jun 2025 12:57:01 -0700
Subject: [PATCH] riscv: Require clang-17 or newer for kCFI
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250612-riscv-require-clang-17-for-kcfi-v1-1-216f7cd7d87f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAwxS2gC/x2NSwqFMAwAryJZv0Ab/OFV5C0kphoUPymKIN7d4
 nJgmLkhiqlEaLIbTE6Nui4J/C8DHrtlENQ+MZCjwpWe0DTyiSb7oSbIc3LQVxhWw4mDYuVqTyx
 d3tcEqbKZBL2+Q/t/nhdooh12cQAAAA==
X-Change-ID: 20250612-riscv-require-clang-17-for-kcfi-70812cea4d82
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: Sami Tolvanen <samitolvanen@google.com>, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1738; i=nathan@kernel.org;
 h=from:subject:message-id; bh=RkICIPg0cPvp0gfftu+3DghfNr9uDYcet+Q6+1XpofQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnehuJF+92O/fI7v+TQvHOlPq2sBWs7moOrbGokvdZ0v
 GHRuC3dUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbif4jhr+gHU0PRde0qU1Xz
 oy/f+ZRux8L+efIkJjOLPlnZScwxJQz/TC7HevJEdm26zN+pmFwWzOo+RWuq2/UJEnIPs9dMKTX
 jBgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After the combination of commit c217157bcd1d ("riscv: Implement
HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS"), which starts using
'-fpatchable-function-entry=M,N', and commit d0262e907e29 ("riscv:
ftrace: support PREEMPT"), which allows CONFIG_DYNAMIC_FTRACE to be
enabled by allmodconfig, allmodconfig builds with clang-16 begin
crashing in the generic LLVM kCFI pass (see [1] for the stack trace).

clang-17 avoids this crash by moving to target-specific lowering of the
kCFI operand bundles [2]. Require clang-17 to select CONFIG_CFI_CLANG to
avoid this crash.

Fixes: c217157bcd1d ("riscv: Implement HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS")
Link: https://godbolt.org/z/xG39Pn16o [1]
Link: https://github.com/llvm/llvm-project/commit/62fa708ceb027713b386c7e0efda994f8bdc27e2 [2]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/riscv/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 36061f4732b7..d71ea0f4466f 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -63,7 +63,8 @@ config RISCV
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
-	select ARCH_SUPPORTS_CFI_CLANG
+	# clang >= 17: https://github.com/llvm/llvm-project/commit/62fa708ceb027713b386c7e0efda994f8bdc27e2
+	select ARCH_SUPPORTS_CFI_CLANG if CLANG_VERSION >= 170000
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS if MMU

---
base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
change-id: 20250612-riscv-require-clang-17-for-kcfi-70812cea4d82

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

