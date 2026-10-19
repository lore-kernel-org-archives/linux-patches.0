Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA2663DB34;
	Mon, 19 Oct 2026 14:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418769; cv=none; b=I3P09GLtobCg59A4tU/Ce5OIXsD88lw3XD6oHnI36ltyz7v1Fz79FyAq0U7xGhBhjZaPZKL1Q344PYZO8kFx5eF4Q2JwASqQZSqtE0+qCDqmoAk4PLSXiyC3ShFBPT0iACsq6EAbwUp8n0jIuqs/1JxElbvQjjZxtg06GQxzkDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418769; c=relaxed/simple;
	bh=JpIOdMdUqqqsLHeKs4c1NWOHSQJbekSIoZpUBHsn6mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lg0K81iM2W307Hlua3mBsmLjdlkTVTb8PJGfOgXIxCEt2tRYBBry8ZnEKHdx20uE0AAsNdOVQT+MA4KuoA/qQzfBr96lx+ncDe5OlpIifGwW0HcBB9m2Ss87tOxO4SL+DtlAIL+Wm569+Ngp26mhgG5fB+VSaRh9VSScwaF6gA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1VZCZ6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1VZCZ6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEE21F000C6;
	Mon, 19 Oct 2026 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418766;
	bh=8Un+t9UHQoa2+aMNN+qjSUAj1SPh0+dl3IWX8+UPWnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1VZCZ6SFoEf5cLUGjof/Y++jzxeMPeNflQovH2/s+v2sjngLpDX7OoONQhnpmg0K
	 yuyj00LqcRZa20DPXTV5k7xCUSvwrY6x51uSsVh+Xw1AXnqQhhLOquHp2RppVM8A+A
	 HNpvvfASllkqI9z/prxThyEyDM4pQn2ayAfN0hAnJorI2zqm/EyB+ovtBziBs0MP2f
	 dGEtR9g84RHJ5JrH9gAdhZvT+iuh4mE6ixk+X9L0QwVgYX0a7SUl4FLTc6HGJYUg5d
	 trTckcTnK9DhPus1IQDNxrxQVCYfk2ylAn7j+Afz26GvsNaHwbSdVfeiVJIC/e1X5O
	 /2w4rNoh57CXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: renpanpan <renpanpan@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 14-dv1001TU
Date: Mon, 19 Oct 2026 09:52:51 -0400
Message-ID: <20261019135441.1420968-480-sashal@kernel.org>
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

From: renpanpan <renpanpan@kylinos.cn>

[ Upstream commit ece609abc95cc0f75e633d93f3d868b030d9a8fe ]

The HP Pavilion 14-dv1001TU (subsystem ID 103c:8987) uses a Realtek
ALC287 codec. The mute LED on this machine is controlled by GPIO bit
0x10, which was verified via hda-verb, but the subsystem ID is missing
from the quirk table. As a result, the ALC287_FIXUP_HP_GPIO_LED fixup
that drives GPIO 0x10 is never applied and the mute LED stays off even
though the associated LED class device toggles correctly.

Add the missing SND_PCI_QUIRK entry to map this subsystem ID to
ALC287_FIXUP_HP_GPIO_LED so the mute LED works as expected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221810
Signed-off-by: renpanpan <renpanpan@kylinos.cn>
Link: https://patch.msgid.link/20260930065504.24151-1-rppxj178543@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line HP ALC287 mute-LED quirk for this 6.18.y tree. The
SSID is missing from `alc269_fixup_tbl`, GPIO 0x10 was verified on the
machine, and the existing `ALC287_FIXUP_HP_GPIO_LED` fixup is already
present.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA/hda/realtek] [Add] [mute LED quirk for HP Pavilion
14-dv1001TU]
Subsystem prefix `ALSA: hda/realtek`. Action verb is “Add”, but the body
is a missing-quirk hardware workaround, not a new feature.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Link: https://bugzilla.kernel.org/show_bug.cgi?id=221810 (user bug
  report)
