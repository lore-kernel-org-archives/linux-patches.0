Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2757AF50;
	Mon, 31 Aug 2026 13:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184168; cv=none; b=cHBLGl8PiYKRqESA7cYsM767R+sTUM62SsbkkM1KrNPnjTS5FvkRV1Z0h8PocvkhfCRNZjV2ND3WZjY1bFY6yDt3aYlC570nfK+FrA27FtQ08GADoTsVPQSyJkU7Z7un6H+wtQnvVUV2zXwtPgIlNGw15NUtiLokZMbjtDCUBCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184168; c=relaxed/simple;
	bh=OaI6AHdSbNYol0qxXd9g/mrwedOpm1WSxGEQ9WocUPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSG5i5FioMIn+8PreL1/zT8Nb4bKLm/a7yQZ9SHjLQvEB3b5TI+ocddDnn8n0vc0oUD54Cdv9FGDbIxiPv8MVtElAlBEiTz6qIJM0K5Ap0jPuS9oVDw7ZT2I04qr6FYxAJQcju0PkLXr4cqfwKtELC3BIVfYC53l75SCTbD80Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDB0CjZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDB0CjZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE4C1F00A3F;
	Mon, 31 Aug 2026 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184165;
	bh=l5bO7/FV2QTdlgRTU8o2zG/6Csv1poRfJdScgOkwW3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDB0CjZWW6onw4IFy90EprLjf5xFmLLHPkfeVEbEzF2Q3oT71zcjQZtm0wCo0FUR2
	 eKT/36C4fIjv6Hf3fpTx86YFWuys+wpuad8JlPzVxT92mmrKGGJgy5qypxusw7cMZB
	 X7fzo76wn/oUrbNgKuXmwxAONgxfOu24DMaz13Q8qKtuj8tTQfQz0CF9/9fSb+6nAz
	 FKVrKT11mAXV2wlwmBeq/X4/nEHzdO2+iUQcujQkRZzhDOY7XOoxz0QVuHVd6F9Bz5
	 Rj1higvzn1140L6dDYCO+H3VElvvvXWU5UiGKr2NCZs9hRuIb7yVhVGl0kJ7+ZMek9
	 5EupcbkgbbPxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: add first record offset check
Date: Mon, 31 Aug 2026 09:29:18 -0400
Message-ID: <20260831133314.4125787-530-sashal@kernel.org>
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

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit 4073cdf6713b7c170e35bf055354580cc52085d6 ]

check the upper and lower limits of first record offset

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amdgpu: add first record offset check`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `VERSION = 6`,
`PATCHLEVEL = 18`, `SUBLEVEL = 44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amdgpu]` `[add]` — validate `first_rec_offset` bounds
in RAS EEPROM header parsing during init.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Gangliang Xie <ganglxie@amd.com>` — author
- `Reviewed-by: Tao Zhou <tao.zhou1@amd.com>` — AMD reviewer
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` — amdgpu
  maintainer
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, or `Tested-by:`
  tags
- Notable: maintainer sign-off and internal AMD review, but no external
  bug report

### Step 1.3: Body analysis
**Record:**
- **Bug described:** `first_rec_offset` from the RAS EEPROM header is
  not bounds-checked.
- **Symptom/failure mode:** Not spelled out in the message; code
  analysis shows invalid `first_rec_offset` yields an invalid `ras_fri`
  (first record index), breaking circular-buffer read logic.
- **Version info:** None in message.
- **Root cause (from code):** `RAS_OFFSET_TO_INDEX()` does unsigned
  arithmetic; a `first_rec_offset` below `ras_record_offset` wraps to a
  huge index, and values above the record region produce `ras_fri >=
  ras_max_record_count`.

### Step 1.4: Hidden bug fix detection
**Record:** Yes — despite the neutral “add check” wording, this is a
defensive bug fix completing RAS header validation started by
`5df0d6addb7e9` (“Add basic validation for RAS header”). Invalid
`ras_fri` can cause out-of-bounds EEPROM reads and bad arithmetic in
`amdgpu_ras_eeprom_read()`.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c` (+8 lines)
- **Function:** `amdgpu_ras_eeprom_init()`
- **Scope:** Single-file, surgical validation on an error path

