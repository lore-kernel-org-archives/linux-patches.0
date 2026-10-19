Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA305A0AC2;
	Mon, 19 Oct 2026 13:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418136; cv=none; b=daOriezcbecSYswAwd+yKiYpxIai5ea1CxScQBULt05qZpNaTFfAjwoDjRsyJA6doMLCZ+OMre0rYhaLZjFehWTJpikYR1wKXGbwJAr7Zl3xhVt8qnh5sQDy1XTuiu+nhQHApeeLhyq8/looxzoimpOoit1FJda/FTF+tKQdAHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418136; c=relaxed/simple;
	bh=wEBBmhxucJ3n5jb832F4l1kVSLkrTKPyrndN37O3NeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5ohQ6zLvhNdguIKQpNFvdOzLLv3GnLuAngIYk4ISk0s4MCTdcucmI4kFy0RTvnkIP0P/u5eMla7m2/hMDvGupFnV2XBfF0D3/gGOORTCvYGmyNNcre/SUv2qcbpngraOvH3oNEKPaH7PYn9sd8CfkwCTMjFkbWnbGHxe8laIew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RucyaPFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RucyaPFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6251F000C6;
	Mon, 19 Oct 2026 13:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418133;
	bh=Clz/JsIAWIaB4hcXgGGWbflHNAFrM7MQmWlusGb1bFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RucyaPFTMTNAJM149WTgzqCF11+VYLmD9HqEmU9pe8iWxw8iTnygZi0euDdxQqBax
	 T6/QEBJdVNcJgAZ5VxxgCKT04yte4lhbsvCuvsv4Q5XyWjL5WwbJswIACtdQUzsZqB
	 Q37qMbKRaVw6WVlhTceMvqse0n7R0y1ns7KeLKlRf6zbRhIyc/0Ilrlwb8IdTuRmKn
	 xsLHyEDQ7/U5d6WlBxmeaEfQtKfidnxHOgpS25G12xSXceBgg5VFgDd192bSWxJyL9
	 ReTTXNKjb5/ENdGpfDACXF0SUxTEuD7l9BrxwXwyNZ8YSYPFebUFDpkUJPlnmVO/OM
	 cuAevt0VB2KqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>,
	Michal Suchanek <msuchanek@suse.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ACPI: sysfs: Properly map BERT and CCEL data to their ACPI tables
Date: Mon, 19 Oct 2026 09:45:26 -0400
Message-ID: <20261019135441.1420968-35-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Renninger <trenn@suse.de>

[ Upstream commit e45ee607ca6f9f97a2f97be356d844a912971a16 ]

In the case of multiple BERT ACPI tables, one gets:

sysfs: cannot create duplicate filename '/firmware/acpi/tables/data/BERT'

This is because both:

/firmware/acpi/tables/BERT1
/firmware/acpi/tables/BERT2

are attempted to be mapped to the same data table:

/firmware/acpi/tables/data/BERT

Address this problem by passing and using the same filename for data
tables.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Reported-by: Michal Suchanek <msuchanek@suse.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1270211
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260717065129.72924-3-trenn@suse.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **mainline 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`,
`VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`). The commit under
review is already an ancestor of `HEAD` as `e45ee607ca6f9`. The verdict
is whether this fix is suitable to backport, based on the code and
history in this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ACPI sysfs] [Properly map] BERT and CCEL data sysfs names to
the same instance filenames as the parent ACPI tables.** Subsystem
prefix `ACPI: sysfs:`. “Properly map” is a correctness/fix verb even
without “fix”.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** Michal Suchanek `<msuchanek@suse.com>` (real distro
  report)
- **Closes:** `https://bugzilla.suse.com/show_bug.cgi?id=1270211`
- **Link:**
  `https://patch.msgid.link/20260717065129.72924-3-trenn@suse.de` (patch
  2/2 of a series)
- **Cc: stable:** absent (expected; not a negative signal)
- **Signed-off-by:** Thomas Renninger `<trenn@suse.de>` (author); Rafael
  J. Wysocki `<rafael.j.wysocki@intel.com>` (ACPI maintainer)
- **[ rjw: Subject and changelog edits ]** — maintainer edited the
  changelog before applying
- No Tested-by, Reviewed-by, Acked-by, or syzbot tags

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** With more than one BERT table, sysfs tries to create
  `/firmware/acpi/tables/data/BERT` twice.
- **Symptom:** `sysfs: cannot create duplicate filename
  '/firmware/acpi/tables/data/BERT'`. Table files are `BERT1`/`BERT2`;
  data files were all named `BERT`.
