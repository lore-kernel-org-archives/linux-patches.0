Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914AB1FDD;
	Mon,  4 Aug 2025 00:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267938; cv=none; b=vCs+XISBo3sfXMN3flWj00lJBkvfTjWxEGf7b95zbLviNlHCXt9dZxmcUUXJ8Cjfht4W9ZH9U5Lixh6Xdnyew3kxySvrlMpxwLBmO81gnEpxj3TzoMRA+E2pDVfL3SLcFMgkPg9GjaDGUlzEGO5XZIvCIWr41YuGawd38qTR8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267938; c=relaxed/simple;
	bh=1KUE5bxIJPdQBz/e5JfdWEef4SoYwPSb7HUyr5wZdBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dd3cauofr5NmjlZPibBepVuPzAe+yvNBC6JK0pcSwEKL+tm9hdRvBNLDN2yMyZfFjCnxaY3E1w6LMWc6d6hrkS+nRFkpmosXM0MEw6ImuFBNu2XaAku5l6fTGBQVSYg2rXYrh4VhLpMZf1OQ+XRE0psQEvcukATfHsAQ1HHtChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3pKr1jJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3pKr1jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AEDC4CEEB;
	Mon,  4 Aug 2025 00:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267938;
	bh=1KUE5bxIJPdQBz/e5JfdWEef4SoYwPSb7HUyr5wZdBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3pKr1jJBhXxbQ3LTscFDAW6iuT0xHYNqJ/zeteYOY1KSqVkkU5eKoJ06tpr4fIzL
	 wr1grOOJWy7GzixMZUmeq2HClkJ72RLDCH4FVnSkJP8sA8VAEIYfGfU1niMGKX/7XL
	 sqpD84zhP6i4lvoMNK71GHPsUWvlXuRq0OOvkT6SaHN4jKpm0TYVX0b/M6b8KB2ML3
	 0x+qS4afcwILV+Hi8yG+CweGDDTDoKThAF6fpJzzuJOHUEvvfzoDY3VV8IcAb+juu5
	 VV+h1QEXVdnyHbw5XrXKPKcbpwIyWWtu/fAtLkuSN1wwA4unBTAlwKdsy1Zbi5VvDm
	 NhcxzGYdM9DJQ==
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
Subject: [PATCH AUTOSEL 5.15 03/44] selftests/futex: Define SYS_futex on 32-bit architectures with 64-bit time_t
Date: Sun,  3 Aug 2025 20:38:08 -0400
Message-Id: <20250804003849.3627024-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003849.3627024-1-sashal@kernel.org>
References: <20250804003849.3627024-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
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

