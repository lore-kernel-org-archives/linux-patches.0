Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102BA52CCCB;
	Mon, 19 Oct 2026 13:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418118; cv=none; b=sdi9ZXNx12OW1tjiDrqSBIYCjuoWA8lG8FtXNbyXfaesP32U7PlOTyXtU1t0fYWSgz6nz9nwuXt/dp1Wto+HjZv0hWBmFBE1yNW6InmmKwV5fjLa5OISy8CwGTSJdmrxKQONhNJPKJKSQyKz3nCWfDKNBB7ytHxaNZyLtW0pjwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418118; c=relaxed/simple;
	bh=PmudlrudLdAanj58C1sWrtQ/fZfqREqyylf0yGvFvf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLDye5jcMwLcL7iliZOR/AbNXGb7xmTpXqMGQTv/VvQK043p7kTWz3euRo1J2aEQxnq/QGfUvPi9Fy6Mal5fJVsP8d//+VBSVWVIlwGHw0vFE2+dEWohMsbXqsXh1XRfiI8r2PymPjOLnV6RUvetQpdGpuU+qGuxrsIpolbi1Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVxRvnLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVxRvnLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F050C1F000C7;
	Mon, 19 Oct 2026 13:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418116;
	bh=eRKh27WTcim/71bt1Dd3x9aJZ+WOlDtE80dMKQu2svo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVxRvnLEU37Mv4ym6Vsq9IzWSNudFKIcsmvWvXdgpikbZqEg7MJfhdbIesDMuIgST
	 MGvcoI91X6znr6oma4Y10Ud2PgpG84UVOwIClkq3RiUdWYj2l/tZDqeyfFQGi0KWTY
	 VMt3JTAIs3a5cVrPhXS6MB67eihtwfjgJ7IBzDGx7u3Gooe2YfM+iDDxWh+cyEA81M
	 mHi/uuysJSW4czCNnyoU+I4dct/XTJMbu42gjre9olyH+X5ApBL0pr4npME6lGmQNX
	 4UBty7o+C22G8r41A1kdVoPUQfSvsQNgd00vurMRZRFjTFLHCVh0YmgpRlPcof5gsE
	 YvM8NFZOA9YYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Add quirk for Lenovo IdeaPad Slim 3 15ABR8
Date: Mon, 19 Oct 2026 09:45:13 -0400
Message-ID: <20261019135441.1420968-22-sashal@kernel.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit be79a45e2ec289eb9fad519e8f5a3d4fc3789dd0 ]

The internal microphone on Lenovo IdeaPad Slim 3 15ABR8 (subsystem
17aa:3862) exhibits severe distortion at default gain levels. The
Capture Volume is fixed at 63 (max) and cannot be lowered without
explicit userspace intervention. The existing fixup
ALC269_FIXUP_LIMIT_INT_MIC_BOOST limits the gain range and resolves
the issue.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221891
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260824123752.525173-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line Realtek HDA hardware quirk for a specific Lenovo
laptop. The local tree is **6.12.111** (`pending-6.12`). The Realtek
quirk table and `ALC269_FIXUP_LIMIT_INT_MIC_BOOST` already exist here;
SSID `17aa:3862` does not.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: **[ALSA/hda/realtek] [Add] [quirk for Lenovo IdeaPad Slim 3
  15ABR8]**
- Subsystem prefix: `ALSA: hda/realtek`
- Action verb: **Add** (hardware quirk table entry, not a new feature)
- Claimed intent: map PCI subsystem `17aa:3862` to an existing internal-
  mic boost limit fixup

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221891` — user-
    filed kernel.org bug
  - `Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>` — author
  - `Link: https://patch.msgid.link/20260824123752.525173-1-
    zhangheng@kylinos.cn` — original submission msgid
  - `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA HDA maintainer
    applied it
  - No `Fixes:`, no `Cc: stable`, no `Reported-by`, no `Tested-by`, no
    `Reviewed-by` (absence of `Fixes:`/`Cc: stable` is expected for this
    review)
