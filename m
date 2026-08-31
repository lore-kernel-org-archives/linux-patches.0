Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB683521210;
	Mon, 31 Aug 2026 13:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183855; cv=none; b=BnigulsA3j5w+GoJ0Mjd6wb5EgnLJxrdk3NABh1WOh8n0Bym6vfwG5wIRZsDT6XodTEUCVYNc+4hNe2JeHa5HHYL2P+rXxTHloWo1nDeVDwx64EPBhNf8dVP75xl3UiAcRb9EDPhSBhpVwR2Edghg3okI9gp+WiErIXgvviXJc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183855; c=relaxed/simple;
	bh=9UVlpdY2+yBE/50frAkHYJdIgkUz+ShHyHuMH0CWi2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AwcoBdIlBgs45z4tI6v9isFOcpUEC+x+2UFpvoztvVaWCiOV0gALF/majqvDZOXGhAgnuMxjHT55XJIeJJgnjhm7gUmLstWTa+HdFRwLLoI9bcU2TvgE4Q9RqLO/8Kz57mcptqDueps3YvovpDv4Zf3qPsfZvue3zxOm1GVn5lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLk/2A6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLk/2A6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077E01F00A3E;
	Mon, 31 Aug 2026 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183851;
	bh=QXRzar77aJt/WkXV87uNtCkSjKWYNfrHbwi6KZO9GUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLk/2A6Bp/XVkKA1mZ5RzaHay0XmceXligCyTi//WFaY5hxDudLnAjanAMKgg7osU
	 PTSiR80y/52SHOKoBhAAtHGiQ5TPHBsVgd/+Llz8UkdYGo+efIxE2A4WhuKkDGKaO1
	 K1BhliPYpkFaffXZ3Ohh5Gp3/A4tZ41Xx4rbENXJK5QvX/IAtbXUu9giJtNWUD2NsH
	 q3LdDyQodkTy9PFmU5zO99wFacjpWSKJ04vAG8FVfMOLGnX5Lpkd9vkXz248Y46Zdf
	 66nujuGFTyxQcGyLIj/DLY32UbG7l9XpU5Epx811n77OcL7kk9ru3K5NZWEb1/yMQQ
	 EM6Gw1aIT+pkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jetha Chan <jethachan@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: amd: yc: Add Alienware m15 R7 AMD to DMIC quirk table
Date: Mon, 31 Aug 2026 09:26:10 -0400
Message-ID: <20260831133314.4125787-342-sashal@kernel.org>
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

From: Jetha Chan <jethachan@gmail.com>

[ Upstream commit e782d687d2f5bf8b8113dc48ba22cca4b472c252 ]

The Alienware m15 R7 AMD exposes an ACP6x DMIC path, but its DMI
product name is not present in the Yellow Carp ACP quirk table. As a
result, the ACP machine driver does not enable the DMIC card on this
system.

Add the DMI product name for this machine. With this quirk applied, the
kernel reports:

  acp_yc_mach acp_yc_mach.0: Enabling ACP DMIC support via DMI

and ALSA exposes the ACP DMIC capture device:

  card 3: acp6x
  device 0: DMIC capture dmic-hifi-0

Tested on an Alienware m15 R7 AMD with product SKU 0B59.

Link: https://jethachan.net/dev/2026/03/21/fixing-internal-microphone-alienware-linux.html
Assisted-by: OpenAI-Codex:gpt-5.5
Signed-off-by: Jetha Chan <jethachan@gmail.com>
Link: https://patch.msgid.link/20260630003328.15675-1-jethachan@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ASoC: amd: yc: Add Alienware m15 R7 AMD to
DMIC quirk table

