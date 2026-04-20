Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F190F3CB2D9;
	Mon, 20 Apr 2026 13:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691064; cv=none; b=p4Mm6i4bI8DP26ewDAyWShHAs67yGd/bUBact1ecsnPXNo0Gouvmov11UPKMBUbevcDuky7vlEeaa66wLdYN4txe+ZOz1p/qK+ZelZvVIa3h8psNf28eGarUzFHdbHrceDZJh+P4nupgGPr65V7wRXmvZfFA83BOPdQqPBxSpmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691064; c=relaxed/simple;
	bh=kgfq54QGG2g58urvUeBUMahf9u493TsnAKZki1DT03Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj5sfEJ01occkvimGeuaNuMVEjMV1zdzcG3FyTaQY9j+02o4rYsT+SUxY9FX5N89kz7d6pGQR72dO70jfoIwXq+kF92umNa0rWtFtK4P6zyyLdC1e5Pk1FgVxyp3LAQB15fnh6eejTWG6KFmpGG/JVZpRpYxhhR9K7ki2Zj725A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uiqL3gbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uiqL3gbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C336C2BCB4;
	Mon, 20 Apr 2026 13:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691063;
	bh=kgfq54QGG2g58urvUeBUMahf9u493TsnAKZki1DT03Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiqL3gbWk+jJbU+nFLsHg44O6xpCrh75V1QgBnS3AGwB/Xf8GL3waJ60JGIPwnI6C
	 IpL0X/ChLtZCwgQxNnz+K59M/k/MtqljVmHFEl8vFVlfjca7Iclj6zrfvFzjhs8lwh
	 4bTBoFMEj0GmYj8WTxpVrut/hdK3vsJV+AnwZfaezpdNBPwKd/iCfUGksk3oQWgksg
	 j+5PmHNuNQxp9SLzUAjOudPtQ25efXleufy+xPUdw2QoxOJQNSDfMApkQtLdA/0zYK
	 jNREtu2fxD0QkaikZa+ZVkzWp30c9yfPmFaVpjey2y2X+g2shxSaq4YFp+ah1GdIUL
	 OcUdC0VAqXrIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dawei Liu <dawei.liu.jy@renesas.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	jdelvare@suse.com,
	corbet@lwn.net,
	linux-hwmon@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] hwmon: (pmbus/isl68137) Add support for Renesas RAA228942 and RAA228943
Date: Mon, 20 Apr 2026 09:08:58 -0400
Message-ID: <20260420131539.986432-72-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Dawei Liu <dawei.liu.jy@renesas.com>

[ Upstream commit 7c760db74c9f30da7281c7f450d0676ec78ec3e6 ]

Add I2C device IDs for Renesas RAA228942 and RAA228943.

At the Linux PMBus hwmon interface level currently supported by this
driver, these devices are compatible with the existing 2-rail non-TC
controllers, so devicetree will use fallback compatibles and no
dedicated OF match entries are needed.

Signed-off-by: Dawei Liu <dawei.liu.jy@renesas.com>
Link: https://lore.kernel.org/r/20260325090208.857-3-dawei.liu.jy@renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `hwmon: (pmbus/isl68137)`
- Action verb: "Add support"
- Summary: Add I2C device IDs for two new Renesas voltage regulators
  (RAA228942 and RAA228943)
- Record: This is a device ID addition, not a bug fix.

**Step 1.2: Tags**
- Signed-off-by: Dawei Liu <dawei.liu.jy@renesas.com> (author, Renesas
  employee)
- Link: lore.kernel.org mail link
- Signed-off-by: Guenter Roeck <linux@roeck-us.net> (hwmon subsystem
  maintainer - accepted the patch)
- No Fixes: tag (expected for candidates)
- No Cc: stable (expected for candidates)
- No Reported-by, Tested-by, or Reviewed-by

**Step 1.3: Commit Body**
- States that these devices "are compatible with the existing 2-rail
  non-TC controllers"
- Explicitly says "devicetree will use fallback compatibles and no
  dedicated OF match entries are needed"
- This is a pure hardware enablement addition

**Step 1.4: Hidden Bug Fix?**
- No. This is not a hidden bug fix. It is straightforward device ID
  addition.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `Documentation/hwmon/isl68137.rst`: +20 lines (documentation for two
  new devices)
- `drivers/hwmon/pmbus/isl68137.c`: +2 lines (two I2C device ID table
  entries)
