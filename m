Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDDE51DAE6;
	Mon, 19 Oct 2026 13:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418285; cv=none; b=nH66x190PT4JVxVQKahXuDWdEnQ1pyHdV7iDyHuPrfsiw5Kmrh4RHzQD8T4xnyn/7+5mQmM6lI/ArGtJeaZ26uQ5BWVuMzhaptFyRSivO+ax98Wj+RB5r+sZC3E8E+xZw1H7+cAMFgOzdqpLVrCUoPodhhvCjDVjEUjbUyufkzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418285; c=relaxed/simple;
	bh=Gv6k1C/39ggz7wO/3bNh8gJiH5NU5JV0k6IW8N9JWMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CGJ2jBhon/c8bLlOFYTPHGFgB+9twBoR8JVW5tTSo28SxsfeaRH6n6Ov76AHpAFYtZcNvGKa1yU7vOEfHun3yILZaQNnrEf3j+imxD5pGSqgatnBccIm8J5p3DpkfPhcyaqFY2gVRnJT15CWNRt1eEv3NIe9Vh/qwR4K5lc7cK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=am+o/k7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="am+o/k7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421FA1F000C8;
	Mon, 19 Oct 2026 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418282;
	bh=cUgDBXxJlx6W2o3Tcn+WyqZtO/tJR3ZczkJTDItOmjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=am+o/k7+BFnkfbe/shplaYggAYQOJpBR1LQY9GUwvjSw5ILaxTfBEwrV8STf8Nzc+
	 oZaTom7BqvI9RU0XqIkhYzh8pSBw6YQ3Q7DZd7p+u+41YT8eHrVv3+3f3OuByUgnz0
	 vgEPwabuTvlO8h/1vbYFLfxmQYzVjkXafWXzz5dRDTu51TSdioYvdaS+q9Wm7KEuJb
	 gda/8JYIg6g76yHCCUPhDuMRDV/yYENXnQrCWHVLEPTQQ9P4ibiwIszwuj5ynJHrrl
	 PD6sVyadESvJe0eQ2G1ul29RQUteKZD9MUzQZaktltyVxv/O2cHvS2NfS5b7lgpEs5
	 a4kWMRGmIWUGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Schaefer <dhs@frame.work>,
	=?UTF-8?q?Sven=20Vaink=C3=BCla?= <sven@xn--vainkla-r2a.ee>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	jic23@kernel.org,
	linux-input@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] iio: hid-sensor: als: scale each channel individually
Date: Mon, 19 Oct 2026 09:47:08 -0400
Message-ID: <20261019135441.1420968-137-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Daniel Schaefer <dhs@frame.work>

[ Upstream commit cad928dad9a4c26aa56b4223dc2a29bca517fb5f ]

Some sensors have multiple channels (not just brightness but color ALS
sensors) with different scaling factors.

Signed-off-by: Daniel Schaefer <dhs@frame.work>
Link: https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/merge_requests/413
Tested-by: Sven Vainküla <sven@xn--vainkla-r2a.ee> #Asus ProArt PX13 laptop.
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **Linux 7.3-rc4** (mainline). Color ALS channels exist
here (since v6.9), and this is a small per-channel IIO scale correctness
fix with a real user report. Full phase walkthrough follows.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[iio/hid-sensor-als] [scale] scale each ALS channel
individually rather than using one illuminance scale for every channel**

- Subsystem: `iio: hid-sensor: als`
- Verb: “scale” (correctness of IIO `in_*_scale`, not a refactor)
- Claimed intent: color ALS sensors have per-channel scaling factors;
  the driver used a single shared scale

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record: tags (ignoring pipeline `Signed-off-by: Sasha Levin` /
`[Upstream commit …]`):
- **Signed-off-by:** Daniel Schaefer `<dhs@frame.work>` (author,
  Framework)
- **Link:** `https://gitlab.freedesktop.org/hadess/iio-sensor-
  proxy/-/merge_requests/413`
- **Tested-by:** Sven Vainküla (Asus ProArt PX13)
- **Acked-by:** Srinivas Pandruvada (HID sensor hub maintainer)
- **Signed-off-by:** Jonathan Cameron (IIO maintainer)
- **No Fixes:** (expected for this review)
- **No Cc: stable:** (expected)
- **No Reported-by / syzbot / KASAN**

