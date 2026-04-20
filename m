Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B92A3FA5C7;
	Mon, 20 Apr 2026 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691570; cv=none; b=LbZiQlLZqeDJQnvEUIP1dm0RhSZLOLZKAGBN5aEm/DbDE0/ltrgs8t0/lOJ/vD558/WR5KO36Jtwvddahh6+Ivc6idrivK39bMRrZUVUPJEy7sIQ+EfxJUUOVexXhjxytda6u65J8FD7RrrgEXo9O0ojBACWYfAs/t27HqnTRho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691570; c=relaxed/simple;
	bh=aePsErvzFJloIxrrjSbTedTghx+HOM3zzVUhqil3lD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED8sKLh04VuB+YLgHrQFZSHfOX8cTyhNIVwpR3uThBGql0pgrCrtsxZtdgN7y8qmfLjlUQVzjz1JaIAYxKvXbWFiB9yl1K44/Jd5D/f5ySuc5hAXgN44w1fYnzb0T+kDVxzmZ84Ga3ijs/3sf/JvL04N/XpM8d43Vsbcwt55ACc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icqTMtZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icqTMtZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E743C2BCC4;
	Mon, 20 Apr 2026 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691570;
	bh=aePsErvzFJloIxrrjSbTedTghx+HOM3zzVUhqil3lD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icqTMtZn6xf2oHTfaBb5BaWJZUyBlO551NidNUQWHtDfrTTzS1roNwU80vGf3DhVK
	 BjMUxyEXlto0ugs3cF5YdTMUhWe6i0SxrauxsRTBxpJQqvPdry6Z5Nu2NZsqwSNin4
	 8QOMLemH/14BzzIEsc0nQbZRYSRZuB4nrHFbC74MJ763hKSXBkjxmXes7GnN6RPlBK
	 q9zq7y1MbwbNDWjfrMCrb7sbn+aZqTe+viJVX0xML5RdugpMxFVDP2do48Wbegta/P
	 mUgpsMfkW8e45vS5mUM31TlGgjZeDxMqQv7OAozxfq2iHnqqauXXgg8vSrOwwGd+3W
	 Qc/QBRGtFDtKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu: Handle IH v7_1 reg offset differences
Date: Mon, 20 Apr 2026 09:18:20 -0400
Message-ID: <20260420132314.1023554-106-sashal@kernel.org>
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

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit 41c61e60f82d55e9a3a3f3f04d192d732230a91c ]

IH v7_1 changes the offsets of some registers relative to
IH v7_0. Introduce IH v7_1-specific register access

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting (attempt 1)...
Retry attempt 1...
Now let me compile the final analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `drm/amdgpu` (AMD GPU driver, IH = Interrupt Handler)
- **Action verb**: "Handle" - implies addressing a functional issue
- **Summary**: Addresses register offset differences between IH v7.0 and
  IH v7.1 hardware IP versions

Record: [drm/amdgpu] [Handle] [Fix wrong register offsets for IH v7.1
hardware]

### Step 1.2: Tags
- Signed-off-by: Hawking Zhang (AMD GPU architect/contributor)
- Reviewed-by: Lijo Lazar (AMD GPU developer)
- Signed-off-by: Alex Deucher (AMD GPU subsystem maintainer)
- No Fixes: tag, no Reported-by, no Cc: stable - all expected for
  candidate evaluation.

Record: Standard AMD GPU driver patch flow. Reviewed by subsystem
contributor, signed off by maintainer.

### Step 1.3: Commit Body
The body explains: "IH v7_1 changes the offsets of some registers
relative to IH v7_0." This states factually that register offsets differ
between hardware versions. "Introduce IH v7_1-specific register access"
means the fix adds conditional paths.

Record: The bug is that IH v7.1 hardware has different register offsets
for certain registers, but the driver uses v7.0 offsets for all
versions, leading to wrong register accesses.

### Step 1.4: Hidden Bug Fix Detection
This IS a hidden bug fix. The phrase "Handle... differences" understates
the issue: without this change, the driver reads/writes WRONG register
offsets on IH v7.1 hardware. This is a functional correctness bug.

Record: Yes, this is a hidden bug fix disguised as enablement.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files**: `drivers/gpu/drm/amd/amdgpu/ih_v7_0.c` (+22 lines net)
- **Functions modified**: `ih_v7_0_irq_init()`
- **Scope**: Single-file, single-function, surgical fix

### Step 2.2: Code Flow Change
The diff modifies `ih_v7_0_irq_init()` in three places:

1. **IH_CHICKEN register** (lines 321-324): Before: always uses
   `regIH_CHICKEN` (0x018a from v7.0 header). After: checks IP version;
   uses 0x0129 for v7.1, 0x018a for v7.0.