- Notable: maintainer SOB plus a `Closes:` bugzilla link

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** Internal mic on IdeaPad Slim 3 15ABR8 (`17aa:3862`) has
    severe distortion at default gain
  - **Symptom:** Capture Volume stuck at 63 (max); cannot be lowered
    without explicit userspace intervention; captured audio is badly
    distorted
  - **Root cause (author):** default amp/boost range is too high for
    this hardware
  - **Fix:** reuse existing `ALC269_FIXUP_LIMIT_INT_MIC_BOOST`
  - **Version info:** none in the message; laptop is a 2023 AMD IdeaPad,
    so 6.12 users are in the affected population

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not a hidden fix. It is an explicit hardware quirk. The “Add”
  verb is the standard form for `SND_PCI_QUIRK` table entries that make
  existing hardware usable.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
- Record:
  - File in the commit: `sound/hda/codecs/realtek/alc269.c` (**+1 /
    −0**)
  - Function/table: `alc269_fixup_tbl[]`
  - Scope: **single-file surgical** — one `SND_PCI_QUIRK` line
  - Local tree equivalent file: `sound/pci/hda/patch_realtek.c` (HDA
    codecs were not yet split out of `sound/pci/hda/` in 6.12)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record: **Before** — SSID `17aa:3862` matches no quirk; probe uses
  generic auto-config; internal mic boost stays at the default wide
  range, Capture Volume sits at max, audio is distorted.
  **After** — `snd_hda_pick_fixup()` matches
  `ALC269_FIXUP_LIMIT_INT_MIC_BOOST`. At `HDA_FIXUP_ACT_PROBE`,
  `alc269_fixup_limit_int_mic_boost()` walks auto-config inputs, and for
  internal mic pins overrides amp caps to 0 offset, 1 step, step size
  `0x2f` (boost limited to 0 or 1). Only the probe path for this SSID is
  affected.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: **[Hardware workaround / audio codec quirk]**
  - Mechanism: Realtek codec exposes boost steps 2 and 3 that are too
    noisy on this chassis. The existing helper comments: “The mic boosts
    on level 2 and 3 are too noisy on the internal mic input. Therefore
    limit the boost to 0 or 1.”
  - The new line only *selects* that already-present helper for one PCI
    subsystem ID.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: Obviously correct and minimal. Same pattern already used for
  ThinkPad T480, Positivo ARN50/N14AP7, several Asus/VAIO machines, etc.
  - Regression risk: **very low**. Match is vendor+device SSID
    `17aa:3862` only. `ALC269_FIXUP_LIMIT_INT_MIC_BOOST` also chains to
    `ALC269_FIXUP_THINKPAD_ACPI`, but `hda_fixup_thinkpad_acpi()`
    returns immediately unless ACPI IDs `LEN0068`/`LEN0268`/`IBM0068`
    exist, so LED binding does not run on an IdeaPad.
    `alc_fixup_no_shutup()` still runs (reduces click noise); that same
    chain is already used by other non-ThinkPad LIMIT_INT_MIC_BOOST
    quirks in this tree.
  - No public API, no new fixup enum, no new module parameter.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
- Record: There is no “buggy line” in the table; the bug is a
  **missing** entry. Neighboring rows in this tree:
  - `0x3855` Legion 7 16ITHG6 — `1e24881d8b2a7c` (2022)
  - `0x3865` Lenovo 13X — `25f46354dca912` (2024)
  - Insertion sits in a long-stable Lenovo SSID block. The helper
    `alc269_fixup_limit_int_mic_boost()` was introduced in
    `3e0d611b2045b` (2013-04-22, “Limit internal mic boost for a few
    Asus machines”) and has been in-tree for years.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Not applicable. The “bug” is hardware that
  never had a quirk, not a regression from a prior commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: Recent `patch_realtek.c` history is almost entirely other
  `SND_PCI_QUIRK` additions (HP mute LED, Legion, Yoga, etc.). Same-
  fixup examples already in this 6.12 tree:
  - `85981dfd6b0a0` Limit mic boost on T480 (`Cc: stable`)
  - `86a433862912f` Limit mic boost on N14AP7 (`Cc: stable`)
  - `d44418f5024f6` Limit mic boost on Positivo ARN50 (already
    backported here as `[ Upstream commit 76b0a22d4cf7... ]`)
