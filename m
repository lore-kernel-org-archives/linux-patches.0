Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D7F5CDB9C;
	Mon, 19 Oct 2026 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418478; cv=none; b=WV4iqUScBesJ1AIvy5jd7zmFZC8Z7L1HdE6UKiigK88ebeRdEgSzhaYH+prpEKY3XmGjnKndU5ME8n6e6wjge8yQTCy9r6Tii7zPCpkZH5k0X1fQzx0t35e+CuPuoqaT5Ndr+RqkWFvUhcIP+mk4oZHTIvH9HRri6Nnwp30DDfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418478; c=relaxed/simple;
	bh=dg1OSbhdK+j5YOd2MtI3qmFptUi1dNzhh0R8cegcDXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jW+ufL95/HeM9VHt+K6Vt2+SxwtKKIjynQJbUglDNT+uoAUl0KenlvsMmOJGfRM6KUHeR0BG8EF/ynpGHuN+jRU4Dl4VECnJxJNWzrHL+wNpYJmu2TDYrGLPk01TKcBId76TBF9Wxi4F6sau7vjIOPN5fFWCrYlBhl6dTWS5iSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GgHRD7zX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgHRD7zX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFFF1F000C9;
	Mon, 19 Oct 2026 14:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418475;
	bh=JOxAUzlACqLQi93ICgBBTP9HwMF/WetlV2sXwSwxALY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgHRD7zXkMqUxPqUIRRLQG0rSKaGzwg0mj769BU8yfKQhKvbg1UlhseD0NeQkXPCi
	 6bQtb0CtGk2hxLAPagpuHUmpyXuVyGQrg32CfLs5XyamzuaJCn+/iTd2V+ADAq44+d
	 KF8ZiYhS8NizkLhtX4eILlVBEqM6+N3NfSn8LP74dsM4sRn8XLRl+Ve8UN7PLwaNr4
	 Ymwdi69lvDkhRlhz3VeZF3qewYT5lKm0eqCOZlPjHsdVFPrDhcWmVydZx9GpqJ2b2X
	 yKasmHX1WuQPXOWR19OLtbfVTgw9ELVi6TQsrHDHfmarxqy1WNMyww3IyPx9oySSrF
	 1q+Cpwa+Y8/Ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] soundwire: dmi-quirks: add a global ghost list
Date: Mon, 19 Oct 2026 09:49:26 -0400
Message-ID: <20261019135441.1420968-275-sashal@kernel.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit b7a5d101d7d267922e828c40135bcaccf8cfb3bf ]

Not like other ghost devices, the 0x000000D010010500 ADR doesn't belong
to any codec. We should disable it in all devices.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260703011656.2572959-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is Linux **7.3.0-rc4**. This is a hardware quirk that
disables a bogus SoundWire ACPI `_ADR` on Intel hosts; the same class of
ghost-device quirks has already been treated as stable material.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
- Subsystem prefix: `soundwire: dmi-quirks:`
- Action verb: **add** (adds a global ghost-ADR table)
- Claimed intent: disable ACPI `_ADR` `0x000000D010010500` on every
  machine because it is not a real codec
Record: [soundwire/dmi-quirks] [add] [global ghost ADR list to disable a
firmware-invented SoundWire device]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- Fixes: **absent** (expected for this review pipeline; not a negative
  signal)
- Reported-by: **absent**
- Tested-by: **absent**
- Reviewed-by: Charles Keepax (Cirrus; author of the earlier per-machine
  ghost-Realtek quirks); Pierre-Louis Bossart (SoundWire expert)
- Acked-by: **absent**
- Link: `https://patch.msgid.link/20260703011656.2572959-1-yung-
  chuan.liao@linux.intel.com`
- Cc: stable: **absent** (expected)
- Signed-off-by: Bard Liao (author, Intel SoundWire); Vinod Koul
  (SoundWire maintainer). Ignore any Sasha Levin SOB if present; none is
  on this commit.
