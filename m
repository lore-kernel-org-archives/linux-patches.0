Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A485452AE;
	Mon, 31 Aug 2026 13:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183974; cv=none; b=cOraDgHzw539TTo79KT1e9RWwv6b129KavyPaWyQmmyJ7W+Kwl/rOJ95gunX69U1KEJ5cMd5HYUB5gD7ybC6o8iLeL+0U2RXMZfoB/bWRuXlllgHNqXKIaLxNCP7Cz7GgzFXLxgGy6DB2NDppi1WqWW/h8BRgXYbFrau3yDUyqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183974; c=relaxed/simple;
	bh=0aE/oO2MPaQWqaJemDPF+AEzcS/C9vT3DePSBBX7y8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+TBdVWtbg0bVKBbRAPchdV7Zuy3qfs71FrUjFAOc0+sXII/8CoYK5hCEJ8bsVupIaVYD4BPHErtc9qcH65UnqddcvkOkVWYKNCq7wBuWBoI9svggRUheVQYjtnGJxvjowNShI+pT+85l7v3mKn98Ck1RI9rqogkTXhtqUVDhxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eOXAf6pM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eOXAf6pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D27A1F00ACF;
	Mon, 31 Aug 2026 13:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183970;
	bh=cN5TP4EZ603qWBDmqoSOqeM6CBwPnR8Wtb1a+BBdkDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOXAf6pMI/AIEL9Z2jZr66c/5cDO004lYN7etxj3Z3LsX/D2EiVNHGimXFCEgnRxV
	 uvcsXhKNbCxiuB0OnSp6o+AgBMDj5jK4CkGLUFhUxhrzHt3vI1N+dqYX8ChDyYA6Gn
	 8fHTxp0k2Y/7knxYPoK/EHsMsGv8dqY2xXgrcj3nqsd+xem4RCSuU5T06UgKCI2p2T
	 yT8xPiFrffLDWWTF/hhwzoIkRwSWyC7qFZHONSApNu46QAiFixdEQpfhTnecKTBETp
	 yj6/Z12B4pXIqnLcY9jpipMbFkAGlBP1Z2KZL6haKwEzIDEO2djYSSrsNWdNsdE0fq
	 P0BuM5UD7ObPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Downey <bdowne01@gmail.com>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	corbet@lwn.net,
	linux-hwmon@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] hwmon: (asus-ec-sensors) add ROG MAXIMUS Z790 EXTREME
Date: Mon, 31 Aug 2026 09:27:20 -0400
Message-ID: <20260831133314.4125787-412-sashal@kernel.org>
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

From: Brian Downey <bdowne01@gmail.com>

[ Upstream commit 5f6617089dc06f9941e8ca57ba64345c9f1ed9ed ]

Add support for ROG MAXIMUS Z790 EXTREME

Signed-off-by: Brian Downey <bdowne01@gmail.com>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260608060855.40469-1-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[hwmon: (asus-ec-sensors)] [add] [ROG MAXIMUS Z790 EXTREME
board support to existing EC sensors driver]`

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** `https://lore.kernel.org/r/20260608060855.40469-1-
  eugene.shalygin@gmail.com`
- **Cc: stable@vger.kernel.org** — not present (expected)
- **Signed-off-by:** Brian Downey, Eugene Shalygin, Guenter Roeck (hwmon
  maintainer)

Notable: no syzbot/sanitizer reports; maintainer (Guenter Roeck)
committed it.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug description:** None stated. Commit only says "Add support for
  ROG MAXIMUS Z790 EXTREME."
- **Symptom/failure mode:** Without this patch, `asus-ec-sensors` does
  not match this board's DMI name and does not expose EC-based hwmon
  sensors (T_Sensor, VRM, water-in/out, water-flow).
- **Version info:** None in message.
- **Root cause:** Board not listed in `dmi_table[]`;
  `sensors_family_intel_700[]` lacked water-sensor EC register mappings
  needed by this board.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not a hidden bug fix. This is explicit hardware enablement —
a DMI board table entry plus sensor-family data for a new motherboard.
No crash, leak, race, or corruption is described or implied.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- `Documentation/hwmon/asus_ec_sensors.rst`: +1 line (board list)
- `drivers/hwmon/asus-ec-sensors.c`: +15 lines
- **Functions modified:** None (only static data:
  `sensors_family_intel_700[]`, new `board_info_maximus_z790_extreme`,
  `dmi_table[]`)
- **Scope:** Single-file driver change + doc; surgical hardware-ID
  addition

### Step 2.2: CODE FLOW CHANGE
**Record:**
- **Hunk 1 (`sensors_family_intel_700[]`):** Before: intel 700 family
  had T_Sensor, T_Sensor 2, VRM, CPU_Opt only. After: adds Water_Flow,
  Water_In, Water_Out EC register mappings (same addresses as intel 600
  family).
- **Hunk 2 (`board_info_maximus_z790_extreme`):** New board config
  mirroring `board_info_maximus_z690_formula` but using
  `family_intel_700_series`.
- **Hunk 3 (`dmi_table[]`):** Adds DMI exact match for `"ROG MAXIMUS
  Z790 EXTREME"` → new board info.
