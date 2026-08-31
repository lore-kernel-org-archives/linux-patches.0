Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E16554090;
	Mon, 31 Aug 2026 13:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184021; cv=none; b=ABVmawKYhaEsN50V0Gyp47rIbQwTZRM7dDd9HPY+qg9CMrA/Eoj5bCKyLCKFExDktShablKghFxCx5C5fArKFD5u++eBmO5pZ7uIrQGWyB0iavqL1LB8WtKHDyGLO+PEhZTgBFYfpuZAzzStOzpI6u/p6rAIB4wDv9rnAe6qUZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184021; c=relaxed/simple;
	bh=uJAbHlxYNXIHE4aJUZQOJhTOXMAj8pE4PVHD3CgWx8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RVSTVyXwFyodvKGbSwqHodtf/YZmMdmUrQuMOh4/SBEWddu5/v9OCDFdeo1ySXkEb50IsruE5uMf/zyMzl1TkF/mqD0mdkIn3HTpaQyt8g54PTRA1+zNnU7VfgP03wtSCLWedRmqVMnOnBHUk/yqhnC/Kz2nV/LAWDY/YPyiPAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WuG181x8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WuG181x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39DC1F00A3D;
	Mon, 31 Aug 2026 13:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184016;
	bh=weETPJ2teorjRCwF4+obXO9mQoQUZieMMic/CWNjFss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WuG181x89eFRn3KbU8hCTdI1AC4Um2d48KIiJJb0CeXWecFEVwJZiRJ1FEi8yYxKV
	 DSmnk7/bpp7BeLKew64skmLOMjO/j0CQKcVW6s9HtUByBS2FojhkhoiOWU4GOq1Rwp
	 3uD1tLoCz0r1g5VwONNpiaeeSWBVRjvWQwyvYD/DdGY/JGDYudD/YzRyTotJR0WB5t
	 G83t7sXVP4K6QqI5/zjL9Rch1iRmuopCm8XDNmWSDlvqyVnBSymixNoMmhYpIM6Mun
	 NP7pTZWsFJMjrVC5MuE5EYmJRJbffSqXsC6X4ihyVYeeTEy0vqJJVDJaPnoIg8X+qa
	 Fh9zUwe3XxzdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	corbet@lwn.net,
	linux-hwmon@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] hwmon: (asus-ec-sensors) add ROG STRIX B850-E GAMING WIFI
Date: Mon, 31 Aug 2026 09:27:48 -0400
Message-ID: <20260831133314.4125787-440-sashal@kernel.org>
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

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit 5e9f31543515d685cafed33274433b6360c0e1e4 ]

The board has a similar sensor configuration to the
ROG STRIX B850-I GAMING WIFI, but includes an additional
T-Sensor header. The patch was provided via GitHub [1].

