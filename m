Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614F33D0923;
	Mon, 30 Mar 2026 12:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874326; cv=none; b=ul7EiynGW018/bKfuWGWF1tE8PHa9DR7ic7VBW5mnsQzrvYQJNjVvq0OQe5HxWU25/iNrJ72MH5SmoOyBFjhIHz42FTTLT7swb3+Lx/tmKBHQZgyuoOYJQelglLejk8gqVhbIMo7T1OJZw7U+iOfOCcsxwT5IdySUDWhyF6XKv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874326; c=relaxed/simple;
	bh=KRWmWuUtSo9tAqvjpp8SHlLXnSCjYWx3vpTul8pHxgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6Cj53K2gADIrdKYgTJQ2rBan85ga6jLTzkKbsbG6agMkFm+c/9shc3xOIdDslj9KnM+sSKNOTrZ5GmV8w4g76hGc12JmXEUcXj02dVK92lzdhAZ6RBb3t+fsWpQr+37brxuq3rJIe3Mm+QqVLLNwhEmz8OWtq1h1iXKsYpAt4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obZJztLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obZJztLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16480C2BCB1;
	Mon, 30 Mar 2026 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874326;
	bh=KRWmWuUtSo9tAqvjpp8SHlLXnSCjYWx3vpTul8pHxgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obZJztLEKqIly6dePMi2VO9rkW24dwYn3upPW1k3G/ipF/xEyIgLorUt87vbvsqT/
	 2AMQgMG+DcO2P9g27h2SrVJqkcR5FpQ0FquJ/S9qVhORS9bNMtQTuigBWdjkkxGyc2
	 uLsXYFOdLU31LPxkMdZ6C8MvEIbBgJlj/t2ca8r/72lbNAzgfLrrtEo4gqeH31Ktom
	 i10sXIBnate2Bpp++7knnUl+Eo4ZOKhqPqOQy/yoRBHHxuK+wYLgozL5eEbSOnJnpo
	 JT6DI/hhtTr0N8U1Gg2jTg3bvAvhawBp0ziICSER7Ym/UGd5Wp/ih5FLxvC6RmdPJl
	 pIr/9PaIQn2hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hasun Park <hasunpark@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ASoC: amd: acp: add ASUS HN7306EA quirk for legacy SDW machine
Date: Mon, 30 Mar 2026 08:38:15 -0400
Message-ID: <20260330123842.756154-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hasun Park <hasunpark@gmail.com>

[ Upstream commit 2594196f4e3bd70782e7cf1e22e3e398cdb74f78 ]

Add a DMI quirk entry for ASUS HN7306EA in the ACP SoundWire legacy
machine driver.

Set driver_data to ASOC_SDW_ACP_DMIC for this board so the
platform-specific DMIC quirk path is selected.

Signed-off-by: Hasun Park <hasunpark@gmail.com>
Link: https://patch.msgid.link/20260319163321.30326-1-hasunpark@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: Subject Line**
Record: [ASoC: amd: acp] [add] [DMI quirk for ASUS HN7306EA to select
ACP DMIC path in legacy SoundWire machine driver]

**Step 1.2: Tags**
Record:
- `Signed-off-by: Hasun Park <hasunpark@gmail.com>` — author/contributor
- `Link:
  https://patch.msgid.link/20260319163321.30326-1-hasunpark@gmail.com` —
  patch submission
- `Signed-off-by: Mark Brown <broonie@kernel.org>` — ASoC subsystem
  maintainer
- No Fixes: tag (expected for hardware quirk additions)
- No Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc: stable
  (absence expected)

**Step 1.3: Body**
Record: The commit explains it adds a DMI quirk entry for the ASUS
HN7306EA board and sets `driver_data` to `ASOC_SDW_ACP_DMIC` so the
platform-specific DMIC quirk path is selected. Without this quirk, the
board's built-in digital microphone will not be enabled through the ACP
SoundWire path. No stack traces, crash reports, or version information
given — this is standard for a board-specific quirk addition.

**Step 1.4: Hidden Bug Fix**
Record: Yes — while framed as "add," this is a hardware enablement fix.
Without the quirk, the DMIC path is not selected, and the microphone
does not function on this specific laptop. Adding board-specific DMI
quirks is the standard Linux mechanism for making specific hardware work
correctly.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: Inventory**
Record: 1 file modified: `sound/soc/amd/acp/acp-sdw-legacy-mach.c`, +8
lines, 0 removed. Only the static `soc_sdw_quirk_table[]` data array is
extended with one new entry before the `{}` terminator. Scope: single-
file, single-table-entry, trivially scoped.

