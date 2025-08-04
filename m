Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C33E1C84C6;
	Mon,  4 Aug 2025 00:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267712; cv=none; b=S40lwspu8YFDul9L754iF9Iy21D7HWP9zN+ORGs9JP3PXaMwfXdBe0vpLAhRtHAUSMkyLGLFvcydWdC+P08pDQo6gGJ92CE2E7O/IH6qde8m83RomIxjhqfJxOBbTsKf97Ebhlmz3z1lDdcdLJCRPdXEND+nrKwwQizTEWqR8KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267712; c=relaxed/simple;
	bh=90fjRfoTjgHOASwrqoRjuS6DOZClD2UuHTfL3+SKZX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rcW3zk1aH1c6AX2thPs//KXoCpOmaQ8EsVlh07CdKZ3D0okIX6kR0d09ABitziYkAp5m4aZClUTzGTtEnurwFJnLhrfrfDJrmnmRYKlTl7qG/wNT68wom/HOV6zQzttL/WxjvdO8va3N3wIfBRp8KmiLzhzUmXR3UdGN2dibY1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWHLlQY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWHLlQY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F94C4CEF0;
	Mon,  4 Aug 2025 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267712;
	bh=90fjRfoTjgHOASwrqoRjuS6DOZClD2UuHTfL3+SKZX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWHLlQY+Bw0awZe09gj2LRzK4vfix6/q8n1QY9Qvxn7zKjQ0PzN3AlYuCZEzh6QN0
	 TWh9dVVrGIJz5jtuzZqBniPSvdbfk1Ngudt1MZHU5Uf9Jds5WqmpHdIc34bLz3CFJe
	 qHjUqy3P6OPfWddWPnmqF1zRolgq/NF717RSXt2kHx9cBYU7WGSYHbhsmgGsgfUT/a
	 vHZcjaUohown2WoAMxY0vpFDuFP2S/D9x+rjdBtLqWQ0wkHlK40VLwU/Uz5frrgsW3
	 dm2bnKwyN9eZ7Mz7NQzZKJfr+hnkPQ8NYSOKvhiEp/W4sDJCKE1cwOYOBm4P8Sa/Ny
	 rkHnGB4N0TDJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	rostedt@goodmis.org,
	tglozar@redhat.com,
	jolsa@kernel.org,
	acme@redhat.com,
	charlie@rivosinc.com,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.6 24/59] tools/build: Fix s390(x) cross-compilation with clang
Date: Sun,  3 Aug 2025 20:33:38 -0400
Message-Id: <20250804003413.3622950-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
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
index ff527ac065cf..c006e72b4f43 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -98,7 +98,9 @@ else ifneq ($(CROSS_COMPILE),)
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

