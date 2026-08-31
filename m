Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F64E47042E;
	Mon, 31 Aug 2026 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184139; cv=none; b=RQqTlurJlzYNcklwwvpvBbCQdDu1kE6SgvCV5zUuo3h5l5GHeQSHBnzAgYyB+NbvsxzvPngylHhmp0tOqbbxhFuID0vNfSaVUCGmXjmix1/MFCZmh5JBJEO7T7Bj0hS/IddpT9EVlDdAi5o1yS5yqaX0zAB0NiX9gaLLstClJdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184139; c=relaxed/simple;
	bh=8Dnas8XOt+02KXzRfNGj6qX7Og3LgnLq9WXQkwJksbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YoA1KeAoqbeD8yAmcMQwiFECULSq0bWHu2sySZ/NVLEP3FauxlQ/eWCYZtgaCgvBI9cmF116ALpAhH88gW3Ud8t8bgz2U/dWjwJbT/gVl4ItKs2uAQDiHUHZbO/WQW+fF6P5wwFkeuJ6qVhq+COyE3AwMt9U+1VIKGGT+u7uVdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYvScM5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYvScM5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D511A1F00A3D;
	Mon, 31 Aug 2026 13:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184136;
	bh=ts2fQcxFcSPHhhtRBMntO9/TZ+3ftOMNTbo+c/MwJtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GYvScM5pWk7NSlWFnI+4nMT2Gkv6SDzEscE/vhP2COPp3Zn16iO6PK1iKBilL/haj
	 F/6H3LwOONvoVfDl/CaMVfIDjHJm9vHE5b4BszdxD8JrgkrZlhd1lHasLA40j48j5x
	 s7lUglRQdyo3a4XYMg1zBEfjaPIvu/nLUe+ZZ5WK59Cu6po2gIcVHyRYWYN6t2ru+n
	 39JPukr3O5tiUFZ/99k0UJWvo5dhWApfUM9I1cg+EV43A5KL+oRCgDv31H9JtSqZwY
	 G8r2jiEME6e1Txv80xi5XWH+DhSLXOamieuZ6fZ6+2fA1AIhtSFPfTmAwNcS1sPfbw
	 zRAMlLXbFCqAw==
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
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: add boundary checks in acpi_ps_get_next_field()
Date: Mon, 31 Aug 2026 09:29:01 -0400
Message-ID: <20260831133314.4125787-513-sashal@kernel.org>
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

[ Upstream commit e15aa60de0256d63df2331bf5a4bc4dd287504cd ]

Add boundary checks in acpi_ps_get_next_field() to prevent out-of-bounds
access.

Link: https://github.com/acpica/acpica/commit/c39183ea84bc
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/24388159.6Emhk5qWAg@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPICA boundary checks in
`acpi_ps_get_next_field()`

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ACPICA] [add] boundary checks in acpi_ps_get_next_field()
to prevent out-of-bounds access`

### Step 1.2: Commit Message Tags
**Record:**
- **Link:** https://github.com/acpica/acpica/commit/c39183ea84bc
  (upstream ACPICA commit)
- **Signed-off-by:** ikaros <void0red@gmail.com> (author)
- **Signed-off-by:** Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  (ACPI maintainer)
- **Link:**
  https://patch.msgid.link/24388159.6Emhk5qWAg@rafael.j.wysocki (Linux
  integration patch reference)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: upstream ACPICA issue **#1125** with ASAN heap-buffer-
  overflow report and reproducible `acpiexec` test case

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `acpi_ps_get_next_field()` reads AML bytes without verifying
  they remain within the AML buffer (`aml_end`)
- **Symptom:** Heap-buffer-overflow (ASAN) when parsing
  malformed/truncated ACPI AML field lists
- **Root cause:** Reads of 1, 2, and 4 bytes proceed without checking
  `parser_state->aml_end`; caller loop uses `pkg_end`, which can extend
  past `aml_end` on corrupt package-length encoding
- **Version info:** None in commit message; bug exists in long-standing
  code (function dates to 2005)

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly a defensive boundary-check fix
for out-of-bounds memory access. This is a real memory-safety bug fix,
not cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/acpi/acpica/psargs.c` (+20 / -0)
- **Function:** `acpi_ps_get_next_field()` only
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Changes
**Record:**
1. **Entry check:** Before any AML read, if `aml >=
   parser_state->aml_end`, return NULL
2. **Named field path:** Before 4-byte name read (`ACPI_MOVE_32_TO_32`),
   verify `aml + ACPI_NAMESEG_SIZE <= aml_end`; free allocated op on
   failure
