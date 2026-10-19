Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E2E53FA22;
	Mon, 19 Oct 2026 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418180; cv=none; b=VM22sgQc1pOLc3q+bMC38sr4MlrAWcOoGPsbYHUYqj/Gwu7VVqiKb4O5rCJsB/J5h5+QlTCoBz0mDX+xz+eVMWjRPcqWffF49AS4tHRQYIgz0/DdnmXtG4NHGZX2vOC2T9x9Y66elnQmYyVlTd8QF+UpfJ0hgvsagEiI6kh54T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418180; c=relaxed/simple;
	bh=d90ZrNWGybZ/fopWYi0lPp9zHkViaDcRPzWPu+Nm33M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TgoYRjjWVO7M2/bHhr6VXRvPEGbJdG19Gfx9LPZtbQzRfJ0UsRb94TMeQgS2SBTnN8rq2DBRvOKuGU7VHqOvdrnJ0N1nAKeurq6Eb/FJC8OFdDQxWMSYeimvKzolhzaYbTxMPcnOJlCOelJpEcqk5jK+Bw/Pb0vcqfCiEi8+9Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCgHFXK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCgHFXK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30F41F000CC;
	Mon, 19 Oct 2026 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418178;
	bh=2uU7PWYBqpQgVB2lo4xNTADonPX7dwGLfKqej5TgR7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VCgHFXK34xD1N1KPut+MjIbsumSqfzSsVsyS85ZRwAegaYIAMieNexsef3/8V3jAa
	 /OqdKarBzLD3qI2V0qsnjw1Wj54R0FSLlbF+9hFRIEYQ57LPwW03x4vPabym6x8eil
	 6mubKVx0RpDByNM85/EpAo+v2vEHTsGvSlv71pHlWi2VauHu2g17R2Yb/0x/vmCSQ8
	 i5SDzY8iZvoMLGK2kHkqvh9hgE/f4Ed2dTDfsIRNlzGuU1CVFD/qK0yMXnziUzYgIi
	 D0iEve0X5995aqenToUdQVDIUr6bVY8SbaqYvi2b08JL0KkrxuxSO/GT9x29sMmO5/
	 WStE8km1JcTmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] soundwire: intel_auxdevice: Add cs42l44 to wake_capable_list
Date: Mon, 19 Oct 2026 09:45:59 -0400
Message-ID: <20261019135441.1420968-68-sashal@kernel.org>
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

[ Upstream commit d08e4d9197396ceb906715d976b63aed0c5cc8e5 ]

Add cs42l44 to the wake_capable_list because it can generate
jack events whilst the bus is stopped.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260708122948.1502227-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this: it is a one-line Intel SoundWire wake quirk
for CS42L44, which this 7.3-rc4 tree already contains.

## Local tree

- `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion`: `7.3.0-rc4`
- Makefile: `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`
- Commit under review: `d08e4d9197396ceb906715d976b63aed0c5cc8e5`
- `git merge-base --is-ancestor d08e4d9197396 HEAD`: yes (merged via
  `soundwire-7.3-rc1`; not in `v7.2`)

Verdict is for this 7.3-rc4 checkout only. `intel_auxdevice.c`,
`wake_capable_list`, and `is_wake_capable()` are present here. This is a
host-side ID quirk in an existing Intel SoundWire master driver.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[soundwire/intel_auxdevice] [Add] [put CS42L44 on the Intel
wake-capable quirk list]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` none (expected)
- `Reported-by:` none
- `Tested-by:` none
- `Reviewed-by:` none on the committed version
- `Acked-by:` none
- `Link:` `https://patch.msgid.link/20260708122948.1502227-1-
  ckeepax@opensource.cirrus.com`
- `Cc: stable@vger.kernel.org`: none (expected)
- `Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>`
  (Cirrus, chip vendor)
- `Signed-off-by: Vinod Koul <vkoul@kernel.org>` (SoundWire maintainer)
- Ignore any Sasha Levin SOB / `[Upstream commit]` markers (none in the
  real commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: CS42L44 can raise jack events while the SoundWire bus is clock-
  stopped, but the Intel master did not treat it as wake-capable.
- Symptom: headset plug/unplug while audio is idle is missed; bus/system
  does not wake for jack detect.
- Version info: none in the message. Commit landed for 7.3-rc1.
- Root cause (from this patch plus `e66f91a2d10b9`): ACPI does not
  export wake capability; the codec driver’s `wake_capable` flag is too
  late (set at probe, after device-number assignment). The Intel master
  uses a static mfg/part quirk table.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised cleanup. Explicit hardware-quirk / device-ID
addition.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/soundwire/intel_auxdevice.c` (`+1 / -0`)
- Function: none; one entry in `wake_capable_list[]`
- Scope: single-file surgical ID add

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: `{0x01fa, 0x4244}` was absent, so `is_wake_capable()` returned
  false for CS42L44 unless firmware already set
  `slave->prop.wake_capable`.
