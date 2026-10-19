Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033EC4FECCB;
	Mon, 19 Oct 2026 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418486; cv=none; b=BMCuz1jjJJgX9TRs2DOyx1gd8g/jhAIWAmklCbmC1/cv0h/EQLx0l01WszNm7cFgy00R6XnuPwTDpEKwM6WQmG0hP23ht73WL/7WL8FXed080OICqxgD8mJ2v3FbwBjU2XQ8KppToskV5JJA9pvNJr4Gmd2C3jx6hrxlup0svI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418486; c=relaxed/simple;
	bh=T+SJQKkQNkV1odb+u0fSYiUhhiFBgAgqiN5Ku20W6zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=obD8l0V0jLntfRg6iq1eSDueaxjdE0p+x4LyvnRq04aPA/VxV/RnlxvTDvRfSa0eU2Xk4jX46jX16XZR0X3sXqLL608QCKtcEVljPLlwEmxfnV42dsX+ttSJEYpISzQgooK2HrqoSoDB9XofgUUl+luJHTNwohO3kT8/OGcSttI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ij+aj8iS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ij+aj8iS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36781F000C4;
	Mon, 19 Oct 2026 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418483;
	bh=dSAE443ekBLb4DzBFWNQVF7AV2ZjnexmVnurg1YZebY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ij+aj8iS74TSoGkRUTIW3mKTmSs/b0sT95ovZx+DDXcmUjJmUMfO4aRdUl5XajKUl
	 K8cU7Amdcnhz9qQmHEAwBSniRXt+ow5FJfCkIRgjICzCnb7hx+EhW0ePXCwGcGYGSK
	 BY6x0yociDvpuGaHaAVdQrnRTmVYZM06PfcJXfwX+LFkMzx5AejqiZQId2AHddeFPo
	 OnEbjXPpTLbNit/yTGnNlmUG7WCPGLcwDKmold6Hfl83WFdLz/qooSKlyQF/sc8R7w
	 IQJ1z+oHn4Z9lP5jOb/253zl1NAcjyY65KSZek0yJgZi5g0Yy7vam/PDcnjImyC5IN
	 Q3kucUqmmBgsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] soundwire: dmi-quirks: Disable ghost Realtek on Asus Zenbook Duo
Date: Mon, 19 Oct 2026 09:49:32 -0400
Message-ID: <20261019135441.1420968-281-sashal@kernel.org>
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

[ Upstream commit ca02ffd4975ca5249abf0cfb750a495d23b453ee ]

The Asus Zenbook Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260720095741.3592825-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a DMI hardware quirk for this 6.12 tree. The `ghost_realtek`
remap table is already here; the commit only adds board `UX8407AA`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[soundwire / dmi-quirks] [Disable] Disable ghost Realtek on
Asus Zenbook Duo.** “Disable” is a bug-fix verb: stop enumerating a non-
existent ACPI codec.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Charles Keepax (author)
- Reviewed-by: Pierre-Louis Bossart (SoundWire/Intel audio)
- Link: https://patch.msgid.link/20260720095741.3592825-1-
  ckeepax@opensource.cirrus.com
- Signed-off-by: Vinod Koul (SoundWire maintainer; applied as
  `ca02ffd4975c`)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable (absence expected)
- Ignore pipeline SOBs/Upstream markers

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: Asus Zenbook Duo ACPI lists a Realtek SoundWire device that is
  not on the board.
- Symptom: machine driver tries to create DAI links for that ghost codec
  → wrong/broken sound card.
- Root cause: firmware _ADR for a phantom RT722 (same class as UX5406AA
  / Lenovo entries already in this tree).
- No stack trace; hardware/firmware description.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware quirk.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/soundwire/dmi-quirks.c` (+7 / −0)
- Function/data: `adr_remap_quirk_table[]` only
- Scope: single-file surgical DMI entry
- New match: `DMI_SYS_VENDOR "ASUS"` + `DMI_BOARD_NAME "UX8407AA"` →
  existing `ghost_realtek`

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: Before, UX8407AA was not in the table, so ACPI _ADR
`0x000330025d072201` (RT722 on link3) was used as-is. After, that _ADR
is remapped to `0`, so `find_slave()` skips the device.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Hardware workaround (DMI quirk).** Same `ghost_realtek` map
already in tree:

```97:104:drivers/soundwire/dmi-quirks.c
static const struct adr_remap ghost_realtek[] = {
        /* rt722 on link3 */
        {
                0x000330025d072201ull,
                0x0000000000000000ull
        },
        {}
};
```

`sdw_dmi_override_adr()` applies that map. `find_slave()` then drops a
zero address:

```109:113:drivers/soundwire/slave.c
        if (bus->ops->override_adr)
                addr = bus->ops->override_adr(bus, addr);

        if (!addr)
                return false;
