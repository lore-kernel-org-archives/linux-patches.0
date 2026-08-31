Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732C256B849;
	Mon, 31 Aug 2026 13:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184104; cv=none; b=D4DtBF61LAxkobcDji6IGfg6kJ7G9QsuNhV3J32VOxgP1YM1q+ZfdTwd7q+JPYjPIXrfbY/J3E9IVbTvwU05hCvKuo4ZTWjg4tG7rhGkduQ64Gvn9tWnSUQPSX4ZZkujtAI6+78+sZq8DsDX8KuH9F5lSuVh+TDn+fHdIJk+Ivk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184104; c=relaxed/simple;
	bh=ICMaeph8qIA0Z4Lm/054A4TiDZG5TWHd6AOv/rUpzuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lw3+urKeBkvJyz+72KUgnBtGQZGkJ/dPmMLR6Qz60WnrCrbSEPG4yurZzCBVJpaStCUoJAdwKewVkqCrYCP4b7x+nIopfEWIqbY1aPrq8oCAi7V+br1LpzvKmsMl+nqruS9OmvoEGAvWGZ5yX/N6Kgb1Qlw9Uxmd9SAqOsuYtwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=It/PsrBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="It/PsrBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040A81F00A3F;
	Mon, 31 Aug 2026 13:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184101;
	bh=qPUmKbS1BOi1wXUMdlbZLVGuseJUfoYlZgmIobEfGYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=It/PsrBKtTaES4dc1E8VLnus8aak+dWXsuRpBSOHNVXXna0bMJZNYXrxbCuqITGZP
	 A47TYj5uEFQy2hKKRU5ExDwmIeh6inebsDidOnlO6jxgnAzJ8/4JybwtmmyU1Se3Pn
	 Na7iYX92GUf/M9qWad6uhK85yO4hrOvhwX5/9go4xkGuX2hff9NwKsTarb9SzC2Oml
	 vYQ9hRiwvzM4HhFw0bwKM0Zp9pveU+paq2V4tx2yZAZLkqsreCUYM5biV+8TxBXap+
	 IEsf+fVcJr++25Z/+Epobjhrb+Wge/4TEzP/uIxgcD/SV0O6imJSoXYAAQ1OLnHHk+
	 xkFwaVcd9KfYg==
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
Subject: [PATCH AUTOSEL 6.18-6.1] ACPICA: Enhance OEM ID and Table ID validation in acpi_ex_load_table_op()
Date: Mon, 31 Aug 2026 09:28:39 -0400
Message-ID: <20260831133314.4125787-491-sashal@kernel.org>
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

[ Upstream commit 485829e6999b7909f50761a1c708660304edc945 ]

Enhance OEM ID and Table ID validation in acpi_ex_load_table_op() to
prevent buffer overflows.

Link: https://github.com/acpica/acpica/commit/f85a43098d65
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2230782.OBFZWjSADL@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPICA OEM ID/Table ID Validation in
`acpi_ex_load_table_op()`

