Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD6253FA26;
	Mon, 19 Oct 2026 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418738; cv=none; b=Nh/heiJSclZK0racGURBP9it+mCO9ceAsiRf/HgRjmP2BmrSB0yFxJaxc5OzOzOfK2zVG+RaTAj7FvB/LOReHk7nqa74XKTmbUn65BZVCnR+behmgN+4CIZfalUhftn64Z3mrIn/5lURuKO1F+GQ7AzsJvZRJ2aJ1VCinwp5I4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418738; c=relaxed/simple;
	bh=pOb0H8skd+AzcHB4DNgvfJakssKiJsR/9YQjTb3Lmf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9iw7nXIAlMtRNB4XmBAmHwOeZZTtYvla7L/zBwEfA5OXMkMEtu4ctmcQI3rNNIuBi7te3OqU+UImLu3TJXkfRTcFKA7sNNSARb0CWszOZfqL2OUtltW3FZ9Qol6nx80kOhF87SGJ9/FIa1O/W+YJtGwr6r/9RwgrlnnGbkpsyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFInfdJu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFInfdJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1A41F000C7;
	Mon, 19 Oct 2026 14:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418735;
	bh=x+wlokLDEGW8le5aJHkkAhHds91W1b7S+7cIxEqOJ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFInfdJuBX0QPcDGBhefC2q7Wd8BU+WONJz9XCdbLygcutNbiIOdfaLIoK1vO1qq/
	 whUSPSeEz1o3/xgal7RBXP/9IMjthKVn9xEi1h0mw1sWdjxnDpSBEBI5JLagXx+pCd
	 EYvbuYBEro/izpaft0EdwRXug+rcUPWckTfiFEN/CNZwB82bRdXyLkDD1ulSpdnNZU
	 xz2rV4RN8xCgLJ0bQS5VCOQhip+n3cYKJKy4RZiVxqlU/7LZKWHkELRXAYInmZm+10
	 ijEuEAyugBqsC7EUL388HcNAlUIP93Zcy6W0Apn+zVsRiPD6m5+2xAX8DwC9ZR4qBp
	 fJq06tTwswauw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Seiji Adachi <seiji_adachi@yahoo.co.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: amd: yc: Add Lenovo ThinkPad E16 Gen 2 (21JN) to quirks
Date: Mon, 19 Oct 2026 09:52:30 -0400
Message-ID: <20261019135441.1420968-459-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Seiji Adachi <seiji_adachi@yahoo.co.jp>

[ Upstream commit 4cae4ca34992d210d115e8e891f1e88c9df5f24c ]

Signed-off-by: Seiji Adachi <seiji_adachi@yahoo.co.jp>
Link: https://patch.msgid.link/20260917131851.2122144-1-seiji_adachi@yahoo.co.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a DMI hardware quirk for the existing AMD Yellow Carp ASoC
machine driver. The local tree is **6.18.57**
(`v6.18.57-155-gcdf239ca885b2`). The driver, quirk table, and
neighboring Lenovo E16 entries are all present here, so the patch is a
straightforward YES for this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ASoC/amd/yc] [Add] [Lenovo ThinkPad E16 Gen 2 DMI product
21JN to the Yellow Carp quirk table]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- No `Fixes:` tag (expected for this review class)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:` on the
  committed message
- `Link: https://patch.msgid.link/20260917131851.2122144-1-
  seiji_adachi@yahoo.co.jp`
- `Signed-off-by: Seiji Adachi <seiji_adachi@yahoo.co.jp>` (author)
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer)
- Ignore pipeline markers (`[Upstream commit ...]`, `Signed-off-by:
  Sasha Levin`)

Notable: the committed message is thin, but the mailing-list thread
(Phase 4) has the real bug report and `arecord -l` output. Absence of
`Cc: stable` is expected and is not a negative signal. Sibling E16 Gen 2
quirks for **21M5** and **21M6** in this same file *did* carry `Cc:
stable@vger.kernel.org`.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The git object itself has almost no body. The original submission text
(resend, same diff) is:

> Add ThinkPad E16 Gen 2 (21JN) to the DMI table in acp6x-mach.c to
enable the internal digital microphone (DMIC).

The earlier request in the same thread (17 Jul 2026) is more specific:
on a ThinkPad E16 Gen 2 (AMD Ryzen 7 7735HS, machine type 21JN), the
internal DMIC is not detected on Debian 13 **kernel 6.18**. The author
later confirmed the same failure on 7.0.13 and 7.1.8, with `arecord -l`
showing only analog HDA capture (`CX11880 Analog`), not the ACP DMIC
card.

Record:
- Bug: this SKU’s ACPI `_WOV` / `AcpDmicConnected` path does not enable
  ACP DMIC, so the machine driver bails out unless a DMI quirk matches
- Symptom: internal digital microphone is missing; only analog HDA
  capture appears
- Versions: reporter hit it on **6.18**, which is this tree
- Root cause: missing DMI product `21JN` in `yc_acp_quirk_table[]`

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hardware quirk: one
DMI entry so an already-supported DMIC path probes on this Lenovo SKU.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/soc/amd/yc/acp6x-mach.c` — **+7 / -0**
- Function/object: `yc_acp_quirk_table[]` (data only; no control-flow
  change)
