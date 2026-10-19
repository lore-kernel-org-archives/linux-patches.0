Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7762256CE04;
	Mon, 19 Oct 2026 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418280; cv=none; b=ArLc2kVp079IDvSycHytREHYfX+ut9vjN3H69uNrqN6RPxmlWWrAgfgwtQdXYzchRH4r4SnWWch3JrKj/HKuyjLxgRQOSI6Ozpbfx15Kal0H00kjPoi2dirvNHtitQuD3cnwYVhzYCxjkGzPlhqf93/EXWgajViJ/TtfRs12sBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418280; c=relaxed/simple;
	bh=p7XwU1Cmktg71iLWiSqZGVHzdkqB53V+abIuVga9KAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/zFei94h7iKJ8L6f//N06c4Iaq1r02L1f6yLvpd3DyjhKFgRBW7y7UZjj0kOArjtMoaaFHQu9gSmfTIQL87FjkGWMiTcAYlumN2bGnikfdpPgmQZxdp34sBpTBNHKjIUpjbvWIGBMVbHI3llbzydjvs4U7T5gG3V83Wc39b0qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzBbMgz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzBbMgz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA751F000C6;
	Mon, 19 Oct 2026 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418278;
	bh=ZePzfD06LTtY9SuocAapOamZxhL1BzMjFtw4kmvDVuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzBbMgz6ZQkbYTQQDL3XPiDvofPaOy93nh7jRztpHNWgb2M0AWhoXFMOdAr1TXHJC
	 RxD2+LOeOO7JR3UMiKqXFN6HysV2yUJ5fZSXcnzZawMJ5VQZxWs8qESK12tQNC2IBk
	 BXUXaWz0DgCKLwnAQDdtNzzFlYFa/qaPBmlv3PSQPxHNMCR9InCmrtifWs+axdizmi
	 E1e1CepSIxyu5tFRdQ9GWlxaXtz+4ObuB0v9kN92xfmwvXIo8dyJSoCg5+H+3t3ei6
	 YBpXVoqZiOjQBpaujZsl6DBRC2c1z5pNqB/lM2zRqspktlioNkpgJhanrSGwkqbXpH
	 ugkwOBw6+ZMPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] soundwire: dmi-quirks: Disable ghost Realtek on Asus Expertbook
Date: Mon, 19 Oct 2026 09:47:05 -0400
Message-ID: <20261019135441.1420968-134-sashal@kernel.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 90af3209742db61a7f9d7d054a16165818cfc6d8 ]

The Asus Expertbook B9406CAA also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine driver
into attempting to create DAI links for the device. Add a quirk to
remove this device.

Closes: https://github.com/thesofproject/linux/issues/5828
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260630081132.3294488-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a DMI hardware quirk for a user-
confirmed “no sound” failure, and the `ghost_realtek` machinery already
exists in this 7.3 tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [soundwire: dmi-quirks] [Disable] [DMI quirk to hide a ghost
Realtek SoundWire device on Asus Expertbook B9406CAA]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Closes: https://github.com/thesofproject/linux/issues/5828 (user-filed
  SOF audio bug)
- Signed-off-by: Charles Keepax (author)
- Link: https://patch.msgid.link/20260630081132.3294488-1-
  ckeepax@opensource.cirrus.com
- Signed-off-by: Vinod Koul (SoundWire maintainer)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by in the committed
  message
- Ignore pipeline SOBs: none present (no Sasha Levin marker)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: ACPI lists a Realtek SoundWire device that is not physically
  present on Asus Expertbook B9406CAA.
- Symptom: the machine driver tries to create DAI links for that ghost
  device; audio probe fails (dummy output / no card).
- Version info in the GitHub issue (not the commit body): worked on 7.0,
  broken since 7.1 after function-topology matching.
- Root cause: firmware/ACPI advertises RT722 on link 3; function
  topology builds the card from ACPI, so the ghost device breaks card
  creation.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware quirk. The
