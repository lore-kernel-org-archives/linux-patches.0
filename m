Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C63468C3B;
	Mon, 31 Aug 2026 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183293; cv=none; b=u1fMrYEwcZMxhY/LV3x55bM+c9sUgYMc1Cx3UVac5ll3SN3MTp99XXG0Bk7UC3adsTwgb+xdw9HuJ18k9sKqrLbsXr+QVlJWNzh0AQ4toazN6vvLDajO8vvH0HobRMObjI0ztjy5r1bfDyh6DviKKe66UQc89VKcMj01/ZhrhLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183293; c=relaxed/simple;
	bh=HLiBdYmCQfRbz9b62Ku8mQ6d4hMrifr3NdIv7TWd/BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9gxxyMRJST/S2wA8FJsbpzEPDRXUQTNdC4BqUJCTHz4mbV3xCgZdYY0HfNRvM7ZqCJJjewGzvqkE/YNgCzSfzPZdygbVy9QRrPoFNj1DNWAvzXByXQemX+tWsOdt8M3qwu9DKE3xhJpymcc/0Kp6uUM52vRqJSDos8q6jr1g0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8+ltzgM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8+ltzgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4859F1F00A3E;
	Mon, 31 Aug 2026 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183290;
	bh=PSa/J42ad4e/7Ts2G0oDuoktwXfLZfk+vMouwLvcDzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8+ltzgMzBfujXW8+8ImZdOqkt6hYxcM78Vnj8Lk7tnCmuIHnnmnxuLNWitPuT8HI
	 YX1bC9hWc89pu+OI0tsoseWGR9tuX2ynYpYvctyMYNGhme9F+M738A5+EUzf88jk8o
	 UmgNnvy3+l5hHk5vPOYp0ApKUJYI2CVCCbzPmHx6Ld+AHc5AC/6jI9+7mInRcKWX0v
	 uPXLJGKOgLUFdPwCaZg3wPFsLlI8rkK5ouHAZH9Lr6Z1RN3v1aF5DaX+l06kvi40Xo
	 X3j/EaJPMyqAy2gtGz0rEwUUJ/BybqGKVsEerR6GnXg+SXzLEC9eIOgkrExWQufjNN
	 sdo30c8MVTCHw==
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
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Improve argument parsing in acpi_ps_get_next_simple_arg()
Date: Mon, 31 Aug 2026 09:21:28 -0400
Message-ID: <20260831133314.4125787-60-sashal@kernel.org>
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

[ Upstream commit 27d27e75ecb752a0b4da848c440bb3a88396ecba ]

Improve argument parsing in acpi_ps_get_next_simple_arg() to handle
remaining AML data safely.

Link: https://github.com/acpica/acpica/commit/ecbb8bcfe301
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2008043.taCxCBeP46@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: **[ACPICA] [Improve] argument parsing in
`acpi_ps_get_next_simple_arg()` to handle remaining AML data safely**

**Step 1.2 — Tags**

Record:
- **Link:** https://github.com/acpica/acpica/commit/ecbb8bcfe301
- **Link:** https://patch.msgid.link/2008043.taCxCBeP46@rafael.j.wysocki
  (blocked by bot protection; lkml.iu.edu mirror used instead)
- **Signed-off-by:** ikaros \<void0red@gmail.com\> (author)
- **Signed-off-by:** Rafael J. Wysocki \<rafael.j.wysocki@intel.com\>
  (ACPI maintainer)
- No **Fixes:**, **Reported-by:**, **Cc: stable**, **Tested-by:**, or
  **Reviewed-by:** tags in the message
- Notable: patch is **[PATCH v1 17/27]** in Rafael’s ACPICA sync series
  (May 2026); upstream ACPICA commit fixes GitHub issues **#1073** and
  **#1131**

**Step 1.3 — Body analysis**

Record:
- **Bug:** `acpi_ps_get_next_simple_arg()` reads integer and string AML
  arguments without checking how many bytes remain before
  `parser_state->aml_end`.