- **Affected path:** `get_board_info()` → `dmi_first_match()` →
  `asus_ec_probe()` only when DMI matches this board.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Bug category:** None (hardware enablement / missing board ID)
- **Mechanism:** Driver probes via platform device; `get_board_info()`
  returns NULL for unknown boards → probe returns `-ENODEV`. This patch
  adds the missing board identifier and its sensor map.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is obviously correct: copies the established Z690 FORMULA pattern
  (same sensor set, same mutex path) onto intel 700 family.
- Minimal and surgical; no logic changes.
- **Regression risk:** Very low. Water sensor entries in
  `sensors_family_intel_700[]` are only used when a board's `.sensors`
  bitmask requests them. Existing intel-700 boards (`ROG STRIX Z790-E
  GAMING WIFI II`, `ROG STRIX Z790-I GAMING WIFI`) do not enable water
  sensors and are unaffected.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- `sensors_family_intel_700[]` introduced in `0183cb21b8a87`
  (2025-07-28, "Add ROG STRIX Z790E GAMING WIFI II"); water sensors were
  absent from the start.
- Commit `5f6617089dc06` (2026-06-08) adds Z790 EXTREME support.
- Intel 700 family and DMI infrastructure are present in this tree since
  v6.18 development.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present; step not applicable.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Similar board-add commits already in v6.18.44: `15c8317366908` (Z790-I
  GAMING WIFI), `0183cb21b8a87` (Z790E GAMING WIFI II), `34c61c198d06b`
  (Z690-E GAMING WIFI).
- Same author ecosystem (Eugene Shalygin as committer/reviewer on many
  board-add patches).
- Standalone single-patch series (v1 → v2 per `b4 dig -a`); no multi-
  patch dependency.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Eugene Shalygin is a regular `asus-ec-sensors` contributor
(many board-add patches). Brian Downey contributed the board data.
Guenter Roeck (hwmon maintainer) committed it.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:**
- Prerequisites present in v6.18.44: `asus-ec-sensors` driver,
  `family_intel_700_series`, `ASUS_HW_ACCESS_MUTEX_RMTW_ASMX`, DMI
  matching macros, water sensor enum/bit definitions.
- Commit is self-contained; no series dependencies.
- Cherry-pick to v6.18.44 applies cleanly (verified).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- `b4 dig -c 5f6617089dc06`: matched v2 at `https://patch.msgid.link/202
  60608060855.40469-1-eugene.shalygin@gmail.com`
- `b4 dig -a`: v1 (2026-06-07) and v2 (2026-06-08); committed version is
  latest (v2).
- Lore thread content could not be fetched (Anubis bot protection on
  patch.msgid.link). Stable nomination in thread: **unverified**.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** `b4 dig -w` recipients include Guenter Roeck (hwmon
maintainer), linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
Jonathan Corbet, Shuah Khan.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No bug report tags or syzbot links. This is a user/hardware
enablement request, not a crash report.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone 1-patch series (v1/v2). No companion fixes
required.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched (no stable Cc: tag, no bug report to anchor
search). Stable-specific discussion: **unverified**.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** No functions modified. Static data consumed by
`get_board_info()` and `asus_ec_probe()`.

### Step 5.2: TRACE CALLERS
**Record:**
- `get_board_info()` → called from `asus_ec_probe()` (line ~1256)
- `asus_ec_probe()` → registered as `.probe` in platform driver; reached
  from `asus_ec_init()` via `platform_create_bundle()`
- `module_init(asus_ec_init)` at driver load
- Context: module init / platform probe during boot; not a hot path

### Step 5.3: TRACE CALLEES
**Record:** `dmi_first_match(dmi_table)`, sensor setup via
`setup_sensor_data()`, `fill_ec_registers()`, hwmon device registration.
Uses existing EC read infrastructure and ACPI mutex locking.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Boot-time driver load → DMI match → hwmon sysfs sensors
exposed. Not directly syscall-triggered, but affects all users of this
motherboard who want temperature/fan monitoring via `asus-ec-sensors`.
Without match, driver silently does not bind (`-ENODEV`).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Identical pattern used for dozens of boards in this driver
(e.g., `board_info_maximus_z690_formula` with same sensor set on intel
600 family). Water sensor EC addresses match those in
`sensors_family_intel_600[]`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:**
- **Local tree:** `v6.18.44` (linux-6.18.y stable), `VERSION=6
  PATCHLEVEL=18 SUBLEVEL=44`