- Scope: single-file surgical table insertion between existing `21J6`
  and `21M1` Lenovo entries

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, `dmi_first_match(yc_acp_quirk_table)` in `acp6x_probe()`
does not match product `21JN`, so `platform_set_drvdata()` is not
populated from the quirk and the probe returns `-ENODEV` if ACPI did not
already enable DMIC. After, that SKU matches, `driver_data` is
`&acp6x_card`, and the ACP DMIC card registers.

Verified probe logic in this tree:

```845:854:sound/soc/amd/yc/acp6x-mach.c
check_dmi_entry:
        /* check for any DMI overrides */
        dmi_id = dmi_first_match(yc_acp_quirk_table);
        if (dmi_id)
                platform_set_drvdata(pdev, dmi_id->driver_data);

        card = platform_get_drvdata(pdev);
        if (!card)
                return -ENODEV;
```

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Hardware workaround / DMI quirk.** Same pattern as
USB/PCI/codec quirks: the generic ACPI path is wrong/incomplete for this
laptop, so a DMI match enables the existing `acp6x_card` DMIC machine
driver. Not a UAF, race, leak, or crash-path fix.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. It copies the exact struct used by dozens of
neighboring Lenovo entries (`DMI_BOARD_VENDOR "LENOVO"` +
`DMI_PRODUCT_NAME "21JN"` + `.driver_data = &acp6x_card`). Regression
risk is confined to that DMI string: a false match would only affect a
different Lenovo product also named `21JN`, which is how this table is
designed. No locking, no API, no data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: The insertion sits between:
- `21J5` / `21J6`: `c0fc96fed7ffa` (syed sabakareem, 2022-08-02)
- `21J0`: `50ee641643dd0` (Johnny Hsieh, 2024-02-26)
- `21M1`: `cbc86dd0a4fe9f` (Uwe Kleine-König, 2024-11-22)

The Yellow Carp machine driver itself landed in `fa991481b8b22` (“ASoC:
amd: add YC machine driver using dmic”, 2021-10-18). The table has been
the supported way to enable DMIC on laptops with broken ACPI for years.
This is not new 7.x-only infrastructure.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. N/A. The “bug” is a missing SKU in a allow-
list, not a regression from a specific earlier commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same file has a long series of identical DMI additions. Directly
related E16 Gen 2 quirks already in this tree:
- `1d9ce4440414c` — “Support mic on Lenovo Thinkpad E16 Gen 2” (product
  **21M5**, `Cc: stable`)
- `0704a15b930cf` — “Support mic on another Lenovo ThinkPad E16 Gen 2
  model” (product **21M6**, `Cc: stable`)