- **Failure mode:** `sysfs_warn_dup()` prints that warning and calls
  `dump_stack()` at boot. The second BERT (or CCEL) error region is
  never exported.
- **Version info:** none in the message.
- **Root cause:** `acpi_bert_data_init` / `acpi_ccel_data_init` hard-
  coded the bin-attribute name to `"BERT"` / `"CCEL"` instead of using
  the instance filename already computed for the table.

Cover letter (from the lore mbox) shows real firmware with two BERT
tables:

```
ACPI: BERT ... (v01 AMD    AMD BERT ...)
ACPI: BERT ... (v01 AMI    AMI.BERT ...)
sysfs: cannot create duplicate filename
'/firmware/acpi/tables/data/BERT'
```

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** This is an explicit sysfs-name collision fix. It
is not cleanup, refactor, or a new feature.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/acpi/sysfs.c` only — **+5 / −4** (9 lines).
- **Functions:** `acpi_bert_data_init`, `acpi_ccel_data_init`,
  `acpi_table_data_init`, `acpi_tables_sysfs_init`.
- **Struct:** `acpi_data_attr` gains `filename[]`.
- **Scope:** single-file surgical fix.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `acpi_table_attr_init()` already builds `BERT` vs
  `BERT1`/`BERT2`. `acpi_table_data_init()` then created data files with
  a hard-coded `"BERT"` / `"CCEL"` name.
- **After:** `acpi_table_data_init(th, table_attr)` copies
  `table_attr->filename` into `data_attr->filename` and uses that as the
  sysfs name. Data nodes match table nodes (`BERT`, or `BERT1`/`BERT2`).
- **Path:** boot-time ACPI sysfs init only (`acpi_tables_sysfs_init`).
  Return value of `acpi_table_data_init` is still ignored (pre-
  existing).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Logic / correctness]** Hard-coded sysfs names collide when
ACPI has multiple tables of the same signature. Fix: reuse the already-
instanced filename. Same pattern for BERT and CCEL.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. `acpi_table_attr_init()` runs first
  and fills `table_attr->filename`; then `acpi_table_data_init()` copies
  it. `attr.name` points at the heap `data_attr->filename` buffer, which
  lives as long as the bin attribute (same lifetime as the old string-
  literal names).
- **Single-table ABI:** unchanged. Instance suffix is added only when a
  second table exists (`instance > 1` or `acpi_get_table(..., 2, ...)`
  succeeds), so a lone BERT still appears as
  `/firmware/acpi/tables/data/BERT`.
- **Regression risk:** very low. No locking, no public API, no new sysfs
  files in the common case.
- **Not introduced here:** if `sysfs_create_bin_file()` fails,
  `data_attr` is still leaked (return value ignored). This patch avoids
  the duplicate-name failure; it does not add that leak.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- BERT data sysfs: **`7dae6326ed764`** (“ACPI / sysfs: Extend ACPI sysfs
  to provide access to boot error region”), Tony Luck, **v4.14-rc1**.
  Hard-coded `"BERT"` is from that commit.
- CCEL: **`4f855dcead6c5`** (“ACPI: sysfs: Enable ACPI sysfs support for
  CCEL records”), **v6.4-rc1**. Copied the same hard-coded-name pattern.
- Table instance filenames: `acpi_table_attr.filename` since
  **`1c8fce27e275fd`** (v2.6.36-era sysfs) / **`3278675567dfb9`**
  (ACPI_NAMESEG_SIZE rename, 2019).
- Buggy pattern has been in tree for years, not last-month code.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Introducer is `7dae6326ed764` (BERT, v4.14)
and `4f855dcead6c5` (CCEL, v6.4). Both are ancestors of this HEAD (`git
merge-base --is-ancestor` exit 0).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Immediate parent: **`f45c999e67120`** — series patch 1/2, BERT
  `sizeof` check (`acpi_hest_generic_status` → `acpi_bert_region`).
  Independent; this patch does not need it.
- No later commits on `drivers/acpi/sysfs.c` after `e45ee607ca6f9` (no
  follow-up revert or fix).
- **Standalone** as a 2/2 series member: patch 1 is a separate size-
  check fix.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Thomas Renninger is a long-time ACPI contributor (SUSE). Same-
day sibling is only the BERT sizeof patch. Merged by ACPI maintainer
Rafael J. Wysocki.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **None required for the naming fix.** It uses existing
`table_attr->filename`, `strscpy`, and `acpi_table_attr_init`.
`kzalloc_obj` in surrounding lines is later mainline allocation API and
is **not** introduced by this diff. On older trees the same hunks apply
around `kzalloc`. `strscpy` has been in the kernel since v4.3.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:** series at
  `https://patch.msgid.link/20260717065129.72924-3-trenn@suse.de`
