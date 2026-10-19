Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C585D2A09;
	Mon, 19 Oct 2026 14:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418495; cv=none; b=p+xLMaHUPGmFamnhLCai78sXJRKA28K7P01OXn74a2WD5vpNCvdS6LszrBeuSeffl4x0eNzcIMIVhJO1/Qo28nQ8FDHrIcJWZB1pp0KHIcjJTrCFMlJiV6TbNQogNR1/EP7PK3OnH/fjucrSAaaqsXGWrwgwTlX6SIJMWBTTH5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418495; c=relaxed/simple;
	bh=FTo0tuqmLtaoXV1Ps7QVMNzMAHQZnrxv5rcQCfXaVEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKrFLN0fsVk7KJr4l8MJvtnjdPA5xbDKzAmmSygPOE2tn65i8e5yHJYmfA+8rs7BqBMEpmgY7MJJlODZeplDO54+b6YKHQKGLGn5SUMxmgl3ucqcXmmKY2qEBTKrON2dF74UH3x5HoIKn38p9uV/lUucrXMIGs+EHg7q2o9ejoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzBPbMoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzBPbMoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866961F000C4;
	Mon, 19 Oct 2026 14:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418492;
	bh=qIx0oMbMGkNxA0B5LE0snzLqyXZgwPDKrBhNTml/zNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzBPbMoPD1ux0ii5v8qFtUoLQ79s6HMzxWiSGoJaTbQbNRCVs+DfLG3qK+WnCP4p8
	 i3mtcQrnqQqQFOw82lWUHKPh8f+D8JOXPvMtwik8vUoRwGsBIx7XJyLfCAJp2aNeAl
	 7yJtBc/LkrUXef5zvK8X8ETlkwa3QBdDa6eeDJShIn2Fd7BnDxwjPcCdm1Q3EWamot
	 jaZryFxTVr+PQZMjcXfF75eXqReinNr60f+bgaaidbwi6jJoZ71Fta4EYw2j4K51DW
	 fslb2kxTtCWC/TNI6dbtapJ+p0a9SPDXhYyKwfeAgCAksGCFMBq6VDZayXgMlzkpap
	 i9OG+PbEkKp1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-5.15] wifi: mt76: mt7603: add 0x7592 EEPROM chip ID
Date: Mon, 19 Oct 2026 09:49:38 -0400
Message-ID: <20261019135441.1420968-287-sashal@kernel.org>
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

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit d16447d7470502e998d82e806ca7ed49d1baa853 ]

Some EcoNet based routers ship an on-flash EEPROM whose chip-id is
0x7592 instead of the expected 0x7603. The device probes as PCI
14c3:7603 and the hardware MT_HW_CHIPID register reports 0x7603,
independent of the EEPROM value.

This is seen across multiple EcoNet EN751221 and EN7528 based devices
(for example the Genexis Platinum 4410).

Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Link: https://patch.msgid.link/20260719082530.3879831-1-naseefkm@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The evaluation target is **pending-6.6 (6.6.157)**. The mt7603 driver is
present; the 0x7592 EEPROM ID is not. This is a one-line ID addition to
an existing driver, which is a standard stable exception.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [wifi: mt76: mt7603] [add] [accept EEPROM chip ID 0x7592 in
mt7603_check_eeprom]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Ahmed Naseef \<naseefkm@gmail.com\> (author)
- Link:
  https://patch.msgid.link/20260719082530.3879831-1-naseefkm@gmail.com
- Signed-off-by: Felix Fietkau \<nbd@nbd.name\> (mt76 maintainer,
  applied the patch)
- No Fixes: tag (expected for this review queue)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by
- No syzbot / KASAN tags
- Sasha Levin SOB not present on this commit

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: EcoNet routers store chip-id 0x7592 in on-flash EEPROM instead of
  0x7603/0x7628/0x7600.
- Hardware identity is still MT7603: PCI 14c3:7603, and MT_HW_CHIPID
  reads 0x7603.
- Symptom: driver treats a valid factory EEPROM as invalid.
- Devices: EcoNet EN751221 and EN7528, e.g. Genexis Platinum 4410.
- No stack trace; this is hardware recognition, not a crash fix.
- Root cause: mt7603_check_eeprom() whitelist is incomplete.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit EEPROM ID addition.
When the ID is rejected and OTP exists, mt7603_eeprom_init() memcpy()s
OTP over the flash EEPROM, so MAC/calibration from flash are discarded.
That is a real functional bug for those boards, not a new API.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
- +1 line, 0 removed
- Function: mt7603_check_eeprom()
- Scope: single-file, one-line surgical change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: switch accepts 0x7628, 0x7603, 0x7600; anything else returns
  -EINVAL.
- After: also accepts 0x7592.
- Path: probe → mt7603_register_device() → mt7603_init_hardware() →
  mt7603_eeprom_init().
- If check succeeds and OTP exists: apply cal-free OTP overlay onto
  flash EEPROM.
