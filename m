Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EB51C01;
	Wed, 11 Feb 2026 12:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813086; cv=none; b=iF0IxZCrg9m//v4EXl5VIIgBfdSsGKjLhVtrRBJ0y9fKcxlSmlKkWMbEUn9PKofKcILt89U+L1IjOmxHoR/fw7cBynVNB4kR0RD557x8bO/fIpF18W1nk2Kw5zYZqClLsi2rUtsXPWHl9GZyjHi8+lWNDS1X8hQsXFID/vapwps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813086; c=relaxed/simple;
	bh=c3aChKA8drdhnIBuW2vLY9FQBB2u/UfTbE9NIiLS7lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWD6PNZuAW43q03qjh5x8sddGlSGYcONnkzrxj9xvoSWYvON7j6an6Go84Qtbzt3KnhqNxuiDVFo2aDyJnFzWaFZqPwHYxLcDVYuCg5+OQGML9k0IAo0HCeAqdUN/gLb/UvMGajWVo7rbcM33YSOdk7qEP3Ku0KTdFeG7wlhtow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QM8zV3Mp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QM8zV3Mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01333C4CEF7;
	Wed, 11 Feb 2026 12:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813086;
	bh=c3aChKA8drdhnIBuW2vLY9FQBB2u/UfTbE9NIiLS7lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QM8zV3Mp8H2Lr7kskuN1SIgXijCuBjQ/0mS5p0g0dC1Daxlw7wxuGBZqHHPpQdxkg
	 3/m2YFva38fjDV5tlxXYffNNXPJNNcZGkmb5yNZ23eR5cOTnJCUWwzNATVTajfaCHr
	 6hGPhf9+YJm2JfqWqropG++Z8U/A9/GwXC7W41NedC5A3NtgENjO1E6G1uIjsHzBfs
	 rqfiQuFNz5DgzND3jcb2HkdwStuBeIDhiX9hNUEuoAJVsGO03lx9Cd+NcDDe7GVAec
	 PYGyJfRx7Dg1cl1Np22LLh5QWTgKDnXCVSr/3uxZdqTtQbboJ10Ipct2W04yInTzFj
	 XRva1p36hHbzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Michal Simek <michal.simek@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] perf/arm-cmn: Support CMN-600AE
Date: Wed, 11 Feb 2026 07:30:16 -0500
Message-ID: <20260211123112.1330287-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 12a94953c37e834c3eabb839ce057094946fe67a ]

The functional safety features of CMN-600AE have little to no impact on
the PMU relative to the base CMN-600 design, so for simplicity we can
reasonably just treat it as the same thing. The only obvious difference
is that the revision numbers aren't aligned, so we may hide some aliases
for events which do actually exist, but those can still be specified via
the underlying "type,eventid" format so it's not too big a deal.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Tested-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Let me now do the complete analysis summary.

---

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** "perf/arm-cmn: Support CMN-600AE"

The commit adds support for the CMN-600AE part in the ARM CMN perf
driver. The message explicitly states that CMN-600AE is a "functional
safety" (AE = Automotive Enhanced) variant of CMN-600, and from the PMU
perspective, it is effectively the same as CMN-600. The author (Robin
Murphy, the arm-cmn driver maintainer) acknowledges that revision number
differences may hide some event aliases, but these can still be used via
raw `type,eventid` format.

The commit has both `Reviewed-by` (Ilkka Koskinen from Ampere Computing)
and `Tested-by` (Michal Simek from AMD/Xilinx), indicating this was
tested on real hardware.

### 2. CODE CHANGE ANALYSIS

The change is extremely small - exactly **4 lines added, 0 lines
removed** (net +4):

**Change 1:** Adds `PART_CMN600AE = 0x438` to the `enum cmn_part` (line
~213 in the diff). This is a simple hardware ID constant.

**Change 2:** In `arm_cmn_discover()`, after reading the part number
from the hardware's peripheral ID registers, adds:
```c
/* 600AE is close enough that it's not really worth more complexity */
if (part == PART_CMN600AE)
    part = PART_CMN600;
```

This maps the CMN-600AE part number to CMN-600 before it's stored in
`cmn->part`. This is a clean aliasing approach - the rest of the driver
sees it as CMN-600.

### 3. CLASSIFICATION - This is a Hardware Device ID Addition

This commit falls squarely into the **"New Device IDs"** exception
category for stable backporting. It is analogous to adding a new PCI ID
or USB ID to an existing driver. Specifically:

- The driver already exists in all stable trees (since v5.10).
- The CMN-600 support is fully mature.
- The only change is recognizing a new hardware part number (0x438) and
  mapping it to the existing CMN-600 code path.

### 4. WHAT HAPPENS WITHOUT THE PATCH

On a system with CMN-600AE hardware:

1. **Firmware/DT matching:** The firmware would describe the device as
   CMN-600 compatible (since there's no separate "arm,cmn-600ae" DT
   binding or ACPI ID). So `cmn->part` is initially set to `PART_CMN600`
   (0x434) at probe time (line 2557).

2. **Hardware discovery:** In `arm_cmn_discover()`, the hardware
   peripheral ID register reports 0x438, NOT 0x434. This triggers the
   **firmware binding mismatch warning**: `"Firmware binding mismatch:
   expected part number 0x%x, found 0x%x"`.