```

Intel ops already wire this (`override_adr = sdw_dmi_override_adr` in
`intel_auxdevice.c`). `intel_init.c` builds `ctx->ids` from registered
slaves, so SOF machine select in `hda_sdw_machine_select()` never sees
the ghost.

Step 2.4: ASSESS THE FIX QUALITY
Record: Copy of existing ASUS/Lenovo rows; DMI-gated; no
API/locking/hot-path change. Regression risk is limited to mis-matched
board strings on UX8407AA only.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: PTL `ghost_realtek` rows come from `30e7fb61a64ba` (“Disable
ghost Realtek devices”), backport of upstream `4dab2b904414` (Charles
Keepax, 2026-05-20). Already in this tree. UX8407AA is not.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introduced bug is firmware, not a kernel commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `dmi-quirks.c` history is quirk additions. Sibling IDs
already here: UX5406AA, Lenovo 83QK, 83SF. Upstream context also has
B9406CAA; that ID is **not** in this tree and is **not** required for
UX8407AA.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Charles Keepax is a regular SoundWire/ASoC contributor (Cirrus).
Same author added the original `ghost_realtek` table. Reviewed by
Pierre-Louis Bossart; applied by Vinod Koul.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `ghost_realtek` + `sdw_dmi_override_adr` + Intel
`override_adr`. All present (`30e7fb61a64ba`). Standalone; not patch
x/y. Original May 2026 series (ptl-match Chrome matches, then
ghost_realtek) is independent of this July follow-up.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c ca02ffd4975c` → https://patch.msgid.link/20260720095741.359
  2825-1-ckeepax@opensource.cirrus.com
- `b4 dig -a`: single v1, no later revision
- Pierre-Louis Bossart: Reviewed-by; noted this will keep happening as
  more BIOS bugs ship; not a NAK
- Vinod Koul: Applied, thanks
- No NAKs, no Cc: stable in review (not a negative)

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To Vinod Koul; Cc Yung-Chuan Liao, Pierre-Louis Bossart, linux-
sound, linux-kernel, Cirrus patches. Appropriate maintainers.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Author report of shipping ACPI. Same
firmware class as quirks already in 6.12. Related AUTOSEL for 6.12:
`platform/x86: asus-nb-wmi: add DMI quirk for ASUS Zenbook Duo UX8407AA`
— this SKU is already treated as 6.12-relevant.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone 1/1. Follow-up to `4dab2b904414` / `30e7fb61a64ba`,
already here.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED** — lore.kernel.org/stable returned 403. No
evidence this was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body change. Data: `adr_remap_quirk_table`.
Consumer: `sdw_dmi_override_adr()`.

Step 5.2: TRACE CALLERS
Record:
- `sdw_dmi_override_adr` ← Intel `sdw_intel_ops.override_adr`
- `find_slave()` during ACPI slave walk
- Boot/probe only, Intel SoundWire platforms with matching DMI

Step 5.3: TRACE CALLEES
Record: `dmi_first_match()`, remap loop, `dev_dbg()`. No alloc/locks.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable at SoundWire probe on UX8407AA. Not a syscall UAF;
broken audio on that laptop. `hda_sdw_machine_select()` uses
`hdev->sdw->ids` from registered slaves, so skipping the ghost changes
machine matching and DAI-link construction.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same pattern already used for UX5406AA and two Lenovo SKUs. This
extends that list.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree: **pending-6.12**, `make kernelversion` = **6.12.111**
  (`p-6.12-2-gd38d58a4e0359`)
- `drivers/soundwire/dmi-quirks.c` present; `ghost_realtek` present;
  UX8407AA **absent**
- PTL SOF support present (`pci-ptl.c`, `soc-acpi-intel-ptl-match.c`
  with RT722 link0/link3)
- Mechanism that makes a zero _ADR drop the slave is present
- Candidate `ca02ffd4975c` is **not** an ancestor of HEAD (expected)

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Lore hunk (insert before first LENOVO `ghost_realtek` row)
**`git apply --check` clean**. Full upstream context mentioning B9406CAA
is not required. Difficulty: **clean apply**.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Generic ghost-Realtek table yes; this board ID no. No substitute
UX8407AA SoundWire quirk.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **soundwire DMI quirks** (Intel laptop audio). **IMPORTANT** for
those machines; DMI-gated so not CORE-wide.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature quirk table (since ~2021) with ongoing DMI additions.
This is the usual enablement pattern, not a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver/platform-specific**: ASUS board UX8407AA (Zenbook Duo).
Everyone else unchanged.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot/probe on that DMI. No race. Unprivileged users get
broken audio; they cannot trigger it on other machines.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Wrong DAI links / wrong SOF machine (e.g. matching
`ptl_rt722_l3` on a ghost RT722) or probe of a codec that is not there.
**HIGH** for that SKU (no/wrong audio), not a panic.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: audio enumeration correct on a shipping PTL laptop; same
  class as quirks already in 6.12
