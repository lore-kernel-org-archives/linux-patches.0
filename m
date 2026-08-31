Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FB554A7D7;
	Mon, 31 Aug 2026 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183990; cv=none; b=lua96UU4HHVW+kESh2PIhbbZ4wgDtLsDH4yF057WXD/mFLjW7DANo5ejFMOKoQQ+8lLzBpV2ZN+3TsmXjz85t1Fqfk6rGWiZ61MFAb2+EIPecOn2KEcvJM3ZogB9KbFdymfnpEyHjRxkUMM0H0XOI1dm3S0ki9l5zUPgqaskRb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183990; c=relaxed/simple;
	bh=QrrSsW7Q53fjm5gyXVHzfqwlRQmQfNlzWlpLZWkNVWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cOH51xnRu7tE9TPJ9ugkWU/6+5nOaMNbq0LFvX5a08mwPscmtxvPQbegKW49FkCRQ7UxxTrvXi4RgIelOczuhWqPr5zUUVN9FtPtTnC5Jdikr6lyY+Y+VBJvdHES7T73ig0cymRp8+fYDQ6jBSliBFTpGBaiQMAuY0z6cJAnqB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QoVx97Nm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoVx97Nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FBD1F00ACA;
	Mon, 31 Aug 2026 13:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183986;
	bh=AEn1EkuoVMCTAw9FNBlW4wAm8PyUTNXt8wvQ2WMCEkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QoVx97NmD6aVfSHIoZgMHhkShgOvUpG/nzrg7C5UloJspUgz9wOZj7qYSiMySL7eF
	 WqUDofBr6RP/LmgGNOg6a2Dm+yN8rlCKZOsGdTtOogqwS8pe0XywduTAq13jeHLn3w
	 VYAfVXwa0oeS46993gaVdSjcMNQabxf+DDjPi8HQO2Jgkdky6DHW8RHvRbDWO476SL
	 bs48dVcf27Sb++25vKecEj0XkO9gDKMJ+TIRe89cEsAEwP25qE4pdb3EyjOjWwRIST
	 wVKM5V9a5mxWLjtlAofzUYPtmw3L+q4uD7gkr5O064UMsQjK40MHx2SeKA0TBzw/3Q
	 l3v0ZtvQDojIw==
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
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: validate byte_count in acpi_ps_get_next_package_length()
Date: Mon, 31 Aug 2026 09:27:30 -0400
Message-ID: <20260831133314.4125787-422-sashal@kernel.org>
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

[ Upstream commit d49c6ee08365a8596f639da46eb7e71752b0cd42 ]

Validate package length reading in acpi_ps_get_next_package_length().

Link: https://github.com/acpica/acpica/commit/40e03f9941e2
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3616255.QJadu78ljV@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPICA `acpi_ps_get_next_package_length()`
bounds check

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ACPICA] [validate] validate byte_count in
acpi_ps_get_next_package_length()` — ACPI parser subsystem; verb is
“validate,” indicating a safety/bounds fix.

### Step 1.2: Tags
**Record:**
- **Link:** https://github.com/acpica/acpica/commit/40e03f9941e2
  (upstream ACPICA commit)
- **Link:** https://patch.msgid.link/3616255.QJadu78ljV@rafael.j.wysocki
  (kernel submission)
- **Signed-off-by:** ikaros \<void0red@gmail.com\> (author)
- **Signed-off-by:** Rafael J. Wysocki \<rafael.j.wysocki@intel.com\>
  (ACPI maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: submitted as **[PATCH v1 13/27]** in an ACPICA upstream sync
  series (May 27, 2026)

### Step 1.3: Body analysis
**Record:**
- **Bug:** `acpi_ps_get_next_package_length()` reads package-length
  encoding bytes without checking remaining AML buffer size.
- **Symptom:** Out-of-bounds read when `byte_count` (bits 6:7 of first
  byte) claims more follow-on bytes than exist before `aml_end`.
- **Upstream evidence:** ACPICA issue #1123 documents ASAN heap-buffer-
  overflow at `psargs.c:223` in `AcpiPsGetNextPackageLength`, triggered
  by malformed `issue8.aml` via `acpiexec`.
- **Root cause:** Parser advances and reads `aml[byte_count]` in a loop
  without validating `byte_count + 1 <= remaining`.

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite minimal commit text, this is a confirmed
memory-safety bug fix (heap buffer overflow / OOB read), not cosmetic
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/acpi/acpica/psargs.c` (+17 lines, 0 removed)
- **Function:** `acpi_ps_get_next_package_length()`
- **Scope:** Single-file, single-function surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (remaining == 0):** Before → reads `aml[0]` unconditionally.
  After → if no bytes remain, return 0 immediately.
