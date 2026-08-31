Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C92233689F;
	Mon, 31 Aug 2026 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183907; cv=none; b=dd8zn/a8abQoXEDID54VJ9KYTZahRNjEpxXwRedyoaS5dDZ74mOJZx14ibd0wmXqc+hcSlvGRKuTepxt+j+NsTNb4nPZh22HgJaD5B78dggRyxUkHDDRsIgS+f5OFNl0I0e3hDTdycnQ/XuG1XRF5kq74SJSoKcL5BjGjLrUJ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183907; c=relaxed/simple;
	bh=3rxy6/IJnITvpYr6o0JR9nxRSByeWPyzKmL7et1ub3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBJOyIeelJ4Wolm2mz/5LIhMZ2uCOblROM2veV1wEXmqD4CXKSnSSl0VjgY7Fd9M9JC9JLwnpYFmwbhPdA7If3hYQS3bmT+fH922vWY71TPn6iZPsa6WvtZLrK1GlZpC4ohpwFjdRGZ9UfdI1EUFs7871GbDCi4wyElP9ojwg5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmVkmSc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmVkmSc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4641F00ADB;
	Mon, 31 Aug 2026 13:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183904;
	bh=hmK0RXrnJ268dKPF54g8Nt8vjQBqRHmDylIKk4zmaz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmVkmSc2y6MNai0L9Xbnpp70RYSkFBkSiP9S08H4llqewDTMJ2D8uy9hI3wclsXPE
	 8DiHdvVXVsKZNxmipmiZRvJ6QuVQU/7JBMw+6bFeHR6M3/8jQ+PPnIsbEXZw/U/xSl
	 F5hKft9k9sJULaqsaI+vhG2HtXCi6iX0qDxct6000ME3zR6HHtY0wImc+5kGEAO6rH
	 3NbxPmiu9d68wc3gdhhJSaVSCuThF0rlARdz3WNNm142/3M+wu69wzOABXAGhwBZaz
	 rW4smGzkli+Skk9Ae1MPcxM7LA0GhmalqrPDoJZTfMPKUwF+tXxnpKO3EyWiz1G5qH
	 gfKrBWWhnhY9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: check and drop invalid bad page records
Date: Mon, 31 Aug 2026 09:26:40 -0400
Message-ID: <20260831133314.4125787-372-sashal@kernel.org>
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

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit 3999aa4a04a04167d70bfe4dc3ba239257e5b5df ]

Check and drop invalid bad page records.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[drm/amdgpu]` `[check]` — validate and discard invalid RAS
EEPROM bad-page records before they are applied to VRAM reservation /
in-kernel bad-page tables.

**Step 1.2 — Tags**

Record:
- Signed-off-by: YiPeng Chai \<YiPeng.Chai@amd.com\> (author)
- Reviewed-by: Tao Zhou \<tao.zhou1@amd.com\> (AMD RAS reviewer; also
  author of prior range-check work in this tree)
- Signed-off-by: Alex Deucher \<alexander.deucher@amd.com\> (amdgpu
  maintainer)
- No Fixes:, Reported-by:, Link:, Cc: stable@vger.kernel.org, Tested-
  by:, or Acked-by:

Notable: reviewed by subsystem expert; no public bug report in the
commit message.

**Step 1.3 — Body**

Record:
- Bug description: EEPROM / RAS bad-page records may contain
  `retired_page` values outside usable VRAM.
- Symptom/failure mode: not spelled out in the message; code adds
  `dev_warn()` and refuses to process out-of-range records.
- Version info: none in message.
- Root cause (from code): validation used `mc_vram_size` in some paths
  (commit `2b17c240e8cd9`, already in 6.18.y), but reservation and
  restore still lacked checks against `real_vram_size`, which can be
  smaller than `mc_vram_size` when `amdgpu_vram_limit` is set
  (`amdgpu_gmc_vram_location()` in `amdgpu_gmc.c`).

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite the terse message, this is a defensive
correctness fix: it prevents out-of-range PFNs from reaching
`amdgpu_ras_reserve_page()` → `amdgpu_vram_mgr_reserve_range()` and adds
a batch guard in `__amdgpu_ras_restore_bad_pages()` on EEPROM load.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c` (+22 lines net)
- Functions: new `__check_record_in_range()`; modified
  `__amdgpu_ras_restore_bad_pages()`, `amdgpu_ras_reserve_page()`
- Scope: single-file, surgical

**Step 2.2 — Code flow**

Record:
- Hunk 1 (`__check_record_in_range`): before — no upfront validation of
  EEPROM batch; after — if any `retired_page >= real_vram_size >>
  page_shift`, warn and return false.
