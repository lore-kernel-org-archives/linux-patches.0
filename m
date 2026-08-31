Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A02055C322;
	Mon, 31 Aug 2026 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184034; cv=none; b=rImBxRGv+XUYMUGMyRQwXBDB+b/VV9iyrVouAVVTClzb3bTgu1QHtX2j9+US4oxxUbdLKU6pkPVKf91DFCbHc6zK17BP18CNDkGzAdTbxDGqJ06a/IaMkMLUwMY09o/UBB4SDb/lNeie7GvzmoKEkbCkm+7oMd+6yyTUQbVtZb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184034; c=relaxed/simple;
	bh=0Cjmk0kCgi86IxYn8tza0kbbYuon573llq5aR7LuiKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mUwzQAvKTD2Ucp23Spq6+63t08Ygp12SFh81mvBNrqJOnOajFY8bxCn1Jb8BLfxZ10hW4DFyQeEi4bbBTKeQq/59x97eaA9fj6MUmCTl6LJQgYFPI2ftZUwPvmNu95GFpyBbuW4n6GcEHjN9KkCO1UrgZ4DTFq/0wTdQsN0L7vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdD8xoOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdD8xoOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDE61F00A3E;
	Mon, 31 Aug 2026 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184032;
	bh=5hjfVIzCYf6JQbj+yEVcByH4cLUNPP1nPkhVuvNkzF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdD8xoOU16pJPZWGVqJQJaaF2qrPyQ3L0ninavv+vM6CZNGRQ1pIgarhhp4lkmzBj
	 VKsG7kLfeMPhHDMc9bWrgnijjmmBkZxJvhBLRo4kR3DYfwkWUGmHXPvE4LufBz2eXX
	 icbvvAFMUNBZev+9twtoBjcHECxfeOYTi61cdGpUOab5VrOYf8GnT7I0Xt3JIkTEk9
	 9SkhjE5ar6/ZoQ5aq1xmzHsd+C5Z6plu9d1bleOJZWpAeR+VbVfMsrVrwl8P0kyZEF
	 EiKbAK1CH6LWjKaYFFS72yhVUzdLasFiKU6otwn4m3Mwzq+zUWPIOdC/4MWv5uEB/k
	 uffjuSOAYcQXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shiji Yang <yangshiji66@outlook.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-pwm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] pwm: mediatek: set mt7628 pwm45_fixup flag to false
Date: Mon, 31 Aug 2026 09:27:58 -0400
Message-ID: <20260831133314.4125787-450-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 88c6c956fa310117638e41d4831b20074dfff2ba ]

According to the programing guide, mt7628 has generic register layout
like most other hardware revisions. We should not set pwm45_fixup flag
for it.

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Link: https://patch.msgid.link/OS7PR01MB13602B3C7E43A2E38275C73AEBC74A@OS7PR01MB13602.jpnprd01.prod.outlook.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[pwm: mediatek]` `[set]` — Correct the `mt7628`
`pwm45_fixup` SoC data flag from `true` to `false`.

