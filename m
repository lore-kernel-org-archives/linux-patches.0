Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBAB29A2;
	Mon,  4 Aug 2025 00:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267490; cv=none; b=lMZKby1hCedLbb1x0zz7macz5Uow8OtX9F0nAUOC6THDRH4b92nK9zJO4lP3Ifmb9Q2rGuAfwy8oSAFADQi/Is2M/xj0v+2g6x6CPyDclFeqWfiGnkizXX3SNqAN0Nb7ZJEwK9W5rOXJYTieSrU7kbiNrRpr+z755wTEc8GQQkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267490; c=relaxed/simple;
	bh=1KUE5bxIJPdQBz/e5JfdWEef4SoYwPSb7HUyr5wZdBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gutxPMa41tF6fW3WsQ++WvZ73pF+roTuq8UxUBBAf+/o4ZXWlfttzjUaQchF62efVC88mzu/Nt0y/R5Ght/glbvalsEkDUgmSkG6suWTRiaX373ChTaxWUSHWlYrfbEVX7ltqdzVJcHg+N39sOQ5YeQnAFFQiTCh+9e92KRiZIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHC+OPwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHC+OPwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E100C4CEEB;
	Mon,  4 Aug 2025 00:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267490;
	bh=1KUE5bxIJPdQBz/e5JfdWEef4SoYwPSb7HUyr5wZdBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHC+OPwYzZIA6Igy0NwQZA6iN501MVMBPD0fYt25B9NtmrGtD7Yj7k10Nfbty8Q10
	 SOh82vXXuVmz3uyttfrDsGDcp3VjyjhR5lzi3jAK8uRATBl2rm7uVZBU3Ooddmhtx8
	 TZ1FGElC1b/7hlZwlWRv/r7od4RZESMP6oliaFQpdu2Jo/KF/nwmWKFQ10Hc9sN89x
	 sHEXYZu7HNFf3+li3ncgGkfC1L74ZVKwzbZ8m3Y9ufJLouz20ySs+lS49WcMabwLQn
	 Mb89mLXt7ge11WPjcLRpr8wjXzuWCCXGkZyTwDCZPpQDgIxlm20xTg39smnbdjBLF8
	 Hg3f4K7fCO3AQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cynthia Huang <cynthia@andestech.com>,
	Ben Zong-You Xie <ben717@andestech.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.12 04/69] selftests/futex: Define SYS_futex on 32-bit architectures with 64-bit time_t
Date: Sun,  3 Aug 2025 20:30:14 -0400
Message-Id: <20250804003119.3620476-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Cynthia Huang <cynthia@andestech.com>

[ Upstream commit 04850819c65c8242072818655d4341e70ae998b5 ]

The kernel does not provide sys_futex() on 32-bit architectures that do not
support 32-bit time representations, such as riscv32.

As a result, glibc cannot define SYS_futex, causing compilation failures in
tests that rely on this syscall. Define SYS_futex as SYS_futex_time64 in
such cases to ensure successful compilation and compatibility.

Signed-off-by: Cynthia Huang <cynthia@andestech.com>
Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/all/20250710103630.3156130-1-ben717@andestech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real compilation failure bug**: The commit addresses a
   build failure in kernel selftests on 32-bit architectures with 64-bit
   time_t, specifically riscv32. This prevents the futex selftests from
   compiling on these architectures, which is a functional bug that
   affects testing infrastructure.

2. **Simple and contained fix**: The change is minimal - it only adds a
   conditional preprocessor definition that maps `SYS_futex` to
   `SYS_futex_time64` when the former is not defined but the latter is.
   The fix is:
  ```c
  #if !defined(SYS_futex) && defined(SYS_futex_time64)
  #define SYS_futex SYS_futex_time64
  #endif
  ```

3. **No risk of regression**: The change is guarded by preprocessor
   conditionals that only activate when `SYS_futex` is not defined AND
   `SYS_futex_time64` is defined. This means it has zero impact on
   architectures where `SYS_futex` is already defined, ensuring no
   regressions on existing systems.

4. **Affects kernel testing infrastructure**: While this is in the
   selftests directory and not core kernel code, having working
   selftests is critical for kernel stability and quality assurance. The
   futex selftests are important for validating futex functionality
   across different architectures.

5. **Addresses Y2038 compatibility**: This fix is part of the broader
   Y2038 compatibility effort where 32-bit architectures are
   transitioning to 64-bit time_t. As more 32-bit architectures adopt
   64-bit time_t, this fix becomes increasingly important.

6. **Clear problem and solution**: The commit message clearly explains
   the issue (glibc cannot define SYS_futex on certain architectures)
   and provides a clean solution that maintains compatibility.

The fix follows stable kernel rules by being a minimal change that fixes
an important bug without introducing new features or architectural
changes. It's confined to the testing infrastructure and has clear
boundaries with no side effects beyond enabling compilation of the futex
selftests on affected architectures.

 tools/testing/selftests/futex/include/futextest.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/futex/include/futextest.h b/tools/testing/selftests/futex/include/futextest.h
index ddbcfc9b7bac..7a5fd1d5355e 100644
--- a/tools/testing/selftests/futex/include/futextest.h
+++ b/tools/testing/selftests/futex/include/futextest.h
@@ -47,6 +47,17 @@ typedef volatile u_int32_t futex_t;
 					 FUTEX_PRIVATE_FLAG)
 #endif
 
+/*
+ * SYS_futex is expected from system C library, in glibc some 32-bit
+ * architectures (e.g. RV32) are using 64-bit time_t, therefore it doesn't have
+ * SYS_futex defined but just SYS_futex_time64. Define SYS_futex as
+ * SYS_futex_time64 in this situation to ensure the compilation and the
+ * compatibility.
+ */
+#if !defined(SYS_futex) && defined(SYS_futex_time64)
+#define SYS_futex SYS_futex_time64
+#endif
+
 /**
  * futex() - SYS_futex syscall wrapper
  * @uaddr:	address of first futex
-- 
2.39.5