- Signed-off-by: renpanpan &lt;renpanpan@kylinos.cn&gt; (author)
- Link:
  https://patch.msgid.link/20260930065504.24151-1-rppxj178543@163.com
- Signed-off-by: Takashi Iwai &lt;tiwai@suse.de&gt; (ALSA/HDA
  maintainer)
- No Fixes: tag (expected for this review)
- No Reported-by / Tested-by / Reviewed-by / Acked-by / Cc: stable
- Ignore pipeline-added “[Upstream commit …]” and “Signed-off-by: Sasha
  Levin”

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: HP Pavilion 14-dv1001TU (SSID 103c:8987, Realtek ALC287) never
  matches a quirk, so `ALC287_FIXUP_HP_GPIO_LED` is not applied.
- Symptom: speaker mute works; physical mute LED stays off. LED class
  device `/sys/class/leds/hda::mute` still toggles.
- Root cause: GPIO bit 0x10 drives the LED (verified with hda-verb);
  that GPIO is what `alc287_fixup_hp_gpio_led()` programs, but 103c:8987
  is absent from the table.
- Version info in the message: none. Bugzilla reporter used kernel
  7.1.5-arch1-2; the omission is in this 6.18 tree as well.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware quirk
addition for a missing SSID.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (+1 / −0)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line surgical quirk

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: Before, `snd_hda_pick_fixup()` in the ALC269 probe path did not
match 103c:8987, so no GPIO mute-LED hook ran. After, that SSID maps to
`ALC287_FIXUP_HP_GPIO_LED`, which calls `alc287_fixup_hp_gpio_led()` →
`alc_fixup_hp_gpio_led(codec, action, 0x10, 0)` (mute mask 0x10, no
micmute mask). Only this SSID is affected.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware workaround / codec quirk] Missing `SND_PCI_QUIRK`
meant GPIO 0x10 was never configured as the mute LED. The fix adds that
table entry. Not a UAF, leak, race, or crash.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and minimal. Neighboring HP Pavilion entries
already use the same fixup (e.g. 0x898a “HP Pavilion 15-eg100”).
Matching is by PCI subsystem ID only, so other machines are untouched.
Regression risk is very low; wrong GPIO on this one SKU would at worst
leave the LED still broken.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: The bug is a missing row, not a bad existing line. Neighbors
0x8981 and 0x898a come from `aeeb85f26c3bb` (“ALSA: hda: Split Realtek
HD-audio codec driver”, 2025-07-11), which is an ancestor of this tree.
`ALC287_FIXUP_HP_GPIO_LED` / `alc287_fixup_hp_gpio_led()` exist in that
split and at the parent of this patch.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. The defect is an omitted SSID for
a laptop that already uses the long-standing ALC287 GPIO-LED fixup.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Same file has many one-line mute-LED quirks (Pavilion 15-eg0xxx,
15-eg3xxx, Victus, etc.). This is standalone, not patch X/Y. No extra
refactor is required.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: `git log --author=renpanpan -- sound/hda/codecs/realtek/` shows
only this commit in this tree. Author is not the ALSA maintainer;
Takashi Iwai applied it the same day.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Parent already has `alc287_fixup_hp_gpio_led()`, enum
`ALC287_FIXUP_HP_GPIO_LED`, table entry for 0x898a, and
`alc_fixup_hp_gpio_led()` in `realtek.c`. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 66ab53f7fac5a` →
  https://patch.msgid.link/20260930065504.24151-1-rppxj178543@163.com
- `b4 dig -a`: single v1 series, no later revision
- Thread: Takashi Iwai replied “Applied now. Thanks.” No NAK, no
  requested changes, no stable note
- Lore WebFetch returned 403; the full thread was recovered via `b4 dig
  -m`

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w` recipients: tiwai@suse.de, perex@perex.cz, alsa-
devel, linux-kernel, author. Subsystem maintainer was To: and merged it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: Bugzilla 221810, title “ALC287: HP Pavilion 14-dv1001TU
(103c:8987) missing mute LED quirk”. Reporter (Arch, kernel 7.1.5)
documented Product ID 50N47PA#ACJ, SOF TGL driver, ALC287, and hda-verb
GPIO 0x10 on/off. They could not rebuild the module on that machine.
Patch author confirmed the analysis and posted the quirk. No Tested-by
of the kernel patch itself; hardware GPIO behavior is verified.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone one-patch series. Same pattern as `8db3663d3c3e2`
(Pavilion 15-eg0xxx, GPIO 0x10, `ALC287_FIXUP_HP_GPIO_LED`), which is
already in this series (`v6.18.24~178`).

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. UNVERIFIED whether
anyone discussed this hash on stable@. No evidence it was rejected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body edited. Added one entry in
`alc269_fixup_tbl[]`, consumed by `snd_hda_pick_fixup()`. Downstream:
`alc287_fixup_hp_gpio_led` → `alc_fixup_hp_gpio_led`.

