Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95749500AB2;
	Mon, 19 Oct 2026 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418313; cv=none; b=PLt/yXcKKyIpYvoeZqbEA/Mjax4GMwo0bWPfp3MZsBNhjir2RVBTa2j3Wk4XnZfpDn0BkKm1cHAnV4VimFLSrqMZDWIp0QPo0oeuuczOQ7xvTk7/xISewiTQDk4y0bYOrd/PeBaVfubvmEob/zAYUtQfyBjiFzpK8EpLQrSQ4x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418313; c=relaxed/simple;
	bh=NUI4HswhqgaO7W+RZ0/47l1u0VZpLSVFQrs0xmbHVec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBGY2PMte16Yf7vfSwlmiDqoVlJoNrhFo3M1xcTZu8p87S792EH25Ih3l5jQra2K3OcS4GB9iFdIOvZi4jpMZw8tzraS+TS1fJUcPbmwXvxDEI7LrXfwo+g8b6f32oXY0MFRPViY/2owL3g8NnxFYAfZ8Ef+W3cUwjyFlDd2j+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFiViMLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFiViMLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD931F000CC;
	Mon, 19 Oct 2026 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418310;
	bh=HmlvrLpapebHv/j4oGnVBBFuClaBCde5IZcYymyDERc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFiViMLBb7NklaoIzYkIgghcmedPmyu6VG5Arq0D+BTG/DOxo3TshgK85RGF/YzpM
	 ZTIXSAT1RzWczTn6ywsWfvsC+2iDU7VgIdgV/L83Nx1olM5fXeFuAlyNQ//Cmm/JMU
	 1qZ9vY/8y+GAHhjqMk4pKelzPb8r9ybXchWehN2DrD4nfHfzyjxv6OEGsKwG4mQFHG
	 mBKmxXsXRinNdbi9IlVOnumfG8qZLEUaL5KFHA+wSOcFIvnI9uciA9Bx3LddLidRoK
	 /KP6oicL7p+ZnHfPqGwwhYYNlh/Qo0DI43KlVKSCGOZu0cPLzeHNeMeFgn2GXOSAvX
	 AlAkThpJbXKeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] soundwire: dmi-quirks: Disable ghost Realtek on Asus ROG Zephyrus Duo
Date: Mon, 19 Oct 2026 09:47:28 -0400
Message-ID: <20261019135441.1420968-157-sashal@kernel.org>
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

[ Upstream commit 5b08a3afd2995e5312c4c47ffea9d21b651e8e13 ]

The Asus ROG Zephyrus Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Suggested-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260807121425.1952003-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a DMI-gated hardware quirk,
`ghost_realtek` already exists in 6.12, and GX651AR is not listed yet.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [soundwire: dmi-quirks] [Disable] [DMI quirk to hide a phantom
Realtek SoundWire device on Asus ROG Zephyrus Duo board GX651AR]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Suggested-by: Bard Liao <yung-chuan.liao@linux.intel.com>
- Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com> (author;
  Cirrus codec maintainer)
- Link: https://patch.msgid.link/20260807121425.1952003-1-
  ckeepax@opensource.cirrus.com
- Signed-off-by: Vinod Koul <vkoul@kernel.org> (SoundWire maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence expected)
- Ignored: any pipeline “Upstream commit” / “Signed-off-by: Sasha Levin”
  markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: Asus ROG Zephyrus Duo ACPI lists a Realtek SoundWire device that
  is not on the board.
- Symptom: the ASoC machine driver still builds DAI links for that ACPI
  node.
- Failure mode: wrong/extra DAI links; on the sibling GX651AX report,
  sof_sdw probe fails with -12 (ENOMEM) after duplicate `SDW3-Playback-
  SimpleJack` links.
- Root cause: firmware exposes a ghost RT722 (`0x000330025d072201`) on
  SoundWire link 3.
- Version info: none in this commit. A later sibling patch (GX651AX)
  used `Cc: stable # 7.2.x`; that does not describe this GX651AR change.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit hardware quirk: add one DMI
match that reuses `ghost_realtek`.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/soundwire/dmi-quirks.c` (+7 lines, 0 removed)
- Data only: one `dmi_system_id` entry in `adr_remap_quirk_table[]`
- No function body changes
- Scope: single-file surgical quirk

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: ASUS GX651AR does not match the remap table, so ACPI `_ADR`
  `0x000330025d072201` is used as-is.
- After: that board matches `ghost_realtek`, which remaps that `_ADR` to
  `0`.
- Path: SoundWire ACPI slave discovery (`sdw_dmi_override_adr` →
  `find_slave()`). If `addr` is 0, `find_slave()` returns false and the
  slave is not registered.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: hardware workaround (DMI quirk table)
- Mechanism: same as the existing `ghost_realtek` entries.
  `find_slave()`:

```109:113:drivers/soundwire/slave.c
        if (bus->ops->override_adr)
                addr = bus->ops->override_adr(bus, addr);

        if (!addr)
                return false;