“add a table entry” form is the standard stable-acceptable quirk
pattern.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/soundwire/dmi-quirks.c` (+7 / −0)
- Function/data: `adr_remap_quirk_table[]` only (no new functions)
- Scope: single-file surgical DMI match addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: B9406CAA did not match `adr_remap_quirk_table`, so ACPI `_ADR`
  0x000330025d072201 (RT722 on link 3) stayed visible.
- After: DMI match `ASUS` + board `B9406CAA` uses existing
  `ghost_realtek[]`, remapping that `_ADR` to 0.
- Path: SoundWire ACPI slave discovery (`find_slave()`), not a hot path
  or a new API.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware workaround / DMI quirk]
Mechanism: `ghost_realtek[]` remaps `0x000330025d072201` → `0`.
`find_slave()` does `if (!addr) return false;`, so the ghost device is
not registered and sof_sdw does not build DAI links for it.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and minimal. Same pattern as UX5406AA / Lenovo
83QK / 83SF. Regression risk is very low: only that DMI pair is
affected; other machines are unchanged.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: The new B9406CAA block is this commit (`90af3209742db`,
2026-06-30). `ghost_realtek[]` and the PTL comment come from
`4dab2b904414f` (“Disable ghost Realtek devices”, 2026-05-20, in v7.2).
`dmi-quirks.c` itself dates to `f6594cdfec4cd` (v5.13).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The user-visible regression was function topology
in 7.1 (`e0fb794d67f86` / `45cf24da0a10` pair, present in v7.1). This
commit does not revert those; it adds a device-specific ACPI workaround.
`git merge-base --is-ancestor e0fb794d67f86 v7.1` is true.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Same-file siblings: `4dab2b904414f` (base table), then B9406CAA,
then UX8407AA / GX651AR / GX651AX. Standalone: one extra DMI row.
Prerequisite is only `ghost_realtek[]`, which is in this tree.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Charles Keepax has 30 SoundWire commits here; he introduced
`ghost_realtek`. Vinod Koul (maintainer) applied it. Pierre-Louis
Bossart (reviewer in MAINTAINERS) was CCed.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Depends on `ghost_realtek[]` (`4dab2b904414f`, in v7.2 and in
this 7.3 tree) and on remap-to-zero skip in `find_slave()` (`if (!addr)
return false;` in `drivers/soundwire/slave.c`). Both exist here. Applies
standalone on this tree.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 dig: https://patch.msgid.link/20260630081132.3294488-1-
  ckeepax@opensource.cirrus.com
- Series: v1 only (no v2/v3)
- Cover note: follow-up quirk after a previous one proved unnecessary
- Vinod Koul: “Applied, thanks!” → `90af3209742db`
- No NAK, no review concerns, no Cc: stable in the thread

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (b4 dig -w): To Vinod Koul; Cc Pierre-Louis Bossart, Bard Liao,
linux-sound, linux-kernel, Cirrus patches. Maintainer applied it. No
extra Reviewed-by on this follow-up (the base table had Reviewed-by:
Pierre-Louis Bossart).

Step 4.3: SEARCH FOR THE BUG REPORT
Record: GitHub thesofproject/linux#5828, closed.
- Reporter q66: no sound on ExpertBook B9406CAA since 7.1 (dummy output;
  `snd_soc_register_card failed -517`, later duplicate sysfs).
- Charles identified ACPI ghost: `link 3 mfg_id 0x025d part_id 0x0722`.
- Reporter confirmed DMI `ASUS` / `B9406CAA` and that this exact quirk
  restored sound (downstream Chimera Linux kernel).
- Charles: “Yeah that is the correct fix.”
- Separate later UCM/mute-LED discussion is unrelated to this quirk.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone 1/1. Same family as `4dab2b904414f` and later laptop
rows. No other patches required for this DMI entry.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable WebFetch returned 403. UNVERIFIED whether
it was discussed on stable@. On the GitHub issue, Charles said the
original ghost-Realtek table should be forwarded to stable because 7.1
already had the topology switch. That is context, not a substitute for
this patch’s own merit.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body changes. Data only: `adr_remap_quirk_table[]`
using existing `ghost_realtek[]`. Consumer: `sdw_dmi_override_adr()`.

Step 5.2: TRACE CALLERS
Record:
- `sdw_dmi_override_adr()` is `bus->ops->override_adr` for Intel
  (`drivers/soundwire/intel_auxdevice.c`).
- Called from `find_slave()` in `drivers/soundwire/slave.c` during ACPI
  enumeration.
- Context: device probe / SoundWire bus init, not IRQ.

Step 5.3: TRACE CALLEES
Record: `dmi_first_match()`, then table walk. If ADR matches, replace
with remapped value (0 for ghost Realtek).

Step 5.4: FOLLOW THE CALL CHAIN
Record: Boot/probe of Intel SOF SoundWire (Panther Lake Expertbook).
Userspace cannot trigger it except by using the laptop. Reachable on
that hardware every boot. Confirmed by dmesg in the issue.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same `ghost_realtek` DMI rows for UX5406AA, 83QK, 83SF, later
UX8407AA / GX651AR / GX651AX. Systematic ACPI ghost-device problem, not
a one-off.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is v7.3-rc4 (`7.3.0-rc4`). `ghost_realtek[]` and
remap-to-zero skip are present. Function topology on PTL
(`snd_soc_acpi_intel_no_function_topology` in `soc-acpi-intel-ptl-
match.c`) is present — that is what made the ghost ACPI entry fatal from
7.1. The B9406CAA row is already in this checkout at lines 189–195 of
`dmi-quirks.c` (`git merge-base --is-ancestor 90af3209742db HEAD`
succeeded). The bug class exists here; this tree already contains the
fix because it is 7.3 mainline.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply on this tree. Same table layout as the patch. No
rework needed. (Would need `ghost_realtek[]` on a tree older than v7.2.)

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Base table `4dab2b904414f` is here. No alternate B9406CAA fix
besides this row. Later extra laptops are independent.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [SoundWire DMI quirks / Intel SOF audio] [IMPORTANT for affected
laptops, PERIPHERAL globally]. Not core mm/net, but complete audio loss
on a shipping Panther Lake laptop.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active: multiple 2026 ghost-Realtek DMI additions. Maintainer-
applied. Mature quirk file since v5.13.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver/platform-specific: Asus Expertbook B9406CAA (DMI board
name). CONFIG_SOUNDWIRE_INTEL + SOF PTL machine driver.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot on that laptop once function topology is used (7.1+).
Not a race. Not unprivileged-attack surface. Reporter reproduced on
7.1.1.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [No audio / card probe failure] [HIGH for that hardware]. Not a
panic. User-visible: dummy output, deferred probe `-517`, or failed
DAI/sysfs setup. Confirmed in issue 5828.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: Benefit high for those users (restores sound). Risk very low:
7-line DMI entry, existing remap table, DMI-gated. Ratio strongly favors
applying it on trees that already have `ghost_realtek`.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Hardware quirk / DMI workaround — listed as a stable exception.
- Real user bug: complete audio failure; reporter tested this exact
  match.
- Maintainer applied; SOF issue closed with this approach.
- 7 lines, existing `ghost_realtek[]`, no new API.
- `ghost_realtek` and remap-to-0 skip exist in this 7.3 tree.
- Same pattern as other accepted laptop rows.

AGAINST:
- Not a crash/UAF/security bug (audio probe failure).
- Affects one laptop model.
- No Fixes:/Cc: stable (expected for this review pipeline).
- This 7.3-rc4 checkout already contains the commit (mainline source,
  not a reason to reject on merit).

UNRESOLVED:
- lore.kernel.org WebFetch 403; stable@ discussion not independently
  confirmed beyond GitHub.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — same remap table; user confirmed
   on B9406CAA; maintainer applied.
2. Fixes a real bug that affects users? PASS — no sound since 7.1 on
   that Expertbook.
3. Important issue? PASS — HIGH: total audio loss, not a panic; still a
   serious hardware enablement/regression for that machine.
4. Small and contained? PASS — +7 lines, one file, one DMI entry.
5. No new features or APIs? PASS — table row only.
6. Can apply to the local tree? PASS — `ghost_realtek` and
   `sdw_dmi_override_adr` exist; patch matches current table form.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk / DMI workaround for broken ACPI. Automatically
qualifies.

Step 9.4: MAKE YOUR DECISION
This tree (v7.3-rc4) has the buggy ACPI path, function topology, and
`ghost_realtek`. The change is a one-row DMI quirk that restores audio
on a shipping laptop. That is exactly the stable-acceptable quirk class.

What it solves: ACPI advertises a non-existent RT722; sof_sdw then fails
to build the card. The quirk remaps that `_ADR` to 0 so discovery skips
it.

Risk vs benefit: benefit is restoring sound; risk is a DMI-gated no-op
on every other machine.

No missing prerequisites on this tree.

Verification:
- [Phase 1] Tags: Closes GitHub 5828; SOB Charles Keepax + Vinod Koul;
  lore msgid link; no Fixes/Cc: stable
- [Phase 2] Diff: +7 lines in `adr_remap_quirk_table` matching
  ASUS/B9406CAA → `ghost_realtek`
- [Phase 2] `ghost_realtek` remaps 0x000330025d072201 → 0;
  `find_slave()` skips `!addr`
- [Phase 3] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor 90af3209742db HEAD` → already
  in this tree (7.3-rc1+)