- Standalone. Not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Zhang Heng has other sound quirks in this tree (ASUS UM6702RC,
  Inspur S14-G1, Samsung 750XBE, AMD YC DMI quirks). Regular hardware-
  quirk contributor, not the subsystem maintainer. Maintainer Takashi
  Iwai applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: None. Depends only on `SND_PCI_QUIRK`,
  `ALC269_FIXUP_LIMIT_INT_MIC_BOOST`, and `alc269_fixup_tbl[]`, all
  present in 6.12. Can apply standalone with a path remap (`alc269.c` →
  `patch_realtek.c`).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: `b4 dig -c` could not be used: this SHA is not in the local
  tree. Recovered via msgid
  `20260824123752.525173-1-zhangheng@kylinos.cn`.
  - Submission: https://lists.openwall.net/linux-kernel/2026/08/24/1126
    (also lkml.iu.edu/2608.3/00949.html)
  - Single-patch v1 only; diff is the same one-line quirk as committed
  - To: `tiwai@suse.de`; Cc: `linux-sound`, `linux-kernel`
  - Maintainer reply (Takashi Iwai, 2026-08-25): **“Applied now.
    Thanks.”** (lkml.iu.edu/2608.3/02564.html)
  - No NAK, no requested respin, no stable discussion in the thread
  - Lore.kernel.org itself returned Anubis/403 to automated fetch

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: Sent directly to Takashi Iwai (ALSA HDA maintainer) and linux-
  sound. Maintainer applied v1 as-is. No other reviewer comments found.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: Bugzilla 221891 was 403/Anubis; full comments **UNVERIFIED**.
  The `Closes:` tag plus the commit body (SSID, Capture Volume 63,
  distortion) are the verified description.
  - Related real-world report: Ask Ubuntu “Audio issues on Lenovo
    Ideapad Slim 3 **16ABR8** — microphone distortion” (sibling ABR8
    chassis, same symptom class). That report is 16ABR8, not
    15ABR8/`17aa:3862`, so it does **not** prove this SSID, only that
    the product family has this class of mic problem.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Standalone 1/1. No series. No extra Realtek patches required.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable search blocked (Anubis). No evidence in
  this tree that this SSID was already requested or rejected. Identical
  LIMIT_INT_MIC_BOOST quirks have been accepted into this 6.12 tree
  before.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
- Record: No function body changed. New table entry in
  `alc269_fixup_tbl[]`. Runtime functions involved:
  `snd_hda_pick_fixup()` → `alc269_fixup_limit_int_mic_boost()` (and
  chained `alc_fixup_thinkpad_acpi()`).

**Step 5.2: TRACE CALLERS**
- Record: `alc269_fixup_tbl` is passed from the ALC269-family probe
  path:

```12583:12584:sound/pci/hda/patch_realtek.c
        snd_hda_pick_fixup(codec, alc269_fixup_models,
                       alc269_fixup_tbl, alc269_fixups);
```

That runs during codec probe (device enumeration / module load), not a
syscall hot path. Reachable on every boot for machines with a Realtek
ALC269-family HDA codec.

