Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A94546F483;
	Mon, 31 Aug 2026 13:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184122; cv=none; b=mh1YD22Y6lb5Fm4W7ST3fGCuXZIYPUd/eFNzQbgqRU7cMDQAxrNdU2lkFeGXxOhJHnnCcO3mLuxnGZv8k8ogVIpfxYEi9EMzuAsX6Blz5fRzs4InRFlnT2DjdeJcyGJzQWE52bG0d9u0OnXh4p8LIQPPgcCOaNLOetwx1Kg69XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184122; c=relaxed/simple;
	bh=E40eJRUesULlNN79L6psJzUyWkRZFuSRM+KE8fyEmKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p6QzBm+t5b+UzmWutoOXGeHKC/vUPnvEm3syGHOmTKWdJDRFv6EXhSKXT9YNbprp+oR+tqQkdzJDqK/R0QUhqpEzII9dVqFWHW1zNtKU+vRP8JEEsc9N+h+uyNZ/ErYS1vNoq9eXyhDxbCpN9+3WQX2uLMvMtS0kZ8v8U0aF8qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nabQVVYq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nabQVVYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0991F00A3F;
	Mon, 31 Aug 2026 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184117;
	bh=DdVo6N7K5a2KSV3VcTuiLIDHoWMhDvu1DsKU74vcPz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nabQVVYq9Ya4iArAgOgLLlADWGNsmLdhkiTaBCFwZfFpOzFKg60KVXGht3jDp3EvL
	 ejEjSaOkmhlc9nPaxo47phOFm/GMJzckbEq8Ph8biv+0La2/3RWs/Nn3PJVnkj/Z6U
	 DcId/4j6EKPzadmz1I79xkuAcFgOwWwQJePIOEeaq9La17SSYnrPirXMNbofHfKo98
	 hPB0zRCR5HeblfXBy53f4JlPsC6EcZytSASzXWngyMt7wKlmJSiLFhDSStBKDst2if
	 /odXPqTWVOo7cMsQAWLsmrAcluzC4yixdXgFVjR+Jl6OQtPwV5OQ7s5Hhqp8Vs6Eyx
	 Aueu363LhOhqA==
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
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Add validation for node in acpi_ns_build_normalized_path()
Date: Mon, 31 Aug 2026 09:28:50 -0400
Message-ID: <20260831133314.4125787-502-sashal@kernel.org>
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

[ Upstream commit 96b2b616870e46e2bc04efec03879683a0036e66 ]

Add validation for node in acpi_ns_build_normalized_path()
to prevent use-after-free vulnerabilities.