Step 5.2: TRACE CALLERS
Record: `alc269_fixup_tbl` is passed from ALC269-family probe
(`alc269.c` around the `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` call). Codec probe / device
enumeration, not IRQ or a syscall hot path.

Step 5.3: TRACE CALLEES
Record: `alc_fixup_hp_gpio_led()` sets `gpio_mute_led_mask` and
registers the mute LED cdev with `gpio_mute_led_set`. mute_mask=0x10
matches the reporter’s SET_GPIO_MASK/DIR/DATA 0x10.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace mute → HDA generic LED cdev → GPIO. Reachable on this
laptop whenever the Realtek HDA codec probes. Unprivileged unmute/mute
of speakers is enough once the quirk is applied; today the LED class
device already toggles, but GPIO is never programmed.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Multiple HP SSIDs already use `ALC287_FIXUP_HP_GPIO_LED`
(0x87c8, 0x87cb, 0x87cc, 0x88d0, 0x8919, 0x898a, 0x8a0f, …). Same bug
class: new HP SKU omitted from the table.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is `v6.18.57` (Makefile 6.18.57). Parent of the
candidate has 0x8981 then 0x898a with **no** 0x8987. File path
`sound/hda/codecs/realtek/alc269.c` exists (post-split). Fixup enum and
function exist. The laptop is a consumer HP Pavilion 14-dv1xxx; the
omission is old, not introduced after 6.18.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Context lines match. No conflicting 0x8987 entry.
Expected difficulty: clean apply.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other 103c:8987 quirk. Similar GPIO-LED quirks for other HP
models are present; they do not cover this SSID.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [sound/hda/realtek] [IMPORTANT] — common laptop audio, not core
mm/fs. Impact is one HP SKU’s mute LED.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Very active quirk table; recent log is mostly per-model
`SND_PCI_QUIRK` additions. Mature driver, ongoing hardware ID
maintenance.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / platform-specific: owners of HP Pavilion
14-dv1001TU (PCI SSID 103c:8987, ALC287).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot/probe on that machine. Mute key / userspace mute. Not
a race. No extra privilege needed. Audio mute itself already works.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Mute LED stays off] [MEDIUM/LOW as a crash class, but a real
hardware bug]. Not panic, deadlock, or data corruption. User-visible
broken LED on a shipping laptop.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: Benefit: restores mute LED on this SKU using the same fixup
already used on sibling Pavilion models. Risk: one SSID-guarded line;
very low. Ratio strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real, user-reported hardware bug (bugzilla 221810) with hda-verb proof
  of GPIO 0x10
- Existing, already-used fixup; only the SSID was missing
- One-line `SND_PCI_QUIRK` — the documented audio-codec quirk exception
- ALSA maintainer merged v1 the same day; no NAKs
- Applies cleanly; fixup and table exist in 6.18.57
- Same pattern as other HP mute-LED quirks already in this series (e.g.
  15-eg0xxx in v6.18.24)
