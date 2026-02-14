Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F029C311958;
	Sat, 14 Feb 2026 21:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104438; cv=none; b=EI/OtZVps7bLsRuDP2R/EbgEVdZbofltK9Y2clK6Ke2DoQt0O8R/pHFddWse6dh+BNoK7VoaFCua5/w570HiAnwjmL65xVMn8qKD2PHAWlrrUT5V5dpgaCr49ptEbCozbUXX4O8JTAa+u2TI+Q97hcGK1sMjInibiHIGnQrrWnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104438; c=relaxed/simple;
	bh=jZniUG8MJE6NEjp2sQ6SyA4QAB2SmzL08cFseyqOA2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kum1LsJSjyBKgzYWt5Ek0pTLGyca0HXYWURB7sj9sjgiDp+CR26tmYQPDsP79iIyVS34/O508+3B3qUQ2qKyPBRMHfXtrGqbNrzG/Wih2BdYoy/PtePfeKheW/jvO5z3+zyqevlP8boVfkTZqlsfDb56RYMzy381FbWx69oXQtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEDi55Q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEDi55Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC420C19422;
	Sat, 14 Feb 2026 21:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104437;
	bh=jZniUG8MJE6NEjp2sQ6SyA4QAB2SmzL08cFseyqOA2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEDi55Q9Kg3iVt/WPBxkg8fr4ZvTKuYfQq1lxD9l43cMC4YED93jV51I8ly/7eAlr
	 eCKeUEt3uAEHs6y1yJOqVAPNzYZa8uMrrXQ6duYF0UYzPzLFmD8gybBToN84k7/dSr
	 Jqeor5+rEcQJClXz5ncNulk7x/la1PZmFyyMAw6yrO2CLZMyK+78CV0hky5lYm7fqD
	 CCiRQoA8jpL/TKcgyEsjYqTsI+Sz88MDc6W9BuNaF0u/tPh0Rc1ggnsBrXOhz14Hlg
	 uV5HPnRAHvcUaDm2YYxPkF6I+YK9uUhVlBCnZ9FWs6257ya5kkH6K5vCly2soOGOy+
	 +26W/U0nH8lcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Masney <bmasney@redhat.com>,
	kernel test robot <lkp@intel.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-5.10] openrisc: define arch-specific version of nop()
Date: Sat, 14 Feb 2026 16:23:48 -0500
Message-ID: <20260214212452.782265-83-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 0dfffa5479d6260d04d021f69203b1926f73d889 ]

When compiling a driver written for MIPS on OpenRISC that uses the nop()
function, it fails due to the following error:

    drivers/watchdog/pic32-wdt.c: Assembler messages:
    drivers/watchdog/pic32-wdt.c:125: Error: unrecognized instruction `nop'

The driver currently uses the generic version of nop() from
include/asm-generic/barrier.h:

    #ifndef nop
    #define nop()   asm volatile ("nop")
    #endif

Let's fix this on OpenRISC by defining an architecture-specific version
of nop().

This was tested by performing an allmodconfig openrisc cross compile on
an aarch64 host.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601180236.BVy480We-lkp@intel.com/
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

This commit defines an architecture-specific `nop()` macro for OpenRISC.
The problem is that the generic `nop()` from `asm-generic/barrier.h`
uses `asm volatile ("nop")`, but OpenRISC's assembler doesn't recognize
the bare `nop` instruction — it needs `l.nop` (the OpenRISC-prefixed
form). This causes a **build failure** when compiling any driver that
calls `nop()` on OpenRISC.

The specific failure was reported by the kernel test robot
(lkp@intel.com) during an allmodconfig build, triggered by
`drivers/watchdog/pic32-wdt.c`.

### Code Change Analysis

The change is a single line addition:

```c
#define nop() asm volatile ("l.nop")
```

This is placed in `arch/openrisc/include/asm/barrier.h` **before** the
`#include <asm-generic/barrier.h>`, so it pre-defines `nop()` and
prevents the generic version from being used (since the generic version
is guarded by `#ifndef nop`).

The change is:
- **1 line of code** added
- **1 file** modified
- **Zero risk** of runtime regression — it simply uses the correct
  instruction mnemonic for the architecture

### Classification

This is a **build fix**. It prevents a compilation error on the OpenRISC
architecture when building modules that use `nop()`. Build fixes are
explicitly listed as acceptable for stable backporting, as they are
critical for users who need to build the kernel.

### Scope and Risk Assessment

- **Scope**: Minimal — one `#define` in one architecture-specific header
- **Risk**: Extremely low. The `l.nop` instruction is the correct
  OpenRISC NOP instruction. This simply teaches the kernel to use the
  right assembly mnemonic.
- **Subsystem**: OpenRISC architecture — niche but has real users
- **Regression potential**: Near zero. This only affects OpenRISC
  builds, and only changes which assembly instruction is emitted for
  `nop()`.

### User Impact

Without this fix, any OpenRISC kernel build that includes a driver using
`nop()` will **fail to compile**. This is a hard build failure, not a
warning. The pic32-wdt watchdog driver is one concrete example, but any
code using the `nop()` macro would be affected.

### Stability Indicators

- Reported by kernel test robot (automated build testing infrastructure)
- Tested with allmodconfig cross-compilation
- Signed off by the OpenRISC maintainer (Stafford Horne)
- The fix follows the exact same pattern used by other architectures

### Stable Kernel Rules Check

1. **Obviously correct and tested**: Yes — uses the standard OpenRISC
   `l.nop` instruction, tested with allmodconfig
2. **Fixes a real bug**: Yes — compilation failure
3. **Important issue**: Yes — build failures prevent kernel compilation
   entirely
4. **Small and contained**: Yes — single line, single file
5. **No new features**: Correct — this is a build fix
6. **Applies cleanly**: Should apply cleanly as this file is very stable

### Dependency Check

No dependencies on other commits. The `barrier.h` file for OpenRISC is
simple and unlikely to have changed significantly between versions.

### Concerns

- OpenRISC is a niche architecture, so the user base is small
- However, the fix is risk-free and prevents a real build failure

### Verdict

This is a textbook build fix: tiny, obviously correct, zero regression
risk, and it prevents a hard compilation failure. Build fixes are
explicitly called out as appropriate stable material.

**YES**

 arch/openrisc/include/asm/barrier.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/openrisc/include/asm/barrier.h b/arch/openrisc/include/asm/barrier.h
index 7538294721bed..8e592c9909023 100644
--- a/arch/openrisc/include/asm/barrier.h
+++ b/arch/openrisc/include/asm/barrier.h
@@ -4,6 +4,8 @@
 
 #define mb() asm volatile ("l.msync" ::: "memory")
 
+#define nop() asm volatile ("l.nop")
+
 #include <asm-generic/barrier.h>
 
 #endif /* __ASM_BARRIER_H */
-- 
2.51.0

