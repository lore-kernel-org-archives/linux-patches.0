Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553ED2737E7;
	Mon, 18 Aug 2025 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543478; cv=none; b=l+reLL0eENHoZK9ZFX/6yg9P8gLKzzUtyadCawNLr27HcISCQi/SgZ+sLyhU1oq/Zeas1nr0aBDgDlQJVAqDefkg5uTXd8ZvkCo4icxSKi8Tb7UD+PXs+ahCjHTS3QPFMIWfwoV2FSzMcFkj7SfiP9eqg9E9Uhk8Ak5jCKXa6x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543478; c=relaxed/simple;
	bh=nJ35DlX2T53iUJ+subiqQJTdhVfvpvfP4TLzJ6JO4ao=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DRAq/4IL8RmjwdgY4eA9yn5N526dt0ml0zggvMw8Cvo6ZpOUbIpmWaSF8uhNZRzJuLHslQkIIPd6NBXWGEsvpFKxXmnSsKFLd0SduIFeyYhfBTciS9w0YGILdEMzmmJJvivxHHuM3G5TYYrXXgSuDU1tOprlHtd3AAaw1VDDSU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASunkgBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASunkgBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F04EC116C6;
	Mon, 18 Aug 2025 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755543477;
	bh=nJ35DlX2T53iUJ+subiqQJTdhVfvpvfP4TLzJ6JO4ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ASunkgBL6b+ELW9k7q04RxRGKg3pAgxjh912ojXZgFYBNGtzTThQfljhg3ygVZv/K
	 wrha6otvNER9Oa01RTLYsynZDErbD7Dc7iGo+RlfzDnAXHwXBdts+UlB9rMwCTZoxd
	 HGyV+9BKt6plZWvO4V/YUBsDKgRp/W04hb+5i15ucE/Sdy/5QeeL2KgCnjHFDSAX9V
	 AAnsU9U3akAsIj/0kR90XEiToANu9Anzd+SvyTE7x14YJIPkwJeBbpEisfcWZMfvD/
	 eIA6MTrA1up6eD3LEM/3a6aXTqiiIVscuZZwozmiyNyBq8iuL0i8k4y7QvWSP5ija2
	 GfQhvKjzk28tg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 18 Aug 2025 11:57:20 -0700
Subject: [PATCH 04/10] arm64: Remove tautological LLVM Kconfig conditions
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-bump-min-llvm-ver-15-v1-4-c8b1d0f955e0@kernel.org>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1445; i=nathan@kernel.org;
 h=from:subject:message-id; bh=nJ35DlX2T53iUJ+subiqQJTdhVfvpvfP4TLzJ6JO4ao=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmLyxe6ysnU1s56xM/RNinw2qwitQrbe8YqwdL8pakrV
 oa4vc/sKGVhEONikBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABN5EM3I0KAn5qeuXRWgzLLz
 t/7azPMMvOtl9j2ICfgbfMBHmyv6KSPDz1RFu4rli7qyL5z8U+417cq8n4VteZeLBI4t80x+25/
 NBAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, two sets of always true conditions can be
safely removed in the arm64 Kconfig file.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm64/Kconfig | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a6..41c05562e9af 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1492,8 +1492,6 @@ choice
 
 config CPU_BIG_ENDIAN
 	bool "Build big-endian kernel"
-	# https://github.com/llvm/llvm-project/commit/1379b150991f70a5782e9a143c2ba5308da1161c
-	depends on AS_IS_GNU || AS_VERSION >= 150000
 	help
 	  Say Y if you plan on running a kernel with a big-endian userspace.
 
@@ -2363,8 +2361,7 @@ config STACKPROTECTOR_PER_TASK
 
 config UNWIND_PATCH_PAC_INTO_SCS
 	bool "Enable shadow call stack dynamically using code patching"
-	# needs Clang with https://github.com/llvm/llvm-project/commit/de07cde67b5d205d58690be012106022aea6d2b3 incorporated
-	depends on CC_IS_CLANG && CLANG_VERSION >= 150000
+	depends on CC_IS_CLANG
 	depends on ARM64_PTR_AUTH_KERNEL && CC_HAS_BRANCH_PROT_PAC_RET
 	depends on SHADOW_CALL_STACK
 	select UNWIND_TABLES

-- 
2.50.1