- If check fails and OTP exists: overwrite entire flash EEPROM with OTP
  (MAC, TX power, xtal data from flash lost).
- Probe does not fail on unknown EEPROM ID.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware ID / quirk] [Whitelist used to decide whether on-flash
EEPROM is trusted. Missing 0x7592 caused valid EcoNet EEPROMs to be
discarded in favor of OTP.]

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: same pattern as the existing 0x7600 case.
- Minimal: one case label.
- Regression risk: very low. A random EEPROM whose first LE16 is 0x7592
  would be trusted; that is the same risk as the existing IDs.
- No API or data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- mt7603_check_eeprom() introduced in c8846e1015022 ("mt76: add driver
  for MT7603E and MT7628/7688"), 2018, first released in v5.1-rc1.
- 0x7600 added by bf4a938ab2cf8 ("mt76: mt7603: add additional EEPROM
  chip ID"), 2020, same one-line pattern for TP-Link Archer C50 v4.
- Both commits are ancestors of pending-6.6.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Buggy whitelist dates to the original driver
(v5.1), which is in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Related: bf4a938ab2cf8 already in 6.6 (precedent).
- Candidate d16447d747050 is not an ancestor of pending-6.6.
- Standalone; not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Author Ahmed Naseef has no other mt76 commits on pending-6.6.
- Applied by Felix Fietkau, listed maintainer of MEDIATEK MT76.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- No new helpers or struct fields.
- pending-6.6 vs patch parent only differs in SPDX and later
  chainmask/return of mt76_eeprom_override(); the switch hunk is
  identical.
- Can apply standalone with a clean hunk.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 dig -c d16447d747050 →
  https://patch.msgid.link/20260719082530.3879831-1-naseefkm@gmail.com
- b4 dig -a: single v1 series, no v2/v3.
- Thread mbox is the patch only; no replies, no NAK, no Cc: stable in
  review.
- Included in wireless-next-2026-08-06 pull (Johannes Berg).
- Syzbot CI: build/boot passed; fuzz skipped.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record:
- b4 dig -w: Felix Fietkau, Lorenzo Bianconi, Ryder Lee, Shayne Chen,
  Sean Wang, linux-wireless, linux-mediatek, linux-kernel.
- Applied by Felix Fietkau (maintainer SOB). No separate Reviewed-by.

Step 4.3: SEARCH FOR THE BUG REPORT
Record:
- No bugzilla/syzbot link.
- Commit cites multiple EcoNet EN751221/EN7528 devices, example Genexis
  Platinum 4410.
- OpenWrt mt76 tree already contains case 0x7592.
- No independent public crash report found (UNVERIFIED beyond the commit
  text and OpenWrt tree).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone one-patch series. Same pattern as bf4a938ab2cf8.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable returned 403. No stable discussion found
via b4/mbox. UNVERIFIED whether anyone requested/rejected this for
stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: mt7603_check_eeprom() only.

Step 5.2: TRACE CALLERS
Record:
- Only caller: mt7603_eeprom_init() (same file).
- mt7603_eeprom_init() ← mt7603_init_hardware() ←
  mt7603_register_device()
- mt7603_register_device() ← mt76pci_probe() (PCI 14c3:7603) and
  mt76_wmac_probe() (mediatek,mt7628-wmac).
- Probe/init path, not hot path or IRQ.

Step 5.3: TRACE CALLEES
Record: get_unaligned_le16() on eeprom.data[0]. No alloc, lock, or I/O
in the changed function.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Reachable when an MT7603 PCI device or MT7628 WMAC probes with
  CONFIG_MT7603E.
- Not a syscall-triggered memory bug; firmware/EEPROM contents decide
  the branch.
- Unprivileged users cannot trigger it except by plugging/using the
  device.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record:
- Sibling drivers use the same EEPROM-ID switch (mt7615, mt76x0,
  mt76x2).
- This tree already backported other mt76 ID adds, e.g. efd75512e38ac
  (mt76x2u TP-Link USB ID).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree under evaluation: pending-6.6, 6.6.157 (git describe
  p-6.6-3-g04810563abb71).
- Yes. pending-6.6 eeprom.c switch has 0x7628/0x7603/0x7600 only.
- git merge-base --is-ancestor d16447d747050 pending-6.6 → not present.
- Bug present since v5.1 driver introduction.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Switch context matches. Later chainmask/license
diffs are outside the hunk.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: 0x7600 ID is present. 0x7592 is not. No alternate fix.

Note: EcoNet SoC support landed in 6.16 (arch/mips/econet), not in 6.6.
That lowers vanilla-6.6 user count; it does not remove the driver or the
ID check. PCI 14c3:7603 still exists in this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drivers/net/wireless/mediatek/mt76/mt7603] [IMPORTANT for
MT7603/MT7628 users; PERIPHERAL relative to core kernel]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature driver since v5.1. 6.6 still receives mt76 fixes.
Maintainer is Felix Fietkau.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / config-specific (CONFIG_MT7603E). Documented
users are EcoNet EN751221/EN7528 routers with MT7603 PCI WiFi. Vanilla
6.6 cannot boot EcoNet SoCs; downstream 6.6 kernels and any other board
with this EEPROM still benefit.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: probe of MT7603 when flash EEPROM starts with 0x7592 and OTP
  is present.
- Every boot on those devices, not a race.
- Not exploitable by unprivileged software alone.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Wrong EEPROM source: factory MAC/calibration replaced by OTP]
[Severity: MEDIUM for those devices — broken/degraded WiFi or wrong MAC,
not oops/corruption]

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium for affected hardware (WiFi uses intended EEPROM);
  lower on vanilla 6.6 because EcoNet platform is later, but this is the
  usual device-ID case.