- Total: +22 lines, 0 removed
- Scope: Trivially small, single-file code change + docs

**Step 2.2: Code Flow**
- Two entries added to the `raa_dmpvr_id[]` I2C device ID table:
  - `{"raa228942", raa_dmpvr2_2rail_nontc}`
  - `{"raa228943", raa_dmpvr2_2rail_nontc}`
- These use the existing `raa_dmpvr2_2rail_nontc` variant, which was
  introduced in commit 51fb91ed5a6fa (v5.10 era). The variant disables
  `TEMP3` and configures 2-page mode.
- No new code paths, no new functions, no logic changes

**Step 2.3: Bug Mechanism**
- Category: Hardware device ID addition (exception category h)
- Without these IDs, the kernel cannot bind the existing ISL68137 PMBus
  driver to these Renesas parts

**Step 2.4: Fix Quality**
- Obviously correct: merely adding two string/enum pairs to an existing
  table
- Minimal and surgical
- Zero regression risk: only affects systems with these specific I2C
  devices
- No new code paths, APIs, or behavioral changes

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- The `raa_dmpvr_id[]` table has been present since commit f621d61fd59f4
  (2020). The `raa_dmpvr2_2rail_nontc` variant was added in commit
  51fb91ed5a6fa (2020, v5.10 era).
- Both are present in all active stable trees (5.10+, 5.15+, 6.1+, 6.6+)

**Step 3.2: Fixes Tag**
- No Fixes: tag (not applicable - this is a device ID addition, not a
  bug fix)

**Step 3.3: File History**
- Prior identical-pattern commit: 2190ad55a601d added RAA228244 and
  RAA228246 in the same manner. This was a v6.18/6.19 timeframe commit.
- The pattern of adding new Renesas device IDs to this driver is well
  established.

**Step 3.4: Author**
- Dawei Liu is a Renesas employee (dawei.liu.jy@renesas.com),
  appropriate for submitting Renesas device support.

**Step 3.5: Dependencies**
- No dependencies. The `raa_dmpvr2_2rail_nontc` enum value and its case
  statement already exist in stable trees back to 5.10.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5:** Lore is behind bot protection and cannot be fetched.
However, the Link: tag confirms the patch was submitted via the standard
process and accepted by hwmon maintainer Guenter Roeck. The `b4 dig` of
the prior similar commit (2190ad55a601d) confirmed it was part of a
normal patch series accepted through the standard hwmon tree.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.5:**
- The only code change is adding entries to a static `struct
  i2c_device_id` table.
- When the I2C subsystem finds a device matching `"raa228942"` or
  `"raa228943"`, it will call `isl68137_probe()` with the
  `raa_dmpvr2_2rail_nontc` variant.
- The `raa_dmpvr2_2rail_nontc` case (lines 413-416) simply disables
  TEMP3, falls through to the 2-rail handler. This is well-tested code
  used by RAA228228, RAA228244, and RAA228246.
- No new code paths are created.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The driver exists in all active stable trees (5.10+). The
`raa_dmpvr2_2rail_nontc` variant exists since 5.10.

**Step 6.2:** The patch adds 2 lines to the I2C ID table and
documentation. It will apply cleanly or with trivial context adjustments
(the table is in alphabetical order).

**Step 6.3:** No related fixes already in stable for these specific
devices.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** `drivers/hwmon/pmbus` - hardware monitoring for PMBus
voltage regulators. Criticality: PERIPHERAL (specific hardware).
However, PMBus voltage regulators are used in servers and embedded
systems where stable kernels are common.

**Step 7.2:** Actively maintained by Guenter Roeck, with regular device
ID additions.

## PHASE 8: IMPACT AND RISK

**Step 8.1:** Affects users of Renesas RAA228942/RAA228943 hardware
specifically.

**Step 8.2:** Without these IDs, the driver cannot bind to the hardware
at all. Users with this hardware have no workaround on stable kernels.

**Step 8.3:** Failure mode without fix: hardware is completely
inaccessible. Severity: MEDIUM (functional but not crash/corruption).

**Step 8.4:**
- Benefit: Enables hardware monitoring for users with these specific
  Renesas voltage regulators on stable kernels.
- Risk: Essentially zero. Two table entries using an existing, well-
  tested variant.
- Ratio: Very favorable benefit/risk.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Device ID addition to existing driver - explicitly allowed exception
  category