### Step 2.2: Code flow change
**Record:**
- **Before:** After validating `ras_num_recs`, code unconditionally sets
  `control->ras_fri = RAS_OFFSET_TO_INDEX(control,
  hdr->first_rec_offset)` and returns success.
- **After:** Rejects headers where `first_rec_offset <
  ras_record_offset` or `ras_fri >= ras_max_record_count`, logging an
  error and returning `-EINVAL`.
- **Path affected:** GPU probe / RAS EEPROM init (error-handling path
  for corrupt EEPROM data).

### Step 2.3: Bug mechanism
**Record:** **Memory safety / logic correctness fix**
- `RAS_OFFSET_TO_INDEX` is `((offset - ras_record_offset) / 24)` using
  unsigned math.
- Corrupt `first_rec_offset` below `ras_record_offset` (e.g. `0` when
  minimum is `20`) wraps to a huge `ras_fri`.
- `ras_fri` drives circular-buffer indexing in
  `amdgpu_ras_eeprom_read()`; with invalid `ras_fri`, `g0`/`g1`
  arithmetic can produce read counts far larger than the allocated
  buffer (e.g. buffer sized for `ras_num_recs` but
  `__amdgpu_ras_eeprom_read()` asked to read underflow-derived huge
  counts).
- No validation existed for this field; only `ras_num_recs` was checked
  (since `5df0d6addb7e9`).

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct — mirrors existing header validation
  style.
- **Minimal:** 8 lines, no API changes.
- **Regression risk:** Very low; only rejects already-invalid headers.
  On failure, `amdgpu_ras_init_badpage_info()` already sets
  `is_eeprom_valid = false` and skips EEPROM loading.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `ras_fri` assignment and `ras_num_recs` check introduced together in
  `5df0d6addb7e9` (Lijo Lazar, 2025-03-26) — “Add basic validation for
  RAS header”.
- That commit validated record count but not `first_rec_offset`.
- Bug present since `5df0d6addb7e9` in this tree; `ras_fri` usage is
  much older.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Natural follow-up to `5df0d6addb7e9`,
which is already in this tree.

### Step 3.3: Related file history
**Record:**
- `5df0d6addb7e9` — basic RAS header validation (in tree)
- `660261df61fb7` — checksum validation on unload (in tree)
- `89232d0db3ca9` — return on checksum error (in tree)
- `4073cdf6713b7` — this fix (on `master`, **not** in `6.18.y`)
- `c83e4a45ff9a0` — `tbl_size` validation (on `master`, not in tree;
  separate issue)
- Standalone one-commit fix, not part of a multi-patch series.

### Step 3.4: Author context
**Record:** Gangliang Xie is an active amdgpu contributor (RAS EEPROM
work: checksum checks, bad-page loading, threshold handling). Alex
Deucher is amdgpu maintainer.

### Step 3.5: Dependencies
**Record:**
- Depends on `amdgpu_ras_eeprom_init()` and fields from `5df0d6addb7e9`
  — all present in `6.18.y`.
- `git apply --check` on `4073cdf6713b7` succeeds cleanly against
  current tree.
- Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 4073cdf6713b7` returned no match. Lore search
blocked (Anubis bot protection). Commit is on `master` as
`4073cdf6713b7` (committed 2026-05-19).

### Step 4.2: Reviewers
**Record:** `b4 dig -w` also failed. From commit metadata: Reviewed-by
Tao Zhou (AMD), Signed-off-by Alex Deucher (maintainer).

### Step 4.3: Bug reports
**Record:** No `Reported-by:` or `Link:` tags. No syzbot/fuzzer report.
Bug inferred from code path and prior validation commit rationale
(“corrupted EEPROM header”).

### Step 4.4: Related patches
**Record:** Related mainline follow-up `c83e4a45ff9a0` (tbl_size guard)
is separate; not required for this patch.

### Step 4.5: Stable list discussion
**Record:** Could not search lore stable list (bot protection). No
evidence found that this was explicitly rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `amdgpu_ras_eeprom_init()` (modified); downstream consumers
of `ras_fri`: `amdgpu_ras_eeprom_read()`, `__amdgpu_ras_eeprom_read()`,
EEPROM write paths.

### Step 5.2: Callers
**Record:**
- `amdgpu_ras_eeprom_init()` ← `amdgpu_ras_init_badpage_info()` ←
  `amdgpu_ras_recovery_init()` / `amdgpu_xgmi.c`
- Called during GPU probe/RAS init on AMD hardware with RAS EEPROM
  support (not VF, not SR-IOV guest).

### Step 5.3: Callees
**Record:** `amdgpu_eeprom_read()`, `__decode_table_header_from_buf()`,
`RAS_OFFSET_TO_INDEX` macro.

### Step 5.4: Reachability
**Record:**
- Triggered at boot/probe when reading physical GPU EEPROM over I2C.
- Not directly userspace-triggerable, but affects every boot on affected
  AMD GPUs with corrupted EEPROM.
- Corruption can arise from hardware wear, firmware bugs, or prior bad
  writes.

### Step 5.5: Similar patterns
**Record:** Same validation pattern as `ras_num_recs >
ras_max_record_count` check added in `5df0d6addb7e9`. Part of a series
of RAS EEPROM hardening commits already present in `6.18.y`.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code in tree?
**Record:** **Yes.** At line 1441 in `amdgpu_ras_eeprom.c`, `ras_fri` is
set without bounds checking. Fix commit `4073cdf6713b7` is not an
ancestor of HEAD (`git merge-base --is-ancestor` exit 1). Gap introduced
when `5df0d6addb7e9` landed in this tree (2025-03).

### Step 6.2: Backport complications
**Record:** Clean apply confirmed (`git apply --check` passes). No
conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** Prior validation (`5df0d6addb7e9`, `660261df61fb7`,
`89232d0db3ca9`) is in tree, but not this `first_rec_offset` check. No
duplicate fix found (`git log --grep="first record offset" HEAD` empty).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/amd/amdgpu` — **IMPORTANT** (AMD GPU
driver, RAS reliability/memory-error tracking). Not core-kernel-wide,
but affects production AMD GPU deployments (datacenter, workstation).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; multiple RAS EEPROM validation commits
in 2025–2026 in this file.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** AMD GPUs with RAS EEPROM support and corrupted/invalid
`first_rec_offset` in EEPROM header. Config/driver-specific, not
universal.

### Step 8.2: Trigger conditions
**Record:** Corrupt EEPROM header on boot/RAS init. Uncommon but
realistic (EEPROM corruption is exactly why `5df0d6addb7e9` was added).
Not userspace-exploitable in the usual sense.

### Step 8.3: Failure mode severity
**Record:** Invalid `ras_fri` breaks circular-buffer arithmetic in
`amdgpu_ras_eeprom_read()`:
- Unsigned underflow when `ras_fri > ras_max_record_count` → `g0 =
  ras_max_record_count - ras_fri` wraps to a huge value
- `__amdgpu_ras_eeprom_read()` may attempt reads far exceeding the
  `kcalloc(num, ...)` buffer
- **Severity: HIGH** — potential buffer overrun, I2C read errors, driver
  malfunction; graceful `-EINVAL` path exists with the fix

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected hardware — prevents invalid EEPROM
  parsing and dangerous downstream reads
- **Risk:** VERY LOW — 8-line bounds check, same style as existing
  validation
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real gap in RAS EEPROM header validation left by `5df0d6addb7e9`
- Invalid `ras_fri` can cause dangerous read arithmetic / buffer sizing
  mismatch
- Small, surgical, maintainer-reviewed
- Applies cleanly to `6.18.y`
- Prerequisites already in tree
- Consistent with other RAS EEPROM hardening already backported to this
  tree

**AGAINST backport:**
- Commit message lacks explicit crash/reproducer description
- Requires corrupted EEPROM (hardware-specific edge case)
- No syzbot or user bug report

**Unresolved:** Lore discussion and stable-list nomination could not be
verified (b4/lore unavailable).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — straightforward bounds
   check; AMD-reviewed, maintainer-acked (no runtime test cited).
