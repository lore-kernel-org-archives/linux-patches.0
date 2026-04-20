Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CA248C419;
	Mon, 20 Apr 2026 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691931; cv=none; b=Lcr2wVQh5ENkJXvVtG/4rUgMC1D13axgSMjhsvKGnrTH77MAEzeA6wiPtDxZb7P5YDmwWn36mbyv7jC0y7hufXKYRwXSHgaDi2vnBTv63Urlur/AiMPN5F5RXxf1APGfPXoD3uVcCe6GcoEIKDxPy/14Lzmx1VGWx9xEVZNCFjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691931; c=relaxed/simple;
	bh=/eaq8lMCumNDRzpCT8cYDTdDPbgwBpq/RFNHpaJfm3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drHkmEfc2mP50vuLBFw4kr+9MtWNltuY0wNYcCEZW1zmTz/rAxZTLlf5wU0G5+KsfGXDWZeNq2sakpGpH+SXli86jP9SMwAK+1hB0i/0aggulU+5kB8q328Ey28cM587Cgt37I4w+K3qcUVP4hmRKJOAHfhlTedK1v81rHTZZH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ibB8bD88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ibB8bD88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD92C2BCB4;
	Mon, 20 Apr 2026 13:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691931;
	bh=/eaq8lMCumNDRzpCT8cYDTdDPbgwBpq/RFNHpaJfm3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibB8bD88ZJK1KniHUjmB3qd5B5U+O3OcHVj5rmDFTGjxl63EpQgItDAxT4DtdAT1A
	 6IpLleP4DcZ0RbD98eDneJUaSQjyJTZDx+OOX6HH5pnxmwCQWQkWSygNAYc5sC+LAX
	 k03TGOze9+zQGR6rGBttKad4QSPpJvDfQ5IiqMvewtgwLBUHD/kB2ljzbwyRB92YQl
	 D3gzX6+PU+XuofsZ04T+OF+hhZnMgcU2NeAVsAuqQop0V4dsWzUFocd24nmFF1KEQi
	 LHldL2WGgYevo2Zg2h8ucdxaPq4YZYZyZKs1kYoth6zXvQCrZNYRnDfcaSZ/9T/NVi
	 pP2k6FaLE5JPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antheas Kapenekakis <lkml@antheas.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	cryolitia@uniontech.com,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] hwmon: (gpd-fan) Add GPD Win 5
Date: Mon, 20 Apr 2026 09:21:10 -0400
Message-ID: <20260420132314.1023554-276-sashal@kernel.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 4853b53264869e51378cad7bf1556d4e8049d445 ]

The GPD Win 5 is a new device by GPD with an AMD AI MAX 385/395 chip.
It uses the same fan control registers as the GPD Win Duo. This
information was provided by GPD.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20260220161601.2344291-1-lkml@antheas.dev
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `hwmon: (gpd-fan)`
- Action verb: "Add" — adding a new device entry
- Summary: Adding DMI match for GPD Win 5 handheld device to the gpd-fan
  hwmon driver
- Record: [hwmon/gpd-fan] [Add] [New DMI entry for GPD Win 5 device]

**Step 1.2: Tags**
- `Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>` — the author,
  a GPD/handheld Linux contributor
- `Link:
  https://lore.kernel.org/r/20260220161601.2344291-1-lkml@antheas.dev` —
  original submission
- `Signed-off-by: Guenter Roeck <linux@roeck-us.net>` — the hwmon
  subsystem maintainer accepted the patch
- No Fixes: tag (expected for this type of commit)
- No Reported-by, no Cc: stable (expected for device ID additions)
- Record: Accepted by hwmon maintainer Guenter Roeck. No bug report tags
  — this is hardware enablement.

**Step 1.3: Commit Body**
- The GPD Win 5 is a new handheld device by GPD with AMD AI MAX 385/395.
- It uses the same fan control registers as the GPD Win Duo.
- Information was provided directly by GPD (the manufacturer).
- Record: Hardware enablement for a new device using already-existing
  driver data. No bug being fixed — this is a device ID addition.

**Step 1.4: Hidden Bug Fix Detection**
- This is NOT a hidden bug fix. It is purely a device ID addition to
  enable fan control on new hardware.
- Without this entry, the GPD Win 5 has no kernel-level fan control,
  which could result in overheating or always-on-full-speed fans.
- Record: Not a hidden bug fix; a device ID addition in the "exception"
  category.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: `drivers/hwmon/gpd-fan.c` only
- Lines added: +8 (a single DMI table entry block)
- Lines removed: 0
- Functions modified: None — the change is to the static `dmi_table[]`
  array
- Scope: Single-file, trivial table entry addition
- Record: [drivers/hwmon/gpd-fan.c: +8/-0] [dmi_table[] data array]
  [Trivial table entry]

