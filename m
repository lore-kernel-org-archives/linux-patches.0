Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CEC3F9F5D;
	Tue, 28 Apr 2026 10:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372917; cv=none; b=shMfEfPcEZWICLlGRtTubPKG0cs/kbixE2ptCE6R8B7r1zQjrqvITV3QNQRm2kgLc0oXJEc/WlTPDJn9MLWtmRxNwenn1kbAHSOedUmiYrKH5i2rIuTh610uSaEAPYfVlg4PX9w4s5nfP+WEAPUNwRrHH1IgTtW2QdB0p6GEdW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372917; c=relaxed/simple;
	bh=jqLL9PMWQLPxYzTigBKojWpIaxGpzTrfi+7oTZFBti8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIpE/ptL2LeFuhqv5VJh/8PApXzK9bV2sZBRprsVHsAbIUJiJM2XR+2mBoW3dAk6IiVpNhFnvk4ozQyt7J7FjaZMIuizjgBnLGosRDfGX+CQCqlN/ucI4M5/pBo3w2IBZ487LASeNa7DCy5w8Gg0k/NT1TKsfhADqlmDI1FJt64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iL8p3xlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iL8p3xlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900A6C2BCB5;
	Tue, 28 Apr 2026 10:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372917;
	bh=jqLL9PMWQLPxYzTigBKojWpIaxGpzTrfi+7oTZFBti8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iL8p3xlHYp2DBXLC11N35f7WM5g+yQ3PMBb+VkwZpi3Vqf7Y26w6lo9H+Y0+EEJZZ
	 xQz69TL6iMhXmjJiygNL5rjv6DWPhfxArJWQRkqrDrOHMcNPwSdY+VzxoY71J3dLPm
	 jKjcuFNd68Z4g9vW5H/CgO1SUmTJtZRPR4FsGhKWmB61pEjYYwmaaZqdLD8PwuO2VU
	 2UUFd07+rvQ+iGjlxGn1jrelh08JXiFcpu3e7kBqfrRlEZGKtRKWT7AXkEiYkdw1AV
	 3QC2OVexfiJNEYmbd+TcMd/uFpe7NklNHJLO1kb2G85kW63Z7PrAc18zq53wfao829
	 t5KMwsdL8fNHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 7.0-6.18] mfd: mt6397: Properly fix CID of MT6328, MT6331 and MT6332
Date: Tue, 28 Apr 2026 06:40:28 -0400
Message-ID: <20260428104133.2858589-17-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit a09506820afa391e0a8ecc4b05c954f21e50b1de ]

CIDs set for MT6328, MT6331 and MT6332 are not appropriate.
Many Android downstream kernels define CID as below,

MT6328:

    #define PMIC6328_E1_CID_CODE    0x2810
    #define PMIC6328_E2_CID_CODE    0x2820
    #define PMIC6328_E3_CID_CODE    0x2830

MT6331/MT6332:

    #define PMIC6331_E1_CID_CODE    0x3110
    #define PMIC6331_E2_CID_CODE    0x3120
    #define PMIC6331_E3_CID_CODE    0x3130

    #define PMIC6332_E1_CID_CODE    0x3210
    #define PMIC6332_E2_CID_CODE    0x3220
    #define PMIC6332_E3_CID_CODE    0x3230

The current configuration incorrectly uses the revision code as the CID.
Therefore, the driver cannot detect the same PMIC of different revisions.
(E1/E2 for MT6328, E1/E3 for MT6331/MT6332)
Based on these, the CID of MT6328, MT6331 and MT6332 should be corrected.

Additionally, the incorrect MT6331/MT6332 CID overlaps with the MT6320's
actual CID:

    #define PMIC6320_E1_CID_CODE    0x1020
    #define PMIC6320_E2_CID_CODE    0x2020

This causes a conflict in the switch-case statement of mt6397-irq.c,
this prevents adding support for MT6320.

Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260302140045.651727-1-akkun11.open@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me provide the complete
analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem prefix: `mfd: mt6397`
- Action verb: "Properly fix" — explicit bug-fix language
- One-line summary: Corrects wrongly configured CID values for MT6328,
  MT6331, and MT6332 PMICs
- **Record:** `[mfd/mt6397]` `[fix]` — Properly fix CID values for
  MT6328/MT6331/MT6332 PMICs so they get correctly recognized

**Step 1.2: Tags**
- `Signed-off-by:` Akari Tsuyukusa (author)
- `Reviewed-by:` AngeloGioacchino Del Regno
  <angelogioacchino.delregno@collabora.com>
- `Link:` https://patch.msgid.link/20260302140045.651727-1-
  akkun11.open@gmail.com
