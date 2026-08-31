Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF7E42DA20;
	Mon, 31 Aug 2026 13:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183210; cv=none; b=qFto6HJjS4+bbGa1af61Z30whLUnUdcI81vD6B1ixyCtT1p8Yh+1/tt5+PkAkCGb6ygFcBjj8Zm2NZR0JXSEIjpYoBy9r2f1GCsIz9Gh57IXqi/orbEX+HXWWcIFjdXTa6+NFJuHe5mXHy+6+gPWygfhKcxK0DDZV4yRYjl6ado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183210; c=relaxed/simple;
	bh=Cpdq/hdLgHOnK2/2Df8uliquYDhINglA8BG+lAA2qb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QbGcsfuEkPqTsA1zHadI2BHV4KS+gCyZx0YXgHl5PGX6mKh0x25fvOk/4mKxupsTr8rcWoj6JxnghKXd2oTfIecvlbyBM6CM5AtiOT4ZKKDYTru3aijizzmurzb8eZyo8AAesm7Iw1jFyH2QZ3Mbyjk7+zDEYNJQRGDsXoe67bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R//+bULy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R//+bULy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E701F000E9;
	Mon, 31 Aug 2026 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183209;
	bh=dsJxYGfTejdNN0K+N2I9dd0MGqetmjFk7kICNZ32h50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R//+bULyW7jwqzY0pCOZGK0mLliQnsISYggrICGt2tIquF4f4DM9KvSng3r5AMOMy
	 3hKzYPBEEJMqU2mNibqQ7OsJr86kRenWhmTf9keMhuCdq2VHXe+hmJHAjbrj9zQjCC
	 0OZbNCiySroQkZS9gbnrmzYQWLMdO8sTe13BNqJLyfZ2zznqvypwhEC7WViQGRcNvW
	 s6UqkOtuOoAhW19X8sh1SSH1I/WP6qSnaiCF20soGcCJVWw25k9VCgyu3S/Y3RkTB4
	 Z2Wddl2lmjgT81a5CpQu809nKyLnoRiD+g+c2zCDi3196BM0qliN+OEzYWtaXKU4Ld
	 01d2mhacYsJOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yu Peng <pengyu@kylinos.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] arm64: fixmap: Allow 256K early_ioremap() at any offset
Date: Mon, 31 Aug 2026 09:20:37 -0400
Message-ID: <20260831133314.4125787-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Peng <pengyu@kylinos.cn>

[ Upstream commit 21fc7ec93f8b633b60d5bddef2f1529ff6b36185 ]

NR_FIX_BTMAPS is the per-slot page limit for early_ioremap(). Since
__early_ioremap() maps the page-aligned physical range, a 256K request
can require one extra page when the physical address is not page-aligned.

Reserve one extra page per slot so the 256K mapping budget is usable
regardless of the initial page offset.

Link: https://lore.kernel.org/r/08fd96fa-ee3a-4904-bd11-bb08bd90436f@kylinos.cn
Signed-off-by: Yu Peng <pengyu@kylinos.cn>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `arm64: fixmap: Allow 256K early_ioremap()
at any offset`

