Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04104457DB;
	Mon, 31 Aug 2026 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183242; cv=none; b=bj7PRDAfPQ+BAUUagG0DyDSOLUdc08dBGtl7TM10jXcMk4tQ2GPmW5rDISQ++cTU92d/Ub8gWOV0qx1/xXJegUPtd2oSZpZImmn1lVBw/D+wDseVpg7XYsQ7sAuX4Ru3wSPAxjCfXyedUUjJcSUzp5h2Q6jT4ZD5IngYIhyJgMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183242; c=relaxed/simple;
	bh=XEufWIAB4YMVpvaMrO68QTX1Mx8aWllkAEtzs6FGVX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2QGcKB0a5dLlz8ioIgp39GELJ+2Vkk1OtiI/ujKbBeceSeLtGBe8MM6TTEoJLKAa0Ob2g2qAgCOP6dqr2GNRVl36xcGeJwq4JW/1Hd6FEy2Pl0SFBwwMTQHs1L5KbvDinbkM5J/jWTg1Fsx8DQZhZG2vyuK3x3LXBwcrP/AqrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUx5Nhfe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUx5Nhfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3209D1F00A3D;
	Mon, 31 Aug 2026 13:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183240;
	bh=mQLVFedAryXzf4R4Gw7lLwMqOlxpZk+6H8r98aGlBu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUx5NhfeBh+xesf3UU+jw69ZR4jAx+bwgFZYGFJlRGULg/mHc8OwZrphLYdCRzi/0
	 D2L+rO9Pzpjsn+DUhew5DJWuBDyLkXbUi7RvW+eplEsAbKBUHzM3M2dZvn+Xh5oVID
	 u9DZ4eI3s4lOK+IwjmIYrE1vw7Yhag15h1DMP3EjFxvSZPX35rfsL8VdkeVLe6klxi
	 3X2enrYaj6YQ2qU2FKQIMS7Z8C+JrVFKOuiod+qQtIoj24vordzAa3sgndVQi+hKGg
	 L5jA97sJgl08gNIw3j3vv4OqbX9ZEMEBq1jezsNECVQqTgWEfTxaSjE4eOnzy7UNrf
	 3ilJ8sbAMhOLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	maciej.wieczor-retman@intel.com,
	pawel.chmielewski@intel.com,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Prevent adding invalid references
Date: Mon, 31 Aug 2026 09:20:57 -0400
Message-ID: <20260831133314.4125787-29-sashal@kernel.org>
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

From: ikaros <void0red@gmail.com>

[ Upstream commit 6e8c55e13a5e3a9f38921d62924f18ceba3330eb ]

Prevent adding references for local, argument, and debug objects
in acpi_ut_copy_simple_object().

Link: https://github.com/acpica/acpica/commit/f576898d7814
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4511989.ejJDZkT8p0@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPICA: Prevent adding invalid references

## Tree Context

Local checkout: **v6.18.44** (6.18.44). The fix is **not** present in
this tree; the buggy code remains at `drivers/acpi/acpica/utcopy.c:734`.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ACPICA] [prevent] — Prevent adding invalid references in
acpi_ut_copy_simple_object() when copying LOCAL/ARG/DEBUG reference
objects.`

### Step 1.2: Tags
**Record:**
- **Link:** https://github.com/acpica/acpica/commit/f576898d7814
  (upstream ACPICA commit)
- **Link:** https://patch.msgid.link/4511989.ejJDZkT8p0@rafael.j.wysocki
  (kernel submission; fetch blocked by bot protection)
- **Signed-off-by:** ikaros <void0red@gmail.com> (author)
- **Signed-off-by:** Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  (ACPI maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable@
- Notable: Submitted as **[PATCH v1 15/27] ACPI: ACPICA 20260408**
  series (May 27, 2026)

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `acpi_ut_copy_simple_object()` unconditionally calls
  `acpi_ut_add_reference(source_desc->reference.object)` for all
  reference classes except `ACPI_REFCLASS_TABLE`.
- **Problem:** LOCAL, ARG, and DEBUG references do not have a valid
  operand-object pointer in `reference.object`.
- **Symptom:** Use-after-free when `acpi_ut_add_reference()` →
  `acpi_ut_valid_internal_object()` reads freed memory (confirmed in
  ACPICA issue #1127 with ASAN stack trace).
- **Root cause:** LOCAL/ARG use `reference.value` (and may store a
  namespace-node pointer in `object` via cast); DEBUG sets only
  `reference.class` with no valid `object`. Calling
  `acpi_ut_add_reference()` on these is semantically wrong and can
  dereference stale/freed pointers.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite the neutral "prevent" wording, this is a real
memory-safety bug fix (UAF), not cleanup. It extends the existing 2008
`ACPI_REFCLASS_TABLE` exemption pattern to the three other reference
classes that similarly lack a valid operand-object pointer.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/acpi/acpica/utcopy.c` (+9, -1)
- **Function:** `acpi_ut_copy_simple_object()`
- **Scope:** Single-file, surgical fix in one `case
  ACPI_TYPE_LOCAL_REFERENCE:` block