- `Signed-off-by:` Lee Jones <lee@kernel.org> (MFD maintainer)
- No `Fixes:` tag, no `Cc: stable` — expected, and why the commit is
  under review
- **Record:** Reviewed by the subsystem expert who authored the original
  MT6331 support (AngeloGioacchino Del Regno) and committed by the
  subsystem maintainer (Lee Jones).

**Step 1.3: Body Analysis**
- Bug description: The values previously assigned to `MT6328_CHIP_ID`,
  `MT6331_CHIP_ID`, and `MT6332_CHIP_ID` were revision codes (E3 in the
  MT6328 case, E2 in the MT6331/MT6332 case), not the actual chip
  identifiers. The `cid_shift=0` for these chips extracts the lower byte
  (= revision), so only one specific revision matches.
- Symptom: Same PMIC of a different revision is not detected; driver
  probe fails.
- Secondary effect: The old (incorrect) MT6331/MT6332 CID value 0x20
  collides with the real MT6320 CID, blocking future MT6320 support.
- Explicit reference to downstream Android kernels that document the
  real CID layout: E-revision occupies bits 0-7, PMIC model occupies
  bits 8-15.
- **Record:** Clear explanation of a correctness bug with concrete
  hardware consequences.

**Step 1.4: Hidden Bug Fix Detection**
Not hidden — the title uses "Properly fix". This is a straightforward
correctness fix for a mis-identified register layout.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `drivers/mfd/mt6397-core.c`: 2 lines changed (cid_shift 0→8 for
  mt6328_core and mt6331_mt6332_core)
- `include/linux/mfd/mt6397/core.h`: 3 enum values changed
  (MT6328=0x30→0x28, MT6331=0x20→0x31, MT6332=0x20→0x32)
- Total: 5 insertions, 5 deletions, 2 files — extremely small, surgical
- **Record:** 2 files, ~5 effective lines of value changes, no logic
  changes.

**Step 2.2: Code Flow Change**
In `mt6397_probe()`:

```346:398:/home/sasha/linux-autosel-7.0/drivers/mfd/mt6397-core.c
static int mt6397_probe(struct platform_device *pdev)
{
        ...
        ret = regmap_read(pmic->regmap, pmic_core->cid_addr, &id);
        ...
        pmic->chip_id = (id >> pmic_core->cid_shift) & 0xff;
        ...
```

The chip_id is read from the hardware CID register (MT6328_HWCID=0x200,
MT6331_HWCID=0x100), then shifted and masked.

- Before fix (`cid_shift=0`): reads low byte = revision code (e.g.,
  0x10, 0x20, 0x30)
- After fix (`cid_shift=8`): reads high byte = actual chip model (0x28,
  0x31, 0x32), same across all revisions

The enum values are updated correspondingly so that the old "only
revision X works" behavior is preserved for revision X, and the new
behavior additionally supports all revisions.
- **Record:** The fix changes what portion of the 16-bit HWCID register
  is used for chip identification.

**Step 2.3: Bug Mechanism**
Category (g) Logic / correctness fix — specifically, wrong bit-field
extraction from a hardware register.

Concretely, MT6328 HWCID returns e.g. 0x2810 (E1), 0x2820 (E2), 0x2830
(E3):
- Old: chip_id = 0x2810 & 0xff = 0x10 / 0x20 / 0x30 — only E3 matches
  MT6328_CHIP_ID=0x30
- New: chip_id = (0x28XX >> 8) & 0xff = 0x28 for all revisions → matches
  MT6328_CHIP_ID=0x28

Same analysis for MT6331 (only E2=0x3120 matches old 0x20) and MT6332
(only E2=0x3220 matches old 0x20).

When chip_id doesn't match in `mt6397_irq_init()`'s switch statement:

```207:210:/home/sasha/linux-autosel-7.0/drivers/mfd/mt6397-irq.c
        default:
                dev_err(chip->dev, "unsupported chip: 0x%x\n",
chip->chip_id);
                return -ENODEV;
```

→ probe fails → entire MFD (regulators, RTC, keys) is absent → device
unbootable/unusable.

**Step 2.4: Fix Quality**
- Obviously correct given the documented hardware register layout.
- Pure value change; no new control flow.
- The fix preserves the previous working behavior: hardware that matched
  before (MT6328 E3, MT6331/MT6332 E2) still matches after, because the
  enum value is updated in lockstep with the shift.
