Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EA9528E68;
	Mon, 19 Oct 2026 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418578; cv=none; b=kbra1v9p5VYdIO3bmCxIbb/TTukfEpi7hBTOmxDZH/O+QRTujgOBRnTEc7eK2Z2KlInU6OJMhraa2OChgH2WTiC6LykYN82l8yQ+Leyr94ZCb78zH3qe3M763qxZSSXhmmUWcNfWz0iRS25iOzxRURrdcPlGLB1K7iDR67M4aEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418578; c=relaxed/simple;
	bh=mxgUwr6eBLDTr3uKoTKvcNKJHZ4U7iU0rHWnG5sCgGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGtdcmtJOZKdpdfTe3YsECER/an/vAlw69pPAueI6pbtQh/GiPtOsVLZbrXAjNppQYldoJcym1hbSXnKchMrJG9ZhJpVDMMY1j1xnq87N3OvW6W/8ADfhCBBEiMFcovXal2Xyv/ChL1FURprxD5xHcNWOZEa351HzvhhD/lP0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CU9SAHCx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CU9SAHCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293D41F000CC;
	Mon, 19 Oct 2026 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418575;
	bh=4+ql4p3vcgQx02kQf+GRMuwllGIpGjZYMql1bdoHiOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CU9SAHCxIbVAtWPqFl6/lNgWh1InzVqESYolABan5DQqtftHW0ob1IA3h871xpciX
	 gIA/cbKp6SQSKf8R/o20gwj6tFrsKaxgbCM8PnG9VAVbFK6YPRMd+YGenxpfqmNyNR
	 whGiUL2oDovzenuVVK4GzKBHb3s+yAEP/ZP7AXHke7N90YQCmtzUKPQWRmcUgDN33w
	 s2ZLMi2gSGg4h+aNGX730YsOK35jGdU/LXaih42zJJ5lZJp8C0emiMSx9LwxWG6c6d
	 C37gUoea29i0Kgmte31VLkBh4Axbbn3Hn9CDEqQHwk+JELjU1ykhgHT290pLxmlPRK
	 yTC9W6NakH5jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/panel-edp: Add BOE NV116WH2-M30, BOE NT116WHM-N21, BOE NV116FH1-M31, BOE NV116FH1-M30
Date: Mon, 19 Oct 2026 09:50:36 -0400
Message-ID: <20261019135441.1420968-345-sashal@kernel.org>
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

From: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>

[ Upstream commit d4ae726fc08024b359e9cacf2507f1c256b9d71c ]

The raw EDIDs for each panel:

BOE NV116WH2-M30
00 ff ff ff ff ff ff 00 09 e5 6e 38 00 00 00 00
0a 24 01 04 95 1a 0e 78 03 0b 55 9a 5f 58 95 28
1e 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 96 1d 56 c8 50 00 26 30 30 20
36 00 00 90 10 00 00 1a b9 13 56 c8 50 00 26 30
30 20 36 00 00 90 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 0f 0c 17 7d 00 00 00 00 80

BOE NT116WHM-N21
00 ff ff ff ff ff ff 00 09 e5 79 38 00 00 00 00
08 24 01 04 95 1a 0e 78 03 3a d5 95 5c 58 94 29
24 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 38 1d 56 c8 50 00 1c 30 30 20
36 00 00 90 10 00 00 1a 7b 13 56 c8 50 00 1c 30
30 20 36 00 00 90 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 0f 0c 17 7d 00 00 00 00 7a

BOE NV116FH1-M31
00 ff ff ff ff ff ff 00 09 e5 8b 38 01 ff 00 00
0c 24 01 04 a5 1a 0e 78 03 50 d5 9c 55 52 8f 27
15 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 9a 36 80 a0 70 38 28 40 30 20
35 00 00 90 10 00 00 1a 67 24 80 a0 70 38 28 40
30 20 35 00 00 90 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 36 ff 0a 3c 96 0f 0b 1a 96 00 00 00 01 cd

