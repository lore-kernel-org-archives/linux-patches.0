Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FD042586B;
	Mon, 31 Aug 2026 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183207; cv=none; b=oN6Cv8oFtxUiifBRIybRUyrqM4VIYam2VjKZECA0Hc3IUuYwls66XvvFg1iqwpAZJRxX6c0Ddh3zvmGePS7nDJfAc8KOIG3hnhRwUvDRx9L7obnBO79RVxLlRJadSFPftigkJS8ld97aGsLmvL3TBRSoBpckVDWzxKfLi34iuvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183207; c=relaxed/simple;
	bh=rr1d2pXLvPvjEEcE7c+vtL+KiFF1NErrBkD6EvNezQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JHHLWoflhk6ymm0PdsNu+AwrYA/Urs96Z8ztgpdd+Vs1Lv7jh7gvyFf2VXjofj2SfO9Axq095rzXmIWj+Vt9SfUKVNG9hxaM0bNGlO4iu19CJN6490IwjgSsG4kY3MoVvwG/vR35kZXYrxrFC6LPUw+vjMwkNwyPytkv7/SN2RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7T8jU4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7T8jU4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56271F000E9;
	Mon, 31 Aug 2026 13:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183205;
	bh=24qskOLMHdbuDhDDof6GItzrhBGwpozkNaF8Tm7nG/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7T8jU4ZK0j3CQ5mIiZmQNOEH1HU6mcXOLIbiI+Fszt2K8XoSk3TmfRJNGLfbDki8
	 gvkjtS/1Pvn6xTw2yi9yX6okH5aF1MVamJ6E1fGBfea0V+PNIlWP3wDkIL6/9633Oz
	 KnOzGVjJDjZh84TOE5u55cntXJhhp6yEqSSnQeWXaYlxTHehW2MB+oa+bL0AGE4miH
	 YxKjsuEqK4s/du4K2i+S7CBC6ChrtgPru+uVKKkTWELalRF2GIrTaDemyh8V6pxsbZ
	 us7bDLEy/NIIoG42zBXzjkMGjxBZ+3u5ZjU98Jq0jZ3Qx4WUUJVyrV3JaUWxlyrwX2
	 HS77YndWrrAsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Andreas Westman Dorcsak <hedmoo@yahoo.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ARM: tegra: tf600t: Invert accelerometer calibration matrix
Date: Mon, 31 Aug 2026 09:20:34 -0400
Message-ID: <20260831133314.4125787-6-sashal@kernel.org>
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 774bc2764647cfd6b65727cfa978d809f11df392 ]

IMU calibration matrix used in the device tree is inverted when testing on
the device which results in wrong screen orientation. Invert it to match
the matrix dumped from the device.

Tested-by: Andreas Westman Dorcsak <hedmoo@yahoo.com>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ARM: tegra: tf600t: Invert accelerometer
calibration matrix

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
Makefile `VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`)