Record: Author + two subsystem reviewers + maintainer SOB. No
user/syzbot report. No Fixes/Cc-stable.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
The body is two sentences: unlike DMI-matched ghost codecs, `_ADR
0x000000D010010500` does not belong to any codec, so it should be
disabled on all devices. No stack trace, no machine list, no kernel-
version range.
Decoded `_ADR` (MIPI DisCo layout in `include/linux/soundwire/sdw.h`):
link_id=0, version=0, unique_id=0, mfg_id=`0xd010`, part_id=`0x0105`,
class_id=0. That is not a known in-tree codec (Realtek is `0x025d`). It
is firmware garbage, not a real part.
Record: [Bug: ACPI exposes a non-codec SoundWire `_ADR`] [Symptom:
kernel enumerates a phantom slave, which can break machine-driver /
function-topology matching] [No version info] [Root cause: BIOS `_ADR`
is not a real codec; remap to 0 so core skips it]

Step 1.4: DETECT HIDDEN BUG FIXES
Not disguised cleanup. It is an explicit hardware workaround: treat a
bogus ACPI device as missing.
Record: [Not a hidden fix; it is a hardware quirk. Same pattern as
`ghost_realtek[]` remapping to 0.]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
- File: `drivers/soundwire/dmi-quirks.c` only
- +20 / -1 (21-line change)
- New table `global_ghost_adr[]`; function `sdw_dmi_override_adr()`
  updated (`break` → `goto out`, then a global remap loop)
Record: [1 file, +20/-1] [sdw_dmi_override_adr] [single-file surgical
quirk]

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Before: `sdw_dmi_override_adr()` only remapped addresses if DMI matched
`adr_remap_quirk_table`.
After:
1. DMI remap still runs first. On a hit, `goto out` so a machine-
   specific remap wins and is not overwritten.
2. Otherwise walk `global_ghost_adr[]`. If `addr == 0x000000D010010500`,
   set `addr = 0`.
Caller `find_slave()` in `drivers/soundwire/slave.c` already does `if
(!addr) return false;` (since 2021), so a zero `_ADR` is not enumerated.
Record: [DMI remap still preferred; unmatched 0x000000D010010500 is
forced to 0 and skipped during ACPI slave discovery]

Step 2.3: IDENTIFY THE BUG MECHANISM
Category **(h) hardware workaround**, using the existing remap-to-zero
disable path.
Record: [Hardware quirk] [BIOS lists a fake SoundWire device; remap to 0
so Intel SoundWire enumeration ignores it]

Step 2.4: ASSESS THE FIX QUALITY
Obviously correct: same remap-to-0 used by `ghost_realtek[]`. Pierre-
Louis noted on-list that zero is ignored by existing core logic.
Regression risk is low: only `_ADR 0x000000D010010500` is dropped, and
reviewers state it is not a real codec. `ARRAY_SIZE` includes the `{}`
terminator (one extra compare of `adr==0`); harmless. `goto out` is
required so a DMI remap is not then clobbered by the global list.
Record: [Minimal, obviously correct] [Regression risk: low; worst case
would be disabling a real device with this exact `_ADR`, which the
author/reviewers say does not exist]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
`sdw_dmi_override_adr()` and remap-to-0 skip date to **6558b667a7297**
(“soundwire: add override addr ops”, 2021-03-22, first in **v5.13**).
File introduced by **f6594cdfec4cd** (v5.12-rc2-2). Per-machine ghost
Realtek disable: **4dab2b904414f** (in **v7.2**).
Record: [Quirk infrastructure since v5.13] [This specific ADR workaround
is new in 7.3; the BIOS bug is not a recent kernel regression]

Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag.
Record: [N/A — no Fixes tag] [Buggy “code” is firmware; kernel side is
missing a quirk]

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Related commits on this file: `4dab2b904414f` (ghost Realtek, DMI-
matched), then more ASUS/Lenovo DMI rows, then this global list, then
more per-machine Realtek ghosts. This commit is not patch N/M.
Record: [Same-file ghost-device series, but this patch is standalone]
[No extra kernel commit required for remap-to-0 to work]

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Bard Liao is a regular Intel SoundWire contributor (many
cadence/intel_ace2x commits). Reviewed by Keepax and Bossart; applied by
Vinod Koul.
Record: [Intel SoundWire contributor; patch vetted by subsystem
experts/maintainer]

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Needs `sdw_dmi_override_adr` + `if (!addr) return false` in
`find_slave()` — both present since v5.13. Does not need
`ghost_realtek[]`. Applies standalone on this tree.
Record: [No missing prereqs in this tree] [Standalone]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
`b4 dig -c b7a5d101d7d26` matched:
https://patch.msgid.link/20260703011656.2572959-1-yung-
chuan.liao@linux.intel.com
`b4 dig -a`: **v1 only**, dated 2026-07-03. Thread (mbox): Bard submit →
Pierre-Louis Reviewed-by (notes zero is ignored by core) → Vinod applied
as `b7a5d101d7d26`. No NAK, no v2.
Record: [lore via b4] [v1 applied as-is] [No NAKs] [No reviewer Cc:
stable] [Keepax Rb already on v1]