### Step 2.2: Code Flow Change
**Record:**
- **Before:** After exempting `ACPI_REFCLASS_TABLE`, always call
  `acpi_ut_add_reference(source_desc->reference.object)`.
- **After:** Also skip `acpi_ut_add_reference()` for
  `ACPI_REFCLASS_LOCAL`, `ACPI_REFCLASS_ARG`, and `ACPI_REFCLASS_DEBUG`.
- **Path affected:** Object-copy path used when duplicating ACPI
  internal objects (packages, CopyObject opcode, store operations).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Use-after-free / invalid pointer dereference
- **Mechanism:** For LOCAL/ARG/DEBUG references, `reference.object` is
  not a valid `union acpi_operand_object *`. `acpi_ut_add_reference()`
  calls `acpi_ut_valid_internal_object()` which reads
  `ACPI_GET_DESCRIPTOR_TYPE(object)` from that pointer — triggering UAF
  when the pointer is stale (e.g., freed walk-state memory per ACPICA
  issue #1127 ASAN report).

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: mirrors the existing TABLE exemption and matches
  how `exresolv.c` treats these classes ("do not dereference").
- Minimal, no unrelated changes.
- Low regression risk: only skips refcount increment that should never
  have happened for these three classes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Reference-handling case dates to **2005** (initial ACPICA import).
- `acpi_ut_add_reference()` call: **2005** (Len Brown).
- `ACPI_REFCLASS_TABLE` exemption: **2008** (Bob Moore, commit
  `1044f1f65b7df2`) — LOCAL/ARG/DEBUG were never added.
- Bug has been present since ~2005; TABLE partial fix since 2008.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag. Upstream ACPICA issue #1127 references
commit f576898.

### Step 3.3: Related File History
**Record:**
- `470188b09e92d` (2022): Fixed a separate UAF in
  `acpi_ut_copy_ipackage_to_ipackage()` in the same file — shows this
  code path is security-relevant and prior UAF fixes were backported.
- `b6a163875935c` (2008): Warn on invalid package references — related
  defensive work in ACPI reference handling.
- This fix is **standalone** (patch 15/27 of ACPICA bulk update, but
  functionally independent).

### Step 3.4: Author Context
**Record:** ikaros reported the bug to ACPICA upstream. Rafael J.
Wysocki (ACPI maintainer) signed off and submitted to linux-acpi. Author
has prior kernel commits (null-check fixes).

### Step 3.5: Dependencies
**Record:** No dependencies. Self-contained 8-line conditional. All
referenced symbols (`ACPI_REFCLASS_LOCAL/ARG/DEBUG`) exist in this
tree's `acobject.h`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c f576898d7814`: Failed (ACPICA upstream SHA, not in Linux
  git).
- Web search found submission: **[PATCH v1 15/27] ACPICA: Prevent adding
  invalid references** at lkml.iu.edu (May 27, 2026), part of ACPI:
  ACPICA 20260408 series by Rafael J. Wysocki.
- ACPICA GitHub issue #1127: ASAN heap-use-after-free in
  `AcpiUtValidInternalObject` via `AcpiUtAddReference` →
  `AcpiUtCopySimpleObject`, reproduced with `acpiexec -m issue11.aml`.

### Step 4.2: Reviewers
**Record:** Rafael J. Wysocki submitted and signed off — ACPI subsystem
maintainer endorsement. Full recipient list unavailable (b4 dig failed;
lore blocked).

### Step 4.3: Bug Report
**Record:**
- ACPICA issue #1127: **heap-use-after-free**, READ of size 1 in
  `acpi_ut_valid_internal_object`.
- Call chain: `acpi_ut_copy_simple_object` → `acpi_ut_add_reference` →
  `acpi_ut_valid_internal_object`.
- Triggered during AML parsing/execution (`acpi_ps_parse_aml`, table
  load).
- Severity: memory safety, potential crash/corruption.

### Step 4.4: Series Context
**Record:** Part of 27-patch ACPICA 20260408 update. This patch is
standalone; does not require other series patches.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — could not search lore.kernel.org/stable (bot
protection). No evidence against stable nomination.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `acpi_ut_copy_simple_object()` (modified); callers:
`acpi_ut_copy_ielement_to_ielement()`,
`acpi_ut_copy_iobject_to_iobject()`.

