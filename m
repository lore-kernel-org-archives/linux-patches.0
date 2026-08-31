Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48030530E01;
	Mon, 31 Aug 2026 13:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183899; cv=none; b=uz4jDrRopz0omN0tOQsgHqnZNaN9CSpdBw+E4NXPbSYAoI/SYdMumGa9hOHkuQ4PV/mzkpNzh86ruhTdTi0Y1gRQA8kjhpFFOmEoCpYv4ar46KAJnXDOExCAZJxhpeCyxuMGI3q4K8uSxcJe44dY3ZL/h5JO/ylF5MuI4/hfZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183899; c=relaxed/simple;
	bh=iFJCfpRqwuOkvNt7G9lVIOoQbPuxZKN1Q63mAfehW1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PR01gUfeXBU6ezfqUHqWXyhkHeguEFN4SFyftyGv/+iEpYzwdHMIImTRFoF8AK3e8RBTMlbIlmWQoYIIMtHYcBcdVdBPjcna7MwEpLOWS5BWhdeuiMnG1yuixXmZHwBhK+qvp+/S+HFN98p9o8gkEduKe6pJUUY1lq7O1w2ssgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bl9FLwE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bl9FLwE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91021F00A3D;
	Mon, 31 Aug 2026 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183897;
	bh=5EYOOfs2MFQSXCyk4VnYLNrx8jys++FtwygfapBYvHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bl9FLwE0jGbtWZWUeqhjDWbNCHPrHuLrX6lMBgwflBtHldPRtd941eRFNRSgMvtah
	 U2ztVPLhCGHj6u0nmVWxKsdPIsVcX4IOvMuW2mcNZswrGQ0Di/lFEORyWF9jYCxuIg
	 JNS5aWJJH+92ZpCoKfa5v+ksrbjaqiiIP7IbQMZBD5CMY4ws4amHIpPQ6wx3snLCmk
	 2IQYckPot9K8vMezps1KgpAgiBbrT2Vd56vZJXPn6bBRqCtXGxk8McIYws5XVYXARp
	 iwhzyrQo/fAxqsobOQTkG7WoG/TOQxt8RNQS1M7SwdS43woj/8kHysD1wBvClVQOIx
	 6qkq7yiYqMriQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Jarkko Nikula <jarkko.nikula@bitmer.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sen@ti.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: ti: omap3pandora: update board check to use DT compatible
Date: Mon, 31 Aug 2026 09:26:36 -0400
Message-ID: <20260831133314.4125787-368-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit 45efb8fbdae303539e7fb5562e147583d4ed63ad ]

