Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621543AEF24;
	Mon, 20 Apr 2026 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692010; cv=none; b=f1IlN4gooq7T+4IKwO14iCIveXMcTfHmpRoSHKukA17Kv7yAywA1DeFq6pPw20VFMu5ZCFsgsPR4lo4zefV3f0/993ilZCfGoylI15r/1p8Y7wKB4wZ3M2nFUQRe1U3dhqp0/Gnf0ILmwEPqsujiHErVTAQzV4rYy9YtbjmkS44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692010; c=relaxed/simple;
	bh=Du06ac2FcfYd7216GCViyqlHCDb4mvvk3Gt9wFBHM0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOuJuI1S/ZH078vzkdJ/Ym0o7pF/uil4nsziHc1+HE8OSH+sjIdERvgENRf81n5Am1WBH+imIvNaRvz3A+muPLaL4/vwfVC4JFRIvxHJKk+WK17iT+F7HeWtYtgbqvrxXrVrn9g85kHsnAKw8MFqUH9LosjOMwUe2eo+0mKktuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZ45FN+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZ45FN+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C0BC19425;
	Mon, 20 Apr 2026 13:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692010;
	bh=Du06ac2FcfYd7216GCViyqlHCDb4mvvk3Gt9wFBHM0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ45FN+0RG7uSF/fF7DKqJX81g3lJWqjCMbGa5ug9UhEllaYkmUh4fY7t1CyQ0mcp
	 kDAGgzGVGdANebqOz6nO2CjnN005avC5hGW9wMU1UCDzpQlYHKWctv1zrbCJZnk/ZV
	 EpyCeEA+IGiW8if7Z2RmjCpOrCM5F1qcv9Q69CXpfit8ZPoRe2kUQT31xFOI5TOTng
	 1yV03N+PBVpxnk9euQoz1fAxMaNDWQkMslTo25vlMhXHchQKeapCi0/qdrvtPZMxoa
	 B8LSD5CqcAKULDjOTvXPOS7OmMa2aeUrIvOuT6O4BvXlBCG2woQzyQWiRm1NRstItz
	 ixhYxkpgQVT2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Petr Klotz <pklotz0@protonmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] hwmon: (nct6683) Add customer ID for ASRock B650I Lightning WiFi
Date: Mon, 20 Apr 2026 09:21:54 -0400
Message-ID: <20260420132314.1023554-320-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Petr Klotz <pklotz0@protonmail.com>

[ Upstream commit ff708b549c4dbecb308fa97e360a8fe0b2f89309 ]

The ASRock B650I Lightning WiFi motherboard uses an NCT6686D chip with a
customer ID of 0x1633. Without this ID, the nct6683 driver fails to
recognize the hardware on this board, preventing hardware monitoring
from working.

Add NCT6683_CUSTOMER_ID_ASROCK6 (0x1633) to the list of supported customer
IDs and update the probe function to handle it

Signed-off-by: Petr Klotz <pklotz0@protonmail.com>
Link: https://lore.kernel.org/r/20260412000911.9063-2-pklotz0@protonmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem:** hwmon (nct6683)
- **Action verb:** "Add" (customer ID)
- **Summary:** Add customer ID for ASRock B650I Lightning WiFi
  motherboard

Record: [hwmon/nct6683] [Add] [New customer ID 0x1633 for ASRock B650I
Lightning WiFi]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by:** Petr Klotz <pklotz0@protonmail.com> (author)
- **Link:**
  https://lore.kernel.org/r/20260412000911.9063-2-pklotz0@protonmail.com
- **Signed-off-by:** Guenter Roeck <linux@roeck-us.net> (subsystem
  maintainer / committer)
- No Fixes: tag (expected for manual review candidates)
- No Cc: stable (expected)
- No Reported-by (author is the user who needs this)

Record: Author is Petr Klotz, applied by Guenter Roeck (hwmon
maintainer). No Fixes/stable tags (expected).

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit message states:
- The ASRock B650I Lightning WiFi uses an NCT6686D chip with customer ID
  0x1633
- Without this ID, the nct6683 driver fails to recognize the hardware
  (returns -ENODEV)
- This prevents hardware monitoring from working on this board

Record: Bug = driver fails to instantiate on a real board. Symptom = no
hwmon support. Root cause = customer ID 0x1633 not in the allowlist.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is not a hidden fix - it's a straightforward device ID addition to
enable hardware support on a specific board. This falls into the "NEW
DEVICE IDs" exception category.