- **Symptoms:** Out-of-bounds reads when AML is truncated or a string
  lacks a null terminator within the buffer; downstream code (e.g.
  `strlen()` on the string pointer) can also OOB-read.
- **Root cause:** Unbounded `*aml` / `ACPI_MOVE_*` reads and unbounded
  `while (aml[length])` loop.
- **Fix approach:** Compute `remaining = aml_end - aml`, bounds-check
  all reads, bound the string scan, warn and force a null terminator at
  the buffer edge when needed.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** “Improve argument parsing” is defensive hardening
against real memory-safety bugs (heap-buffer-overflow confirmed in
upstream ACPICA via ASAN).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/acpi/acpica/psargs.c` (+68 / −10 per lkml; net ~58
  lines)
- **Function:** `acpi_ps_get_next_simple_arg()` only
- **Scope:** Single-file, single-function surgical fix

**Step 2.2 — Code flow per hunk**

Record:
- **ARGP_BYTEDATA:** Before: always read 1 byte. After: read only if
  `remaining >= 1`, else return 0 with `length = 0`.
- **ARGP_WORD/DWORD/QWORDDATA:** Before: always read 2/4/8 bytes. After:
  full read if enough bytes; else zero-init and `memcpy()` partial bytes
  if any remain.
- **ARGP_CHARLIST:** Before: unbounded scan for `'\0'`. After: scan only
  within `remaining`; if no terminator, `ACPI_WARNING`, write `'\0'` at
  `aml[remaining-1]`, set `length = remaining`.
- **Normal path:** `parser_state->aml += length` unchanged.

**Step 2.3 — Bug mechanism**

Record: **Memory safety / buffer overflow (OOB read).** Integer cases
read past `aml_end`; string case can scan past `aml_end` and pass a non-
terminated pointer to later `strlen()`-based code (upstream issue
#1131).

**Step 2.4 — Fix quality**

Record: Fix is minimal, uses existing `aml_end` and `ACPI_PTR_DIFF`
(already used elsewhere in ACPICA). Low regression risk on valid AML.
Minor concern: in-place mutation of AML bytes for malformed strings
(`aml[remaining-1] = 0`), but this only triggers on invalid AML and is
the upstream-chosen mitigation to prevent downstream OOB.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Buggy logic dates to original ACPICA import (~2005, Bob Moore /
Len Brown). Present in this tree at lines 364–443 of `psargs.c`. Not a
recently introduced regression.

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**

Record: Recent `psargs.c` changes in v6.18.44 are copyright updates and
separate memory-leak fixes (`acpi_ps_get_next_field`,
`acpi_ps_get_next_namepath`). No prior fix for this bounds-check issue.

**Step 3.4 — Author commits**

Record: Author ikaros/void0red is an ACPICA contributor (fuzzing-driven
fixes). Rafael Wysocki is ACPI subsystem maintainer; patch submitted as
part of ACPICA v1 27-patch series.

**Step 3.5 — Dependencies**

Record: Listed as patch 17/27 in an ACPICA bulk sync, but the diff is
self-contained — uses only existing `struct acpi_parse_state` fields
(`aml`, `aml_end`, `aml_start`) and `ACPI_PTR_DIFF`. No structural
prerequisites from other series patches identified. **Can apply
standalone.**

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- **b4 dig -c ecbb8bcfe301:** Failed (ACPICA SHA not in Linux git)
- **lkml mirror:** https://lkml.iu.edu/2605.3/06252.html — Rafael’s
  [PATCH v1 17/27], May 27 2026
- **Series revisions:** Part of v1 27-patch ACPICA update; no evidence
  of a newer conflicting version for this hunk
- **Stable nomination in thread:** Not found in available sources
- **NAKs:** None found

**Step 4.2 — Reviewers**

Record: Rafael J. Wysocki (maintainer) signed off and submitted. Full
recipient list unavailable (b4/lore blocked).

**Step 4.3 — Bug reports**

Record:
- **GitHub acpica#1073:** ASAN heap-buffer-overflow in
  `AcpiPsGetNextSimpleArg` at integer read (iasl fuzzing)
- **GitHub acpica#1131:** ASAN heap-buffer-overflow via `strlen()` on
  malformed AML string without null terminator (acpiexec); fixed by this
  commit
- Both closed after ecbb8bc

**Step 4.4 — Series context**

Record: One patch in a 27-patch ACPICA sync; this hunk is independent
and does not require the other 26 patches.

**Step 4.5 — Stable list**

Record: Could not search lore stable list (bot protection). No stable-
specific discussion found via web search.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `acpi_ps_get_next_simple_arg()` modified.

**Step 5.2 — Callers**

Record:
- `acpi_ps_get_arguments()` in `psloop.c` (constant/string opcode
  arguments during parse loop)
- `acpi_ps_get_next_arg()` in `psargs.c` (general argument fetching)

Both are on the ACPI AML parse path used during table load and method
execution.

**Step 5.3 — Callees**

Record: `acpi_ps_init_op()`, `acpi_ps_get_next_namestring()` (unchanged
paths), `ACPI_MOVE_*` macros, `memcpy()`, `ACPI_WARNING()`.

**Step 5.4 — Reachability**

Record:
- Boot: `acpi_ns_one_complete_parse()` →
  `acpi_ds_init_aml_walk(aml_start, aml_length)` → `acpi_ps_parse_aml()`
  → parse loop → `acpi_ps_get_next_simple_arg()`
- Runtime: ACPI method evaluation uses the same walk/parse path via
  `acpi_ds_init_aml_walk()`
- **Reachable on every ACPI-enabled system** when parsing tables or
  evaluating methods. Trigger requires malformed/truncated AML (buggy
  firmware, corrupted tables, or injected SSDT).

**Step 5.5 — Similar patterns**

Record: No existing bounds-check pattern for this function in v6.18.44.
`parser_state->aml_end` is set in `acpi_ds_init_aml_walk()`
(`dswstate.c:578-586`) for all AML walks. `psloop.c` already uses
`parser_state->aml < parser_state->aml_end` at the loop level, but
individual argument parsing lacked per-field bounds checks.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44` (Makefile 6.18.44).
`acpi_ps_get_next_simple_arg()` at `psargs.c:364-443` has the unbounded
reads. Commit ecbb8bc is **not** in this tree.