**Commit under review:** `774bc2764647c` (mainline; **not** present in
this 6.18.y checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[ARM: tegra: tf600t]` `[Invert]` `[accelerometer
calibration matrix in device tree]`

Subsystem: ARM Tegra device tree for ASUS TF600T. Action: correct an
inverted IMU `mount-matrix`.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
| Tag | Value |
|-----|-------|
| Tested-by | Andreas Westman Dorcsak \<hedmoo@yahoo.com\> |
| Signed-off-by | Svyatoslav Ryhel \<clamor95@gmail.com\> (author) |
| Signed-off-by | Thierry Reding \<treding@nvidia.com\> (Tegra
maintainer) |
| Fixes: | absent (expected) |
| Reported-by: | absent |
| Cc: stable@vger.kernel.org | absent (expected, not a negative signal)
|
| Link: | absent |

Notable: hardware-tested on the actual device; maintainer sign-off from
Thierry Reding.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** IMU `mount-matrix` in `tegra30-asus-tf600t.dts` is inverted
  relative to values read from the physical device.
- **Symptom:** Wrong screen orientation (auto-rotation does not match
  physical tablet orientation).
- **Root cause:** Incorrect device-tree sensor orientation matrix for
  the MPU6050 IMU node.
- **Version info:** None stated; fix targets board support introduced in
  `8ae70af2477b7`.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised as cleanup. This is an explicit device-tree
hardware-description correction. It is a functional bug fix (wrong
sensor axis mapping), not a refactor or style change.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts` (+3 / −3
  lines)
- **Node:** `imu@69` (compatible `"invensense,mpu6050"`)
- **Functions:** N/A (device tree only)
- **Scope:** Single-file, surgical, device-specific DT fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| IMU `mount-matrix` | `[[0,-1,0],[-1,0,0],[0,0,-1]]` |
`[[0,1,0],[1,0,0],[0,0,1]]` |

The magnetometer child node (`ak8975`) `mount-matrix` is **unchanged**
(still the old values). Only the MPU6050 accelerometer/gyro orientation
is corrected. The IIO driver reads this matrix at probe via
`iio_read_mount_matrix()` and exposes corrected axis data to
userspace/kernel consumers that drive display rotation.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Hardware description / DT correctness fix (incorrect
  `mount-matrix`)
- **Mechanism:** Inverted axis transformation causes accelerometer
  readings to be mapped to the wrong physical axes; consumers
  interpreting gravity vector for screen rotation get incorrect
  orientation.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is minimal and obviously correct for the stated hardware
  measurement.
- Zero impact on any other board (property change is inside TF600T DTS
  only).
- Regression risk: **very low** — affects only TF600T IMU node.
- Matrix values are a sign flip on all three diagonal elements,
  consistent with a 180°/axis-inversion correction.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- Buggy `mount-matrix` introduced in `8ae70af2477b7` by Svyatoslav Ryhel
  (2025-06-17, committed 2025-07-09).
- Subject: "ARM: tegra: Add device-tree for ASUS VivoTab RT TF600T"
- Present in this 6.18.y tree at lines 1043–1045 (verified via `git
  blame` and file read).

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- **6.18.y history** for this file: only `8ae70af2477b7` (initial TF600T
  DTS).
- **master history** additionally has panel/backlight/connector commits
  not in 6.18.y:
  - `2ecff0cda80b9` Configure panel
  - `d9c890d753034` Drop backlight regulator
  - `774bc2764647c` Invert accelerometer calibration matrix (this
    commit)
- This specific fix is **standalone** (patch 9/9 of a series on lore,
  but functionally independent — only touches IMU matrix).

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Svyatoslav Ryhel is an active Tegra DTS contributor (TF600T,
SL101, Transformer, etc.). Thierry Reding (maintainer) committed both
the original DTS and this fix.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No code dependencies. The MPU6050 driver and TF600T DTS
already exist in 6.18.y. Fix applies cleanly (`git apply --check`
passed). **Standalone: yes.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- `b4 dig -c 774bc2764647c` found: [PATCH v1 9/9] ARM: tegra: tf600t:
  Invert accelerometer calibration matrix
- URL:
  https://patch.msgid.link/20260511074859.24930-10-clamor95@gmail.com
- Also matched earlier v1 series from 2026-04-06 (same patch 9/9).
- WebFetch of lore URL blocked by Anubis bot protection — could not read
  thread replies.
- **UNVERIFIED:** Whether reviewers explicitly nominated `Cc: stable` in
  thread replies.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** (`b4 dig -w`) CC'd: Rob Herring, Krzysztof Kozlowski, Conor
Dooley (DT maintainers), Thierry Reding, Jonathan Hunter, devicetree@,
linux-tegra@, linux-kernel@. Appropriate subsystem coverage.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report links. Testing evidence is `Tested-
by:` on actual TF600T hardware.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Part of a 9-patch TF600T series on lore; other patches
address panel/backlight/connector. This matrix fix does not depend on
them.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** **UNVERIFIED** — did not search lore stable list (no
indication of prior stable discussion found via b4).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** Device-tree property only. Runtime handling is in IIO
drivers (`iio_read_mount_matrix()` used by ST magnetometer, BMC150,
etc.; MPU6050 uses same binding per
`Documentation/devicetree/bindings/iio/imu/invensense,mpu6050.yaml`).

### Step 5.2: TRACE CALLERS
**Record:** `mount-matrix` is read at IMU driver probe. Accelerometer
data feeds userspace (e.g., `iio-sensor-proxy`, compositors) and kernel
display-rotation logic. Affects normal runtime sensor path on TF600T
when `CONFIG_INV_MPU6050_IIO` (or equivalent) is enabled.

### Step 5.3: TRACE CALLEES
**Record:** IIO core reads DT `mount-matrix` property and applies
transformation to raw sensor readings before exposing channels.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Boot → DT probe of `imu@69` → MPU6050 driver reads `mount-
matrix` → accelerometer channel data transformed → userspace/kernel
reads orientation → display rotation. **Reachable during normal tablet
use** (not an obscure error path).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Other boards in-tree use `mount-matrix` for orientation
(e.g., PinePhone, various ST sensors). Incorrect matrices are a known
class of DT bugs; magnetometer on the same TF600T node still has the old
matrix (intentionally left unchanged per this commit).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE (6.18.y)

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** Current 6.18.44 tree has the buggy matrix at lines
1043–1045. `git merge-base --is-ancestor 8ae70af2477b7 HEAD` → TF600T
DTS is in tree. `git merge-base --is-ancestor 774bc2764647c HEAD` →
**fix is NOT in tree.**

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** `git apply --check` on formatted
patch succeeded. Line numbers differ slightly from mainline diff (1074
vs 1091) due to fewer upstream commits in stable file, but merge is
trivial.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No alternate fix for this issue found in 6.18.y history.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Subsystem:** ARM device tree / Tegra platform / IIO sensor
orientation. **Criticality:** PERIPHERAL — affects only ASUS VivoTab RT
TF600T (Tegra30 tablet, niche but real hardware).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** TF600T support is new (added 6.17 cycle, present in 6.18.y).
Active development on mainline with follow-up TF600T patches not yet in
stable.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Platform-specific** — users running Linux on ASUS TF600T
with kernel 6.18.y. No impact on any other hardware.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Trigger is **every boot / every sensor read** on TF600T when
display auto-rotation is used. Common for tablet use. Not security-
relevant; unprivileged users cannot trigger kernel crashes via this bug.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- **Failure mode:** Incorrect screen orientation / auto-rotation.
- **Severity:** **LOW to MEDIUM** — functional/interactivity issue, not
  crash, corruption, deadlock, or security. Annoying and breaks expected
  tablet behavior, but system remains stable.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Corrects broken auto-rotation for TF600T users on 6.18.y;
  completes board support already shipped in stable.
- **Risk:** Minimal — 3-line DT change scoped to one device node on one
  board.
- **Ratio:** High benefit-to-risk for TF600T users; near-zero risk for
  everyone else.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real, hardware-verified bug (wrong screen orientation)
- Buggy code is present in 6.18.y (board support was merged with
  incorrect matrix)
- Trivial, device-specific DT fix; applies cleanly
- Tegra maintainer signed off; Tested-by on hardware
- Matches stable exception: DT fix for incorrect hardware description
- Per `stable-kernel-rules.rst`: fixes "a real bug that bothers people"
  on supported hardware

**AGAINST backporting:**
- Low severity (orientation wrong, not crash/corruption/security)
- Extremely niche hardware (2012-era Windows RT tablet)
- No syzbot/fuzzer report, no widespread user reports
- Other TF600T improvements remain mainline-only (panel, backlight) —
  stable already ships partial board support

**UNRESOLVED:**
- Whether lore reviewers explicitly requested `Cc: stable` (WebFetch
  blocked)
- Whether any distribution kernel maintainer has reported this to stable

### Step 9.2: APPLY THE STABLE RULES CHECKLIST

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — Tested-by on device;
maintainer ack; values match hardware dump |
| 2. Fixes a real bug affecting users? | **PASS** — wrong screen
orientation on TF600T |
| 3. Important issue? | **PASS (borderline)** — interactivity/functional
bug on supported hardware, not crash-level; qualifies as hardware-
description correction per stable DT guidance |
| 4. Small and contained? | **PASS** — 3 lines, 1 file |
| 5. No new features or APIs? | **PASS** — DT property value correction
only |
| 6. Can apply to local tree? | **PASS** — verified clean apply |

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** **Device tree update for existing hardware** — corrects
incorrect `mount-matrix` for a board whose DTS is already in 6.18.y.

### Step 9.4: DECISION RATIONALE

This 6.18.y tree already ships TF600T device-tree support
(`8ae70af2477b7`) with an incorrect accelerometer orientation matrix.
Users of this specific tablet on 6.18.x get broken auto-rotation. The
fix is as low-risk as stable backports get: three lines in a board-
specific DTS, hardware-tested, maintainer-approved, and applies cleanly.
While severity is low compared to crashes or security issues, stable
rules explicitly accept DT hardware-description fixes and "real bugs
that bother people" on supported platforms. Shipping board support
without this correction leaves a known, verified functional defect in
the stable tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `git show
  774bc2764647c`
- **[Phase 2]** Diff analysis: 3 lines changed in `imu@69` `mount-
  matrix`; magnetometer matrix unchanged
- **[Phase 3]** `git blame`: buggy lines from `8ae70af2477b7`
  (2025-07-09)
- **[Phase 3]** `git log stable/linux-6.18.y -- tegra30-asus-
  tf600t.dts`: only intro commit in stable
- **[Phase 3]** `git log master -- tegra30-asus-tf600t.dts`: fix + 3
  other TF600T commits not in stable
- **[Phase 3]** `git merge-base --is-ancestor`: DTS in 6.18.y, fix NOT
  in 6.18.y
- **[Phase 4]** `b4 dig -c 774bc2764647c`: found lore URL
- **[Phase 4]** `b4 dig -w`: DT and Tegra maintainers CC'd
- **[Phase 4]** `b4 dig -a`: v1 series, patch 9/9
- **[Phase 4]** WebFetch lore URL: blocked (Anubis) — stable nomination
  in thread UNVERIFIED
- **[Phase 5]** Read current DTS at lines 1043–1064; confirmed buggy IMU
  matrix present
- **[Phase 5]** Grep: `mount-matrix` binding documented in
  `invensense,mpu6050.yaml`
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** `git apply --check` on formatted patch: clean apply
- **[Phase 6]** Read file: confirmed buggy code exists at lines
  1043–1045
- **[Phase 7]** Read `Documentation/process/stable-kernel-rules.rst`:
  DT/hardware-description fixes qualify
- **[Phase 8]** Assessed severity: functional orientation bug, LOW-
  MEDIUM, platform-specific

**YES**

 arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts b/arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts
index 5d9e23a438204..856b1bb8b6f37 100644
--- a/arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts
+++ b/arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts
@@ -1040,9 +1040,9 @@ imu@69 {
 			vdd-supply   = <&vdd_3v3_sys>;
 			vddio-supply = <&vdd_1v8_vio>;
 
-			mount-matrix =	 "0", "-1",  "0",
-					"-1",  "0",  "0",
-					 "0",  "0", "-1";
+			mount-matrix =	 "0",  "1",  "0",
+					 "1",  "0",  "0",
+					 "0",  "0",  "1";
 
 			/* External I2C interface */
 			i2c-gate {
-- 
2.53.0