Record: Not a hidden fix. Classic hardware ID addition.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **Files changed:** 1 (`drivers/hwmon/nct6683.c`)
- **Lines added:** 3 (one #define, two lines for `case` statement)
- **Lines removed:** 0
- **Functions modified:** `nct6683_probe()` (adding a case to an
  existing switch)
- **Scope:** Single-file, surgical, trivially small

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Hunk 1** (line ~185): Adds `#define NCT6683_CUSTOMER_ID_ASROCK6
0x1633` to the list of known customer IDs. Pure definition, no behavior
change by itself.

**Hunk 2** (line ~1248): Adds `case NCT6683_CUSTOMER_ID_ASROCK6: break;`
to the probe function's customer ID switch statement. Before: customer
ID 0x1633 falls through to `default`, which returns -ENODEV (unless
force=1). After: 0x1633 is recognized and the probe continues normally.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Category:** Hardware enablement / device ID addition

The switch statement in `nct6683_probe()` acts as an allowlist. Without
the ID, the `default` case returns `-ENODEV`, preventing the driver from
loading. Adding the case enables the driver for this specific board.

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct?** YES - identical to 10+ previous customer ID
  additions
- **Minimal/surgical?** YES - 3 lines, one define + one case statement
- **Regression risk?** Essentially zero - the new case only matches a
  single specific hardware ID and does nothing different from all other
  ASRock cases
- **Red flags?** None

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The customer ID area was last modified by commit c0fa7879c985 (ASROCK5,
Dec 2025). The switch statement follows the same pattern since the
driver's creation in 2014 (41082d66bfd6).

Record: Driver exists since v3.16 (2014). Customer ID mechanism
unchanged since inception.

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present (expected - this is an ID addition, not a bug fix
per se).

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
There have been 10+ identical customer ID additions to this driver:
- ASROCK (0xe2c) - v5.12
- ASROCK2 (0xe1b) - v5.15
- ASROCK3 (0x1631) - v6.7
- ASROCK4 (0x163e) - v6.14
- ASROCK5 (0x1621) - v7.0-rc1
- MSI through MSI4, AMD, MITAC, INTEL - various versions

This is a well-established pattern with the exact same structure every
time.

Record: Standalone commit. No prerequisites. Follows established
pattern.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Petr Klotz is not the subsystem maintainer. This appears to be a first-
time or infrequent contributor submitting a board-specific ID. However,
Guenter Roeck (the hwmon maintainer) applied it, lending credibility.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
No dependencies. The patch adds a #define and a case to an existing
switch. It applies cleanly to any version that has the customer ID
switch structure (all versions since v3.16).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.2: FIND THE ORIGINAL PATCH DISCUSSION
The Link tag points to `20260412000911.9063-2-pklotz0@protonmail.com`.
Lore.kernel.org was behind Anubis protection during fetch. However, the
commit was applied by Guenter Roeck, the hwmon subsystem maintainer,
confirming it passed review.

The "-2" in the message ID suggests this was patch 2 of a series.

### Step 4.3: BUG REPORT
No separate bug report - the author is the user affected. This is
typical for hardware ID additions.

### Step 4.4-4.5: RELATED PATCHES AND STABLE HISTORY
Similar customer ID additions have been routinely backported to stable
trees. This is standard practice for device enablement.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
Only `nct6683_probe()` is modified (adding a case to an existing
switch).

### Step 5.2: TRACE CALLERS
`nct6683_probe()` is called by the platform driver subsystem during
device enumeration - a standard, well-tested path.

### Step 5.3-5.4: CALL CHAIN
The probe function reads the customer ID from hardware register 0x602,
then checks it against the allowlist. If not found and `force` is not
set, it returns -ENODEV. This is the normal device discovery path.

### Step 5.5: SIMILAR PATTERNS
Identical pattern seen in all 10+ previous customer ID additions. No
unique concerns.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
YES. The nct6683 driver with the customer ID switch exists in all active
stable trees:
- **v6.1.y:** Has INTEL, MITAC, MSI, ASROCK, ASROCK2
- **v6.6.y:** Has INTEL, MITAC, MSI, MSI2, ASROCK, ASROCK2
- **v6.12.y:** Has INTEL, MITAC, MSI, MSI2, MSI3, ASROCK through ASROCK3

All versions have the switch structure and the `default: return -ENODEV`
path.

### Step 6.2: BACKPORT COMPLICATIONS
The patch will need trivial context adjustment since each stable tree
has a different number of existing customer IDs. However, the pattern is
identical: add a #define and a case. This is a trivial conflict to
resolve.

### Step 6.3: RELATED FIXES ALREADY IN STABLE
No fix for this specific board (0x1633) exists in stable.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem:** drivers/hwmon (hardware monitoring)
- **Criticality:** PERIPHERAL to IMPORTANT - hwmon is used on all
  server/desktop boards for temperature/fan monitoring. ASRock B650I is
  a consumer AM5 motherboard (AMD Ryzen).

### Step 7.2: SUBSYSTEM ACTIVITY
The nct6683 driver is actively maintained with regular customer ID
additions (the most recent being Dec 2025). Guenter Roeck is the active
maintainer.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
Users of the ASRock B650I Lightning WiFi motherboard who want hardware
monitoring. This is a consumer AM5 board, so it has a real user
population.

### Step 8.2: TRIGGER CONDITIONS
Every boot on the affected hardware. The driver will always fail to
probe without this ID.

### Step 8.3: FAILURE MODE SEVERITY
Without this patch: hardware monitoring completely non-functional on
this board. Severity: LOW-MEDIUM (not a crash or security issue, but a
real hardware enablement problem). Users can work around with `force=1`
module parameter, but this is non-obvious.

### Step 8.4: RISK-BENEFIT RATIO
- **BENEFIT:** Enables hwmon for a real board. Trivial, well-tested
  pattern.
- **RISK:** Essentially zero. 3 lines, no logic change, only affects one
  specific hardware ID.
- **Ratio:** Very favorable for backporting.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILED

**FOR backporting:**
- Textbook device ID addition to an existing driver (explicit exception
  in stable rules)
- 3 lines total, minimal and obviously correct
- Follows the exact pattern of 10+ previous identical commits
- Enables hardware monitoring on a real consumer motherboard
- Applied by subsystem maintainer (Guenter Roeck)
- Driver exists in all active stable trees
- Zero regression risk

**AGAINST backporting:**
- Not a crash/security/corruption fix
- Cosmetically, it's "adding support" not "fixing a bug"
- Patch needs minor context adjustment for older stable trees (trivial)

### Step 9.2: STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES - identical pattern to 10+
   previous commits, applied by maintainer
2. **Fixes a real bug?** YES - enables hardware monitoring on real
   hardware that is otherwise blocked
3. **Important issue?** MODERATE - hardware completely non-functional
   without it
4. **Small and contained?** YES - 3 lines in one file
5. **No new features or APIs?** CORRECT - just a device ID to an
   existing driver
6. **Can apply to stable?** YES with trivial context adjustments

### Step 9.3: EXCEPTION CATEGORY
**YES - Device ID addition to existing driver.** This is explicitly
listed as an exception that IS allowed in stable despite being an
"addition."

### Step 9.4: DECISION
This is a textbook device ID addition. The stable kernel rules
explicitly allow these because they are trivial, risk-free, and enable
real hardware for real users.

---

## Verification

- [Phase 1] Parsed commit message: author Petr Klotz, applied by Guenter
  Roeck (hwmon maintainer), Link to lore present
- [Phase 2] Diff analysis: 3 lines added - one #define
  (NCT6683_CUSTOMER_ID_ASROCK6 0x1633) and one case statement in
  nct6683_probe()
- [Phase 3] git blame: customer ID mechanism originates from
  41082d66bfd6 (v3.16, 2014), last ASRock ID added in c0fa7879c985 (Dec
  2025)
- [Phase 3] git log history: confirmed 10+ identical customer ID
  additions following the same pattern
- [Phase 4] Lore fetch failed (Anubis protection), but Link tag confirms
  accepted submission; commit applied by subsystem maintainer
- [Phase 4] Web search: confirmed pattern of customer ID additions is
  routine for this driver
- [Phase 5] nct6683_probe() is the only function modified; standard
  platform driver probe path
- [Phase 6] Verified driver exists in v6.1, v6.6, v6.12 stable trees via
  `git show v6.X:drivers/hwmon/nct6683.c`; all have the customer ID
  switch with the default: return -ENODEV path
- [Phase 6] Minor context conflicts expected due to differing number of
  existing IDs per stable tree (trivial to resolve)
- [Phase 8] Risk: essentially zero. Benefit: enables hwmon on real
  ASRock B650I Lightning WiFi board
- UNVERIFIED: Could not read the full lore discussion thread due to
  Anubis protection; however, maintainer acceptance is confirmed by
  Guenter Roeck's SOB

**YES**

 drivers/hwmon/nct6683.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/nct6683.c b/drivers/hwmon/nct6683.c
index 4a83804140386..0581770380cc5 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -182,6 +182,7 @@ superio_exit(int ioreg)
 #define NCT6683_CUSTOMER_ID_ASROCK3	0x1631
 #define NCT6683_CUSTOMER_ID_ASROCK4	0x163e
 #define NCT6683_CUSTOMER_ID_ASROCK5	0x1621
+#define NCT6683_CUSTOMER_ID_ASROCK6	0x1633
 
 #define NCT6683_REG_BUILD_YEAR		0x604
 #define NCT6683_REG_BUILD_MONTH		0x605
@@ -1245,6 +1246,8 @@ static int nct6683_probe(struct platform_device *pdev)
 		break;
 	case NCT6683_CUSTOMER_ID_ASROCK5:
 		break;
+	case NCT6683_CUSTOMER_ID_ASROCK6:
+		break;
 	default:
 		if (!force)
 			return -ENODEV;
-- 
2.53.0