70 20 79 02 00 20 00 0c 9a 0e 00 8b 38 00 00 00
00 0c 1a 00 21 01 1d 03 0a a2 05 80 07 38 04 88
c2 39 55 1e 15 8f 7a 32 15 02 35 54 b0 5c b0 5c
00 36 12 78 22 00 14 ff 21 02 85 7f 07 9f 00 2f
00 1f 00 37 04 27 00 02 00 04 00 81 00 15 74 1a
00 00 03 00 28 3c 00 00 53 5a 53 5a 3c 00 00 00
00 00 00 2b 00 06 27 00 28 3b 00 00 2e 00 06 80
4b b0 5c b0 5c 00 00 00 00 00 00 00 00 00 89 90

BOE NV116FH1-M30
00 ff ff ff ff ff ff 00 09 e5 8c 38 01 ff 00 00
0c 24 01 04 a5 1a 0e 78 03 50 d5 9c 55 52 8f 27
15 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 9a 36 80 a0 70 38 28 40 30 20
35 00 00 90 10 00 00 1a 67 24 80 a0 70 38 28 40
30 20 35 00 00 90 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 36 ff 0a 3c 96 0f 0b 1a 96 00 00 00 01 cc

70 20 79 02 00 20 00 0c 9a 0e 00 8c 38 00 00 00
00 0c 1a 00 21 01 1d 03 0a a2 05 80 07 38 04 88
c2 39 55 1e 15 8f 7a 32 15 02 35 54 b0 5c b0 5c
00 36 12 78 22 00 14 ff 21 02 85 7f 07 9f 00 2f
00 1f 00 37 04 27 00 02 00 04 00 81 00 15 74 1a
00 00 03 00 28 3c 00 00 53 5a 53 5a 3c 00 00 00
00 00 00 2b 00 06 27 00 28 3b 00 00 2e 00 06 80
4b b0 5c b0 5c 00 00 00 00 00 00 00 00 00 88 90

Signed-off-by: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260608080310.15126-3-terry_hsiao@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a four-line addition of BOE eDP panel IDs to the existing
`panel-edp` table in **6.18.53**. That is the device-ID exception for
stable: the driver and delay helper already exist here; only the IDs are
new.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `drm/panel-edp`
- Action verb: **Add**
- Claimed intent: register four BOE 11.6" eDP panels by EDID product ID

Record: [`drm/panel-edp`] [Add] [four BOE panel IDs to the EDID lookup
table]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Signed-off-by: Terry Hsiao <terry_hsiao@compal.corp-
  partner.google.com>` (author; Compal/Google Chromebook ODM)
- `Reviewed-by: Douglas Anderson <dianders@chromium.org>` (panel-edp
  maintainer)
- `Signed-off-by: Douglas Anderson <dianders@chromium.org>` (applied to
  drm-misc)
- `Link: https://patch.msgid.link/20260608080310.15126-3-
  terry_hsiao@compal.corp-partner.google.com`
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Reported-by:` / `Tested-by:` / `Acked-by:`
- Ignore pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  ...]`

Record: Author SOB + maintainer Reviewed-by/SOB + lore Link. No syzbot,
no Fixes. Series msgid `-3` is patch 2/2 of a 2-patch series.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The body is four raw EDIDs. Product IDs in those EDIDs match the table
entries (bytes 10–11 LE): `6e 38` → `0x386e`, `79 38` → `0x3879`, `8b
38` → `0x388b`, `8c 38` → `0x388c`. Manufacturer `09 e5` is BOE.

Record: [Bug: these panel IDs are missing from `edp_panels[]`] [Symptom:
unknown-panel `WARN_ON` plus conservative 2000 ms unprepare / 200 ms
enable instead of panel-specific 500/80 ms] [No version range stated]
[Root cause: hardware not in the EDID delay table]

**Step 1.4: DETECT HIDDEN BUG FIXES**
Not a disguised leak/race fix. It is hardware enablement plus power-
sequencing timings (quirk-style).

Record: [Not a hidden memory-safety fix. It is a device-ID / timing-
quirk addition.]

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/gpu/drm/panel/panel-edp.c` (+4 / −0)
- Function/data: `edp_panels[]` only
- Scope: single-file surgical table insert

Record: [1 file, +4 lines] [`edp_panels[]`] [single-file surgical]

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before: `find_edp_panel()` misses these IDs → `WARN_ON(!detected_panel)`
→ `panel_edp_set_conservative_timings()` (`unprepare=2000`,
`enable=200`).
After: match BOE `0x386e/0x3879/0x388b/0x388c` and copy
`delay_200_500_e80` (`hpd_absent=200`, `unprepare=500`, `enable=80`).

