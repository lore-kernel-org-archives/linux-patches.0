Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB963F660B;
	Mon, 20 Apr 2026 13:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691557; cv=none; b=bQoP0gaKEJdgfai+omNB4znuwKvSNly6Y5/ERmTbrjZ5Ee9kAOJ7tU4NVOwWIzrnvKIS+WQc/F7eGZKw3QA3oF3s6dIhZMtUlS318O4V6H2S5uPWYpddP37Dhy6ZxAEmxsYH9iYMIKjrel2hNeMj/5M7RfAzNo2/S5Pva5ROgkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691557; c=relaxed/simple;
	bh=SZI/oSocyDlcozG/n+ticI/QDtm52F+51SbwuEk3IkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swegGAKpXf5Wy6nlYp4JzMp3ni378tX+5hiZhCN7rs44ObMkvxpD3l63Ih/teIk+fHiM2dni0fgdZxaFapSmRuAm1Csjyrw7n7qukjq+GgCLQ/GKjaYUrmXSHavU9u6dmL0dLq1F5P/btH7d21+bPGnC61HiOKXIFaGdzIkK+c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1kNneet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1kNneet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB78C2BCB9;
	Mon, 20 Apr 2026 13:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691556;
	bh=SZI/oSocyDlcozG/n+ticI/QDtm52F+51SbwuEk3IkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1kNneetsnBEUqiEKjDPiyG6UoYoFhenvwQZvwNxCdZ5kHmCAF2ecaFOz3Qkh9Oce
	 xiR8IuYoGZHZ3QvWCK8+AgAZlntbQX39tw+kLmsIbFxck0CR3M38tCkOdPPUn7muMp
	 hqvBwOyZIPOyRy3H7+4mlPeqVqkcO75l+b5IBfSfzorcMiFE1vEnzm5K9mqzaMg1yl
	 vFnQCiJNEeCBnorvXOtjitrjWbbrMAAjBFqlt5NqCxxXrbZqni7d8gNd3B3DoO2lvd
	 QsgmrR/x07lXwX21BxV7iREHn7R9zVvD2c3Mr7NKG8Vk0Pyk4LBX7NoC8zY1bwT4tD
	 Vp6rIWh/8exxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Timothy C. Sweeney-Fanelli" <tim@zerobytellc.com>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	corbet@lwn.net,
	linux-hwmon@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] hwmon: (asus-ec-sensors )add ROG CROSSHAIR X670E EXTREME
Date: Mon, 20 Apr 2026 09:18:12 -0400
Message-ID: <20260420132314.1023554-98-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Timothy C. Sweeney-Fanelli" <tim@zerobytellc.com>

[ Upstream commit ab4b7071ae0a831e4c2fd45c626c3b1d66cc1201 ]

Add support for ROG CROSSHAIR X670E EXTREME

Signed-off-by: Timothy C. Sweeney-Fanelli <tim@zerobytellc.com>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260215151743.20138-3-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `hwmon: (asus-ec-sensors)`
- Action verb: `add`
- Summary: Add board support for ROG CROSSHAIR X670E EXTREME motherboard

Record: [hwmon/asus-ec-sensors] [add] [New motherboard board definition
for ROG CROSSHAIR X670E EXTREME]

**Step 1.2: Tags**
- `Signed-off-by: Timothy C. Sweeney-Fanelli <tim@zerobytellc.com>` —
  original contributor/tester of the board info
- `Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>` — driver
  maintainer who curates submissions
- `Link: https://lore.kernel.org/r/20260215151743.20138-3-
  eugene.shalygin@gmail.com` — patch 3 of a series
- `Signed-off-by: Guenter Roeck <linux@roeck-us.net>` — hwmon subsystem
  maintainer who merged it

Record: No Fixes tag (expected for a board addition). No Reported-by,
Cc: stable, or syzbot. The patch went through the driver author
(Shalygin) and hwmon maintainer (Roeck). This is patch 3 of a series.

**Step 1.3: Commit Body**
The body simply says "Add support for ROG CROSSHAIR X670E EXTREME." No
bug description, stack traces, or failure modes — this is a hardware
enablement commit.

Record: No bug is described; this is a hardware support addition for a
specific ASUS motherboard model.

**Step 1.4: Hidden Bug Fix Detection**
This is not a hidden bug fix. It's a straightforward board ID / sensor
configuration addition to enable hwmon sensor monitoring on a new
motherboard.

Record: Not a hidden bug fix. Pure hardware enablement.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `Documentation/hwmon/asus_ec_sensors.rst`: +1 line (adds board name to
  supported list)
- `drivers/hwmon/asus-ec-sensors.c`: +11 lines (9-line board_info struct
  + 2-line DMI table entry)
- Total: ~12 lines added, 0 removed
- Functions modified: None. Only static const data structures added.

Record: 2 files, +12 lines, 0 lines removed. Only adds static const data
(board_info struct and DMI match entry). Scope: single-file surgical
addition.

