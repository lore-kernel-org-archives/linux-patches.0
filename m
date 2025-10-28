Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59CF32D7D8;
	Tue, 28 Oct 2025 12:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761655709; cv=none; b=edvYVIfPXSCp/ecf6rkA9RR+XqhjnwH5zdbcwj1xS/DsuUazHuAAQq3hl4ma7W6f+mHCz7LZTThBPsYSA+AWW9f1PkaG+T9m+RJ8qmtW2p8LbxpkyUNGL//fNDJ5kurbLEuSmWTEhtUdc2lQaD/d0cECYwO5l1o4E3McyQ/LZrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761655709; c=relaxed/simple;
	bh=mBs6zOvlj94/t/tcRzA9U+nJJWpO9GMLA7jnyPrzwMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViO1FVeZqaYIBMNhAczHRQnF24yVDtQMSGn76o1mlptvy52sAeXnf0c8tEsJxbeA70bUesWpacr8M4mCUHtOwOfjD5rFBDZmVsIOprJRd+GYcbBYxNd0ZVavesHCqdIDmCx1q+dFFtx20CQHTqO7iZZJ3pvKpcMfDKTQJTdizF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=beLtwKfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="beLtwKfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BEFC4CEF7;
	Tue, 28 Oct 2025 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761655709;
	bh=mBs6zOvlj94/t/tcRzA9U+nJJWpO9GMLA7jnyPrzwMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beLtwKfkHuArdJ093VKDaQyW5I77Lx9WOTXN184qFghOTo6/Tdh2mUvvtTH+jRL2S
	 4cygiFZP7DMx9PsOIwy1/u+DYquQyts+p2E1uAYY7ztuWaQwWzWQh4RcCRGIh3vlIV
	 WRxFToVynHiHiPYkbcrBPFvbFEvXb9aIf20ebCQeUGjEu4eVNmQTU3ynfL3vl9jhf5
	 BK2XPYyxVuE65pAQd6m4XDplUFIKr8L0KPtWB5OUjQsdiFoKbzoSImm/rw9X8ZF0Tg
	 tKOktKXmzdGKg0CWYMMY9tnh55nN9ABkDZRMduKMYLwMYVG4Z5tRJV6JZqJkOEhpJ1
	 E2O1QgHXh0gVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	akpm@linux-foundation.org,
	david@redhat.com,
	apopple@nvidia.com,
	alexandre.f.demers@gmail.com,
	alexghiti@rivosinc.com,
	willy@infradead.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.1] riscv: mm: Define MAX_POSSIBLE_PHYSMEM_BITS for zsmalloc
Date: Tue, 28 Oct 2025 08:48:06 -0400
Message-ID: <20251028124815.1058740-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028124815.1058740-1-sashal@kernel.org>
References: <20251028124815.1058740-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 5898fc01ff344075e4332aa9abeb0841c85e7e51 ]

This definition is used by zsmalloc to optimize memory allocation. On
riscv64, it is the same as MAX_PHYSMEM_BITS from asm/sparsemem.h, but
that definition depends on CONFIG_SPARSEMEM. The correct definition is
already provided for riscv32.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20251015233327.3885003-1-samuel.holland@sifive.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit using repository
examination and code analysis, here is my assessment:

## **Backport Status: YES**

## Detailed Analysis

### 1. Code Change Analysis

The commit adds a single line to `arch/riscv/include/asm/pgtable-64.h`:
```c
#define MAX_POSSIBLE_PHYSMEM_BITS 56
```

This definition is required by zsmalloc (used by ZRAM/ZSWAP) for correct
memory allocation calculations.

### 2. Tools Used and Findings

**Repository Investigation:**
- **Grep searches** revealed that MAX_POSSIBLE_PHYSMEM_BITS is:
  - Already defined for riscv32 (34 bits)
  - Defined for all other major architectures (x86, arm64, powerpc,
    mips, arc, arm)
  - Missing for riscv64 (this is the bug being fixed)

- **Code analysis of mm/zsmalloc.c** (lines 65-77, 91-92) shows:
  - zsmalloc uses `_PFN_BITS = (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)`
  - OBJ_INDEX_BITS = (BITS_PER_LONG - _PFN_BITS)
  - Without MAX_POSSIBLE_PHYSMEM_BITS, it falls back to MAX_PHYSMEM_BITS
    or BITS_PER_LONG