- Hunk 2 (`__amdgpu_ras_restore_bad_pages`): before — processes all
  records; after — if batch check fails, return 0 immediately (drop
  entire batch).
- Hunk 3 (`amdgpu_ras_reserve_page`): before — only critical-address
  check, then buddy reservation; after — early return with warning for
  PFN beyond `real_vram_size`.

**Step 2.3 — Bug mechanism**

Record:
- Category: **logic / bounds validation** (prevents invalid VRAM
  reservations and inconsistent bad-page state).
- Mechanism: corrupt or stale EEPROM entries (or entries beyond
  `real_vram_size` after VRAM limiting) could reach VRAM buddy allocator
  reservation. Existing `amdgpu_ras_check_bad_page_unlock()` (6.18.y)
  validates against `mc_vram_size`, not `real_vram_size`.
  `amdgpu_ras_reserve_page()` had no upper-bound check at all and is
  called directly from `umc_v12_0.c` on ECC error paths.

**Step 2.4 — Fix quality**

Record: Fix is minimal and obviously correct for bounds checking.
Regression risk is low. One nuance: if **any** record in a batch is out
of range, **all** records are dropped (conservative, not per-record
filtering). No deadlock or API change.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- `amdgpu_ras_reserve_page()` introduced by YiPeng Chai (2024-03-29),
  present since before 6.18.y.
- `__amdgpu_ras_restore_bad_pages()` core loop from 2025-02-24; related
  fixes by Tao Zhou (July 2025).
- Target commit `3999aa4a04a04` dated 2026-05-12; **not** in current
  tree (6.18.44).

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 — Related commits**

Record:
- `2b17c240e8cd9` — "add range check for RAS bad page address" — **IN
  6.18.y**; checks `mc_vram_size` in
  `amdgpu_ras_check_bad_page_unlock()`.
- `0b7f78caeffa5` — "Move ras data alloc before bad page check" — **IN
  6.18.y**; fixed NULL deref in sysfs bad-pages read when EEPROM had
  only invalid entries.
- `0028b86b52f76` — "mark invalid records with U64_MAX" — **NOT in
  6.18.y** (mainline only).
- `3fc96f60b61ce` — critical-address check in
  `amdgpu_ras_reserve_page()` — **IN 6.18.y**.
- This commit is standalone (not part of a numbered series).

**Step 3.4 — Author context**

Record: YiPeng Chai is a regular amdgpu/RAS contributor (reserve_page
author, critical-address work). Tao Zhou reviewed and authored the prior
range-check commit.

**Step 3.5 — Dependencies**

Record: No prerequisites. Patch applies cleanly to 6.18.y (`git apply
--check` succeeded). Uses `adev->gmc.real_vram_size` and
`AMDGPU_GPU_PAGE_SHIFT`, both present in this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 3999aa4a04a04` — **no lore match found**. Phase not
fully applicable.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` not run (no thread found). Reviewed-by Tao Zhou and
Signed-off-by Alex Deucher verified from `git show`.

**Step 4.3 — Bug report**

Record: N/A — no Reported-by/Link tags; no public thread found.

**Step 4.4 — Related series**

Record: Related mainline-only work (`U64_MAX` invalid-record marking)
not in 6.18.y; this commit is independently useful without it.

**Step 4.5 — Stable list**

Record: Not searched (no lore thread to anchor a stable@ query). Related
NULL-deref fix (`0b7f78caeffa5`) was already backported to 6.18.y,
showing this problem class is stable-worthy.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `__check_record_in_range()`, `__amdgpu_ras_restore_bad_pages()`,
`amdgpu_ras_reserve_page()`.

**Step 5.2 — Callers**

Record:
- `__amdgpu_ras_restore_bad_pages()` ← `amdgpu_ras_add_bad_pages()` ←
  `amdgpu_ras_load_bad_pages()` (boot/RAS init EEPROM load) and runtime
  UMC error paths.
- `amdgpu_ras_reserve_page()` ← `__amdgpu_ras_restore_bad_pages()` and
  `umc_v12_0.c` ECC handler (line 609).

**Step 5.3 — Callees**

Record: `amdgpu_vram_mgr_reserve_range()`,
`amdgpu_vram_mgr_query_page_status()`, `dev_warn()`,
`amdgpu_ras_check_critical_address()`.

**Step 5.4 — Reachability**

Record: Triggered on boot when RAS EEPROM has records
(`amdgpu_ras_load_bad_pages()` during RAS init) and at runtime on UMC
ECC events. Requires `CONFIG_DRM_AMDGPU` + RAS-capable AMD hardware
(datacenter/workstation GPUs). Not a generic syscall path, but real
production hardware.