Link: https://github.com/acpica/acpica/commit/b35adf49e89a
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/118666237.nniJfEyVGO@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[ACPICA] [Add] validation for node in
acpi_ns_build_normalized_path() to prevent use-after-free`

**Step 1.2 — Tags**
Record:
- Link: https://github.com/acpica/acpica/commit/b35adf49e89a
- Link: https://patch.msgid.link/118666237.nniJfEyVGO@rafael.j.wysocki
- Signed-off-by: ikaros \<void0red@gmail.com\>
- Signed-off-by: Rafael J. Wysocki \<rafael.j.wysocki@intel.com\>
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, or Cc: stable tags
- Notable: ACPICA maintainer (Rafael J. Wysocki) signed off; upstream
  ACPICA commit link present

**Step 1.3 — Body analysis**
Record:
- Bug: `acpi_ns_build_normalized_path()` can dereference an
  invalid/freed namespace node pointer
- Symptom: heap use-after-free when reading `next_node->name`
- Root cause (from upstream issue #1138): during ACPI AML
  parsing/cleanup, walk state is freed while a stale `method_node` is
  still passed into pathname building via `acpi_ex_stop_trace_method()`
  → `acpi_ns_get_normalized_pathname()` →
  `acpi_ns_build_normalized_path()`
- No kernel version range stated in commit message

**Step 1.4 — Hidden bug fix?**
Record: No — explicitly described as UAF prevention, not disguised
cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- `drivers/acpi/acpica/nsnames.c`: +6 lines, 0 removed
- Function modified: `acpi_ns_build_normalized_path()`
- Scope: single-file, surgical fix

**Step 2.2 — Code flow change**
Record:
- Before: after NULL check on `node`, function immediately walks
  `next_node->parent` chain and reads `next_node->name` via
  `ACPI_MOVE_32_TO_32`
- After: if `ACPI_GET_DESCRIPTOR_TYPE(node) != ACPI_DESC_TYPE_NAMED`,
  jump to `build_trailing_null` (return empty path with trailing NUL)
  instead of dereferencing
- Affected path: any caller passing a stale/invalid node into
  `acpi_ns_build_normalized_path()`

**Step 2.3 — Bug mechanism**
Record:
- Category: **memory safety / use-after-free**
- Mechanism: freed walk-state memory is still referenced as a namespace
  node; reading `next_node->name` at the line equivalent to current line
  232 triggers ASAN heap-use-after-free (confirmed upstream in ACPICA
  issue #1138)

**Step 2.4 — Fix quality**
Record:
- Obviously correct: matches existing ACPICA validation pattern used in
  `acpi_ns_get_pathname_length()` (lines 56–63 of the same file),
  `acpi_ns_validate_handle()`, and `acpi_ut_get_node_name()`
- Minimal, no unrelated changes
- Regression risk: very low — invalid nodes get empty path instead of
  crash; valid nodes unchanged

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: vulnerable loop introduced in `d1e7ffe50ba58` (2015, "ACPICA:
Namespace: Add function to directly return normalized full path"). Bug
has been present since that function was added.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag in commit message.

**Step 3.3 — File history**
Record: `nsnames.c` is long-stable ACPI code; recent changes are
formatting/copyright, not structural refactors. Fix is standalone (not
dependent on other patches in the 27-patch ACPICA series).

**Step 3.4 — Author**
Record: ikaros (void0red) reported the UAF to upstream ACPICA; Rafael J.
Wysocki (ACPI maintainer) committed to Linux.

**Step 3.5 — Dependencies**
Record: no prerequisites. Patch 12/27 in the same series fixes a related
UAF in `acpi_ds_terminate_control_method()`, but this validation patch
is independent and self-contained. `git apply --check` confirms clean
apply to this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- b4 dig found: [PATCH v1 19/27] at
  https://patch.msgid.link/118666237.nniJfEyVGO@rafael.j.wysocki
- Part of "ACPI: ACPICA 20260408" series (27 patches)
- v1 only revision found
- No NAKs or stable nominations found in thread mbox

**Step 4.2 — Reviewers**
Record: CC'd to Rafael J. Wysocki, linux-acpi, LKML, Saket Dumbre, Pawel
Chmielewski (Intel ACPICA developers).

**Step 4.3 — Bug report**
Record: ACPICA GitHub issue #1138 documents:
- ASAN heap-use-after-free at `AcpiNsBuildNormalizedPath` reading 4
  bytes (`next_node->name`)
- Reproducer: `./generate/unix/bin/acpiexec -m issue33.aml`
- Call chain: `acpi_ns_build_normalized_path` ←
  `acpi_ns_get_normalized_pathname` ← `acpi_ex_stop_trace_method` ←
  `acpi_ds_terminate_control_method` ← AML parse/table load path
- Severity: confirmed memory safety bug with concrete reproducer

**Step 4.4 — Related patches**
Record: patch 12/27 addresses a different UAF root cause in
`acpi_ds_terminate_control_method()`. Patch 19/27 (this commit) is a
defensive guard at the common pathname builder. Both are security-
relevant; this one stands alone.

**Step 4.5 — Stable list**
Record: no Cc: stable discussion found in downloaded thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `acpi_ns_build_normalized_path()` (modified); callers include
`acpi_ns_get_pathname_length()`, `acpi_ns_handle_to_pathname()`,
`acpi_ns_get_normalized_pathname()`

**Step 5.2 — Callers**
Record: `acpi_ns_get_normalized_pathname()` is called from many ACPI
paths including:
- `acpi_ex_stop_trace_method()` in `extrace.c` (UAF trigger path)
- `acpi_ns_get_external_pathname()`, `nsparse.c`, `nsinit.c`,
  `dsmethod.c`, `nseval.c`, `nssearch.c`
- Debugger-only paths (`db*.c`) — less relevant for production

**Step 5.3 — Callees**
Record: reads node descriptor type, walks parent chain, copies 4-byte
ACPI names; no allocation in the vulnerable section.

**Step 5.4 — Reachability**
Record:
- Call chain reaches ACPI table loading and method termination during
  normal kernel ACPI operation (boot + runtime method execution)
- Trigger requires crafted/malformed ACPI AML that causes walk-state
  teardown with stale node reference — demonstrated with `issue33.aml`
  in acpiexec; same ACPICA code runs in the kernel

**Step 5.5 — Similar patterns**
Record: `acpi_ns_get_pathname_length()` already validates descriptor
type before calling `acpi_ns_build_normalized_path()`, but
`acpi_ns_get_normalized_pathname()` does not — creating the gap this
patch closes at the lowest common level.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code in tree?**
Record: **YES**. Local tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44`). Vulnerable code is present at lines 221–244 of
`drivers/acpi/acpica/nsnames.c` without the descriptor-type check. Fix
commit `96b2b616870e4` is **not** an ancestor of HEAD.