AGAINST:
- Not a crash, security hole, or data-corruption bug
- No Tested-by of the built module (reporter used hda-verb only)
- Affects one laptop SKU
UNRESOLVED:
- Stable@ discussion (lore/stable 403)
- Original reporter never confirmed the kernel module on that machine

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? [PASS] — GPIO verified on hardware;
   maintainer applied; kernel-module Tested-by missing but the mapping
   is the standard ALC287 GPIO-LED path
2. Fixes a real bug that affects users? [PASS] — mute LED never lights
   on this Pavilion
3. Important issue? [PASS under hardware-quirk exception] — not
   crash/corruption; codec quirk / broken LED on real hardware
4. Small and contained? [PASS] — +1 line, one table
5. No new features or APIs? [PASS] — no new API; enables existing fixup
   for one SSID
6. Can apply to the local tree? [PASS] — file, neighbors, and
   `ALC287_FIXUP_HP_GPIO_LED` all present

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Audio codec quirk (`SND_PCI_QUIRK` for a specific laptop).
Explicitly treated as stable material.

Step 9.4: MAKE YOUR DECISION
This is a contained hardware quirk for a machine this tree already
supports (ALC287 + `ALC287_FIXUP_HP_GPIO_LED`). The bug is real and
user-visible; the change cannot affect other SSIDs. It should be
backported to this 6.18.y tree.

Verification:
- [Phase 1] Parsed tags: bugzilla 221810; msgid link; SOB renpanpan and
  Takashi Iwai; no Fixes/Cc-stable/Tested-by
- [Phase 1] `git describe HEAD` / `make kernelversion` / Makefile:
  v6.18.57-155-gcdf239ca885b2, 6.18.57
- [Phase 2] Diff: +1 line in `alc269_fixup_tbl[]` mapping 0x103c:0x8987
  → `ALC287_FIXUP_HP_GPIO_LED`
- [Phase 2] `alc287_fixup_hp_gpio_led()` at alc269.c:1386 uses mute_mask
  0x10, matching the report
- [Phase 2] `alc_fixup_hp_gpio_led()` in realtek.c:2223 sets
  `gpio_mute_led_mask` and registers the mute LED cdev
- [Phase 3] Parent `git grep 0x8987` empty; neighbors 0x8981/0x898a
  present
- [Phase 3] `git merge-base --is-ancestor aeeb85f26c3bb HEAD` succeeded
  (codec split / file path in this tree)
- [Phase 3] `alc287_fixup_hp_gpio_led` present at `66ab53f7fac5a^`
- [Phase 3] Author has no other realtek commits in this tree
- [Phase 4] `b4 dig -c 66ab53f7fac5a`: v1 only; lore
  patch.msgid.link/20260930065504.24151-1-rppxj178543@163.com
- [Phase 4] `b4 dig -w`: To tiwai, Cc perex/alsa-devel/lkml
- [Phase 4] mbox: Iwai “Applied now. Thanks.” No NAK
- [Phase 4] curl bugzilla 221810: GPIO 0x10 verified; reporter on 7.1.5;
  could not test rebuilt module
- [Phase 4] lore/stable search: 403, UNVERIFIED
- [Phase 5] `snd_hda_pick_fixup(..., alc269_fixup_tbl, ...)` at
  alc269.c:8557 during codec probe
- [Phase 6] No duplicate 103c:8987; context applies cleanly
- [Phase 6] Similar quirk `8db3663d3c3e2` is in this series
  (`v6.18.24~178`) — same fixup, different SSID
- [Phase 8] Failure mode: mute LED stuck off, audio mute still works;
  SSID-scoped
- UNVERIFIED: whether the compiled quirk was tested on 14-dv1001TU (hda-
  verb only)
- UNVERIFIED: stable@ thread contents (HTTP 403)

The patch is a one-line SSID quirk onto an existing ALC287 GPIO mute-LED
fixup. That is the standard audio-codec exception, it matches verified
hardware, and it applies cleanly to this 6.18.57 tree.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a40b85fbaf393..2a466ef894697 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6902,6 +6902,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
+	SND_PCI_QUIRK(0x103c, 0x8987, "HP Pavilion 14-dv1001TU", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0