### Step 1.2: Commit message tags
**Record:**
- **Signed-off-by:** Shiji Yang `<yangshiji66@outlook.com>` (author)
- **Link:** patch.msgid.link URL to original submission
- **Signed-off-by:** Uwe Kleine-König `<ukleinek@kernel.org>` (PWM
  maintainer, committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: no syzbot/user bug report; maintainer ack only

### Step 1.3: Body analysis
**Record:**
- **Bug:** MT7628 was configured with `pwm45_fixup = true`, but the
  programming guide says MT7628 uses the generic register layout (like
  most MediaTek PWM revisions), not the MT7623-specific PWM4/5 offset
  quirk.
- **Symptom:** PWM channel 3 on MT7628 uses wrong register offsets for
  period/duty (`0x30`/`0x34` instead of `0x2c`/`0x30`), so PWM3 output
  is programmed incorrectly.
- **Root cause:** Incorrect SoC table entry, likely copied from MT7623
  when MT7628 support was added in 2018.
- **Version info:** None in commit message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite the neutral wording (“set flag to false”), this
is a hardware-specific driver bug fix, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Change inventory
**Record:**
- **Files:** `drivers/pwm/pwm-mediatek.c` only (+1/−1)
- **Functions modified:** none (only `mt7628_pwm_data` static
  initializer)
- **Scope:** Single-file, one-line surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** For `mediatek,mt7628-pwm`, `pwm45_fixup = true` → in
  `pwm_mediatek_config()` and `pwm_mediatek_get_state()`, when
  `pwm->hwpwm > 2`, driver uses `PWM45DWIDTH_FIXUP` (0x30) and
  `PWM45THRES_FIXUP` (0x34).
- **After:** `pwm45_fixup = false` → MT7628 always uses standard
  `PWMDWIDTH` (0x2c) and `PWMTHRES` (0x30).
- **Affected path:** PWM apply/get_state on MT7628 channel 3 only
  (`num_pwms = 4`, so channels 0–2 are unaffected).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware quirk / logic correctness fix
- **Mechanism:** MT7628 has 4 PWMs. With `pwm45_fixup = true`, channel 3
  (`hwpwm == 3`) gets MT7623-specific register offsets that do not exist
  on MT7628, writing period/duty to wrong registers and breaking PWM3.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: aligns MT7628 with every other non-MT7623 entry
  (`pwm45_fixup = false`).
- Minimal and isolated; zero risk to other SoCs.
- No deadlock/locking/API change risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / introduction
**Record:**
- Buggy `pwm45_fixup = true` for MT7628 introduced in `8cdc43afbb2cb`
  (“pwm: mediatek: Add MT7628 support”, Jul 2018).
- Present in this tree at `drivers/pwm/pwm-mediatek.c:461`.
- Present since at least v5.10 through v6.18 in this repo.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Original buggy commit is
`8cdc43afbb2cb`, which is in this tree’s ancestry.

### Step 3.3: Related file history
**Record:**
- Related fix on linux-next: `c84291ce0e09d` (“pwm: mediatek: correct
  mt7628 clock source setting”) — patch 2/2 of the same series, adds
  `clksel_fixup`.
- Original `pwm45_fixup` mechanism added for MT7623 in `360cc036563db`
  (Mar 2018, with `Cc: stable@vger.kernel.org`).
- Fix commit `88c6c956fa310` is **not** in current HEAD (6.18.44); buggy
  code is still present.

### Step 3.4: Author context
**Record:** Shiji Yang is a contributor; Uwe Kleine-König is PWM
subsystem maintainer and committed the fix.

### Step 3.5: Dependencies
**Record:** Patch 1/2 is standalone (one boolean). Patch 2/2 addresses a
separate MT7628 clock-source issue and is not required for this one-line
change to apply or make sense.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/OS7PR01MB13602B3C7E43A2E38275C73AEBC
  74A@OS7PR01MB13602.jpnprd01.prod.outlook.com
- **Series:** `[PATCH 0/2] pwm: mediatek: fix mt7628 register offset and
  clock source`
- **Revisions:** v1 only (b4 dig -a)
- Uwe Kleine-König: “series looks reasonable”; applied without further
  Mediatek maintainer feedback (May 2026)
- No explicit stable nomination in thread
- No NAKs

### Step 4.2: Reviewers
**Record:** CC’d: linux-pwm, Uwe Kleine-König, Matthias Brugger,
AngeloGioacchino Del Regno, linux-mediatek. No formal `Reviewed-by` on
the patch.

### Step 4.3: Bug reports
**Record:** No syzbot, Bugzilla, or user crash reports. Hardware
documentation is the evidence source.

### Step 4.4: Related patches
**Record:** Patch 2/2 adds `clksel_fixup` for MT7628 clock BIT(3)
handling — separate issue affecting all channels’ clock config; not a
prerequisite for this register-offset fix.

### Step 4.5: Stable list history
**Record:** Not searched on lore stable (fetch blocked). No stable
nomination found in mbox thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `pwm_mediatek_config()`, `pwm_mediatek_get_state()` (where
`pwm45_fixup` is checked); `mt7628_pwm_data` (modified).

### Step 5.2: Callers
**Record:** `pwm_mediatek_apply()` → `pwm_mediatek_config()`; PWM core
calls `.apply`/`.get_state` when consumers configure PWM via sysfs or
kernel drivers.

### Step 5.3: Callees
**Record:** `pwm_mediatek_writel()` / `pwm_mediatek_readl()` perform
MMIO to PWM registers with computed offsets.

### Step 5.4: Reachability
**Record:** Reachable when a board probes `mediatek,mt7628-pwm` and uses
PWM channel 3. Driver and DT binding exist; no in-tree `mt7628-pwm` DT
node currently, but out-of-tree/OpenWrt boards may use it.

### Step 5.5: Similar patterns
**Record:** Only MT7623 has `pwm45_fixup = true`. All other SoCs,
including MT7628’s siblings, use `false`. MT7623’s fix was explicitly
stable-nominated in 2018.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code present?
**Record:** Yes. `git describe HEAD` → `v6.18.44`. At line 461:
`mt7628_pwm_data.pwm45_fixup = true`. Bug present since MT7628 support
landed (2018).

### Step 6.2: Backport complications
**Record:** Clean one-line apply expected. File structure matches
mainline patch context (`chanreg_base`/`chanreg_width` layout). No
`clksel_fixup` in this tree — irrelevant to this patch.

### Step 6.3: Related fixes already present?
**Record:** No. `git merge-base --is-ancestor 88c6c956fa310 HEAD` → fix
**not** in tree. No `clksel_fixup` either.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/pwm/` — IMPORTANT, driver-specific (MediaTek MT7628
MIPS router/IoT SoC).

### Step 7.2: Activity
**Record:** Driver actively maintained; MT7628 fixes landed in 7.2 cycle
on linux-next.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of MT7628/MT7688 boards using PWM channel 3 via `pwm-
mediatek` driver. Platform-specific, config-dependent.

### Step 8.2: Trigger conditions
**Record:** Probe `mediatek,mt7628-pwm` and configure PWM index 3. Not
security-relevant; unprivileged users can affect PWM via sysfs if
exported.

### Step 8.3: Failure severity
**Record:** Incorrect PWM waveform on channel 3 — functional hardware
malfunction. **Severity: MEDIUM** (not crash/corruption/security;
channels 0–2 unaffected).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — restores correct PWM3 register programming on a
  widely deployed router SoC.
- **Risk:** VERY LOW — one boolean, MT7628-only, channels >2 only.
- **Ratio:** Favorable; classic hardware-quirk fix.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real, long-standing hardware bug (since 2018)
- Hardware quirk/workaround category (explicit stable exception)
- One-line, obviously correct per programming guide
- Same mechanism as MT7623 `pwm45_fixup` fix (which was stable-
  nominated)
- Bug exists in 6.18.44; patch applies cleanly
- PWM maintainer merged it

**AGAINST backport:**
- No crash/corruption/security impact
- Only PWM channel 3 on one SoC family
- No in-tree DT board using `mediatek,mt7628-pwm`
- Companion patch 2/2 fixes separate clock issue for all channels
- No formal Mediatek maintainer review or user bug report

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (documentation-based,
   maintainer-merged; no runtime Tested-by)
2. Fixes real bug affecting users? **PASS** (PWM3 broken on MT7628 when
   used)
3. Important issue? **PASS** (hardware malfunction; quirk-class fix, not
   crash-level)
4. Small and contained? **PASS** (1 line, 1 file)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS**

### Step 9.3: Exception category
**Record:** Hardware quirk/workaround — correcting wrong SoC-specific
register-layout flag.

### Step 9.4: Decision rationale
This is a longstanding MT7628 driver bug: channel 3 was programmed with
MT7623-specific register offsets. The fix is minimal, obviously correct,
and matches the documented hardware layout. It does not crash the
kernel, but it is the same class of hardware-specific correction that
stable trees routinely take (mirroring the original MT7623 `pwm45_fixup`
stable nomination). For 6.18.44, the buggy code is present and the patch
applies cleanly as a standalone fix.

---

## Verification

- [Phase 1] Parsed commit `88c6c956fa310`: tags listed; no syzbot/Fixes
- [Phase 2] Diff: 1-line change to `mt7628_pwm_data.pwm45_fixup`
- [Phase 2] Read `pwm_mediatek_config()`/`get_state()`: `pwm45_fixup &&
  hwpwm > 2` logic at lines 212–218, 273–279
- [Phase 3] `git describe HEAD` → `v6.18.44`; Makefile 6.18.44
- [Phase 3] `git show 8cdc43afbb2cb`: MT7628 added with `pwm45_fixup =
  true` (2018)
- [Phase 3] `git show 360cc036563db`: MT7623 `pwm45_fixup` introduced
  with `Cc: stable`
- [Phase 3] `git merge-base --is-ancestor 88c6c956fa310 HEAD` → fix NOT
  in tree
- [Phase 3] Verified buggy flag at v6.18, v6.12, v5.10, v5.15 tags
- [Phase 4] `b4 dig -c 88c6c956fa310`: lore URL found; v1 only
- [Phase 4] `b4 dig -w`: CC list includes PWM maintainer, Mediatek lists
- [Phase 4] Mbox thread: 2-patch series; Uwe applied both; no stable Cc
- [Phase 5] Call chain: `.apply` → `pwm_mediatek_config()` uses
  `pwm45_fixup`
- [Phase 6] Buggy code confirmed at `drivers/pwm/pwm-mediatek.c:461`
- [Phase 6] `clksel_fixup` absent in tree (patch 2/2 not present)
- [Phase 6] No in-tree DTS using `mediatek,mt7628-pwm` (grep in
  `arch/mips/boot/dts`)
- [Phase 6] DT binding lists `mediatek,mt7628-pwm` in
  `Documentation/devicetree/bindings/pwm/mediatek,mt2712-pwm.yaml`
- [Phase 8] Impact: PWM3 register misprogramming; channels 0–2
  unaffected; severity MEDIUM

**YES**The branch search finished. On `linux-next`/`master`, the fix is
commit `88c6c956fa310` (“pwm: mediatek: set mt7628 pwm45_fixup flag to
false”), merged via `pwm/for-7.2-rc1`. It is not in the current 6.18.44
stable checkout; that tree still has the buggy `pwm45_fixup = true` for
MT7628.

The analysis stands: this is a one-line hardware quirk fix for PWM
channel 3 on MT7628, and it should be backported to this tree.

**YES**

 drivers/pwm/pwm-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-mediatek.c b/drivers/pwm/pwm-mediatek.c
index 4291072a13a7f..e87feda2e7831 100644
--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -458,7 +458,7 @@ static const struct pwm_mediatek_of_data mt7623_pwm_data = {
 
 static const struct pwm_mediatek_of_data mt7628_pwm_data = {
 	.num_pwms = 4,
-	.pwm45_fixup = true,
+	.pwm45_fixup = false,
 	.chanreg_base = 0x10,
 	.chanreg_width = 0x40,
 };
-- 
2.53.0