**Step 2.2: Code Flow Change**
Record: Before: No DMI match for "ASUSTeK COMPUTER INC." / "HN7306EA" →
the global `soc_sdw_quirk` stays at its default `RT711_JD1` → DMIC path
not selected at line 419. After: DMI match sets `soc_sdw_quirk =
ASOC_SDW_ACP_DMIC` via `soc_sdw_quirk_cb()` → at line 419,
`soc_sdw_quirk & ASOC_SDW_ACP_DMIC` is true → `dmic_num = 1` →
`create_dmic_dailinks()` is called at line 454, enabling the built-in
digital microphone.

Verified code path from file:

```419:420:sound/soc/amd/acp/acp-sdw-legacy-mach.c
        if (soc_sdw_quirk & ASOC_SDW_ACP_DMIC || mach_params->dmic_num)
                dmic_num = 1;
```

```450:457:sound/soc/amd/acp/acp-sdw-legacy-mach.c
        if (dmic_num > 0) {
                if (ctx->ignore_internal_dmic) {
                        dev_warn(dev, "Ignoring ACP DMIC\n");
                } else {
                        ret = create_dmic_dailinks(card, &dai_links,
&be_id, 0);
                        if (ret)
                                return ret;
                }
```

**Step 2.3: Bug Mechanism**
Record: Category: Hardware workaround / DMI quirk table entry. The board
requires `ASOC_SDW_ACP_DMIC` to be set so the DMIC DAI link is created.
Without it, the standard default (`RT711_JD1`) does not enable the DMIC
path.

**Step 2.4: Fix Quality**
Record: Obviously correct — follows the exact same struct pattern as
every other entry in the table (AMD, Dell, Lenovo). Minimal and
surgical: 8 lines of pure static data. Zero regression risk for other
machines: only fires when both `DMI_BOARD_VENDOR == "ASUSTeK COMPUTER
INC."` AND `DMI_PRODUCT_NAME == "HN7306EA"` match.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: Blame**
Record: `git blame` confirms the quirk table was introduced by
`2981d9b0789c44` (Vijendar Mukunda, 2024-11-13, "ASoC: amd: acp: add
soundwire machine driver for legacy stack") with just one entry (AMD
Birman-PHX). Dell entries added by `4bb5b6f13fd83b` (2025-02-07) and
`3254959b4dd065` (2025-09-03). Lenovo entries added by `aa7b7452bb742f`
(2026-02-18). The infrastructure for `ASOC_SDW_ACP_DMIC` and the DMIC
path has existed since the driver was created.

**Step 3.2: Fixes Tag**
Record: No Fixes: tag present — not applicable for a quirk addition.

**Step 3.3: File History**
Record: 13 commits to this file since creation. Other DMI quirk
additions (Dell, Lenovo) follow the identical pattern. This ASUS commit
is standalone — not part of a series.

**Step 3.4: Author**
Record: `git log --author='Hasun Park'` returns empty for
`sound/soc/amd/` — this appears to be an external contributor (likely
owns the hardware). The patch was merged by Mark Brown, the ASoC
subsystem maintainer, which is a strong quality endorsement.

**Step 3.5: Dependencies**
Record: No dependencies. The `ASOC_SDW_ACP_DMIC` constant (`BIT(5)` in
`soc_amd_sdw_common.h`), the `soc_sdw_quirk_cb` callback, and the DMIC
path all exist since the driver's introduction in v6.13. Fully self-
contained.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1-4.4:** Record: The `Link:` tag provides the patch message ID.
Direct access to lore.kernel.org and patch.msgid.link was blocked by bot
protection (Anubis). The patch was merged by Mark Brown directly. No
NAKs or concerns are evidenced (the commit reached mainline). Could not
verify explicit stable nominations or review comments from primary
sources.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: Key Functions**
Record: No function bodies modified — only the `soc_sdw_quirk_table[]`
static data. Consumers: `soc_sdw_quirk_cb()`, `mc_probe()`,
`soc_card_dai_links_create()`, `create_dmic_dailinks()`.

**Step 5.2: Callers**
Record: `soc_sdw_quirk_table` is consumed by `dmi_check_system()` at
line 498 in `mc_probe()`, the platform driver `.probe` callback.
`mc_probe()` is registered via `soc_sdw_driver` (line 570) matching
platform device ID `"amd_sdw"`.