The omap3pandora driver contains a check for the ARM machine ID via the
machine_is_omap3_pandora() macro. The board concerned now supports
only FDT booting, which does not use machine IDs, and therefore the
code should be updated to check the DT compatible property instead. The
legacy board file for this machine was removed in commit 7fcf7e061edd
("ARM: OMAP2+: Remove legacy booting support for Pandora").
The presence of this machine ID check prevents the removal of machine
IDs no longer used by the kernel from arch/arm/tools/mach-types,
because the machine_is_*() macros are generated from mach-types. To
resolve this issue, use of_machine_is_compatible() instead.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[ASoC: ti: omap3pandora]` `[update]` — Update OMAP3 Pandora
board detection to use device-tree compatible strings instead of ARM
machine ID.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Ethan Nelson-Moore `<enelsonmoore@gmail.com>`
  (author)
- **Acked-by:** Jarkko Nikula `<jarkko.nikula@bitmer.com>`
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Link:, or Cc:
  stable@vger.kernel.org in the committed message (v1 had Cc: stable; v3
  removed it per review)
- Notable: maintainer ack and ASoC maintainer sign-off

### Step 1.3: Body analysis
**Record:**
- **Bug:** `machine_is_omap3_pandora()` relies on legacy ARM machine
  IDs; Pandora boots only via FDT since legacy board support was removed
  in `7fcf7e061edd` (2015).
- **Symptom:** The ASoC module’s `module_init()` returns `-ENODEV`, so
  the Pandora audio card never registers on DT-booted systems.
- **Secondary motivation:** The `machine_is_*()` reference blocks
  cleanup of unused `mach-types` entries.
- **Root cause:** Board detection uses `MACH_TYPE_OMAP3_PANDORA` while
  DT boot matches generic `OMAP3_DT` / `OMAP36XX_DT` machine descriptors
  and sets `__machine_arch_type` accordingly (see
  `arch/arm/kernel/devtree.c:235`).

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although framed partly as mach-types maintenance, this
is a functional board-detection bug: DT-booted Pandora boards do not
match `machine_is_omap3_pandora()`, so audio never initializes. v2
changelog softened v1’s “always fails” wording, but on normal DT boot
`__machine_arch_type` is set from the matched DT machine descriptor, not
`MACH_TYPE_OMAP3_PANDORA`.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `sound/soc/ti/omap3pandora.c` (+3 / -2 net, ~5 logical lines
  changed)
- **Functions:** `omap3pandora_soc_init()` only
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (includes):** Adds `<linux/of.h>`, removes `<asm/mach-
  types.h>` — switches from machine-ID API to OF API.
- **Hunk 2 (`omap3pandora_soc_init`):**
  - **Before:** `if (!machine_is_omap3_pandora()) return -ENODEV;`
  - **After:** `if
    (!of_machine_is_compatible("openpandora,omap3-pandora-600mhz") &&
    !of_machine_is_compatible("openpandora,omap3-pandora-1ghz")) return
    -ENODEV;`
  - **Path affected:** `module_init()` gate for the entire Pandora audio
    driver.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix (board detection).** On DT boot,
Pandora DTs use compatibles `openpandora,omap3-pandora-{600mhz,1ghz}`
plus generic `ti,omap3430`/`ti,omap3630`. Kernel matches generic
OMAP3/OMAP36xx DT machine descriptors; `__machine_arch_type` is not
`MACH_TYPE_OMAP3_PANDORA` (1761). The old check always fails on DT boot,
blocking driver registration.

### Step 2.4: Fix quality
**Record:** Obviously correct. Matches DT files in-tree and the pattern
used by sibling OMAP board drivers (`rx51.c`, `n810.c`). Minimal change,
no API changes, very low regression risk. Only Pandora DT compatibles
pass the new check.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Current `machine_is_omap3_pandora()` gate is long-standing
driver code. Legacy Pandora board file removed in `7fcf7e061edd`
(2015-07-16). DT support added in `771048f59d068`, `b715da74deaf`,
`9ccd0106c9db` (2015-03-16). Mismatch between DT-only boot and machine-
ID check has existed since ~2015.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in committed version (removed in v2
after review).

### Step 3.3: Related file history
**Record:** No related omap3pandora fixes in recent history. A larger
rewrite series (“Rewrite sound card driver as a platform driver with
DT”, Nikolaus Schaller, 2026) exists on mailing lists but is not in this
tree and would be unsuitable for stable anyway.

### Step 3.4: Author context
**Record:** Ethan Nelson-Moore appears to be a board-specific
contributor. Patch acked by Jarkko Nikula and signed off by Mark Brown
(ASoC maintainer).

### Step 3.5: Dependencies
**Record:** Standalone. Requires only existing DT compatibles and
`of_machine_is_compatible()`, both present in this tree. No series
prerequisites.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** Patch went through v1 → v2 → v3 (May 2026). v2 changelog:
removed Fixes: tags and corrected claim that machine IDs “always fail” —
noted they can work if bootloader passes ID. v3 is the committed form.
Lore fetch blocked by bot protection; details corroborated via
Ratatoskr/search results.

### Step 4.2: Reviewers
**Record:** Acked-by Jarkko Nikula; Signed-off-by Mark Brown.
Appropriate ASoC maintainers involved.

### Step 4.3: Bug reports
**Record:** No syzbot, bugzilla, or user crash reports. Functional
hardware-enablement issue, not a sanitizer finding.

### Step 4.4: Related patches
**Record:** v1 included Cc: stable; final v3 does not. Larger DT
platform-driver rewrite is a separate future effort.

### Step 4.5: Stable list history
**Record:** Not investigated on lore stable list (fetch blocked). No
evidence of prior stable rejection.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `omap3pandora_soc_init()` (modified gate only).

### Step 5.2: Callers
**Record:** Called via `module_init()` when `snd-soc-omap3pandora.ko` is
loaded (`CONFIG_SND_SOC_OMAP3_PANDORA=m` in `omap2plus_defconfig`). Runs
in process context during module load, after DT is populated — safe for
`of_machine_is_compatible()`.

### Step 5.3: Callees
**Record:** `of_machine_is_compatible()`, then existing
`platform_device_alloc/add`, GPIO/regulator setup unchanged.

### Step 5.4: Reachability
**Record:** Triggered when distro/user loads the omap3pandora audio
module on OpenPandora hardware booted from DT (the only supported method
since 2015). Direct user-visible impact: audio card registration.

### Step 5.5: Similar patterns
**Record:** `sound/soc/ti/rx51.c:364` uses `machine_is_nokia_rx51() ||
of_machine_is_compatible("nokia,omap3-n900")`.
`sound/soc/ti/n810.c:289-291` uses only DT compatibles. omap3pandora was
the outlier still using machine ID only.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `sound/soc/ti/omap3pandora.c:226` still has
`machine_is_omap3_pandora()`. DT files with correct compatibles exist at
`arch/arm/boot/dts/ti/omap/omap3-pandora-{600mhz,1ghz}.dts`. Legacy
board file is gone (`7fcf7e061edd` present). `mach-types` still lists
`omap3_pandora` at line 325.

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git apply --check` against
current tree. No conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** No equivalent DT-compatible check already applied in this
tree.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** **ASoC / OMAP3 Pandora audio driver** — PERIPHERAL (niche
embedded hardware: OpenPandora handheld).

