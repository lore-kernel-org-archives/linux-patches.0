Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C754F210E;
	Mon, 31 Aug 2026 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183658; cv=none; b=YoZSxWw4ZgperOCLry9ArtlHeXFclOQxftA9bmpmy7RrFhFDDwrmpnKAEu8RuEwJG8eFILIgRnzTaIjdbvsrGKv85QcQQ6rMUA2a3Wy3jd80lEPVedPqBCoEkgchtjT0d0TAVnPX4/zMP/7hA53ot+mrNp2EUZQo8AEgQKtadIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183658; c=relaxed/simple;
	bh=NGygtitpRytc0TLalzd6mxJZJG5Am9qOjNkmlbs+jUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E68hr/xFcxXXtVB8/LNIpZdsQalnFZgTMp2Ow0pA2wydAXGpkF5JsIz/AU4laeqv2vf/GWrYibYfPhnZvFd8afWbOjCaMuxaNIbDmpcNZ2Ex4K7fM2WyquNQKL8zy/87j7SHo0Yi5Gid36YIxU/ZidNFFOM9trcWf3GaYPMbfTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdoMskVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdoMskVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4271F00A3F;
	Mon, 31 Aug 2026 13:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183655;
	bh=HGOBFmnZOh2RuIqahVn2N5Pz7MRumnhnDhwZFjgMxXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdoMskVkJG3NCq2C9YAN2WGyYL1VlkX4szGR/kR1onGwwPH2xJ803TF4B+b8no4ye
	 ae0+uNIOORjPO99m6hEAtxKbfKDcNBfQevy9rABG+zy3+tNQI6SN0z4WI6Eo3YK931
	 +ARgcFdH470DbH4N0VerP3IJbbFjevUW2CpYndVhTiuIuBDNHygQ9f9/97qQXtZS9/
	 4FW8la6Onr1Y7hPuD3IWGyrdVvPPCbqj6xROHrVuhBze3AwlfJTuvYw7NHzyPg7nsu
	 Smt1j4SoyGmTzvcaQquuS4TeQXcT5P/GG+6dDZ+nQI45YOagBTnTWNkbA7nsllJugN
	 a/aXR/MNgR0BA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	linux-clk@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] clk: clk-axi-clkgen: Add support versal timings
Date: Mon, 31 Aug 2026 09:24:12 -0400
Message-ID: <20260831133314.4125787-224-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 0aef2f0db6db22c2a441e067d8e8458106fb0483 ]

Add proper VCO and PFD limits for versal based platforms. For that we
need to add new Technology and Speed grade defines.

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `clk: clk-axi-clkgen: Add support versal
timings`