```

Skipping the slave means it is not in `ctx->ids`
(`drivers/soundwire/intel_init.c`), so SOF machine matching does not
treat a phantom RT722 as present.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one DMI match, existing `ghost_realtek` table, same
  pattern as UX5406AA / 83QK / 83SF already in this file.
- Regression risk: very low; only ASUS board name `GX651AR`.
- No API, locking, or allocator changes.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Local tree: `p-6.12-3-gc504cf0baa3d8`, Makefile `VERSION=6
  PATCHLEVEL=12 SUBLEVEL=111`.
- `ghost_realtek[]` and the first DMI users come from `30e7fb61a64ba`
  (“soundwire: dmi-quirks: Disable ghost Realtek devices”, 2026-05-20).
- `adr_remap_quirk_table` dates to 2021 (`f6594cdfec4cd`).
- GX651AR is not in this checkout.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent `dmi-quirks.c` history is other DMI remaps (HP Omen, NUC,
  Avell) plus the ghost-Realtek table.
- Not a numbered series (`patch X/Y`). Standalone DMI row.
- Mainline context includes `B9406CAA` and `UX8407AA`; those IDs are not
  in 6.12. They are independent rows, not code prerequisites.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Charles Keepax maintains Cirrus codecs (CS42L43 lives on this class of
  machines).
- Same author added the original ghost-Realtek table in this tree
  (`30e7fb61a64ba`).
- Suggested-by Bard Liao, SoundWire co-maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `ghost_realtek[]` and `sdw_dmi_override_adr()` — both present
  (`git merge-base --is-ancestor 30e7fb61a64ba HEAD` → yes).
- Upstream SHA `5b08a3afd2995e5312c4c47ffea9d21b651e8e13` is not an
  ancestor of HEAD (expected; this is the candidate).
- Can stand alone once the DMI entry is inserted next to `UX5406AA`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 5b08a3afd2995e5312c4c47ffea9d21b651e8e13` → https://patch.m
  sgid.link/20260807121425.1952003-1-ckeepax@opensource.cirrus.com
- `b4 dig -a`: v1 only, 2026-08-07.
- Vinod Koul applied it (`commit:
  5b08a3afd2995e5312c4c47ffea9d21b651e8e13`). No NAK, no revision churn.
- lore.kernel.org search URLs returned 403; discussion recovered from
  b4, patchew, LKML, and openwall.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Vinod Koul; Cc Bard Liao, Pierre-Louis Bossart,
linux-sound, linux-kernel, Cirrus patches. Right SoundWire people. No
extra Reviewed-by on the committed message; maintainer applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record:
- No bugzilla/syzbot link on this patch.
- Sibling GX651AX (Ian Luites, 2026-08-31): ghost RT722 stays
  unattached, CS42L43 + two CS35L56 attach, duplicate `SDW3-Playback-
  SimpleJack`, sof_sdw probe `-12`. That is the same ACPI ghost class,
  different SKU.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Later GX651AX is another DMI row, not a dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable returned 403. Web search found no stable-
list discussion of GX651AR. UNVERIFIED: whether anyone asked for this on
stable@ for 6.12.y.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function edited. Data consumed by `sdw_dmi_override_adr()`.

**Step 5.2: TRACE CALLERS**
Record:
- `sdw_dmi_override_adr` ← `bus->ops->override_adr` in `find_slave()`
  (`drivers/soundwire/slave.c`)
- Intel sets `.override_adr = sdw_dmi_override_adr` in
  `drivers/soundwire/intel_auxdevice.c`
- `find_slave()` runs during ACPI SoundWire slave enumeration
  (probe/boot)

**Step 5.3: TRACE CALLEES**
Record: `dmi_first_match()` then remap. Remap-to-0 is handled by `if
(!addr) return false`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
ACPI scan → Intel SDW link probe → `sdw_slave_add` / `find_slave` →
`override_adr` → skipped slave not on `bus->slaves` → not copied into
`ctx->ids` → `hda_sdw_machine_select()` /
`snd_soc_acpi_sdw_link_slaves_found()` never sees the ghost RT722 →
`sof_sdw` does not build DAI links for it.
Reachable on any GX651AR that boots this kernel with Intel SoundWire +
SOF. Not a syscall fuzzer path; firmware/hardware path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `ghost_realtek` already used for ASUS UX5406AA, Lenovo
83QK, Lenovo 83SF in this file. This is another ID in that set.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `ghost_realtek` remaps RT722 `0x000330025d072201` to 0. PTL
tables include `ptl_rt722_l3` for that address. GX651AR is not listed,
so this laptop still exposes the ghost device. Bug introduced with the
ACPI firmware + the existing remap-to-0 design (table added 2026-05-20,
already in this 6.12.y checkout).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Not a clean apply: mainline hunk context has B9406CAA before
GX651AR; 6.12 goes from the “PTL devices” comment to UX5406AA. Backport
is insert the same 7-line entry next to UX5406AA. Difficulty: minor
context, no semantic rework.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: The generic ghost-Realtek table is here. No
GX651AR/GX651AX/B9406CAA/UX8407AA rows. No alternate fix for this board.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [drivers/soundwire DMI quirks + Intel SOF/ASoC] [IMPORTANT —
laptop audio on Intel SoundWire machines; not core mm/fs, but user-
visible “no sound / probe fail”]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature DMI table (since 2021) with ongoing per-board additions.
This is the usual stable-friendly pattern, not a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver/platform-specific: ASUS board `GX651AR` (ROG Zephyrus
Duo) with Intel SoundWire. Everyone else is unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot/probe on that laptop. Not a race. Unprivileged users
do not trigger it; firmware does. Common for owners of that model.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure: extra/wrong DAI links; sibling SKU: sof_sdw probe -ENOMEM; on
  this 6.12 tree, `ptl_rt722_l3` can match a laptop that only has a
  ghost RT722 on link 3 and then load the wrong topology.
