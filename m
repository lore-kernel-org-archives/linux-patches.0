Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA94568FB8;
	Mon, 31 Aug 2026 13:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184111; cv=none; b=V5BmiudA6iFmEWG5QP9AeUbJtGn/o1ShBNxUqQEaEY11abTos0AtbnbbatkP9iDLd2muP6jdtUTyc05gL4r7Nqpyux26lS0c31j442kTmS0L3QpMqyguoZhtSRMzIik3fSH2UquzP+Tkeb+sSQ18u2tUCVQS7ctSB8qLk0tP4FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184111; c=relaxed/simple;
	bh=KPLACwdHpwunMXyFjE/Qch4G9kpD0swfVuQ0q1eHw3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wv2KjZ9W1S+3p/Od1sAgCrf8b/WltvXAU2TGnMhw8oDEbY2APdy3CTzxhK2Fyqw/MOOGGDeHzVLgMZ20hb0ajg2XD3BqwaYDDXoNB5Hio/h7+qOmxSHPBH8e5TuRPiWpoYL9J4/V33R5+c8Q5ZqTc8F96qdX3VOq1d8B+ffbHoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGukKDDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGukKDDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56B71F00A3D;
	Mon, 31 Aug 2026 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184109;
	bh=h2417QFsNsN7jeVp0HIW7Ec11pPQ0l2ZCCKB+5O68ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGukKDDnO4NECwKwtR3IjTZDLbW4Z2ZQsS+h6uFBKK1I7PTvv20auvVWIq0ILCsMx
	 EGdL/eAVAfLYPupFjpaeumTSlCfy76K44458zhyiQ/1dv2AS3X5nwswLzlrBpI0FfV
	 6PEVUtYynOleBJdQiFC24CBKjMcw++XiGBEdX4EdtrCP6XnBSPp9ZeJp6rX4+iBEbE
	 oYTQUyX2E9LBz6AkhkE/zkhy9/sWYMYneTWcPJmMHXYMPEC2/Y+CqYJ/+OhiYHDjla
	 sQfogIWRoEzjVDh4zUx/iAkdH57+kMjv4rw1KFezJOAHklmKlUTc5CU156J1VdCpII
	 HRoSb1RR0Zr6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amd/pm: bound pp_dpm_set_pp_table() memcpy
Date: Mon, 31 Aug 2026 09:28:44 -0400
Message-ID: <20260831133314.4125787-496-sashal@kernel.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit f193e71fa9fab2e68ef85201b106e8f580d3a25b ]

The powerplay path allocates hardcode_pp_table once with kmemdup(...,
soft_pp_table_size). memcpy(..., size) used the sysfs store count (up to
PAGE_SIZE) with no upper bound, causing heap overflow. Reject
writes where size exceeds soft_pp_table_size.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amd/pm: bound pp_dpm_set_pp_table()
memcpy`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `VERSION=6`,
`PATCHLEVEL=18`, `SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amd/pm]` `[bound]` — bounds-check `memcpy` in
`pp_dpm_set_pp_table()` to prevent heap overflow when uploading a
powerplay table via sysfs.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Asad Kamal `<asad.kamal@amd.com>` (author)
- **Reviewed-by:** Yang Wang `<kevinyang.wang@amd.com>` (AMD reviewer)
- **Signed-off-by:** Alex Deucher `<alexander.deucher@amd.com>`
  (subsystem maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`, or `Acked-by:`

Notable: maintainer sign-off and AMD internal review; no syzbot report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `hardcode_pp_table` is allocated once via `kmemdup(...,
  soft_pp_table_size)`, but `memcpy(..., size)` uses the sysfs write
  length (`count`, up to `PAGE_SIZE`) with no upper bound.
- **Symptom:** Heap buffer overflow in kernel memory.
- **Trigger:** Writing more bytes than `soft_pp_table_size` to the
  `pp_table` sysfs attribute on the legacy powerplay DPM path.
- **Root cause:** Mismatch between allocation size and copy size.
- **Version info:** None in commit message.

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite “bound” wording rather than “fix”, this is a
clear memory-safety bug fix (heap overflow / out-of-bounds write), not
cleanup or optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c` (+3 / -0)
- **Function:** `pp_dpm_set_pp_table()`
- **Scope:** Single-file, surgical fix (3 lines)

### Step 2.2: Code flow change
**Record:**
- **Before:** After basic `hwmgr`/`pm_en` validation, code allocates (if
  needed) `hardcode_pp_table` sized to `soft_pp_table_size`, then
  unconditionally `memcpy(hwmgr->hardcode_pp_table, buf, size)`.
- **After:** Rejects writes where `size > hwmgr->soft_pp_table_size`
  with `-EINVAL` before allocation/copy.
- **Path affected:** Sysfs write → `amdgpu_set_pp_table()` →
  `amdgpu_dpm_set_pp_table()` → `pp_dpm_set_pp_table()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds heap write (memory
  safety).