- **Missing board support exists:** `ROG MAXIMUS Z790 EXTREME` is absent
  from `dmi_table[]` and documentation in HEAD.
- Commit `5f6617089dc06` is **not** an ancestor of HEAD (`commit NOT in
  tree`).
- Driver `asus-ec-sensors` and `family_intel_700_series` **do** exist.
- `ROG MAXIMUS Z790 EXTREME` appears in `nct6775-platform.c` WMI list
  (partial/alternate monitoring path), but not in `asus-ec-sensors`.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Cherry-pick of `5f6617089dc06` onto v6.18.44 succeeds with
auto-merge, no conflicts. Expected apply: **clean**.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No equivalent Z790 EXTREME entry in `asus-ec-sensors`.
Related intel-700 Z790 boards (Z790-I, Z790E WIFI II) are already
supported. This specific board is the gap.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/hwmon/` — hardware monitoring. **Criticality:
PERIPHERAL** (affects specific ASUS motherboard owners, not core kernel
paths).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** `asus-ec-sensors` is actively maintained with frequent
board-add commits. v6.18.44 already includes multiple board-add patches
from the same series.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Platform-specific** — owners of ASUS ROG MAXIMUS Z790
EXTREME motherboards running `CONFIG_SENSORS_ASUS_EC`. No impact on
other hardware.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Triggered at boot when DMI reports `"ROG MAXIMUS Z790
EXTREME"` and `asus-ec-sensors` module loads. Common for affected
hardware owners. Not a security issue; not userspace-triggerable beyond
normal module loading.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** Without patch: EC-based hwmon sensors unavailable (no
T_Sensor header, VRM temp, water loop temps/flow via this driver).
System boots normally; monitoring gap only. **Severity: LOW** (missing
functionality, not crash/corruption/hang).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Enables hwmon for a real, shipping high-end motherboard
  on 6.18.y; matches established in-tree pattern.
- **Risk:** Very low — 16 lines of static data, no logic changes, no
  effect on existing boards.
- **Ratio:** Moderate benefit for a small user population vs. very low
  regression risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Explicitly permitted by `Documentation/process/stable-kernel-
  rules.rst`: *"must either fix a real bug … or just add a device ID"*
- DMI board table entry is the functional equivalent of a device ID for
  this driver
- Driver already exists in v6.18.44; only board ID + sensor map added
- Small (16 lines), applies cleanly, obviously correct
- Same pattern as board-add commits already present in this tree
  (Z790-I, Z690 FORMULA, etc.)
- Hwmon maintainer committed it
- No regression risk for existing configurations

**AGAINST backporting:**
- Not a bug fix (no crash, corruption, security, deadlock)
- Missing sensors is low-severity — system works without them
- Partial monitoring may exist via `nct6775` WMI path for this board
  name
- Adds sensor family entries beyond a pure one-line ID (though only used
  by the new board)
- No `Cc: stable` or user bug reports demonstrating urgency

**Unresolved:**
- Whether lore reviewers nominated for stable (thread inaccessible)
- Whether users rely exclusively on `asus-ec-sensors` vs. `nct6775` on
  this board

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mirrors Z690 FORMULA;
   maintainer committed; v1→v2 review cycle
2. Fixes a real bug affecting users? **PASS** (via device-ID exception)
   — not a crash bug, but missing board ID prevents hardware monitoring
   on a supported driver
3. Important issue (crash, security, corruption, deadlock)? **FAIL** for
   bug-fix criterion; **PASS** only under device-ID exception (low-
   severity enablement)
4. Small and contained? **PASS** — 16 lines, 2 files, static data only
5. No new features or APIs? **PASS** — no new APIs; board ID addition
   per stable rules exception
6. Can apply to local tree? **PASS** — cherry-pick verified clean on
   v6.18.44

### Step 9.3: EXCEPTION CATEGORIES
**Record:** Falls under **device ID addition** (DMI board identifier for
existing driver). Analogous to PCI/USB ID additions documented in stable
rules and review guidelines.

### Step 9.4: DECISION RATIONALE

For **linux-6.18.y (v6.18.44)**: the `asus-ec-sensors` driver, intel-700
sensor family, and DMI infrastructure are all present. The commit adds
only a missing board identifier and its sensor configuration — the exact
pattern already used for other Z790/Z690 boards in this stable series.
Per the tree's own stable rules, device-ID additions to existing drivers
are explicitly eligible for stable backport even when they are not crash
fixes.

The patch is minimal, applies cleanly, and cannot affect boards that do
not match the new DMI entry. The benefit is enabling EC sensor
monitoring for ROG MAXIMUS Z790 EXTREME owners on 6.18.y; the risk is
negligible.

