Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE385419AA;
	Mon, 31 Aug 2026 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183959; cv=none; b=KONKi6RtsI6u7AqVZBJ6qTFTqbcJwDDRw6DSNHcKsvK3hQfQO7yeSwIkqjZa3RXYB1K/dBGKPTDJhCdcV6NiRCmvEphRdG0e+YP3nlezWh0K1+++ZwwYWO9D+uYqDX+ZAz+Dp3azy38lerDzIy7JANhw2trpbfdtrbYRdfGumYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183959; c=relaxed/simple;
	bh=zbywMqE66HVsRAx54iF4I8/X8Nz8MgXYoJInsctGmXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dU83Twzl8pWuMX1s+dlgLEnTBotWeBSeI1+13xs7+teQKRnZTrJOVhQYCHh4c1jdPEm7OEit+tPvoUehs9o5uxj3dpu4n+hWjKwyX+ekiL8KC7jjlg1ert6yIEX0lD3ZAw2PCJ0qw7+zYbXcjLxfyHn9TdHGiOBQkS7mxCha7CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtNBZgCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtNBZgCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0609C1F000E9;
	Mon, 31 Aug 2026 13:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183956;
	bh=GZJQ16v06Yi0FO07Nrm2/I1nwA5R9x34h9AS1PcYTVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtNBZgCRWGB3bzGwWJfbYL60yw8ZyGd/C8xboA7eTElN3zHwyzjZb7pLtCSRvwqHg
	 S87XjrmkYaIBl7KSp4DSx9lF5tksd2flikYmoIm49obkqJCRqHVbMQ9+y7hxqtpUTK
	 MXAA6og/GDjRqWMy5493WieVw+BhLU4/zu1dkY4V5L4yLCMZamGylVwVZKTYEpl/OT
	 S6xcngFs2E+JSBKrMbshLDGTzQE7DB0bJ8rcV2COqjTYZP7xpYaqy/N5X2r2pBagoU
	 JAAhI8rJJBVbDjA0H1QGT8xc6sVcExdPxhhkNWUMNXKiY71rPwTdwrXtfEMG5mWhD6
	 KoacA7AV3eP5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Baojun Xu <baojun.xu@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	sen@ti.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: tas2781: Update default register address to TAS2563
Date: Mon, 31 Aug 2026 09:27:11 -0400
Message-ID: <20260831133314.4125787-403-sashal@kernel.org>
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

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 64184f07e7516eb3ac1839387eb7cbe2dbeaa96f ]

The previous TAS2781 address is overwritten during calibration,
so switching to the TAS2563 address is required.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20260625102815.20043-1-baojun.xu@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ASoC: tas2781: Update default register
address to TAS2563

