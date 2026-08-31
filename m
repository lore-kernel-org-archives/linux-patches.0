Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183CA4EF5F5;
	Mon, 31 Aug 2026 13:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183648; cv=none; b=dPjkYgScdMJEAdYKMdBSjnl8YPqfObtUpgNu6EewzWwz5DZxd4+S1MO8bGbyKy9+vEpqhUJeY0Sq/6lZ/Nrw35ySUFj/eTHE581m6+3FJgQv8yoT8uvWvtESNMz6xzfLcG1pOLlfNNZpHXpPMyKlBcUHij2554LWRfdvWTaXlQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183648; c=relaxed/simple;
	bh=ybRXSEKDxyPR94oCX853SdCK/fOAeaJohqaHlv4szGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EVrUgxac/UdmAG5WLRENHjOQoIrkUK/ahxP5zMGsZf+FTn3bHdPiRToap7dCpkjatDr1lqY30IP/CEgU0lzazpQF4jyORJrpX2XAVLeMNTtnsJubyJJuAlOJptH9g4fnALz0dUEUZzSnaKih5nTpWQayeN2+AJejAGg68ZwWgqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZzN7QwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZzN7QwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F971F00ACF;
	Mon, 31 Aug 2026 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183646;
	bh=mRUTTgz3R/MNZTg3sShlIn2nyt4fV+v7UOFktzNW24w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZzN7QwYNsqelM0Q1elntEkh1C9Gnx3Mm9MAAuoRApCJnfpxTlqsrE3RiG8J0h3dm
	 G64FUJtgZZtgQ9+Wc9qYRClYL+GQm8tSdUhkX2TMd4ooLc+1BwiId7u7X7Ea/RoQJ5
	 DsNWyrpbi5wevOaucr+SAKWCYbM7PXJJS/pJnkhXHeW0ue/io1b21mZ1SYfkSHTkdl
	 TgXIKfflIoVj3fTY+toSnDpCfUaborwr/vBUMZsyrwePPusXIpygx3z2sm4eoE6Xxs
	 7y5OJ+9RkY+fwea1L4E6wj3os1+Jb54LbI1ZKkPMMoruChwhEfUq555ciEtuAvmnN5
	 gkBXazSBNwZbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ata: libata-core: Disable LPM on WD Green 2.5 480GB
Date: Mon, 31 Aug 2026 09:24:06 -0400
Message-ID: <20260831133314.4125787-218-sashal@kernel.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit d549df8a0ace611bff0a336a907f93420648b462 ]

According to a user report, the WD Green 2.5 480GB has problems with LPM.

Link: https://lore.kernel.org/linux-ide/CAGiKK17Fg4SgS+y0GzD3new44QzD_yPZU5V3ZeHdUr9mFnfn1Q@mail.gmail.com/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ata: libata-core: Disable LPM on WD Green
2.5 480GB`

**Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ata: libata-core]` `[Disable]` — disable Link Power
Management (LPM) for the WD Green 2.5 480GB SSD via a device quirk.

### Step 1.2: Tags
**Record:**
- **Link:** `https://lore.kernel.org/linux-ide/CAGiKK17Fg4SgS+y0GzD3new4
  4QzD_yPZU5V3ZeHdUr9mFnfn1Q@mail.gmail.com/` (user report)
- **Signed-off-by:** Niklas Cassel `<cassel@kernel.org>` (libata
  maintainer)