- Risk: very low (7 lines, DMI-gated, existing table)
- Ratio: strongly favors backport

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Hardware quirk / DMI ID on an existing driver — stable exception
- Real firmware bug: ghost Realtek in ACPI
- User-visible: machine driver builds DAI links for hardware that does
  not exist
- +7 lines, copy of existing entries
- `ghost_realtek` + Intel override path already in 6.12.111
- Applies cleanly
- Reviewed by Bossart, applied by Koul
- Same author/table as UX5406AA already in this tree
- PTL SoundWire/SOF present
- Zero blast radius off that DMI match

AGAINST:
- One laptop SKU
- No Reported-by/syzbot (normal for DMI quirks)
- PTL match table in 6.12 is still mostly RT711/RT722 (function-topology
  DAI building is stronger on later/ARL paths); the skip still prevents
  ghost-slave probe and false `ptl_rt722_l3` match
- lore.kernel.org/stable search 403

UNRESOLVED:
- Exact UX8407AA DMI strings not independently dumped
- Stable-list discussion not fetched (HTTP 403)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — identical to existing rows;
   maintainer Reviewed-by/applied
2. Fixes a real bug that affects users? **PASS** — ghost ACPI codec
   breaks card/DAI setup
3. Important issue? **PASS** — broken audio on a shipping laptop (HIGH
   for that SKU)
4. Small and contained? **PASS** — 7 lines, one table
5. No new features or APIs? **PASS** — DMI quirk only
6. Can apply to the local tree? **PASS** — lore hunk applies;
   prerequisites present

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk / DMI workaround** on an existing SoundWire
quirk table.

Step 9.4: MAKE YOUR DECISION
This belongs on 6.12.y. The bug exists here, the fix is the established
DMI pattern, and it does not depend on B9406CAA or later function-
topology work.

------------------------------------------------
What problem it solves for this tree
------------------------------------------------
Asus Zenbook Duo UX8407AA ships ACPI for a Realtek RT722 on SoundWire
link3 that is not physically present. Without the quirk, Intel SoundWire
registers that slave, SOF machine select can treat it as real, and
`sof_sdw` can create DAI links for it. Remapping that _ADR to 0 drops
the ghost device. The remap table and call path are already in 6.12.111;
this only names the board.

Risk vs benefit
------------------------------------------------
Benefit is working (or at least not mis-probed) audio on that SKU. Risk
is a DMI-only table row. No new APIs, no locking, no cross-subsystem
change.

Concerns
------------------------------------------------
None that block backport. B9406CAA in some upstream context is a
different board and is not a prerequisite. Apply is clean with the lore
hunk.

Verification:
- [Phase 1] Parsed subject/tags from the provided message; no
  Fixes/syzbot; Reviewed-by Bossart; Link msgid 20260720095741.3592825-1
- [Phase 2] Diff is +7 lines in `adr_remap_quirk_table`; `ghost_realtek`
  maps RT722 link3 `_ADR` to 0
- [Phase 2] Confirmed `find_slave()` returns false on `!addr`; Intel ops
  set `override_adr`
- [Phase 3] `git blame` PTL block → `30e7fb61a64ba` (backport of
  `4dab2b904414`); UX8407AA not present
- [Phase 3] `git merge-base --is-ancestor 30e7fb61a64ba HEAD` → yes;
  `ca02ffd4975c` → no
- [Phase 3] Author history in `drivers/soundwire/` includes the original
  ghost-Realtek quirk
- [Phase 4] `b4 dig -c ca02ffd4975c` → lore msgid; `-a` v1 only; `-w`
  Vinod/Bossart/linux-sound
- [Phase 4] Patchew/openwall: Bossart Reviewed-by; Vinod applied
  `ca02ffd4975c`
- [Phase 4] WebSearch: related 6.12 AUTOSEL asus-nb-wmi quirk for
  UX8407AA
- [Phase 5] Callers: `sdw_dmi_override_adr` ← `find_slave` ← Intel
  probe; `ctx->ids` from registered slaves
- [Phase 6] `git describe HEAD` p-6.12-2; `make kernelversion` 6.12.111;
  PTL SOF files present
- [Phase 6] `git apply --check` of lore hunk: clean
- [Phase 8] Failure mode: wrong DAI links / ghost codec probe; DMI-gated
- UNVERIFIED: lore.kernel.org/stable search (403); live DMI dump of
  UX8407AA

The patch is a small, existing-pattern DMI quirk; prerequisites are in
this tree and it applies cleanly.

**YES**

 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 62cee6e2179da..f738e547a1f30 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -200,6 +200,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "UX8407AA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
2.53.0