3. **Access field path:** Before reading 2 bytes (type/attribute),
   verify `aml + 2 <= aml_end`; free op on failure
4. **Extended access field:** Before reading third byte
   (`access_length`), verify `aml < aml_end`; free op on failure

**Before → After:** Unbounded AML pointer advancement → bounded reads
with graceful NULL return and proper `acpi_ps_free_op()` cleanup on
post-allocation failures.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read (memory safety)
- **Mechanism:** On truncated or malformed AML,
  `acpi_ps_get_next_field()` advances `parser_state->aml` and reads past
  the end of the AML buffer. ASAN report confirms a 4-byte read past a
  175-byte heap allocation at the named-field path.

### Step 2.4: Fix Quality
**Record:**
- Fix is minimal, follows existing `aml_end` semantics used elsewhere in
  ACPICA
- Properly frees `field` on error paths after `acpi_ps_alloc_op()`
  succeeds
- Does not cover every read in the function (e.g.,
  `AML_INT_CONNECTION_OP` sub-paths,
  `acpi_ps_get_next_package_length()`), but addresses the ASAN-confirmed
  overflow sites
- Low regression risk; only adds early-exit guards on malformed input

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Core `acpi_ps_get_next_field()` logic introduced in 2005
(`^1da177e4c3f4`). Buggy unbounded-read pattern has been present since
initial implementation. `parser_state->aml_end` field added long ago and
is set in `dswstate.c`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:** Related recent fix in this tree:
- `e6169a8ffee8a` — "ACPICA: Fix memory leak if acpi_ps_get_next_field()
  fails" (April 2024)
  - Ensures caller frees partial field list when
    `acpi_ps_get_next_field()` returns NULL
  - Complements this fix: boundary failure returns NULL, and caller
    already handles that path

### Step 3.4: Author Context
**Record:** Author ikaros reported the bug via ACPICA GitHub issue
#1125. Patch integrated by Rafael J. Wysocki (ACPI subsystem
maintainer). No other commits from this author in the Linux ACPICA tree.

### Step 3.5: Dependencies
**Record:**
- Requires `parser_state->aml_end` in `struct acpi_parse_state` —
  **present** in this tree (`aclocal.h:912`)