- **Hunk 2 (byte_count >= remaining):** Before → reads `aml[0]`,
  advances pointer, loops reading `aml[byte_count]` even past buffer
  end. After → if encoding needs more bytes than available (`byte_count
  >= remaining` means `byte_count + 1 > remaining`), set
  `parser_state->aml = aml_end` and return 0.
- **Normal path:** Unchanged when sufficient bytes exist.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read (memory safety)
- **Mechanism:** ACPI package-length encoding uses 1–4 bytes. With
  truncated/corrupt AML near `aml_end`, `byte_count` can be 1–3 while
  only 1–2 bytes remain. The `while (byte_count)` loop does
  `aml[byte_count]` past the allocation — exactly matching the ASAN
  report at line 223 (Linux tree line 71: `package_length |=
  (aml[byte_count] << ...)`).

### Step 2.4: Fix quality
**Record:**
- Fix is obviously correct: compares available bytes against encoding
  width before reading.
- Minimal, no unrelated changes.
- Low regression risk: only affects truncated/corrupt AML; valid tables
  unchanged.
- On error, returns 0 and advances to `aml_end` — safe degradation vs.
  OOB read.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Core parsing logic dates to **2005** (Bob Moore,
`drivers/acpi/parser/psargs.c`). Bug present since initial
implementation. `aml_end` field and `ACPI_PTR_DIFF` macro already exist
in this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Upstream ACPICA commit references
GitHub issue #1123.

### Step 3.3: Related file history
**Record:** Recent `psargs.c` changes in 6.18.44 include memory-leak
fixes (`e6169a8ffee8a`, `5accb265f7a1b`) — same file, same maintainer
pattern for stable-worthy ACPICA parser fixes. This specific fix is
**not** yet in the tree.

### Step 3.4: Author context
**Record:** ikaros reported the ACPICA bug with ASAN PoC. Rafael Wysocki
(ACPI maintainer) carried it into kernel as patch 13/27 of an ACPICA
sync.

### Step 3.5: Dependencies
**Record:** Patch is part of a 27-patch series but **this hunk is self-
contained**:
- Uses existing `parser_state->aml_end` (in `struct acpi_parse_state`
  since long ago)
- Uses existing `ACPI_PTR_DIFF` (`include/acpi/actypes.h:505`)
- `git apply --check` succeeds cleanly on 6.18.44
- No prerequisite structural changes from earlier series patches
  required

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lkml.iu.edu/2605.3/06258.html (patch submission, May
  27, 2026)
- **Series:** v1 13/27 of ACPICA upstream sync
- **Review thread:** No replies visible on lkml.iu.edu mirror; no NAKs
  found
- **Stable nomination:** None found in available thread content

### Step 4.2: Reviewers
**Record:** `b4 dig -c 40e03f9941e2` failed (ACPICA hash, not in Linux
tree). Patch submitted by Rafael Wysocki to linux-acpi; maintainer sign-
off present.

### Step 4.3: Bug report
**Record:**
- **ACPICA issue #1123:** Heap-buffer-overflow, ASAN-confirmed,
  reproducible with `acpiexec -m issue8.aml`
- Stack trace: `AcpiPsGetNextPackageLength` → `AcpiPsGetNextPackageEnd`
  → `AcpiPsGetNextArg` → `AcpiPsParseLoop` → `AcpiNsLoadTable` →
  `AcpiLoadTables`
- Severity: memory safety violation during ACPI table parsing

### Step 4.4: Related patches
**Record:** Same series includes additional boundary checks in
`acpi_ps_peek_opcode()`, `acpi_ps_get_next_field()`,
`acpi_ps_get_next_namestring()` (patches 14–27). Those fix related but
separate OOB paths; this patch stands alone for this specific function.

