Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD9446074;
	Mon, 31 Aug 2026 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183601; cv=none; b=tihJ9+X0qQz3/sHToRUkcrceIR7LWYG9ULC9GBKHLZKSGDgawLojKaehb+IgORMIMpmuoFdxXMTUzM5lM2b67tEW8J/pCGY4t6LcIinLCZ4xH7c9YE4QuS5dIu9et512JYx5thGt7GylHvpkHopAD6pD5us3O1pSmp+oKByU2Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183601; c=relaxed/simple;
	bh=r8dkcLNr5q9v4O/kFqzMa0nfADSurC5aXyTF/Z5tkH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qf2jrbEk19Kje0xI2JIJhXwNnVZax6hS/boW5wyEErPbWb/AkdCxKj9gzx1c7TrdZ2MYM5C1QkDpG1qALyN3uYx3ZsewDwItbC/9A0wVod1WeLWFdQh/PsFF96PpZJxaVWjQ6GGpfRBObZrVG9/pl7hyeruJsS9IGm9TEs8Vfpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgKJ8abu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgKJ8abu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4A41F00ACA;
	Mon, 31 Aug 2026 13:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183598;
	bh=rwB2YCCBSkSa7ALLQYruPF6qOCUg1uuofODiN2yR2qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgKJ8abuCIeo26N0C0ygBqJWsSkxT6nQK9+oHLHVVO64se7epwcB+vF5FkE3DtOdH
	 52m1+MdDCs5tlgtrzPBkSs9bH7YqML+wGZAkueq5E6UwIGMVjPz3Mp0AanTsOKP4jY
	 mOVNmqW+8BtMSgXnQGn2sXcrxjb9oKeYsmTJlRQYVLjw2MapZY/2Qpdz801r5RnqXR
	 baenAoVr+vN71jXvZVVZFYZ3e/eUI3K3M2jBf3T7yjF1L661rhXkX5zsKZF9uYT7SM
	 JxNLaC7rbqStDjsXuG5VLO/5pwqxtt8cG5vm989jq3yVLwqiCqhVmi+WhdO3xjrQ4f
	 +Vh3wwlQ7TRxA==
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
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Fix condition check in acpi_ps_parse_loop()
Date: Mon, 31 Aug 2026 09:23:38 -0400
Message-ID: <20260831133314.4125787-190-sashal@kernel.org>
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

[ Upstream commit 8de27e2d83c0d07ae9443c6304575b0609394bfd ]

Fix condition check for AML_ELSE_OP in acpi_ps_parse_loop() to prevent
out-of-bounds access.

Link: https://github.com/acpica/acpica/commit/3b537b92336e
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1959692.tdWV9SEqCh@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPICA Fix condition check in
acpi_ps_parse_loop()

**Local tree:** `stable/linux-6.18.y` at `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ACPICA]` `[Fix]` — correct the `AML_ELSE_OP` condition
check in `acpi_ps_parse_loop()` to prevent out-of-bounds access.

### Step 1.2: Commit Message Tags
**Record:**
- **Link:** https://github.com/acpica/acpica/commit/3b537b92336e
  (upstream ACPICA commit)
- **Signed-off-by:** ikaros <void0red@gmail.com> (author)
- **Signed-off-by:** Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  (ACPI maintainer)
- **Link:** https://patch.msgid.link/1959692.tdWV9SEqCh@rafael.j.wysocki
  (kernel submission; could not fetch — Anubis bot protection)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: Rafael Wysocki sign-off indicates ACPI maintainer acceptance
  for kernel integration

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** After skipping a failed If/While block, the code checks
  `*walk_state->aml == AML_ELSE_OP` without verifying `walk_state->aml`
  is within the AML buffer.
- **Symptom:** Out-of-bounds read (1 byte past buffer end).
- **Root cause:** `acpi_ps_get_next_package_end()` can advance the AML
  pointer to or past `parser_state->aml_end` on malformed/truncated AML;
  the subsequent dereference is unchecked.