- **Signed-off-by:** Damien Le Moal `<dlemoal@kernel.org>` (libata co-
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Tested-by:`, or `Reviewed-
  by:` in the candidate message
- Part of a 2-patch series: `[PATCH 0/2] ata: disable LPM on some WDC
  drives` (2026-07-28)

### Step 1.3: Body analysis
**Record:**
- **Bug:** WD Green 2.5 480GB has problems with SATA Link Power
  Management.
- **Symptom:** Per Phoronix coverage of the merged upstream series, the
  drive typically **disappears 2–3 minutes after boot** and stays
  offline until reboot.
- **Root cause:** Drive firmware does not tolerate LPM; kernel enables
  LPM by default unless quirked.
- **Workaround:** `libata.force=nolpm` boot parameter (confirmed by
  Phoronix).

### Step 1.4: Hidden bug fix?
**Record:** Yes — presented as a quirk addition, but it fixes a real
hardware compatibility bug (drive drop-off), not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/ata/libata-core.c` (+1 line)
- **Function/area:** `__ata_dev_quirks[]` static quirk table
- **Scope:** Single-line, single-file hardware quirk

### Step 2.2: Code flow change
**Record:**
- **Before:** WD Green 2.5 480GB not in quirk table → LPM may be enabled
  → drive can drop off link.
- **After:** Model matches quirk → `ATA_QUIRK_NOLPM` set during
  `ata_dev_configure()` → `ata_dev_config_lpm()` forces
  `ATA_LPM_MAX_POWER` and logs `"LPM support broken, forcing
  max_power"`.
- **Path:** Device probe/enumeration (normal boot path for affected
  hardware).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround / quirk
- **Mechanism:** Broken device firmware mishandles SATA LPM; kernel
  disables LPM for this exact model string, same pattern as existing
  Seagate, ADATA, Samsung, Crucial NOLPM entries in this tree.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: identical to multiple existing NOLPM quirk entries
  already in 6.18.44.
- Minimal scope: one table entry.
- **Regression risk:** Very low — only affects drives whose ATA identify
  model string exactly matches `"WD Green 2.5 480GB"` (per
  `glob_match()` full-string semantics in `lib/glob.c`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Quirk table in this tree dates to long-standing libata code
(WD SATA-I `ATA_QUIRK_WD_BROKEN_LPM` entries unchanged since v6.18 merge
base). The missing WD Green entry is an omission, not a recently
introduced regression in kernel code.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent NOLPM quirk backports already in **this** 6.18.44
tree:
- `a70fd483c4b93` — ST2000DM008-2FR102 (Jan 2026)
- `87f0349beaaca` — ST1000DM010-2EP102 (Mar 2026, `Cc: stable`)
- `2229b4cf97301` — ADATA SU680 (Mar 2026, `Cc: stable`)

This commit is patch **2/2** of a series; patch **1/2**
(`20b72163992eb`, WD100EFGX/WD102KFBX) is **not** in current HEAD but is
independent for this drive.

### Step 3.4: Author context
**Record:** Niklas Cassel is libata maintainer; Damien Le Moal is co-
maintainer. Same authors/maintainers as prior NOLPM quirk backports in
this tree.

### Step 3.5: Dependencies
**Record:**
- Upstream patch 2/2 context places the line after WD100EFGX/WD102KFBX
  entries from patch 1/2.
- In **6.18.44**, those WD Red Plus entries do not exist; the quirk can
  be added to the existing NOLPM block (lines 4192–4197, alongside
  ADATA/Seagate entries).
- **Standalone for this device:** does not require patch 1/2 to
  function.
- Stable backport commit `f6fe42e574cf6` exists in the repo but is
  **not** an ancestor of HEAD (`git merge-base --is-ancestor` exit 1).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c d549df8a0ace6` →
  `https://patch.msgid.link/20260728111310.722450-6-cassel@kernel.org`
- Ratatoskr archive confirms series: PATCH 0/2, 1/2, 2/2 (2026-07-28);
  Damien Le Moal replied 2026-07-29 (series accepted upstream).
- Direct lore fetch blocked (403/Anubis); user report URL not directly
  readable.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned only the msgid link (no recipient
list). Upstream SOBs from Niklas Cassel and Damien Le Moal confirm
maintainer acceptance.

### Step 4.3: Bug report details
**Record:**
- **Phoronix (2026-08-01):** WD Green 2.5 480GB disappears 2–3 minutes
  after boot; `libata.force=nolpm` is the workaround.
- **linux-hardware.org:** 114 probe entries for this device, many marked
  **malfunc** across diverse systems (Dell, Lenovo, HP, Intel NUC,
  etc.).
- **bugzilla.kernel.org #220693** referenced by patch 1/2 (WD Red
  drives), not this specific drive.

### Step 4.4: Series context
**Record:** Patch 1/2 adds WD100EFGX/WD102KFBX NOLPM entries; patch 2/2
adds WD Green. Each is independently useful for its respective hardware.

### Step 4.5: Stable list history
**Record:** Not searched on lore stable list (blocked). Prior NOLPM
quirk commits in this tree explicitly carried `Cc:
stable@vger.kernel.org`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `__ata_dev_quirks[]`, `ata_dev_quirks()`,
`ata_dev_configure()`, `ata_dev_config_lpm()`.

### Step 5.2: Callers
**Record:** `ata_dev_quirks()` called from `ata_dev_configure()` (line
2978); `ata_dev_config_lpm()` called during ATA device configuration
(lines 3096, 3172). Every SATA disk probe goes through this path.

### Step 5.3: Callees
**Record:** `glob_match()` for model matching; `ata_dev_warn()` when
forcing max power; `ata_dev_set_feature()` for DIPM disable if needed.

### Step 5.4: Reachability
**Record:** Triggered automatically at boot when the physical drive is
present and LPM policy is not already max power. No special config
required beyond normal SATA/AHCI.

### Step 5.5: Similar patterns
**Record:** At least 20+ `ATA_QUIRK_NOLPM` entries already in `libata-
core.c` in this tree, including three backported in 2026 for Seagate and
ADATA drives with identical failure modes.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** `ATA_QUIRK_NOLPM`, `ata_dev_config_lpm()`, and the
quirk table all exist. The WD Green entry is **absent** (`grep` finds no
match). LPM can still be enabled for this drive in 6.18.44.

### Step 6.2: Backport complications
**Record:** **Minor placement adjustment.** Upstream context assumes
patch 1/2 entries exist; in 6.18.44 the line belongs in the existing
NOLPM section (~line 4197). Trivial one-line addition, no structural
changes needed.

### Step 6.3: Related fixes already present?
**Record:** No WD Green quirk in HEAD. Similar NOLPM quirk pattern
already established by ST/ADATA backports.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/ata/` — **IMPORTANT** (storage stack; affects any
system with this SATA SSD).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; multiple ATA quirk/fix commits in
6.18.44 history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with a WD Green 2.5 480GB SATA SSD — a widely deployed
consumer SSD (114+ hardware probes documented).

### Step 8.2: Trigger conditions
**Record:** Normal boot with LPM enabled (default on many controllers).
Reproducible within minutes per user/Phoronix reports. Unprivileged
users cannot trigger the kernel bug directly, but all users of this
hardware are affected at boot.

### Step 8.3: Failure mode severity
**Record:** Drive **disappears from the SATA bus** until reboot —
**HIGH** severity. Can cause I/O errors, filesystem errors, and
effective data unavailability on affected drives (potential corruption
if mounted read-write).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — restores reliable operation for a known-broken
  device model.
- **Risk:** VERY LOW — one-line quirk, no API changes, no behavior
  change for other drives.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real user-reported hardware bug with documented symptoms (drive drop-
  off).
- Same fix class as three NOLPM quirk backports already in 6.18.44.
- Maintainers (Cassel, Le Moal) authored and accepted upstream.
- Trivial, obviously correct one-line change.
- Falls under stable **hardware quirk exception**.
- Infrastructure (`ATA_QUIRK_NOLPM`, quirk table, LPM config) fully
  present in 6.18.44.
- Workaround (`libata.force=nolpm`) confirms the diagnosis.

**AGAINST backport:**
- Patch 2/2 upstream context references patch 1/2 placement (cosmetic
  backport adjustment only).
- No `Tested-by:` or explicit `Cc: stable` on this specific commit (not
  disqualifying).
- Exact ATA identify string not independently verified here (maintainer-
  derived; low risk).

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard quirk; upstream
merged; maintainer SOBs |
| 2. Fixes a real bug affecting users? | **PASS** — drive disappears
with LPM enabled |
| 3. Important issue? | **PASS** — HIGH: storage device becomes
inaccessible |
| 4. Small and contained? | **PASS** — 1 line, 1 file |
| 5. No new features/APIs? | **PASS** — quirk table entry only |
| 6. Can apply to local tree? | **PASS** — add to existing NOLPM section
|

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — textbook stable material.

### Step 9.4: Decision rationale
For Linux **6.18.44**, this commit should be backported. The WD Green
2.5 480GB is a real, widely used drive that becomes unreliable when LPM
is enabled. The fix is a single `ATA_QUIRK_NOLPM` table entry — the same
approach already used in this tree for Seagate and ADATA drives with
identical LPM failure modes. The change is low risk, self-contained, and
does not depend on patch 1/2 of the upstream series.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; identified as patch 2/2 of
  WDC LPM series.
- **[Phase 1]** Link tag points to linux-ide user report (direct fetch
  blocked).
- **[Phase 2]** Diff: +1 line in `__ata_dev_quirks[]` with
  `ATA_QUIRK_NOLPM`.
- **[Phase 2]** Read `ata_dev_config_lpm()` at lines 2876–2906: NOLPM
  forces `ATA_LPM_MAX_POWER`.
- **[Phase 2]** Read `glob_match()` in `lib/glob.c`: pattern must match
  entire string.
- **[Phase 3]** `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`;
  Makefile VERSION 6.18.44.
- **[Phase 3]** `grep "WD Green"` in tree → no matches (quirk absent
  from HEAD).
- **[Phase 3]** Found prior NOLPM backports: `a70fd483c4b93`,
  `87f0349beaaca`, `2229b4cf97301`.
- **[Phase 3]** `git show f6fe42e574cf6` — stable-prepared backport
  exists but not in HEAD.
- **[Phase 3]** `git merge-base --is-ancestor f6fe42e574cf6 HEAD` → exit
  1 (not in HEAD).
- **[Phase 3]** `git show 20b72163992eb` — patch 1/2 also not in HEAD.
- **[Phase 4]** `b4 dig -c d549df8a0ace6` → patch msgid link found.
- **[Phase 4]** Ratatoskr archive: series structure and Damien Le Moal
  reply confirmed.
- **[Phase 4]** Phoronix article: drive disappears 2–3 min after boot;
  `libata.force=nolpm` workaround.
- **[Phase 4]** linux-hardware.org: 114 probes, many "malfunc" status
  entries.
- **[Phase 5]** `ata_dev_quirks()` called from `ata_dev_configure()`
  line 2978.
- **[Phase 5]** `ata_dev_config_lpm()` called at lines 3096, 3172.
- **[Phase 6]** `ATA_QUIRK_NOLPM` defined in `include/linux/libata.h`.
- **[Phase 6]** NOLPM quirk section present at lines 4192–4197 in
  current tree.
- **[Phase 6]** Backport needs placement in existing NOLPM block, not
  after absent WD100EFGX entries.
- **[Phase 8]** Failure mode: drive bus drop-off, severity HIGH.

**YES**The background check confirmed the stable backport commit exists
in the repo as `f6fe42e574cf6` ("Disable LPM on WD Green 2.5 480GB"),
but it is **not** on the current HEAD (`6.18.44`). The quirk is still
missing from the checked-out tree.

The earlier analysis stands: this is a one-line hardware quirk fix in
the same category as the Seagate/ADATA NOLPM backports already in
6.18.y, and it should be backported.

**YES**

 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ae1e5f82026c5..a7a89b675a912 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4379,6 +4379,7 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	 */
 	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WD Green 2.5 480GB",		NULL,	ATA_QUIRK_NOLPM },
 
 	/*
 	 * This sata dom device goes on a walkabout when the ATA_LOG_DIRECTORY
-- 
2.53.0