- **Mechanism:** `kmemdup` allocates `soft_pp_table_size` bytes;
  `memcpy` can copy up to `PAGE_SIZE` (4096) bytes from sysfs `count`.
  When `size > soft_pp_table_size`, writes past the kmalloc buffer. On
  subsequent writes, the buffer is not reallocated (only allocated once
  when `!hardcode_pp_table`), so overflow persists.

### Step 2.4: Fix quality
**Record:**
- Fix is obviously correct and minimal.
- Mirrors the intent of the SMU-path fix in commit `1abb2648698bf`
  (“avoid buffer overflow … in `smu_sys_set_pp_table()`”), which added
  size validation and reallocation logic.
- Low regression risk: only rejects invalid oversized writes; legitimate
  writes matching the existing table size continue to work.
- No API or structural changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `pp_dpm_set_pp_table()` introduced in `f3898ea12fc1f` (Eric Huang,
  2015-12-11).
- Unbounded `memcpy` introduced in `4dcf9e6f2e33fe` (Eric Huang,
  2016-06-01): “add uploading pptable and resetting powerplay support”.
- Bug has existed since mid-2016; present in this 6.18.y tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:**
- Related stable-worthy fix already in tree: `1abb2648698bf` (Feb 2025)
  — SMU `smu_sys_set_pp_table()` overflow fix, with `Cc:
  stable@vger.kernel.org`.
- Candidate fix (`bound pp_dpm_set_pp_table`) is **not** in this tree;
  buggy code confirmed at lines 660–676 without the bounds check.
- Standalone one-patch fix, not part of a series.

### Step 3.4: Author context
**Record:** Asad Kamal is an active AMD contributor (`drm/amdgpu`,
`drm/amd/pm`). Patch reviewed by Yang Wang and committed by Alex Deucher
(AMD DRM maintainer).

### Step 3.5: Dependencies
**Record:** No prerequisites. Adds a simple validation before existing
logic. Applies cleanly to current `amd_powerplay.c` in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 6f5c27bdc1e91` failed (commit not in local object
  database).
- Web search found submission: [amd-gfx May
  2026](https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/145636.html) by Asad Kamal, May 29, 2026.
- Review reply from Yang Wang referenced in thread index.
- No explicit stable nomination found in available search results.
- No NAKs found in available summaries.

### Step 4.2: Reviewers
**Record:** CC list included AMD maintainers (Deucher, Lazar, etc.).
`Reviewed-by: Yang Wang`; `Signed-off-by: Alex Deucher`.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug identified by
code inspection / internal AMD review.

### Step 4.4: Related patches
**Record:** Direct parallel: `1abb2648698bf` for
`smu_sys_set_pp_table()` — same sysfs interface, same class of overflow,
already in this tree and nominated for stable.

### Step 4.5: Stable list history
**Record:** lore.kernel.org blocked by bot protection; could not search
stable@ list directly. SMU sibling fix explicitly had `Cc:
stable@vger.kernel.org`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pp_dpm_set_pp_table()`, callers:
`amdgpu_dpm_set_pp_table()`, `amdgpu_set_pp_table()`.

### Step 5.2: Callers
**Record:**
- `amdgpu_set_pp_table()` — sysfs store for `pp_table`
  (`AMDGPU_DEVICE_ATTR_RW(pp_table, ...)`)
- `amdgpu_dpm_set_pp_table()` — dispatches via `pp_funcs->set_pp_table`
  under `adev->pm.mutex`
- Powerplay path: `pp_dpm_funcs.set_pp_table = pp_dpm_set_pp_table`
  (legacy DPM GPUs)
- SMU path: `smu_sys_set_pp_table` (Navi+ and newer) — separate code
  path, already has size checks

### Step 5.3: Callees
**Record:** `kmemdup()`, `memcpy()`, `amd_powerplay_reset()`, optional
`avfs_control()`.

### Step 5.4: Reachability
**Record:**
- Reachable from userspace via `/sys/class/drm/card*/device/pp_table`
  write.
- Requires `amdgpu_pm_get_access()` (device runtime-resumed); sysfs
  write typically requires root/CAP_SYS_ADMIN.
- Affects systems using legacy powerplay DPM (pre-SMU path GPUs:
  Polaris, Vega, older APUs, etc.) — still common in stable/LTS
  deployments.

### Step 5.5: Similar patterns
**Record:** SMU path (`smu_sys_set_pp_table`) validates
`header->usStructureSize != size` and reallocates when needed
(`1abb2648698bf`). Powerplay path lacked any size validation —
inconsistent and vulnerable.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Current tree at `v6.18.44` has unbounded `memcpy`
in `pp_dpm_set_pp_table()` (lines 668–676). No `size >
soft_pp_table_size` check. Bug introduced 2016; long-standing.

### Step 6.2: Backport complications
**Record:** Clean apply expected — 3-line insertion with no surrounding
churn in the function. Recent file history is handle-pointer refactors
unrelated to this hunk.