**Step 2.2: Code Flow**
- Hunk 1 (board_info): Adds `board_info_crosshair_x670e_extreme` struct
  with temperature sensors (CPU, CPU Package, MB, VRM, T_Sensor,
  Water_In, Water_Out), mutex path
  `ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0`, and
  `family_amd_600_series`.
- Hunk 2 (DMI table): Adds a `DMI_EXACT_MATCH_ASUS_BOARD_NAME` entry
  linking the board name to the new struct.
- Before: The board was not recognized; driver wouldn't probe on this
  motherboard.
- After: The board is recognized and the defined sensors are exposed via
  hwmon.

**Step 2.3: Bug Mechanism**
Category: Hardware workaround / device ID addition. No bug fix. The new
struct uses existing sensor macros, an existing mutex path (verified at
7 other locations), and an existing family (`family_amd_600_series`).
The sensor table `sensors_family_amd_600[]` (line 275) includes all the
sensors referenced: `ec_sensor_temp_cpu`, `ec_sensor_temp_cpu_package`,
`ec_sensor_temp_mb`, `ec_sensor_temp_vrm`, `ec_sensor_temp_t_sensor`,
`ec_sensor_temp_water_in`, `ec_sensor_temp_water_out`.

Record: This is a hardware enablement (new board ID) addition. All
referenced sensors, mutex path, and family exist in the codebase.

**Step 2.4: Fix Quality**
- Obviously correct: Yes — follows the exact same pattern as dozens of
  other board entries
- Minimal/surgical: Yes — 12 lines of purely static data
- Regression risk: Essentially zero — the new DMI match only triggers on
  the exact board name "ROG CROSSHAIR X670E EXTREME". Cannot affect any
  other board.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The code this is inserted adjacent to
(`board_info_crosshair_viii_impact` and
`board_info_crosshair_x670e_gene`) has been present since 2022-2023. The
AMD 600 series family support was introduced in commit 790dec13c0128
(April 2023), and is present in all stable trees since ~v6.5+.

**Step 3.2: Fixes Tag**
No Fixes: tag present (expected — this is not a bug fix, it's a new
board addition).

**Step 3.3: File History**
The file has 65+ commits since the driver was introduced (d0ddfd241e571,
Jan 2022). The vast majority are board additions just like this one.
Eugene Shalygin is the driver author/maintainer and has authored nearly
all of them.

**Step 3.4: Author**
Eugene Shalygin is the original author and maintainer of the asus-ec-
sensors driver (copyright 2021, authored 40+ commits). Timothy Sweeney-
Fanelli is the board owner who contributed the sensor data.

**Step 3.5: Dependencies**
No dependencies. All referenced constants (`SENSOR_TEMP_CPU`,
`SENSOR_TEMP_WATER_IN`, `ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0`,
`family_amd_600_series`) already exist in the 7.0 stable tree. This is a
standalone addition.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5:**
The Link: tag indicates this is patch 3 of a series
(20260215151743.20138-3). Lore.kernel.org is behind Anubis protection
and cannot be fetched. However, b4 dig confirmed similar patches from
the same author are findable. The patch was accepted by hwmon maintainer
Guenter Roeck, the standard pathway for all asus-ec-sensors changes.

Record: Could not access lore due to Anubis bot protection. The patch
followed the standard hwmon submission path (contributor -> driver
author -> Guenter Roeck).

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.5:**
No functions are modified. The change adds only static const data
structures. The DMI matching framework (`dmi_table[]`) is used during
module probe. When the DMI system matches the board name, the driver
reads sensors from EC registers at the offsets defined in
`sensors_family_amd_600[]`. This is a purely data-driven mechanism — no
code path changes.

Record: No code flow changes. Only static data additions. The DMI match
→ board_info → sensor table pipeline is well-established and works
identically for all 40+ supported boards.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:**
The driver exists since v5.18 (d0ddfd241e571, Jan 2022). AMD 600 series
support exists since v6.5 (790dec13c0128, Apr 2023). The
`ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0` mutex path and all sensor
macros exist in 7.0.

**Step 6.2:**
The patch should apply cleanly. It's a pure addition between existing
entries in two sorted lists (board_info structs and DMI table). No
conflicts expected.

**Step 6.3:**
No related fix needed — this board has never been supported before.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:**
Subsystem: hwmon (hardware monitoring). Criticality: PERIPHERAL —
affects only users of this specific ASUS motherboard. However, hwmon
sensor monitoring is important for users who rely on temperature/fan
monitoring for system health.

**Step 7.2:**
The driver is actively maintained with 65+ commits, mostly board
additions from the original author.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected users: only owners of the ROG CROSSHAIR X670E
EXTREME motherboard.

**Step 8.2:** Trigger: automatic during driver probe if the DMI board
name matches.

**Step 8.3:** Failure mode without fix: no hwmon sensor data available
for this board. Users cannot monitor CPU/VRM temperatures, water cooling
temps, etc. through the standard hwmon interface.

**Step 8.4:**
- Benefit: LOW-MEDIUM — enables hardware monitoring for a specific
  popular enthusiast motherboard
- Risk: VERY LOW — 12 lines of static const data, cannot affect any
  other board