Step 4.2: CHECK WHO REVIEWED THE PATCH
`b4 dig -w` recipients: linux-sound, Vinod Koul, Pierre-Louis Bossart,
Peter Ujfalusi, Bard Liao. SoundWire maintainer and Intel SoundWire
people were on To/Cc.
Record: [Vinod (maintainer), Pierre-Louis, linux-sound; Keepax reviewed]

Step 4.3: SEARCH FOR THE BUG REPORT
No Reported-by, bugzilla, or syzbot. Web search only finds this patch
thread. User impact is inferred from the sibling ghost-Realtek commit:
ACPI-listed missing codecs confuse function-topology sound-card
creation.
Record: [No public user bug report for this ADR] [Impact inferred from
the same ghost-device mechanism, which is documented in 4dab2b904414f]

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Standalone 1/1. Later dmi-quirks commits only add more DMI rows for
Realtek ghosts; they do not fix this patch.
Record: [Standalone] [Follow-ups are unrelated extra DMI IDs]

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Direct lore.kernel.org/stable fetch returned 403. Web search found
**AUTOSEL of the sibling** `soundwire: dmi-quirks: Disable ghost Realtek
devices` for **6.18–6.1**, and **no AUTOSEL of this global-ghost
commit** (no Fixes/Cc-stable, so it needs this review).
Record: [Sibling ghost-device quirk was AUTOSEL’d into stable] [This
commit was not auto-picked; that is why it is here] [UNVERIFIED: raw
stable-list HTML]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: [`sdw_dmi_override_adr`] [new static table `global_ghost_adr`]

Step 5.2: TRACE CALLERS
`sdw_intel_ops.override_adr = sdw_dmi_override_adr` in
`drivers/soundwire/intel_auxdevice.c` only. Invoked from `find_slave()`
during ACPI child walk when Intel SoundWire enumerates slaves.
Record: [Intel SoundWire ACPI enumeration only] [Not IRQ/hot path;
probe/enumeration]

Step 5.3: TRACE CALLEES
`dmi_first_match()`, `dev_dbg()`. No alloc, no locks, no I/O.
Record: [DMI match + debug print + table walk]

Step 5.4: FOLLOW THE CALL CHAIN
Intel SoundWire link probe → ACPI walk → `find_slave()` →
`override_adr()` → skip if 0. Reachable on Intel laptops with SoundWire
+ ACPI (typical modern OEM audio). Unprivileged users do not trigger it
directly; it runs at device probe and can break audio setup.
Record: [Reachable on Intel SoundWire machines at enumeration] [Not a
syscall crash path]