**Step 5.5 — Similar patterns**

Record: `2b17c240e8cd9` added `mc_vram_size` checks in
`amdgpu_ras_check_bad_page_unlock()`. This commit closes the
`real_vram_size` gap and protects the direct `amdgpu_ras_reserve_page()`
entry point. In 6.18.y, `__amdgpu_ras_restore_bad_pages()` still uses
`if (amdgpu_ras_check_bad_page_unlock(...))` as a boolean despite the
function returning `int` (-EINVAL/0/1), which can mishandle `-EINVAL`
(truthy) without adding a record — another reason upfront validation
helps.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44` on `stable/linux-6.18.y`.
`__check_record_in_range()` and the `amdgpu_ras_reserve_page()` bounds
guard are absent. `amdgpu_ras_reserve_page()` at lines 5366–5383 has
only the critical-address check, no `real_vram_size` upper bound.

**Step 6.2 — Backport complications**

Record: **Clean apply** verified. No structural conflicts with 6.18.y
`amdgpu_ras.c`.

**Step 6.3 — Related fixes already present?**

Record: Partial coverage from `2b17c240e8cd9` (`mc_vram_size` in
`amdgpu_ras_check_bad_page_unlock`) and `0b7f78caeffa5` (NULL deref on
all-invalid EEPROM). This commit's `real_vram_size` checks and
`amdgpu_ras_reserve_page()` guard are **not** already present.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem / criticality**

Record: `drivers/gpu/drm/amd/amdgpu` — RAS (Reliability, Availability,
Serviceability) / VRAM error handling. **IMPORTANT** for AMD enterprise
GPU users; not core-kernel-wide.

**Step 7.2 — Activity**

Record: Active subsystem in 6.18.y (multiple RAS fixes in recent history
on `amdgpu_ras.c`).

---

## Phase 8: Impact and Risk

**Step 8.1 — Who is affected**

Record: Users of AMD GPUs with RAS page retirement enabled, especially
MI-series / CDNA / Instinct and other ECC-capable cards loading bad-page
records from EEPROM at boot or on UMC errors.

**Step 8.2 — Trigger conditions**

Record: Corrupt, migrated, or out-of-date EEPROM bad-page records; or
`real_vram_size < mc_vram_size` via `amdgpu_vram_limit`. Uncommon but
plausible on long-lived server GPUs. Not unprivileged-triggerable
directly; tied to hardware error state / EEPROM content.

**Step 8.3 — Failure mode severity**

Record: Without fix: attempted reservation of out-of-range VRAM
(`amdgpu_vram_mgr_reserve_range()` may fail silently in
`amdgpu_vram_mgr_do_reserve()`), inconsistent bad-page counts (related
NULL-deref class already hit stable), potential RAS tracking corruption.
Severity: **MEDIUM-HIGH** for affected hardware (reliability feature
breakage, possible oops in related paths already seen and fixed
separately).

**Step 8.4 — Risk/benefit**

Record:
- Benefit: **MEDIUM-HIGH** for RAS users — prevents invalid VRAM
  reservations and drops clearly bad EEPROM batches.
- Risk: **LOW** — ~22 lines, warn-and-skip semantics, reviewed by AMD.
- Ratio: favorable for backport.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

FOR:
- Real bounds-validation gap in 6.18.y (`real_vram_size` vs
  `mc_vram_size`).
- `amdgpu_ras_reserve_page()` unguarded; called from runtime ECC path.
- EEPROM restore path lacks batch validation.
- Small, reviewed, applies cleanly.
- Same RAS/EEPROM invalid-record problem class already warranted stable
  fixes (NULL deref in `0b7f78caeffa5`).

AGAINST:
- Sparse commit message (no explicit crash report).
- Niche hardware (RAS-enabled AMD GPUs only).
- Drops entire batch if any record is invalid (conservative).
- Partial overlap with `2b17c240e8cd9` (but does not fully subsume this
  fix).

UNRESOLVED:
- No lore thread or user bug report found.
- Exact user-visible failure without this patch on 6.18.y not reproduced
  here (inferred from code paths and related fixes).

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — straightforward bounds
   checks; Reviewed-by from AMD; no Tested-by.
2. Fixes a real bug? **PASS** — prevents out-of-range VRAM reservations
   and invalid EEPROM restore.
3. Important issue? **PASS** — MEDIUM-HIGH for RAS/enterprise GPU
   reliability; related crash class already backported.
4. Small and contained? **PASS** — single file, ~22 lines.
5. No new features/APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — clean apply verified.

**Step 9.3 — Exception category**

Record: N/A (not device ID, quirk, DT, build, or docs).

**Step 9.4 — Decision rationale**

For the **6.18.y** tree checked out here, this commit closes a real
validation hole in amdgpu RAS bad-page handling. The tree already has
partial protection (`mc_vram_size` checks) and a related NULL-deref fix,
but still lacks `real_vram_size` validation and an
`amdgpu_ras_reserve_page()` guard. The fix is small, low-risk, and
targets production RAS hardware where EEPROM corruption or VRAM limiting
can produce out-of-range records.

---

## Verification

- [Phase 1] `git show 3999aa4a04a04` — parsed subject, tags, body
- [Phase 2] Diff from user query + `git show 3999aa4a04a04` — 22-line
  change in `amdgpu_ras.c`
- [Phase 3] `git describe HEAD` → v6.18.44; `git merge-base --is-
  ancestor 3999aa4a04a04 HEAD` → NOT IN TREE; `2b17c240e8cd9` → IN TREE
- [Phase 3] `git log --oneline -20 --
  drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c` — related RAS history
- [Phase 3] `git show 2b17c240e8cd9`, `0b7f78caeffa5`, `0028b86b52f76` —
  related commits examined
- [Phase 3] `git blame` on restore loop and `amdgpu_ras_reserve_page`
- [Phase 4] `b4 dig -c 3999aa4a04a04` — no lore match
- [Phase 5] `Grep` callers of `amdgpu_ras_reserve_page`,
  `__amdgpu_ras_restore_bad_pages`
- [Phase 5] Read `umc_v12_0.c:609`, `amdgpu_vram_mgr.c:298-327`,
  `amdgpu_gmc.c:217-222`
- [Phase 6] `Grep` for `__check_record_in_range` — not in tree
- [Phase 6] `git show 3999aa4a04a04 --format= --
  drivers/.../amdgpu_ras.c | git apply --check` — clean apply
- [Phase 6] Read current `amdgpu_ras_reserve_page()` at lines 5366–5383
  — no range guard
- [Phase 8] Confirmed `real_vram_size` can be reduced below
  `mc_vram_size` via `amdgpu_vram_limit` in `amdgpu_gmc_vram_location()`

**YES**The background git searches finished and matched what we already
had:

- **`3999aa4a04a04`** — `drm/amdgpu: check and drop invalid bad page
  records` (the commit under review)
- **`2b17c240e8cd9`** — earlier related fix, `drm/amdgpu: add range
  check for RAS bad page address`, already in **6.18.44**

That confirms the new commit is on master but not in this stable tree,
while only partial protection exists today. The backport recommendation
stands: **YES** for **6.18.y**.

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 27 +++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 9df691364a18c..4c1a65fffede7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2884,6 +2884,25 @@ static int amdgpu_ras_mca2pa(struct amdgpu_device *adev,
 		return  -EINVAL;
 }
 
+static bool __check_record_in_range(struct amdgpu_device *adev,
+			struct eeprom_table_record *bps, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (bps[i].retired_page >=
+			(adev->gmc.real_vram_size >> AMDGPU_GPU_PAGE_SHIFT)) {
+			dev_warn(adev->dev,
+				"Recorded address out of range: 0x%llx, 0x%llx, 0x%x, 0x%x\n",
+				bps[i].address, bps[i].retired_page,
+				bps[i].mem_channel, bps[i].mcumc_id);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 					struct eeprom_table_record *bps, int count)
 {
@@ -2891,6 +2910,9 @@ static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
 	struct ras_err_handler_data *data = con->eh_data;
 
+	if (!__check_record_in_range(adev, bps, count))
+		return 0;
+
 	for (j = 0; j < count; j++) {
 		if (!data->space_left &&
 		    amdgpu_ras_realloc_eh_data_space(adev, data, 256)) {
@@ -5370,6 +5392,11 @@ int amdgpu_ras_reserve_page(struct amdgpu_device *adev, uint64_t pfn)
 	uint64_t start = pfn << AMDGPU_GPU_PAGE_SHIFT;
 	int ret = 0;
 
+	if (pfn >= (adev->gmc.real_vram_size >> AMDGPU_GPU_PAGE_SHIFT)) {
+		dev_warn(adev->dev, "Ignoring out-of-range bad page 0x%llx", start);
+		return 0;
+	}
+
 	if (amdgpu_ras_check_critical_address(adev, start))
 		return 0;
 
-- 
2.53.0