- Risk: very low (one case label, no locking/API).
- Ratio: favorable. Device-ID additions are accepted in stable for this
  reason.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- One-line EEPROM/chip ID addition to an existing driver (stable
  exception).
- Same pattern as 0x7600, already in 6.6.
- Real boards named; hardware already binds as PCI 14c3:7603.
- Without it, valid flash EEPROM is discarded for OTP (MAC/cal).
- Maintainer applied it; applies cleanly here; no new API.
- This tree already contains similar mt76 ID backports.

AGAINST:
- Not a crash/security/deadlock.
- No Tested-by/Reviewed-by; mailing list had no discussion.
- EcoNet platform is not in 6.6, so vanilla 6.6 user count is small.
- No Fixes:/Cc: stable (expected, not a negative).

UNRESOLVED:
- Could not search lore.kernel.org/stable (403).
- No independent public repro beyond the commit and OpenWrt mt76 tree.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — one-line whitelist, maintainer-
   applied, syzbot CI build/boot passed.
2. Fixes a real bug that affects users? PASS — those boards trust OTP
   instead of factory EEPROM.
3. Important issue? PASS under the device-ID/quirk exception (functional
   WiFi/MAC on real hardware), even though not a panic.
4. Small and contained? PASS — +1 line, one file.
5. No new features or APIs? PASS — existing driver, additional ID only.
6. Can apply to the local tree? PASS — hunk matches pending-6.6.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Device ID addition to an existing driver (EEPROM chip ID,
analogous to PCI/USB ID). Also a hardware quirk for boards whose EEPROM
ID does not match MT_HW_CHIPID.

Step 9.4: MAKE YOUR DECISION
This belongs in 6.6.y. The driver and the incomplete whitelist are in
this tree; the fix is the standard one-line ID addition stable already
takes for mt76. EcoNet SoC support arriving later reduces vanilla-6.6
exposure but does not make the patch a new feature or a dependency-heavy
backport.

What it solves for stable users: MT7603 devices whose flash EEPROM ID is
0x7592 keep factory MAC and calibration instead of having them replaced
by OTP on probe.

Risk vs benefit: essentially no regression risk; benefit is enabling
correct EEPROM use on existing hardware.

Verification:
- [Phase 1] Tags: author SOB, Felix Fietkau SOB, msgid link; no Fixes/Cc
  stable/Reported-by
- [Phase 2] Diff: +1 `case 0x7592:` in mt7603_check_eeprom()
- [Phase 2] Confirmed eeprom_init: fail → memcpy OTP over flash; success
  → cal-free overlay only
- [Phase 3] blame: function from c8846e1015022 (v5.1); 0x7600 from
  bf4a938ab2cf8; both in pending-6.6
- [Phase 3] git merge-base --is-ancestor d16447d747050 pending-6.6 → not
  in 6.6
- [Phase 3] git diff pending-6.6 vs parent: switch identical; only
  SPDX/chainmask elsewhere
- [Phase 4] b4 dig -c d16447d747050: lore msgid
  20260719082530.3879831-1-naseefkm@gmail.com
- [Phase 4] b4 dig -a: v1 only; mbox has no replies
- [Phase 4] b4 dig -w: mt76 maintainers + linux-wireless CC'd; Felix
  applied
- [Phase 4] wireless-next-2026-08-06 pull lists this commit
- [Phase 5] callers: mt7603_eeprom_init → init_hardware →
  register_device → pci/soc probe
- [Phase 6] pending-6.6 Makefile 6.6.157; switch lacks 0x7592; would
  apply cleanly
- [Phase 6] EcoNet arch not in 6.6 (added ~6.16) — lowers vanilla user
  count, code still present
- [Phase 7] MAINTAINERS: Felix Fietkau maintains mt76
- [Phase 8] Failure: OTP replaces flash EEPROM (MAC/cal); not oops
- UNVERIFIED: stable@ lore search (HTTP 403); no independent field crash
  report

**YES**

 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
index 88382b537a33b..06f61988655e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
@@ -142,6 +142,7 @@ static int mt7603_check_eeprom(struct mt76_dev *dev)
 	case 0x7628:
 	case 0x7603:
 	case 0x7600:
+	case 0x7592:
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.53.0