### Step 4.5: Stable list history
**Record:** lore.kernel.org/stable blocked by bot protection; no stable-
specific discussion found via alternate sources.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `acpi_ps_get_next_package_length()` (modified); callers
include `acpi_ps_get_next_package_end()`.

### Step 5.2: Callers
**Record:**
- `acpi_ps_get_next_package_end()` → used from `acpi_ps_get_next_arg()`
  (ARGP_PKGLENGTH, field parsing)
- `acpi_ps_get_next_package_length()` direct calls in
  `acpi_ps_get_next_field()` (buffer/field length)
- Upstream call chain reaches `acpi_ps_parse_loop()` →
  `acpi_ps_execute_table()` → `acpi_ns_load_table()` →
  `acpi_load_tables()` → `acpi_bus_init()` at boot

### Step 5.3: Callees
**Record:** Uses `ACPI_PTR_DIFF`, pointer arithmetic on
`parser_state->aml` / `aml_end`; no allocations or locks.

### Step 5.4: Reachability
**Record:** **Yes — boot path.** `acpi_bus_init()` calls
`acpi_load_tables()` during ACPI subsystem init. Any corrupt/truncated
DSDT/SSDT AML with malformed package-length encoding can hit this. With
`CONFIG_ACPI_TABLE_OVERRIDE_VIA_BUILTIN_INITRD`, root can supply custom
ACPI tables.