**Step 5.3: Callees**
Record: `soc_sdw_quirk_cb()` (line 35) simply assigns `soc_sdw_quirk =
(unsigned long)id->driver_data`. Downstream,
`soc_card_dai_links_create()` checks the bit at line 419 and
conditionally enables DMIC DAI link creation.

**Step 5.4: Call Chain**
Record: PCI probe → `acp63_machine_register()` →
`platform_device_register_data(..., "amd_sdw", ...)` → `mc_probe()` →
`dmi_check_system(soc_sdw_quirk_table)` → `soc_card_dai_links_create()`
→ DMIC enabled if `ASOC_SDW_ACP_DMIC` set. Reachable automatically on
boot for matching AMD SoundWire hardware.

**Step 5.5: Similar Patterns**
Record: `acp-sdw-sof-mach.c` has an analogous `ASOC_SDW_ACP_DMIC` gating
mechanism (lines 29, 312), confirming this is an established subsystem
pattern. The same quirk table pattern is used for Dell and Lenovo
entries in the same file.

===============================================================
PHASE 6: STABLE TREE ANALYSIS
===============================================================

**Step 6.1: File Existence in Stable Trees**
Record: Verified via `git cat-file -e`:
- `stable/linux-6.6.y`: **MISSING** (driver not present)
- `stable/linux-6.12.y`: **MISSING** (driver not present)
- `stable/linux-6.13.y`: **EXISTS** (3 commits to file — base + Dell
  quirks)
- `stable/linux-6.14.y`: **EXISTS** (3 commits to file — base + Dell
  quirks)
- `stable/linux-6.19.y`: **EXISTS** (13 commits — all quirks including
  Lenovo)

The driver and `ASOC_SDW_ACP_DMIC` infrastructure exist in **6.13.y,
6.14.y, and 6.19.y**.

**Step 6.2: Backport Complications**
Record: The patch inserts one entry before the `{}` terminator in
`soc_sdw_quirk_table[]`. In 6.13.y and 6.14.y, the table has fewer
entries (no Lenovo rows), so there will be a minor context offset, but
the append-before-terminator pattern makes this trivially applicable.
Expected: clean apply or trivial context adjustment in all three stable
trees.

**Step 6.3: Related Fixes in Stable**
Record: No HN7306EA-specific fix exists in any stable tree. Other
Dell/Lenovo quirks have been backported to various stable trees,
confirming this class of change is accepted.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: Subsystem**
Record: `sound/soc/amd/acp` — ASoC AMD Audio Co-Processor SoundWire
machine driver. Criticality: IMPORTANT — audio is a critical user-facing
function on laptops, though this is driver/platform-specific, not
universal.

**Step 7.2: Activity**
Record: Actively maintained — 13 commits to this single file since
creation, with regular quirk additions for Dell, Lenovo, and now ASUS.
Mark Brown (ASoC maintainer) actively merges patches.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: Affected Users**
Record: Device-specific — owners of the ASUS HN7306EA (ProArt PX13)
laptop running kernel 6.13+ with the AMD SoundWire audio stack.

**Step 8.2: Trigger Conditions**
Record: Triggers on every boot during driver probe via
`dmi_check_system()`. Every user of this laptop model is affected. No
special configuration or user action required.

**Step 8.3: Failure Mode**
Record: Without the quirk, the built-in digital microphone is not
enabled (the DMIC DAI link is never created). This is a "hardware
doesn't work" issue — microphone non-functional. Severity: MEDIUM-HIGH
for affected users (broken audio input on a laptop is a significant
usability issue).

**Step 8.4: Risk-Benefit Ratio**
Record:
- BENEFIT: High for affected users — enables the laptop's built-in
  microphone
- RISK: Essentially zero — DMI match table entry only triggers on exact
  vendor+product match; 8 lines of pure static data; uses existing
  infrastructure; well-established pattern
- Ratio: Strongly favorable

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: Evidence**

FOR backporting:
- Classic hardware DMI quirk addition — explicitly listed as an allowed
  exception category
- 8 lines, single file, pure static data addition, trivially correct
- Zero regression risk — only affects boards matching exact DMI strings
- Fixes real user issue: broken DMIC (microphone non-functional) on ASUS
  HN7306EA
- Merged by ASoC subsystem maintainer Mark Brown
- Self-contained with no dependencies
- Infrastructure exists in 6.13.y, 6.14.y, and 6.19.y stable trees
- Same pattern as Dell and Lenovo quirks already backported to stable
  trees