- [Phase 3] `4dab2b904414f` (`ghost_realtek`) is ancestor of v7.2 and of
  HEAD; not in v7.1
- [Phase 3] `90af3209742db` is in v7.3-rc1, not in v7.2 / v7.2.7
- [Phase 3] Topology commits `e0fb794d67f86` / `45cf24da0a10` are in
  v7.1 (issue’s regression window)
- [Phase 3] blame: B9406CAA block is 90af3209742db; table intro
  4dab2b904414f
- [Phase 4] b4 dig: lore patch-id match, v1 only, Vinod “Applied,
  thanks!”
- [Phase 4] b4 dig -w: Vinod, Pierre-Louis Bossart, Bard Liao, linux-
  sound
- [Phase 4] GitHub 5828: reporter confirmed quirk; Charles: correct fix;
  dmesg shows ghost 0x025d:0x0722 on link 3
- [Phase 4] lore.kernel.org WebFetch 403 — stable@ search UNVERIFIED
- [Phase 5] callers: `intel_auxdevice` `.override_adr` → `find_slave()`
  ACPI enum
- [Phase 6] local `dmi-quirks.c` already has B9406CAA and
  `ghost_realtek`
- [Phase 7] SOUNDWIRE maintainers Vinod Koul / Bard Liao; reviewer
  Pierre-Louis Bossart
- [Phase 8] Failure: no audio on one Asus PTL laptop; severity HIGH;
  risk very low
- UNVERIFIED: stable@ mailing list archive contents (HTTP 403)

This is a hardware quirk for a real, user-confirmed audio failure. It is
small, already the established `ghost_realtek` pattern, and the
supporting code is in this tree.

**YES**

 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 32a46a2d90f7c..2a98fc8c104d6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -178,6 +178,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		.driver_data = (void *)hp_omen_16,
 	},
 	/* PTL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "B9406CAA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0