**Step 2.2: Code Flow Change**
- BEFORE: The `dmi_table[]` does not match GPD Win 5 (DMI product name
  "G1618-05"). The driver returns `-ENODEV` on this hardware.
- AFTER: The `dmi_table[]` has an entry for "G1618-05" pointing to
  `&gpd_duo_drvdata`. The driver will probe and provide fan control on
  GPD Win 5.
- Record: [Before: no match, driver not loaded → After: match found,
  driver loads with duo drvdata]

**Step 2.3: Bug Mechanism**
- Category: Hardware workaround / Device ID addition (category h)
- This is a DMI match table entry addition — the exact same pattern as
  USB device IDs, PCI IDs, etc.
- Uses existing `gpd_duo_drvdata` — no new data structures, code paths,
  or logic.
- Record: [Device ID addition] [DMI_MATCH entry enabling existing driver
  on new hardware]

**Step 2.4: Fix Quality**
- Obviously correct: just adds one DMI table entry with vendor "GPD" and
  product "G1618-05"
- Minimal/surgical: 8 lines, all in the DMI table
- Regression risk: Essentially zero. The entry only matches on the
  specific GPD Win 5 DMI strings. No other hardware affected.
- Record: [Obviously correct, trivially reviewable] [Zero regression
  risk to existing hardware]

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The `dmi_table[]` structure was introduced in commit `0ab88e2394392`
  (Sep 2025, v6.18) by Cryolitia PukNgae.
- Additional entries have been added in subsequent releases (Micro PC 2
  in v7.0).
- Record: [DMI table introduced in v6.18, exists in 7.0]

**Step 3.2: Fixes Tag**
- No Fixes: tag — expected for device ID additions.

**Step 3.3: File History**
- The driver was created in v6.18 and has had fixes and additions
  through v7.0.
- Between v6.18 and v7.0: 3 commits (Micro PC 2 support, subsystem
  locking fix, merge).
- The file is stable and well-maintained.
- Record: [Standalone commit, no prerequisites beyond the base driver
  existing in 7.0]

**Step 3.4: Author**
- Antheas Kapenekakis is a regular contributor to GPD/handheld Linux
  support, with commits to platform/x86 (oxpec), iommu, and HID
  subsystems.
- Not the subsystem maintainer, but a domain expert for GPD hardware.
- Record: [Domain expert for GPD hardware, active kernel contributor]

**Step 3.5: Dependencies**
- The commit only references `gpd_duo_drvdata` which exists in the 7.0
  tree (introduced in the original driver commit `0ab88e2394392`).
- No dependencies on any other patches.
- Record: [No dependencies. `gpd_duo_drvdata` already exists in 7.0.
  Standalone commit.]

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Original Patch**
- Link in commit:
  `https://lore.kernel.org/r/20260220161601.2344291-1-lkml@antheas.dev`
- Lore was blocked by Anubis anti-scraping. Could not fetch discussion
  directly.
- The patch was accepted by hwmon maintainer Guenter Roeck (Signed-off-
  by).
- Record: [Lore URL identified but inaccessible. Accepted by maintainer
  per SOB.]

**Step 4.2: Reviewers**
- Guenter Roeck (hwmon maintainer) signed off on the patch — this is the
  appropriate maintainer.
- Record: [hwmon maintainer accepted the patch]

**Step 4.3-4.5: Bug report / Related patches / Stable history**
- Not applicable — this is a device ID addition, not a bug fix. No bug
  report expected.
- Record: [N/A for device ID additions]

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Functions**
- No functions are modified. The change is to a static data table
  (`dmi_table[]`).
- The table is consumed by `dmi_first_match()` in `gpd_fan_init()`,
  which is the module init path.
- The matched `gpd_duo_drvdata` is used by existing code paths
  (`gpd_read_rpm()`, `gpd_write_pwm()`, `gpd_duo_write_pwm()`, etc.)
  that already handle the `duo` board type.
- Record: [Data-only change. All code paths that consume this data
  already exist and work for GPD Duo.]

**Step 5.5: Similar Patterns**
- The entire `dmi_table[]` follows the same pattern. There are 13
  existing entries that are structurally identical.
- Record: [Pattern is identical to all other DMI entries in the table]

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Does the code exist in stable trees?**
- The `gpd-fan` driver was introduced in v6.18. The 7.0 stable tree has
  the complete driver including `gpd_duo_drvdata`.
- Record: [Driver exists in 7.0.y. The `gpd_duo_drvdata` structure
  exists.]

**Step 6.2: Backport Complications**
- The patch should apply cleanly to 7.0.y. The `dmi_table[]` is largely
  unchanged since the driver was introduced, with minor additions (Micro
  PC 2 in 7.0).
- Record: [Expected clean apply to 7.0.y]

**Step 6.3: Related Fixes**
- No related fixes already in stable.
- Record: [No prior attempt to add GPD Win 5 support to stable]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
- `drivers/hwmon/` — hardware monitoring, specifically fan control for a
  handheld gaming device