Notable: real hardware Tested-by, userspace (iio-sensor-proxy) link,
maintainer Ack.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** some HID ALS devices are color ALS (illuminance + color
  temperature + chromaticity), not brightness-only, and those extra
  channels have different HID unit/exponent than illuminance.
- **Symptom:** userspace (iio-sensor-proxy, compositors) applies the
  illuminance scale to color-temp/chromaticity raw values → wrong
  physical units (night light / color management broken or nonsense).
- **Version info:** none in the message. Color/chromaticity channels
  themselves landed in v6.9.
- **Root cause:** `hid_sensor_format_scale()` was called only on
  `als[CHANNEL_SCAN_INDEX_INTENSITY]` and that one scale was returned
  for every channel.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a hidden cleanup.** It is an explicit correctness fix:
wrong IIO SCALE sysfs values for extra ALS channels. Same class as
`8b518cdb03f5f` (“iio: hid-sensor-prox: support multi-channel SCALE
calculation”), which had `Cc: stable` and `Fixes:`.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/iio/light/hid-sensor-als.c` only
- **Size:** 12 insertions, 10 deletions (net +2)
- **Functions:** `struct als_state`, `als_read_raw()`,
  `als_parse_report()`
- **Scope:** single-file surgical driver fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
1. **State:** `scale_pre_decml` / `scale_post_decml` / `scale_precision`
   become arrays of `CHANNEL_SCAN_INDEX_MAX`.
2. **`als_read_raw` IIO_CHAN_INFO_SCALE:** used to return the one
   illuminance scale for any channel; now indexes by `chan->scan_index`,
   with a bounds check.
3. **`als_parse_report`:** scale is computed **inside** the per-usage
   loop with `st->als[i]` (that channel’s units/exponent), instead of
   once afterward from intensity only.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Logic / correctness]** IIO SCALE ABI wrong for color ALS.

`hid_sensor_format_scale()` (verified in `hid-sensor-attributes.c`)
matches `usage_id` (still the ALS sensor usage `0x200041`) **and**
`attr_info->units`, then applies `attr_info->unit_expo`. The per-channel
difference is those HID attribute fields. Intensity/illuminance share
`HID_USAGE_SENSOR_LIGHT_ILLUM`; color-temp and chromaticity have
different attributes, so they must not reuse intensity’s exponent.

Classic brightness-only ALS is unchanged: both intensity and illum still
use the same HID usage and therefore the same scale.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct; same pattern as hid-sensor-prox
  (`scale_pre_decml[index]` + format_scale in the parse loop).
- **Minimal:** no unrelated edits.
- **Regression risk:** low. Traditional ALS behavior is preserved.
  Color-temp/chromaticity SCALE sysfs values change from wrong to
  correct (intended).
- **Known limitation (discussed on-list, not a NAK):**
  `IIO_CHAN_INFO_SCALE` stays `info_mask_shared_by_type`, so
  chromaticity X and Y share one sysfs scale. Jonathan Cameron: that
  only matters if X and Y scales differ; the reported bug is illuminance
  vs color-temp. Author: “in practice it's probably not needed and the
  patch works as is.” No v2 was required; v1 was applied.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Shared scale fields date to **`36783d09f1a5c`** (“iio: hid-sensors:
  ALS: adjust scale and offset”, 2014) — correct when there was only
  illuminance.
- Extra channels: **`3765d426fe864`** color temperature,
  **`2ec17b1950bb8`** chromaticity, both **v6.9-rc1**. That is when one
  scale became wrong.
- Dynamic channel assignment: **`f2a71ebdf2312`** (v6.9).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Closest introduction of the bug is the v6.9
color-temp/chromaticity additions. Those commits **are** ancestors of
this 7.3-rc4 tree (`git merge-base --is-ancestor` not required for each;
`git describe --contains` shows `v6.9-rc1`).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: recent ALS history includes channel init refactor, timestamp
alignment, probe race fix. **No prerequisite series** for this patch
(standalone v1). **No follow-ups** on this file after `cad928dad9a4c`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Daniel Schaefer has this single IIO commit in-tree. Not the
subsystem maintainer. Weight comes from **Acked-by Srinivas Pandruvada**
and **SOB Jonathan Cameron**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: needs existing `als[]` per-channel attribute array,
`CHANNEL_SCAN_INDEX_*`, and `hid_sensor_format_scale()` — all present
here since v6.9 / much earlier. **Applies standalone.** Prox analog
`8b518cdb03f5f` is a sibling pattern, not a dependency.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:** https://patch.msgid.link/20260723-chromaticity-v1-1-
  5ef5746ace2a@frame.work
- **Series:** v1 only (no v2/v3 despite author briefly offering a v2 for
  `info_mask_separate`)
- **Jonathan Cameron (2026-07-26):** SCALE shared-by-type is OK unless
  chromaticity X/Y differ; “the change here looks fine”; queued on
  iio.git testing.
- **Srinivas Pandruvada:** Acked-by.
- **David Lechner:** explained testing-branch means accepted/applied.
- **No NAK.** No reviewer asked for Cc: stable.
- **Sashiko bot:** flagged shared-by-type (addressed in discussion) and
  a **pre-existing** buffer-layout concern, not introduced by this
  patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc included Jonathan Cameron, Srinivas Pandruvada, David
Lechner, Nuno Sá, Andy Shevchenko, linux-iio, linux-input. Right
maintainers were in the loop.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: GitLab iio-sensor-proxy MR 413 returned **HTTP 403** (UNVERIFIED
beyond the Link tag). Hardware evidence that **is** verified: Tested-by
on Asus ProArt PX13; Framework author; iio-sensor-proxy is the standard
userspace for laptop ALS.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: standalone, not N/M. Prox multi-channel SCALE (`8b518cdb03f5f`,
v6.15-rc6) is the same bug class and **was** `Cc: stable`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: no “stable” in the lore mbox. UNVERIFIED whether linux-stable@
discussed it separately (no lore.kernel.org/stable hit via b4 thread).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `als_read_raw`, `als_parse_report`; struct `als_state`. Probe
path: `hid_als_probe` → `als_parse_report`. Sysfs/read path: IIO core →
`als_info.read_raw` → `als_read_raw`.

**Step 5.2: TRACE CALLERS**

Record:
- `als_parse_report`: only from `hid_als_probe` (HID-SENSOR-200041 /
  LISS-0041 platform devices).
- `als_read_raw`: IIO `read_raw` for sysfs (`in_illuminance_scale`,
  `in_colortemp_scale`, `in_chromaticity_x_scale`, etc.) and buffered
  metadata. **Userspace-reachable**, not IRQ-hot.

**Step 5.3: TRACE CALLEES**

Record: `hid_sensor_format_scale()` → unit table +
`adjust_exponent_nano()`; `sensor_hub_input_get_attribute_info()` fills
per-channel `units`/`unit_expo`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: unprivileged users can read IIO sysfs on a system with this HID
ALS. Color ALS on recent AMD/laptop HID sensor hubs (v6.9+ channels).
**Reachable from userspace.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: hid-sensor-prox already uses per-channel scale arrays. Other
hid-sensor drivers (accel, gyro, press, temp) still use a single scale
because they are not mixed-unit multi-channel in the same way. ALS was
the leftover mismatch after v6.9 extra channels.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- **Tree:** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = **7.3.0-rc4** (Linus mainline, not an LTS branch).
- Color ALS channels **are** in `hid-sensor-als.c`.
- Commit **`cad928dad9a4c` is already an ancestor of HEAD** (working
  tree already has per-channel arrays). That is the mainline landing of
  this fix during 7.3, **not** a reason to reject it on technical merit
  (pipeline “already selected” markers ignored).
- Bug introduced **v6.9** (2024), long before this tree.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: against **this** 7.3 tree the change is already applied / would
apply cleanly. Context in the submitted v1 still used
`als_adjust_channel_bit_mask`; this tree uses `iio_scan_type`
initializer (`cded217233845`). For **this** checkout that is already
resolved. No extra commits required for the logic of the fix.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: this exact commit is in HEAD. No later revert or competing fix.
No other ALS scale fix in `git log cad928dad9a4c..HEAD --
drivers/iio/light/hid-sensor-als.c`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **IIO light / HID sensor hub ALS** — **PERIPHERAL to IMPORTANT**
depending on hardware. Laptop ambient/color light (Framework, Asus
ProArt, HID sensor hubs). Not mm/net/fs core, but commonly used on
notebooks via iio-sensor-proxy.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: mature driver (2012), still getting channel and race fixes.
Color ALS is several years old (v6.9), not brand-new staging code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **driver-specific / config-specific** (`CONFIG_HID_SENSOR_ALS`).
Users of HID color ALS (not every illuminance-only ALS). Confirmed: Asus
ProArt PX13; likely other color-ALS HID laptops.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: **Every read of IIO SCALE** for color-temp/chromaticity, and
every userspace conversion of those raw values. Not a race. Unprivileged
users with IIO device node/sysfs access can observe it. Common on
affected laptops at session start (iio-sensor-proxy).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Wrong sensor physical values** (color temperature /
chromaticity), not oops/UAF/deadlock. Userspace brightness for classic
ALS is unaffected (same HID usage). Compositor color/night-light using
color ALS can be wrong. **Severity: MEDIUM** — real, user-visible, “oh
that’s not good,” not CRITICAL.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** correct IIO scale on color ALS; unbreaks iio-sensor-
  proxy/hardware that already exists in this lineage.
- **Risk:** very low (≈20-line, one file, no locking/API).
- **Ratio:** favorable. Same class already taken for stable in prox.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting**
- Real userspace-visible bug: mixed-unit color ALS channels reused
  illuminance scale.
- Hit on real hardware (Asus ProArt PX13 Tested-by); iio-sensor-proxy MR
  linked.
- Small, obviously correct, acked by HID-sensor maintainer, applied by
  IIO maintainer.
- Identical prox bug was explicitly `Cc: stable`.
- This tree **has** the v6.9 color/chromaticity channels, so the bug
  class exists in this lineage.
- Traditional ALS unchanged; only extra channels’ SCALE change.
- Fits documented stable bar: “real bug that bothers people” / “oh,
  that’s not good.”

**AGAINST**
- Not a crash, UAF, deadlock, or security issue.
- No Fixes:/Cc: stable (not a negative per review rules).
- SCALE still shared-by-type for chromaticity X/Y (accepted by
  maintainer as OK for the reported bug).
- Peripheral driver, not core kernel.
- GitLab MR body UNVERIFIED (403).

**UNRESOLVED**
- Exact HID unit/exponent values on the PX13 (not in-tree).
- Whether chromaticity X vs Y ever differ on some firmware (maintainers
  assumed no).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — Tested-by, Acked-by, IIO
   maintainer queued v1.
2. Fixes a real bug that affects users? **PASS** — wrong IIO scale on
   color ALS; userspace conversion broken.
3. Important issue? **PASS** (medium “oh that’s not good,” not CRITICAL
   crash) — wrong physical units for sensors userspace actually uses.
4. Small and contained? **PASS** — one file, +12/−10.
5. No new features or APIs? **PASS** — corrects SCALE for channels that
   already exist; no new sysfs ABI.
6. Can apply to the local tree? **PASS** — affected code is in 7.3-rc4;
   change is already the current code here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: not a device-ID/quirk/DT/build/docs exception. Ordinary driver
correctness fix.

**Step 9.4: MAKE YOUR DECISION**

This tree’s ALS driver includes color-temperature and chromaticity
channels added in v6.9 but, until this change, advertised a single
illuminance-derived IIO scale for all of them. That is a real, tested
userspace bug (wrong color ALS readings via iio-sensor-proxy), not a
feature or cleanup. The patch is small, matches the already-stable-
worthy prox multi-channel SCALE fix, and does not change classic
illuminance ALS. Benefit outweighs the low regression risk.

### What the commit solves and why it matters here

Color HID ALS devices expose extra channels with different HID
units/exponents. The driver formatted scale only from the intensity
attribute, so `in_colortemp_scale` / chromaticity scale were wrong. On
this 7.3-rc4 tree those channels exist, so the fix is applicable and is
the right stable-style correctness change for that hardware.

### Risk vs benefit

Benefit: correct sensor units for color ALS on laptops that already use
this driver. Risk: a few array/index changes on the sysfs read path;
illuminance-only devices keep the same scale.

### Concerns

No crash-level severity; chromaticity X/Y still share type-wide scale
(explicitly accepted). Neither blocks backport of this contained fix.

Verification:
- [Phase 1] Parsed tags: Tested-by Sven Vainküla (Asus ProArt PX13);
  Acked-by Srinivas Pandruvada; SOB Jonathan Cameron; Link to iio-
  sensor-proxy MR 413; no Fixes/Cc:stable
- [Phase 2] Diff: 12+/10- in hid-sensor-als.c; scalar scale → per-
  scan_index arrays; format_scale moved into parse loop over
  `st->als[i]`
- [Phase 2] Verified `hid_sensor_format_scale()` uses `attr_info->units`
  and `unit_expo`; ALS unit table only has ALS+0 and ALS+LUX
- [Phase 3] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor cad928dad9a4c HEAD` → already
  in this tree (mainline landing)
