Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73534D98F8;
	Mon, 20 Apr 2026 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692018; cv=none; b=Qee1Gbe2+iaV82pHfUlqfNkMxIVFYkQlYz/qv111Py/U45yCLDUNNzFb96TpbxkD74CsZsthJh7Cxysx8Jre/ZckC5+gTwGQdrHcAo/lioo1fxMZoL0DLUJUbfG5WrSQDRHw/KlHCGv76GnWUZ2m0dKs1IVFyBTEmQO3ACE5ocM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692018; c=relaxed/simple;
	bh=jgZWabGUujhafuo9BtlfJU1ksYakC7LsTIbq4wGHocY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUs3nalRC6qa1Kl0mgGM/vgdIXaz1F18Wn2goHNZu481RgxYkfZj5nDAEJ904rHdWquEklt2i/bV9aXVUzYFI+07ljiusZuMaSGo/Hf8NI7Lly1H99xI3cgf5MGs34NMPnpZh/KdLV3Ot06HXM8Q0C7pvfbjaJ2tj2zveCpGuJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gp0Uz/ru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gp0Uz/ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7178CC19425;
	Mon, 20 Apr 2026 13:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692018;
	bh=jgZWabGUujhafuo9BtlfJU1ksYakC7LsTIbq4wGHocY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gp0Uz/ru3htgWF/J+c5Jq3FGJbiyJBR/Yv6imxEpr7hyF1ddcBEW03rvm7zoYE0Tz
	 mBXcs7NjA1dk2yWmp7VeUK9RNfgzn6b6NDl62XUjkEhL5GsHb8WcfdnWyIXFo+0kFj
	 HkJywT0+eqAN8V5Db9rrMtHJ46HsOiRsIqkLPgwCiqkll9oC3PU74s5oEAcskujyda
	 PMKxEJbnfMhqmuNnUeMmeEPj3UOH7RxG5sPI7RETNKslPI8HBprrZ+csBnHRZOXfw0
	 zuYb23nisuO/HYnMQBEZhDyLDhtvxVjAAI4T+J7xi2puaNWPgGZFxS/JvGjjzo9Q6h
	 fN6ScEaM9A8VA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: songxiebing <songxiebing@kylinos.cn>,
	dzidmail <dzidmail@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] ALSA: hda/realtek: Add quirk for HP Spectre x360 14-ea
Date: Mon, 20 Apr 2026 09:21:59 -0400
Message-ID: <20260420132314.1023554-325-sashal@kernel.org>
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

From: songxiebing <songxiebing@kylinos.cn>

[ Upstream commit 882321ccaeea52dd645dff98bfea2f92b286e673 ]

HP Spectre x360 Convertible 14-ea0xxx (2021 model or so)
doesn't make produce sound,The Bang & Olufsen speaker amplifier
is not enabled.

Root causing:
The PCI subsystem ID is 103c:0000 (HP left it unset), while the codec
subsystem ID is 103c:885b. The vendor-wide catch-all
SND_PCI_QUIRK_VENDOR(0x103c, "HP", ALC269_FIXUP_HP_MUTE_LED) matches
103c:0000 before the codec SSID fallback is reached, so
ALC245_FIXUP_HP_X360_AMP never applies.

So add the quirk in alc269_fixup_tbl.