2. **IH_RING1_CLIENT_CFG_INDEX** (lines 361-363): Before: always uses
   `regIH_RING1_CLIENT_CFG_INDEX` (0x0183). After: uses 0x0122 for v7.1.

3. **IH_RING1_CLIENT_CFG_DATA** (lines 365-371): Before: always uses
   `regIH_RING1_CLIENT_CFG_DATA` (0x0184). After: uses 0x0123 for v7.1.

Six local `#define` constants are added for the v7.1 offsets.

### Step 2.3: Bug Mechanism
**Category**: Hardware register access correctness bug

I verified the register offsets from the actual header files:

**osssys_7_0_0_offset.h**:
- `regIH_CHICKEN` = 0x018a
- `regIH_RING1_CLIENT_CFG_INDEX` = 0x0183
- `regIH_RING1_CLIENT_CFG_DATA` = 0x0184

**osssys_7_1_0_offset.h**:
- `regIH_CHICKEN` = 0x0129
- `regIH_RING1_CLIENT_CFG_INDEX` = 0x0122
- `regIH_RING1_CLIENT_CFG_DATA` = 0x0123

The offsets differ significantly (e.g., IH_CHICKEN is 0x61 dwords
apart). Since `ih_v7_0.c` only includes the v7.0 header, on v7.1
hardware it reads/writes completely wrong registers.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes - version check + correct v7.1 offsets
  verified against official header
- **Minimal/surgical**: Yes - only the three affected registers are
  touched
- **Regression risk**: Very low - only changes behavior for
  IP_VERSION(7,1,0); v7.0 paths unchanged
- **Red flags**: None

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy `RREG32_SOC15(OSSSYS, 0, regIH_CHICKEN)` at line 321 was
introduced by `12443fc53e7d7` (Likun Gao, 2023 - initial ih_v7_0
support). The IH_RING1 client config lines (359-371) were added by
`f0c6b79bfc921` (Sunil Khatri, July 2024).

### Step 3.2: Fixes Tag
No Fixes: tag present. The underlying issue is that `692c70f4d8024`
("drm/amdgpu: Use ih v7_0 ip block for ih v7_1") claimed v7.1 could
share the v7.0 implementation, but didn't account for register offset
differences. This commit IS in the stable tree.

### Step 3.3: File History
20+ commits to ih_v7_0.c, mostly API refactoring. The v7.1-specific code
(retry CAM) was added by `e06d194201189` which IS in this tree.

### Step 3.4: Author
Hawking Zhang is a principal AMD GPU architect and frequent contributor,
also added the osssys v7.1 headers.

### Step 3.5: Dependencies
No dependencies. The commit is self-contained - it adds local #defines
rather than including the v7.1 header (avoiding symbol clashes).

## PHASE 4: MAILING LIST RESEARCH

Could not find the specific patch thread on lore.kernel.org (Anubis
anti-scraping protection blocked search). Web search also did not find
the exact patch. The "Consolidate register access methods" series by
Lijo Lazar (Jan 2026) appears to be a follow-up refactoring.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
`ih_v7_0_irq_init()` is the only function modified.

### Step 5.2: Callers
`ih_v7_0_irq_init()` is called from:
- `ih_v7_0_hw_init()` -> called during device load
- `ih_v7_0_resume()` -> called during system resume

These are critical initialization paths that run every time the GPU is
initialized or resumed.

### Step 5.4: Reachability
Absolutely reachable - runs on every device init and resume for any GPU
using IH v7.x.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
YES - both the code and the IH v7.1 hardware recognition
(`amdgpu_discovery.c` line 2110: `case IP_VERSION(7, 1, 0)`) exist in
this 7.0 tree. The v7.1-specific retry CAM code (commit `e06d194201189`)
is also present.

### Step 6.2: Backport Complications
The patch should apply cleanly - the file in the stable tree matches the
pre-image of the diff exactly. The current code at lines 303-402 matches
what the diff expects.

### Step 6.3: Related Fixes
No related fix for the same issue already in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
`drm/amdgpu` - IMPORTANT. AMD GPUs are very widely used. IH (Interrupt
Handler) is critical for GPU interrupt delivery.

### Step 7.2: Activity
Very active subsystem with frequent changes.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users with IH v7.1 GPUs (specific AMD GPU generation). These GPUs are
detected and loaded by the driver in the 7.0 stable tree.

### Step 8.2: Trigger Conditions
Every GPU initialization and every system resume. 100% reproducible on
affected hardware.

### Step 8.3: Failure Mode Severity
Without this fix on IH v7.1 hardware:
- **IH_CHICKEN wrong**: Bus address mode for IH not configured ->
  potential firmware load path issues
- **IH_RING1_CLIENT_CFG wrong**: Interrupt redirection to ring 1 broken
  for dGPUs -> interrupt handling incomplete