- **Version info:** None in commit message; upstream ACPICA issue #1078
  documents ASan reproduction.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly labeled a fix for an out-of-
bounds access. Genuine memory-safety bug fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/acpi/acpica/psloop.c` (+3 / -1 lines)
- **Function:** `acpi_ps_parse_loop()`
- **Scope:** Single-file, surgical fix in an error-recovery path

### Step 2.2: Code Flow Change
**Record:**
- **Before:** After skipping a failed If/While body, unconditionally
  dereferenced `*walk_state->aml` to test for `AML_ELSE_OP`.
- **After:** Only dereferences if `walk_state->aml <
  parser_state->aml_end` AND the byte equals `AML_ELSE_OP`.
- **Path affected:** Error recovery when `acpi_ps_get_arguments()` fails
  inside an If/While control structure during module-level ACPI table
  parsing.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read (memory safety)
- **Mechanism:** `acpi_ps_get_next_package_end()` returns a pointer past
  the package end. On malformed AML at the buffer boundary,
  `walk_state->aml` can equal or exceed `parser_state->aml_end`. The old
  code read one byte past the allocated AML buffer. The fix adds the
  same bounds guard used by the main parse loop at line 300.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct; mirrors the existing
  `parser_state->aml < parser_state->aml_end` pattern at line 300.
- **Regression risk:** Very low — only skips the Else-block skip when
  already past the buffer end (correct behavior).
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy line introduced in `5088814a6e931` ("ACPICA: AML
parser: attempt to continue loading table after error") by Erik Kaneda,
2018-06-01. Confirmed ancestor of HEAD. Present in `v6.18.44`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag. Upstream ACPICA issue #1078
references the bug; the introducing commit is `5088814a6e931` (2018).

### Step 3.3: Related File History
**Record:** Recent `psloop.c` history is copyright updates and unrelated
parser cleanups. No prior fix for this issue in this tree. The Else-skip
logic has been unchanged since 2018.

### Step 3.4: Author Context
**Record:** Author ikaros (void0red) reported the bug via ACPICA
fuzzing. Rafael Wysocki (ACPI maintainer) signed off. ACPICA maintainer
SaketADumbre merged upstream PR #1087 with positive review ("minimal but
the right changes").

### Step 3.5: Dependencies
**Record:** No dependencies. Standalone 3-line fix. No patch series.
Applies cleanly to current `psloop.c` in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 3b537b92336e` failed — commit not in Linux git
history (ACPICA-only commit). Upstream discussion found at:
- ACPICA issue #1078: ASan heap-buffer-overflow at `psloop.c:569`
  (fuzzed AML via `acpiexec`)
- ACPICA PR #1087: merged 2026-02-21
- Kernel lore/patch.msgid.link blocked by Anubis — could not read thread

### Step 4.2: Reviewers
**Record:** Rafael Wysocki signed off (kernel ACPI maintainer).
SaketADumbre (ACPICA maintainer) reviewed and merged upstream. No NAKs
found.

### Step 4.3: Bug Report
**Record:** ACPICA issue #1078 — ASan READ of size 1 at address 0 bytes
past a 1293-byte heap region. Reproducible with fuzzed AML
(`fuzz_178.aml`). Severity: confirmed memory safety bug via sanitizer.

### Step 4.4: Related Patches
**Record:** Standalone fix. Not part of a multi-patch series.

### Step 4.5: Stable Mailing List
**Record:** Could not search lore (Anubis protection). No stable-
specific discussion found via other sources.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `acpi_ps_parse_loop()` — modified.
`acpi_ps_get_next_package_end()` — called just before the buggy check.

### Step 5.2: Callers
**Record:** `acpi_ps_parse_loop()` called from `acpi_ps_parse_aml()` in
`psparse.c:475`. Reachable during ACPI table loading and method
execution.