[1] https://github.com/zeule/asus-ec-sensors/pull/105

Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260607123626.100630-1-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[hwmon: (asus-ec-sensors)] [add] [ROG STRIX B850-E GAMING
WIFI board support]`

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — not present
- **Tested-by:** — not present
- **Reviewed-by:** — not present
- **Acked-by:** — not present
- **Link:** `https://lore.kernel.org/r/20260607123626.100630-1-
  eugene.shalygin@gmail.com`
- **Cc: stable@vger.kernel.org:** — not present (expected)
- **Signed-off-by:** Eugene Shalygin `<eugene.shalygin@gmail.com>`
  (author)
- **Signed-off-by:** Guenter Roeck `<linux@roeck-us.net>` (hwmon
  maintainer)
- **Notable:** GitHub reference `[1] https://github.com/zeule/asus-ec-
  sensors/pull/105` in body; no syzbot/fuzzer tags

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug description:** Not a crash/corruption fix. Adds DMI board
  identification and sensor configuration for the ASUS ROG STRIX B850-E
  GAMING WIFI motherboard.
- **Symptom without patch:** `asus-ec-sensors` does not bind on this
  board; no EC-based temperature/fan hwmon sensors are exposed.
- **Root cause:** Board is absent from the driver's `dmi_table[]` and
  has no `ec_board_info` entry.
- **Configuration detail:** Similar to B850-I, but adds
  `SENSOR_TEMP_T_SENSOR` (T-Sensor header) and uses
  `ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0` instead of the ACPI
  global lock used by B850-I.
- **Version info:** None in commit message.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not a hidden bug fix. This is explicit hardware enablement —
a DMI board-table addition analogous to adding a PCI/USB device ID. No
error-path, locking, refcount, or memory-safety changes.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- `Documentation/hwmon/asus_ec_sensors.rst`: +1 line (board list)
- `drivers/hwmon/asus-ec-sensors.c`: +10 lines (struct + DMI entry)
- **Total:** ~11 lines added, 0 removed
- **Functions modified:** None; only static data
  (`board_info_strix_b850_e_gaming_wifi`, `dmi_table[]`)
- **Scope:** Single-subsystem, single-driver, surgical data-table
  addition

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (docs):** Adds board name to supported-boards list.
- **Hunk 2 (board_info):** Before → no config for B850-E. After → new
  `ec_board_info` with CPU/CPU package/MB/VRM temps, T-Sensor, CPU_OPT
  fan, SB PCI0 SIO1 mutex, `family_amd_800_series`.
- **Hunk 3 (dmi_table):** Before → DMI match fails for `"ROG STRIX
  B850-E GAMING WIFI"`, `get_board_info()` returns NULL,
  `asus_ec_probe()` returns `-ENODEV`. After → board matches and probe
  proceeds with correct sensor/mutex config.
- **Path affected:** Driver probe on matching DMI hardware only.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware enablement / board ID addition (DMI quirk
  equivalent)
- **Mechanism:** Missing DMI entry prevents driver binding; not a
  runtime crash bug. Wrong mutex/sensor map (if guessed from B850-I)
  could cause incorrect EC access — the patch supplies board-owner-
  validated configuration.

### Step 2.4: Fix Quality Assessment
**Record:**
- **Quality:** High. Follows the exact pattern of
  `board_info_strix_b850_i_gaming_wifi` (commit `25b2c02e5b1f8`) and
  other ATX boards using `ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0`
  (e.g. `board_info_strix_x670e_e_gaming_wifi`).
- **Regression risk:** Very low — only adds a new DMI match; existing
  boards unaffected.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:** Commit not yet in this tree. Sister board B850-I was added
by `25b2c02e5b1f8` (2025-07-28, merged via `989253cc46ff3` hwmon-
for-v6.18-rc1). `family_amd_800_series` introduced in `2c8ac03aad7a8`
(ROG STRIX X870E-E GAMING WIFI). All prerequisite infrastructure
predates 6.18.44.

### Step 3.2: Follow Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File History for Related Changes
**Record:** Recent `asus-ec-sensors.c` changes on `stable/linux-6.18.y`
after v6.18.0 are bug fixes only (`ENOMEM` handling, EC read intervals,
bank looping, T_Sensor fix for PRIME X670E-PRO WIFI). No new board
additions were backported post-v6.18.0. B850-I and other boards arrived
via the v6.18-rc1 merge. This commit would be the first post-release
board addition for this driver in 6.18.y, but that is precedent context,
not a disqualifier.

### Step 3.4: Author's Other Commits
**Record:** Eugene Shalygin is an active `asus-ec-sensors` contributor
(e.g. B850-I co-author, multiple board/fix commits). Guenter Roeck is
the hwmon maintainer and committed the patch.