**Step 6.2 — Backport complications**

Record: **Clean apply expected.** lkml diff index (`3526ea109414`)
matches current file structure; only line-offset difference. `aml_end`
field exists in `aclocal.h:912`. `ACPI_PTR_DIFF` used elsewhere in
ACPICA.

**Step 6.3 — Related fixes already present?**

Record: **No.** `git log --grep` found no prior fix for this function’s
bounds checking in `psargs.c`.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem / criticality**

Record: **ACPI / ACPICA parser** — **CORE** for all `CONFIG_ACPI`
systems (essentially all x86 PCs and many ARM servers).

**Step 7.2 — Activity**

Record: ACPICA receives regular maintenance; this is a targeted safety
fix within a periodic upstream sync.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: All ACPI-enabled systems parsing AML at boot or during method
evaluation. Driver-specific only in the sense that it requires ACPI,
which is near-universal on supported platforms.

**Step 8.2 — Trigger conditions**

Record: Malformed or truncated AML bytecode (truncated integer args,
string without `'\0'` within buffer). Uncommon in practice from
legitimate firmware, but confirmed reproducible with fuzzed AML. ACPI
table override/SSDT loading requires elevated privileges; primary
production risk is buggy OEM firmware.

**Step 8.3 — Failure mode severity**

Record: **OOB read** → potential kernel oops, info leak, or further
cascading OOB in `strlen()`. **Severity: HIGH** (boot-time or runtime
crash on ACPI parse path).

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit: HIGH** — prevents memory-safety bug on a core boot path
- **Risk: LOW** — single function, defensive checks, no API change;
  valid AML behavior unchanged
