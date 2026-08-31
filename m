Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCF1470105;
	Mon, 31 Aug 2026 13:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183307; cv=none; b=PxnnnlaVNyn+NQNzwU6Ucmqg9YDdSStwsyeP3hOY8YCXC9xuqOv9JCq3S7hoc8pEzNUIyUBrs0r6fe+iIk8r0b8sdphWS+8EfkGSowX9RlAl2f+wt5Ro1yK2VdnjK8nGYI1IZxpdAEDlQY6JHit101sZfXO01cSEMP+NrBLkzEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183307; c=relaxed/simple;
	bh=zoVrskEDuoFkW2T3zBTR2fSDYP97m4cdTJwOHY6miuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zj2UgNy/aXmRJXQ4gLh2MF+w3AqamneApgcfZQJ2kuODfVUdKK7lwJiUklglGRSJO3xFJFTQM0QHIo6yGC7tNcSdHaN7VUD1o1S3g/rwItJA5Gohq2GnzEZ0jgIBfHFO+ZmRS0vPallESEwT4W2DEpZ8yYNNiZCXdO7W2yi46CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipncZ0eF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipncZ0eF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2938A1F00A3D;
	Mon, 31 Aug 2026 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183305;
	bh=001UyezUgqzBgR+joQcEPUm7bTKh8njlpvoggf2sAd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipncZ0eF45ZkS6hZ41WTwFVBfPGhYcl8HoedRWmuhL0EIQTwLIny7Uv1ohup2IvvL
	 pSv8VBzOHhzx3J6H/dsZf8Ys5azdqz2jRz5+bzy2K3cBmyoVdDXHPP9MifzMNpTHei
	 98bmruotPjIwVMolYvTaU4rUgPoxtFFd2cdvDpd1pv2q5Z0eOPR2HSFRKlUakLcX2C
	 v0yhCYNjrYVH4Br2YNyRlBB3fGWIqsJB2N9V6lBn1879qjkXV7zjxUeVhjkFURTNQ4
	 QwY5pdu3bob1iMb3w6xqVDNYLWuRQ6QXPxX2UQgogq5vql0o/RX8IPvhpvgb8aBnE0
	 Y0HtoSBaH/T9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: validate RAS EEPROM tbl_size before record count
Date: Mon, 31 Aug 2026 09:21:37 -0400
Message-ID: <20260831133314.4125787-69-sashal@kernel.org>
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit c83e4a45ff9a0b7aa1c48246102009a99ccef11b ]

Corrupt EEPROM data can set tbl_size below the table header size.
Guard the RAS_NUM_RECS macros against undersized tbl_size and reset
the table during init when tbl_size is below the minimum for the table
version instead of trusting the header.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[drm/amdgpu]` `[validate]` — Validate RAS EEPROM `tbl_size`
before computing record count from the EEPROM table header.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Candice Li `<candice.li@amd.com>` (author)
- **Reviewed-by:** Hawking Zhang `<Hawking.Zhang@amd.com>`
- **Signed-off-by:** Alex Deucher `<alexander.deucher@amd.com>`
  (drm/amdgpu maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`, or syzbot tags
- Notable absence: no fuzzer or user bug report; maintainer-reviewed
  driver fix only

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** Corrupt EEPROM can set `tbl_size` below the minimum size for
  the table version (20 bytes for V1, 276 bytes for V2.1/V3).
- **Symptom:** `RAS_NUM_RECS` / `RAS_NUM_RECS_V2_1` perform unsigned
  subtraction on undersized `tbl_size`, producing incorrect record
  counts; driver should not trust the header.
- **Fix approach:** Guard macros to return 0 on undersized `tbl_size`;
  during `amdgpu_ras_eeprom_init()`, detect undersized `tbl_size` and
  reset the table via `amdgpu_ras_eeprom_reset_table()` instead of
  proceeding.
- **Root cause:** Missing minimum-size validation before using
  `tbl_size` in record-count arithmetic.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as validation, but it is a real correctness