**Step 6.2 — Backport complications**
Record: clean apply confirmed (`git apply --check` → CLEAN APPLY). No
rework needed.

**Step 6.3 — Related fixes already present?**
Record: no — `git log -S "Validate the Node to avoid use-after-free"`
finds nothing in this tree; related patch 12/27
(`acpi_ds_terminate_control_method` UAF fix) also absent.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: **ACPI/ACPICA** — IMPORTANT to CORE. ACPI is on every x86/ARM
server, laptop, and most embedded systems with firmware tables.

**Step 7.2 — Activity**
Record: ACPI subsystem actively maintained in this tree (recent NULL-
deref and execution-abort fixes in `drivers/acpi/acpica/`).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: all systems using in-kernel ACPICA for ACPI table parsing and
AML method execution.

**Step 8.2 — Trigger conditions**
Record: malformed/crafted ACPI AML during table load or method
termination with tracing enabled path; demonstrated with acpiexec +
crafted AML. Requires specific ACPI content, but ACPI tables are
firmware-supplied and occasionally attacker-influenced (e.g., custom
DSDT injection in some environments).

**Step 8.3 — Failure mode severity**
Record: **heap use-after-free** → kernel oops/panic or potential
information disclosure/exploitation primitive. Severity: **HIGH**.

**Step 8.4 — Risk-benefit**
Record:
- Benefit: **HIGH** — prevents real UAF on ACPI parsing path
- Risk: **VERY LOW** — 6-line defensive check, established ACPICA
  pattern