- Ratio: Favorable

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Falls squarely into the "new device ID / board addition" exception
  category
- Trivially small (12 lines of static const data)
- Zero regression risk (only triggers on exact DMI board name match)
- All infrastructure (AMD 600 series sensors, mutex path) already exists
  in stable
- Authored by the driver maintainer, accepted by the hwmon subsystem
  maintainer
- Follows identical pattern to dozens of prior board additions

**Evidence AGAINST backporting:**
- This is not a bug fix — it's hardware enablement
- Affects only one specific motherboard model
- No Cc: stable tag (but this is expected for board additions needing
  manual review)

**Stable rules checklist:**
1. Obviously correct? YES — identical pattern to 40+ other entries
2. Fixes a real bug? NO — but falls into the device ID exception
3. Important issue? NO — but enables real hardware for real users
4. Small and contained? YES — 12 lines, static data only
5. No new features/APIs? YES — no new interfaces, just enables existing
   driver on new hardware
6. Can apply to stable? YES — clean apply expected

**Verification:**
- [Phase 1] Parsed tags: SOBs from Timothy Sweeney-Fanelli
  (contributor), Eugene Shalygin (driver author), Guenter Roeck (hwmon
  maintainer). Link to lore present.
- [Phase 2] Diff: +12 lines across 2 files. Only static const board_info
  struct and DMI table entry added. No code logic changes.
- [Phase 3] git log: Eugene Shalygin authored 40+ commits to this file,
  is the original driver author (copyright 2021).
- [Phase 3] git log: AMD 600 series support introduced in 790dec13c0128
  (April 2023), present in 7.0 tree.
- [Phase 3] Verified `ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0` used
  by 7 other boards (lines 567, 673, 687, 694, 702, 710, 777).
- [Phase 3] Verified all sensor macros used (`SENSOR_TEMP_CPU`,
  `SENSOR_TEMP_CPU_PACKAGE`, `SENSOR_TEMP_MB`, `SENSOR_TEMP_VRM`,
  `SENSOR_TEMP_T_SENSOR`, `SENSOR_TEMP_WATER_IN`,
  `SENSOR_TEMP_WATER_OUT`) exist in `sensors_family_amd_600[]` (lines
  275-293).
- [Phase 4] Lore inaccessible due to Anubis protection; b4 dig could not
  find the commit directly (likely not yet in tree). The submission path
  (contributor -> driver author -> Guenter Roeck) is standard.
- [Phase 5] No functions modified. Only static const data. Zero code
  path impact.
- [Phase 6] Driver and AMD 600 series support exist in 7.0 tree. Clean
  apply expected.
- [Phase 8] Risk: VERY LOW (static data only, DMI-scoped). Benefit:
  enables hwmon on a specific board.

This is a textbook new board ID addition to an existing driver — one of
the explicitly allowed exception categories for stable backporting. It's
trivially small, uses only existing infrastructure, and cannot regress
any other system.

**YES**

 Documentation/hwmon/asus_ec_sensors.rst |  1 +
 drivers/hwmon/asus-ec-sensors.c         | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/hwmon/asus_ec_sensors.rst b/Documentation/hwmon/asus_ec_sensors.rst
index 58986546c7233..8a080a786abd2 100644
--- a/Documentation/hwmon/asus_ec_sensors.rst
+++ b/Documentation/hwmon/asus_ec_sensors.rst
@@ -22,6 +22,7 @@ Supported boards:
  * ROG CROSSHAIR VIII FORMULA
  * ROG CROSSHAIR VIII HERO
  * ROG CROSSHAIR VIII IMPACT
+ * ROG CROSSHAIR X670E EXTREME
  * ROG CROSSHAIR X670E HERO
  * ROG CROSSHAIR X670E GENE
  * ROG MAXIMUS X HERO
diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index adedaf0db10e6..934e37738a516 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -456,6 +456,15 @@ static const struct ec_board_info board_info_crosshair_viii_impact = {
 	.family = family_amd_500_series,
 };
 
+static const struct ec_board_info board_info_crosshair_x670e_extreme = {
+	.sensors = SENSOR_TEMP_CPU | SENSOR_TEMP_CPU_PACKAGE |
+		SENSOR_TEMP_MB | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_WATER_IN |
+		SENSOR_TEMP_WATER_OUT,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0,
+	.family = family_amd_600_series,
+};
+
 static const struct ec_board_info board_info_crosshair_x670e_gene = {
 	.sensors = SENSOR_TEMP_CPU | SENSOR_TEMP_CPU_PACKAGE |
 		SENSOR_TEMP_T_SENSOR |
@@ -825,6 +834,8 @@ static const struct dmi_system_id dmi_table[] = {
 					&board_info_crosshair_viii_hero),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VIII IMPACT",
 					&board_info_crosshair_viii_impact),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR X670E EXTREME",
+					&board_info_crosshair_x670e_extreme),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR X670E GENE",
 					&board_info_crosshair_x670e_gene),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR X670E HERO",
-- 
2.53.0