- Severity: HIGH for those machines (audio probe failure / wrong
  machine). Not a UAF/panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: high for GX651AR (and zero elsewhere). Same class as
  USB/PCI/DMI quirks that stable already takes; this tree already has
  three `ghost_realtek` IDs.
- Risk: very low (7 DMI lines, exact board match).
- Ratio: strongly favors backport.

Note: 6.12 PTL match tables have no CS42L43/CS35L56 entries, so this
laptop may still lack a perfect SOF machine even after the quirk. The
quirk still stops a false `ptl_rt722_l3` match and is the same
enablement already used for UX5406AA. It does not make other hardware
worse.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real hardware ACPI bug on a shipping Asus laptop
- Classic DMI quirk exception in stable-kernel-rules
- 7 lines, existing table, DMI-gated
- Infrastructure (`ghost_realtek`, `override_adr` → skip `addr==0`) is
  in this 6.12 tree
- SoundWire maintainer applied; suggested by SoundWire co-maintainer
- Sibling SKU documents sof_sdw probe failure from the same ghost RT722

AGAINST:
- Fuzzy apply (missing B9406CAA context) — trivial to re-context
- No Fixes:/Cc: stable on this patch (not a negative under these rules)
- PTL Cirrus machine tables are thinner in 6.12 than mainline — audio
  may still be incomplete, but the quirk is still the correct filter

UNRESOLVED:
- Could not read lore.kernel.org/stable (403)
- No on-list Tested-by for GX651AR itself (author + Intel suggestion)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? [PASS — identical to existing entries;
   maintainer applied]
2. Fixes a real bug that affects users? [PASS — ghost ACPI device breaks
   machine/DAI setup]
3. Important issue? [PASS — audio probe failure / wrong topology on that
   laptop; HIGH]
4. Small and contained? [PASS — +7 lines, one file]
5. No new features or APIs? [PASS — DMI ID on existing quirk]
6. Can apply to the local tree? [PASS — needs trivial context
   adjustment, not missing code]

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Hardware quirk / DMI match on an existing driver. Automatic YES
class.

**Step 9.4: MAKE YOUR DECISION**
This should be backported to this 6.12.y tree. It is a small, DMI-gated
quirk using code already present here, and it prevents a phantom Realtek
RT722 from participating in SoundWire/SOF setup on Asus GX651AR.

Verification:
- [Phase 1] Parsed tags: Suggested-by Bard Liao; SOBs Keepax + Vinod
  Koul; Link msgid 20260807121425.1952003-1; no Fixes/Reported-by
- [Phase 2] Diff: +7 lines in `adr_remap_quirk_table` for ASUS / GX651AR
  → `ghost_realtek`
- [Phase 2] Confirmed `find_slave()` drops `addr==0` after
  `override_adr`
- [Phase 3] `git describe HEAD` / Makefile: 6.12.111
  (`p-6.12-3-gc504cf0baa3d8`)
- [Phase 3] `git blame`: `ghost_realtek` from `30e7fb61a64ba`; GX651AR
  absent
- [Phase 3] `git merge-base --is-ancestor 30e7fb61a64ba HEAD`: present;
  `5b08a3afd2995` not ancestor
- [Phase 3] `git log --oneline -20 -- drivers/soundwire/dmi-quirks.c`:
  prior DMI remaps only
- [Phase 4] `b4 dig -c 5b08a3afd2995`: lore msgid above; v1 only; Vinod
  applied
- [Phase 4] `b4 dig -w`: To vkoul; Cc Liao, Bossart, linux-sound
- [Phase 4] Sibling GX651AX: duplicate SimpleJack DAI links, sof_sdw -12
- [Phase 4] UNVERIFIED: stable@ thread (HTTP 403)
- [Phase 5] Callers: `intel_auxdevice.c` `.override_adr` → `find_slave`
  → `intel_init.c` `ctx->ids` → `hda.c` machine select
- [Phase 6] Local file has UX5406AA/83QK/83SF, not GX651AR; PTL
  `rt722_3` ADR matches the quirk
- [Phase 6] Apply: context conflict on B9406CAA, trivial insert beside
  UX5406AA
- [Phase 8] Failure: wrong/extra DAI links / failed sof_sdw probe; DMI-
  limited; very low regression risk

**YES**

 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index f738e547a1f30..768255dd12db6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -193,6 +193,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "GX651AR"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0