**Local tree:** `v6.18.44` (Linux 6.18.y stable)
**Mainline commit:** `485829e6999b7` (not yet in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ACPICA] [enhance/validate] Enhance OEM ID and Table ID
validation in acpi_ex_load_table_op() to prevent buffer overflows`

### Step 1.2: Tags
**Record:**
- **Link:** https://github.com/acpica/acpica/commit/f85a43098d65
  (upstream ACPICA fix)
- **Link:** https://patch.msgid.link/2230782.OBFZWjSADL@rafael.j.wysocki
  (kernel submission)
- **Signed-off-by:** ikaros \<void0red@gmail.com\> (author)
- **Signed-off-by:** Rafael J. Wysocki \<rafael.j.wysocki@intel.com\>
  (ACPI maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: maintainer merge; part of ACPICA 20260408 import series
  (patch 22/27)

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `acpi_ex_load_table_op()` passes AML string operand pointers
  directly to `acpi_tb_find_table()`, which reads fixed
  `ACPI_OEM_ID_SIZE` (6) and `ACPI_OEM_TABLE_ID_SIZE` (8) bytes via
  `memcpy()` regardless of actual string length.
- **Symptom:** Heap-buffer-overflow on read when OEM ID/Table ID strings
  are shorter than those fixed sizes.
- **Root cause:** AML strings have explicit `.length` fields;
  allocations are `length + 1` bytes. `acpi_tb_find_table()` always
  copies 6/8 bytes from the pointer.
- **Version info:** None in commit message; bug mechanism dates to
  original `acpi_ex_load_table_op()` code (2005).

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite "Enhance validation" wording, this is a real
memory-safety bug fix. Upstream ACPICA issue
[#1144](https://github.com/acpica/acpica/issues/1144) documents an ASAN
heap-buffer-overflow with reproducer (`issue49.aml`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/acpi/acpica/exconfig.c` (+24 / -2)
- **Function:** `acpi_ex_load_table_op()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (stack buffers):** Adds `oem_id[7]` and `oem_table_id[9]`
  local buffers.
- **Hunk 2 (validation):** Before calling `acpi_tb_find_table()`, checks
  `operand[1]->string.length <= ACPI_OEM_ID_SIZE` and
  `operand[2]->string.length <= ACPI_OEM_TABLE_ID_SIZE`; returns
  `AE_AML_STRING_LIMIT` on violation.
- **Hunk 3 (safe copy):** Copies only `operand[n]->string.length` bytes
  into local buffers, null-terminates, passes local buffers to
  `acpi_tb_find_table()` instead of raw AML pointers.
- **Before:** Raw AML pointers passed → `acpi_tb_find_table()` does
  `memcpy(..., ACPI_OEM_ID_SIZE)` (6 bytes) from potentially 1–2 byte
  allocation.
- **After:** Length-validated, null-terminated stack buffers of exactly
  the right size are passed.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer over-read / heap-buffer-overflow (memory safety)
- **Mechanism:** In `acpi_tb_find_table()` at lines 60–61 of `tbfind.c`:

```60:61:drivers/acpi/acpica/tbfind.c
        memcpy(header.oem_id, oem_id, ACPI_OEM_ID_SIZE);
        memcpy(header.oem_table_id, oem_table_id,
ACPI_OEM_TABLE_ID_SIZE);
```

  `strlen()` validation (lines 51–53) only checks upper bound; it does
not prevent reading past a short string's allocation. A 1-byte OEM ID
gets a 2-byte allocation (`string_size + 1` in
`acpi_ut_create_string_object()`), but `memcpy` reads 6 bytes.

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct and minimal.
- Uses known AML `.length` rather than `strlen()` on potentially
  non–null-terminated data.
- Stack buffers are correctly sized (`ACPI_OEM_ID_SIZE + 1`,
  `ACPI_OEM_TABLE_ID_SIZE + 1`).
- **Regression risk:** Very low. Only affects the `LoadTable` AML opcode
  path; oversized strings now correctly return `AE_AML_STRING_LIMIT`
  instead of proceeding to over-read.
- Error-path cleanup is handled by `exoparg6.c` cleanup on
  `ACPI_FAILURE(status)`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Vulnerable `acpi_tb_find_table(operand[0]..., operand[1]...,
  operand[2]...)` call introduced in commit `4be44fcd3bf648` (Len Brown,
  2005-08-05).
- Bug present in this tree since kernel import of ACPICA.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:**
- Commit `9f41fd8a175ff` (2015, "Update parameter validation for
  data_table_region and load_table") **removed** length validation from
  `acpi_ex_load_table_op()` and relied on `acpi_tb_find_table()`'s
  `strlen()` checks — which do not prevent the short-string `memcpy`
  over-read.
- Fix is **not** in 6.18.y (`git log --grep="Enhance OEM"` returns
  nothing on this branch).
- Fix **is** on mainline: `485829e6999b7` (merged May 27, 2026).

### Step 3.4: Author Context
**Record:** ikaros (void0red) reported ACPICA issue #1144 and
contributed 14 patches in the ACPICA 20260408 series. Rafael J. Wysocki
merged to mainline.

### Step 3.5: Dependencies
**Record:** Patch is labeled 22/27 in the ACPICA import series but is
**standalone** — it only touches `acpi_ex_load_table_op()` and has no
structural dependencies on other series patches. `git cherry-pick --no-
commit 485829e6999b7` applies cleanly to v6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/2230782.OBFZWjSADL@rafael.j.wysocki
- **Series:** v1 only (ACPICA 20260408, 27 patches); no v2/v3 revisions
  for this patch.
- **Review feedback:** No NAKs or stable nominations found in saved
  thread mbox.
- Maintainer cover letter confirms routine ACPICA upstream sync.

### Step 4.2: Reviewers
**Record:** CC'd: Rafael J. Wysocki, linux-acpi@vger.kernel.org, LKML,
Saket Dumbre (Intel), Pawel Chmielewski (Intel).

### Step 4.3: Bug Report
**Record:**
- **ACPICA issue #1144:** Heap-buffer-overflow in `AcpiTbFindTable` via
  `LOAD_TABLE_OP`.
- **ASAN:** READ of size 6, 0 bytes past end of 49-byte region;
  reproducer `issue49.aml` via `acpiexec`.
- **Call chain:** `AcpiExLoadTableOp` → `AcpiTbFindTable` →
  `AcpiPsParseAml` → `AcpiNsLoadTable` → `AcpiLoadTables`.

### Step 4.4: Related Patches
**Record:** Same author has 13 other fixes in the series (integer
overflows, NULL checks, etc.). This patch is independent. Note:
`acpi_ds_eval_table_region_operands()` in `dsopcode.c` still passes raw
pointers to `acpi_tb_find_table()` — a separate, unfixed path not
addressed by this commit.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific fix. (Lore
stable search blocked by bot protection; b4 mbox had no stable
mentions.)

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `acpi_ex_load_table_op()` (modified), `acpi_tb_find_table()`
(caller of fixed behavior).

### Step 5.2: Callers
**Record:**
- `exoparg6.c:272` — `case AML_LOAD_TABLE_OP: status =
  acpi_ex_load_table_op(...)`
- Invoked during AML interpretation when `LoadTable()` opcode executes.

### Step 5.3: Callees
**Record:** `acpi_ut_create_integer_object()`, `acpi_tb_find_table()`,
`acpi_ex_add_table()`, namespace/scope operations.

### Step 5.4: Reachability
**Record:**
- **Boot:** ACPI table loading/parsing (`acpi_load_tables()` → namespace
  load → AML parse).
- **Runtime:** `acpi_load_table()` API (e.g., `acpi_configfs.c` for
  root-loaded SSDTs).
- **Trigger:** Malformed/crafted ACPI AML containing `LoadTable()` with
  undersized OEM ID/Table ID string operands.
- **Userspace reachability:** Root can inject ACPI tables via configfs;
  firmware-supplied tables are the common case. Not directly triggerable
  by unprivileged users, but boot-time parsing of malicious firmware
  tables is a realistic attack surface.

### Step 5.5: Similar Patterns
**Record:** `dsopcode.c:507-509` (`acpi_ds_eval_table_region_operands`)
has the same raw-pointer pattern — unfixed by this commit. The 2015 BZ
1184 fix targeted `data_table_region` error handling but did not fix the
`LoadTable` opcode path addressed here.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current `exconfig.c` lines 108–110 pass raw operand
pointers:

```108:110:drivers/acpi/acpica/exconfig.c
        status = acpi_tb_find_table(operand[0]->string.pointer,
                                    operand[1]->string.pointer,
                                    operand[2]->string.pointer,
&table_index);
```

### Step 6.2: Backport Complications
**Record:** **Clean apply.** Cherry-pick tested successfully on
v6.18.44. No conflicts expected.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** `git log --grep="Enhance OEM"` on this branch
returns nothing. Mainline has `485829e6999b7`; 6.18.y does not.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **ACPI / ACPICA interpreter** — IMPORTANT. ACPI is on every
ACPI-enabled system; interpreter bugs affect boot and runtime ACPI
method execution.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; periodic ACPICA upstream syncs. Recent
6.18.y history is mostly copyright updates, not functional changes to
this path.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** All systems with `CONFIG_ACPI` on ACPI firmware or
dynamically loaded ACPI tables that execute `LoadTable()` AML with short
OEM strings.

### Step 8.2: Trigger Conditions
**Record:**
- **When:** ACPI AML interpretation executing `LoadTable(Sig, OEMID,
  OEMTableID, ...)`.
- **Condition:** OEM ID string operand length < 6 bytes, or OEM Table ID
  < 8 bytes.
- **Likelihood:** Uncommon in legitimate firmware (OEM fields are
  typically padded to full size), but trivially reproducible with
  crafted AML (confirmed by upstream reproducer).
- **Privilege:** Root for dynamic table load; boot-time for firmware
  tables.

### Step 8.3: Failure Mode Severity
**Record:** Heap-buffer-overflow (read past allocation) → **HIGH**
severity. Can cause kernel oops/crash; potential info leak or further
memory corruption depending on heap layout. ASAN-confirmed.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — closes a confirmed memory-safety hole in ACPI
  interpreter.
- **Risk:** VERY LOW — 22 lines, single function, no API changes.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Confirmed heap-buffer-overflow with ASAN reproducer (ACPICA #1144)
- Bug exists in v6.18.44 tree (verified in source)
- Small, surgical, obviously correct fix
- Applies cleanly to 6.18.y
- Maintainer-merged on mainline
- Memory-safety issue in core ACPI interpreter path
- Self-contained (no series dependencies)

**AGAINST backport:**
- Trigger requires crafted/short OEM strings in `LoadTable` AML — rare
  in legitimate firmware
- Not directly exploitable by unprivileged users (requires root or
  malicious firmware)
- `dsopcode.c` data-table-region path has similar unfixed pattern (out
  of scope)

**Unresolved:**
- No explicit `Cc: stable` or reviewer stable nomination found
- Full lore thread review limited to b4-saved mbox (no replies captured)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — ASAN reproducer upstream;
   logic is straightforward.
2. Fixes a real bug affecting users? **PASS** — confirmed heap-buffer-
   overflow.
3. Important issue? **PASS** — memory-safety / potential crash (HIGH).
4. Small and contained? **PASS** — 1 file, ~22 lines.
5. No new features or APIs? **PASS** — validation/copy only.
6. Can apply to local tree? **PASS** — cherry-pick applies cleanly to
   v6.18.44.

### Step 9.3: Exception Categories
**Record:** N/A (not a device ID, quirk, DT, build, or docs fix —
standard bug fix).

### Step 9.4: Decision Rationale

This commit fixes a real, ASAN-confirmed heap-buffer-overflow in the
ACPI `LoadTable` opcode handler. The vulnerable code is present in Linux
6.18.y and has been since the function was introduced.
`acpi_tb_find_table()` unconditionally reads 6/8 bytes from OEM string
pointers, but AML string objects may be allocated with fewer bytes. The
fix validates lengths using the AML `.length` field and copies into
properly sized, null-terminated stack buffers before calling
`acpi_tb_find_table()`.

For 6.18.y stable users, this is exactly the kind of memory-safety fix
that belongs in -stable: small, contained, obviously correct, and
preventing a confirmed kernel memory corruption path during ACPI table
operations.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified buffer overflow fix
  intent
- [Phase 1] GitHub ACPICA issue #1144: ASAN heap-buffer-overflow,
  reproducer confirmed
- [Phase 2] Read diff: +24/-2 in `exconfig.c`, adds validation + safe
  copy
- [Phase 2] Read `tbfind.c:51-61`: `strlen` upper-bound check + fixed-
  size `memcpy` confirms over-read mechanism
- [Phase 2] Read `utobject.c:256-274`: string allocation is `string_size
  + 1` bytes
- [Phase 3] `git describe HEAD`: v6.18.44 (6.18.y stable)
- [Phase 3] `git blame exconfig.c:108-110`: vulnerable call since 2005
  (4be44fcd3bf648)
- [Phase 3] `git show 9f41fd8a175ff`: 2015 commit removed length
  validation from `acpi_ex_load_table_op`, did not fix short-string
  over-read
- [Phase 3] `git log --grep="Enhance OEM"` on 6.18.y: no results (fix
  absent)
- [Phase 3] `git show 485829e6999b7`: mainline commit confirmed
- [Phase 3] `git cherry-pick --no-commit 485829e6999b7`: applies cleanly
  (exit 0)
- [Phase 4] `b4 dig -c 485829e6999b7`: lore URL found
- [Phase 4] `b4 dig -a`: v1 series only, patch 22/27
- [Phase 4] `b4 dig -w`: Rafael Wysocki, linux-acpi, Intel developers
  CC'd
- [Phase 4] `b4 dig -m /tmp/acpica_thread.mbox`: thread saved; no
  stable/NAK mentions
- [Phase 5] `grep acpi_ex_load_table_op`: caller in `exoparg6.c:272`
  (`AML_LOAD_TABLE_OP`)
- [Phase 5] `grep acpi_load_table`: reachable via `acpi_configfs.c`,
  `bus.c`
- [Phase 6] Read current `exconfig.c:108-110`: buggy code confirmed
  present
- [Phase 6] Cherry-pick test: clean apply to v6.18.44
- [Phase 8] Failure mode: heap-buffer-overflow, severity HIGH

**YES**The background searches finished and match the earlier analysis:

- **Fix search:** No “Enhance OEM ID” commit on **6.18.y** — the fix is
  only on mainline (`485829e6999b7`).
- **Author search:** **ikaros** has other kernel commits here, but not
  this ACPI validation patch.

**Verdict for 6.18.y:** **YES** — backport the heap-buffer-overflow fix
in `acpi_ex_load_table_op()`; it applies cleanly.

 drivers/acpi/acpica/exconfig.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/exconfig.c b/drivers/acpi/acpica/exconfig.c
index 4d7dd0fc6b07b..894695db0cf94 100644
--- a/drivers/acpi/acpica/exconfig.c
+++ b/drivers/acpi/acpica/exconfig.c
@@ -90,6 +90,8 @@ acpi_ex_load_table_op(struct acpi_walk_state *walk_state,
 	union acpi_operand_object *return_obj;
 	union acpi_operand_object *ddb_handle;
 	u32 table_index;
+	char oem_id[ACPI_OEM_ID_SIZE + 1];
+	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE + 1];
 
 	ACPI_FUNCTION_TRACE(ex_load_table_op);
 
@@ -102,12 +104,32 @@ acpi_ex_load_table_op(struct acpi_walk_state *walk_state,
 
 	*return_desc = return_obj;
 
+	/*
+	 * Validate OEM ID and OEM Table ID string lengths.
+	 * acpi_tb_find_table expects strings that can safely read
+	 * ACPI_OEM_ID_SIZE and ACPI_OEM_TABLE_ID_SIZE bytes.
+	 */
+	if ((operand[1]->string.length > ACPI_OEM_ID_SIZE) ||
+	    (operand[2]->string.length > ACPI_OEM_TABLE_ID_SIZE)) {
+		return_ACPI_STATUS(AE_AML_STRING_LIMIT);
+	}
+
+	/*
+	 * Copy OEM strings to local buffers with guaranteed null-termination.
+	 * This prevents heap-buffer-overflow when acpi_tb_find_table reads
+	 * ACPI_OEM_ID_SIZE/ACPI_OEM_TABLE_ID_SIZE bytes.
+	 */
+	memcpy(oem_id, operand[1]->string.pointer, operand[1]->string.length);
+	oem_id[operand[1]->string.length] = 0;
+	memcpy(oem_table_id, operand[2]->string.pointer,
+	       operand[2]->string.length);
+	oem_table_id[operand[2]->string.length] = 0;
+
 	/* Find the ACPI table in the RSDT/XSDT */
 
 	acpi_ex_exit_interpreter();
 	status = acpi_tb_find_table(operand[0]->string.pointer,
-				    operand[1]->string.pointer,
-				    operand[2]->string.pointer, &table_index);
+				    oem_id, oem_table_id, &table_index);
 	acpi_ex_enter_interpreter();
 	if (ACPI_FAILURE(status)) {
 		if (status != AE_NOT_FOUND) {
-- 
2.53.0