- [Phase 3] Color temp `3765d426fe864` and chromaticity `2ec17b1950bb8`
  contained in v6.9-rc1
- [Phase 3] Prox analog `8b518cdb03f5f` had Cc: stable + Fixes
- [Phase 3] No follow-up commits on hid-sensor-als.c after cad928dad9a4c
- [Phase 4] `b4 dig -c cad928dad9a4c`: lore https://patch.msgid.link/202
  60723-chromaticity-v1-1-5ef5746ace2a@frame.work
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: IIO + HID-sensor maintainers on To/Cc
- [Phase 4] mbox: Jonathan OK with shared-by-type; Srinivas Ack; no NAK;
  no stable nomination in thread
- [Phase 4] GitLab MR fetch: 403, body UNVERIFIED
- [Phase 5] semcode: not available; grep shows als_read_raw only from
  als_info; hid_als_probe only caller of als_parse_report
- [Phase 6] Working tree already has per-channel scale arrays at lines
  36–38 and 332–334
- [Phase 8] Failure mode: wrong IIO SCALE for color ALS → incorrect
  userspace conversion; severity MEDIUM
- UNVERIFIED: exact PX13 HID unit/exponent values; linux-stable@
  discussion outside this thread

**YES**

 drivers/iio/light/hid-sensor-als.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