### Step 5.3: Callees
**Record:** `acpi_ps_get_arguments()`, `acpi_ps_complete_op()`,
`acpi_ps_get_next_package_end()`, `acpi_ut_pop_generic_state()`.

### Step 5.4: Call Chain (Reachability)
**Record:**
```
Boot: acpi_ns_load_table() → acpi_ns_parse_table() →
acpi_ns_execute_table()
  → acpi_ps_execute_table() [sets ACPI_METHOD_MODULE_LEVEL]
  → acpi_ps_parse_aml() → acpi_ps_parse_loop()
```
Module-level ACPI table parsing (DSDT/SSDT) uses this error-recovery
path. Malformed firmware AML that fails If/While argument parsing can
reach the buggy dereference. **Reachable during boot on all ACPI-enabled
systems.**

### Step 5.5: Similar Patterns
**Record:** Main parse loop at line 300 uses `parser_state->aml <
parser_state->aml_end`. The Else check at line 428 was the only
unguarded dereference in this error path. No similar fix already present
in this tree (`git log -S 'walk_state->aml <'` returned nothing).

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Line 428 in `drivers/acpi/acpica/psloop.c` has the
unguarded `if (*walk_state->aml == AML_ELSE_OP)`. Confirmed in
`v6.18.44` tag. Bug present since 2018 (commit `5088814a6e931`).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** File structure unchanged around
the hunk. No conflicting recent changes in this area.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** Fix not in this tree. `grep` for the bounds-check
pattern returns no matches.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **ACPI / ACPICA** — **CORE**. ACPI table parsing runs at
boot on essentially all x86 and many ARM systems. Affects firmware table
loading.

### Step 7.2: Subsystem Activity
**Record:** Active — regular ACPICA syncs and copyright updates, but
this code path has been stable since 2018.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** All systems with ACPI enabled that load AML tables
containing If/While constructs. Trigger requires malformed ACPI AML
(common in buggy firmware) combined with a parse failure in the If/While
predicate.

### Step 8.2: Trigger Conditions
**Record:**
- If/While argument parsing fails during module-level table load
- `acpi_ps_get_next_package_end()` advances AML pointer to or past
  buffer end
- Unprivileged users cannot directly inject ACPI tables, but **malicious
  or buggy firmware ACPI tables** can trigger this at boot
- Likelihood: Low in practice, but the error-recovery path exists
  specifically for malformed AML

### Step 8.3: Failure Mode Severity
**Record:** Out-of-bounds read of 1 byte past AML buffer. **Severity:
HIGH** — potential kernel oops/crash or information leak. ASan-confirmed
heap-buffer-overflow.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents OOB read in core ACPI parser on malformed
  firmware tables
- **Risk:** VERY LOW — 3-line bounds check matching existing code
  pattern
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, ASan-confirmed out-of-bounds read
- Small (3 lines), obviously correct fix
- Bug present in this tree since 2018
- Affects core ACPI table loading at boot
- ACPI maintainer (Rafael Wysocki) signed off
- No dependencies; clean apply
- Error-recovery path designed for malformed AML — exactly when this bug
  triggers

**AGAINST backport:**
- Found via acpiexec fuzzing, not a reported production kernel crash
- Requires malformed ACPI + specific parse failure (narrow trigger)
- ACPI tables come from firmware, not direct userspace input (reduced
  attack surface, but buggy firmware is common)

**UNRESOLVED:**
- Kernel lore thread content (Anubis blocked)
- Whether any production kernel crash has been attributed to this
  specific bug

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — matches existing bounds-
   check pattern; ASan-verified fix upstream
2. Fixes a real bug? **PASS** — confirmed OOB read
3. Important issue? **PASS** — memory safety in core boot path (HIGH)
4. Small and contained? **PASS** — 3 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code confirmed present,
   clean apply expected

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not a device ID/quirk/DT/build/doc
exception.