### Step 5.2: Callers
**Record:**
- `acpi_ut_copy_iobject_to_iobject()` called from:
  - `exoparg1.c` — `AML_COPY_OBJECT_OP`
  - `exstore.c`, `exstoren.c` — store operations
  - `dsutils.c`, `dsmthdat.c` — dispatcher/method data
- All are core ACPI AML execution paths, active during boot and runtime
  ACPI method evaluation.

### Step 5.3: Callees
**Record:** `acpi_ut_add_reference()` →
`acpi_ut_valid_internal_object()` → reads descriptor type from pointer.
For invalid `reference.object`, this is the UAF site.

### Step 5.4: Reachability
**Record:**
- Triggered when copying packages or objects containing LOCAL/ARG/DEBUG
  references.
- ASAN reproducer uses AML table execution during namespace load.
- Reachable on every ACPI-enabled system during DSDT/SSDT evaluation and
  method execution. Not limited to obscure configs.

### Step 5.5: Similar Patterns
**Record:**
- `utcopy.c:730`: `ACPI_REFCLASS_TABLE` already exempted (same
  rationale).
- `exresolv.c:208-212`: DEBUG/TABLE/REFOF — "Just leave the object as-
  is, do not dereference."
- `dsobject.c:471-522`: LOCAL/ARG set `reference.value`; DEBUG sets only
  `reference.class` — confirms `object` is not a refcountable operand
  object.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** At `drivers/acpi/acpica/utcopy.c:721-735`,
unconditional `acpi_ut_add_reference(source_desc->reference.object)`
after only TABLE exemption. Fix text not found via grep.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Index context matches submitted
patch (line ~731). No conflicting recent changes to this hunk. Only
copyright-year churn in file history.

### Step 6.3: Related Fixes Already Present?
**Record:** `470188b09e92d` (UAF in `acpi_ut_copy_ipackage_to_ipackage`)
is present. No duplicate fix for LOCAL/ARG/DEBUG reference handling.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** **ACPI/ACPICA** — **CORE** subsystem. Affects all x86
systems and ARM64 systems using ACPI.

### Step 7.2: Activity
**Record:** Actively maintained; recent ACPICA fixes in this tree
include UAF, NULL deref, and AML safety patches.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** All users with ACPI enabled (essentially all PCs, servers,
many ARM laptops). Driver-specific? No — core ACPI interpreter.

### Step 8.2: Trigger Conditions
**Record:** Copying ACPI internal objects (packages, CopyObject) that
contain LOCAL, ARG, or DEBUG reference elements. Can be triggered by
ACPI AML in firmware tables. Timing-dependent UAF when
`reference.object` holds stale pointer. Unprivileged users cannot
directly trigger, but firmware/ACPI tables are the attack surface.

### Step 8.3: Failure Mode
**Record:** **Heap use-after-free** in `acpi_ut_valid_internal_object`.
Severity: **HIGH** (crash, potential memory corruption). Could manifest
as oops during boot, suspend/resume, or device hotplug ACPI methods.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents UAF in core ACPI object-copy path on all
  ACPI systems.
