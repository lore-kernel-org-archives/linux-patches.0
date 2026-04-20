Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5583E024E;
	Mon, 20 Apr 2026 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691469; cv=none; b=dbaOGSigiiqEyRFOH63+SmuLEjzC7ofP7FCJ0gFC9OWO6N4nUce6PjaCGnSQvERLOnsXQ0S4zzMa962In8D9GOPxE9uuZdsCXPc/KPFpmwyr9qDh6f0eV4DxLNeHPjPIQawAcOWoO4JBIG+MiBYHRBAWLpUf/LZ2dsn5+fqYSy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691469; c=relaxed/simple;
	bh=mdTTLFFRGSvS9pVXxreZEr6WIIMFyUkAMBZmnwnFgGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qmPPLdyYxtmOrWzJ1g2VVJVSJhrVSU8KKuwvm32ErYVKZL4KjjgY+n7hn4auO4C7Ml9mLrjxlg5sqWM+lLtF25CEHQgmzx154fC1haTgNdgh/VtTKeLfXKErGTK4cafvoUkZJ9RTDliC7wo4o+gkAmf27bgBcwwd7koIOVvBuLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ht8SJa56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ht8SJa56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1D4C2BCB4;
	Mon, 20 Apr 2026 13:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691468;
	bh=mdTTLFFRGSvS9pVXxreZEr6WIIMFyUkAMBZmnwnFgGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ht8SJa563vBIdvtheNgt9tiBYHMZoa9Hz+7rjpLyO/o+rrpCqTbPDaOLEth6zt5Wu
	 lWbMnNLYecz90pKu1r5cMtc6Qtf5QqV9nlJl/IclZ/4tZP+/96T97y5H1c8KXTHSR3
	 6hSq3MuqMlXI8jHcCWrfL6TWY2YzVxrZ7g8+4QqUhZFv6u/Ce9ZydFGnu8Or2W2Hxe
	 RCMbMB7hHuZI7oq7kx0/txJ8ssEffALSXNvspojoXxnvv8alroxYRtYLD5qTchu44N
	 fES+MmgaXSc9A2pwlfp9A4sX5lv5kN1yU0OOAZCQNHo/T6JYzLHYJ6tQ+sm+31PZIg
	 cU1TcKJHqqBaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] arm64: tegra: Fix snps,blen properties
Date: Mon, 20 Apr 2026 09:17:21 -0400
Message-ID: <20260420132314.1023554-47-sashal@kernel.org>
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

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 51f10c527a63dc4a71bce4b40fc53eee78bbbd52 ]

The snps,blen property of stmmac-axi-config nodes needs to have 7
entries in total, with unsupported burst lengths listed as 0.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for my analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `arm64: tegra` (ARM64 device tree, Tegra SoC)
- Action verb: "Fix" — direct bug fix language
- Summary: Fix the `snps,blen` DT properties for MGBE Ethernet
  controllers
- Record: [arm64: tegra] [fix] [correcting snps,blen DT property to have
  required 7 entries]

**Step 1.2: Tags**
- `Signed-off-by: Thierry Reding <treding@nvidia.com>` — Author is the
  Tegra platform maintainer at NVIDIA.
- No Fixes: tag, no Cc: stable, no Reported-by (expected for auto-
  selection candidates).
- Record: No notable tags beyond authorship. Author is the subsystem
  maintainer.

**Step 1.3: Commit Body**
- States: "The snps,blen property of stmmac-axi-config nodes needs to
  have 7 entries in total, with unsupported burst lengths listed as 0."
- This describes a DT schema violation — the property had 4 entries but
  the driver requires 7.
- Record: Bug is a malformed DT property that doesn't match the driver's
  expectation.

**Step 1.4: Hidden Bug Fix Detection**
- This is NOT a hidden fix — it's explicitly labeled "Fix." The
  underlying bug is that `of_property_read_u32_array(np, "snps,blen",
  axi_blen, 7)` fails silently when the property only has 4 entries,
  leaving the stack buffer uninitialized.
- Record: Direct bug fix, not disguised.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `arch/arm64/boot/dts/nvidia/tegra234.dtsi`
- 3 lines changed (each identical):
  - `snps,blen = <256 128 64 32>;` → `snps,blen = <256 128 64 32 0 0
    0>;`
- Affects MGBE0, MGBE1, MGBE2 stmmac-axi-config nodes.
- Record: Single DT file, 3 identical one-line changes. Scope:
  minimal/surgical.

**Step 2.2: Code Flow**
- Before: DT property has 4 u32 entries.
- After: DT property has 7 u32 entries (3 trailing zeros for unsupported
  burst lengths).