**Local tree:** `v6.18.44-1-g2736c32da98b9` (Makefile: 6.18.44), checked
out from `stable/linux-6.18.y`.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ASoC: amd: yc] [add] Add Alienware m15 R7 AMD to DMIC
quirk table`

### Step 1.2: Tags
**Record:**
- **Link:** https://jethachan.net/dev/2026/03/21/fixing-internal-
  microphone-alienware-linux.html (author blog with reproduction
  details)
- **Link:**
  https://patch.msgid.link/20260630003328.15675-1-jethachan@gmail.com
  (mailing list submission)
- **Assisted-by:** OpenAI-Codex:gpt-5.5
- **Signed-off-by:** Jetha Chan \<jethachan@gmail.com\>
- **Signed-off-by:** Mark Brown \<broonie@kernel.org\> (ASoC maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer Signed-off-by; hardware-tested per commit body

### Step 1.3: Body analysis
**Record:**
- **Bug:** Alienware m15 R7 AMD has ACP6x DMIC hardware, but DMI product
  name is missing from `yc_acp_quirk_table`, so the ACP machine driver
  does not enable DMIC.
- **Symptom:** `acp_yc_mach.0` stays unbound; no ACP DMIC ALSA capture
  device; internal microphone unusable.
- **Root cause:** BIOS does not expose working `AcpDmicConnected` ACPI
  property (same pattern as m17 R5 AMD quirk from 2022).
- **Fix approach:** Add DMI vendor/product match entry pointing at
  `acp6x_card`.
- **Version info:** Tested on SKU 0B59; author used kernel 6.19.8 on
  Arch-based distro.

### Step 1.4: Hidden bug fix?
**Record:** Not disguised — this is an explicit hardware-enablement
quirk fix. Without the entry, probe returns `-ENODEV` and DMIC never
registers.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/soc/amd/yc/acp6x-mach.c` (+7 lines, 0 removed)
- **Functions modified:** none directly; `yc_acp_quirk_table[]` data
  extended
- **Scope:** Single-file, surgical DMI table addition

### Step 2.2: Code flow change
**Record:**
- **Before:** `dmi_first_match(yc_acp_quirk_table)` on Alienware m15 R7
  AMD returns NULL → `platform_get_drvdata()` NULL → probe fails with
  `-ENODEV`.
- **After:** DMI match succeeds → `platform_set_drvdata(pdev,
  &acp6x_card)` → DMIC card registers, log shows `"Enabling ACP DMIC
  support via DMI"`.
- **Path affected:** Platform driver probe during boot on matching
  hardware only.

### Step 2.3: Bug mechanism
**Record:** **[Hardware workaround / DMI quirk]** — Missing DMI override
for a platform whose ACPI tables omit `AcpDmicConnected`. Same mechanism
as existing Alienware m17 R5 AMD entry (`d40b6529c6269`).

### Step 2.4: Fix quality
**Record:**
- Obviously correct: identical structure to 70+ existing entries in the
  same table.
- Minimal, no logic changes.
- **Regression risk:** Very low — only matches exact DMI vendor
  `"Alienware"` + product `"Alienware m15 R7 AMD"`.
- **Backport note:** Mainline diff context includes MSI Vector/Raider
  entries not present in 6.18.44; insertion should go immediately before
  the existing m17 entry at lines 503–509. Trivial adjustment, same
  7-line hunk content.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Alienware m17 R5 AMD quirk introduced by `d40b6529c6269` (Brent
  Mendelsohn, 2022-10-24).
- YC machine driver introduced by `fa991481b8b22` (2021-10-18).
- Both are ancestors of HEAD in this tree.
- **m15 R7 AMD entry:** NOT present (`git log -S "Alienware m15 R7 AMD"
  -- sound/soc/amd/yc/acp6x-mach.c` returns empty).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Bug is omission from quirk table, not a
regression from a specific commit.

### Step 3.3: Related file history
**Record:** 73 quirk-related commits in `sound/soc/amd/yc/`. Recent
stable examples: HP OMEN (`65aabf8896687`), MSI Bravo 17 D7VF
(`ba06528ad5a31`), ASUS ExpertBook entries. **20** DMI quirk commits
already in `stable/linux-6.18.y` for this subsystem. Standalone one-
patch fix.

### Step 3.4: Author context
**Record:** Jetha Chan is not a regular ASoC contributor (only unrelated
Alienware platform/x86 commit `246f9bb62016c` in tree). Patch merged by
Mark Brown. Precedent: community hardware reports routinely land as DMI
quirks in this file.