- Trivially small (2 lines of code)
- Uses existing, well-tested variant (`raa_dmpvr2_2rail_nontc`) present
  since v5.10
- Zero regression risk
- Accepted by subsystem maintainer (Guenter Roeck)
- Author is from the chip vendor (Renesas)
- Enables real hardware for real users

**Evidence AGAINST backporting:**
- Not a bug fix - purely hardware enablement
- Affects only users with these specific Renesas parts (narrow audience)

**Stable Rules Checklist:**
1. Obviously correct? **YES** - trivial table addition
2. Fixes a real bug? **No** - but device ID additions are an explicit
   exception
3. Important? Moderately - enables hardware for users who have it
4. Small and contained? **YES** - 2 lines of code + docs
5. No new features/APIs? **YES** - no new features, just ID binding
6. Can apply to stable? **YES** - clean apply expected

**Exception Category:** Device ID addition to existing driver - this is
one of the explicitly listed categories that ARE allowed in stable
despite being "additions."

## Verification

- [Phase 1] Parsed tags: Signed-off-by from Renesas author + hwmon
  maintainer Guenter Roeck; Link to lore
- [Phase 2] Diff analysis: +2 lines in I2C ID table (raa228942/raa228943
  as raa_dmpvr2_2rail_nontc), +20 lines docs
- [Phase 3] git blame: ID table present since f621d61fd59f4 (2020);
  nontc variant since 51fb91ed5a6fa (2020, v5.10 era)
- [Phase 3] git tag --contains 51fb91ed5a6fa: present in p-5.10, p-5.15,
  all active stable trees
- [Phase 3] git log: prior identical-pattern commit 2190ad55a601d
  (RAA228244/RAA228246) confirmed
- [Phase 3] git log --author: author is Renesas employee
- [Phase 4] b4 dig: lore blocked by bot protection; confirmed standard
  hwmon maintainer acceptance via prior similar commit
- [Phase 5] Code reading: raa_dmpvr2_2rail_nontc case at line 413
  disables TEMP3, falls through to 2-rail; well-tested
- [Phase 6] Verified existing variant in tree at lines 76, 413, 498-500,
  549-551
- [Phase 6] No raa228942/raa228943 references found anywhere in current
  tree (grep confirmed)
- [Phase 8] Risk: zero regression potential from static table entry
  addition
- UNVERIFIED: Could not read lore discussion due to bot protection

This is a textbook device ID addition - the simplest and safest type of
stable backport. Two lines adding I2C device IDs to an existing driver
using an existing, well-tested variant. Zero regression risk, enables
hardware for real users.

**YES**

 Documentation/hwmon/isl68137.rst | 20 ++++++++++++++++++++
 drivers/hwmon/pmbus/isl68137.c   |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/hwmon/isl68137.rst b/Documentation/hwmon/isl68137.rst
index e77f582c28505..0ce20d09164fc 100644
--- a/Documentation/hwmon/isl68137.rst
+++ b/Documentation/hwmon/isl68137.rst
@@ -394,6 +394,26 @@ Supported chips:
 
       Provided by Renesas upon request and NDA
 
+  * Renesas RAA228942
+
+    Prefix: 'raa228942'
+
+    Addresses scanned: -
+
+    Datasheet:
+
+      Provided by Renesas upon request and NDA
+
+  * Renesas RAA228943
+
+    Prefix: 'raa228943'
+
+    Addresses scanned: -
+
+    Datasheet:
+
+      Provided by Renesas upon request and NDA
+
   * Renesas RAA229001
 
     Prefix: 'raa229001'
diff --git a/drivers/hwmon/pmbus/isl68137.c b/drivers/hwmon/pmbus/isl68137.c
index 3e3a887aad050..c8930f2d54237 100644
--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -498,6 +498,8 @@ static const struct i2c_device_id raa_dmpvr_id[] = {
 	{"raa228228", raa_dmpvr2_2rail_nontc},
 	{"raa228244", raa_dmpvr2_2rail_nontc},
 	{"raa228246", raa_dmpvr2_2rail_nontc},
+	{"raa228942", raa_dmpvr2_2rail_nontc},
+	{"raa228943", raa_dmpvr2_2rail_nontc},
 	{"raa229001", raa_dmpvr2_2rail},
 	{"raa229004", raa_dmpvr2_2rail},
 	{"raa229141", raa_dmpvr2_2rail_pmbus},
-- 
2.53.0