**Step 5.3: TRACE CALLEES**
- Record: `alc269_fixup_limit_int_mic_boost()` uses
  `snd_hda_codec_get_pincfg()`, `snd_hda_get_input_pin_attr()`,
  `snd_hda_override_amp_caps()`. Probe-time mixer cap override only; no
  allocation, no new locks.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Userspace does not need a special trigger. Opening the capture
  device at default volume is enough. Unprivileged users of this laptop
  hit it (PulseAudio/PipeWire default capture). High user visibility,
  hardware-specific.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Many `SND_PCI_QUIRK(..., ALC269_FIXUP_LIMIT_INT_MIC_BOOST)`
  entries already in this file (ThinkPads
  `0x2215`/`0x225d`/`0x5013`/`0x5026`/`0x5109`, Asus
  `0x106d`/`0x115d`/`0x1c23`, Positivo, VAIO). This is a systematic,
  well-worn workaround, not a one-off invention.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: **Yes, as a missing quirk.** Local tree:
  `p-6.12-3-gc504cf0baa3d8`, `VERSION=6 PATCHLEVEL=12 SUBLEVEL=111`.
  - `sound/hda/codecs/realtek/` does **not** exist (split is post-6.12).
  - `sound/pci/hda/patch_realtek.c` **does** exist; `alc269_fixup_tbl[]`
    at line 10675; LIMIT_INT_MIC_BOOST at 8711–8716 and function at
    6661–6691.
  - `git grep 0x3862 -- sound/pci/hda/` : **no match**. Between 0x3855
    and 0x3865 there is a hole exactly where the new line goes (lines
    11565–11566).
  - Bug “introduced”: never fixed here; hardware existed well before
    v6.12 (released 2024-11-17).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: **Minor path remap, otherwise clean.** Neighboring context in
  this tree is identical to the mainline hunk (`0x3855` Legion then
  `0x3865` Lenovo 13X). Need to apply to `sound/pci/hda/patch_realtek.c`
  instead of `sound/hda/codecs/realtek/alc269.c`. No conflicting SSID,
  no missing helper.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: No `IdeaPad Slim 3 15ABR8` and no `17aa:3862` in
  `sound/pci/hda/`. Sibling IdeaPad Slim 9i 14ITL5 is a different
  SSID/fixup. No earlier version of this fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: **[sound/pci/hda Realtek codec] [IMPORTANT]** — not core
  mm/vfs, but the default laptop audio stack.
  `CONFIG_SND_HDA_CODEC_REALTEK` is a standard distro config.
  Criticality is hardware-specific, not peripheral/staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: Very active: recent history is a stream of model quirks.
  Mature table, mature helper (2013). Quirk additions are the normal
  stable-friendly change in this file.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: **driver-specific / hardware-specific** — only PCI SSID
  `17aa:3862` (Lenovo IdeaPad Slim 3 15ABR8). Everyone else unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: Trigger is default capture on this laptop (every
  VoIP/recording session). Common for owners of this model. Unprivileged
  users can trigger it. Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: **[Internal mic unusable / severe distortion] [MEDIUM
  functionally; HIGH for that hardware]**
  - Not panic, UAF, or data corruption
  - Internal microphone is effectively broken at default settings;
    userspace volume workarounds are the only current escape
  - This is the documented audio-codec quirk class, routinely taken into
    stable

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record:
  - **Benefit:** High for 15ABR8 owners on 6.12; mic works without mixer
    hacks
  - **Risk:** Very low — 1 line, SSID-gated, helper used for a decade,
    same pattern already backported here
  - **Ratio:** strongly in favor of backport

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real hardware bug with a kernel.org bugzilla `Closes:` (221891)
- Severe mic distortion; capture stuck at max gain
- Classic `SND_PCI_QUIRK` exception (explicitly stable-appropriate)
- 1 line, existing fixup from 2013
- Helper and table present in 6.12; SSID absent
- Maintainer (Takashi Iwai) applied v1 with no objections
- Identical LIMIT_INT_MIC_BOOST quirks already in this 6.12 tree (T480,
  N14AP7, Positivo ARN50)

AGAINST:
- Not a crash/security/deadlock (strict reading of “important issue”)
- Mainline path differs (`alc269.c` vs `patch_realtek.c`) — trivial
  remap
- Full bugzilla text could not be fetched (403)
- `b4 dig` could not run without a local SHA

UNRESOLVED:
- Full bugzilla 221891 comments
- Whether any other chassis silently shares SSID `17aa:3862` (no in-tree
  collision)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one SSID line to a long-used
   helper; maintainer applied; same pattern proven in this tree
2. Fixes a real bug that affects users? **PASS** — unusable/distorted
   internal mic; bugzilla + concrete SSID