- No API change, no locking change, no memory operations touched.
- **Record:** High-quality fix, zero added regression surface.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- MT6328 chip_data and enum entry introduced in `6e31bb8d3a63b` ("mfd:
  mt6397: Add initial support for MT6328") — kernel v6.13.
- MT6331/MT6332 chip_data and enum entries introduced in `d9cd0bc604705`
  ("mfd: mt6397: Add basic support for MT6331+MT6332 PMIC") — kernel
  v6.0.
- **Record:** Buggy code has been present since v6.0 (MT6331/MT6332) and
  v6.13 (MT6328).

**Step 3.2: Fixes: Tag**
No Fixes: tag provided. The natural "Fixes:" targets would be the two
commits above. Both are in mainline and in stable trees (since v6.0 /
v6.13).

**Step 3.3: File History** — recent `mt6397-core.c` history shows only
incremental PMIC additions and minor cleanups; no concurrent refactors
that would block a backport.

**Step 3.4: Author's Other Commits** — First-time author; the Reviewed-
by is from AngeloGioacchino Del Regno (Collabora), the original author
of the MT6331/MT6332 support and a prolific MediaTek-platform developer.

**Step 3.5: Dependencies** — Standalone, self-contained. No other
commits needed.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Patch Discussion**
Retrieved the full thread via b4
(lore.kernel.org/all/20260302140045.651727-1-akkun11.open@gmail.com/):
- v1 posted 2026-02-28 by Akari Tsuyukusa
- AngeloGioacchino Del Regno reviewed v1 on 2026-03-02, asked for GitHub
  links to be removed, gave Reviewed-by.
- v2 posted 2026-03-02 with Reviewed-by, no code changes.
- Lee Jones applied v2 as commit
  `f59b2bc3e6dbcd75c53f1881c1f08a6d3c2a72e5` on 2026-03-06.
- **Record:** Latest version applied; no objections, no stable-specific
  discussion either way, no NAKs.

**Step 4.2: Reviewers** — Correct subsystem parties included: Lee Jones
(MFD maintainer), Matthias Brugger (MediaTek), AngeloGioacchino Del
Regno (MediaTek expert), Yassine Oudjana (original MT6328 author), and
the linux-mediatek/arm/kernel lists.

**Step 4.3–4.5: Bug Report Links** — No external bug report; the
reporter is also the author who likely hit this on their own hardware.
No prior stable-list discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Entities Modified**
- `struct chip_data mt6328_core` (initializer constant)
- `struct chip_data mt6331_mt6332_core` (initializer constant)
- `enum chip_id` members MT6328_CHIP_ID, MT6331_CHIP_ID, MT6332_CHIP_ID

**Step 5.2: Callers/Use sites**
- `mt6328_core` / `mt6331_mt6332_core` referenced as `.data` in the
  of_device_id table → consumed once per probe by `mt6397_probe()`.
- `MT6328_CHIP_ID` / `MT6331_CHIP_ID` used in the `switch
  (chip->chip_id)` inside `mt6397_irq_init()`
  (drivers/mfd/mt6397-irq.c).
- `MT6332_CHIP_ID` is only defined; not referenced in switch (MT6332 is
  dispatched through MT6331's IRQ path per the combination comment in
  mt6397-core.c line 185).
- No users outside the driver — confirmed via repository-wide search.
- **Record:** Very small impact surface; isolated to mt6397 MFD driver.

**Step 5.3–5.4: Call chain** — Only reachable at device probe
(`mt6397_probe`), triggered by the PMIC node in device tree. User impact
path is: boot → PMIC probe reads HWCID → chip_id mismatch → ENODEV → no
regulators/RTC/keys.

**Step 5.5: Similar patterns** — Other PMICs in the same file
(mt6357/mt6358/mt6359) already use `cid_shift = 8` with their SWCID
addresses. The fix brings the three broken entries into line with the
rest of the driver.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable Trees**
Verified directly against local tracked branches:
- `for-greg/6.6-200` (6.6.y): contains MT6331/MT6332 with `cid_shift =
  0` and MT6331/MT6332 CHIP_ID = 0x20. MT6328 not present. →
  MT6331/MT6332 part of the fix is needed.
- `for-greg/6.12-200` (6.12.y): same state as 6.6.y. → MT6331/MT6332
  part needed.
- `for-greg/6.18-200` (6.18.y): has MT6328=0x30 present plus
  MT6331/MT6332=0x20. → Full fix applies.
- `for-greg/6.19-200` and `stable/linux-7.0.y`: have both; full fix
  applies.

**Step 6.2: Backport Complications**
- 6.6.y and 6.12.y: need a minor adaptation — drop the MT6328 hunks (2
  lines) and the MT6328_CHIP_ID enum line. The rest applies cleanly.
  Trivial adjustment.
- 6.18.y+: applies cleanly.

**Step 6.3: Related Fixes in Stable** — None; this is the first and only
fix for this issue.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1–7.2:** `drivers/mfd/` is an important subsystem but this
particular driver is device-specific (MediaTek PMIC companion chips for
specific SoCs). Criticality: IMPORTANT for owners of affected MediaTek
hardware (MT6735, MT6795 Helio X10 phones like Sony Xperia M5). Mature
code with steady activity (new PMIC support added periodically).

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Driver-specific: users of MediaTek SoCs paired with MT6328 (MT6735-based
devices), MT6331/MT6332 (MT6795 Helio X10, e.g. Sony Xperia M5 — present
as `mt6795-sony-xperia-m5.dts` and `mt6795-xperia-m5.dts` upstream).

**Step 8.2: Trigger Conditions**
Every boot on an affected hardware revision (any MT6328 E1/E2, any
MT6331/MT6332 E1/E3). The revision shipped in each product is fixed by
manufacturing, so a given user will either always hit or never hit the
bug.

**Step 8.3: Failure Mode**
When triggered: `mt6397_irq_init` returns -ENODEV → `mt6397_probe` fails
→ regulator/RTC/keys sub-devices never register → platform effectively
non-functional (no voltage rails programmed, no RTC, no power button).
Severity: HIGH (device unbootable for affected revisions).

**Step 8.4: Risk-Benefit**
- BENEFIT: HIGH — enables full PMIC support for a population of MediaTek
  devices that currently cannot boot properly.
- RISK: VERY LOW — 5-line pure value change; the behavior for
  previously-working revisions (MT6328 E3, MT6331/MT6332 E2) is
  preserved exactly because both the `cid_shift` and enum value move in
  lockstep; no new code paths, no locking/memory changes.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR:**
- Fixes real, user-visible bug preventing PMIC probe on non-matching
  hardware revisions.
- Failure mode is severe (device boot regression).
- Fix is small (5 effective lines), obviously correct, and aligns with
  all other PMIC entries in the same driver.
- Reviewed and Acked by subsystem expert (original MT6331 author);
  applied by subsystem maintainer.
- Buggy code has been in mainline since v6.0 (MT6331/MT6332) and v6.13
  (MT6328), so stable users have been exposed for a long time.
- Preserves backward-compatibility for revisions that previously
  happened to work.

**Evidence AGAINST:**
- Minor: requires dropping two MT6328 hunks for pre-6.13 stable trees
  (trivial adaptation).
- Not accompanied by `Cc: stable` (expected; that's why it's under
  review).

**Stable Rules Check:**
1. Obviously correct: YES (pure value change, documented hardware
   register layout).
2. Fixes real bug that affects users: YES (broken probe on specific
   revisions).
3. Important issue: YES (device unusable without PMIC).
4. Small and contained: YES (5 effective lines).
5. No new features/APIs: YES.
6. Applies to stable: YES (clean on 6.18+/7.0; trivial hunk drop on
   6.6/6.12).

**Exception categories:** Not a device-ID/quirk/DT/doc/build-fix per se,
but is a narrow hardware-identification correctness fix — equivalent
spirit to a quirk/device-ID update.

## Verification

- [Phase 1] Parsed tags: Signed-off-by Akari Tsuyukusa, Reviewed-by
  AngeloGioacchino Del Regno, Link to patch.msgid.link, Signed-off-by
  Lee Jones (MFD maintainer). No stable tag, no Fixes tag.
- [Phase 2] Diff analysis: 2 files, 5 insertions, 5 deletions — verified
  by reading the diff; matches b4-retrieved v2 mbox.
- [Phase 2] Verified code flow: read `drivers/mfd/mt6397-core.c` lines
  280–398 and confirmed `pmic->chip_id = (id >> pmic_core->cid_shift) &
  0xff;`.
- [Phase 2] Verified failure path: read `drivers/mfd/mt6397-irq.c`
  switch 178–210; unmatched chip_id returns -ENODEV.
- [Phase 2] Verified enum collision claim: `MT6331/MT6332_CHIP_ID =
  0x20` in `include/linux/mfd/mt6397/core.h`.
- [Phase 3] git log on `drivers/mfd/mt6397-core.c`: `6e31bb8d3a63b`
  added MT6328 support, `d9cd0bc604705` added MT6331/MT6332 support.
- [Phase 3] `git tag --contains 6e31bb8d3a63b | sort -V` shows v6.13 as
  earliest tag.
- [Phase 3] `git tag --contains d9cd0bc604705 | sort -V` shows v6.0 as
  earliest tag.
- [Phase 4] `b4 am` retrieved patch thread (4 messages): v1 submitted
  2026-02-28, v2 submitted 2026-03-02 with Reviewed-by added and GitHub
  links removed, applied as `f59b2bc3e6dbcd75c53f1881c1f08a6d3c2a72e5`
  by Lee Jones 2026-03-06.
- [Phase 4] Full thread read at `/tmp/mt6397_mbox/...mbx`; only review
  feedback was to remove GitHub links; no NAK, no stable nomination, no
  concerns raised.
- [Phase 5] Searched the whole repo for
  `MT6328_CHIP_ID|MT6331_CHIP_ID|MT6332_CHIP_ID` — only appear in the
  header and `mt6397-irq.c` switch statement.
- [Phase 5] `drivers/mfd/mt6397-core.c` verified: other PMICs
  (mt6357/58/59) already use `cid_shift = 8` pattern.
- [Phase 6] `git show for-greg/6.6-200:include/linux/mfd/mt6397/core.h`
  — MT6331/MT6332=0x20 present, MT6328 absent.
- [Phase 6] `git show for-greg/6.12-200:include/linux/mfd/mt6397/core.h`
  — same as 6.6.y.
- [Phase 6] `git show for-greg/6.18-200:include/linux/mfd/mt6397/core.h`
  — MT6328=0x30 and MT6331/MT6332=0x20 present.
- [Phase 6] `git show for-greg/6.6-200:drivers/mfd/mt6397-core.c` —
  `mt6331_mt6332_core` with `cid_shift = 0`. Patch hunk for
  MT6331/MT6332 applies identically.
- [Phase 8] Device tree usage verified:
  `arch/arm64/boot/dts/mediatek/mt6331.dtsi` and
  `arch/arm64/boot/dts/mediatek/mt6795-sony-xperia-m5.dts` use these
  compatibles.
- UNVERIFIED: exact distribution of revisions in shipping devices (E1 vs
  E2 vs E3) — claim about which specific revisions fail is taken from
  commit message and is consistent with the bit-field math, which I
  verified.

This is a correctness fix for a mis-decoded PMIC identification register
that makes the driver unable to probe on specific hardware revisions
shipping in real products (MT6735-based phones, MT6795 Helio X10 phones
including Sony Xperia M5). The change is tiny and preserves behavior for
revisions that happened to work before. It has been reviewed by the
MediaTek PMIC expert and landed by the MFD maintainer. Buggy code has
been in stable since v6.0 (MT6331/MT6332) and v6.13 (MT6328).
Backporting is low risk and high benefit; pre-6.13 trees need only to
drop the MT6328 hunks.

**YES**

 drivers/mfd/mt6397-core.c       | 4 ++--
 include/linux/mfd/mt6397/core.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/mt6397-core.c b/drivers/mfd/mt6397-core.c
index 3e58d0764c7e0..1bdacda9a933f 100644
--- a/drivers/mfd/mt6397-core.c
+++ b/drivers/mfd/mt6397-core.c
@@ -297,7 +297,7 @@ static const struct chip_data mt6323_core = {
 
 static const struct chip_data mt6328_core = {
 	.cid_addr = MT6328_HWCID,
-	.cid_shift = 0,
+	.cid_shift = 8,
 	.cells = mt6328_devs,
 	.cell_size = ARRAY_SIZE(mt6328_devs),
 	.irq_init = mt6397_irq_init,
@@ -313,7 +313,7 @@ static const struct chip_data mt6357_core = {
 
 static const struct chip_data mt6331_mt6332_core = {
 	.cid_addr = MT6331_HWCID,
-	.cid_shift = 0,
+	.cid_shift = 8,
 	.cells = mt6331_mt6332_devs,
 	.cell_size = ARRAY_SIZE(mt6331_mt6332_devs),
 	.irq_init = mt6397_irq_init,
diff --git a/include/linux/mfd/mt6397/core.h b/include/linux/mfd/mt6397/core.h
index b774c3a4bb62e..340fc72e22aa6 100644
--- a/include/linux/mfd/mt6397/core.h
+++ b/include/linux/mfd/mt6397/core.h
@@ -12,9 +12,9 @@
 
 enum chip_id {
 	MT6323_CHIP_ID = 0x23,
-	MT6328_CHIP_ID = 0x30,
-	MT6331_CHIP_ID = 0x20,
-	MT6332_CHIP_ID = 0x20,
+	MT6328_CHIP_ID = 0x28,
+	MT6331_CHIP_ID = 0x31,
+	MT6332_CHIP_ID = 0x32,
 	MT6357_CHIP_ID = 0x57,
 	MT6358_CHIP_ID = 0x58,
 	MT6359_CHIP_ID = 0x59,
-- 
2.53.0