- The stmmac driver calls `of_property_read_u32_array(np, "snps,blen",
  axi_blen, AXI_BLEN)` where `AXI_BLEN = 7`. With only 4 entries,
  `of_find_property_value_of_size()` checks `prop->length (16) < min
  (28)` and returns `-EOVERFLOW`. The stack array `axi_blen[7]` is never
  written. Then `stmmac_axi_blen_to_mask()` processes uninitialized
  stack data.

**Step 2.3: Bug Mechanism**
- Category: **Uninitialized data** / **incorrect DT specification**
- Mechanism: The DT property is too short, causing
  `of_property_read_u32_array()` to fail, leaving a stack buffer
  uninitialized. The uninitialized data is then used to configure the
  AXI DMA burst length register for network hardware.
- Record: Uninitialized stack data used for hardware DMA configuration.
  The fix ensures the property has the correct count.

**Step 2.4: Fix Quality**
- Obviously correct: all other DT files using `snps,blen` have exactly 7
  entries (verified by grep across all arm64 DT files).
- Minimal/surgical: 3 identical one-line changes.
- Zero regression risk: adding trailing zeros only enables the driver to
  read the property successfully, and zero entries are explicitly
  skipped by `stmmac_axi_blen_to_mask()`.
- Record: Fix is obviously correct, minimal, zero regression risk.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- The buggy `snps,blen = <256 128 64 32>` was introduced by commit
  `81695da63b977` ("arm64: tegra: Add AXI configuration for Tegra234
  MGBE") by Thierry Reding, dated 2024-02-21, merged in v6.9.
- Record: Bug introduced in v6.9 by the same author who is now fixing
  it.

**Step 3.2: Fixes tag**
- No Fixes: tag present. The implicit fix target is `81695da63b977`.

**Step 3.3: File History**
- Recent changes to `tegra234.dtsi` are mostly DT cleanup/additions. No
  related fixes.
- Record: Standalone fix, no prerequisites.

**Step 3.4: Author**
- Thierry Reding is the Tegra platform maintainer at NVIDIA. He wrote
  the original buggy commit and is now fixing it.
- Record: Subsystem maintainer self-fix.

**Step 3.5: Dependencies**
- None. The fix is a pure DT property value change that applies
  independently.
- Record: No dependencies, applies cleanly standalone.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Submission**
- Found via web search: patch is `[PATCH 09/10]` in a series "dt-
  bindings: Various cleanups for Tegra-related bindings" posted
  2026-02-23.
- Part of a v3 cleanup series. While most patches in the series are DT
  binding cleanups, this specific patch (09/10) is a genuine bug fix.
- Record: Part of a larger DT cleanup series, but this patch is an
  independent bug fix.

**Step 4.2: Reviewers**
- b4 dig found the original commit (81695da63b977) was reviewed and
  tested by Jon Hunter (NVIDIA Tegra co-maintainer). The fix itself is
  straightforward enough that formal review was likely implicit.
- Record: Original buggy code was reviewed by Jon Hunter.

**Step 4.3-4.5: Bug Reports / Stable History**
- No specific bug report found. Likely discovered by the author during
  code review / DT validation.
- No prior stable discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Key Functions**
- `stmmac_axi_setup()` in `stmmac_platform.c` parses the DT property.
- Called during stmmac platform driver probe for any device using
  `snps,axi-config` DT phandle.
- `stmmac_axi_blen_to_mask()` converts the burst length array to
  register value.
- The register value is written to hardware in `dwxgmac2_dma_init()` /
  `dwmac4_dma_init()` / `dwmac1000_dma_init()`.
- Impact: Affects AXI DMA configuration for MGBE Ethernet on Tegra234.

**Step 5.5: Similar Patterns**
- All other arm64 DT files consistently use 7 entries for `snps,blen`.
  Tegra234 was the ONLY outlier with 4 entries.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
- Commit `81695da63b977` was introduced in v6.9. It exists in stable
  trees v6.12.y and any newer LTS branches.
- It does NOT exist in v6.6.y (confirmed via `git merge-base --is-
  ancestor`).
- Record: Bug affects v6.9+ stable trees (v6.12.y at minimum).

**Step 6.2: Backport Complications**
- Pure DT change with no code dependencies. Should apply cleanly.
- Record: Clean apply expected.

**Step 6.3: Related Fixes**
- No prior fix for this issue found in any tree.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- ARM64 Device Tree for Tegra234 MGBE (Multi-Gigabit Ethernet).
- Criticality: IMPORTANT — affects Tegra234 network hardware users
  (NVIDIA Jetson AGX Orin, etc.).
- Record: [arm64/tegra DT] [IMPORTANT — Jetson platform network
  hardware]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- Users of NVIDIA Tegra234 platforms (Jetson AGX Orin) using MGBE
  Ethernet controllers.
- Platform-specific but widely deployed in industrial/embedded
  applications.

**Step 8.2: Trigger Conditions**
- Triggered on every boot when the MGBE driver probes. No special
  configuration needed.
- The AXI burst length read fails silently, so uninitialized data
  configures DMA hardware.

**Step 8.3: Failure Mode**
- Uninitialized stack data used for DMA hardware configuration.
- Could result in suboptimal network performance, potential DMA errors,
  or undefined hardware behavior depending on what stack values happen
  to be.
- Severity: **HIGH** (hardware misconfiguration from uninitialized data,
  affecting network DMA)

**Step 8.4: Risk-Benefit**
- BENEFIT: High — fixes broken AXI DMA configuration for 3 MGBE Ethernet
  controllers on Tegra234.
- RISK: Very low — 3 identical one-line DT property changes, adding
  trailing zeros, no code change.
- Record: Very favorable risk-benefit ratio.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes real bug: `of_property_read_u32_array()` fails with only 4/7
  entries, leading to uninitialized stack data being used for hardware
  DMA configuration
- Minimal, surgical fix: 3 identical one-line DT changes
- Obviously correct: all other DT files use 7 entries
- Written by subsystem maintainer (Thierry Reding, NVIDIA Tegra
  maintainer)
- Zero regression risk: trailing zeros are explicitly handled ("Burst
  values of zero must be skipped")
- Applies to v6.12.y+ stable trees

AGAINST backporting:
- No explicit user report of symptoms (could mean it works by luck with
  stack data)
- Part of a larger series (but this patch is independent)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct? **YES** — all other DT files have 7 entries
2. Fixes a real bug? **YES** — uninitialized data used for HW
   configuration
3. Important issue? **YES** — hardware DMA misconfiguration
4. Small and contained? **YES** — 3 one-line changes in 1 DT file
5. No new features? **YES** — pure DT fix
6. Can apply to stable? **YES** — clean DT-only change

**Step 9.3: Exception Category**
- DT update fixing existing hardware description — automatic YES
  category

## Verification

- [Phase 1] Parsed subject: "Fix" verb, arm64 tegra subsystem, snps,blen
  property
- [Phase 2] Diff: 3 lines changed in tegra234.dtsi, each adds `0 0 0` to
  snps,blen property
- [Phase 2] Verified AXI_BLEN=7 in `include/linux/stmmac.h` line 109
- [Phase 2] Verified `of_property_read_u32_array()` calls
  `of_find_property_value_of_size()` with min=28 bytes; property has 16
  bytes (4 entries), so it returns -EOVERFLOW
- [Phase 2] Verified `stmmac_axi_blen_to_mask()` skips zero entries
  ("Burst values of zero must be skipped")
- [Phase 3] git blame: buggy code from 81695da63b977 (v6.9), author:
  Thierry Reding
- [Phase 3] git merge-base: confirmed 81695da63b977 is in v6.12 but not
  v6.6
- [Phase 4] b4 dig: found original commit submission at lore (patch-id
  match)
- [Phase 4] Web search: fix is PATCH 09/10 of "dt-bindings: Various
  cleanups for Tegra-related bindings"
- [Phase 5] Verified all other arm64 DT snps,blen entries have exactly 7
  values (grep across arch/arm64/boot/dts)
- [Phase 5] Traced call chain: stmmac_axi_setup →
  of_property_read_u32_array → of_find_property_value_of_size
- [Phase 6] Bug exists in v6.9+ stable trees
- [Phase 8] Failure mode: uninitialized stack data used for AXI DMA
  register, severity HIGH

**YES**

 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 850c473235e36..04a95b6658caa 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3621,7 +3621,7 @@ ethernet@6800000 {
 			snps,axi-config = <&mgbe0_axi_setup>;
 
 			mgbe0_axi_setup: stmmac-axi-config {
-				snps,blen = <256 128 64 32>;
+				snps,blen = <256 128 64 32 0 0 0>;
 				snps,rd_osr_lmt = <63>;
 				snps,wr_osr_lmt = <63>;
 			};
@@ -3663,7 +3663,7 @@ ethernet@6900000 {
 			snps,axi-config = <&mgbe1_axi_setup>;
 
 			mgbe1_axi_setup: stmmac-axi-config {
-				snps,blen = <256 128 64 32>;
+				snps,blen = <256 128 64 32 0 0 0>;
 				snps,rd_osr_lmt = <63>;
 				snps,wr_osr_lmt = <63>;
 			};
@@ -3705,7 +3705,7 @@ ethernet@6a00000 {
 			snps,axi-config = <&mgbe2_axi_setup>;
 
 			mgbe2_axi_setup: stmmac-axi-config {
-				snps,blen = <256 128 64 32>;
+				snps,blen = <256 128 64 32 0 0 0>;
 				snps,rd_osr_lmt = <63>;
 				snps,wr_osr_lmt = <63>;
 			};
-- 
2.53.0