Record: [unknown-panel conservative path → identified panel with
`delay_200_500_e80`]

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category **(h) hardware workarounds / device IDs**. Mechanism: EDID
identity was not in the delay table.

Record: [Device ID / panel quirk] [Missing table rows; add four
`EDP_PANEL_ENTRY` lines using an existing delay struct]

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct: sorted by vendor then product ID (`0x386e` after
`0x0ddf`). Reuses `delay_200_500_e80`, already used by many BOE 11.6"
panels. No API/struct change. Regression risk is limited to these four
IDs; wrong delays would only affect those panels, and 80 ms enable is
the common BOE value.

Record: [Minimal, correct, low risk] [No public API change]

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Local tree: `v6.18.53` (`6.18.53`), branch `autosel`.
- `panel-edp.c` exists since `5f04e7ce392db` (2021, ancestor of
  v6.18.53)
- `delay_200_500_e80` from `4d53cf8147950` (2023, ancestor of v6.18.53)
- Insertion point at v6.18.53 is after BOE `0x0ddf` (`518867b093942`)

Record: [Table/driver long present] [Bug is missing IDs, not a
regression in old lines] [First appeared as a gap whenever these panels
are used with `edp-panel`]

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag.

Record: [N/A — no Fixes tag]

**Step 3.3: CHECK FILE HISTORY**
v6.18..v6.18.53 already contains several of the same class of commits,
e.g. `89097c138061e`, `2583d6dcbf500`, `bafdd6284f1b9`, `ed713c88b6bf7`,
`7eeefe23a8196`, `0bd968c04acfb`.

Record: [This tree already takes panel-edp ID additions] [No
prerequisite refactor for these 4 lines] [Series 2/2; independent of
1/2]

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Terry Hsiao has other panel-edp ID additions in this tree
(`bafdd6284f1b9`, `ed713c88b6bf7`, `d4b9b6da5777b`). Douglas Anderson is
the subsystem maintainer and reviewed/applied this.

Record: [Regular Chromebook panel contributor; maintainer-reviewed]

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Series 1/2 adds unrelated AUO/CMN/CSW IDs. `EDP_PANEL_ENTRY` and
`delay_200_500_e80` are already in v6.18.53. `0x0db3` is in the
**mainline** hunk context but **not** in v6.18.53; the 4 added lines do
not need it.

Record: [No functional dependency on 1/2] [Can apply standalone]

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c d4ae726fc08024b359e9cacf2507f1c256b9d71c` matched:
https://patch.msgid.link/20260608080310.15126-3-terry_hsiao@compal.corp-
partner.google.com

`b4 dig -a`: single revision **v1**, series `[PATCH v1 0/2] drm/panel-
edp: Add AUO, BOE, CMN, and CSW panels`.

Doug Anderson: `Reviewed-by` and pushed to drm-misc-next as
`d4ae726fc08024b359e9cacf2507f1c256b9d71c`. No NAK, no stable discussion
in-thread.

Record: [lore/msgid above] [v1 only] [Maintainer R-b, no objections] [No
Cc: stable in review]

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w`: To/Cc included `dianders@chromium.org`, DRM maintainers
(Airlie, Vetter, Ripard, Zimmermann, Lankhorst, Armstrong), `dri-devel`,
`linux-kernel`.

Record: [Correct lists; panel-edp maintainer reviewed]

**Step 4.3: SEARCH FOR THE BUG REPORT**
No bugzilla/syzbot. Evidence is author-supplied EDIDs from Compal/Google
hardware.

Record: [No public crash report] [Real panels documented by EDID dumps]

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Patch 1/2 is independent ID adds. Not required for 2/2.

Record: [Standalone among the series]

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org HTTP fetch returned 403. Thread mbox from `b4 dig -m`
has no stable@ traffic.

Record: [No stable-specific discussion found in the submission thread]
[UNVERIFIED: lore.kernel.org/stable web search 403]

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Modified: `edp_panels[]`. Consumers: `find_edp_panel()`,
`generic_edp_panel_probe()`.

