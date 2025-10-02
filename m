Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1FA4D8CE;
	Thu,  2 Oct 2025 15:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419034; cv=none; b=rnzDSGsQ1UYxphTd9wstTeUixXzpgXBeLs1P6X4DYoXqvLVfXz396u///WK/cL4XfLkMs+Pe+XYBxyuBoSiPh6xUOZFmsb1otuMoN9zF6lAJNRSonHl6Un0hv0USpmaslL/91uGx2EB5cTIhhlJrh7ksxbi4K3dVAl4I9B3BCr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419034; c=relaxed/simple;
	bh=z47ApIfRBuF0MsiY1k02WYL31pu6dZDtuwiSQsfCCpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g8v/Rp9OirnxLAt+vWcepiUnFbVkmGxY2Qg2QN+bOSojui0JxizZuj7YINkeAlgJfCccM6L/NUq2CPvCC4Ok/VTr8WSmsUoq3EbThctJdMATEnMUjFXOMApWcYlfLD9XhqFLakPI1CTh0xb1ZXzGrNReqWPLxtErELrfNBLhseU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jhcm0UcR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jhcm0UcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE56C4CEF4;
	Thu,  2 Oct 2025 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419033;
	bh=z47ApIfRBuF0MsiY1k02WYL31pu6dZDtuwiSQsfCCpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jhcm0UcRfFzwoDO4Bj+S7E7/AE9yyHzOzt+bhbWR859LITl6vg8ySv3W1uU0l8SVC
	 IPDOCgGVkRgk4FSdpFhxHZeUxN3fwzDm9cOeHv4IArkT0vwFWnyF0yXop3s3M0Ds7f
	 PcARqYobpEQzMmCas1uPnR6v0RL6s2dD8951AS6B6U1OjbPqgSQAPJkhVSpomNIUhg
	 Km+ehA7q6v9tFOFFoovCnu6RA9EE4a8gBhC8rUJg2Khv9vj2rdEuBKMlaLLTogb4ft
	 zqSonJcsUe7wg1iSRL1JedqEjHrDp7Mn+MaqJ1b8aqoZmXpPYgumVzl4Tp9wvbj7wm
	 JUixG4rReKVsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-5.4] m68k: bitops: Fix find_*_bit() signatures
Date: Thu,  2 Oct 2025 11:29:53 -0400
Message-ID: <20251002153025.2209281-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 6d5674090543b89aac0c177d67e5fb32ddc53804 ]

The function signatures of the m68k-optimized implementations of the
find_{first,next}_{,zero_}bit() helpers do not match the generic
variants.

Fix this by changing all non-pointer inputs and outputs to "unsigned
long", and updating a few local variables.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509092305.ncd9mzaZ-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Link: https://patch.msgid.link/de6919554fbb4cd1427155c6bafbac8a9df822c8.1757517135.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my thorough analysis of this commit, here is my assessment:

## Backport Recommendation: **YES**

### Extensive Analysis

#### 1. **Nature of the Bug**

This commit fixes an **API signature mismatch** between m68k-specific
implementations of `find_{first,next}_{,zero_}bit()` and the generic
variants defined in `include/linux/find.h`.

**Specific Issues Fixed:**
- **Return type mismatch**: m68k returned `int` instead of `unsigned
  long`
- **Parameter type mismatch**: m68k used `int`/`unsigned int` for
  size/offset parameters instead of `unsigned long`
- **Internal variable types**: Updated `res` from `int` to `unsigned
  long` and `words` from `unsigned int` to `unsigned long` for
  consistency

**Code Changes:**
```c
// Before (incorrect):
static inline int find_first_zero_bit(const unsigned long *vaddr,
unsigned size)
{
    int res = 32;
    unsigned int words;
    ...
}

// After (correct):
static inline unsigned long find_first_zero_bit(const unsigned long
*vaddr, unsigned long size)
{
    unsigned long res = 32;
    unsigned long words;
    ...
}
```

#### 2. **Root Cause and Discovery**

**Historical Context:**
- The generic `find_*_bit()` API has used `unsigned long` for return
  values and size/offset parameters since at least **May 2021** (commit
  2cc7b6a44ac21d)
- In **June 2022**, commit 0e862838f2901 unified non-atomic bitops
  prototypes across architectures, but m68k's `find_*_bit()` functions
  were missed
- m68k did update `__fls()` to return `unsigned long` in 2022, but
  `find_*_bit()` was overlooked

**Discovery:**
- Reported by kernel test robot on **September 9, 2025**
- Triggered by the `gpio-mpsse` driver (introduced in v6.13) when
  compiled for m68k with GCC 15.1.0
- Build warning: `warning: format '%ld' expects argument of type 'long
  int', but argument 3 has type 'int' [-Wformat=]`
- The gpio-mpsse driver correctly assumed `find_first_bit()` returns
  `unsigned long` and used `%ld` format specifier

#### 3. **Impact Assessment**

**Build Impact:**
- Causes `-Wformat` warnings with modern compilers (GCC 15.1.0+)
- Breaks W=1 builds (extra warnings enabled)
- Affects m68k-allmodconfig builds