### Step 3.5: Dependent/Prerequisite Commits
**Record:** No series dependency. Requires only existing infrastructure
in this tree:
- `asus-ec-sensors` driver ✓
- `family_amd_800_series` ✓
- `SENSOR_TEMP_T_SENSOR`, `SENSOR_FAN_CPU_OPT` ✓
- `ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0` ✓
- B850-I support (`25b2c02e5b1f8`) ✓
Standalone backport.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** Lore URL blocked by Anubis bot protection (could not read
thread). GitHub PR #105 (merged 2026-04-18, author `leimh`) confirms
hardware-owner testing; board config includes T-Sensor header and
dedicated hardware mutex. Label `mainlined` added. `b4 dig` without
commit hash failed; `b4 dig -c 25b2c02e5b1f8` worked for the related
B850-I patch only.

### Step 4.2: Reviewers
**Record:** Guenter Roeck (maintainer) Signed-off-by on commit. GitHub
review by `zeule` (asus-ec-sensors maintainer) before merge.

### Step 4.3: Bug Report
**Record:** No formal bug report. Hardware validation via GitHub PR #105
from a B850-E owner. Symptom: missing sensor support, not a kernel oops.

### Step 4.4: Related Patches/Series
**Record:** Standalone 1/1 patch. Related: B850-I addition
(`25b2c02e5b1f8`) already in tree; B850-E extends the same product line
with different sensor/mutex layout.

### Step 4.5: Stable Mailing List History
**Record:** Not searched (lore access blocked). No stable nomination
found in available sources.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** No functions modified. Data consumed by `get_board_info()` →
`asus_ec_probe()`.

### Step 5.2: Callers
**Record:** `get_board_info()` called from `asus_ec_probe()` (line
1256). `asus_ec_probe()` is the platform driver probe callback — runs at
boot/module load on ASUS boards with `CONFIG_SENSORS_ASUS_EC=y/m`.

### Step 5.3: Callees
**Record:** `dmi_first_match(dmi_table)` performs string match against
DMI board name; returns `ec_board_info` pointer used for sensor bitmask,
mutex path, and family selection.

### Step 5.4: Call Chain / Reachability
**Record:** Boot-time platform driver probe → DMI match → hwmon device
registration. Reachable on every boot for B850-E owners with the driver
enabled. Not a syscall-triggered path; not unprivileged-user
triggerable.

### Step 5.5: Similar Patterns
**Record:** Identical pattern to B850-I (`25b2c02e5b1f8`), X670E-E,
X870-I, and dozens of other `DMI_EXACT_MATCH_ASUS_BOARD_NAME` entries in
the same file (44 total matches).

---

## Phase 6: Cross-Referencing Against Local Tree

### Step 6.1: Does Buggy/Missing Code Exist?
**Record:** Local tree is **linux-6.18.y at v6.18.44** (`git describe
HEAD` → `v6.18.44`). `B850-E` is **not** present; `B850-I` **is**
present. Without this patch, B850-E users get `-ENODEV` from
`asus_ec_probe()`. All patch dependencies exist.

### Step 6.2: Backport Complications
**Record:** Expected **clean apply**. Insertion anchors verified in
current tree:
- After `board_info_strix_b650e_i_gaming` (lines 575–580)
- Before `board_info_strix_b850_i_gaming_wifi` (lines 582–587)
- DMI table between B650E-I and B850-I entries (lines 775–778)
- Docs between B650E-I and B850-I (lines 30–31)