- **Ratio:** Strong benefit, low risk → backport warranted

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Confirmed heap-buffer-overflow (ASAN) in upstream ACPICA for this
  exact function
- Same vulnerable code present in v6.18.44 since ~2005
- `aml_end` infrastructure already exists and is set on all parse paths
- Small, self-contained, maintainer-signed fix
- Prevents OOB reads during ACPI table parsing and method evaluation
- Fits stable criteria: real bug, important (crash/security-class memory
  safety), no new APIs

**Evidence AGAINST backport:**
- Part of a 27-patch ACPICA series (cosmetic concern only; patch is
  standalone)
- In-place AML mutation for malformed strings (edge case; upstream-
  accepted)
- Bugs found via iasl/acpiexec fuzzing, not a field user report (but
  kernel shares the code)

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — straightforward bounds
   checks; ASAN-verified upstream
2. Fixes a real bug affecting users? **PASS** — OOB read on ACPI parse
   path
3. Important issue? **PASS** — HIGH severity (memory safety / potential
   crash)
4. Small and contained? **PASS** — one function, ~58 net lines
5. No new features or APIs? **PASS** — defensive parsing only
6. Can apply to local tree? **PASS** — buggy code present, dependencies
   satisfied

**Exception category:** N/A (not device ID, quirk, DT, build, or docs)

**Conclusion:** This commit fixes a long-standing memory-safety hole in
core ACPI AML parsing that is present in the v6.18.44 tree. The fix is
surgical, uses existing parser state, and prevents out-of-bounds reads
that can crash the kernel when malformed AML is encountered.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
  and lkml mirror
- [Phase 1] Confirmed upstream fixes acpica#1073 and #1131 via GitHub
  issue pages