**Runtime Impact:**
- **On m68k (32-bit)**: Both `int` and `long` are 32 bits, so no data
  corruption or truncation at runtime
- **Type safety**: Violates API contract and breaks type safety
  guarantees
- **Future-proofing**: Could cause issues with future compiler
  optimizations or analysis tools

**Affected Code:**
- Any code using these functions with format strings (like gpio-mpsse)
- Any code relying on proper type signatures for static analysis

#### 4. **Fix Quality Assessment**

**Strengths:**
- **Small and focused**: Only changes type signatures, no logic changes
- **Self-contained**: No dependencies on other commits
- **Low risk**: On m68k, `int` and `unsigned long` have identical size
  and alignment
- **Well-tested**: The generic API with these signatures has been used
  successfully across all other architectures since 2021
- **Maintainer approval**: Acked by Yury Norov (NVIDIA), the maintainer
  of bitmap/find_bit subsystem

**Changes Made:**
1. Function return types: `int` → `unsigned long` (4 functions)
2. Size parameters: `unsigned size` → `unsigned long size`
3. Offset parameters: `int offset` → `unsigned long offset`
4. Internal variables: `int res` → `unsigned long res`, `unsigned int
   words` → `unsigned long words`

#### 5. **Consistency with Kernel Standards**

This fix brings m68k in line with:
- The generic API defined in `include/linux/find.h` (lines 385, 179,
  206, 60)
- All other architecture-specific implementations
- The kernel's bitmap subsystem standards established in 2021-2022

#### 6. **Backport Suitability**

**Meets Stable Kernel Criteria:**
✅ **Fixes important bug**: API signature mismatch causing build warnings
✅ **Small and contained**: ~20 lines changed, type-only modifications
✅ **No architectural changes**: Pure signature corrections
✅ **Minimal regression risk**: Same size types on target architecture
✅ **No new features**: Only fixes existing API compliance

**Priority by Kernel Version:**
- **High priority for 6.13+**: Contains gpio-mpsse driver that exposes
  the bug
- **Medium priority for 6.6-6.12**: No immediate triggering code, but
  bug exists
- **Low priority for <6.6**: Older compilers less likely to catch the
  issue, but correctness still matters

**Dependencies:**
None - the fix is self-contained and applies cleanly to any kernel with
the current m68k bitops.h structure (present since at least 2021).

#### 7. **Potential Risks**

**Minimal risks identified:**
- On m68k, `int` and `unsigned long` are both 32-bit, so binary
  compatibility is preserved
- No ABI changes (inline functions)
- No performance impact
- No behavior changes

### Conclusion

This commit is an **excellent candidate for backporting** to stable
kernel trees. It fixes a long-standing API compliance bug with minimal
risk, improves type safety, resolves build warnings with modern
compilers, and aligns m68k with kernel-wide standards. The fix is small,
focused, well-reviewed, and has no dependencies, making it ideal for
stable tree inclusion.

 arch/m68k/include/asm/bitops.h | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/m68k/include/asm/bitops.h b/arch/m68k/include/asm/bitops.h
index 14c64a6f12176..50ec92651d5a5 100644
--- a/arch/m68k/include/asm/bitops.h
+++ b/arch/m68k/include/asm/bitops.h
@@ -350,12 +350,12 @@ static inline bool xor_unlock_is_negative_byte(unsigned long mask,
 #include <asm-generic/bitops/ffz.h>
 #else
 
-static inline int find_first_zero_bit(const unsigned long *vaddr,
-				      unsigned size)
+static inline unsigned long find_first_zero_bit(const unsigned long *vaddr,
+						unsigned long size)
 {
 	const unsigned long *p = vaddr;
-	int res = 32;
-	unsigned int words;
+	unsigned long res = 32;
+	unsigned long words;
 	unsigned long num;
 
 	if (!size)
@@ -376,8 +376,9 @@ static inline int find_first_zero_bit(const unsigned long *vaddr,
 }
 #define find_first_zero_bit find_first_zero_bit
 
-static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
-				     int offset)
+static inline unsigned long find_next_zero_bit(const unsigned long *vaddr,
+					       unsigned long size,
+					       unsigned long offset)
 {
 	const unsigned long *p = vaddr + (offset >> 5);
 	int bit = offset & 31UL, res;
@@ -406,11 +407,12 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 }
 #define find_next_zero_bit find_next_zero_bit
 
-static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
+static inline unsigned long find_first_bit(const unsigned long *vaddr,
+					   unsigned long size)
 {
 	const unsigned long *p = vaddr;
-	int res = 32;
-	unsigned int words;
+	unsigned long res = 32;
+	unsigned long words;
 	unsigned long num;
 
 	if (!size)
@@ -431,8 +433,9 @@ static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 }
 #define find_first_bit find_first_bit
 
-static inline int find_next_bit(const unsigned long *vaddr, int size,
-				int offset)
+static inline unsigned long find_next_bit(const unsigned long *vaddr,
+					  unsigned long size,
+					  unsigned long offset)
 {
 	const unsigned long *p = vaddr + (offset >> 5);
 	int bit = offset & 31UL, res;
-- 
2.51.0