2. Fixes a real bug? **PASS** — unvalidated `first_rec_offset` yields
   invalid `ras_fri`.
3. Important issue? **PASS** — HIGH severity: potential buffer overrun /
   driver malfunction on corrupt EEPROM.
4. Small and contained? **PASS** — 8 lines, one function.
5. No new features/APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — clean apply, prerequisites
   present.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
This completes RAS EEPROM header validation already started in this
`6.18.y` tree. Without it, a corrupt `first_rec_offset` can slip past
existing checks and produce an invalid `ras_fri`, leading to broken
circular-buffer read logic and potential memory safety issues during
bad-page loading. The fix is minimal, obviously correct, low-risk, and
directly addresses a real failure mode on AMD RAS-capable hardware.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and `git show 4073cdf6713b7`
- **[Phase 2]** Read `amdgpu_ras_eeprom_init()` at lines 1373–1444;
  analyzed `RAS_OFFSET_TO_INDEX` macro (lines 135–136) and
  `amdgpu_ras_eeprom_read()` (lines 962–1028)
- **[Phase 2]** Traced buffer overflow scenario: invalid `ras_fri` → bad
  `g0`/`g1` in `amdgpu_ras_eeprom_read()`
- **[Phase 3]** `git blame -L 1434,1444`: `5df0d6addb7e9` introduced
  unchecked `ras_fri` assignment
- **[Phase 3]** `git show 5df0d6addb7e9`: prior validation commit
  rationale (corrupt EEPROM → huge allocation)
- **[Phase 3]** `git merge-base --is-ancestor 4073cdf6713b7 HEAD` → exit
  1 (fix not in tree)
- **[Phase 3]** `git merge-base --is-ancestor 5df0d6addb7e9 HEAD` → in
  tree; `660261df61fb7` → in tree
- **[Phase 3]** `git apply --check` on `4073cdf6713b7` → applies cleanly
- **[Phase 4]** `b4 dig -c 4073cdf6713b7` → no result (exit 1)
- **[Phase 4]** Lore.kernel.org fetch → blocked by Anubis
- **[Phase 5]** `grep amdgpu_ras_eeprom_init`: callers in
  `amdgpu_ras.c:3590`, `amdgpu_xgmi.c:1674`
- **[Phase 5]** `amdgpu_ras_init_badpage_info()` sets `is_eeprom_valid =
  !ret` on init failure (line 3591)
- **[Phase 6]** `git describe HEAD` → `v6.18.44`; tree is
  `stable/linux-6.18.y`
- **[Phase 6]** Buggy code confirmed at line 1441 without bounds check
- **[Phase 6]** `git log --grep="first record offset" HEAD` → empty (fix
  absent)
- **[Phase 8]** Constants verified: `RAS_TABLE_HEADER_SIZE=20`,
  `RAS_RECORD_START=20`, `RAS_TABLE_RECORD_SIZE=24`,
  `RAS_MAX_RECORD_COUNT≈10922`

---

**YES**The background check on `stable/linux-6.18.y` confirmed:

- **Related validation is present:** `5df0d6addb7e9` ("Add basic
  validation for RAS header") is in the tree.
- **This fix is not:** no commit matching "first record offset" was
  found on the stable branch.

That matches the earlier analysis: the gap remains in `6.18.y`, the
patch applies cleanly, and the backport recommendation stands at
**YES**.

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index dafa46a9656ca..652aa085b6263 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -1439,6 +1439,14 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control)
 	}
 
 	control->ras_fri = RAS_OFFSET_TO_INDEX(control, hdr->first_rec_offset);
+	if (hdr->first_rec_offset < control->ras_record_offset ||
+	    control->ras_fri >= control->ras_max_record_count) {
+		dev_err(adev->dev,
+			"RAS header invalid, ras_fri: %u, first_rec_offset:0x%x",
+			control->ras_fri, hdr->first_rec_offset);
+		return -EINVAL;
+	}
+
 	control->ras_num_mca_recs = 0;
 	control->ras_num_pa_recs = 0;
 	return 0;
-- 
2.53.0