- [Phase 2] Diff analysis: single-function bounds-check fix in
  `acpi_ps_get_next_simple_arg()`
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame -L 364,443 drivers/acpi/acpica/psargs.c`: code
  from ~2005
- [Phase 3] `git log --oneline -20 -- drivers/acpi/acpica/psargs.c`: no
  prior bounds-check fix
- [Phase 3] `git log -1 ecbb8bcfe301`: commit not in local tree
- [Phase 4] `b4 dig -c ecbb8bcfe301`: no match (ACPICA-only SHA)
- [Phase 4] lkml.iu.edu/2605.3/06252.html: found [PATCH v1 17/27] with
  identical diff
- [Phase 4] GitHub acpica#1073: ASAN heap-buffer-overflow at integer
  read
- [Phase 4] GitHub acpica#1131: ASAN heap-buffer-overflow via strlen on
  malformed string
- [Phase 5] `grep acpi_ps_get_next_simple_arg`: callers in
  `psloop.c:71`, `psargs.c:769`
- [Phase 5] Read `nsparse.c:173-198`: table parse sets
  `aml_start`/`aml_length` via `acpi_ds_init_aml_walk()`
- [Phase 5] Read `dswstate.c:578-586`: `aml_end` set from `aml_start +
  aml_length`
- [Phase 6] Read `psargs.c:364-443`: confirmed vulnerable code in
  v6.18.44
- [Phase 6] Read `aclocal.h:909-920`: `aml_end` field exists in `struct
  acpi_parse_state`
- [Phase 8] Assessed severity as HIGH based on verified OOB read
  mechanism
- [UNVERIFIED] Full lore.kernel.org review thread (Anubis bot blocked
  direct fetch)
- [UNVERIFIED] Whether any reviewer explicitly nominated for stable (not
  needed for decision)

**YES**The background history searches finished and matched what the
main analysis already used.

**Task 264644** (`git log` on `psargs.c`): Recent changes are copyright
updates and separate leak fixes in `acpi_ps_get_next_field()` /
`acpi_ps_get_next_namepath()`. Nothing related to bounds checking in
`acpi_ps_get_next_simple_arg()`.

**Task 264645** (author/search): No Linux-kernel commits from
ikaros/void0red on this fix; the patch came through Rafael Wysocki’s
ACPICA sync. Recent ACPI work in this tree includes other parser/safety
fixes, but not this one.

That confirms the vulnerable code is still present in **v6.18.44** and
this fix isn’t already here. Verdict remains **YES** for stable
backport.

 drivers/acpi/acpica/psargs.c | 78 +++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 3526ea1094146..064652d11d9aa 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -384,6 +384,8 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 	u32 length;
 	u16 opcode;
 	u8 *aml = parser_state->aml;
+	u32 remaining = (u32)ACPI_PTR_DIFF(parser_state->aml_end, aml);
+	u64 partial_value;
 
 	ACPI_FUNCTION_TRACE_U32(ps_get_next_simple_arg, arg_type);
 
@@ -393,8 +395,13 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Get 1 byte from the AML stream */
 
 		opcode = AML_BYTE_OP;
-		arg->common.value.integer = (u64) *aml;
-		length = 1;
+		if (remaining >= 1) {
+			arg->common.value.integer = (u64)*aml;
+			length = 1;
+		} else {
+			arg->common.value.integer = 0;
+			length = 0;
+		}
 		break;
 
 	case ARGP_WORDDATA:
@@ -402,8 +409,19 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Get 2 bytes from the AML stream */
 
 		opcode = AML_WORD_OP;
-		ACPI_MOVE_16_TO_64(&arg->common.value.integer, aml);
-		length = 2;
+		if (remaining >= 2) {
+			ACPI_MOVE_16_TO_64(&arg->common.value.integer, aml);
+			length = 2;
+		} else {
+			arg->common.value.integer = 0;
+			length = 0;
+			if (remaining > 0) {
+				partial_value = 0;
+				memcpy(&partial_value, aml, remaining);
+				arg->common.value.integer = partial_value;
+				length = remaining;
+			}
+		}
 		break;
 
 	case ARGP_DWORDDATA:
@@ -411,8 +429,19 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Get 4 bytes from the AML stream */
 
 		opcode = AML_DWORD_OP;
-		ACPI_MOVE_32_TO_64(&arg->common.value.integer, aml);
-		length = 4;
+		if (remaining >= 4) {
+			ACPI_MOVE_32_TO_64(&arg->common.value.integer, aml);
+			length = 4;
+		} else {
+			arg->common.value.integer = 0;
+			length = 0;
+			if (remaining > 0) {
+				partial_value = 0;
+				memcpy(&partial_value, aml, remaining);
+				arg->common.value.integer = partial_value;
+				length = remaining;
+			}
+		}
 		break;
 
 	case ARGP_QWORDDATA:
@@ -420,8 +449,19 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Get 8 bytes from the AML stream */
 
 		opcode = AML_QWORD_OP;
-		ACPI_MOVE_64_TO_64(&arg->common.value.integer, aml);
-		length = 8;
+		if (remaining >= 8) {
+			ACPI_MOVE_64_TO_64(&arg->common.value.integer, aml);
+			length = 8;
+		} else {
+			arg->common.value.integer = 0;
+			length = 0;
+			if (remaining > 0) {
+				partial_value = 0;
+				memcpy(&partial_value, aml, remaining);
+				arg->common.value.integer = partial_value;
+				length = remaining;
+			}
+		}
 		break;
 
 	case ARGP_CHARLIST:
@@ -434,10 +474,28 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Find the null terminator */
 
 		length = 0;
-		while (aml[length]) {
+		while ((length < remaining) && aml[length]) {
+			length++;
+		}
+		if (length < remaining) {
+
+			/* Account for the terminating null */
 			length++;
+		} else {
+			/*
+			 * No terminator found - add null at buffer boundary
+			 * and report a warning
+			 */
+			ACPI_WARNING((AE_INFO,
+				      "Invalid AML string: no null terminator, truncating at offset %u",
+				      (u32)(aml - parser_state->aml)));
+
+			/* Add null terminator at the boundary */
+			if (remaining > 0) {
+				aml[remaining - 1] = 0;
+				length = remaining;
+			}
 		}
-		length++;
 		break;
 
 	case ARGP_NAME:
-- 
2.53.0