AGAINST backporting:
- Only affects a single laptop model (normal for quirks — not a valid
  concern)
- Not a crash/security/corruption fix (but hardware enablement quirks
  are an explicit exception)

UNRESOLVED:
- Could not access lore.kernel.org to verify mailing list review
  discussion
- No primary end-user bug report verified (author is likely the affected
  user)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — trivial table entry following
   exact same pattern as all existing entries; merged by maintainer
2. Fixes a real bug? **YES** — broken DMIC on ASUS HN7306EA
3. Important issue? **YES** — non-functional microphone on a shipping
   laptop
4. Small and contained? **YES** — 8 lines, one file, one table entry
5. No new features or APIs? **YES** — just a DMI quirk data entry using
   existing code paths
6. Can apply to stable? **YES** — applicable to 6.13.y, 6.14.y, 6.19.y
   with clean or trivial context adjustment

**Step 9.3: Exception Category**
Record: **Hardware quirk/workaround** — This is a DMI quirk table entry
for a specific laptop, which is the textbook example of a stable-
appropriate exception. Dell and Lenovo quirks from the same table have
already been backported.

**Step 9.4: Decision**
This is a trivial, zero-risk DMI quirk table entry that enables the
built-in digital microphone on a specific ASUS laptop model. It falls
squarely into the "hardware quirks and workarounds" exception category
that is explicitly allowed in stable. The fix is 8 lines of pure static
data, uses existing infrastructure, and only affects the exact matching
hardware. The driver and `ASOC_SDW_ACP_DMIC` infrastructure exist in
stable trees 6.13.y, 6.14.y, and 6.19.y.

## Verification

- [Phase 1] Parsed commit message: "add ASUS HN7306EA quirk," tags
  include author SOB and Mark Brown (maintainer) SOB, Link to patch
- [Phase 2] Read `acp-sdw-legacy-mach.c`: verified `ASOC_SDW_ACP_DMIC`
  check at line 419 enables `dmic_num = 1`, which triggers
  `create_dmic_dailinks()` at line 454
- [Phase 2] Grep for `ASOC_SDW_ACP_DMIC`: found at line 29 (log_quirks),
  line 419 (DMIC enablement), and `soc_amd_sdw_common.h` line 28
  (`BIT(5)`)
- [Phase 3] `git blame` lines 41-115: confirmed table origin commit
  `2981d9b0789c44` (2024-11-13), Dell quirks from `4bb5b6f13fd83b` and
  `3254959b4dd065`, Lenovo from `aa7b7452bb742f`
- [Phase 3] `git show 2981d9b0789c44`: confirmed original driver
  introduction creating `acp-sdw-legacy-mach.c` (486 lines)
- [Phase 3] `git log --author='Hasun Park'`: no prior commits found in
  `sound/soc/amd/`
- [Phase 3] `git log --oneline -20`: confirmed 13 commits to file, all
  quirk additions and driver evolution, no prerequisites for this patch
- [Phase 5] Traced call chain in code: `mc_probe()` line 498 calls
  `dmi_check_system(soc_sdw_quirk_table)`, then line 514 calls
  `soc_card_dai_links_create()`, which checks quirk at line 419
- [Phase 5] Grep confirmed analogous `ASOC_SDW_ACP_DMIC` pattern in
  `acp-sdw-sof-mach.c` (established subsystem pattern)
- [Phase 6] `git cat-file -e` across stable trees: file MISSING in 6.6.y
  and 6.12.y; EXISTS in 6.13.y, 6.14.y, 6.19.y
- [Phase 6] `git log stable/linux-6.13.y`: 3 commits (base + Dell
  quirks); `stable/linux-6.14.y`: 3 commits; `stable/linux-6.19.y`: 13
  commits (includes Lenovo)
- [Phase 6] Clean apply expected in all three applicable stable trees —
  trivial table entry append
- [Phase 8] Failure mode verified from code: without quirk,
  `ASOC_SDW_ACP_DMIC` not set → `dmic_num` stays 0 →
  `create_dmic_dailinks()` not called → DMIC non-functional
- UNVERIFIED: Could not access lore.kernel.org or patch.msgid.link
  (blocked by Anubis bot protection) — no reviewer discussion or NAKs
  verified

**YES**

 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 4f92de33a71a0..2e0f751afe250 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -111,6 +111,14 @@ static const struct dmi_system_id soc_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HN7306EA"),
+		},
+		.driver_data = (void *)(ASOC_SDW_ACP_DMIC),
+	},
 	{}
 };
 
-- 
2.53.0