**Local tree:** `v6.18.44` (`6.18.44`, commit `2736c32da98b9`)
**Upstream commit:** `64184f07e7516` (mainline, merged Jun 25, 2026)
**Stable candidate:** `43c6afb999d7e` (on `autosel` branch, not yet in
HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ASoC: tas2781]` `[Update]` — Change default XM calibration
register addresses from TAS2781 book/page to TAS2563 book/page.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Baojun Xu `<baojun.xu@ti.com>` (TI, driver author)
- **Link:**
  https://patch.msgid.link/20260625102815.20043-1-baojun.xu@ti.com
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org,
  Acked-by:
- **Notable:** Maintainer applied with no objections; no syzbot or user
  bug reports cited.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Default `TASDEVICE_XM_A1_REG` / `TASDEVICE_XM_A2_REG` point
  to TAS2781 page `0x63`, which is overwritten during speaker
  calibration.
- **Symptom:** ALSA controls `"Amp XMA1 Data"` and `"Amp XMA2 Data"`
  read from wrong registers and return incorrect calibration data.
- **Root cause:** Hardware/firmware overwrites the TAS2781-specific page
  during calibration; TAS2563 page `0x02` holds the persistent XM data.
- **Version info:** None stated; addresses introduced with calibration
  kcontrols in Sep 2024.

### Step 1.4: Hidden Bug Fix
**Record:** Yes. Wording is "update address," but this is a functional
calibration correctness fix — wrong register map causes bad data reads,
not a cosmetic change.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `include/sound/tas2781.h` only (+2 / -2 lines)
- **Functions affected indirectly:** `tasdev_XMA1_data_get()`,
  `tasdev_XMA2_data_get()` in `sound/soc/codecs/tas2781-i2c.c`
- **Scope:** Single-file, surgical header fix

| Macro | Before | After |
|-------|--------|-------|
| `TASDEVICE_XM_A1_REG` | `TASDEVICE_REG(0x64, 0x63, 0x3c)` |
`TASDEVICE_REG(0x64, 0x02, 0x4c)` |
| `TASDEVICE_XM_A2_REG` | `TASDEVICE_REG(0x64, 0x63, 0x38)` |
`TASDEVICE_REG(0x64, 0x02, 0x64)` |

New addresses share book `0x64`, page `0x02` with existing
`TAS2563_RUNTIME_RE_REG` (`0x48`) and `TAS2563_RUNTIME_RE_REG_TF`
(`0x70`).

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `tasdev_XMA1_data_get()` / `tasdev_XMA2_data_get()`
  default to page `0x63` when `dspbin_typ == 0`; firmware-provided
  addresses used when `dspbin_typ != 0`.
- **After:** Same logic, but defaults point to page `0x02` (TAS2563
  calibration page).
- **Path:** ALSA kcontrol read → `calib_data_get()` →
  `tasdevice_dev_bulk_read()` at corrected register.

### Step 2.3: Bug Mechanism
**Record:** **Category (g): Logic / correctness fix** — wrong hardware
register map. **Category (h): Hardware workaround** — TAS2781 page
overwritten during calibration; driver must use TAS2563 addresses for
persistent XM data.

### Step 2.4: Fix Quality
**Record:** Obviously correct and minimal. New addresses align with
other TAS2563 calibration registers already in the same header. Very low
regression risk; only changes fallback addresses when firmware does not
override them.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Wrong addresses introduced in `49e2e353fb0db` ("ASoC:
tas2781: Add Calibration Kcontrols for Chromebook", Sep 12, 2024).
Present in this tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related Commits
**Record:**
- `fcc3d77fef02c` — already backported to this tree: wrong SINEGAIN2
  register in calibration path (same class of fix)
- `cf86e0ae60a22` — calibration failure fix (register unlock)
- `2aa13da97e2b9` — calibration stress-test fix
- `791520a8e54e2` — wrong period fix
- Standalone; not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Baojun Xu is a regular TI contributor to tas2781 (chip ID
fixes, DT updates, HDA quirks). Mark Brown is ASoC maintainer.

### Step 3.5: Dependencies
**Record:** None. Self-contained 2-line header change; no prerequisite
commits.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260625102815.20043-1-baojun.xu@ti.com
- **Revisions:** v1 only
- **Review:** Mark Brown applied to `for-7.2` with no NAKs or change
  requests
- **Stable nomination:** None in thread

### Step 4.2: Reviewers
**Record:** CC'd: broonie@kernel.org, tiwai@suse.de, alsa-devel, linux-
sound, shenghao-ding@ti.com, other TI engineers.

### Step 4.3: Bug Reports
**Record:** No external bug report, syzbot, or Bugzilla link. Issue
identified internally by TI based on hardware behavior.

### Step 4.4: Series Context
**Record:** Standalone 1/1 patch; no series dependencies.

### Step 4.5: Stable List History
**Record:** Not searched on lore stable list (Anubis blocked web fetch).
Precedent in this tree: `fcc3d77fef02c` (tas2781 calibration register
fix) already backported.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `tasdev_XMA1_data_get()`, `tasdev_XMA2_data_get()`,
`calib_data_get()`

### Step 5.2: Callers
**Record:** Registered in `tasdevice_cali_controls[]` (lines 925–926),
added for all chip types via `tasdevice_create_cali_ctrls()`. Invoked
from userspace ALSA control reads (e.g. Chromebook calibration tooling).

### Step 5.3: Callees
**Record:** `calib_data_get()` → `tasdevice_dev_bulk_read()` — 4-byte
register read under `codec_lock`.

### Step 5.4: Reachability
**Record:** Reachable from userspace via ALSA mixer/control interface.
Affects calibration data reads, not normal audio playback. Triggered
when userspace reads `"Amp XMA1 Data"` / `"Amp XMA2 Data"` and
`dspbin_typ == 0`.

### Step 5.5: Similar Patterns
**Record:** `tasdev_tf_data_get()` and `tasdev_re_data_get()` already
use `TAS2563_RUNTIME_RE_REG*` on page `0x02` for non-TAS2781 chips. This
fix brings XM defaults in line with that established mapping.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `include/sound/tas2781.h` lines 62–64 still have
page `0x63` addresses. Upstream fix `64184f07e7516` is not in HEAD (`git
merge-base --is-ancestor` returns exit 1).

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git cherry-pick --no-commit 43c6afb999d7e`
succeeds with exit 0 on HEAD.