- Ratio: strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backport:
- Confirmed heap UAF with ASAN report and reproducer (ACPICA #1138)
- Affects ACPI table/method execution — common kernel path
- Small, surgical, obviously correct fix
- Matches existing validation patterns in same subsystem
- Applies cleanly to Linux 6.18.44
- Signed off by ACPI maintainer
- Bug present since 2015 — long exposure window

AGAINST backport:
- Part of larger ACPICA import series (but this patch is standalone)
- No explicit stable nomination in mailing list
- Related root-cause fix exists separately in patch 12/27 (but this
  defensive fix has independent value)

UNRESOLVED: none material to the decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — ASAN-verified bug, standard
   ACPICA validation pattern
2. Fixes a real bug? **PASS** — confirmed heap UAF
3. Important issue? **PASS** — memory safety during ACPI parsing
   (crash/security)
4. Small and contained? **PASS** — 6 lines, one function
5. No new features/APIs? **PASS** — defensive validation only
6. Can apply to local tree? **PASS** — clean apply verified

**Step 9.3 — Exception category**
Record: N/A (security/memory-safety bug fix, not a quirk/ID/DT
exception).

**Step 9.4 — Decision rationale**

For **Linux 6.18.44**, this commit should be backported. The vulnerable
`acpi_ns_build_normalized_path()` code exists in this tree, the fix is
absent, and upstream has demonstrated a reproducible heap use-after-free
on the ACPI AML parsing/teardown path that the kernel shares. The fix is
minimal, follows established ACPICA conventions already used in sibling
functions in the same file, and prevents dereferencing freed namespace
nodes by validating the descriptor type before walking the parent chain.

---

## Verification

- [Phase 1] Parsed commit message and tags from `git show 96b2b616870e4`
- [Phase 1] Fetched ACPICA upstream issue #1138 — ASAN UAF confirmed
  with stack trace and reproducer
- [Phase 2] Diff analysis: +6 lines adding `ACPI_GET_DESCRIPTOR_TYPE`
  check before node walk
- [Phase 2] Read current `nsnames.c` lines 193–270 in tree — vulnerable
  code confirmed present
- [Phase 3] `git blame -L 221,245`: buggy loop from `d1e7ffe50ba58`
  (2015)
- [Phase 3] `git merge-base --is-ancestor 96b2b616870e4 HEAD` → FIX NOT
  IN TREE
- [Phase 3] `git apply --check` on patch → CLEAN APPLY
- [Phase 4] `b4 dig -c 96b2b616870e4` → lore URL found; patch 19/27 of
  ACPICA series
- [Phase 4] `b4 dig -w` → Rafael Wysocki, linux-acpi, LKML CC'd
- [Phase 4] Downloaded mbox; grep found no Cc: stable; found related
  patch 12/27
- [Phase 5] `grep acpi_ns_get_normalized_pathname` — multiple kernel
  callers including `extrace.c:284`
- [Phase 5] Read `extrace.c` `acpi_ex_stop_trace_method()` and
  `dsmethod.c:850` call site
- [Phase 5] Confirmed `acpi_ns_get_pathname_length()` already validates
  at line 58; `acpi_ns_get_normalized_pathname()` does not
- [Phase 6] `git describe HEAD` → v6.18.44
- [Phase 6] Confirmed validation check absent in current `nsnames.c`
- [Phase 7] `git log --oneline -20 -- drivers/acpi/acpica/` — active
  subsystem
- [Phase 8] UAF severity assessed from ASAN report in issue #1138

**YES**The analysis is complete for **ACPICA: Add validation for node in
acpi_ns_build_normalized_path()** on **Linux 6.18.44**.

**Summary:** This is a small (6-line) fix for a confirmed heap use-
after-free in ACPI pathname building. The vulnerable code is present in
this tree; the fix is not. It applies cleanly and follows existing
ACPICA validation patterns. Upstream demonstrated the bug with ASAN on
the ACPI AML parse/teardown path (`acpi_ex_stop_trace_method` →
`acpi_ns_get_normalized_pathname` → `acpi_ns_build_normalized_path`).

**Verdict for this tree: YES** — worth backporting as a memory-safety
fix on a common ACPI path.

 drivers/acpi/acpica/nsnames.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/acpica/nsnames.c b/drivers/acpi/acpica/nsnames.c
index 22aeeeb56cffd..19802da865c54 100644
--- a/drivers/acpi/acpica/nsnames.c
+++ b/drivers/acpi/acpica/nsnames.c
@@ -222,6 +222,12 @@ acpi_ns_build_normalized_path(struct acpi_namespace_node *node,
 		goto build_trailing_null;
 	}
 
+	/* Validate the Node to avoid use-after-free vulnerabilities */
+
+	if (ACPI_GET_DESCRIPTOR_TYPE(node) != ACPI_DESC_TYPE_NAMED) {
+		goto build_trailing_null;
+	}
+
 	next_node = node;
 	while (next_node && next_node != acpi_gbl_root_node) {
 		if (next_node != node) {
-- 
2.53.0