Record: [`edp_panels[]` / `find_edp_panel` / `generic_edp_panel_probe`]

**Step 5.2: TRACE CALLERS**
`generic_edp_panel_probe()` ← `panel_edp_probe()` when DT compatible is
`edp-panel` ← `panel_edp_platform_probe` / DP AUX probe
(`panel_edp_dp_aux_ep_probe` path at line 2190).

Record: [Probe-time, one path per panel] [Not IRQ/hot-path]

**Step 5.3: TRACE CALLEES**
`drm_edid_read_base_block`, `drm_edid_get_panel_id`, `find_edp_panel`,
`drm_edid_match`. On match: `desc->delay = *entry->delay`.

Record: [EDID identify + delay copy]

**Step 5.4: FOLLOW THE CALL CHAIN**
Userspace does not call this directly. It runs when an eDP panel with
compatible `edp-panel` is probed (typical Chromebook/laptop). Reachable
on machines that actually have these BOE panels.

Record: [Device probe] [Reachable on those laptops] [Unprivileged users
do not trigger a new attack surface]

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Many existing BOE `NT116WHM-N21` / `NV116*` rows already use
`delay_200_500_e80` or nearby delays. Same pattern as other stable
panel-edp ID commits in this tree.

Record: [Same table-add pattern already used in 6.18.y]

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Yes. `panel-edp.c` and `edp_panels[]` exist at v6.18.53. `git grep` of
`0x386e|0x3879|0x388b|0x388c|NV116WH2-M30` on **v6.18.53** found
nothing. `git merge-base --is-ancestor` of the candidate vs `v6.18.53`
is false.

Record: [IDs missing from 6.18.53] [Driver present since 2021]

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Dry-run: `git show 75ecc68dd7996` patch against
`v6.18.53:drivers/gpu/drm/panel/panel-edp.c` applied cleanly (`patch
--dry-run` exit 0). Mainline context mentions `0x0db3` (not in 6.18.53);
the 3-line context used for this tree (`0x0d45`/`0x0d73`/`0x0ddf`)
matches.

Record: [Clean apply to 6.18.53]

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No other commit on this file adds these four IDs except the autosel
candidate itself (ignored as pipeline). No alternate fix.

Record: [IDs not in v6.18.53]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
`drivers/gpu/drm/panel/` — DRM eDP panel database. Criticality:
**IMPORTANT** for machines with these panels; **PERIPHERAL** globally.
`CONFIG_DRM_PANEL_EDP` is the existing Kconfig.

Record: [drm/panel-edp] [IMPORTANT for affected laptops]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Actively receiving ID additions; mature table, small well-known change
type.

