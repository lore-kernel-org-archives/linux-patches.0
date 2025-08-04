Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE6819E81F;
	Mon,  4 Aug 2025 00:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267360; cv=none; b=S5/WlNO3jNoeevMtCI9rjUyZpVRnrALIK+MXDQfoae42sDOpnSWTXG7kOfBFMBZxTK2LKvN4TvrC9MSqNtNzIs8eGmpZBad6E29AAjVo2E8JMJ66iDimu918rea2Xp6YnpGEKRA85mZUapA2YtMKOJGlGP62IMsDFnC4vBN/MJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267360; c=relaxed/simple;
	bh=9UMiUf1MBn+wDvZ8oHtCiFOAIjMQ1Ucmj6kDwvuEGVg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qKpCNSW2hQJh88QMWGsN2KhHAKaSFT5fFOpyWvpbIpxpSHk3jjAibVmIuHFtzPk0t1WYgt8fVIJ4V5ZBar6Efb+IHy1a4d8S9xxzK9YDUxc8Zy9v6O2NtDXgonq9GB+yH31WtHbxUZvFpx7r+R5mLxKlXNnIsNVbGZcs/eTYvZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tL+yWW5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tL+yWW5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727DBC4CEEB;
	Mon,  4 Aug 2025 00:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267360;
	bh=9UMiUf1MBn+wDvZ8oHtCiFOAIjMQ1Ucmj6kDwvuEGVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL+yWW5lKlEJq5LLOn+OWGwcfUooPIMlfDwe2+xX8nn3aGEVS3FFTAtWsyQCJWco8
	 3NiMynYQWSPMXcJFzykwqoihCIH3CDkNIdVA76+UpynGY8EecULqAnz4LGl5VVqHaq
	 bD0IoW6RJ3C0hAYN5cjl2TfP5behLLKmgZmeClpXgcAjjSebo1f3QfoE0rsM3UMu+6
	 PF2BxejXuIuvL2PThXk+VzoIyG5dgRg1apwW5xlO95L/zcFYzWktZn0A4AvSGIUozx
	 HImikGq/XZwEaKLyKvxb8JtgxtQzjAVJVXOdvsMwJLJsMsWLOzlQCKgKzSXFtL4XVh
	 +w4iTW+BZbtvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	tglozar@redhat.com,
	rostedt@goodmis.org,
	jolsa@kernel.org,
	charlie@rivosinc.com,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.15 35/80] tools/build: Fix s390(x) cross-compilation with clang
Date: Sun,  3 Aug 2025 20:27:02 -0400
Message-Id: <20250804002747.3617039-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit a40f0cdce78be8a559ee8a85c908049c65a410b2 ]

The heuristic to derive a clang target triple from a GCC one does not work
for s390. GCC uses "s390-linux" while clang expects "s390x-linux" or
"powerz-linux".

Add an explicit override.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250620-tools-cross-s390-v2-1-ecda886e00e5@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me understand better what the issue is. Based on my analysis:

**Backport Status: YES**

This commit fixes a critical cross-compilation issue where the heuristic
to derive a clang target triple from a GCC one fails for s390
architecture. Here's my detailed analysis:

## Analysis of Code Changes:

The patch modifies `tools/scripts/Makefile.include` by adding two lines
after line 104:
```makefile
CLANG_CROSS_FLAGS := --target=$(notdir $(CROSS_COMPILE:%-=%))
+CLANG_TARGET := $(notdir $(CROSS_COMPILE:%-=%))
+CLANG_TARGET := $(subst s390-linux,s390x-linux,$(CLANG_TARGET))
+CLANG_CROSS_FLAGS := --target=$(CLANG_TARGET)
```

## Key Findings:

1. **Bug Type**: This fixes a build failure when cross-compiling kernel
   tools for s390 architecture using clang.

2. **Root Cause**: GCC uses "s390-linux" as the target triple while
   clang expects "s390x-linux" or "systemz-linux". The existing
   heuristic that derives the clang target from the GCC cross-compiler
   prefix fails for s390.

3. **Similar Fixes Already Present**: I found that other parts of the
   kernel already handle this incompatibility:
   - `tools/testing/selftests/nolibc/Makefile:` converts s390-linux to
     systemz-linux
   - `tools/include/nolibc/Makefile:` converts s390-linux to systemz-
     linux
   - `scripts/Makefile.clang:` directly uses s390x-linux-gnu

4. **Impact**: Without this fix, cross-compilation of kernel tools for
   s390 using clang will fail, affecting:
   - Developers building tools for s390 systems
   - CI/CD pipelines that cross-compile for multiple architectures
   - Distribution builders who need to build kernel tools

5. **Risk Assessment**:
   - The change is minimal and isolated to the build system
   - It only affects the clang target selection logic
   - No runtime behavior changes
   - Similar transformations are already proven in other makefiles

6. **Stable Tree Criteria**:
   - ✓ Fixes a real bug that affects users (build failure)
   - ✓ Small and contained fix (2 lines)
   - ✓ No side effects beyond fixing the issue
   - ✓ No architectural changes
   - ✓ Only touches build infrastructure
   - ✓ Minimal risk of regression

This is a clear candidate for stable backporting as it fixes a concrete
build failure with minimal risk.

 tools/scripts/Makefile.include | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 5158250988ce..ded48263dd5e 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -101,7 +101,9 @@ else ifneq ($(CROSS_COMPILE),)
 # Allow userspace to override CLANG_CROSS_FLAGS to specify their own
 # sysroots and flags or to avoid the GCC call in pure Clang builds.
 ifeq ($(CLANG_CROSS_FLAGS),)
-CLANG_CROSS_FLAGS := --target=$(notdir $(CROSS_COMPILE:%-=%))
+CLANG_TARGET := $(notdir $(CROSS_COMPILE:%-=%))
+CLANG_TARGET := $(subst s390-linux,s390x-linux,$(CLANG_TARGET))
+CLANG_CROSS_FLAGS := --target=$(CLANG_TARGET)
 GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)gcc 2>/dev/null))
 ifneq ($(GCC_TOOLCHAIN_DIR),)
 CLANG_CROSS_FLAGS += --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
-- 
2.39.5