- **Risk:** VERY LOW — 8-line conditional extending an established
  pattern; no API/behavior change for valid reference types (REFOF,
  INDEX, NAME still get refcounted).
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Confirmed UAF (ASAN report in ACPICA #1127)
- Long-standing bug (since 2005; TABLE partial fix since 2008)
- Buggy code present in v6.18.44
- Core ACPI path (boot, AML execution)
- Small, surgical, obviously correct fix
- Matches existing TABLE exemption and exresolv.c semantics
- ACPI maintainer (Rafael Wysocki) signed off and submitted
- Prior UAF fix in same file was backported to stable

**AGAINST backport:**
- No kernel runtime reproducer in commit message (only acpiexec/AML test
  case)
- Part of larger ACPICA bulk update (but this patch is standalone)
- Not yet merged into this 6.18.44 tree (candidate evaluation)

**Unresolved:**
- Lore stable-list discussion (site blocked)
- Exact frequency in production firmware (unverified, but bug mechanism
  is clear)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic mirrors TABLE
   exemption; ASAN-verified upstream; maintainer SOB.
2. Fixes a real bug? **PASS** — UAF in object copy.
3. Important issue? **PASS** — UAF/memory corruption in core ACPI,
   severity HIGH.
4. Small and contained? **PASS** — 9 lines, one file, one function.
5. No new features/APIs? **PASS** — defensive guard only.
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected.

### Step 9.3: Exception Categories
**Record:** N/A (not device ID, quirk, DT, build, or docs — standard bug
fix).

### Step 9.4: Decision Rationale
This commit fixes a verified use-after-free in the ACPICA object-copy
path that has existed since the code was written. LOCAL, ARG, and DEBUG
references never had valid operand-object pointers in `reference.object`
— the 2008 TABLE exemption proves the developers knew some reference
classes must skip `acpi_ut_add_reference()`. The fix is minimal, follows
established patterns in the same file and in `exresolv.c`, and protects
all ACPI-enabled systems during AML execution. For v6.18.44, the buggy
code is present and the fix applies cleanly.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified UAF bug from ACPICA
  issue #1127
- [Phase 1] Web search: found [PATCH v1 15/27] on lkml (May 27, 2026),
  Rafael Wysocki submission
- [Phase 2] Read diff: +9/-1 in `acpi_ut_copy_simple_object()`,
  LOCAL/ARG/DEBUG guard added
- [Phase 2] Read `acobject.h:340-365`: LOCAL/ARG use `value`, DEBUG has
  no valid `object`
- [Phase 2] Read `dsobject.c:462-522`: LOCAL/ARG/DEBUG creation confirms
  no operand-object in `reference.object`
- [Phase 2] Read `utdelete.c:677-696`: `acpi_ut_add_reference()` calls
  `acpi_ut_valid_internal_object()`
- [Phase 2] Read `utobject.c:305-335`: `acpi_ut_valid_internal_object()`
  reads descriptor type (UAF site)
- [Phase 3] `git blame -L 721,735`: buggy code from 2005; TABLE
  exemption from 2008 (`1044f1f65b7df2`)
- [Phase 3] `git log -20 -- utcopy.c`: related UAF fix `470188b09e92d`
  present in tree
- [Phase 3] `git show 1044f1f65b7df2`: TABLE exemption rationale
  documented
- [Phase 3] `git show 470188b09e92d`: prior UAF in same file, backported
  class of bug
- [Phase 4] `b4 dig -c f576898d7814`: failed (ACPICA SHA not in Linux
  git) — used web search instead
- [Phase 4] ACPICA GitHub issue #1127: ASAN UAF stack trace, acpiexec
  reproducer
- [Phase 4] ACPICA GitHub commit f576898: confirms fix details
- [Phase 4] UNVERIFIED: lore.kernel.org and patch.msgid.link blocked by
  bot protection
- [Phase 5] `grep acpi_ut_copy_simple_object`: callers in utcopy.c,
  exoparg1.c, exstore.c, dsutils.c, dsmthdat.c
- [Phase 5] Read `exresolv.c:208-212`: DEBUG/TABLE/REFOF not
  dereferenced — consistent with fix
- [Phase 5] Read `exoparg1.c:465-469`: CopyObject opcode uses
  `acpi_ut_copy_iobject_to_iobject`
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Read `utcopy.c:721-735`: buggy unconditional
  `acpi_ut_add_reference` confirmed
- [Phase 6] `grep "Local/Arg/Debug references"`: fix NOT in tree
- [Phase 8] ACPICA #1127 ASAN: heap-use-after-free, severity HIGH

**YES**The background `git log --grep` check finished: it found **no
commit** matching “Prevent adding invalid” or “invalid references” in
this tree. That matches what we already saw in `utcopy.c` — the
LOCAL/ARG/DEBUG guard is still missing, so the backport analysis stands
as **YES** for v6.18.44.

 drivers/acpi/acpica/utcopy.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/utcopy.c b/drivers/acpi/acpica/utcopy.c
index 80458e70ac2bf..9ecf5c3f49ba6 100644
--- a/drivers/acpi/acpica/utcopy.c
+++ b/drivers/acpi/acpica/utcopy.c
@@ -731,7 +731,15 @@ acpi_ut_copy_simple_object(union acpi_operand_object *source_desc,
 			break;
 		}
 
-		acpi_ut_add_reference(source_desc->reference.object);
+		/*
+		 * Local/Arg/Debug references do not have a valid Object pointer
+		 * that can be referenced
+		 */
+		if ((source_desc->reference.class != ACPI_REFCLASS_LOCAL) &&
+		    (source_desc->reference.class != ACPI_REFCLASS_ARG) &&
+		    (source_desc->reference.class != ACPI_REFCLASS_DEBUG)) {
+			acpi_ut_add_reference(source_desc->reference.object);
+		}
 		break;
 
 	case ACPI_TYPE_REGION:
-- 
2.53.0