- After: match on Cirrus `mfg_id 0x01fa` + `part_id 0x4244`.
- Path: SoundWire enumeration / device-number allocation
  (`intel_get_device_num_ida`, `generic_new_peripheral_assigned`), not
  an error path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: **hardware workaround / device ID in an existing quirk
  table**
- Mechanism: Intel Lunar Lake-class wake requires a system-unique SDI
  and IDA device numbers in a reserved range. Without the list entry,
  CS42L44 is allocated a non-wake number, `program_sdi()` is skipped,
  and jack IRQs while the bus is stopped are not handled.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: same pattern as CS42L43 (`0x4243`), CS42L45
  (`0x4245`), CS42L49 (`0x4249`), CS42L43B (`0x2A30`/`0x2A3B`).
- Minimal: one array line; no API, locking, or structure change.
- Regression risk: very low. Extra list iteration is cheap; the new ID
  only matches that part. Wrong SDI assignment would only affect that
  exact codec, and the vendor authored the entry.
- Nearby gap (does not make this patch wrong):
  `drivers/mfd/cs42l43-sdw.c` still has no `SDW_SLAVE_ENTRY` for
  `0x4244`. DT only gained `cirrus,cs42l44` later (`d4c669890ed08`).
  This commit is still the correct host-side quirk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Table introduced in `e66f91a2d10b9` (2023-07-31, described as
  `v6.5-rc1-6-ge66f91a2d10b9`): “add hybrid IDA-based device_number
  allocation”.
- That commit states the quirk table is expected to grow for each new
  headset codec because firmware does not provide wake capability.
- Line `0x4244` itself is this commit (`d08e4d9197396`, Charles Keepax,
  2026-07-08).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The “bug” is an incomplete