### Step 7.2: Activity
**Record:** Mature, low-churn driver. OMAP DT infrastructure stable.
Recent activity is this board-detection fix and a proposed larger DT
rewrite.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** OpenPandora users with `CONFIG_SND_SOC_OMAP3_PANDORA`
enabled (present in `omap2plus_defconfig`). Small but real user
population.

### Step 8.2: Trigger conditions
**Record:** DT boot (standard for Pandora since 2015) + omap3pandora
module load. Common for intended users, not a race or obscure corner
case.

### Step 8.3: Failure mode severity
**Record:** Audio driver silently fails init (`-ENODEV`); no kernel
crash, corruption, or security issue. **Severity: MEDIUM** — broken
hardware functionality (“oh, that's not good” per stable rules), not
CRITICAL.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores Pandora audio on the only supported boot path;
  enables mach-types cleanup; follows established OMAP DT-detection
  pattern.
- **Risk:** Very low — 5-line change, board-specific compatibles only.
- **Ratio:** Moderate-to-good benefit for affected users, minimal risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real functional bug: DT-booted Pandora never passes board check
- Small, surgical, maintainer-reviewed fix
- Applies cleanly to 6.18.43
- Matches in-tree DT compatibles
- Precedent in sibling OMAP ASoC drivers
- Qualifies as hardware quirk / board-detection fix under stable
  exceptions

**AGAINST backport:**
- Niche hardware, small user base
- Bug present since ~2015 without crash/security impact
- No user bug reports or syzbot findings
- Final commit omits Cc: stable (not decisive per review rules)
- Strict “important issue” bar (crash/corruption/deadlock) not met

**Unresolved:** No direct user bug report verified; lore thread not
fully readable due to bot protection.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic verified against DT
   files and `devtree.c` behavior; maintainer acked.
2. Fixes a real bug affecting users? **PASS** — Pandora audio module
   cannot initialize on DT boot.
3. Important issue? **PASS (borderline)** — hardware functionality
   broken for affected users; hardware-quirk category, not
   crash/security.
4. Small and contained? **PASS** — ~5 lines, one file.
5. No new features or APIs? **PASS** — detection mechanism change only.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception category
**Record:** Hardware quirk / board-detection workaround — analogous to
DT updates enabling already-supported hardware.

### Step 9.4: Decision rationale

For **this 6.18.43 tree**, the buggy code exists, DT is the only Pandora
boot path, and the fix is minimal and correct. Without it,
`CONFIG_SND_SOC_OMAP3_PANDORA` is effectively dead on real hardware.
While the user base is small and severity is functional rather than
catastrophic, stable rules explicitly accept fixes for “hardware quirk”
issues and “real bug[s] that bother people.” This fits that pattern and
mirrors accepted OMAP board-detection fixes (`rx51`, `n810`).

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided content;
  noted v1→v3 evolution via web search.
- [Phase 2] Read full `sound/soc/ti/omap3pandora.c`; confirmed diff
  scope and `module_init` gate.
- [Phase 3] `git describe HEAD`: v6.18.43-1-gc7f0dac02d232 / kernel
  6.18.43.
- [Phase 3] `git show 7fcf7e061edd`: legacy Pandora board file removed
  2015-07-16; present in tree.
- [Phase 3] `git show b715da74deaf`, `9ccd0106c9db`, `771048f59d068`: DT
  files added 2015-03-16; present in tree.
- [Phase 3] `git blame` on lines 222-230: long-standing
  `machine_is_omap3_pandora()` check.
- [Phase 4] Web search: found v1/v2/v3 thread; v2 changelog correction
  about machine IDs; lore direct fetch blocked.
- [Phase 4] `b4 dig`: no result for attempted lookups.
- [Phase 5] Grep `of_machine_is_compatible` in `sound/soc/ti/rx51.c`,
  `n810.c`: confirmed precedent.
- [Phase 5] Read `arch/arm/kernel/devtree.c:234-235`: DT boot sets
  `__machine_arch_type = mdesc->nr`.
- [Phase 5] Read `arch/arm/mach-omap2/board-generic.c:130-161`: Pandora
  matches generic OMAP3/OMAP36xx DT descriptors, not OMAP3_PANDORA.
- [Phase 5] Grep `arch/arm/tools/mach-types`: `omap3_pandora` = 1761.
- [Phase 6] Grep `sound/soc/ti/omap3pandora.c`: buggy
  `machine_is_omap3_pandora()` at line 226.
- [Phase 6] Grep DT files: compatibles
  `openpandora,omap3-pandora-600mhz` and
  `openpandora,omap3-pandora-1ghz` present.
- [Phase 6] `git apply --check`: patch applies cleanly to current tree.
- [Phase 6] Grep `CONFIG_SND_SOC_OMAP3_PANDORA`: enabled as module in
  `omap2plus_defconfig`.
- [Phase 7] Read `Documentation/process/stable-kernel-rules.rst`:
  hardware quirk criterion applies.
- [Phase 8] Traced failure mode: `module_init` returns `-ENODEV` → no
  audio card registered.

**YES**

 sound/soc/ti/omap3pandora.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ti/omap3pandora.c b/sound/soc/ti/omap3pandora.c
index 808fb6765c05f..2ddd14e8f6b6c 100644
--- a/sound/soc/ti/omap3pandora.c
+++ b/sound/soc/ti/omap3pandora.c
@@ -11,12 +11,12 @@
 #include <linux/delay.h>
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
 
-#include <asm/mach-types.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 
 #include "omap-mcbsp.h"
@@ -223,7 +223,8 @@ static int __init omap3pandora_soc_init(void)
 {
 	int ret;
 
-	if (!machine_is_omap3_pandora())
+	if (!of_machine_is_compatible("openpandora,omap3-pandora-600mhz") &&
+		!of_machine_is_compatible("openpandora,omap3-pandora-1ghz"))
 		return -ENODEV;
 
 	pr_info("OMAP3 Pandora SoC init\n");
-- 
2.53.0

