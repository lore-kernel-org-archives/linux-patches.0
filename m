Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898DF3D647F;
	Mon, 20 Apr 2026 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691423; cv=none; b=i4/ZgFHVKXuem0IXoCX0hHRmEPx0tzJiCQa+hbDfgISOx9RrrqlgojDa+vtXtk39txAdUCfG9QnSd1dWxmPGyYJkPauhrGIHgjMOfJwVuRXjruLvJW6VzH6fnqcI8X44fPS54L7tZMwS+kGrE2o4/nGjCWxj7oafB146PVIE7dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691423; c=relaxed/simple;
	bh=HmVkddanjV40b6zd3ML51lSe6vmZoSzwh0EDddWFdhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjT7ME76d7qyD8QTLW04PDhSuY3a0oHyomF8qZzi+hO6HUhzIplQiifyxDHfZ54JK0WEAb9pFQOx1jDKeYSbhlVyTxrvcU59pzwEuilqxddwdP2E3YF8JQUoKltlcvXPqgzq2rbC+9sg178vcHREMmMSgsTZ5F1aRSrdjuh1mbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYHzTzpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYHzTzpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779C4C2BCB7;
	Mon, 20 Apr 2026 13:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691423;
	bh=HmVkddanjV40b6zd3ML51lSe6vmZoSzwh0EDddWFdhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYHzTzpZyxMyF+bhzk/3kMSOTOBcYGKP9kHX/v2HPgcjbN53RGM7/D63xdLE4Woh/
	 nUtmiQUzOass9jLkJm83LjYZZLS1ReHAv38awr4plzjlUHsbu6QAXq7v73+Q2rmdgJ
	 JAIy/TB1/5Lbt6YdhezbeMOY7XG0+w8zj7At+2tbt/7q2TMLVuSM+8oYQhmwMdjzON
	 gOgFh6kjkf6Ou8W3NqnEAJWmrpLaRVOCp6nnxwRcbtdjMBpW0KTqQ7hXe1xldU/qnW
	 myZXWHh01k3YN+T7oYt5qp2HqvLeo7TD5OEdpPnh+vMgcdx6V+YLVizhxmSF6BAbzR
	 ZpXl/iAwc0q2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Denis Pauk <pauk.denis@gmail.com>,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20B=C5=BEatek?= <bugs@bzatek.net>,
	Theunis Scheepers <ptscheepers@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] hwmon: (nct6775) Add ASUS X870/W480 to WMI monitoring list
Date: Mon, 20 Apr 2026 09:16:52 -0400
Message-ID: <20260420132314.1023554-18-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 21518579cbdeb4e86a6fffbc3d52f52bd74ab87e ]

Boards such as
* G15CE,
* PRIME X870-P WIFI,
* PRIME X870-P,
* Pro WS W480-ACE,
* ProArt X870E-CREATOR WIFI,
* ROG CROSSHAIR X870E APEX,
* ROG CROSSHAIR X870E DARK HERO,
* ROG CROSSHAIR X870E EXTREME,
* ROG CROSSHAIR X870E GLACIAL,
* ROG CROSSHAIR X870E HERO BTF,
* ROG CROSSHAIR X870E HERO,
* ROG STRIX X870-A GAMING WIFI,
* ROG STRIX X870-F GAMING WIFI,
* ROG STRIX X870-I GAMING WIFI,
* ROG STRIX X870E-E GAMING WIFI,
* ROG STRIX X870E-E GAMING WIFI7 R2,
* TUF GAMING X870-PLUS WIFI,
* TUF GAMING X870-PRO WIFI7 W NEO,
* TUF GAMING X870E-PLUS WIFI7,
* W480/SYS,
* X870 AYW GAMING WIFI W,
* X870 MAX GAMING WIFI7 W,
* X870 MAX GAMING WIFI7
have got a nct6775 chip, but by default there's no use of it because of
resource conflict with WMI method.

Add the boards to the WMI monitoring list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Tested-by: Tomáš Bžatek <bugs@bzatek.net>
Tested-by: Theunis Scheepers <ptscheepers@gmail.com>
Link: https://lore.kernel.org/r/20260322131848.6261-1-pauk.denis@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `hwmon: (nct6775)`
- Action verb: "Add" — adding board names to whitelist
- Summary: Add 23 ASUS X870 and W480 motherboard names to the WMI
  monitoring board lists

**Step 1.2: Tags**
- `Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807` — long-
  running bug tracking nct6775 WMI access on ASUS boards
- `Signed-off-by: Denis Pauk <pauk.denis@gmail.com>` — author, primary
  maintainer of this WMI board list
- `Tested-by: Tomáš Bžatek <bugs@bzatek.net>` — independent tester
- `Tested-by: Theunis Scheepers <ptscheepers@gmail.com>` — second
  independent tester
