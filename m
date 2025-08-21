Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFC72D7DE8;
	Thu, 21 Aug 2025 21:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810966; cv=none; b=X2lna2+sZgePGpXFSMbRV0jYIZtsZlKaqUv8fposG46K0wqpyUj5vyBU+MfG8lweR5wDQTKJrprfptzmg5v4ZoOHtgijS5f5M2QFEWO5W9nDDEj4bjAeI/BwF7LO4BVZBEIome5slr9PPJm9EHu3P2fRTnu8s/WhZvv1uGCGfL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810966; c=relaxed/simple;
	bh=k8t2LMzkHbTix/DiHIeNz0Pk9z8ZvuqlTYVV5CKGLxo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JA15D2ly8WHz0JPECKwT7aO54wvjrXKx7uKMdr+tsi7YaB+mcqM+hWF47/zpGGRRkLSnzNkHi+fZ8mLmKSrZS0jG10qJcgU6fTyTiBCsdZhwt/9O0UJWAPuvegxQtxg+q/mvTER2Ejy/jAQN8GTt4cnTu6rT9rMvkHc/8a7FAkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GD3v7Wtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GD3v7Wtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCDAC113D0;
	Thu, 21 Aug 2025 21:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810965;
	bh=k8t2LMzkHbTix/DiHIeNz0Pk9z8ZvuqlTYVV5CKGLxo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GD3v7WtlG5xYR/Z3EK1MnOl2iyyRM1rMSx2wm9Ua0PX2kRPwtG8LJifnqf+9Hwd7B
	 32ZCrQsemML2UayOB6DeS4YK8pe0XyMb89Te++sSe6Vog6m9tZjGoLxKAqo0E2CJFk
	 xYVKu7iBHzizPxx8io2A2sYbqBUjuVQiLm0izajDr7WaMPF2dS9VsvxxuggrICGoJj
	 bn8bX4seFrjEXTtlxAMNjOpOzDxq6OdxNQH+KI3j8C5uO6k/cVq6JOgi5iQer/XSrP
	 F2RRD6H1JQxwgBTl4R+pJI5IMnIbqOAsg0SQeUzDAt9cVnUDsdoJXxcIIvQtiyWbRE
	 n5dcfhppWLwzw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:41 -0700
Subject: [PATCH v2 04/12] arm64: Remove tautological LLVM Kconfig
 conditions
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-4-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Will Deacon <will@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
 linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1412; i=nathan@kernel.org;
 h=from:subject:message-id; bh=k8t2LMzkHbTix/DiHIeNz0Pk9z8ZvuqlTYVV5CKGLxo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe5rCEk5cW9wg6jDh4UvntsNHek/MaTbebxi/2m+5X
 3ltuUFoRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIE3dGhssZXDFm/YrseQVT
 Lpeqvv+hva78ke18lYRjTYU7ZaeWfWT4HxA96azS8XR/v3krUs34Wr7f+vrZO/2EVLPfhzU9dfY
 q/AA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, two sets of always true conditions can be
safely removed in the arm64 Kconfig file.

Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: linux-arm-kernel@lists.infradead.org
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