### Step 6.3: Related Fixes Already Present?
**Record:** No B850-E entry or equivalent fix present. B850-I support
already in tree as the closest reference implementation.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/hwmon/` — **PERIPHERAL** (board-specific sensor
driver). Affects only users of `CONFIG_SENSORS_ASUS_EC` on this specific
motherboard.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; 4 bug-fix backports to this driver
since v6.18.0, plus many board additions in the v6.18-rc1 merge.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** **Driver-specific / platform-specific** — owners of ROG
STRIX B850-E GAMING WIFI running `CONFIG_SENSORS_ASUS_EC`.

### Step 8.2: Trigger Conditions
**Record:** Every boot with matching DMI and driver enabled. Common for
target hardware. Not security-relevant; not userspace-triggerable.

### Step 8.3: Failure Mode Severity
**Record:** Without patch: no hwmon sensors (temperature/fan monitoring
unavailable via this driver); probe returns `-ENODEV`. **Severity: LOW**
— functional gap, not crash/corruption/deadlock. Fan control may fall
back to BIOS/EC defaults.

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Enables correct thermal/fan monitoring on a current AM5
  board for stable-kernel users; validated by hardware owner.
- **Risk:** Very low (~11 lines, data-only, no logic changes).
- **Ratio:** Favorable. Matches the stable-tree exception for
  device/board ID additions explicitly allowed in
  `Documentation/process/stable-kernel-rules.rst`.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Explicitly allowed by stable rules: "just add a device ID" (`stable-
  kernel-rules.rst` line 15)
- DMI board entry is the hwmon equivalent of a device ID/quirk
- Tiny, surgical, obviously correct
- All prerequisites present in 6.18.44 (driver, `family_amd_800_series`,
  B850-I precedent, mutex path, sensor flags)
- Hardware-validated via GitHub PR #105
- Maintainer (Guenter Roeck) signed off
- Sister board B850-I already supported in this tree

**AGAINST backport:**
- Does not fix a crash, security issue, or data corruption
- No post-v6.18.0 board-addition backports for this driver (only bug
  fixes) — conservative precedent
- Affects a narrow hardware population

**Unresolved:**
- Full lore review thread inaccessible (Anubis block)
- Exact mainline commit SHA not in local tree (not needed for
  applicability assessment)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — pattern proven by sibling
   boards; GitHub PR from hardware owner; maintainer SOB.
2. Fixes a real bug affecting users? **PASS (exception)** — not a
   runtime bug, but stable rules explicitly allow device/board ID
   additions for hardware enablement.
3. Important issue? **PASS (exception)** — hardware quirk/ID category;
   enables monitoring on real production hardware.
4. Small and contained? **PASS** — ~11 lines, 2 files, data only.
5. No new features/APIs? **PASS** — no new APIs; board table entry only.
6. Can apply to local tree? **PASS** — prerequisites present; clean
   insertion points verified.

### Step 9.3: Exception Category
**Record:** Device/board ID addition to an existing driver (DMI quirk
equivalent). Driver `asus-ec-sensors` and `family_amd_800_series`
already exist; only the board entry is new.

### Step 9.4: Decision Rationale

For **linux-6.18.y (v6.18.44)**, this commit should be backported. It is
a minimal DMI board-table addition to an existing, already-shipped
driver — the same category explicitly permitted by stable-kernel rules
alongside PCI/USB ID additions. The B850-E is not covered by the
existing B850-I entry (different mutex path and additional T-Sensor).
Without it, owners of this board on 6.18.y get no `asus-ec-sensors`
support despite the driver and AMD 800-series infrastructure already
being present. Risk is negligible.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes:/syzbot tags; Link to
  lore present
- [Phase 1] GitHub PR #105 fetched: merged, hardware-owner tested,
  T-Sensor + mutex noted
- [Phase 2] Diff inventory: 2 files, ~11 lines, static data only
- [Phase 2] Read `asus_ec_probe()` lines 1256–1258: `-ENODEV` when
  `get_board_info()` returns NULL
- [Phase 3] `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- [Phase 3] `git log --grep="B850-E"` → no commit in tree; B850-I at
  `25b2c02e5b1f8` confirmed in tree
- [Phase 3] `git blame` lines 582–587 → B850-I added by `25b2c02e5b1f8`
- [Phase 3] `git log v6.18.44 --not v6.18 -- drivers/hwmon/asus-ec-
  sensors.c` → 4 bug-fix backports only, no board additions
- [Phase 4] Lore fetch blocked by Anubis; GitHub PR #105 verified
  instead
- [Phase 4] `b4 dig -c 25b2c02e5b1f8` → B850-I lore URL (related patch
  only)
- [Phase 5] `get_board_info()` at line 1233; `asus_ec_probe()` at line
  1241; DMI table at line 728