- `Link:
  https://lore.kernel.org/r/20260322131848.6261-1-pauk.denis@gmail.com`
  — lore thread
- `Signed-off-by: Guenter Roeck <linux@roeck-us.net>` — hwmon subsystem
  maintainer

Record: Two independent testers, hwmon maintainer sign-off, bug tracker
reference. Strong quality signals.

**Step 1.3: Body Text**
The commit explains that these ASUS boards have nct6775-compatible chips
but "by default there's no use of it because of resource conflict with
WMI method." Without the board name in the whitelist, the driver can't
use WMI to access the hardware monitoring chip, so users get zero sensor
data.

Record: Bug = no hardware monitoring on popular boards due to ACPI/WMI
resource conflict. Symptom = sensors completely unavailable.

**Step 1.4: Hidden Bug Fix Detection**
This is not a hidden bug fix — it's explicitly an enablement for
hardware that is inaccessible without the whitelist entry. This falls
squarely in the "hardware quirk/workaround" exception category.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/hwmon/nct6775-platform.c`)
- Lines added: ~23 string entries across two `const char *` arrays
- Lines removed: 0
- Functions modified: 0 — only data arrays changed
- Scope: Pure data addition, single file, no logic changes

**Step 2.2: Code Flow Change**
- `asus_wmi_boards[]`: 2 entries added ("Pro WS W480-ACE", "W480/SYS")
- `asus_msi_boards[]`: ~21 entries added (G15CE, various X870 boards,
  ProArt X870E, ROG CROSSHAIR X870E variants, ROG STRIX X870 variants,
  TUF GAMING X870 variants, X870 AYW/MAX variants)
- Both arrays are used in `sensors_nct6775_platform_init()` via
  `match_string()` to determine whether WMI access should be used
  instead of direct I/O port access.
- No control flow, no error handling, no locking changes.

**Step 2.3: Bug Mechanism**
Category: Hardware workaround / device ID addition. Board names are
added to static `const` whitelist arrays. When the board DMI name
matches an entry, the driver uses WMI to access the nct6775 chip instead
of direct I/O (which is blocked by ACPI resource claims).

**Step 2.4: Fix Quality**
- Obviously correct: string literals added in alphabetical order to
  const arrays
- Minimal/surgical: only data, zero logic
- Regression risk: zero — adding new strings cannot affect behavior for
  existing boards
- No red flags whatsoever

---

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The `asus_wmi_boards[]` array originates from commit c3963bc0a0cf9
(v5.19-rc1, platform split). The `asus_msi_boards[]` array originates
from commit e2e09989ccc21 (v6.3-rc1). Both have been incrementally
expanded with each new board generation, with ~20 prior similar commits
by Denis Pauk and others.

**Step 3.2: Fixes tag**
No Fixes: tag (expected for this type of commit — it's an enablement,
not a code fix).

**Step 3.3: File History**
20+ prior commits adding board names to these arrays. This is a well-
established, routine pattern. Recent commits include:
- 246167b17c14e: Add ASUS Pro WS WRX90E-SAGE SE
- 03897f9baf3ee: Add ASUS ROG STRIX X870E-H GAMING WIFI7
- ccae49e5cf6eb: Add 665-ACE/600M-CL
- 1f432e4cf1dd3: Add G15CF

**Step 3.4: Author**
Denis Pauk is the primary author of the WMI access support and has
authored the vast majority of board list additions (12+ commits). He is
the de facto maintainer of this feature.

**Step 3.5: Dependencies**
No dependencies. The commit is a pure addition of string constants. No
new functions, no API changes, no prerequisite commits needed.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.2: Patch Discussion**
The lore.kernel.org and bugzilla sites were behind anti-bot protection;
however, web search confirmed:
- Bug 204807 is a long-running tracker (since ~2019) for ASUS boards
  where nct6775 sensors don't work without `acpi_enforce_resources=lax`
- The WMI access method was the proper fix, implemented in v5.16
- Board lists are updated as new ASUS models are released
- Guenter Roeck (hwmon maintainer) reviewed and applied

**Step 4.3: Bug Report**
Bugzilla #204807 is a well-documented, long-standing issue affecting
many ASUS users. The commit message and two Tested-by tags confirm real
users need this.

**Step 4.4-4.5: Related Patches**
This is a standalone patch — no series dependencies. Previous identical-
pattern patches have been applied regularly.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Function Impact**
The modified arrays are referenced only in
`sensors_nct6775_platform_init()` (lines 1521-1531) via
`match_string()`. The call chain is:
1. `module_init(sensors_nct6775_platform_init)` — called once at driver
   load
2. DMI board name is compared against whitelist
3. If match, `nct6775_determine_access()` is called to probe WMI method
4. If WMI works, sensor access uses WMI instead of direct I/O

The change only adds new match targets. Existing matches are completely
unaffected.

**Step 5.5: Similar Patterns**
20+ identical pattern commits exist in the git history. This is routine
maintenance of a device whitelist.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence**
- Both `asus_wmi_boards[]` and `asus_msi_boards[]` exist in the 7.0 tree
  (and 6.6.y, 6.12.y)
- The `asus_msi_boards[]` was introduced in v6.3, so it exists in 6.6.y
  and later
- For 6.1.y, only `asus_wmi_boards[]` entries would apply (2 entries)

**Step 6.2: Backport Complications**
Minimal. The patch adds strings in alphabetical order. The only context
dependency is the surrounding existing strings. The "ROG STRIX X870E-H
GAMING WIFI7" entry (03897f9baf3ee) is already in the 7.0 tree at line
1407, which provides a context anchor. The patch should apply cleanly or
with trivial offset adjustments.

**Step 6.3: Related Fixes Already in Stable**
No — these specific X870/W480 board names are not in any stable tree
yet.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
- Subsystem: `drivers/hwmon` — hardware monitoring
- Criticality: PERIPHERAL (but widely used — temperatures, fan speeds,
  voltages)
- Without this fix, users of these popular boards cannot monitor
  hardware health

**Step 7.2: Activity**
Active subsystem with regular board list updates. The file sees routine
additions every few months.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Users of 23 specific ASUS motherboard models. These are popular consumer
and workstation boards (X870 is current-gen AMD AM5 platform, W480 is
Intel workstation).

**Step 8.2: Trigger**
Every boot on affected hardware. Without this patch, the driver silently
falls back to direct I/O access, which fails due to ACPI resource
conflict, resulting in no sensor data at all.

**Step 8.3: Severity**
- Failure mode: Complete loss of hardware monitoring capability
- Severity: MEDIUM — no crash or data corruption, but hardware
  monitoring is a core system management feature

**Step 8.4: Risk-Benefit**
- BENEFIT: HIGH — enables hardware monitoring on popular current-gen
  motherboards for all stable users
- RISK: NEAR-ZERO — pure string additions to const arrays, cannot affect
  other boards, zero logic changes
- Ratio: Overwhelmingly favorable

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Classic hardware quirk/device ID addition pattern
- Zero logic changes — only const string array additions
- Two independent Tested-by tags
- hwmon maintainer (Guenter Roeck) signed off
- Fixes real issue for popular current-gen hardware
- Long-established pattern with 20+ identical prior commits
- References well-known bugzilla bug #204807
- No regression risk

AGAINST backporting:
- (None identified)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — string additions, two testers
2. Fixes a real bug? **YES** — hardware monitoring inaccessible on
   affected boards
3. Important issue? **MEDIUM** — not a crash, but total loss of hwmon on
   popular boards
4. Small and contained? **YES** — single file, pure data, ~23 lines of
   strings
5. No new features or APIs? **YES** — adds IDs to existing mechanism
6. Can apply to stable? **YES** — clean apply expected

**Step 9.3: Exception Category**
**YES** — This is a hardware quirk/workaround addition (board names to
existing WMI whitelist). This is explicitly listed as an exception that
IS allowed in stable.

---

## Verification

- [Phase 1] Parsed tags: found 2x Tested-by, Link to bugzilla #204807,
  maintainer SOB from Guenter Roeck
- [Phase 2] Diff analysis: ~23 string literals added to
  `asus_wmi_boards[]` (2 entries) and `asus_msi_boards[]` (21 entries),
  zero logic changes
- [Phase 3] git blame: `asus_wmi_boards[]` introduced in c3963bc0a0cf9
  (v5.19-rc1), `asus_msi_boards[]` in e2e09989ccc21 (v6.3-rc1)
- [Phase 3] git log: confirmed 20+ prior identical-pattern board
  addition commits by Denis Pauk
- [Phase 3] Author Denis Pauk: confirmed as primary maintainer of this
  WMI board list feature (12+ commits)
- [Phase 4] WebSearch: confirmed bugzilla #204807 is long-running
  tracker for ASUS nct6775 WMI access issues
- [Phase 4] b4 dig/lore: anti-bot protection prevented direct thread
  access, but maintainer sign-off and metadata verified
- [Phase 5] Code trace: arrays used only in
  `sensors_nct6775_platform_init()` via `match_string()`, single
  callsite
- [Phase 6] Both arrays exist in 7.0 tree, `asus_msi_boards[]` exists in
  6.6.y+
- [Phase 6] "ROG STRIX X870E-H GAMING WIFI7" already present at line
  1407, confirming context compatibility
- [Phase 8] Failure mode: complete loss of hardware monitoring on
  affected boards, severity MEDIUM
- [Phase 8] Risk: near-zero — pure const data addition

**YES**

 drivers/hwmon/nct6775-platform.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 555029dfe713f..1975399ac440d 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1159,6 +1159,7 @@ static const char * const asus_wmi_boards[] = {
 	"Pro A520M-C",
 	"Pro A520M-C II",
 	"Pro B550M-C",
+	"Pro WS W480-ACE",
 	"Pro WS X570-ACE",
 	"ProArt B550-CREATOR",
 	"ProArt X570-CREATOR WIFI",
@@ -1258,6 +1259,7 @@ static const char * const asus_wmi_boards[] = {
 	"TUF Z390-PRO GAMING",
 	"TUF Z390M-PRO GAMING",
 	"TUF Z390M-PRO GAMING (WI-FI)",
+	"W480/SYS",
 	"WS Z390 PRO",
 	"Z490-GUNDAM (WI-FI)",
 };
@@ -1270,6 +1272,7 @@ static const char * const asus_msi_boards[] = {
 	"EX-B760M-V5 D4",
 	"EX-H510M-V3",
 	"EX-H610M-V3 D4",
+	"G15CE",
 	"G15CF",
 	"PRIME A620M-A",
 	"PRIME B560-PLUS",
@@ -1320,6 +1323,8 @@ static const char * const asus_msi_boards[] = {
 	"PRIME X670-P",
 	"PRIME X670-P WIFI",
 	"PRIME X670E-PRO WIFI",
+	"PRIME X870-P",
+	"PRIME X870-P WIFI",
 	"PRIME Z590-A",
 	"PRIME Z590-P",
 	"PRIME Z590-P WIFI",
@@ -1362,11 +1367,18 @@ static const char * const asus_msi_boards[] = {
 	"ProArt B660-CREATOR D4",
 	"ProArt B760-CREATOR D4",
 	"ProArt X670E-CREATOR WIFI",
+	"ProArt X870E-CREATOR WIFI",
 	"ProArt Z690-CREATOR WIFI",
 	"ProArt Z790-CREATOR WIFI",
 	"ROG CROSSHAIR X670E EXTREME",
 	"ROG CROSSHAIR X670E GENE",
 	"ROG CROSSHAIR X670E HERO",
+	"ROG CROSSHAIR X870E APEX",
+	"ROG CROSSHAIR X870E DARK HERO",
+	"ROG CROSSHAIR X870E EXTREME",
+	"ROG CROSSHAIR X870E GLACIAL",
+	"ROG CROSSHAIR X870E HERO",
+	"ROG CROSSHAIR X870E HERO BTF",
 	"ROG MAXIMUS XIII APEX",
 	"ROG MAXIMUS XIII EXTREME",
 	"ROG MAXIMUS XIII EXTREME GLACIAL",
@@ -1404,6 +1416,11 @@ static const char * const asus_msi_boards[] = {
 	"ROG STRIX X670E-E GAMING WIFI",
 	"ROG STRIX X670E-F GAMING WIFI",
 	"ROG STRIX X670E-I GAMING WIFI",
+	"ROG STRIX X870-A GAMING WIFI",
+	"ROG STRIX X870-F GAMING WIFI",
+	"ROG STRIX X870-I GAMING WIFI",
+	"ROG STRIX X870E-E GAMING WIFI",
+	"ROG STRIX X870E-E GAMING WIFI7 R2",
 	"ROG STRIX X870E-H GAMING WIFI7",
 	"ROG STRIX Z590-A GAMING WIFI",
 	"ROG STRIX Z590-A GAMING WIFI II",
@@ -1451,6 +1468,9 @@ static const char * const asus_msi_boards[] = {
 	"TUF GAMING H770-PRO WIFI",
 	"TUF GAMING X670E-PLUS",
 	"TUF GAMING X670E-PLUS WIFI",
+	"TUF GAMING X870-PLUS WIFI",
+	"TUF GAMING X870-PRO WIFI7 W NEO",
+	"TUF GAMING X870E-PLUS WIFI7",
 	"TUF GAMING Z590-PLUS",
 	"TUF GAMING Z590-PLUS WIFI",
 	"TUF GAMING Z690-PLUS",
@@ -1460,6 +1480,9 @@ static const char * const asus_msi_boards[] = {
 	"TUF GAMING Z790-PLUS D4",
 	"TUF GAMING Z790-PLUS WIFI",
 	"TUF GAMING Z790-PLUS WIFI D4",
+	"X870 AYW GAMING WIFI W",
+	"X870 MAX GAMING WIFI7",
+	"X870 MAX GAMING WIFI7 W",
 	"Z590 WIFI GUNDAM EDITION",
 };
 
-- 
2.53.0