### Step 5.5: Similar patterns
**Record:** Same series adds similar bounds checks elsewhere. Prior
stable-relevant fix in tree: `a3e525feaeec4` “Avoid subobject buffer
overflow when validating RSDP signature.”

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Lines 58–71 of `drivers/acpi/acpica/psargs.c` lack
bounds checking — exactly the vulnerable code. Bug present since ~2005.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` passed with zero
conflicts. `aml_end` and `ACPI_PTR_DIFF` already present.

### Step 6.3: Fix already present?
**Record:** **No.** `git log --grep="validate byte_count"` found
nothing. Current function has no `remaining` variable or bounds checks.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **ACPI / ACPICA parser** — IMPORTANT/CORE for x86/ARM
systems with ACPI. Affects boot-time namespace loading for essentially
all ACPI-enabled machines.

### Step 7.2: Activity
**Record:** Actively maintained; regular ACPICA upstream merges. Recent
`psargs.c` leak fixes confirm ongoing parser hardening.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** All systems using ACPI (most PCs, many ARM servers/laptops).
Config: `CONFIG_ACPI=y` (default on most platforms).

### Step 8.2: Trigger conditions
**Record:**
- Corrupt or truncated ACPI AML in DSDT/SSDT tables
- Malformed package-length encoding near end of AML buffer
- Triggered during boot `acpi_load_tables()` — every boot with bad
  tables
- Root can inject tables via initrd override; firmware/QEMU can supply
  bad tables
- Not directly triggerable by unprivileged userspace, but boot crash is
  severe

### Step 8.3: Failure mode severity
**Record:** **HIGH** — heap-buffer-overflow / OOB read; can cause kernel
oops/panic during early boot, potential info leak with KASAN/ASAN. Boot
failure = system unusable.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents OOB read on common boot path with corrupt
  ACPI data
- **Risk:** VERY LOW — 17-line bounds check, no API changes, clean apply
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Confirmed heap-buffer-overflow (ASAN, ACPICA #1123)
- Boot-path ACPI table parsing (`acpi_load_tables`)
- Bug present since 2005 in this tree
- Small, surgical, maintainer-reviewed fix
- Applies cleanly to 6.18.44
- Precedent: similar ACPICA overflow/bounds fixes in stable trees
- Self-contained despite being patch 13/27

**AGAINST backport:**
- Part of larger 27-patch series (but this hunk has no code dependencies
  on siblings)
- No syzbot report (but ASAN PoC exists)
- ACPI tables usually from firmware (limited direct attack surface, but
  corrupt firmware and initrd override are real)

**Unresolved:**
- No visible reviewer stable nominations (lore blocked)
- Full series not yet merged to 6.18.44 (only this patch needed for this
  specific bug)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   ASAN-tested upstream
2. Fixes a real bug affecting users? **PASS** — OOB read on ACPI parse
3. Important issue? **PASS** — memory safety, boot-time crash risk
   (HIGH)
4. Small and contained? **PASS** — 17 lines, one function
5. No new features/APIs? **PASS** — defensive bounds check only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build fix, or docs — standard
bug fix)

### Step 9.4: Decision rationale
For **Linux 6.18.44**, the vulnerable code exists, the fix applies
cleanly, and the bug is a confirmed out-of-bounds read on the ACPI boot
parsing path. This meets all stable kernel criteria.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified ASAN-confirmed OOB
  read
- [Phase 1] Fetched ACPICA commit 40e03f9941e2 and issue #1123 from
  GitHub
- [Phase 2] Read current `psargs.c:45-80` — vulnerable code confirmed
- [Phase 2] Analyzed diff: adds `remaining` check before `byte_count`
  read loop
- [Phase 3] `git blame`: buggy logic from 2005; fix not present
- [Phase 3] `git log --oneline -20 -- drivers/acpi/acpica/psargs.c`: no
  matching fix
- [Phase 3] Verified `struct acpi_parse_state.aml_end` in
  `aclocal.h:912`
- [Phase 3] Verified `ACPI_PTR_DIFF` in `include/acpi/actypes.h:505`
- [Phase 4] `b4 dig -c 40e03f9941e2`: no match (ACPICA-only hash)
- [Phase 4] lkml.iu.edu/2605.3/06258.html: patch 13/27, Rafael Wysocki
  submission
- [Phase 4] GitHub issue #1123: ASAN stack trace and reproduction steps
- [Phase 5] Traced callers: `acpi_ps_get_next_package_end` →
  `acpi_ps_get_next_arg` → parse loop → `acpi_ns_load_table` →
  `acpi_load_tables` → `acpi_bus_init`
- [Phase 5] Confirmed `acpi_load_tables()` call in
  `drivers/acpi/bus.c:1413`
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `git apply --check`: patch applies cleanly
- [Phase 6] Confirmed fix absent (`remaining` variable not in current
  code)
- [Phase 8] Assessed severity: HIGH (boot-time OOB read)
- [UNVERIFIED] Full lore review thread replies (lore blocked by Anubis)
- [UNVERIFIED] Whether entire 27-patch series will merge before next
  6.18.y release (does not affect standalone merit of this fix)

**YES****Verdict: YES** — backport to this tree (Linux 6.18.44).

The commit adds bounds checks in `acpi_ps_get_next_package_length()` so
truncated or corrupt ACPI AML cannot trigger an out-of-bounds read when
decoding package-length fields. That bug is confirmed upstream (ASAN
heap-buffer-overflow, ACPICA issue #1123), hits the boot path via
`acpi_load_tables()`, and the vulnerable code is still present in
6.18.44. The patch is small (17 lines), self-contained, and applies
cleanly.

 drivers/acpi/acpica/psargs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 55273cbbfc67e..3526ea1094146 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -48,6 +48,7 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state)
 	u32 package_length = 0;
 	u32 byte_count;
 	u8 byte_zero_mask = 0x3F;	/* Default [0:5] */
+	u32 remaining;
 
 	ACPI_FUNCTION_TRACE(ps_get_next_package_length);
 
@@ -55,7 +56,23 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state)
 	 * Byte 0 bits [6:7] contain the number of additional bytes
 	 * used to encode the package length, either 0,1,2, or 3
 	 */
+
+	/* Check if we have at least one byte to read */
+	remaining = (u32)ACPI_PTR_DIFF(parser_state->aml_end, aml);
+	if (remaining == 0) {
+		return_UINT32(0);
+	}
+
 	byte_count = (aml[0] >> 6);
+
+	/* Validate byte_count and ensure we have enough bytes to read */
+	if (byte_count >= remaining) {
+
+		/* Clamp to available bytes and advance to end */
+		parser_state->aml = parser_state->aml_end;
+		return_UINT32(0);
+	}
+
 	parser_state->aml += ((acpi_size)byte_count + 1);
 
 	/* Get bytes 3, 2, 1 as needed */
-- 
2.53.0