3. **Part number overwrite:** `cmn->part` is set to the hardware-
   reported 0x438 (line 2273), which is an unknown value.

4. **`arm_cmn_model()` returns 0:** With an unrecognized part number,
   the model lookup returns 0 (default case in the switch). This
   triggers the **"Unknown part number: 0x%x"** warning.

5. **PMU is effectively broken:**
   - **All events are hidden:** The visibility check `eattr->model &
     arm_cmn_model(cmn)` (line 710) evaluates to `X & 0 = 0` for every
     event, so ALL event attributes return mode 0 (hidden from sysfs).
   - **Filter selection fails:** `arm_cmn_filter_sel()` (line 1758)
     checks `e->model & model`, which is always 0, so filter selection
     always returns `SEL_NONE`.
   - **CMN-600-specific paths are skipped:** All checks like `cmn->part
     == PART_CMN600` (lines 444, 728, 739, 1400, 1893, 2353, etc.) fail
     because 0x438 != 0x434.

In summary, **without this patch, the PMU driver fails to function on
CMN-600AE hardware** - it loads but provides zero usable performance
monitoring events, and produces misleading warnings.

### 5. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 4 lines added, 0 removed. Extremely minimal.
- **Files touched:** 1 file (`drivers/perf/arm-cmn.c`).
- **Risk:** Extremely low. The change only affects hardware with part
  number 0x438. All other hardware paths are completely unaffected. The
  mapping `CMN600AE → CMN600` is architecturally correct per the
  hardware designer (Robin Murphy works at Arm).
- **Subsystem:** ARM perf PMU driver - isolated, doesn't affect other
  subsystems.

### 6. DEPENDENCIES

The patch has **no dependencies on other commits**. It's completely
self-contained:
- The `enum cmn_part` exists in all stable trees from v5.10 onward.
- The `arm_cmn_discover()` function and the part-number detection code
  is unchanged across stable trees.
- The patch will need trivial context adaptation for v6.6 (missing
  `PART_CMN_S3` member in the enum), but the actual insertion point is
  clean.

### 7. USER IMPACT

CMN-600AE is used in **functional safety / automotive** applications
(the "AE" stands for Automotive Enhanced). The Tested-by from Michal
Simek at AMD/Xilinx suggests it's used in Xilinx/AMD Versal platforms,
and the review from Ampere Computing's Ilkka Koskinen suggests it's also
relevant in server/cloud contexts. These are exactly the kinds of
systems that use stable kernels.

Without this patch, users with CMN-600AE silicon cannot use the `perf`
PMU monitoring at all, which is important for performance analysis and
debugging on these platforms.

### 8. COMPARISON TO SIMILAR ACCEPTED STABLE PATCHES

This is directly comparable to:
- USB device ID additions to quirks tables
- PCI ID additions to existing drivers
- ACPI ID additions
- DRM i915/amdgpu device ID additions

All of these are routinely backported to stable.

### 9. CONCERNS

The commit message describes this as "support" for new hardware, which
nominally sounds like "new feature." However, the actual implementation
is a **device ID alias** - mapping a new part number to already-
supported functionality. This is not adding new driver code, new event
types, or new functionality. It is enabling existing, proven code paths
for a hardware variant.

The only minor concern is the comment about revision numbers: "the
revision numbers aren't aligned, so we may hide some aliases for events
which do actually exist." This means some named perf events might not
show up in sysfs because the revision check for CMN-600 revisions won't
match CMN-600AE revision numbers. However, these events still work via
raw `type,eventid` format, so this is a cosmetic limitation, not a
functional one.

### CONCLUSION

This commit is a textbook example of a **hardware device ID addition**
to an existing driver. It is:
- **Small:** 4 lines, single file
- **Self-contained:** No dependencies on other commits
- **Low risk:** Only affects systems with specific hardware (part number
  0x438)
- **High value:** Without it, the PMU driver is completely non-
  functional on CMN-600AE hardware
- **Well-tested:** Has both Reviewed-by and Tested-by on real hardware
- **Applies cleanly:** The relevant code context is stable across kernel
  versions

The fix is small, surgical, and meets all stable kernel criteria as a
device ID addition.

**YES**

 drivers/perf/arm-cmn.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 23245352a3fc0..651edd73bfcb1 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -210,6 +210,7 @@ enum cmn_model {
 enum cmn_part {
 	PART_CMN600 = 0x434,
 	PART_CMN650 = 0x436,
+	PART_CMN600AE = 0x438,
 	PART_CMN700 = 0x43c,
 	PART_CI700 = 0x43a,
 	PART_CMN_S3 = 0x43e,
@@ -2266,6 +2267,9 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 	reg = readq_relaxed(cfg_region + CMN_CFGM_PERIPH_ID_01);
 	part = FIELD_GET(CMN_CFGM_PID0_PART_0, reg);
 	part |= FIELD_GET(CMN_CFGM_PID1_PART_1, reg) << 8;
+	/* 600AE is close enough that it's not really worth more complexity */
+	if (part == PART_CMN600AE)
+		part = PART_CMN600;
 	if (cmn->part && cmn->part != part)
 		dev_warn(cmn->dev,
 			 "Firmware binding mismatch: expected part number 0x%x, found 0x%x\n",
-- 
2.51.0