**Local tree:** `v6.18.44-2-g1b9e1abadee04` (detached from
`stable/linux-6.18.y`, kernel version **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[arm64: fixmap]` `[Allow]` — fix boot-time fixmap slot
sizing so a full 256K `early_ioremap()` works at any physical page
offset.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Link:** `https://lore.kernel.org/r/08fd96fa-
  ee3a-4904-bd11-bb08bd90436f@kylinos.cn`
- **Signed-off-by:** Yu Peng `<pengyu@kylinos.cn>` (author)
- **Signed-off-by:** Will Deacon `<will@kernel.org>` (arm64 maintainer,
  committer on mainline)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Cc:
  stable@
- Notable: maintainer commit/sign-off on mainline (`21fc7ec93f8b6`); no
  syzbot or user bug report

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `NR_FIX_BTMAPS` is the per-slot page budget for
  `early_ioremap()`. `__early_ioremap()` page-aligns the physical range,
  so a 256K request at a non-page-aligned address can require **one
  extra page** (65 pages on 4K kernels).
- **Symptom:** `WARN_ON(nrpages > NR_FIX_BTMAPS)` in `__early_ioremap()`
  → returns `NULL` → early-boot mapping failure.
- **Root cause:** `NR_FIX_BTMAPS` was defined as exactly `SZ_256K /
  PAGE_SIZE` (64 on 4K pages), without room for alignment slop.
- **No** explicit kernel version range in the message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit correctness fix for
fixmap slot sizing, not style cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `arch/arm64/include/asm/fixmap.h` (+5 / -1 lines, ~6 lines
  changed)
- **Scope:** Single-header, surgical change
- **Modified:** `NR_FIX_BTMAPS` macro and comment block in `enum
  fixed_addresses`

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Before:** `NR_FIX_BTMAPS = SZ_256K / PAGE_SIZE` (64 pages @ 4K)
- **After:** `NR_FIX_BTMAPS = (SZ_256K / PAGE_SIZE) + 1` (65 pages @ 4K)
- **Affected path:** `__early_ioremap()` in `mm/early_ioremap.c` — early
  boot only (`WARN_ON(system_state >= SYSTEM_RUNNING)`)

Relevant existing logic:

```131:140:mm/early_ioremap.c
        offset = offset_in_page(phys_addr);
        phys_addr &= PAGE_MASK;
        size = PAGE_ALIGN(last_addr + 1) - phys_addr;
        // ...
        nrpages = size >> PAGE_SHIFT;
        if (WARN_ON(nrpages > NR_FIX_BTMAPS))
                return NULL;
```

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Logic/correctness — off-by-one in fixmap page budget.**
Category: boot-time mapping failure / NULL return from
`early_ioremap()`.

Verified math: for `size = SZ_256K` and any `offset_in_page(phys) != 0`,
`nrpages = 65` while `NR_FIX_BTMAPS = 64` → failure.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Obviously correct:** Yes — standard fix for page-aligned mapping of
  unaligned ranges.
- **Minimal:** Yes — one macro change + comment.
- **Regression risk:** Very low — adds 7 extra fixmap pages total (7
  slots × 1 page). Cherry-pick auto-merges cleanly on this tree.
- **Side effect:** `MAX_MAP_CHUNK` / `MAP_CHUNK_SIZE` grow by one page,
  correctly reflecting usable mapping budget.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Current `NR_FIX_BTMAPS` lines blame to `5d324e5159d9e`
(merge, Nov 2025) in this checkout. Value `SZ_256K / PAGE_SIZE` present
since at least **v5.10** through **v6.18.44** on arm64.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Standalone 1-patch series (v1 only per `b4 dig -a`).
Mainline commit: `21fc7ec93f8b6`. Merged to master after `Linux 6.18.44`
(`1efe5d048a391`). No prerequisite commits.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Yu Peng — not a regular arm64 maintainer; patch
reviewed/applied by Will Deacon (arm64 maintainer).

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** None. Self-contained header change. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- **URL:**
  https://patch.msgid.link/20260708023514.2445926-1-pengyu@kylinos.cn
- **Series:** v1 only (no v2/v3)
- **Will Deacon reply:** "Applied to arm64 (for-next/fixes), thanks!" —
  no NAKs, no stable nomination in thread

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC'd: Catalin Marinas, Will Deacon, Thomas Huth, linux-arm-
kernel, linux-kernel. Applied directly by Will Deacon.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No Reported-by, syzbot, or bugzilla link. Code-
analysis/maintainer-accepted fix.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Single-patch series. RISC-V and powerpc use the same
`SZ_256K / PAGE_SIZE` pattern but are out of scope for this arm64-only
commit.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched separately; no stable discussion found in patch
thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** Macro only — affects `__early_ioremap()`, `early_ioremap()`,
`early_memremap()`, `copy_from_early_mem()` (via `MAX_MAP_CHUNK`), ACPI
`MAP_CHUNK_SIZE`.

### Step 5.2: TRACE CALLERS
**Record:** On arm64, `__acpi_map_table()` → `early_memremap(phys,
size)` maps whole ACPI tables without chunking
(`arch/arm64/kernel/acpi.c`). Also EFI early paths, generic
`copy_from_early_mem()`. All early-boot, pre-`SYSTEM_RUNNING`.

Chunking helpers (`copy_from_early_mem`, `acpi_table_upgrade`) already
limit `clen + slop <= MAP_CHUNK_SIZE` with page-aligned `phys`, so they
stay within 64 pages today. **Direct** `early_memremap(phys, ~256K)` at
misaligned `phys` is the failure path.

### Step 5.3: TRACE CALLEES
**Record:** `__early_ioremap()` → `__early_set_fixmap()` /
`__late_set_fixmap()` per page.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Reachable during kernel boot on ACPI/EFI arm64 systems. Not
a post-boot userspace syscall path, but boot failure is severe.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Identical `SZ_256K / PAGE_SIZE` define in
`arch/riscv/include/asm/fixmap.h` and
`arch/powerpc/include/asm/fixmap.h` — same latent bug, different arch.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Current tree has:
```
#define NR_FIX_BTMAPS           (SZ_256K / PAGE_SIZE)
```
Bug present since at least v5.10 on arm64 (verified across tags
v5.10–v6.18.44). Fix **not** present on this 6.18.44 tree; **is** on
`master`.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply** — tested `git cherry-pick --no-commit
21fc7ec93f8b6`: auto-merged `arch/arm64/include/asm/fixmap.h` with no
conflicts.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No equivalent fix in this tree. `master` has commit
`21fc7ec93f8b6`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **arm64 boot / fixmap / early_ioremap** — **CORE** for arm64
boot; affects all arm64 kernels using early MMIO/ACPI/EFI mappings.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Active; fix landed in arm64-fixes for post-6.18 mainline.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Platform-specific (arm64)** — all arm64 builds;
practically relevant for ACPI/EFI early-boot mapping when a ~256K region
is mapped at a non-page-aligned physical address.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- `early_ioremap()` / `early_memremap()` with `size` near `SZ_256K` and
  `phys % PAGE_SIZE != 0`
- Uncommon but deterministic; firmware-chosen ACPI table placement can
  satisfy this
- Not a post-boot unprivileged syscall trigger

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** `WARN_ON` + `NULL` return from `__early_ioremap()` →
ACPI/EFI early mapping failure → **boot failure or ACPI broken**.
Severity: **HIGH** for affected configs (boot-time), though trigger
frequency is **LOW**.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** MEDIUM-HIGH — restores intended 256K early_ioremap
  budget; prevents deterministic boot failures in edge cases
- **Risk:** VERY LOW — 7 extra fixmap pages, no API change, maintainer-
  applied
- **Ratio:** Favorable for stable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real, deterministic off-by-one bug in fixmap sizing
- Boot-time failure mode (NULL from `early_ioremap`)
- Tiny, obviously correct fix; arm64 maintainer signed off
- In mainline (`21fc7ec93f8b6`); cherry-picks cleanly to 6.18.44
- Bug present in this tree since at least v5.10
- Meets stable size rule (< 100 lines)

**AGAINST backport:**
- No user/syzbot report — edge-case trigger
- Most chunking callers already avoid the failure
- arm64-only (not a concern for this tree-specific verdict)

**UNRESOLVED:** No documented production incident; impact inferred from
code path analysis.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mathematically correct;
   maintainer-applied to mainline (no explicit Tested-by)
2. Fixes a real bug? **PASS** — deterministic `nrpages > NR_FIX_BTMAPS`
   failure
3. Important issue? **PASS** — boot-time mapping failure (HIGH severity,
   lower frequency)
4. Small and contained? **PASS** — 6 lines, one file
5. No new features/APIs? **PASS** — sizing correction only
6. Can apply to local tree? **PASS** — clean cherry-pick verified

### Step 9.3: EXCEPTION CATEGORIES
**Record:** N/A — standard bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: DECISION RATIONALE
For **this 6.18.44 arm64 stable tree**, the buggy `NR_FIX_BTMAPS`
definition exists and the fix is already in mainline. The patch is
minimal, maintainer-backed, and prevents real early-boot
`early_ioremap()` failures when the full 256K mapping budget is used at
a misaligned physical address. Risk is negligible.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.44; parsed commit message tags
- [Phase 2] Read `mm/early_ioremap.c` lines 100–160; confirmed alignment
  → `nrpages` check
- [Phase 2] Python math: offset 1/2048/4095 + 256K → `nrpages=65`,
  `NR_FIX_BTMAPS=64`, `fail=True`
- [Phase 3] `git blame` on fixmap.h; tags v5.10–v6.18.44 all show
  `SZ_256K / PAGE_SIZE`
- [Phase 3] `git show 21fc7ec93f8b6` — mainline commit details
- [Phase 3] `git log 1efe5d048a391..master --grep='256K early_ioremap'`
  — fix after 6.18.44
- [Phase 4] `b4 dig -c 21fc7ec93f8b6` — lore URL found
- [Phase 4] `b4 dig -c 21fc7ec93f8b6 -w` — maintainers CC'd
- [Phase 4] `b4 dig -c 21fc7ec93f8b6 -a` — v1 only
- [Phase 4] `b4 dig -m /tmp/fixmap_thread.mbox` — Will Deacon "Applied"
  reply, no NAKs
- [Phase 5] Grep `early_memremap`/`__acpi_map_table` call paths on arm64
- [Phase 5] Read `arch/arm64/kernel/acpi.c` — direct
  `early_memremap(phys, size)` without chunking
- [Phase 6] `git show HEAD:arch/arm64/include/asm/fixmap.h` — buggy
  macro confirmed
- [Phase 6] `git show master:arch/arm64/include/asm/fixmap.h` — fixed
  macro on master
- [Phase 6] `git cherry-pick --no-commit 21fc7ec93f8b6` — clean auto-
  merge

---

**YES**Those background checks finished and line up with the earlier
analysis:

- **NR_FIX_BTMAPS history** — The `SZ_256K / PAGE_SIZE` definition has
  been in arm64 `fixmap.h` since at least v5.10 through v6.18.44, so the
  off-by-one bug is long-standing in this tree.
- **Branch check** — The fix is on `master` (`21fc7ec93f8b6`); the
  6.18.44 checkout still has the buggy `(SZ_256K / PAGE_SIZE)` define.
- **Release timing** — The fix landed in mainline after the `Linux
  6.18.44` tag, which is why it belongs as a stable backport.

**Verdict for 6.18.y: YES** — small, maintainer-applied fix for a real
early-boot `early_ioremap()` failure when mapping 256K at a misaligned
physical address; cherry-picks cleanly.

 arch/arm64/include/asm/fixmap.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 635a43c4ec85b..9288021ba93b1 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -78,8 +78,12 @@ enum fixed_addresses {
 	/*
 	 * Temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
+	 *
+	 * Reserve one extra page so a 256K mapping may start at any
+	 * offset within a page. early_ioremap() maps the page-aligned
+	 * physical range, so the initial offset can consume an extra page.
 	 */
-#define NR_FIX_BTMAPS		(SZ_256K / PAGE_SIZE)
+#define NR_FIX_BTMAPS		((SZ_256K / PAGE_SIZE) + 1)
 #define FIX_BTMAPS_SLOTS	7
 #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
 
-- 
2.53.0