- Cover: `[PATCH 0/2] Fix sysfs duplicate filename if multiple BERT
  tables exist`
- This commit is **[PATCH 2/2]** (msgid `...72924-3...`). Subject on the
  list differed slightly from the applied subject (rjw edited it).
- **v2:** cover says previously sent to linux-pm; v2 stopped using
  `acpi_get_table` inside data init and instead passes `table_attr`.
  Applied version is that v2.
- **Reviewer:** Rafael: “Applied (with some modifications in
  subjects/changelogs) as 7.3 material, thanks!” No NAK.
- **Stable nomination in review:** none found.
- lore.kernel.org WebFetch returned **403**; thread recovered via `b4
  dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: **b4 dig -w** recipients: Thomas Renninger, `linux-
acpi@vger.kernel.org`, Saket Dumbre (Intel ACPI), Michal Suchanek
(reporter). ACPI maintainer applied it. No separate Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: SUSE bugzilla 1270211 WebFetch **403** (likely login-walled).
Cover letter includes the reporter’s dmesg: two BERT tables (AMD + AMI)
and the exact sysfs duplicate warning. That is enough to treat it as a
real distro hit, not theoretical.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 2-patch series. Patch 1/2 (`f45c999e67120`) is an independent
BERT region-size check. This 2/2 patch does not depend on it.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No stable@ discussion found (lore WebFetch 403; web search did
not turn up a stable thread). **UNVERIFIED** whether anyone later asked
for or rejected it on stable@.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `acpi_bert_data_init`, `acpi_ccel_data_init`,
`acpi_table_data_init`, `acpi_tables_sysfs_init`. Struct field added on
`acpi_data_attr`.

**Step 5.2: TRACE CALLERS**

Record:
- `acpi_table_data_init` — only caller: `acpi_tables_sysfs_init`
- `acpi_tables_sysfs_init` — only caller: `acpi_sysfs_init`
  (`drivers/acpi/sysfs.c`)
- `acpi_sysfs_init` — called from `acpi_bus_init()` in
  `drivers/acpi/bus.c` during ACPI boot
- `acpi_sysfs_table_handler` (hot-added tables) does **not** call
  `acpi_table_data_init`; BERT/CCEL data nodes are boot-only. Confirmed
  with grep: only those two sites.

**Step 5.3: TRACE CALLEES**

Record: `kzalloc_obj` / `sysfs_attr_init` / `strscpy` /
`sysfs_create_bin_file` / `acpi_os_map_iomem` (read path). Init-time
sysfs creation, then userspace reads of BERT/CCEL error regions.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: ACPI boot → `acpi_bus_init` → `acpi_sysfs_init` →
`acpi_tables_sysfs_init` → per-table `acpi_table_data_init`. Triggered
on every ACPI boot that has BERT or CCEL. Userspace RAS tools read
`/sys/firmware/acpi/tables/data/`. Unprivileged users typically cannot
read these (mode `0400`). The **warning/dump_stack** happens in kernel
init regardless.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Only BERT and CCEL are in `acpi_data_objs[]`. Both had the same
hard-coded name. No other ACPI data table types in this file.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** BERT data sysfs since v4.14 (`7dae6326ed764`,
ancestor). CCEL since v6.4 (`4f855dcead6c5`, ancestor). The fix is
already applied here as `e45ee607ca6f9`. The bug is old, not introduced
after 7.3 branched.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean / minor context.** Hunks are localized. Older trees may
still use `kzalloc` instead of `kzalloc_obj` (adjacent lines only).
Pre-v6.4 trees have no CCEL function; BERT hunks still apply. `strscpy`
and `filename` on `acpi_table_attr` are present in long-term stables.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This is the fix. No earlier equivalent. No later follow-up on
this file.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM**

Record: **ACPI sysfs** (`drivers/acpi/sysfs.c`). **IMPORTANT** (not
mm/core, but ACPI boot sysfs on essentially all x86 and many ARM
servers). BERT is RAS/boot-error; CCEL is confidential-computing event
log.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature. BERT data mapping has been stable since 2017. Occasional
sysfs/BERT/CCEL fixes, not high churn.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Firmware-specific.** Systems with **two or more BERT** (or
CCEL) tables. Cover letter shows a real AMD + AMI dual-BERT OEM
firmware. Single-table systems are unaffected (same sysfs name as
before). CONFIG_ACPI.

**Step 8.2: TRIGGER CONDITIONS**

Record: **Every boot** on affected firmware. Not a race. Not
unprivileged-triggerable for the data read (0400), but the kernel
`dump_stack()` is automatic at init.

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- `sysfs_warn_dup()` → `pr_warn` + **`dump_stack()`**
  (`fs/sysfs/dir.c`). Looks like a kernel bug in dmesg; `panic_on_warn`
  would panic (unverified whether any of these machines set that).
- Second BERT/CCEL error region is not in sysfs, so RAS tools can miss
  boot errors.
- Boot continues; `acpi_table_data_init` return is ignored.
- **Severity: MEDIUM** (boot warning + missing diagnostic RAS data). Not
  oops/corruption/deadlock, but a real distro-reported “oh, that’s not
  good” bug.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** medium-high for dual-BERT firmware (every boot warning
  gone; both error regions exported). Zero change for the common single-
  table case.
- **Risk:** very low (5 insertions / 4 deletions, init-only naming).
- **Ratio:** favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**For backporting:**
- Real bug on real hardware (AMD BERT + AMI BERT), SUSE bugzilla +
  dmesg.
- `dump_stack()` on every boot; second error region missing from sysfs.
- Tiny, obviously correct, ACPI-maintainer merged, v2 after review.
- Bug present since v4.14 (BERT) / v6.4 (CCEL).
- No new APIs; single-table sysfs ABI unchanged.
- Standalone; does not need series patch 1/2.
- Matches stable-kernel-rules: a real bug that bothers distro users, and
  an “oh, that’s not good” sysfs warning.

**Against:**
- Not a panic, UAF, deadlock, or data-corruption bug in normal configs.
- Only dual BERT/CCEL firmware hits it (uncommon, but not fictional).
- No `Cc: stable` (not a negative signal here).
- Rafael called it “7.3 material” without mentioning stable.

**Unresolved:**
- SUSE bugzilla body (403).
- Whether stable@ ever discussed this (403 / no hits).
- Whether affected machines use `panic_on_warn`.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — naming logic is local and
   matches existing instance filenames; maintainer applied v2; reporter
   provided dmesg.
2. Fixes a real bug that affects users? **PASS** — distro report,
   dump_stack, missing BERT data node.
3. Important issue? **PASS** (medium) — boot `dump_stack` plus
   inaccessible RAS region; rules explicitly include “oh, that’s not
   good” and distro-reported issues.
4. Small and contained? **PASS** — 9 lines, one file.
5. No new features or APIs? **PASS** — corrects names of existing sysfs
   nodes.
6. Can apply to the local tree? **PASS** — already in this 7.3-rc4 tree;
   backport to older stables is clean or BERT-only on pre-CCEL trees.

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk, DT, build, or docs patch).
Qualifies as a normal small bugfix.

**Step 9.4: DECISION**

This is a small, correct fix for a user-visible boot warning and a real
RAS sysfs hole on multi-BERT firmware. The code has been wrong since
v4.14, the patch is surgical, and the common single-table ABI is
unchanged. That meets stable criteria.

---

## What the commit solves (for stable users)

On machines whose firmware publishes **two BERT tables** (seen with AMD
+ AMI), the kernel already creates `/sys/firmware/acpi/tables/BERT1` and
`BERT2`, but both data mappings used the name `BERT`.
`sysfs_create_bin_file()` fails, `sysfs_warn_dup()` dumps a stack at
every boot, and the second boot-error region is never exposed. The same
bug exists for multiple CCEL tables. The fix copies the table’s instance
filename onto the data node.

## Risk vs benefit

Benefit is removing a boot `dump_stack` and exporting all BERT/CCEL
regions on affected firmware. Risk is negligible: init-only string copy,
no locking, no ABI change when there is only one table.

## Concerns

Older stables without CCEL need the CCEL hunk dropped; BERT hunks still
apply. Adjacent `kzalloc_obj` is not part of this patch. Series patch
1/2 is optional, not a prerequisite.

---

## Verification

- **[Phase 1]** Parsed tags: Reported-by Michal Suchanek (SUSE), Closes
  bugzilla 1270211, Link patch 2/2, SOB author + Rafael; no
  Fixes/stable/syzbot.
- **[Phase 2]** `git show e45ee607ca6f9`: `drivers/acpi/sysfs.c` +5/−4;
  add `filename`, stop hard-coding `"BERT"`/`"CCEL"`, pass `table_attr`.
- **[Phase 2]** Read `acpi_table_attr_init` (instance suffix) and
  `acpi_tables_sysfs_init` (attr_init then data_init).
- **[Phase 2]** Read `sysfs_warn_dup` in `fs/sysfs/dir.c`: `pr_warn` +
  `dump_stack()`.
- **[Phase 3]** Blame: BERT data `7dae6326ed764` (v4.14-rc1), CCEL
  `4f855dcead6c5` (v6.4-rc1).
- **[Phase 3]** `git merge-base --is-ancestor 7dae6326ed764 HEAD` and
  `4f855dcead6c5 HEAD` and `e45ee607ca6f9 HEAD`: all 0 (present).
- **[Phase 3]** Sibling `f45c999e67120` is independent sizeof fix; no
  later sysfs.c commits after this one.
- **[Phase 4]** `b4 dig -c e45ee607ca6f9`: lore thread; v2 cover +
  dmesg; Rafael applied as 7.3 material; no NAK.
- **[Phase 4]** `b4 dig -w`: linux-acpi, Saket Dumbre, reporter on CC.
- **[Phase 4]** `b4 dig -m`: full mbox; WebFetch lore/bugzilla 403.
- **[Phase 5]** grep: `acpi_table_data_init` only from
  `acpi_tables_sysfs_init`; `acpi_sysfs_init` from `acpi_bus_init`.
- **[Phase 6]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → 7.3.0-rc4; buggy BERT/CCEL code in this
  lineage.
- **[Phase 8]** Failure mode: boot dump_stack + missing second data
  node; severity MEDIUM.
- **UNVERIFIED:** full SUSE bugzilla text; stable@ archives;
  `panic_on_warn` on affected hosts.

The patch is obviously correct, fixes a real distro-reported boot
warning and missing RAS sysfs data, is nine lines in one file, and does
not add features.

**YES**

 drivers/acpi/sysfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index e596224302f4c..d8d04437f63d6 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -316,6 +316,7 @@ struct acpi_table_attr {
 struct acpi_data_attr {
 	struct bin_attribute attr;
 	u64	addr;
+	char filename[ACPI_NAMESEG_SIZE+ACPI_INST_SIZE];
 };
 
 static ssize_t acpi_table_show(struct file *filp, struct kobject *kobj,
@@ -453,7 +454,6 @@ static int acpi_bert_data_init(void *th, struct acpi_data_attr *data_attr)
 	}
 	data_attr->addr = bert->address;
 	data_attr->attr.size = bert->region_length;
-	data_attr->attr.attr.name = "BERT";
 
 	return sysfs_create_bin_file(tables_data_kobj, &data_attr->attr);
 }
@@ -469,7 +469,6 @@ static int acpi_ccel_data_init(void *th, struct acpi_data_attr *data_attr)
 	}
 	data_attr->addr = ccel->log_area_start_address;
 	data_attr->attr.size = ccel->log_area_minimum_length;
-	data_attr->attr.attr.name = "CCEL";
 
 	return sysfs_create_bin_file(tables_data_kobj, &data_attr->attr);
 }
@@ -484,7 +483,7 @@ static struct acpi_data_obj {
 
 #define NUM_ACPI_DATA_OBJS ARRAY_SIZE(acpi_data_objs)
 
-static int acpi_table_data_init(struct acpi_table_header *th)
+static int acpi_table_data_init(struct acpi_table_header *th, struct acpi_table_attr *table_attr)
 {
 	struct acpi_data_attr *data_attr;
 	int i;
@@ -497,6 +496,8 @@ static int acpi_table_data_init(struct acpi_table_header *th)
 			sysfs_attr_init(&data_attr->attr.attr);
 			data_attr->attr.read = acpi_data_show;
 			data_attr->attr.attr.mode = 0400;
+			strscpy(data_attr->filename, table_attr->filename);
+			data_attr->attr.attr.name = data_attr->filename;
 			return acpi_data_objs[i].fn(th, data_attr);
 		}
 	}
@@ -543,7 +544,7 @@ static int acpi_tables_sysfs_init(void)
 			return ret;
 		}
 		list_add_tail(&table_attr->node, &acpi_table_attr_list);
-		acpi_table_data_init(table_header);
+		acpi_table_data_init(table_header, table_attr);
 	}
 
 	kobject_uevent(tables_kobj, KOBJ_ADD);
-- 
2.53.0