- Criticality: PERIPHERAL (specific device driver), but for real users
  of GPD Win 5 handheld devices, fan control is critical for thermal
  management.
- Record: [hwmon, PERIPHERAL but important for device users]

**Step 7.2: Activity**
- The driver is actively maintained with regular additions and fixes.
- Record: [Active subsystem/driver]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
- Users of the GPD Win 5 handheld device running stable kernels.
- Without this patch, the device has no kernel fan control, which may
  mean fans stuck at default speeds or no thermal management.
- Record: [Driver-specific: GPD Win 5 users only]

**Step 8.2: Trigger**
- The DMI match is evaluated at module load time. Every GPD Win 5 user
  is affected.
- Record: [Every GPD Win 5 user is affected — automatic match on boot]

**Step 8.3: Severity**
- Without fan control: potential thermal issues, user has no way to
  control fan speed.
- This is hardware enablement rather than a crash fix, but fan control
  is essential for a handheld device.
- Record: [MEDIUM — no crash, but essential hardware functionality
  missing]

**Step 8.4: Risk-Benefit**
- BENEFIT: Enables fan control for all GPD Win 5 users on stable kernels
- RISK: Essentially zero — 8-line data-only change that only matches one
  specific DMI product ID
- Record: [High benefit for GPD Win 5 users, near-zero risk]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
- FOR: Device ID addition to existing driver (explicit exception
  category), trivially small (8 lines), data-only change, uses existing
  driver data structure, accepted by hwmon maintainer, zero regression
  risk, enables real hardware for real users.
- AGAINST: Not a bug fix per se — it's hardware enablement. The GPD Win
  5 is a very new device.
- UNRESOLVED: Could not access lore discussion due to Anubis protection.

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — trivial DMI table entry,
   accepted by maintainer, info from GPD.
2. Fixes a real bug that affects users? **Partial** — it's a device ID
   addition, which is an explicit exception.
3. Important issue? **For affected users, yes** — no fan control without
   this.
4. Small and contained? **YES** — 8 lines in one file, data-only.
5. No new features or APIs? **YES** — no new code, just a table entry.
6. Can apply to stable trees? **YES** — clean apply to 7.0.y expected.

**Step 9.3: Exception Category**
This falls into the **"New Device IDs"** exception category. Adding DMI
match entries to existing drivers is explicitly allowed in stable,
analogous to PCI/USB device IDs.

**Step 9.4: Decision**
This is a textbook device ID addition. The stable kernel rules
explicitly allow these. The change is 8 lines of data-only change, uses
an existing driver data structure (`gpd_duo_drvdata`), was accepted by
the hwmon maintainer, and enables fan control for a real shipping
device.

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author (Antheas Kapenekakis)
  and hwmon maintainer (Guenter Roeck). Link to lore present.
- [Phase 2] Diff analysis: +8 lines, single DMI_MATCH entry in
  dmi_table[] referencing existing `gpd_duo_drvdata`
- [Phase 3] git blame: `dmi_table[]` introduced in commit
  `0ab88e2394392` (v6.18, Sep 2025), exists in 7.0
- [Phase 3] git log: `gpd_duo_drvdata` structure confirmed present at
  line 74-84 of current file
- [Phase 3] Author check: Antheas Kapenekakis is active GPD/handheld
  contributor (multiple commits found)
- [Phase 3] Dependencies: `gpd_duo_drvdata` exists in 7.0 tree, no other
  prerequisites
- [Phase 4] Lore: URL identified
  (`20260220161601.2344291-1-lkml@antheas.dev`), inaccessible due to
  Anubis protection
- [Phase 5] Code analysis: data-only change to static table, consumed by
  `dmi_first_match()` in `gpd_fan_init()`, all code paths for `duo`
  board type already exist
- [Phase 6] Driver exists in 7.0.y (introduced v6.18), patch expected to
  apply cleanly
- [Phase 8] Risk assessment: 8-line data-only change, zero regression
  risk, high benefit for GPD Win 5 users
- UNVERIFIED: Could not read lore discussion to check for reviewer
  concerns or stable nomination

**YES**

 drivers/hwmon/gpd-fan.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/gpd-fan.c b/drivers/hwmon/gpd-fan.c
index 1729729b135f8..80de5f20781eb 100644
--- a/drivers/hwmon/gpd-fan.c
+++ b/drivers/hwmon/gpd-fan.c
@@ -209,6 +209,14 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = &gpd_duo_drvdata,
 	},
+	{
+		// GPD Win 5 with AMD AI MAX 395
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GPD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "G1618-05"),
+		},
+		.driver_data = &gpd_duo_drvdata,
+	},
 	{
 		// GPD Pocket 4
 		.matches = {
-- 
2.53.0