Record: [Mature table, frequent ID adds]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Only systems whose eDP EDID is BOE product `0x386e/0x3879/0x388b/0x388c`
(11.6" Compal/Google Chromebook-class panels). `CONFIG_DRM_PANEL_EDP`.

Record: [driver-specific / config-specific]

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Every probe of those panels (boot, resume). Not a race. Not
unprivileged-exploitable beyond “this laptop’s panel”.

Record: [Boot/probe of those four panels] [Likely if that hardware ships
on 6.18] [No extra userspace trigger]

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Without the IDs: `WARN_ON` plus conservative delays (2 s unprepare).
Panel generally still lights; sequencing is slower/less accurate. With
wrong HPD-absent handling, flicker or failed light-up is possible; that
is why the table exists.

Record: [WARN_ON + suboptimal eDP power sequencing] [Severity MEDIUM,
hardware-enablement HIGH for those devices]

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Benefit: enable correct timings for four real panels; stop WARN_ON; same
class already accepted in 6.18.y.
Risk: four static table rows, existing delay struct, no locking/API.

Record: [High benefit for those devices, very low risk] [Favorable]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Explicit stable exception: device IDs / quirks on an existing driver
- Driver, macro, and `delay_200_500_e80` already in 6.18.53
- +4 lines, maintainer-reviewed, EDIDs match IDs
- Applies cleanly to v6.18.53
- Same class already in 6.18.y
- Avoids `WARN_ON` and 2 s conservative unprepare on those panels

AGAINST:
- Not a crash/UAF/security fix
- Fallback path still tries to run the panel
- Affects only four panel SKUs

UNRESOLVED:
- lore.kernel.org HTTP 403 for a stable@ archive search (thread mbox had
  no stable@)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — EDIDs, maintainer R-b,
   pushed to drm-misc-next
2. Fixes a real bug that affects users? **PASS** — missing IDs for real
   panels (WARN_ON + wrong delays)
3. Important issue? **PASS** under the device-ID exception (not CRITICAL
   crash)
4. Small and contained? **PASS** — +4 lines, one table
5. No new features or APIs? **PASS** — IDs only, existing helper
6. Can apply to the local tree? **PASS** — dry-run clean on 6.18.53

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: [NEW DEVICE IDs to existing driver — also hardware timing quirk]

**Step 9.4: MAKE YOUR DECISION**
This belongs in 6.18.y. The local tree already has `panel-edp` and the
delay helper; these four BOE IDs are missing; the change is the same
kind of ID add this series already ships.

What it solves for stable users: Chromebook/laptop eDP panels identified
by those EDIDs get correct power-on/off delays instead of the unknown-
panel `WARN_ON` and 2000 ms conservative unprepare.

Risk vs benefit: four static rows vs making those panels sequence
correctly. No dependencies on series 1/2.

### Verification
- [Phase 1] Tags: Hsiao SOB, Anderson R-b/SOB, msgid
  20260608080310.15126-3; no Fixes/Reported-by
- [Phase 1] EDIDs: product IDs 0x386e/0x3879/0x388b/0x388c match added
  rows
- [Phase 2] Diff: +4 `EDP_PANEL_ENTRY` lines in `edp_panels[]` using
  `delay_200_500_e80`
- [Phase 2] Fallback: `generic_edp_panel_probe()` lines 814–824
  `WARN_ON` + `panel_edp_set_conservative_timings()` (unprepare 2000,
  enable 200)
- [Phase 3] `git describe HEAD` / Makefile: **6.18.53**
  (`v6.18.53-5049-g0f0bdc2b0dffb`)
- [Phase 3] `git merge-base --is-ancestor 4d53cf8147950 v6.18.53` yes;
  `5f04e7ce392db` yes
- [Phase 3] `git grep` on v6.18.53: IDs **absent**; `delay_200_500_e80`
  **present** at line 1760
- [Phase 3] Similar ID adds already in `v6.18..v6.18.53` (e.g.
  `89097c138061e`, `bafdd6284f1b9`)
- [Phase 4] `b4 dig -c d4ae726fc080...`: matched series; v1 only;
  Anderson R-b; drm-misc-next `d4ae726fc080`
- [Phase 4] `b4 dig -w`: dri-devel + DRM maintainers + dianders
- [Phase 4] `b4 dig -m`: cover 0/2, 1/2 independent IDs, 2/2 this patch;
  no NAK
- [Phase 4] WebFetch lore/msgid.link: 403 — discussion taken from mbox
  instead
- [Phase 5] Callers of `generic_edp_panel_probe`: only `panel_edp_probe`
  for `edp-panel`
- [Phase 6] Dry-run apply of candidate hunk onto v6.18.53 `panel-edp.c`:
  **success**
- [Phase 6] `0x0db3` (mainline context) **not** in v6.18.53; not
  required
- [Phase 7] `CONFIG_DRM_PANEL_EDP` present in this tree
- [Phase 8] Failure mode: WARN_ON + conservative delays, not oops
- UNVERIFIED: stable@ archive web search (HTTP 403)

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 9ad1769885b3c..792923b1d7878 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -2005,6 +2005,10 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0d45, &delay_200_500_e80, "NV116WHM-N4B"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0d73, &delay_200_500_e80, "NE140WUM-N6S"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ddf, &delay_200_500_e80, "NV116WHM-T01"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x386e, &delay_200_500_e80, "NV116WH2-M30"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x3879, &delay_200_500_e80, "NT116WHM-N21"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x388b, &delay_200_500_e80, "NV116FH1-M31"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x388c, &delay_200_500_e80, "NV116FH1-M30"),
 
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1130, &delay_200_500_e50, "N116BGE-EB2"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1132, &delay_200_500_e80_d50, "N116BGE-EA2"),
-- 
2.53.0