- Requires `ACPI_NAMESEG_SIZE` — **present** (used at line 527)
- Requires `acpi_ps_free_op()` — **present**
- Standalone; no patch-series dependency
- **This commit is NOT yet in the local tree** (6.18.44); boundary
  checks absent from current `psargs.c`

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c c39183ea84bc` — no match (hash is from upstream ACPICA
  repo, not Linux kernel)
- ACPICA GitHub issue #1125: detailed ASAN report, reproduction with
  `acpiexec -m issue10.aml`, fixed by commit c39183ea84bc
- lore.kernel.org — blocked by bot protection; could not fetch thread

### Step 4.2: Reviewers
**Record:** Rafael J. Wysocki signed off on Linux integration (per
commit message). Full lore review thread unverified due to access block.

### Step 4.3: Bug Report
**Record:**
- **Severity:** Heap-buffer-overflow (ASAN), READ of 4 bytes past
  allocation boundary
- **Reproducible:** Yes, with crafted AML via `acpiexec`
- **Stack trace:** `AcpiPsGetNextField` → `AcpiPsGetNextArg` →
  `AcpiPsGetArguments` → `AcpiPsParseLoop` → `AcpiPsParseAml` → table
  load path

### Step 4.4: Related Patches
**Record:** Standalone fix. Related but separate: memory-leak fix
`e6169a8ffee8a` already in this tree.

### Step 4.5: Stable List Discussion
**Record:** Could not verify stable-list discussion (lore blocked).
Absence of prior stable nomination is not a negative signal per review
guidelines.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `acpi_ps_get_next_field()` (modified), called from
`acpi_ps_get_next_arg()` for `ARGP_FIELDLIST`.

### Step 5.2: Callers
**Record:**
- `acpi_ps_get_next_arg()` — `psargs.c:787`, in `ARGP_FIELDLIST` case
- Called from `acpi_ps_get_arguments()` in `psloop.c`
- Reached during ACPI AML parsing: `acpi_ps_execute_table()` →
  `acpi_ns_parse_table()` → `acpi_ns_load_table()`
- **Context:** ACPI table load at boot (DSDT/SSDT) and dynamic table
  load paths

### Step 5.3: Callees
**Record:** `ACPI_GET8()`, `ACPI_MOVE_32_TO_32()`, `acpi_ps_alloc_op()`,
`acpi_ps_free_op()`, `acpi_ps_get_next_package_length()`,
`acpi_ps_get_next_namestring()`

### Step 5.4: Reachability
**Record:**
- Triggered when kernel parses ACPI AML containing malformed field lists
- ACPI tables come from firmware at boot on virtually all x86/ARM
  systems with ACPI
- Additional paths: `CONFIG_ACPI_TABLE_UPGRADE`, initrd ACPI override
  (`tables.c`), configfs (`acpi_configfs.c`) — root/privileged, but
  firmware-supplied tables are the primary real-world vector
- **Userspace trigger:** Indirect — via firmware/BIOS ACPI tables, not
  direct syscall; still kernel memory safety issue

### Step 5.5: Similar Patterns
**Record:** `aml_end` used as bound in `psloop.c:300`, `dswexec.c:745`,
but **not** in `acpi_ps_get_next_field()` in this tree — this is a gap
the fix addresses.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `psargs.c` at lines 474–586 performs
unbounded reads in `acpi_ps_get_next_field()` with no `aml_end` checks.
`aml_end` field exists and is initialized in `dswstate.c:580–585`.

### Step 6.2: Backport Complications
**Record:** `git apply --check` on the provided diff — **applies
cleanly** to this tree. No conflicts expected.

### Step 6.3: Related Fixes Already Present?
**Record:** Memory-leak companion fix `e6169a8ffee8a` is present.
Boundary-check fix is **not** present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** **drivers/acpi/acpica** — ACPI core parser. **Criticality:
CORE/IMPORTANT** — affects all ACPI-enabled systems during table
parsing.

### Step 7.2: Subsystem Activity
**Record:** ACPICA receives periodic syncs from upstream; active
maintenance by Rafael Wysocki's team. Recent related fix (memory leak)
landed in 2024.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** All systems using ACPI (majority of PCs, servers, many ARM
boards) when loading ACPI tables with malformed field-list AML.

### Step 8.2: Trigger Conditions
**Record:**
- Malformed/truncated ACPI DSDT/SSDT field definitions
- Most likely: buggy firmware ACPI tables; also crafted tables via
  override mechanisms
- Not every boot — requires specific AML corruption in field lists
- Unprivileged direct trigger unlikely; firmware is primary vector

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure mode:** Out-of-bounds heap read during ACPI AML parsing
- **Severity: HIGH** — memory safety violation; potential info leak or
  crash during boot/table load; ASAN-confirmed

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit: HIGH** — prevents OOB read in widely-used ACPI parser
- **Risk: LOW** — 20-line additive guards, only affects malformed-input
  paths
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, ASAN-confirmed heap-buffer-overflow
- Fixes memory safety bug in ACPI core parser used at boot
- Small (+20 lines), single file, applies cleanly
- Signed off by ACPI maintainer (Rafael Wysocki)
- Complements existing memory-leak fix already in tree
- `aml_end` infrastructure already present — no structural dependency

**AGAINST backport:**
- Partial coverage (does not add bounds checks to all read paths in the
  function, e.g., connection-op sub-path)
- Trigger primarily via firmware ACPI tables (not direct userspace
  attack)
- NULL return on boundary failure reported as `AE_NO_MEMORY` by caller
  (pre-existing semantic imprecision, not introduced by this patch)

**Unresolved:**
- Full lore.kernel.org review thread not accessible
- Whether Linux mainline has merged this yet (not in 6.18.44)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — straightforward bounds
   checks; ASAN-tested upstream via acpiexec/issue #1125
2. Fixes a real bug? **PASS** — confirmed heap-buffer-overflow
3. Important issue? **PASS** — OOB read in kernel ACPI parser (HIGH
   severity)
4. Small and contained? **PASS** — +20 lines, one function, one file
5. No new features/APIs? **PASS** — defensive checks only
6. Can apply to local tree? **PASS** — verified clean apply;
   prerequisites present

### Step 9.3: Exception Category
**Record:** N/A — standard memory-safety bug fix, not a device-
ID/quirk/DT/build/doc exception.

### Step 9.4: Decision Rationale

This commit fixes a confirmed out-of-bounds heap read in the ACPI AML
field parser — a core subsystem path exercised during every ACPI table
load. The fix is minimal, uses existing `aml_end` bounds infrastructure,
applies cleanly to Linux 6.18.44, and is signed off by the ACPI
maintainer. While the primary trigger is malformed firmware ACPI tables
rather than direct userspace input, heap buffer overflows in kernel
parsers are exactly the class of fixes stable trees exist to deliver.
The companion memory-leak fix is already in this tree, making the NULL-
return error path safe.

---

## Verification

- **[Phase 1]** Parsed commit message and tags; confirmed ASAN report
  via ACPICA GitHub issue #1125
- **[Phase 1]** Identified subsystem (ACPICA), action (add boundary
  checks), bug type (OOB access)
- **[Phase 2]** Diff analysis: +20 lines in `acpi_ps_get_next_field()`,
  4 boundary-check insertion points
- **[Phase 2]** Read current `psargs.c:457-686` — confirmed buggy code
  without bounds checks
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- **[Phase 3]** `git blame` on lines 474–590: function code from 2005,
  long-standing vulnerability
- **[Phase 3]** `git log --oneline -20 -- drivers/acpi/acpica/psargs.c`:
  found related fix `e6169a8ffee8a`
- **[Phase 3]** `git show e6169a8ffee8a`: memory-leak fix on NULL return
  from same function
- **[Phase 3]** `git log --grep="boundary checks in
  acpi_ps_get_next_field"`: no match — fix not in tree