### Step 3.5: Dependencies
**Record:** No dependencies. Requires only `SND_SOC_AMD_YC_MACH` driver
and `yc_acp_quirk_table` — both present since kernel ~5.15+. Applies
standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig` with message-id failed (commit not in local repo; lore
  blocked by Anubis bot protection).
- Author blog post fetched successfully — detailed reproduction
  confirming DMI mismatch and successful module-level test.

### Step 4.2: Reviewers
**Record:** Mark Brown Signed-off-by confirms maintainer acceptance.
Could not verify CC list via b4 dig -w (tool failure / commit not
indexed locally).

### Step 4.3: Bug report
**Record:** Blog documents: `acp_yc_mach.0` unbound, only HDA cards
visible, DMI product `"Alienware m15 R7 AMD"` vs table having only m17.
Severity from user perspective: **complete internal mic failure**. m17
R5 had bugzilla.kernel.org #216590 for same class of issue.

### Step 4.4: Related patches
**Record:** Standalone. Related sibling: `d40b6529c6269` (m17 R5 AMD,
same table, same symptom class).

### Step 4.5: Stable list history
**Record:** Could not search lore stable archive (bot protection).
However, 20 prior DMI quirk commits for this exact driver are already in
`stable/linux-6.18.y`, establishing clear precedent.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `acp6x_probe()` uses `yc_acp_quirk_table[]`; table data
extended only.

### Step 5.2: Callers
**Record:** `acp6x_probe` registered as `.probe` in `acp6x_mach_driver`,
invoked via `module_platform_driver()` at boot when
`CONFIG_SND_SOC_AMD_YC_MACH` is enabled and ACPI platform device exists.

### Step 5.3: Callees
**Record:** `dmi_first_match()`, `platform_set_drvdata()`,
`devm_snd_soc_register_card()`.

### Step 5.4: Reachability
**Record:** Triggered on every boot for Alienware m15 R7 AMD with YC ACP
hardware and module built-in or loaded. Not userspace-triggerable, but
affects all owners of this laptop model at boot.

### Step 5.5: Similar patterns
**Record:** Entire `yc_acp_quirk_table[]` is a catalog of identical per-
laptop DMI overrides for broken/missing ACPI DMIC detection. Alienware
m17 R5 AMD entry at lines 503–509 is the direct sibling.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **YES.** File `sound/soc/amd/yc/acp6x-mach.c` exists. Quirk
table and probe logic present. m17 R5 AMD quirk present; **m15 R7 AMD
missing** — bug is live in 6.18.44.

### Step 6.2: Backport complications
**Record:** **Minor context adjustment.** Mainline patch context
references MSI Vector/Raider entries absent from 6.18.44; insert before
existing Alienware m17 block. No structural conflicts.

### Step 6.3: Related fixes already present?
**Record:** m17 R5 AMD quirk (`d40b6529c6269`) present. No m15 fix. No
duplicate.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **sound/ASoC AMD YC driver** — IMPORTANT for affected laptop
users; PERIPHERAL in global kernel terms (config-dependent, specific
hardware).

### Step 7.2: Subsystem activity
**Record:** Highly active — continuous DMI quirk additions through
2025–2026, many backported to 6.18.y stable.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Owners of Alienware m15 R7 AMD laptops running kernels with
`SND_SOC_AMD_YC_MACH` enabled (common on AMD Rembrandt/Yellow Carp
laptops).

### Step 8.2: Trigger conditions
**Record:** Every boot on matching DMI identity. Deterministic, not a
race. Unprivileged users cannot trigger the fix path, but all users on
this hardware are affected by the bug.

### Step 8.3: Failure mode severity
**Record:** Internal DMIC completely non-functional (driver probe
fails). **Severity: MEDIUM** — not crash/corruption/security, but core
laptop functionality broken. Falls under stable **hardware quirk
exception**.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected users (working internal microphone).
- **Risk:** VERY LOW (7-line DMI string, exact hardware match only).
- **Ratio:** Strongly favorable; matches established stable practice for
  this file.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real, reproducible hardware bug (dead internal mic)
- Hardware quirk / DMI workaround — explicit stable exception category
- 7-line, single-file, obviously correct
- Tested on real hardware; ASoC maintainer Signed-off-by
- Identical pattern to m17 R5 quirk already in tree since 2022
- 20 similar quirk commits already in 6.18.y stable for this driver
- Driver and quirk infrastructure fully present in this tree
- No new APIs, no behavior change for non-matching systems

**AGAINST backport:**
- Not a crash, security, or data-corruption issue (strict "important
  issue" reading)
- Lore review thread not accessible for verification
- Minor patch context adjustment needed vs mainline

**Unresolved:**
- Full mailing list review thread (Anubis blocked lore.kernel.org)
- b4 dig could not resolve commit hash (not in local tree)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — same pattern as dozens of
   accepted quirks; author tested on hardware
2. Fixes real bug affecting users? **PASS** — internal microphone
   completely broken
3. Important issue? **PASS** (hardware quirk exception) — functional
   hardware failure on a commercial laptop
4. Small and contained? **PASS** — 7 lines, 1 file
5. No new features or APIs? **PASS** — DMI table entry only
6. Can apply to local tree? **PASS** — trivial insertion before existing
   Alienware m17 entry

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — DMI-based enablement for
laptop with broken ACPI DMIC detection.

### Step 9.4: Problem and decision rationale

This commit solves a concrete hardware support gap: the Alienware m15 R7
AMD has an ACP6x DMIC path, but without a DMI quirk the `acp_yc_mach`
platform driver refuses to bind because ACPI does not report
`AcpDmicConnected`. The result is no internal microphone on Linux — a
user-visible regression-class hardware issue, not a cosmetic fix.

For the 6.18.y stable tree specifically, all infrastructure exists (YC
driver since 2021, m17 sibling quirk since 2022, continuous stable
backport of identical quirk patches). The fix is minimal, maintainer-
reviewed, and carries negligible regression risk while restoring
essential laptop functionality for a defined hardware population.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Fetched author blog: confirmed DMI mismatch, unbound
  `acp_yc_mach`, successful DMIC after quirk
- **[Phase 2]** Diff: +7 lines to `yc_acp_quirk_table[]` in
  `acp6x-mach.c`
- **[Phase 2]** Read `acp6x_probe()` lines 758–816: confirmed DMI match
  enables `acp6x_card`, no match → `-ENODEV`
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- **[Phase 3]** `git log -S "Alienware m15 R7 AMD"`: empty — commit not
  in tree
- **[Phase 3]** `git blame` lines 503–509: m17 quirk from
  `d40b6529c6269` (2022-10-24)
- **[Phase 3]** `git merge-base --is-ancestor d40b6529c6269 HEAD`: m17
  quirk is ancestor
- **[Phase 3]** `git merge-base --is-ancestor fa991481b8b22 HEAD`: YC
  driver is ancestor
- **[Phase 3]** `git log --oneline -20 --
  sound/soc/amd/yc/acp6x-mach.c`: many recent quirk commits
- **[Phase 3]** `git show d40b6529c6269`: m17 quirk, same bug class,
  bugzilla #216590
- **[Phase 4]** `b4 dig` for new patch message-id: failed (exit 2)
- **[Phase 4]** lore.kernel.org fetch: blocked by Anubis bot protection
- **[Phase 4]** Blog fetch: success — full reproduction details
- **[Phase 5]** `grep acp6x_probe/dmi_first_match`: probe at line 758,
  DMI check at 798
- **[Phase 6]** `grep "Alienware" acp6x-mach.c`: only m17 R5 present,
  m15 R7 absent
- **[Phase 6]** Confirmed Vector A16/Raider A18 from mainline diff
  context not in 6.18.44 tree
- **[Phase 6]** `git log stable/linux-6.18.y --grep="DMI quirk" --
  sound/soc/amd/yc/ | wc -l`: 20 quirk commits in stable
- **[Phase 7]** Read `sound/soc/amd/Kconfig` lines 107–116:
  `SND_SOC_AMD_YC_MACH` config exists
- **[Phase 8]** Failure mode verified via probe code: no DMI match →
  `-ENODEV` → no DMIC card

**YES**The background searches finished and match what the analysis
already used:

- **Author/subject search:** No ASoC quirk commit for "Alienware m15 R7
  AMD" in this tree. The only m15 R7 hits are unrelated `platform/x86`
  Alienware WMI work.
- **Stable quirk count:** **20** DMI quirk commits for
  `sound/soc/amd/yc/` are already in `stable/linux-6.18.y`, including
  the sibling `d40b6529c6269` (Alienware m17 R5 AMD) entry.

That supports the **YES** backport verdict for 6.18.y: same quirk
pattern, driver and table already present, only the m15 R7 DMI entry is
missing.The target-commit search finished: **"Alienware m15 R7 AMD" is
not in `sound/soc/amd/yc/acp6x-mach.c` in this tree.** The only m15 R7
matches are unrelated `platform/x86` Alienware WMI commits, which
confirms the ASoC DMIC quirk patch still needs to be backported.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index d9f145b634f35..d657287ccf43e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -500,6 +500,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m15 R7 AMD"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