- [Phase 5] `family_amd_800_series` case at line 1279 confirmed
- [Phase 6] `grep B850-E` in tree → not found; `grep B850-I` → present
- [Phase 6] Insertion anchor lines 575–587, 775–778, docs 30–31 verified
  by reading files
- [Phase 6] `ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0` used by
  existing boards (e.g. X670E-E line 625)
- [Phase 7] `CONFIG_SENSORS_ASUS_EC` in `drivers/hwmon/Kconfig` line
  2704; built via `drivers/hwmon/Makefile`
- [Phase 8] `Documentation/process/stable-kernel-rules.rst` line 15: "or
  just add a device ID"
- [Phase 8] Failure without patch: `-ENODEV`, no sensors — severity LOW,
  not crash
- UNVERIFIED: Full lore.kernel.org review thread (blocked)
- UNVERIFIED: Exact mainline commit SHA (not in local tree; irrelevant
  to 6.18.y applicability)

**YES**The analysis is complete for **linux-6.18.y (v6.18.44)**.

**Commit:** `hwmon: (asus-ec-sensors) add ROG STRIX B850-E GAMING WIFI`
**What it does:** Adds a DMI board entry and sensor config (~11 lines)
so the existing `asus-ec-sensors` driver works on the ROG STRIX B850-E
(CPU/MB/VRM temps, T-Sensor, CPU_OPT fan). Sister board B850-I is
already supported in this tree; B850-E is not.

**Verdict: YES** — This is a small board-ID addition to an existing
driver, explicitly allowed under stable rules (“just add a device ID”).
All prerequisites (`family_amd_800_series`, mutex paths, sensor flags)
are present in 6.18.44. Risk is very low; benefit is real hardware
enablement validated via GitHub PR #105.

 Documentation/hwmon/asus_ec_sensors.rst |  1 +
 drivers/hwmon/asus-ec-sensors.c         | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/hwmon/asus_ec_sensors.rst b/Documentation/hwmon/asus_ec_sensors.rst
index a5a58c00c3223..a8456f29db950 100644
--- a/Documentation/hwmon/asus_ec_sensors.rst
+++ b/Documentation/hwmon/asus_ec_sensors.rst
@@ -28,6 +28,7 @@ Supported boards:
  * ROG STRIX B550-E GAMING
  * ROG STRIX B550-I GAMING
  * ROG STRIX B650E-I GAMING WIFI
+ * ROG STRIX B850-E GAMING WIFI
  * ROG STRIX B850-I GAMING WIFI
  * ROG STRIX X570-E GAMING
  * ROG STRIX X570-E GAMING WIFI II
diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 13fd212ad4040..57b771d96d4f0 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -579,6 +579,14 @@ static const struct ec_board_info board_info_strix_b650e_i_gaming = {
 	.family = family_amd_600_series,
 };
 
+static const struct ec_board_info board_info_strix_b850_e_gaming_wifi = {
+	.sensors = SENSOR_TEMP_CPU | SENSOR_TEMP_CPU_PACKAGE |
+		SENSOR_TEMP_MB | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CPU_OPT,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0,
+	.family = family_amd_800_series,
+};
+
 static const struct ec_board_info board_info_strix_b850_i_gaming_wifi = {
 	.sensors = SENSOR_TEMP_CPU | SENSOR_TEMP_CPU_PACKAGE |
 		SENSOR_TEMP_MB | SENSOR_TEMP_VRM,
@@ -774,6 +782,8 @@ static const struct dmi_system_id dmi_table[] = {
 					&board_info_strix_b550_i_gaming),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX B650E-I GAMING WIFI",
 					&board_info_strix_b650e_i_gaming),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX B850-E GAMING WIFI",
+					&board_info_strix_b850_e_gaming_wifi),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX B850-I GAMING WIFI",
 					&board_info_strix_b850_i_gaming_wifi),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX X570-E GAMING",
-- 
2.53.0