This commit is the same class of fix for SKU **21JN**. Standalone; not
patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: `git log --author='Seiji Adachi' -- sound/soc/amd/` shows only
this commit. Author is an end user with the hardware, not the subsystem
maintainer. Maintainer Mark Brown applied it to `sound.git` `for-7.3`.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. It only needs `yc_acp_quirk_table[]`, `acp6x_card`, and
`acp6x_probe()`’s `dmi_first_match()` path, all present here. Confirmed
`21M5`/`21M6` ancestor commits are in this tree. Parent context already
has `21J6` then `21M1`, matching the hunk.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 99dcbf96a43ed`:
  https://patch.msgid.link/aqu4HOCmdCUs_unm@adriana (RESEND)
- Applied version: https://patch.msgid.link/20260917131851.2122144-1-
  seiji_adachi@yahoo.co.jp
- `b4 dig -a`: one series revision after a formatting-rejected RESEND;
  applied version is the git-formatted v1
- Thread also includes the Jul/Aug user reports on 6.18 / 7.0.13 / 7.1.8
- Mark Brown first asked for proper `submitting-patches.rst` formatting,
  then applied the reformatted patch to `for-7.3` as `4cae4ca34992`
- No NAK on the change itself; no reviewer concern about the DMI ID
- No explicit `Cc: stable` in review (not a negative)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included `Vijendar.Mukunda@amd.com` (AMD
audio), `broonie@kernel.org` (ASoC maintainer), `alsa-devel@alsa-
project.org`, `linux-sound@vger.kernel.org`. Mark Brown applied it. No
separate Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: The lore thread *is* the bug report. One user, ThinkPad E16 Gen
2 21JN-003SCD, internal DMIC missing on 6.18 (this series), still
missing after upgrading. `arecord -l` shows only HDA analog. Severity
from the reporter: laptop microphone does not work.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone one-patch series. Related historical patches are the
21M5/21M6 E16 Gen 2 quirks already in this file.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of `lore.kernel.org/stable` for this subject/SKU
found no prior stable discussion and no recorded reason to keep it out
of stable. (lore.kernel.org fetches returned 403; gnuweeb/patchew
mirrors and `b4 dig` were used instead.)

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function body changed. Data consumed by `acp6x_probe()`.
Table: `yc_acp_quirk_table[]`. Card: `acp6x_card`.

**Step 5.2: TRACE CALLERS**
Record: `acp6x_probe()` is `.probe` of `platform_driver
acp6x_mach_driver` (`name = "acp_yc_mach"`). The PCI driver
`sound/soc/amd/yc/pci-acp6x.c` registers that platform device as
`pdevinfo[2].name = "acp_yc_mach"` during ACP PDM-mode probe. Call path:
ACPI/PCI enumerate ACP → `pci-acp6x` probe → register `acp_yc_mach` →
`acp6x_probe()`. This runs at boot on Yellow Carp laptops, not from a
syscall, but it is the normal device-probe path users hit.

**Step 5.3: TRACE CALLEES**
Record: `dmi_first_match()`, `platform_set_drvdata()` /
`platform_get_drvdata()`, `devm_snd_soc_register_card()`. No
allocation/locking change in this commit.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable on this hardware at boot if
`CONFIG_SND_SOC_AMD_YC_MACH` is enabled (`depends on SND_SOC_AMD_ACP6x
&& ACPI`, x86/PCI). That is the intended config for AMD Ryzen 7735HS
ThinkPads. Userspace sees the result via ALSA PCM (`arecord -l`).
Unprivileged users do not trigger a crash; they just have no internal
DMIC.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: The same file is a catalog of this exact pattern (HP, Dell,
Lenovo, ASUS, MSI, Acer, …). 21M5 and 21M6 are the same laptop family.
This is a systematic, well-established quirk style, not a one-off
experiment.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. This is **6.18.y**. `sound/soc/amd/yc/acp6x-mach.c`,
`yc_acp_quirk_table[]`, and `acp6x_probe()`’s DMI override all exist.
Without the 21JN entry, this SKU does not match. The reporter’s original
failure was on Debian 13 kernel **6.18**, so the bug is native to this
branch, not introduced after it.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Context lines `21J6` then `21M1` are present.
Insertion is 7 identical-style lines. No refactor of the probe path
needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: 21M5 and 21M6 quirks are already in this tree; they do **not**
cover product name `21JN`. No alternate 21JN fix exists besides this DMI
row.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ASoC / AMD Yellow Carp (`sound/soc/amd/yc/`)** —
**PERIPHERAL** globally, **IMPORTANT** for users of this laptop. Config:
`SND_SOC_AMD_YC_MACH`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained via a stream of DMI quirk additions (V15 G6
ARP, Acer Aspire Go 15, HP Victus, Alienware, MSI Thin A15, …). Mature
driver (since 2021) with a stable quirk-table contract.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / DMI-specific: Lenovo ThinkPad E16 Gen 2
product **21JN** (AMD Yellow Carp / Ryzen 7735HS). No effect on other
machines.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot on that SKU. ACPI does not enable DMIC; without the
quirk, `acp6x_probe()` returns `-ENODEV`. Not a race. Not triggerable as
a privilege-escalation path.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Internal digital microphone never appears. Not a
panic/UAF/corruption bug. **MEDIUM** as a kernel-severity class,
**HIGH** as a user-visible hardware defect on an otherwise-supported
laptop. This is exactly the class the stable “hardware quirk” exception
is for.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: **HIGH** for 21JN owners on 6.18.y (microphone works);
  **zero** for everyone else
- Risk: **VERY LOW** (7-line DMI row, existing table, existing
  driver_data)
- Ratio: strongly favors backporting

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, user-reported hardware bug: internal DMIC missing on ThinkPad
  E16 Gen 2 21JN
- Reporter reproduced it on **kernel 6.18**, i.e. this tree
- Canonical stable exception: DMI quirk in an existing driver
- Sibling SKUs 21M5/21M6 already use the same quirk and were sent to
  stable
- 7 lines, identical to existing entries, applied by ASoC maintainer
  Mark Brown
- Driver and table exist here since 2021/2022; no missing prerequisites
- Applies cleanly between `21J6` and `21M1`

AGAINST:
- Not a crash, deadlock, or security bug
- Commit message on the git object is sparse (bug detail lives on lore)
- Single reporter, not a maintainer-authored patch

UNRESOLVED:
- Could not fetch lore.kernel.org directly (403); thread recovered via
  `b4 dig`, gnuweeb, and patchew
- Could not independently dump DMI from the reporter’s machine beyond
  the strings they posted

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — identical table pattern;
   user tested on the affected laptop; maintainer applied it
2. Fixes a real bug that affects users? **PASS** — internal mic not
   enumerated
3. Important issue? **PASS** under the hardware-quirk exception (broken
   input device on a shipping laptop)
4. Small and contained? **PASS** — +7 lines, one file, one DMI row
5. No new features or APIs? **PASS** — no new driver, syscall, or module
   param; enables existing DMIC card on one SKU
6. Can apply to the local tree? **PASS** — 6.18.y has the file, table,
   probe path, and hunk context

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / workaround** (DMI match in
`yc_acp_quirk_table[]`). Closely analogous to USB/PCI/codec ID
additions.

**Step 9.4: MAKE YOUR DECISION**
This belongs on 6.18.y. The machine driver is already here; only this
Lenovo product ID is missing; the user-visible failure is a non-working
internal microphone; the change is the same 7-line DMI addition already
used for other E16 Gen 2 SKUs.

Verification:
- [Phase 1] `git describe HEAD` / `make kernelversion` / Makefile: local
  tree is **v6.18.57** (6.18.y)
- [Phase 1] Parsed tags: author SOB, Mark Brown SOB, msgid Link; no
  Fixes/Reported-by/Cc:stable on the git object
- [Phase 1/4] Original patch body and Jul 17 report: DMIC missing on
  Debian 13 kernel 6.18; DMI vendor LENOVO, product 21JN
- [Phase 2] Diff: +7 lines in `yc_acp_quirk_table[]` only;
  `acp6x_probe()` uses `dmi_first_match()` then `-ENODEV` if no card
- [Phase 3] `git blame -L 220,260 sound/soc/amd/yc/acp6x-mach.c`:
  neighbors from 2022–2024; driver added in `fa991481b8b22` (2021)
- [Phase 3] `git merge-base --is-ancestor 1d9ce4440414c HEAD` and
  `0704a15b930cf`: 21M5/21M6 E16 quirks **are** in this tree; both had
  `Cc: stable`
- [Phase 3] No `Fixes:` tag to follow
- [Phase 3] Author has no other `sound/soc/amd` commits here
- [Phase 4] `b4 dig -c 99dcbf96a43ed`: lore RESEND at
  patch.msgid.link/aqu4HOCmdCUs_unm@adriana; applied msgid
  20260917131851.2122144-1; Mark Brown applied to for-7.3 as
  4cae4ca34992
- [Phase 4] `b4 dig -a`: RESEND then properly formatted PATCH; no v2
  technical changes
- [Phase 4] `b4 dig -w`: AMD audio + broonie + alsa-devel/linux-sound
- [Phase 4] gnuweeb thread: no NAK of the quirk; only formatting
  feedback
- [Phase 4] lore.kernel.org WebFetch: 403; used b4/gnuweeb/patchew
  instead
- [Phase 4] stable list search: no hit for this SKU
- [Phase 5] Callers: `pci-acp6x.c` registers `"acp_yc_mach"`; probe is
  boot-time on ACP PDM platforms
- [Phase 5] Kconfig: `SND_SOC_AMD_YC_MACH` depends on `SND_SOC_AMD_ACP6x
  && ACPI`
- [Phase 6] Pre-patch context in this tree has `21J6` then `21M1`;
  `21JN` is the missing row; apply is clean
- [Phase 6] `rg 21JN` confirms the entry is the standard Lenovo match
- [Phase 8] Failure mode verified against probe: no card → `-ENODEV` →
  no ACP DMIC PCM; matches `arecord -l` in the report
- UNVERIFIED: live DMI dump from the reporter’s machine (only the
  strings they mailed)

The patch is a 7-line DMI quirk for existing AMD YC DMIC support. It
fixes a real, 6.18-reproduced microphone failure on ThinkPad E16 Gen 2
21JN, matches the established stable quirk exception, and applies
cleanly here.

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 8e203c034851f..507c07efc069b 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -234,6 +234,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21JN"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