**Local tree:** `v6.18.43` (`linux-6.18.y` stable, HEAD `7b923c78b50d`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[clk: clk-axi-clkgen]` `[Add]` — Add support for Versal
FPGA VCO/PFD timing limits in the existing AXI clkgen driver.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Nuno Sá `<nuno.sa@analog.com>` (author)
- **Reviewed-by:** Brian Masney `<bmasney@redhat.com>`
- **Signed-off-by:** Stephen Boyd `<sboyd@kernel.org>` (clk maintainer
  merge)
- **No** Fixes:, Reported-by:, Tested-by:, Link:, Cc:
  stable@vger.kernel.org

Notable: Reviewed by a Red Hat contributor; merged by clk subsystem
maintainer. No user/fuzzer bug reports in the message.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug described:** Versal-based platforms need correct VCO and PFD
  limits; current driver lacks the technology/speed-grade definitions
  and limit overrides.
- **Symptom/failure mode:** Without proper limits, the driver either
  rejects unknown speed grades at probe time or programs the MMCM/PLL
  with out-of-spec VCO frequency bounds for Versal silicon.
- **Version info:** None stated.
- **Root cause:** `axi_clkgen_setup_limits()` handles
  Series7/Ultrascale/Ultrascale+ but not Versal
  (`ADI_AXI_FPGA_TECH_VERSAL`) or the Versal-specific
  `ADI_AXI_FPGA_SPEED_2MP` speed grade.

### Step 1.4: Hidden Bug Fix Detection
**Record:** **Yes — disguised as "Add support".** The subject says "add
support," but the change corrects two concrete failures in existing
code:
1. Speed grade `2MP` (value 23) falls through the `switch` to `default`
   → probe returns `-ENODEV`.
2. Versal technology is not recognized → VCO limits stay at
   Series7/Ultrascale defaults (e.g. `fvco_min=600000`,
   `fvco_max≤1600000`) instead of Versal-required `2160000–4320000` kHz.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
| File | Changes |
|------|---------|
| `drivers/clk/clk-axi-clkgen.c` | +4 / -1 (7 lines touched) |
| `include/linux/adi-axi-common.h` | +2 enum entries |

**Functions modified:** `axi_clkgen_setup_limits()` only.
**Scope:** Single-function, two-file surgical fix.

### Step 2.2: Code Flow Change (per hunk)

**Hunk 1 — speed grade range (`clk-axi-clkgen.c:524`):**
- **Before:** `ADI_AXI_FPGA_SPEED_2 ... ADI_AXI_FPGA_SPEED_2LV` (20–22)
- **After:** `ADI_AXI_FPGA_SPEED_2 ... ADI_AXI_FPGA_SPEED_2MP` (20–23)
- **Path:** Probe-time limit setup for speed-grade 2 variants.

**Hunk 2 — Versal VCO override (`clk-axi-clkgen.c:546-549`):**
- **Before:** Only Ultrascale+ gets a technology-specific VCO override.
- **After:** Versal gets `fvco_min=2160000`, `fvco_max=4320000`.
- **Path:** Post-switch technology override in
  `axi_clkgen_setup_limits()`.

**Hunk 3 — header enums (`adi-axi-common.h`):**
- **Before:** No `ADI_AXI_FPGA_TECH_VERSAL` or `ADI_AXI_FPGA_SPEED_2MP`.
- **After:** Both defined.

### Step 2.3: Bug Mechanism Classification
**Record:** **(h) Hardware workaround / correctness fix**
- Missing enum value → probe failure (`-ENODEV`) for speed grade 23.
- Missing technology branch → wrong PLL constraint window used by
  `axi_clkgen_calc_params()` in `set_rate()` and `determine_rate()`.

### Step 2.4: Fix Quality Assessment
**Record:** Fix is minimal, mirrors the existing Ultrascale+ override
pattern, and is obviously correct from a hardware-spec perspective.
Regression risk is very low: only affects platforms reporting Versal
technology or 2MP speed grade. No lock-order or API changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame / Introduction of Buggy Code
**Record:** `axi_clkgen_setup_limits()` exists in `v6.18.0` without
Versal handling (verified via `git show v6.18:drivers/clk/clk-axi-
clkgen.c`). Current tree at `v6.18.43` is identical in the affected
region. The omission has been present since at least the 6.18 release.
Shallow history in this checkout prevents identifying the original
introducing commit beyond the squashed import.

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no Fixes: tag present.

### Step 3.3: Related File History
**Record:** No changes to these files on `v6.18..HEAD` (stable queue).
The patch diff base blob `fa5ccef73e60d` matches the current file
content in the affected region — patch applies cleanly.

### Step 3.4: Author Context
**Record:** Nuno Sá is an active Analog Devices contributor (dma-axi-
dmac, iio, hwmon commits in this tree). Brian Masney (reviewer) is a
regular ADI/FPGA driver contributor.

### Step 3.5: Dependencies
**Record:** **Standalone.** No series dependencies, no prerequisite
commits required. The driver, `axi_clkgen_setup_limits()`, and
`ADI_AXI_REG_FPGA_INFO` infrastructure all exist in 6.18.y.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:**
- v1: https://www.spinics.net/lists/kernel/msg6122732.html (2026-03-26)
- RESEND: https://www.spinics.net/lists/kernel/msg6169958.html
  (2026-04-24)
- `b4 dig` could not be run (commit hash not in local tree);
  lore.kernel.org blocked by bot protection.
- Follow-ups from Stephen Boyd and Brian Masney are listed on spinics
  but individual reply bodies were not retrieved.
- Patch is a single standalone commit (not a series).

### Step 4.2: Reviewers
**Record:** CC'd to `linux-clk@`, Michael Turquette, Stephen Boyd.
Reviewed-by: Brian Masney in committed version.

### Step 4.3: Bug Reports
**Record:** No Reported-by, syzbot, or bugzilla links. No external user
crash reports found.

### Step 4.4: Related Patches
**Record:** Single patch; change-id `20260326-clk-axi-clk-versal-
support-8eaef1530870`. v1 and RESEND are identical in content.

### Step 4.5: Stable List History
**Record:** Not searched (no stable nomination found in available patch
posts). Absence of Cc: stable is expected per review instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions Modified
**Record:** `axi_clkgen_setup_limits()` (only function changed).

### Step 5.2: Callers
**Record:** Called once from `axi_clkgen_probe()` when
`ADI_AXI_PCORE_VER_MAJOR(pcore_version) > 0x04`:

```616:619:drivers/clk/clk-axi-clkgen.c
        if (ADI_AXI_PCORE_VER_MAJOR(pcore_version) > 0x04) {
                ret = axi_clkgen_setup_limits(axi_clkgen, &pdev->dev);
                if (ret)
                        return ret;
```

Probe-time, platform driver init path.

### Step 5.3: Callees / Downstream Impact
**Record:** Limits set here are consumed by `axi_clkgen_calc_params()`
via `axi_clkgen_set_rate()` and `axi_clkgen_determine_rate()`. Wrong
limits → `-EINVAL` from rate setting or incorrect PLL divider values
programmed to MMCM registers.

### Step 5.4: Reachability
**Record:** Triggered at device probe for any platform with `adi,axi-
clkgen-2.00.a` or `adi,zynqmp-axi-clkgen-2.00.a` compatible and pcore
version > 4. Requires `CONFIG_COMMON_CLK_AXI_CLKGEN`. No in-tree Versal
DTS nodes use this compatible string (verified by grep), but the driver
reads technology directly from FPGA hardware registers — custom ADI
reference designs on Versal are the target.

### Step 5.5: Similar Patterns
**Record:** Identical pattern already exists for
`ADI_AXI_FPGA_TECH_ULTRASCALE_PLUS` in the same function (lines
545–549). This commit extends that pattern to Versal.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.y)

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Current tree lacks `ADI_AXI_FPGA_TECH_VERSAL`,
`ADI_AXI_FPGA_SPEED_2MP`, and the Versal VCO override. Confirmed in both
HEAD and `v6.18.0`.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Diff base matches current source
exactly in affected hunks.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** Grep found no `VERSAL` or `2MP` symbols in the tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **clk** / **PERIPHERAL** — Analog Devices AXI clock
generator for Xilinx FPGAs (`CONFIG_COMMON_CLK_AXI_CLKGEN`, tristate,
OF-based). Niche industrial/SDR embedded hardware.

### Step 7.2: Subsystem Activity
**Record:** clk subsystem is actively maintained in 6.18.y (many stable
backports), but this specific driver has seen no stable-queue changes
since 6.18.0.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Driver-specific / platform-specific** — users of Analog
Devices AXI clkgen IP on Versal FPGAs with pcore version > 4. Not a
universal kernel path.

### Step 8.2: Trigger Conditions
**Record:**
- FPGA info register reports `ADI_AXI_FPGA_TECH_VERSAL`, and/or
- Speed grade `ADI_AXI_FPGA_SPEED_2MP` (23).
- Triggered at every probe of matching hardware. Not userspace-
  triggerable; not a security issue.

### Step 8.3: Failure Mode Severity
**Record:**
| Failure | Mode | Severity |
|---------|------|----------|
| Speed grade 2MP unrecognized | Probe fails `-ENODEV`, no clock
provider | **HIGH** for affected hardware (device unusable) |
| Wrong VCO limits on Versal | Rate requests fail (`-EINVAL`) or PLL
programmed out of spec | **MEDIUM-HIGH** (functional failure, possible
peripheral misbehavior) |

Not a kernel oops/panic/data-corruption class bug.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables correct clock operation on Versal ADI designs;
  fixes hard probe failure for 2MP speed grade. High value for the small
  affected population.
- **Risk:** Very low — 7 lines, isolated to Versal detection path,
  follows proven Ultrascale+ pattern.
- **Ratio:** Favorable for affected users; negligible risk to everyone
  else.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable bugs in existing driver logic (probe failure + wrong
  PLL limits).
- Hardware quirk/workaround — same category as existing Ultrascale+
  override.
- Tiny, surgical, reviewed, maintainer-merged patch.
- Applies cleanly to 6.18.y; all prerequisite code present.
- Fixes broken behavior on hardware the driver is already designed to
  auto-detect.

**AGAINST backport:**
- Framed as "add support" for a new FPGA generation.
- No bug reports, fuzzer findings, or in-tree DTS users.
- Very niche hardware (ADI reference designs on Versal).
- Does not cause kernel crashes or security issues — device-level
  functional failure.
- Versal was never supported in 6.18.y (not a regression fix).

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors Ultrascale+
pattern; Reviewed-by present; no Tested-by |
| 2. Fixes a real bug affecting users? | **PASS** — probe failure and
incorrect PLL limits on Versal hardware |
| 3. Important issue? | **PASS (borderline)** — device unusable on
affected Versal platforms; not crash/security class |
| 4. Small and contained? | **PASS** — 7 lines, 2 files, 1 function |
| 5. No new features/APIs? | **PASS** — hardware quirk exception; no
userspace API changes |
| 6. Can apply to local tree? | **PASS** — code exists, clean apply |

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — adding correct timing limits
for a new FPGA technology variant in an existing driver, analogous to
the Ultrascale+ VCO override already in stable.

### Step 9.4: Decision Rationale

For **linux-6.18.y**: the driver already reads FPGA technology and speed
grade from hardware and configures PLL limits accordingly. Versal
platforms are a real deployment target for Analog Devices IP (per
Kconfig: "commonly used in Analog Devices' reference designs"). Without
this patch:

1. Versal boards reporting speed grade 2MP fail probe outright.
2. All Versal boards get VCO limits roughly 2–3× too low, breaking clock
   rate configuration.

This is a correctness fix in existing auto-detection logic, not a new
driver. It is small, low-risk, and directly analogous to stable-
acceptable hardware quirk fixes. The niche audience and lack of bug
reports lower priority but do not negate technical merit.

---

## Verification

- **[Phase 1]** Parsed subject, tags (SOB, Reviewed-by), body; no
  Fixes/Reported-by/Link tags.
- **[Phase 2]** Diff analysis: 7 lines, `axi_clkgen_setup_limits()`
  only; classified as hardware workaround.
- **[Phase 3]** `git describe HEAD` → v6.18.43; `git show v6.18:...`
  confirms buggy code at 6.18.0; no VERSAL/2MP in tree (grep); diff base
  `fa5ccef73e60d` matches current file; no changes on v6.18..HEAD for
  these files.
- **[Phase 4]** Fetched v1 and RESEND from spinics.net; lore.kernel.org
  blocked; b4 dig not run (commit not in tree); no bug reports in patch
  posts.
- **[Phase 5]** Read `axi_clkgen_probe`, `set_rate`, `determine_rate`;
  traced limits → `axi_clkgen_calc_params`; grep found no in-tree
  Versal+adi-clkgen DTS.
- **[Phase 6]** Confirmed `CONFIG_COMMON_CLK_AXI_CLKGEN` and driver
  exist; patch applies cleanly; no prior fix present.
- **[Phase 7]** Kconfig confirms peripheral ADI/Xilinx driver.
- **[Phase 8]** Probe failure = -ENODEV (verified in code); wrong limits
  affect rate calculation (verified call chain).
- **UNVERIFIED:** Individual review reply bodies from Brian
  Masney/Stephen Boyd (listed but not fetched); original commit SHA on
  mainline; exact kernel version that introduced
  `axi_clkgen_setup_limits()` (shallow history).

**YES**

 drivers/clk/clk-axi-clkgen.c   | 5 ++++-
 include/linux/adi-axi-common.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index fa5ccef73e60d..26f76a6db8202 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -521,7 +521,7 @@ static int axi_clkgen_setup_limits(struct axi_clkgen *axi_clkgen,
 		axi_clkgen->limits.fvco_max = 1200000;
 		axi_clkgen->limits.fpfd_max = 450000;
 		break;
-	case ADI_AXI_FPGA_SPEED_2 ... ADI_AXI_FPGA_SPEED_2LV:
+	case ADI_AXI_FPGA_SPEED_2 ... ADI_AXI_FPGA_SPEED_2MP:
 		axi_clkgen->limits.fvco_max = 1440000;
 		axi_clkgen->limits.fpfd_max = 500000;
 		if (family == ADI_AXI_FPGA_FAMILY_KINTEX || family == ADI_AXI_FPGA_FAMILY_ARTIX) {
@@ -546,6 +546,9 @@ static int axi_clkgen_setup_limits(struct axi_clkgen *axi_clkgen,
 	if (tech == ADI_AXI_FPGA_TECH_ULTRASCALE_PLUS) {
 		axi_clkgen->limits.fvco_max = 1600000;
 		axi_clkgen->limits.fvco_min = 800000;
+	} else if (tech == ADI_AXI_FPGA_TECH_VERSAL) {
+		axi_clkgen->limits.fvco_max = 4320000;
+		axi_clkgen->limits.fvco_min = 2160000;
 	}
 
 	return 0;
diff --git a/include/linux/adi-axi-common.h b/include/linux/adi-axi-common.h
index 37962ba530dfc..e7ba393061ee6 100644
--- a/include/linux/adi-axi-common.h
+++ b/include/linux/adi-axi-common.h
@@ -51,6 +51,7 @@ enum adi_axi_fpga_technology {
 	ADI_AXI_FPGA_TECH_SERIES7,
 	ADI_AXI_FPGA_TECH_ULTRASCALE,
 	ADI_AXI_FPGA_TECH_ULTRASCALE_PLUS,
+	ADI_AXI_FPGA_TECH_VERSAL,
 };
 
 enum adi_axi_fpga_family {
@@ -71,6 +72,7 @@ enum adi_axi_fpga_speed_grade {
 	ADI_AXI_FPGA_SPEED_2    = 20,
 	ADI_AXI_FPGA_SPEED_2L   = 21,
 	ADI_AXI_FPGA_SPEED_2LV  = 22,
+	ADI_AXI_FPGA_SPEED_2MP  = 23,
 	ADI_AXI_FPGA_SPEED_3    = 30,
 };
 
-- 
2.53.0