### Step 9.4: Decision Rationale

This commit fixes a genuine out-of-bounds read in the ACPI AML parser's
error-recovery path. The bug has existed since 2018 and is present in
the local `6.18.44` tree. While the trigger requires malformed ACPI AML
with a failed If/While parse, that is precisely the scenario the 2018
error-recovery code was written to handle — and buggy ACPI firmware is a
known real-world problem. The fix is minimal, mirrors an existing bounds
check in the same function, and carries negligible regression risk.
Memory-safety fixes in core boot-path code are appropriate for stable
trees.

---

## Verification

- **[Phase 1]** Parsed commit message: subsystem ACPICA, action "Fix",
  OOB access described; Rafael Wysocki SOB confirmed
- **[Phase 1]** No Reported-by/syzbot; upstream ACPICA issue #1078
  provides bug report
- **[Phase 2]** Diff: +3/-1 in `psloop.c`, adds `walk_state->aml <
  parser_state->aml_end` guard before `AML_ELSE_OP` check
- **[Phase 3]** `git blame -L 428,428`: buggy line from `5088814a6e931`
  (2018-06-01)
- **[Phase 3]** `git show 5088814a6e931`: introduced Else-skip logic
  without bounds check
- **[Phase 3]** `git merge-base --is-ancestor 5088814a6e931 HEAD`:
  confirmed buggy commit in tree
- **[Phase 3]** `git log --oneline -20 -- drivers/acpi/acpica/psloop.c`:
  no prior fix for this issue
- **[Phase 3]** `git log -S 'walk_state->aml <' --
  drivers/acpi/acpica/`: no similar fix already applied
- **[Phase 4]** `b4 dig -c 3b537b92336e`: FAILED — commit not in Linux
  git
- **[Phase 4]** ACPICA issue #1078: ASan heap-buffer-overflow confirmed
  at psloop.c
- **[Phase 4]** ACPICA PR #1087: merged, maintainer approved minimal fix
- **[Phase 4]** lore.kernel.org / patch.msgid.link: BLOCKED by Anubis —
  UNVERIFIED for kernel list discussion
- **[Phase 5]** `acpi_ps_parse_loop` callers: `psparse.c:475` via
  `acpi_ps_parse_aml`
- **[Phase 5]** Call chain: `acpi_ns_parse_table` →
  `acpi_ns_execute_table` → `acpi_ps_execute_table` (sets
  `ACPI_METHOD_MODULE_LEVEL`) → `acpi_ps_parse_loop`
- **[Phase 5]** `nsparse.c:98`: `ACPI_METHOD_MODULE_LEVEL` set during
  table execution
- **[Phase 6]** `git describe HEAD`: v6.18.44 on `stable/linux-6.18.y`
- **[Phase 6]** `git show v6.18.44:drivers/acpi/acpica/psloop.c` lines
  426-432: buggy unguarded check confirmed
- **[Phase 6]** `grep` for fix pattern in tree: no matches — fix not
  present
- **[Phase 8]** Failure mode: OOB read, severity HIGH; trigger on
  malformed ACPI during boot table load

**YES**

 drivers/acpi/acpica/psloop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/psloop.c b/drivers/acpi/acpica/psloop.c
index c989cadf271ce..35111ff2526b1 100644
--- a/drivers/acpi/acpica/psloop.c
+++ b/drivers/acpi/acpica/psloop.c
@@ -425,7 +425,10 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 
 					ACPI_ERROR((AE_INFO,
 						    "Skipping While/If block"));
-					if (*walk_state->aml == AML_ELSE_OP) {
+					if ((walk_state->aml <
+					     parser_state->aml_end)
+					    && (*walk_state->aml ==
+						AML_ELSE_OP)) {
 						ACPI_ERROR((AE_INFO,
 							    "Skipping Else block"));
 						walk_state->parser_state.aml =
-- 
2.53.0