- **Wrong register writes**: Writing to offset 0x018a instead of 0x0129
  corrupts whatever register is actually at 0x018a
- Severity: **HIGH** - broken interrupt initialization on affected GPUs

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: HIGH - makes IH v7.1 GPUs work correctly with proper
  interrupt handling
- **Risk**: VERY LOW - only changes behavior for IP_VERSION(7,1,0), all
  v7.0 paths unchanged
- **Ratio**: Strongly favorable

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting**:
- Fixes wrong register access on hardware already supported in stable
  (v7.1 IP recognized, block loaded)
- Three registers accessed at completely wrong offsets (0x018a vs
  0x0129, etc.)
- Wrong register writes can corrupt hardware state and break interrupt
  handling
- Every GPU init/resume triggers the bug on affected hardware
- Self-contained single-file fix
- Reviewed by AMD developer, signed off by AMD maintainer
- Low regression risk (v7.0 hardware unaffected)
- Fix quality is high: correct offsets verified against official header
  file

**AGAINST backporting**:
- Moderate size (~22 lines, 6 #defines + conditional logic)
- Commit message reads more like enablement than a bug fix
- No Reported-by or syzbot (hardware may not yet be widely deployed)
- Could be considered part of ongoing hardware bring-up

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - offsets verified against v7.1
   header
2. Fixes a real bug? **YES** - wrong register addresses on v7.1 hardware
3. Important issue? **YES** - broken interrupt initialization, potential
   register corruption
4. Small and contained? **YES** - single file, single function, ~22
   lines
5. No new features? **YES** - fixes existing hardware support
6. Can apply to stable? **YES** - file matches pre-image exactly

### Step 9.3: Exception Categories
This is a **hardware workaround/quirk** for register offset differences
- this exception category applies.

## Verification

- [Phase 1] Parsed tags: Reviewed-by: Lijo Lazar, Signed-off-by: Hawking
  Zhang + Alex Deucher
- [Phase 2] Diff analysis: adds #defines for 3 v7.1 register offsets +
  conditional selection in ih_v7_0_irq_init()
- [Phase 2] Verified v7.0 offsets: IH_CHICKEN=0x018a, CFG_INDEX=0x0183,
  CFG_DATA=0x0184 (from osssys_7_0_0_offset.h)
- [Phase 2] Verified v7.1 offsets: IH_CHICKEN=0x0129, CFG_INDEX=0x0122,
  CFG_DATA=0x0123 (from osssys_7_1_0_offset.h)
- [Phase 2] Confirmed #defines in patch match v7.1 header values exactly
- [Phase 2] Confirmed all other IH registers (RB_BASE, RB_CNTL, etc.)
  have SAME offsets in v7.0 and v7.1 - only these three differ
- [Phase 3] git blame: regIH_CHICKEN usage introduced by 12443fc53e7d7
  (initial ih_v7_0, 2023); client CFG added by f0c6b79bfc921 (2024)
- [Phase 3] git show 692c70f4d8024: confirmed this commit added
  IP_VERSION(7,1,0) mapping to ih_v7_0_ip_block in discovery
- [Phase 3] git show e06d194201189: confirmed v7.1-specific CAM code
  exists in stable tree
- [Phase 5] ih_v7_0_irq_init() called from hw_init (device load) and
  resume - critical paths
- [Phase 6] Confirmed IP_VERSION(7,1,0) recognized in amdgpu_discovery.c
  line 2110 of this tree
- [Phase 6] Confirmed osssys_7_1_0_offset.h exists in this tree (commit
  755b5591739cc)
- [Phase 6] File matches pre-image of diff exactly - clean apply
  expected
- [Phase 6] RREG32_SOC15 macro verified: uses
  `adev->reg_offset[ip_HWIP][inst][reg_BASE_IDX] + reg` - the `reg`
  value comes from the included header (7_0_0)
- UNVERIFIED: Could not access lore.kernel.org to read patch discussion
  (Anubis protection)
- UNVERIFIED: Which specific GPU models use IH v7.1 (but confirmed it IS
  recognized in this tree)

**YES**

 drivers/gpu/drm/amd/amdgpu/ih_v7_0.c | 36 ++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/ih_v7_0.c b/drivers/gpu/drm/amd/amdgpu/ih_v7_0.c
index 451828bf583e4..1fbe904f4223b 100644
--- a/drivers/gpu/drm/amd/amdgpu/ih_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/ih_v7_0.c
@@ -289,6 +289,13 @@ static uint32_t ih_v7_0_setup_retry_doorbell(u32 doorbell_index)
 	return val;
 }
 