quirk table, not a regression from a single earlier SHA.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same one-line additions: `fe600c8e2dc5d` (cs42l43),
`f87e5575a6bd1` (cs42l45), `b8f2d65fec19f` (cs42l49), `be6d8daaab654`
(cs42l43b), `4b8fc2b17272d` (CS47L47), `4e90368e8680d` (es9356).
Standalone, not `N/M`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Charles Keepax is a regular Cirrus SoundWire/ASoC contributor
and also authored the CS42L43B and CS42L49 wake-list entries. Vinod Koul
applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Depends only on `wake_capable_list` / `is_wake_capable()`,
present here since `e66f91a2d10b9`. Applies standalone. No new helper or
struct.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c d08e4d9197396`: `https://patch.msgid.link/20260708122948.15
  02227-1-ckeepax@opensource.cirrus.com`
- `b4 dig -a`: v1 only; committed version is that v1
- Thread: submit (Keepax) + “Applied, thanks!” (Vinod Koul). No NAK, no
  v2, no reviewer risk notes, no `Cc: stable` in-thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To `vkoul@kernel.org`; Cc Bard Liao, Pierre-Louis
Bossart, linux-sound, linux-kernel, Cirrus patches. Maintainer applied;
no extra Reviewed-by on this revision.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot. Vendor (Cirrus) patch. Later DT text:
“cs42l44 is a cost optimised variant of cs42l43b” (`d4c669890ed08`).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone 1/1. Related later: DT compatible only. MFD SoundWire
ID for `0x4244` is still missing in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable fetch returned 403. Web search found
`[PATCH AUTOSEL 6.19-6.12] ... add cs42l45 codec to wake_capable_list` —
same class of ID was auto-selected for stable. No evidence this CS42L44
patch was rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `wake_capable_list[]` data only. Consumers: `is_wake_capable()`,
`intel_get_device_num_ida()`, `intel_put_device_num_ida()`,
`generic_new_peripheral_assigned()`.

**Step 5.2: TRACE CALLERS**
Record:
- `is_wake_capable()` is static; three call sites in this file (lines
  135, 269, 283).
- `intel_get/put_device_num_ida` are `sdw_intel_ops.get_device_num` /
  `put_device_num`.
- `generic_new_peripheral_assigned` is
  `sdw_intel_ops.new_peripheral_assigned`.
- Context: Intel SoundWire enumeration / PM, not syscall-hot or IRQ
  handler body.

**Step 5.3: TRACE CALLEES**
Record: `ida_alloc_range` / `ida_free` for wake devices;
`hw_ops->program_sdi()` when wake-capable.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: ACPI Intel SoundWire controller → peripheral enumeration →
device number → optional SDI programming. Reachable on Intel laptops
with this codec when audio clocks stop (idle/runtime PM). Not a
userspace-triggered memory-safety bug; it is a device-operation path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same Cirrus IDs already in the table (`0x4243`, `0x4245`,
`0x4249`, `0x2A30`, `0x2A3B`). `sdca_class.c` binds
`0x4245`/`0x4249`/`0x4747` but not `0x4244`. `cs42l43-sdw.c` binds
`0x4243` and `0x2A3B` only.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes, the Intel quirk table and lookup exist
(`drivers/soundwire/intel_auxdevice.c`). Without this ID, CS42L44 would
not be wake-capable here. `e66f91a2d10b9` is from 2023; the table is
long-lived. This commit is already in 7.3-rc1+, so the ID is present at
HEAD; the evaluation is whether that change belongs in this tree’s
stable stream, not whether 6.x is different.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply: insert `{0x01fa, 0x4244}` next to the other Cirrus
entries. No refactor needed on this tree.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This SHA is already an ancestor of HEAD. Sibling codec IDs are
already in the same table. No alternate CS42L44 wake fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/soundwire/` Intel master (`CONFIG_SOUNDWIRE_INTEL`).
**IMPORTANT** for Intel laptop audio, not core mm/VFS. Peripheral
relative to the whole kernel; standard for headset jack/wake.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (regular wake-list IDs, DMI quirks, cadence clock-stop
work). The table mechanism itself has been stable since 2023.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Intel SoundWire hosts with Cirrus CS42L44 (`mfg 0x01fa`, `part
0x4244`). No effect on other devices.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Jack insert/remove while the SoundWire bus is stopped (runtime
idle / clock stop). Common on laptops. Not a security trigger from
unprivileged syscalls.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Missed jack / wake events (headset not detected until something
else restarts the bus). **MEDIUM** functional hardware bug; not
oops/corruption. Covered by the hardware-quirk exception.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: restores jack-wake on CS42L44, same as sibling Cirrus codecs.
- Risk: very low (one static ID).
- Ratio: strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- One-line ID in an existing Intel SoundWire quirk table
- Real hardware: CS42L44 is a documented CS42L43B cost-down variant
  (Cirrus + DT `cirrus,cs42l44`)
- Without it, jack events while the bus is stopped are dropped (by
  design of `e66f91a2d10b9`)
- Same pattern already used for cs42l43/45/49/43b; cs42l45 was AUTOSEL’d
  for stable
- Vendor author, SoundWire maintainer applied, v1 accepted
- Applies cleanly; no new API

AGAINST:
- Not a crash/UAF/security fix
- No `Reported-by` from end users
- MFD `cs42l43-sdw.c` still lacks `0x4244`, so codec bind on Intel SDW
  is incomplete in this tree
- No in-thread `Cc: stable` (not a negative per rules)