### Step 6.3: Related fixes already present?
**Record:** SMU overflow fix (`1abb2648698bf`) is an ancestor of HEAD.
Powerplay-path equivalent is **not** present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/amd/pm` — **IMPORTANT** (AMD GPU driver
power management). Not universal core kernel, but widely deployed on
desktop, laptop, and server GPUs.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent commits in `amd_powerplay.c` and
related PM code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of AMD GPUs on the legacy powerplay DPM path who write
custom powerplay tables via `pp_table` sysfs. Config/driver-specific,
but covers many still-supported Polaris/Vega-era devices.

### Step 8.2: Trigger conditions
**Record:** Write to `pp_table` with `count > soft_pp_table_size` (and
`count` up to `PAGE_SIZE`). Requires sysfs write access (typically
root). Trigger is straightforward for anyone intentionally uploading a
table.

### Step 8.3: Failure mode severity
**Record:** Heap buffer overflow → potential kernel crash, memory
corruption, possible security impact. **Severity: HIGH** (memory safety;
kernel integrity).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — closes a real, long-standing heap overflow on a
  reachable sysfs path; aligns powerplay path with already-stable-
  nominated SMU fix.
- **Risk:** VERY LOW — 3-line bounds check, rejects only invalid inputs.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real heap overflow bug, present since 2016
- Reachable via `pp_table` sysfs on legacy powerplay GPUs
- Small (3 lines), obviously correct, maintainer-reviewed
- Parallel SMU fix already in this tree with stable nomination
- Prevents crash/corruption

**AGAINST backport:**
- Only affects legacy powerplay path (not Navi+/SMU GPUs)
- Sysfs write typically requires elevated privileges
- No syzbot/CVE report (but bug mechanism is clear from code)

**Unresolved:** Full lore review thread content (bot protection); no
explicit `Cc: stable` on this specific patch (but sibling fix had it).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — trivial bounds check;
   `Reviewed-by` AMD engineer; maintainer sign-off.
2. Fixes a real bug affecting users? **PASS** — heap overflow on sysfs
   upload path.
3. Important issue? **PASS** — memory safety / potential crash and
   corruption (**HIGH**).
4. Small and contained? **PASS** — 3 lines, one function.
5. No new features or APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — buggy code present; patch applies
   cleanly.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as a standard security/stability bug fix.

### Step 9.4: Decision rationale
This commit fixes a genuine heap buffer overflow in
`pp_dpm_set_pp_table()` that has existed in the 6.18.y tree since the
powerplay table upload feature was added. The fix is minimal, correct,
and consistent with the already-backported SMU-path overflow fix. For
stable users running legacy AMD GPUs who use `pp_table` sysfs, this
prevents kernel memory corruption and potential crashes.

---

## Verification

- **[Phase 1]** `git describe HEAD` → `v6.18.44`; parsed commit message
  tags and body from user-provided diff
- **[Phase 2]** Read `amd_powerplay.c:660-688` — confirmed missing
  bounds check and unbounded `memcpy`
- **[Phase 2]** Traced call chain via grep: `amdgpu_set_pp_table` →
  `amdgpu_dpm_set_pp_table` → `pp_dpm_set_pp_table`
- **[Phase 3]** `git blame -L 660,690` — function from 2015, `memcpy`
  from `4dcf9e6f2e33fe` (2016-06-01)
- **[Phase 3]** `git show 4dcf9e6f2e33fe` — introduced upload/reset
  support with unbounded copy
- **[Phase 3]** `git show 1abb2648698bf` — SMU sibling overflow fix with
  `Cc: stable`; confirmed ancestor of HEAD
- **[Phase 3]** `git log --grep="bound pp_dpm"` — no match; fix not in
  tree
- **[Phase 4]** `b4 dig -c 6f5c27bdc1e91` — failed (commit not in repo)
- **[Phase 4]** Web search — found amd-gfx submission May 29, 2026;
  Reviewed-by Yang Wang in thread
- **[Phase 4]** lore.kernel.org fetch — blocked (bot protection);
  stable@ search UNVERIFIED
- **[Phase 5]** Read `amdgpu_pm.c:581-601`, `amdgpu_dpm.c:1717-1733` —
  sysfs write path confirmed
- **[Phase 5]** Read `amdgpu_smu.c:633-659` — SMU path has size
  validation; powerplay path does not
- **[Phase 5]** Grep `set_pp_table` — two implementations: powerplay and
  SMU
- **[Phase 6]** `git describe HEAD` → v6.18.44 on `stable/linux-6.18.y`
- **[Phase 6]** Confirmed buggy code at lines 668-676 without fix
- **[Phase 8]** Failure mode: heap OOB write → crash/corruption,
  severity HIGH

**YES**

 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 554492dfa3c00..ec95faa6edcf8 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -665,6 +665,9 @@ static int pp_dpm_set_pp_table(void *handle, const char *buf, size_t size)
 	if (!hwmgr || !hwmgr->pm_en)
 		return -EINVAL;
 
+	if (size > hwmgr->soft_pp_table_size)
+		return -EINVAL;
+
 	if (!hwmgr->hardcode_pp_table) {
 		hwmgr->hardcode_pp_table = kmemdup(hwmgr->soft_pp_table,
 						   hwmgr->soft_pp_table_size,
-- 
2.53.0