bug fix. Undersized `tbl_size` causes unsigned underflow in
`RAS_NUM_RECS*` macros. The init-path change converts a permanent init
failure (`-EINVAL`, EEPROM marked invalid) into self-healing table
reset, matching the existing invalid-header recovery pattern.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c` only
- **Scope:** ~20 lines changed (macro guards + two init checks)
- **Functions/macros modified:** `RAS_NUM_RECS`, `RAS_NUM_RECS_V2_1`,
  `amdgpu_ras_eeprom_init()`
- **Classification:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Macro hunks:** Before — unconditional `(tbl_size - header_size) /
  record_size` (unsigned underflow when `tbl_size` too small). After —
  return `0u` if below minimum, else compute normally.
- **V2.1/V3 init hunk:** Before — compute `ras_num_recs` immediately.
  After — if `tbl_size < 276`, log error and reset table.
- **V1 init hunk:** Before — compute immediately. After — if `tbl_size <
  20`, log error and reset table.
- **Path affected:** Driver init on GPUs with RAS EEPROM support (probe-
  time `amdgpu_ras_eeprom_init()`).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Memory safety / logic correctness (unsigned arithmetic
  on corrupt data)
- **Mechanism:** `tbl_size` is `uint32_t`. When `tbl_size <
  RAS_TABLE_HEADER_SIZE` (V1) or `< RAS_TABLE_HEADER_SIZE +
  RAS_TABLE_V2_1_INFO_SIZE` (V2.1/V3), subtraction wraps to a very large
  value. Commit 5df0d6addb7e9’s `ras_num_recs > ras_max_record_count`
  check catches this and returns `-EINVAL`, but EEPROM stays permanently
  disabled. This commit adds explicit minimum-size validation and auto-
  recovery.

### Step 2.4: Fix Quality
**Record:** Obviously correct and minimal. Mirrors `6ffc6e056febb`
(“Reset RAS table if header is invalid”). Low regression risk: only
triggers on already-corrupt EEPROM headers; reset path is well-tested.
No API changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `RAS_NUM_RECS` introduced in `63d4c081a556a` (2021-04-06, “Optimize
  EEPROM RAS table I/O”)
- `RAS_NUM_RECS_V2_1` introduced in `65183faec89f3e` (2023-05-30, “Add
  RAS table v2.1 macro definition”)
- Buggy unsigned arithmetic present since those commits; this tree is
  **v6.18.44**

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:** Related validation commits already in this tree:
- `5df0d6addb7e9` — “Add basic validation for RAS header” (max record
  count check)
- `6ffc6e056febb` — “Reset RAS table if header is invalid”
- `660261df61fb7` — “refine eeprom data check” (checksum on unload)
- `89232d0db3ca9` — “return when ras table checksum is error”
Standalone fix; not part of a numbered series.

### Step 3.4: Author Context
**Record:** Candice Li is an AMD contributor. Related validation work by
Lijo Lazar and ganglxie in the same file. Alex Deucher (maintainer)
signed off.

### Step 3.5: Dependencies
**Record:** Requires `RAS_NUM_RECS_V2_1`,
`amdgpu_ras_eeprom_reset_table()`, and the version switch in init — all
present in v6.18.44. User diff shows HBM3E context from newer mainline;
that block is **not** in this tree and is **not** part of the patch
hunks. Applies standalone to 6.18.44 init switch.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** Commit hash not in this checkout; `b4 dig -c` could not
match. Lore search blocked by Anubis bot protection. **UNVERIFIED:**
full mailing-list review thread.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via b4. Commit message shows Reviewed-by
Hawking Zhang (AMD) and Signed-off-by Alex Deucher (maintainer).

### Step 4.3: Bug Reports
**Record:** N/A — no `Reported-by:` or `Link:` tags.

### Step 4.4: Related Patches
**Record:** Part of ongoing amdgpu RAS EEPROM validation hardening;
prior related commits are already in v6.18.44.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — could not search lore stable archive.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `RAS_NUM_RECS`, `RAS_NUM_RECS_V2_1`,
`amdgpu_ras_eeprom_init()`

### Step 5.2: Callers
**Record:** `amdgpu_ras_eeprom_init()` called from
`amdgpu_ras_init_badpage_info()` in `amdgpu_ras.c:3590`, which runs
during GPU RAS initialization at probe. Affects VEGA20, Arcturus, Sienna
Cichlid, Aldebaran, and other RAS-EEPROM-capable dGPUs per
`__is_ras_eeprom_supported()`.

### Step 5.3: Callees
**Record:** On undersized `tbl_size`, calls
`amdgpu_ras_eeprom_reset_table()` which rewrites a valid header to
EEPROM via I2C.

### Step 5.4: Reachability
**Record:** Triggered at every boot on affected hardware when EEPROM
`tbl_size` is corrupt. Not userspace-triggerable directly, but affects
all boots on affected systems. Corrupt EEPROM is a realistic
hardware/partial-write scenario on datacenter GPUs.

### Step 5.5: Similar Patterns
**Record:** Same recovery pattern as `6ffc6e056febb` for invalid header
magic. Complements `5df0d6addb7e9` max-record validation.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current tree at lines 145–150 has unguarded
`RAS_NUM_RECS` macros; `amdgpu_ras_eeprom_init()` at lines 1415–1432
lacks `tbl_size` minimum checks. Bug present since 2021/2023; partial
mitigation since `5df0d6addb7e9` (Mar 2025).

### Step 6.2: Backport Complications
**Record:** Expected **clean apply** — init switch structure matches; no
HBM3E block in 6.18.44 that would conflict. Only line-number offset
differs; context-based apply should work.

### Step 6.3: Related Fixes Already Present?
**Record:** Max record count validation (`5df0d6addb7e9`) and invalid-
header reset (`6ffc6e056febb`) are present. **This specific `tbl_size`
minimum validation is NOT present.**

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** `drivers/gpu/drm/amd/amdgpu` — **IMPORTANT** (AMD
datacenter/enterprise GPU RAS reliability; not universal but critical
for affected hardware).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — 4 EEPROM-related commits in recent
file history on this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of AMD GPUs with RAS EEPROM support (VEGA20, Arcturus,
MI-series, RDNA/CDNA dGPUs with HBM RAS). Config: `CONFIG_DRM_AMDGPU`
with supported ASICs.

### Step 8.2: Trigger Conditions
**Record:** Corrupt EEPROM `tbl_size` field on boot. Uncommon but
realistic (wear, partial write, hardware glitch). Not unprivileged-
triggerable; hardware/firmware corruption path.

### Step 8.3: Failure Mode Severity
**Record:**
- **Without fix:** Undersized `tbl_size` → unsigned underflow →
  `ras_num_recs > ras_max_record_count` → `-EINVAL` → `is_eeprom_valid =
  false` every boot. GPU runs but RAS EEPROM bad-page tracking is
  permanently disabled until manual intervention. Verified: all
  `tbl_size < 20` (V1) and `tbl_size < 276` (V2.1) underflow cases
  produce record counts above max (Python verification).
- **With fix:** Table auto-reset; RAS EEPROM functionality restored.
- **Severity:** **MEDIUM-HIGH** for affected datacenter hardware
  (operational RAS degradation, not kernel crash). No OOM path because
  `amdgpu_ras_load_bad_pages()` is gated on `is_eeprom_valid` (line
  3600).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Self-healing corrupt EEPROM; defense-in-depth on macros;
  consistent with existing reset-on-corruption policy.
- **Risk:** Very low — ~20 lines, only error/corruption path, uses
  existing reset function.
- **Ratio:** Moderate benefit, very low risk. Worth backporting given
  prior similar fixes already in 6.18.y.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real corrupt-EEPROM bug (unsigned underflow + incorrect trust of
  header)
- Auto-recovery instead of permanent EEPROM disable on every boot
- Small, surgical, maintainer-reviewed
- Prerequisites present in v6.18.44
- Consistent with already-backported validation series (`5df0d6`,
  `6ffc6e`, `660261`, `89232d`)
- Affects production RAS-capable AMD GPUs

**AGAINST backport:**
- Existing max-record check already prevents huge `kcalloc` / OOM (since
  Mar 2025)
- No crash, deadlock, or security exploit demonstrated
- No user/syzbot report
- Primary improvement is operational recovery, not crash prevention
- Lore review unverified

**UNRESOLVED:** Mailing-list discussion and stable-list nomination
history.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   reviewed by AMD engineer and maintainer (no runtime test tag).
2. Fixes real bug affecting users? **PASS** — corrupt EEPROM leaves RAS
   tracking disabled on every boot on affected hardware.
3. Important issue? **PASS (MEDIUM-HIGH)** — datacenter RAS reliability
   degradation on supported GPUs; not a kernel crash but materially
   impacts production GPU health tracking.
4. Small and contained? **PASS** — one file, ~20 lines.
5. No new features/APIs? **PASS** — validation and recovery only.
6. Can apply to local tree? **PASS** — code exists; patch should apply
   cleanly to v6.18.44.

### Step 9.3: Exception Categories
**Record:** Hardware workaround for corrupt EEPROM data on existing RAS-
EEPROM driver — analogous to quirk/validation exception category.

### Step 9.4: Decision Rationale

This commit completes the RAS EEPROM validation work already present in
v6.18.44. While the max-record check added in `5df0d6addb7e9` prevents
the worst outcome (huge allocation), corrupt undersized `tbl_size` still
causes permanent EEPROM init failure on every boot. The fix follows the
established pattern of resetting corrupt tables rather than leaving the
driver in a degraded state. It is small, obviously correct, low-risk,
and relevant to this tree’s existing amdgpu RAS EEPROM code.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, tags (SOB, Reviewed-by,
  no Fixes/Reported-by/Link)
- **[Phase 2]** Diff analysis: 1 file, macro guards + 2 init checks in
  `amdgpu_ras_eeprom_init()`
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `git blame` lines 145–150: macros from 63d4c081a556a
  (2021), 65183faec89f3e (2023)
- **[Phase 3]** `git log -15 -- amdgpu_ras_eeprom.c`: related validation
  commits present
- **[Phase 3]** `git show 5df0d6addb7e9`: added max record count
  validation
- **[Phase 3]** `git show 6ffc6e056febb`: reset on invalid header magic
- **[Phase 3]** `git merge-base --is-ancestor`: 5df0d6 and 65183fa both
  in tree
- **[Phase 4]** `b4 dig`: no commit hash available in tree — no match
- **[Phase 4]** lore.kernel.org fetch: blocked by Anubis —
  **UNVERIFIED**
- **[Phase 5]** `grep amdgpu_ras_eeprom_init`: caller at
  `amdgpu_ras.c:3590`
- **[Phase 5]** `grep RAS_NUM_RECS`: only used in
  `amdgpu_ras_eeprom_init()`
- **[Phase 5]** `grep is_eeprom_valid`: gates
  `amdgpu_ras_load_bad_pages` at line 3600
- **[Phase 6]** Read current `amdgpu_ras_eeprom.c` lines 145–150,
  1415–1444: buggy code confirmed present
- **[Phase 6]** Python verification: all `tbl_size < 20` (V1) and
  `tbl_size < 276` (V2.1) underflow cases produce record counts > max —
  existing check returns `-EINVAL`
- **[Phase 8]** Read `amdgpu_ras_init_badpage_info()`: `is_eeprom_valid
  = !ret`; load gated on validity
- **[Phase 8]** `tbl_size` type confirmed `uint32_t` in
  `amdgpu_ras_eeprom.h:51`

**YES**

 .../gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    | 26 +++++++++++++++----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 652aa085b6263..51382d604b1f0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -142,12 +142,15 @@
 #define RAS_RI_TO_AI(_C, _I) (((_I) + (_C)->ras_fri) % \
 			      (_C)->ras_max_record_count)
 
-#define RAS_NUM_RECS(_tbl_hdr)  (((_tbl_hdr)->tbl_size - \
-				  RAS_TABLE_HEADER_SIZE) / RAS_TABLE_RECORD_SIZE)
+#define RAS_NUM_RECS(_tbl_hdr) \
+	(((_tbl_hdr)->tbl_size < RAS_TABLE_HEADER_SIZE) ? 0u : \
+	 (((_tbl_hdr)->tbl_size - RAS_TABLE_HEADER_SIZE) / RAS_TABLE_RECORD_SIZE))
 
-#define RAS_NUM_RECS_V2_1(_tbl_hdr)  (((_tbl_hdr)->tbl_size - \
-				       RAS_TABLE_HEADER_SIZE - \
-				       RAS_TABLE_V2_1_INFO_SIZE) / RAS_TABLE_RECORD_SIZE)
+#define RAS_NUM_RECS_V2_1(_tbl_hdr) \
+	(((_tbl_hdr)->tbl_size < RAS_TABLE_HEADER_SIZE + \
+	  RAS_TABLE_V2_1_INFO_SIZE) ? 0u : \
+	 (((_tbl_hdr)->tbl_size - RAS_TABLE_HEADER_SIZE - \
+	   RAS_TABLE_V2_1_INFO_SIZE) / RAS_TABLE_RECORD_SIZE))
 
 #define to_amdgpu_device(x) ((container_of(x, struct amdgpu_ras, eeprom_control))->adev)
 
@@ -1415,11 +1418,24 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control)
 	switch (hdr->version) {
 	case RAS_TABLE_VER_V2_1:
 	case RAS_TABLE_VER_V3:
+		if (hdr->tbl_size < RAS_TABLE_HEADER_SIZE + RAS_TABLE_V2_1_INFO_SIZE) {
+			dev_err(adev->dev,
+				"RAS header invalid, tbl_size %u smaller than minimum %u, resetting table\n",
+				hdr->tbl_size,
+				RAS_TABLE_HEADER_SIZE + RAS_TABLE_V2_1_INFO_SIZE);
+			return amdgpu_ras_eeprom_reset_table(control);
+		}
 		control->ras_num_recs = RAS_NUM_RECS_V2_1(hdr);
 		control->ras_record_offset = RAS_RECORD_START_V2_1;
 		control->ras_max_record_count = RAS_MAX_RECORD_COUNT_V2_1;
 		break;
 	case RAS_TABLE_VER_V1:
+		if (hdr->tbl_size < RAS_TABLE_HEADER_SIZE) {
+			dev_err(adev->dev,
+				"RAS header invalid, tbl_size %u smaller than minimum %u, resetting table\n",
+				hdr->tbl_size, RAS_TABLE_HEADER_SIZE);
+			return amdgpu_ras_eeprom_reset_table(control);
+		}
 		control->ras_num_recs = RAS_NUM_RECS(hdr);
 		control->ras_record_offset = RAS_RECORD_START;
 		control->ras_max_record_count = RAS_MAX_RECORD_COUNT;
-- 
2.53.0