+#define regIH_RING1_CLIENT_CFG_INDEX_V7_1             0x122
+#define regIH_RING1_CLIENT_CFG_INDEX_V7_1_BASE_IDX    0
+#define regIH_RING1_CLIENT_CFG_DATA_V7_1              0x123
+#define regIH_RING1_CLIENT_CFG_DATA_V7_1_BASE_IDX     0
+#define regIH_CHICKEN_V7_1                            0x129
+#define regIH_CHICKEN_V7_1_BASE_IDX                   0
+
 /**
  * ih_v7_0_irq_init - init and enable the interrupt ring
  *
@@ -307,6 +314,7 @@ static int ih_v7_0_irq_init(struct amdgpu_device *adev)
 	u32 tmp;
 	int ret;
 	int i;
+	u32 reg_addr;
 
 	/* disable irqs */
 	ret = ih_v7_0_toggle_interrupts(adev, false);
@@ -318,10 +326,15 @@ static int ih_v7_0_irq_init(struct amdgpu_device *adev)
 	if (unlikely((adev->firmware.load_type == AMDGPU_FW_LOAD_DIRECT) ||
 		     (adev->firmware.load_type == AMDGPU_FW_LOAD_RLC_BACKDOOR_AUTO))) {
 		if (ih[0]->use_bus_addr) {
-			ih_chicken = RREG32_SOC15(OSSSYS, 0, regIH_CHICKEN);
+			if (amdgpu_ip_version(adev, OSSSYS_HWIP, 0) == IP_VERSION(7, 1, 0))
+				reg_addr = SOC15_REG_OFFSET(OSSSYS, 0, regIH_CHICKEN_V7_1);
+			else
+				reg_addr = SOC15_REG_OFFSET(OSSSYS, 0, regIH_CHICKEN);
+			ih_chicken = RREG32(reg_addr);
+			/* The reg fields definitions are identical in ih v7_0 and ih v7_1 */
 			ih_chicken = REG_SET_FIELD(ih_chicken,
 					IH_CHICKEN, MC_SPACE_GPA_ENABLE, 1);
-			WREG32_SOC15(OSSSYS, 0, regIH_CHICKEN, ih_chicken);
+			WREG32(reg_addr, ih_chicken);
 		}
 	}
 
@@ -358,17 +371,26 @@ static int ih_v7_0_irq_init(struct amdgpu_device *adev)
 
 	/* Redirect the interrupts to IH RB1 for dGPU */
 	if (adev->irq.ih1.ring_size) {
-		tmp = RREG32_SOC15(OSSSYS, 0, regIH_RING1_CLIENT_CFG_INDEX);
+		if (amdgpu_ip_version(adev, OSSSYS_HWIP, 0) == IP_VERSION(7, 1, 0))
+			reg_addr = SOC15_REG_OFFSET(OSSSYS, 0, regIH_RING1_CLIENT_CFG_INDEX_V7_1);
+		else
+			reg_addr = SOC15_REG_OFFSET(OSSSYS, 0, regIH_RING1_CLIENT_CFG_INDEX);
+		tmp = RREG32(reg_addr);
+		/* The reg fields definitions are identical in ih v7_0 and ih v7_1 */
 		tmp = REG_SET_FIELD(tmp, IH_RING1_CLIENT_CFG_INDEX, INDEX, 0);
-		WREG32_SOC15(OSSSYS, 0, regIH_RING1_CLIENT_CFG_INDEX, tmp);
+		WREG32(reg_addr, tmp);
 
-		tmp = RREG32_SOC15(OSSSYS, 0, regIH_RING1_CLIENT_CFG_DATA);
+		if (amdgpu_ip_version(adev, OSSSYS_HWIP, 0) == IP_VERSION(7, 1, 0))
+			reg_addr = SOC15_REG_OFFSET(OSSSYS, 0, regIH_RING1_CLIENT_CFG_DATA_V7_1);
+		else
+			reg_addr = SOC15_REG_OFFSET(OSSSYS, 0, regIH_RING1_CLIENT_CFG_DATA);
+		tmp = RREG32(reg_addr);
+		/* The reg fields definitions are identical in ih v7_0 and ih v7_1 */
 		tmp = REG_SET_FIELD(tmp, IH_RING1_CLIENT_CFG_DATA, CLIENT_ID, 0xa);
 		tmp = REG_SET_FIELD(tmp, IH_RING1_CLIENT_CFG_DATA, SOURCE_ID, 0x0);
 		tmp = REG_SET_FIELD(tmp, IH_RING1_CLIENT_CFG_DATA,
 				    SOURCE_ID_MATCH_ENABLE, 0x1);
-
-		WREG32_SOC15(OSSSYS, 0, regIH_RING1_CLIENT_CFG_DATA, tmp);
+		WREG32(reg_addr, tmp);
 	}
 
 	pci_set_master(adev->pdev);
-- 
2.53.0