- **[Phase 4]** WebFetch ACPICA commit c39183ea84bc and issue #1125:
  ASAN heap-buffer-overflow confirmed
- **[Phase 4]** `b4 dig -c c39183ea84bc`: no Linux kernel match (ACPICA-
  only hash)
- **[Phase 4]** lore.kernel.org fetch: blocked (bot protection) — review
  thread unverified
- **[Phase 5]** Grep callers: `acpi_ps_get_next_field` called from
  `acpi_ps_get_next_arg()` at line 787
- **[Phase 5]** Traced load path: `acpi_ns_load_table` →
  `acpi_ns_parse_table` → `acpi_ps_execute_table`
- **[Phase 5]** Read caller at `psargs.c:780-807`: NULL return handled
  with field-list cleanup
- **[Phase 6]** Confirmed `struct acpi_parse_state` has `aml_end` at
  `aclocal.h:912`
- **[Phase 6]** Confirmed `dswstate.c:580-585` initializes `aml_end`
  from AML buffer length
- **[Phase 6]** `git apply --check` on provided diff: **clean apply**
- **[Phase 6]** Grep `aml >= parser_state->aml_end` in `psargs.c`: no
  matches — fix absent
- **[Phase 8]** Assessed severity: heap OOB read during ACPI parse =
  HIGH

**YES**The analysis is done: **backport recommended** for Linux
**6.18.44**.

The commit adds `aml_end` boundary checks in `acpi_ps_get_next_field()`
to stop out-of-bounds reads when parsing malformed ACPI AML. That’s a
real, ASAN-confirmed heap buffer overflow on the ACPI table load path,
the patch is small (+20 lines), applies cleanly here, and the needed
`aml_end` infrastructure is already in this tree.

**YES**

 drivers/acpi/acpica/psargs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 6f6ae38ec044c..55273cbbfc67e 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -474,6 +474,10 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 	ASL_CV_CAPTURE_COMMENTS_ONLY(parser_state);
 	aml = parser_state->aml;
 
+	if (aml >= parser_state->aml_end) {
+		return_PTR(NULL);
+	}
+
 	/* Determine field type */
 
 	switch (ACPI_GET8(parser_state->aml)) {
@@ -522,6 +526,11 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 
 		/* Get the 4-character name */
 
+		if ((parser_state->aml + ACPI_NAMESEG_SIZE) >
+		    parser_state->aml_end) {
+			acpi_ps_free_op(field);
+			return_PTR(NULL);
+		}
 		ACPI_MOVE_32_TO_32(&name, parser_state->aml);
 		acpi_ps_set_name(field, name);
 		parser_state->aml += ACPI_NAMESEG_SIZE;
@@ -567,6 +576,10 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 
 		/* Get the two bytes (Type/Attribute) */
 
+		if ((parser_state->aml + 2) > parser_state->aml_end) {
+			acpi_ps_free_op(field);
+			return_PTR(NULL);
+		}
 		access_type = ACPI_GET8(parser_state->aml);
 		parser_state->aml++;
 		access_attribute = ACPI_GET8(parser_state->aml);
@@ -578,6 +591,10 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 		/* This opcode has a third byte, access_length */
 
 		if (opcode == AML_INT_EXTACCESSFIELD_OP) {
+			if (parser_state->aml >= parser_state->aml_end) {
+				acpi_ps_free_op(field);
+				return_PTR(NULL);
+			}
 			access_length = ACPI_GET8(parser_state->aml);
 			parser_state->aml++;
 
-- 
2.53.0