index 384572844162c..232cb58e0a9ff 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -33,9 +33,9 @@ struct als_state {
 		u32 illum[CHANNEL_SCAN_INDEX_MAX];
 		aligned_s64 timestamp;
 	} scan;
-	int scale_pre_decml;
-	int scale_post_decml;
-	int scale_precision;
+	int scale_pre_decml[CHANNEL_SCAN_INDEX_MAX];
+	int scale_post_decml[CHANNEL_SCAN_INDEX_MAX];
+	int scale_precision[CHANNEL_SCAN_INDEX_MAX];
 	int value_offset;
 	int num_channels;
 	s64 timestamp;
@@ -186,9 +186,11 @@ static int als_read_raw(struct iio_dev *indio_dev,
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SCALE:
-		*val = als_state->scale_pre_decml;
-		*val2 = als_state->scale_post_decml;
-		ret_type = als_state->scale_precision;
+		if (chan->scan_index >= CHANNEL_SCAN_INDEX_MAX)
+			return -EINVAL;
+		*val = als_state->scale_pre_decml[chan->scan_index];
+		*val2 = als_state->scale_post_decml[chan->scan_index];
+		ret_type = als_state->scale_precision[chan->scan_index];
 		break;
 	case IIO_CHAN_INFO_OFFSET:
 		*val = als_state->value_offset;
@@ -338,6 +340,10 @@ static int als_parse_report(struct platform_device *pdev,
 		als_adjust_channel_bit_mask(channels, index, st->als[i].size);
 		++index;
 
+		st->scale_precision[i] = hid_sensor_format_scale(usage_id,
+					&st->als[i], &st->scale_pre_decml[i],
+					&st->scale_post_decml[i]);
+
 		dev_dbg(&pdev->dev, "als %x:%x\n", st->als[i].index,
 			st->als[i].report_id);
 	}
@@ -347,10 +353,6 @@ static int als_parse_report(struct platform_device *pdev,
 	if (index)
 		ret = 0;
 
-	st->scale_precision = hid_sensor_format_scale(usage_id,
-				&st->als[CHANNEL_SCAN_INDEX_INTENSITY],
-				&st->scale_pre_decml, &st->scale_post_decml);
-
 	return ret;
 }
 
-- 
2.53.0