3. Important issue? **PASS via hardware-quirk exception** — not a kernel
   oops, but a device-breaking audio defect of the class stable already
   takes (`SND_PCI_QUIRK` in `patch_realtek.c`)
4. Small and contained? **PASS** — +1 line
5. No new features or APIs? **PASS** — table entry only
6. Can apply to the local tree? **PASS** — remap path to
   `sound/pci/hda/patch_realtek.c`; context around 0x3855/0x3865 matches

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: **AUDIO CODEC QUIRK / hardware workaround** — `SND_PCI_QUIRK`
  in the Realtek HDA table. This is an automatic YES category.

**Step 9.4: MAKE YOUR DECISION**
Backport. The bug exists on 6.12 for this laptop, the fix is the
standard one-line quirk, and the only adjustment is the post-6.12
filename change.

------------------------------------------------
What the commit solves and why it matters here
------------------------------------------------
On IdeaPad Slim 3 15ABR8 the Realtek internal mic boost range is too
high, so Capture Volume sits at 63 and recordings are badly distorted.
6.12 already has `alc269_fixup_limit_int_mic_boost()`; it just never
binds it to `17aa:3862`. Adding that binding restores usable capture for
that model without touching any other machine.

Risk vs benefit: one SSID-gated line vs a broken laptop microphone.
Benefit dominates. Backport applies to `patch_realtek.c` between the
existing `0x3855` and `0x3865` rows.

------------------------------------------------
Verification
------------------------------------------------
- [Phase 1] Parsed tags: `Closes: bugzilla 221891`, msgid link, SOB
  Zhang Heng + Takashi Iwai; no Fixes/Cc-stable
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x17aa, 0x3862, ...,
  ALC269_FIXUP_LIMIT_INT_MIC_BOOST)` in `alc269_fixup_tbl`
- [Phase 2] Read `alc269_fixup_limit_int_mic_boost()` at
  `patch_realtek.c:6661-6691` — probe-time amp-cap override for internal
  mic pins
- [Phase 2] Read `ALC269_FIXUP_LIMIT_INT_MIC_BOOST` at 8711-8716 —
  chains to THINKPAD_ACPI
- [Phase 2] Read `hda_fixup_thinkpad_acpi()` / `is_thinkpad()` in
  `thinkpad_helper.c` — LED path skipped without ThinkPad ACPI IDs
- [Phase 3] `git log -S ALC269_FIXUP_LIMIT_INT_MIC_BOOST --
  sound/pci/hda/patch_realtek.c`: introduced `3e0d611b2045b` (2013)
- [Phase 3] Similar quirks already in this tree: T480 `85981dfd6b0a0`,
  N14AP7 `86a433862912f`, Positivo ARN50 `d44418f5024f6`
- [Phase 3] `git log --grep='IdeaPad Slim 3 15ABR8' -- sound/pci/hda/`:
  empty
- [Phase 4] Openwall + IU LKML: v1 patch identical to commit; Takashi
  “Applied now. Thanks.”
- [Phase 4] lore.kernel.org and bugzilla HTML/REST: 403 Anubis — full
  bugzilla body UNVERIFIED
- [Phase 4] `b4 dig -c`: not run; commit SHA not in this checkout
- [Phase 5] Caller: `snd_hda_pick_fixup(..., alc269_fixup_tbl, ...)` at
  probe (`patch_realtek.c:12583`)
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111
- [Phase 6] `sound/hda/codecs/realtek` missing;
  `sound/pci/hda/patch_realtek.c` present
- [Phase 6] `git grep 0x3862 -- sound/pci/hda/`: no hits; hole between
  0x3855 and 0x3865 at lines 11565-11566
- [Phase 8] Failure mode: distorted/unusable internal mic, SSID-
  specific; severity medium globally, high for that laptop
- UNVERIFIED: full text of bugzilla 221891; whether any other product
  silently uses SSID 17aa:3862

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8196235c31d2b..bc87062f86da7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7515,6 +7515,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
+	SND_PCI_QUIRK(0x17aa, 0x3862, "Lenovo IdeaPad Slim 3 15ABR8", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-- 
2.53.0