---

## Verification

- [Phase 1] Parsed subject, tags, body: hardware enablement, no
  bug/crash language
- [Phase 1] No syzbot/sanitizer/Fixes tags found
- [Phase 2] Diff: 16 lines, static data only in `asus-ec-sensors.c` + 1
  doc line
- [Phase 2] Verified water sensor bits not set on existing intel-700
  boards in HEAD
- [Phase 3] `git describe HEAD`: `v6.18.44`
- [Phase 3] `git merge-base --is-ancestor 5f6617089dc06 HEAD`: commit
  NOT in tree
- [Phase 3] `git blame` on `sensors_family_intel_700[]`: introduced
  0183cb21b8a87
- [Phase 3] Similar board-add `15c8317366908` IS in v6.18.44
- [Phase 4] `b4 dig -c 5f6617089dc06`: v2 lore URL found
- [Phase 4] `b4 dig -a`: v1 and v2 revisions found
- [Phase 4] `b4 dig -w`: Guenter Roeck and linux-hwmon CC'd
- [Phase 4] UNVERIFIED: lore thread content (Anubis blocked fetch)
- [Phase 5] Traced `get_board_info()` → `asus_ec_probe()` call chain in
  source
- [Phase 5] `module_init(asus_ec_init)` confirmed at line 1402
- [Phase 6] `ROG MAXIMUS Z790 EXTREME` absent from `asus-ec-sensors.c`
  in HEAD
- [Phase 6] `ROG MAXIMUS Z790 EXTREME` present in `nct6775-platform.c`
  WMI list
- [Phase 6] Cherry-pick `5f6617089dc06` onto HEAD: clean auto-merge
- [Phase 7] `CONFIG_SENSORS_ASUS_EC` exists in `drivers/hwmon/Kconfig`
- [Phase 8] Failure mode assessed as missing hwmon, severity LOW
- [Phase 9] `Documentation/process/stable-kernel-rules.rst` line 15:
  device ID exception confirmed

**YES**

 Documentation/hwmon/asus_ec_sensors.rst |  1 +
 drivers/hwmon/asus-ec-sensors.c         | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/hwmon/asus_ec_sensors.rst b/Documentation/hwmon/asus_ec_sensors.rst
index a8456f29db950..8b9c24664e158 100644
--- a/Documentation/hwmon/asus_ec_sensors.rst
+++ b/Documentation/hwmon/asus_ec_sensors.rst
@@ -25,6 +25,7 @@ Supported boards:
  * ROG MAXIMUS XI HERO
  * ROG MAXIMUS XI HERO (WI-FI)
  * ROG MAXIMUS Z690 FORMULA
+ * ROG MAXIMUS Z790 EXTREME
  * ROG STRIX B550-E GAMING
  * ROG STRIX B550-I GAMING
  * ROG STRIX B650E-I GAMING WIFI
diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 57b771d96d4f0..33402bc3f6cd7 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -382,6 +382,12 @@ static const struct ec_sensor_info sensors_family_intel_700[] = {
 	[ec_sensor_temp_vrm] = EC_SENSOR("VRM", hwmon_temp, 1, 0x00, 0x33),
 	[ec_sensor_fan_cpu_opt] =
 		EC_SENSOR("CPU_Opt", hwmon_fan, 2, 0x00, 0xb0),
+	[ec_sensor_fan_water_flow] =
+		EC_SENSOR("Water_Flow", hwmon_fan, 2, 0x00, 0xbc),
+	[ec_sensor_temp_water_in] =
+		EC_SENSOR("Water_In", hwmon_temp, 1, 0x01, 0x00),
+	[ec_sensor_temp_water_out] =
+		EC_SENSOR("Water_Out", hwmon_temp, 1, 0x01, 0x01),
 };
 
 /* Shortcuts for common combinations */
@@ -475,6 +481,13 @@ static const struct ec_board_info board_info_maximus_z690_formula = {
 	.family = family_intel_600_series,
 };
 
+static const struct ec_board_info board_info_maximus_z790_extreme = {
+	.sensors = SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_SET_TEMP_WATER | SENSOR_FAN_WATER_FLOW,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_RMTW_ASMX,
+	.family = family_intel_700_series,
+};
+
 static const struct ec_board_info board_info_prime_x470_pro = {
 	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
 		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
@@ -776,6 +789,8 @@ static const struct dmi_system_id dmi_table[] = {
 					&board_info_maximus_xi_hero),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG MAXIMUS Z690 FORMULA",
 					&board_info_maximus_z690_formula),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG MAXIMUS Z790 EXTREME",
+					&board_info_maximus_z790_extreme),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX B550-E GAMING",
 					&board_info_strix_b550_e_gaming),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX B550-I GAMING",
-- 
2.53.0