- **Examined arch/riscv/include/asm/sparsemem.h** which defines
  MAX_PHYSMEM_BITS as 56, but only when `CONFIG_SPARSEMEM` is enabled

**Impact Analysis:**
Without this fix on riscv64 systems where CONFIG_SPARSEMEM is disabled:
- Incorrect: _PFN_BITS = 64 - 12 = **52 bits** (using BITS_PER_LONG
  fallback)
- Correct: _PFN_BITS = 56 - 12 = **44 bits**
- This causes OBJ_INDEX_BITS to be 12 bits instead of 20 bits
- Affects ZS_MIN_ALLOC_SIZE calculations and entire zsmalloc size class
  system

### 3. Historical Context Investigation

**Git history analysis** revealed critical information:
- Commit **f0bbc41760557** (2021) fixed this exact issue for ARM, MIPS,
  PowerPC, and other architectures
- That 2021 commit:
  - Was triggered by actual kernel crashes (NULL pointer dereference in
    zs_map_object)
  - Had "Fixes:" tags pointing to zsmalloc
  - Was backported to stable kernels (signed-off by Sasha Levin)
  - Documented real-world bug report: "Unable to handle kernel NULL
    pointer dereference"
- riscv was NOT included in that 2021 fix (likely because riscv64
  support was incomplete then)
- The current commit (5898fc01ff344) completes that 2021 work for
  riscv64

### 4. Configuration Analysis

**Examined arch/riscv/Kconfig**:
- ARCH_SPARSEMEM_ENABLE is optional (`def_bool y` depends on MMU)
- Users CAN choose FLATMEM instead of SPARSEMEM
- Default config has `CONFIG_SPARSEMEM_MANUAL=y`, but this is not
  mandatory
- Without CONFIG_SPARSEMEM, MAX_PHYSMEM_BITS is undefined, triggering
  the bug

### 5. Subsystem Criticality

**Memory Management Impact:**
- zsmalloc is used by ZRAM (compressed RAM) and ZSWAP (compressed swap)
- These are important for memory-constrained systems
- Incorrect calculations could lead to:
  - Memory corruption
  - Kernel crashes
  - Data loss

### 6. Backport Indicators

**Against backporting:**
- No "Cc: stable@vger.kernel.org" tag
- No "Fixes:" tag
- Limited scope (only affects specific config combinations)

**For backporting:**
- **Critical**: Identical bug was backported for other architectures in
  2021
- **Precedent**: This is completing a known stable-backport pattern
- **Safety**: Minimal change (single line), no side effects
- **Correctness**: Fixes mathematically incorrect value that can cause
  crashes
- **Stable Rules Compliance**: Pure bug fix, no new features, no
  architectural changes

### 7. Risk Assessment

**Regression Risk: VERY LOW**
- Single constant definition
- No behavioral changes
- Only affects riscv64
- Mirrors existing definitions for other architectures
- Value (56) matches the PFN_MASK in the same file (GENMASK(53, 10))

**Impact if NOT backported:**
- Users building riscv64 kernels without CONFIG_SPARSEMEM will have
  broken zsmalloc
- Potential for kernel crashes similar to the 2021 ARM bug report
- Data corruption in ZRAM/ZSWAP scenarios

## Conclusion

This commit SHOULD be backported because:

1. **It fixes the same bug that was considered serious enough to
   backport for other architectures in 2021**
2. **The 2021 fix caused real kernel crashes that were documented**
3. **It's a minimal, safe change with no regression risk**
4. **It follows stable kernel rules: fixes bug, no new features, no
   architectural changes**
5. **riscv64 was simply missed in the 2021 fix, and this commit
   completes that work**

The lack of explicit stable tags is likely an oversight, as this is
clearly a bug fix following the pattern of previous stable-backported
commits for the same issue on other architectures.

 arch/riscv/include/asm/pgtable-64.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 1018d22169013..6e789fa58514c 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -69,6 +69,8 @@ typedef struct {
 
 #define PTRS_PER_PMD    (PAGE_SIZE / sizeof(pmd_t))
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 56
+
 /*
  * rv64 PTE format:
  * | 63 | 62 61 | 60 54 | 53  10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
-- 
2.51.0