Reported-by: dzidmail <dzidmail@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221341
Signed-off-by: songxiebing <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260413011854.96520-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ALSA: hda/realtek`
- Action: "Add quirk"
- Summary: Adding a codec SSID quirk for HP Spectre x360 14-ea to enable
  its speaker amplifier.
- Record: [ALSA/HDA/Realtek] [Add] [Hardware quirk for HP Spectre x360
  14-ea speaker amp]

**Step 1.2: Tags**
- Reported-by: dzidmail <dzidmail@gmail.com> — a real user reporting the
  issue
- Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221341 — filed bug
  report
- Signed-off-by: songxiebing <songxiebing@kylinos.cn> — author, a
  recurring HDA contributor
- Link: patch.msgid.link — lore submission link
- Signed-off-by: Takashi Iwai <tiwai@suse.de> — the HDA subsystem
  maintainer applied it
- Record: User-reported bug with bugzilla tracker. HDA maintainer
  Takashi Iwai merged it directly.

**Step 1.3: Commit Body**
- Bug: HP Spectre x360 14-ea (2021 model) produces no sound. Bang &
  Olufsen speaker amplifier is not enabled.
- Root cause explained clearly: PCI subsystem ID is `103c:0000` (HP left
  it unset). The vendor catch-all `SND_PCI_QUIRK_VENDOR(0x103c, "HP",
  ALC269_FIXUP_HP_MUTE_LED)` matches first because it checks PCI SSID,
  preventing the codec SSID fallback from ever reaching
  `ALC245_FIXUP_HP_X360_AMP`.
- Fix: Use `HDA_CODEC_QUIRK(0x103c, 0x885b, ...)` which sets
  `match_codec_ssid=true`, causing matching against codec SSID
  `103c:885b` in the primary loop, before vendor catch-all kicks in.
- Record: [No audio output] [Speaker amp not enabled] [Incorrect quirk
  applied due to unset PCI SSID]

**Step 1.4: Hidden Bug Fix?**
This is an explicit hardware quirk fix. Not hidden — it directly
addresses a broken hardware scenario. The commit explains the exact
mechanism.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `sound/hda/codecs/realtek/alc269.c`
- 1 line added: `HDA_CODEC_QUIRK(0x103c, 0x885b, "HP Spectre x360
  14-ea", ALC245_FIXUP_HP_X360_AMP),`
- Scope: Single-line surgical addition to an existing quirk table.
- Record: [+1 line in alc269_fixup_tbl quirk table] [Minimal scope]

**Step 2.2: Code Flow Change**
- Before: No entry for codec SSID `103c:885b`. The vendor catch-all
  applies `ALC269_FIXUP_HP_MUTE_LED`, which doesn't toggle the GPIO pin
  needed for the B&O speaker amp.
- After: `HDA_CODEC_QUIRK` with `match_codec_ssid=true` matches in the
  primary loop via codec SSID → `ALC245_FIXUP_HP_X360_AMP` applied →
  GPIO toggled → speaker amp enabled.

**Step 2.3: Bug Mechanism**
Category (h): Hardware workaround / codec quirk. The existing
`ALC245_FIXUP_HP_X360_AMP` fixup already exists and works for sibling
models (0x87f6, 0x87f7). This just adds the correct matching entry for a
model with an unset PCI SSID.

**Step 2.4: Fix Quality**
- Obviously correct: Uses the well-established `HDA_CODEC_QUIRK` pattern
  already present ~10 times in this same table.
- Minimal: Single table entry addition.
- Regression risk: Essentially zero. Only affects devices with codec
  SSID `103c:885b`.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The existing `ALC245_FIXUP_HP_X360_AMP` entries for sibling models
(0x87f6, 0x87f7) date back to commit `aeeb85f26c3bb` (2025-07-09 file
split), but originate from much earlier. The fixup function
`alc245_fixup_hp_x360_amp` exists at line 1448.

**Step 3.2: Fixes tag**
No Fixes: tag — expected for this type of quirk addition.

**Step 3.3: File History**
Recent history shows a steady stream of similar quirk additions (Lenovo
Yoga, Acer Swift, HP Laptop, Samsung, ASUS, Framework). This is routine
maintenance for this file.

**Step 3.4: Author**
songxiebing is a recurring HDA contributor with 4 other commits in this
tree. Patch was merged by Takashi Iwai, the HDA subsystem maintainer.

**Step 3.5: Dependencies**
No dependencies. All required infrastructure exists in the 7.0 tree:
- `HDA_CODEC_QUIRK` macro (verified in
  `sound/hda/common/hda_local.h:314-320`)
- `ALC245_FIXUP_HP_X360_AMP` fixup (line 4841-4846)
- `alc245_fixup_hp_x360_amp` function (line 1448)
- `match_codec_ssid` matching logic in `auto_parser.c`

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.5:** Lore and bugzilla were unreachable due to anti-bot
protections. However, the commit message provides sufficient context:
- Bug reported via bugzilla.kernel.org (#221341)
- Patch submitted and applied within days by the subsystem maintainer
- The Link: tag confirms it went through normal mailing list review

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.2:** The affected function `alc245_fixup_hp_x360_amp` (line
1448) toggles GPIO pin 0x01 to enable the speaker amplifier. This is
called during HDA codec initialization. Without this quirk matching, the
amplifier stays off = no speaker output.

**Step 5.3-5.4:** The matching logic in `snd_hda_pick_fixup`
(`auto_parser.c:1066-1080`) walks the quirk table linearly. With
`match_codec_ssid=true`, the new entry is checked against codec SSID on
every probe of this codec. The call chain is: codec probe →
`snd_hda_pick_fixup` → table walk → match codec SSID → apply fixup.

**Step 5.5:** Similar `HDA_CODEC_QUIRK` entries exist for the same
purpose (ASUS, Lenovo devices with mismatched PCI/codec SSIDs). This is
a well-established pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The `HDA_CODEC_QUIRK` infrastructure and
`ALC245_FIXUP_HP_X360_AMP` fixup exist in the 7.0 stable tree. In older
trees (6.x), the file path would be `sound/pci/hda/patch_realtek.c` and
`HDA_CODEC_QUIRK` may need to be verified.

**Step 6.2:** For 7.0 specifically, the patch should apply with at most
minor context offset. The surrounding lines match the current tree
exactly.

**Step 6.3:** No existing fix for this specific device in the tree.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** ALSA/HDA is an IMPORTANT subsystem. Audio is a core user-
facing feature — no audio output is a severe usability issue.

**Step 7.2:** The file sees constant quirk additions (10+ in recent
history), and Takashi Iwai actively maintains it.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected: Users of HP Spectre x360 14-ea (2021 model).
This is a premium consumer laptop.
**Step 8.2:** Trigger: Every boot. Device always has no speaker output.
100% reproducible.
**Step 8.3:** Severity: HIGH — complete loss of audio output from
speakers. Device is essentially broken for audio use without this quirk.
**Step 8.4:** Benefit: HIGH — restores audio on a shipping consumer
laptop. Risk: VERY LOW — single table entry, only affects devices with
codec SSID 103c:885b, uses a well-tested fixup function that already
works on sibling models.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR:**
- Fixes complete audio failure (no speaker output) on a real consumer
  laptop
- User-reported via bugzilla (#221341)
- Single-line quirk table entry — minimal, surgical, obviously correct
- Uses existing well-tested fixup (`ALC245_FIXUP_HP_X360_AMP`) already
  applied to sibling models
- Merged by HDA subsystem maintainer Takashi Iwai
- Falls into the "hardware quirk" exception category — automatically YES
  per stable rules
- All required infrastructure exists in the 7.0 tree

**Evidence AGAINST:**
- None identified.

**Stable Rules Checklist:**
1. Obviously correct and tested? YES — identical pattern to existing
   entries, user-reported fix
2. Fixes a real bug? YES — no audio output on HP Spectre x360 14-ea
3. Important issue? YES — complete loss of speaker output
4. Small and contained? YES — 1 line added
5. No new features or APIs? YES — no new features
6. Can apply to stable? YES — all infrastructure present

**Exception Category:** Hardware quirk addition — automatically
qualifies for stable.

## Verification

- [Phase 1] Parsed all tags: Reported-by user, Closes bugzilla, merged
  by Takashi Iwai (HDA maintainer)
- [Phase 2] Diff: exactly 1 line added — `HDA_CODEC_QUIRK(0x103c,
  0x885b, ...)` in `alc269_fixup_tbl`
- [Phase 3] git blame: sibling entries (0x87f6, 0x87f7) for same fixup
  present since file split (aeeb85f26c3bb)
- [Phase 3] git log author: songxiebing has 4 other HDA commits in tree
- [Phase 5] Verified `HDA_CODEC_QUIRK` macro definition at
  `hda_local.h:314-320` sets `match_codec_ssid=true`
- [Phase 5] Verified `snd_hda_pick_fixup` matching logic at
  `auto_parser.c:1067-1080` — codec SSID path
- [Phase 5] Verified guard at `auto_parser.c:1019` prevents double-
  matching
- [Phase 5] Verified vendor catch-all at `alc269.c:7834` is in separate
  `alc269_fixup_vendor_tbl[]`
- [Phase 5] Verified `alc245_fixup_hp_x360_amp` function exists at line
  1448 (toggles GPIO for speaker amp)
- [Phase 6] Verified `ALC245_FIXUP_HP_X360_AMP` and `HDA_CODEC_QUIRK`
  both exist in the 7.0 tree
- [Phase 4] UNVERIFIED: Could not access bugzilla or lore due to anti-
  bot protections; relied on commit message metadata

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index f10ee482151f6..e50ad953b09e7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6955,6 +6955,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8847, "HP EliteBook x360 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884b, "HP EliteBook 840 Aero G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884c, "HP EliteBook 840 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
+	HDA_CODEC_QUIRK(0x103c, 0x885b, "HP Spectre x360 14-ea", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x8862, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x8863, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x886d, "HP ZBook Fury 17.3 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
-- 
2.53.0