UNRESOLVED:
- lore.kernel.org/stable search HTTP 403
- How many shipping Intel SKUs use CS42L44 (unverified; vendor patch is
  the evidence)

The missing MFD ID is a separate gap. This patch only teaches the
**Intel master** to treat the part as wake-capable at enumeration, which
must happen before codec probe. That is exactly what this table is for.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one ID, established table,
   maintainer applied
2. Fixes a real bug that affects users? **PASS** — missed jack/wake on
   CS42L44
3. Important issue? **PASS** via hardware-quirk exception (broken jack
   detect while bus stopped)
4. Small and contained? **PASS** — +1 line, one file
5. No new features or APIs? **PASS** — ID in existing quirk list, not a
   new driver
6. Can apply to the local tree? **PASS** — `wake_capable_list` exists;
   patch is a clean insert

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / device ID addition to an existing driver**
(`wake_capable_list` in `intel_auxdevice.c`). Prompt: these are YES for
stable.

**Step 9.4: MAKE YOUR DECISION**
This tree has the Intel SoundWire master and the quirk table. Adding
CS42L44 is the same class of change as USB/PCI ID and codec quirks:
small, obviously correct, and required for real hardware. Benefit
outweighs risk.

---

## What the commit solves for this tree

On Intel SoundWire, device numbers for wake-capable codecs must be
assigned at enumeration from a reserved IDA range, and SDI must be
programmed. Firmware does not advertise wake capability, and the codec
driver has not probed yet, so the master uses `wake_capable_list`.
CS42L44 can generate jack IRQs while the bus is clock-stopped; without
`{0x01fa, 0x4244}` those events are lost. That is a real user-visible
headset-detect failure, not a new feature.

Risk is a single static table entry. No locking, alloc, or ABI change.

---

## Verification

- [Phase 1] `git show d08e4d9197396 --format=fuller`: tags as listed;
  body is the two-line jack-event rationale
- [Phase 2] Diff: `+{0x01fa, 0x4244}` only in `wake_capable_list`
- [Phase 2] Read `intel_auxdevice.c`: `is_wake_capable()` used at lines
  135, 269, 283
- [Phase 3] `git blame -L 53,77 drivers/soundwire/intel_auxdevice.c`:
  table from `e66f91a2d10b9`; this ID from `d08e4d9197396`
- [Phase 3] `git show e66f91a2d10b9`: explains why the quirk table
  exists and will grow
- [Phase 3] `git merge-base --is-ancestor d08e4d9197396 HEAD`: yes; not
  an ancestor of `v7.2`; is in `v7.3-rc1`
- [Phase 3] No `Fixes:`; related one-liners listed above
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 lore thread; Vinod applied;
  recipients include Liao, Bossart, linux-sound
- [Phase 4] WebSearch: AUTOSEL of the cs42l45 equivalent; CS42L44 thread
  has no NAK
- [Phase 4] UNVERIFIED: stable@ lore (HTTP 403)
- [Phase 5] Callers confirmed by grep in
  `drivers/soundwire/intel_auxdevice.c`
- [Phase 5] `cs42l43-sdw.c` id_table: `0x4243` and `0x2A3B` only — no
  `0x4244` (verified)
- [Phase 6] `git describe HEAD` / `make kernelversion`: 7.3.0-rc4; file
  and table present
- [Phase 6] `git show d4c669890ed08`: DT `cirrus,cs42l44` = cost-
  optimised CS42L43B
- [Phase 8] Failure mode: missed jack/wake, not oops; quirk exception
  applies

**YES**

 drivers/soundwire/intel_auxdevice.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index c0c8ffcecc6bf..347e06ad6edba 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -54,6 +54,7 @@ static struct wake_capable_part wake_capable_list[] = {
 	{0x01fa, 0x2A30},
 	{0x01fa, 0x2A3B},
 	{0x01fa, 0x4243},
+	{0x01fa, 0x4244},
 	{0x01fa, 0x4245},
 	{0x025d, 0x5682},
 	{0x025d, 0x700},
-- 
2.53.0