Step 5.5: SEARCH FOR SIMILAR PATTERNS
`ghost_realtek[]` remaps `0x000330025d072201` to 0, but only for DMI-
matched ASUS/Lenovo boards. This patch is the same disable, globally,
for a different `_ADR`.
Record: [Same pattern as in-tree ghost Realtek quirks; this ADR is not
machine-specific]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
`git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**; `make
kernelversion` = **7.3.0-rc4**.
`drivers/soundwire/dmi-quirks.c` and `sdw_dmi_override_adr()` are
present. `find_slave()` skips `addr==0`. Without this quirk, a BIOS that
publishes `0x000000D010010500` still enumerates a phantom slave. (`git
merge-base --is-ancestor b7a5d101d7d26 HEAD` is true because this is the
mainline tree that already contains the commit; that is not used as a
“already selected” NO.)
Record: [Yes — Intel SoundWire DMI override path exists] [Firmware bug;
kernel lacked a global skip until 7.3-rc1]

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
On this tree the patch is already the current code. Against the pre-
image (`v7.2` `sdw_dmi_override_adr` is the same shape, only fewer DMI
rows) it would apply with at most context shift in the DMI table. No
API/data-structure change.
Record: [Clean/trivial on this codebase]

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
`ghost_realtek[]` is here but only matches specific DMI IDs and a
different `_ADR`. It does **not** hide `0x000000D010010500`.
Record: [No substitute fix for this ADR]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
`drivers/soundwire/` — Intel SoundWire master + ACPI quirks. Affects
Intel-laptop audio, not core mm/fs.
Record: [SoundWire / Intel audio] [IMPORTANT for those machines,
PERIPHERAL vs core kernel]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Active (BRA/BPT, ACE2x, many 7.3 SoundWire commits). dmi-quirks itself
is a mature table of BIOS workarounds dating to 2021.
Record: [Active Intel SoundWire; quirk file is a long-lived table]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
CONFIG_SOUNDWIRE_INTEL machines whose ACPI includes `_ADR
0x000000D010010500`. Not universal. The author says the ADR is not a
codec, so the quirk is intentionally global rather than DMI-limited.
Record: [Intel SoundWire / config-specific; any OEM BIOS with that
`_ADR`]

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Triggered at SoundWire/ACPI enumeration (boot or audio-controller
probe), not a race. Not userspace-triggered. How common the BIOS entry
is was not documented; Intel submitted it as a global rule, which
implies it is not one SKU.
Record: [Boot/probe on matching firmware] [Unprivileged users are not
the trigger; they see broken or mis-created audio]

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Not a panic/UAF. Failure mode matches the documented ghost-Realtek
issue: phantom ACPI device confuses topology/machine matching → missing
or wrong sound card, probe noise, possible timeouts talking to a device
that is not there. That is a real user-visible audio failure on affected
laptops.
Record: [Broken/misbuilt audio / failed slave probe] [Severity:
MEDIUM–HIGH for affected hardware; not a generic kernel crash]

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Benefit: restores correct enumeration on machines with this BIOS bug;
same class AUTOSEL already accepted for Realtek ghosts. Risk: ~20 lines,
one file, existing 0-skip path, expert review. Global match is slightly
broader than DMI quirks but the `_ADR` is not a real vendor/part.
Record: [Benefit: medium-high for Intel SoundWire laptops] [Risk: very
low] [Favor applying]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Hardware quirk/workaround (stable exception category)
- Small, one-file, uses remap-to-0 that core has honored since v5.13
- Reviewed by Keepax and Bossart; applied by Vinod
- Sibling ghost-device dmi-quirks were AUTOSEL’d to 6.1–6.18
- Code and skip-on-zero path exist in this tree
- Standalone; no new API
AGAINST:
- Thin commit message; no public reproducer or Reported-by
- Not a crash/security/corruption bug
- Global (all machines) rather than DMI-scoped
UNRESOLVED:
- Could not fetch lore.kernel.org/stable HTML (403)
- No independent confirmation of how many BIOSes contain this `_ADR`

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — existing mechanism; two
   expert reviews; maintainer applied v1
2. Fixes a real bug that affects users? **PASS** — phantom ACPI slave
   breaks audio topology/enumeration
3. Important issue? **PASS** as hardware quirk (broken audio on real
   Intel laptops), not as a generic panic
4. Small and contained? **PASS** — +20/-1, one file
5. No new features or APIs? **PASS** — table entry + lookup in existing
   override hook
6. Can apply to the local tree? **PASS** — `dmi-quirks.c` /
   `sdw_dmi_override_adr` / `if (!addr)` all present

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk/workaround** (SoundWire DMI/`_ADR` quirk,
equivalent to USB/PCI/codec quirk table entries)

Step 9.4: MAKE YOUR DECISION
This is a textbook stable hardware quirk: surgical, reviewed, uses a
long-standing disable path, and fixes real OEM firmware that would
otherwise present a fake SoundWire device to audio matching. The missing
Fixes/Cc-stable tags are why it needs review, not a reason to drop it.

Verification:
- [Phase 1] Tags: Reviewed-by Keepax + Bossart; Link msgid; no
  Fixes/Reported-by/Cc-stable
- [Phase 1] ADR decode: mfg_id 0xd010 / part_id 0x0105 / class 0 — not
  an in-tree codec
- [Phase 2] Diff: +20/-1 in `dmi-quirks.c`; `sdw_dmi_override_adr`
  remaps 0x000000D010010500 → 0
- [Phase 2] `slave.c` `if (!addr) return false` confirmed at lines
  125–129
- [Phase 3] override/zero-skip: 6558b667a7297 (v5.13); dmi-quirks file:
  f6594cdfec4cd; ghost_realtek: 4dab2b904414f (v7.2)
- [Phase 3] `git merge-base --is-ancestor b7a5d101d7d26 v7.2` → not in
  v7.2; in v7.3-rc1 via soundwire-7.3-rc1
- [Phase 3] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; Pierre-Louis Rb + zero-skip
  note; Vinod applied; no NAK
- [Phase 4] lore WebFetch 403; used b4 mbox instead
- [Phase 4] Web search: sibling “Disable ghost Realtek devices” AUTOSEL
  6.18–6.1; this commit not AUTOSEL’d
- [Phase 5] Only hooked from `intel_auxdevice.c`
  `sdw_intel_ops.override_adr`
- [Phase 6] Local `dmi-quirks.c` already contains `global_ghost_adr`;
  `ghost_realtek[]` does not cover this ADR
- [Phase 8] Failure mode: phantom slave at Intel SoundWire probe → audio
  topology/machine mismatch, not oops
- UNVERIFIED: how many machines ship this `_ADR`; stable-list HTML
  beyond web snippets

The patch is a small Intel SoundWire hardware quirk, it matches stable
rules, and the local tree has the code it needs.

**YES**

 drivers/soundwire/dmi-quirks.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 2a98fc8c104d6..62cee6e2179da 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -15,6 +15,14 @@ struct adr_remap {
 	u64 remapped_adr;
 };
 
+static const struct adr_remap global_ghost_adr[] = {
+	{
+		0x000000D010010500ull,
+		0x0000000000000000ull
+	},
+	{}
+};
+
 /*
  * Some TigerLake devices based on an initial Intel BIOS do not expose
  * the correct _ADR in the DSDT.
@@ -212,6 +220,7 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 u64 sdw_dmi_override_adr(struct sdw_bus *bus, u64 addr)
 {
 	const struct dmi_system_id *dmi_id;
+	int i;
 
 	/* check if any address remap quirk applies */
 	dmi_id = dmi_first_match(adr_remap_quirk_table);
@@ -223,10 +232,20 @@ u64 sdw_dmi_override_adr(struct sdw_bus *bus, u64 addr)
 				dev_dbg(bus->dev, "remapped _ADR 0x%llx as 0x%llx\n",
 					addr, map->remapped_adr);
 				addr = map->remapped_adr;
-				break;
+				goto out;
 			}
 		}
 	}
 
+	/* remap the ghost ADRs */
+	for (i = 0; i < ARRAY_SIZE(global_ghost_adr); i++) {
+		if (global_ghost_adr[i].adr == addr) {
+			dev_dbg(bus->dev, "remapped _ADR 0x%llx as 0x%llx\n",
+				addr, global_ghost_adr[i].remapped_adr);
+			addr = global_ghost_adr[i].remapped_adr;
+			break;
+		}
+	}
+out:
 	return addr;
 }
-- 
2.53.0