### Step 6.3: Related Fixes Already Present?
**Record:** `fcc3d77fef02c` (SINEGAIN2 calibration register fix) is
already in this tree. This XM address fix is not yet present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **IMPORTANT** — ASoC tas2781 driver; affects Chromebook
speaker calibration on TI TAS25xx/TAS27xx/TAS58xx hardware.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; multiple calibration fixes in
2024–2026, including several already deemed stable-worthy.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Chromebook / embedded systems using tas2781 codec with
calibration kcontrols. Config-dependent (`CONFIG_SND_SOC_TAS2781_I2C` or
equivalent). Not universal.

### Step 8.2: Trigger Conditions
**Record:**
- Userspace reads XMA1/XMA2 calibration controls
- `dspbin_typ == 0` (no firmware binary override)
- Especially after calibration has run (when page `0x63` is overwritten)
- Unprivileged users can trigger via ALSA control reads

### Step 8.3: Failure Mode Severity
**Record:** **Incorrect calibration data returned** — not a crash, oops,
or data corruption. Severity: **MEDIUM**. Impacts speaker impedance
calibration accuracy and factory/service tooling.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM — correct calibration data for real hardware users
- **Risk:** VERY LOW — 2-line constant change, maintainer-reviewed,
  consistent with existing TAS2563 register map
- **Ratio:** Favorable; same rationale as `fcc3d77fef02c` already
  accepted in this tree

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verified hardware mapping bug (TI author + maintainer)
- Already in mainline (`64184f07e7516`)
- Tiny, surgical, applies cleanly to 6.18.44
- Same fix class as `fcc3d77fef02c` already backported here
- Hardware quirk / register-map correction per stable-kernel-rules.rst
- Affects userspace-reachable calibration path on shipping hardware

**AGAINST backport:**
- No crash, security issue, or data corruption
- Only affects calibration controls, not normal audio
- Only default path (`dspbin_typ == 0`); firmware override unaffected
- Niche hardware (Chromebooks with TI amps)
- No user bug report or syzbot finding

**Unresolved:** No independent user-reported failure case beyond TI's
hardware analysis.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — maintainer applied;
   addresses align with existing TAS2563 map
2. Fixes real bug affecting users? **PASS** — wrong calibration data on
   real hardware
3. Important issue? **PASS (MEDIUM)** — hardware quirk / calibration
   correctness; not crash-level but real functional impact
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features or APIs? **PASS** — register constant correction only
6. Can apply to local tree? **PASS** — clean cherry-pick verified

### Step 9.3: Exception Category
**Record:** **Hardware quirk / workaround** — correcting register
addresses for hardware that overwrites TAS2781 page during calibration.

### Step 9.4: Decision Rationale

This fix corrects wrong default register addresses for speaker
calibration data reads on TI amplifier chips used in Chromebooks. While
it does not cause crashes, it is a real hardware-mapping bug in a
userspace-reachable calibration path. The change is minimal, maintainer-
reviewed, already in mainline, applies cleanly to 6.18.44, and matches
the same class of fix (`fcc3d77fef02c`) already backported to this tree.
Per `stable-kernel-rules.rst`, hardware quirks that fix real-world
device issues are appropriate for stable.

---

## Verification

- **[Phase 1]** Parsed commit message from `git show 43c6afb999d7e` and
  upstream `64184f07e7516`
- **[Phase 1]** Tags: Baojun Xu SOB, Mark Brown SOB, Link tag; no
  Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: 2 lines in `include/sound/tas2781.h`; verified
  current values at lines 62–64
- **[Phase 2]** Computed register values: old A1=`0x3231bc`, new
  A1=`0x32014c` (same page as `TAS2563_RUNTIME_RE_REG`=`0x320148`)
- **[Phase 3]** `git blame`: addresses from `49e2e353fb0db` (Sep 2024)
- **[Phase 3]** `git merge-base --is-ancestor 49e2e353fb0dbe HEAD`:
  calibration commit is ancestor
- **[Phase 3]** `git merge-base --is-ancestor 43c6afb999d7e HEAD`: exit
  1 — fix NOT in HEAD
- **[Phase 3]** Related: `fcc3d77fef02c` already in tree (SINEGAIN2
  calibration fix)
- **[Phase 4]** `b4 dig -c 43c6afb999d7e`: found thread at
  patch.msgid.link/20260625102815
- **[Phase 4]** `b4 dig -a`: v1 only
- **[Phase 4]** `b4 dig -w`: CC'd broonie, tiwai, alsa-devel, linux-
  sound
- **[Phase 4]** Downloaded mbox: Mark Brown applied with no objections
- **[Phase 5]** `grep`: `tasdev_XMA1_data_get`/`tasdev_XMA2_data_get`
  use macros as defaults; override when `dspbin_typ`
- **[Phase 5]** `tasdevice_cali_controls[]` registered for all chip
  types in `tasdevice_create_cali_ctrls()`
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Buggy code confirmed present at
  `include/sound/tas2781.h:62-64`
- **[Phase 6]** `git cherry-pick --no-commit 43c6afb999d7e`: exit 0
  (clean apply)
- **[Phase 8]** Failure mode: wrong calibration data, severity MEDIUM
  (not crash)

**YES****ASoC: tas2781: Update default register address to TAS2563** —
verdict for **6.18.44**: **YES**.

The default XM calibration register addresses in
`include/sound/tas2781.h` point at a TAS2781 page that gets overwritten
during calibration, so `"Amp XMA1 Data"` / `"Amp XMA2 Data"` can return
wrong values when firmware doesn’t override them. The fix is a 2-line
header change to the TAS2563 addresses (same page as other calibration
regs), already in mainline, applies cleanly here, and matches the kind
of tas2781 calibration fix already backported in this tree
(`fcc3d77fef02c`).

 include/sound/tas2781.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/tas2781.h b/include/sound/tas2781.h
index 29d15ba65f04d..648fb55073282 100644
--- a/include/sound/tas2781.h
+++ b/include/sound/tas2781.h
@@ -59,9 +59,9 @@
 #define TASDEVICE_CHECKSUM_REG		TASDEVICE_REG(0x0, 0x0, 0x7e)
 
 /* XM_340 */
-#define	TASDEVICE_XM_A1_REG	TASDEVICE_REG(0x64, 0x63, 0x3c)
+#define	TASDEVICE_XM_A1_REG	TASDEVICE_REG(0x64, 0x02, 0x4c)
 /* XM_341 */
-#define	TASDEVICE_XM_A2_REG	TASDEVICE_REG(0x64, 0x63, 0x38)
+#define	TASDEVICE_XM_A2_REG	TASDEVICE_REG(0x64, 0x02, 0x64)
 
 /* Volume control */
 #define TAS2563_DVC_LVL			TASDEVICE_REG(0x00, 0x02, 0x0c)
-- 
2.53.0

