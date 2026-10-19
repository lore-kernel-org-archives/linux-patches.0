Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F0764C40A;
	Mon, 19 Oct 2026 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418826; cv=none; b=uujvO9FRifzsit4gXvLUwIZSPyTG5REikOmVF6rOb3F4mMhh+hC/D1RCMxTU4uPRZIH2rg+YvYR2geaLasvrDGcA1q7R/dWYdfOsdqlYFgT/McVSK/yTO0AnAbcdLq2swMswGq0cAby4mydJTDtuufvek+iTdu1VxRM0itidFS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418826; c=relaxed/simple;
	bh=sqcL0GY2ywTF8aRJH9sYcEsSs2ajLx9ikcBAEZe8QD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDySn3Kqy2vhWrraP6b0jO1ZZFI3CenFEAzZgGaDGRT5pfs3UWKKf4qGUcIWe1HmXXSqCLIqdQaVNm0LdSTDBQJL2XU6G+Mayl0u+4EgcziGZF1lA40/sB0nV2ZYg64HsdV7z7KjAOqjamisJPWL0n2Qh7aTKx53I5mw48FrNTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heA2iMeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heA2iMeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3531F000C4;
	Mon, 19 Oct 2026 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418814;
	bh=4qTdWVxFt0wuCUbw/btJFkq2aKk1a3vWXLWgJiiJKhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heA2iMeC8fEX72nlmG7AgA9O/qM79S1zO0MeNZCfY6g90ay4agQrKfCPiHJO+nrVB
	 jD6gI1OhNHIMCDQSm6faNpeavdwR/j5Zi0R4kn973m922KoXQ3PxDB0nGXP1AWAjNt
	 oTdQZl1CCWCB8UoCDJwCUnC8B1MS88WmYt5x/EZ815abqy/YrKNEOeXneyRTshC8F0
	 dUHNlpLGAcBo2fk1mC21TIQVRgMZpcYNihVR9G5FZpvmnDl4wXQc0+dxJNiPT+PBNR
	 z3isPKbtiFF1T3up5OQp79jaeLE22IoYs3641vDqa3bXK6k/cquSMQ1ONYG1edArFg
	 VA0b0xVX1bwnw==
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
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA
Date: Mon, 19 Oct 2026 09:53:27 -0400
Message-ID: <20261019135441.1420968-516-sashal@kernel.org>
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

[ Upstream commit f2d08f3651fb12634347fef2c41687a807a7dcba ]

On the ASUS Vivobook S14 S5406SA (subsystem 0x104310c4, Lunar Lake
platform) with an ALC294 codec, the headset microphone (3.5mm jack)
fails to capture any audio. Adding the ALC2XX_FIXUP_HEADSET_MIC
quirk resolves the issue and restores proper headset mic recording.

Link: https://github.com/thesofproject/linux/issues/5729
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-3-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide for this 6.12 tree: the quirk and insertion
point exist, the 0x10c4 entry does not.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ALSA/hda/realtek] [Fix] [headset microphone capture on ASUS
Vivobook S14 S5406SA]**

Subsystem prefix is `ALSA: hda/realtek`. Action verb is **Fix**. Claimed
intent is restoring 3.5mm headset-mic capture on one ASUS laptop by
adding a PCI subsystem quirk.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Link:** https://github.com/thesofproject/linux/issues/5729 (user bug
  report; later confirmed fixed by the model/quirk)
- **Link:**
  https://patch.msgid.link/20260807125857.678297-3-zhangheng@kylinos.cn
  (alsa-devel submission; patch 3/4)
- **Signed-off-by:** Zhang Heng \<zhangheng@kylinos.cn\> (author)
- **Signed-off-by:** Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer;
  applied the series)
- **Fixes:** none (expected)
- **Cc: stable:** none (expected)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none in the
  commit message

Notable: msgid `-3` shows this was patch 3 of a 4-patch batch of
independent hardware quirks, not a dependent refactor series.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** On ASUS Vivobook S14 S5406SA, PCI subsystem `0x1043:0x10c4`,
  Lunar Lake + ALC294, the 3.5mm headset microphone captures silence.
  Headset speakers work; internal DMIC works.
- **Symptom:** Userspace sees a “Headphones Stereo Microphone” source
  that records silence; analog capture mixer controls are missing.
- **Root cause (from message + issue):** BIOS leaves headset-mic pin
  0x19 as `0x411111f0` (N/A). `ALC2XX_FIXUP_HEADSET_MIC` overrides that
  pin and sets `HDA_PINCFG_HEADSET_MIC`.
- **Version info in message:** Lunar Lake platform; GitHub reporter was
  on 6.17, but that does not limit this tree.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a hidden fix.** It is an explicit hardware-quirk bug fix:
one `SND_PCI_QUIRK` line. No cleanup/refactor disguise.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File in upstream commit:** `sound/hda/codecs/realtek/alc269.c` (+1 /
  −0)
- **File in this tree:** `sound/pci/hda/patch_realtek.c` (Realtek codec
  not yet split)
- **Function / table:** `alc269_fixup_tbl[]`
- **Scope:** single-file, one-line surgical hardware quirk

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** SSID `0x1043:0x10c4` has no PCI quirk. `patch_alc269()`
  still calls `snd_hda_pick_fixup()` on `alc269_fixup_tbl`. Existing
  ASUS ALC294 *pin* quirks do not match this machine’s pin 0x12
  (`0x40000000` vs required `0x90a60130`), so no headset-mic fixup is
  applied. Pin 0x19 stays N/A; analog headset mic is never parsed.
- **After:** That SSID selects `ALC2XX_FIXUP_HEADSET_MIC` at PRE_PROBE.
- **Path:** codec probe / jack autoconfig only; not a hot path, error
  path, or API change.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Hardware workaround / pin-config quirk]**

In this tree `ALC2XX_FIXUP_HEADSET_MIC` is:

```10552:10555:sound/pci/hda/patch_realtek.c
        [ALC2XX_FIXUP_HEADSET_MIC] = {
                .type = HDA_FIXUP_FUNC,
                .v.func = alc_fixup_headset_mic,
        },
```

`alc_fixup_headset_mic()` (same body as later
`alc2xx_fixup_headset_mic`) does:
1. Override pin 0x19 to `0x03a1103c` (headset mic)
2. Update coef 0x45
3. Set `spec->parse_flags |= HDA_PINCFG_HEADSET_MIC`

That matches the GitHub dump: pin 0x19 was `0x411111f0` with VREF_HIZ.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: **Obviously correct and minimal.** One PCI ID, existing fixup
already used for Acer Nitro 5, ASUS Vivobook 15 X1504VAP, Gigabyte,
Huawei, Clevo, TongFang, HONOR. Regression surface is only SSID
`0x1043:0x10c4`. No locking, no API, no new code. **Regression risk:
very low.**

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record: The new line is an addition. Neighboring entries exist in this
tree at:

```11192:11193:sound/pci/hda/patch_realtek.c
        SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA",
ALC256_FIXUP_ASUS_MIC),
        SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ",
ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
```

The *bug* is missing pin config from BIOS, not a regression in a
specific old commit. The reusable fixup was added by `1c643c600407d`
(“Add new alc2xx-fixup-headset-mic model”, 2024-12-07), which is **in
this tree** (`git merge-base --is-ancestor 1c643c600407d HEAD`
succeeded). That is the stable backport of upstream `50db91fccea0d`
(first contained in v6.13-rc3; original SHA is **not** an ancestor of
this 6.12 branch, but the equivalent change is present).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Not applicable. The hardware never had a
working pin default for this SSID in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: `sound/pci/hda/patch_realtek.c` is actively receiving similar
one-line quirks (mute LEDs, speakers, headset mics). Recent history is
the same class of change. **No prerequisite series for this one line.**
Similar in-tree uses of `ALC2XX_FIXUP_HEADSET_MIC` include Acer Nitro 5
(`0x1025:0x1539/159c/1597`) and ASUS Vivobook 15 X1504VAP
(`0x1043:0x1e1f`).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Zhang Heng has multiple Realtek quirk commits in this tree
(Samsung, ASUS UM6702RC, Inspur, Conexant). Regular ALSA hda
contributor; this patch was applied by maintainer Takashi Iwai. Related
same-day patches are other independent quirks (Acer Nitro ANV16-42, Acer
Gadget E10, Huawei Matebook Conexant), not dependencies.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **Standalone.** Needs only `ALC2XX_FIXUP_HEADSET_MIC` /
`alc_fixup_headset_mic()`, both present. Series 1/4, 2/4, and 4/4 touch
different SSIDs/files. File path in the upstream diff (`alc269.c`) must
be rewritten to `patch_realtek.c` here; the hunk context around
`0x10c0`/`0x10d0` matches.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **Lore msgid:** `20260807125857.678297-3-zhangheng@kylinos.cn`
- **b4 mbox:** 5 messages; series is four independent quirks
  (2026-08-07)
- **Revisions:** single submission (`[PATCH 3/4]`); no v2/v3 in the
  thread
- **Maintainer:** Takashi Iwai: “Applied all four patches now. Thanks.”
  — no NAK, no requested changes, no stable-risk comments
- Direct lore.kernel.org HTTP fetches returned 403; thread was recovered
  via `b4 mbox`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: **To:** tiwai@suse.com. **Cc:** linux-sound@vger.kernel.org,
linux-kernel@vger.kernel.org. Subsystem maintainer received and applied
it. `b4 dig -w` was not used (no upstream SHA in this checkout);
recipients came from the mbox.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: GitHub thesofproject/linux#5729 (closed):
- Hardware: ASUS Vivobook S14 S5406SA, ALC294, SSID `0x104310c4`, Intel
  Lunar Lake, driver `sof-audio-pci-intel-lnl`
- Symptom: headset speakers OK, headset mic silent; pin 0x19 =
  `0x411111f0`
- Pierre-Louis Bossart: ALC294 config issue, not SOF
- Zhang Heng / Kailang Yang: try model `alc2xx-fixup-headset-mic`
- Reporter **confirmed** `hda_model=alc2xx-fixup-headset-mic` on the
  same machine: dmesg `Headset Mic=0x19`, jack detect works, `pw-record`
  captures real audio
- Also referenced Arch forum thread for the same SSID

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Batch of four independent hardware quirks. This patch does not
need the others. Other patches are not required for this SSID to work.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search returned HTTP 403. **UNVERIFIED**
whether someone already asked stable@ for this specific commit. No in-
tree evidence it was rejected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: No function body changed. Touches `alc269_fixup_tbl[]`. Runtime
effect is via `alc_fixup_headset_mic()` selected as
`ALC2XX_FIXUP_HEADSET_MIC`.

**Step 5.2: TRACE CALLERS**

Record:
- `HDA_CODEC_ENTRY(0x10ec0294, "ALC294", patch_alc269)` at line 13992
- `patch_alc269()` → `snd_hda_pick_fixup(..., alc269_fixup_tbl,
  alc269_fixups)` at 12583–12584
- Called at codec probe (HDA/SOF HDA generic), not IRQ/syscall hot path
- Impact surface: **only** PCI subsystem `0x1043:0x10c4`

**Step 5.3: TRACE CALLEES**

Record: `alc_fixup_headset_mic` → `snd_hda_apply_pincfgs`,
`alc_update_coef_idx`, sets `HDA_PINCFG_HEADSET_MIC`. Same pattern
already used on other laptops in this file.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Plug headset → HDA jack parse/probe → if quirk matches, pin 0x19
becomes a headset mic. **Reachable from userspace** on that laptop
(PipeWire/ALSA capture). Reporter confirmed it.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same `ALC2XX_FIXUP_HEADSET_MIC` already applied to multiple
vendors in `alc269_fixup_tbl`. This is the standard pattern for “BIOS
left headset mic pin as 0x411111f0”.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** This tree is **6.12.111** (`pending-6.12`, `git
describe HEAD` = `p-6.12-3-g710455e2077bb`). Makefile: VERSION=6
PATCHLEVEL=12 SUBLEVEL=111.

- Quirk `0x1043:0x10c4` / “S5406SA” is **absent** (`git grep` found no
  matches).
- Realtek driver, ALC294 `patch_alc269`, `ALC2XX_FIXUP_HEADSET_MIC`, and
  Lunar Lake SOF (`sound/soc/sof/intel/pci-lnl.c`) **are present**.
- The machine is a 2024/2025 Lunar Lake laptop; 6.12 is an LTS that runs
  that hardware.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Minor path remap, otherwise clean.** Upstream hunk is against
`sound/hda/codecs/realtek/alc269.c`; here the table is
`sound/pci/hda/patch_realtek.c`. Context lines `0x10c0` then `0x10d0`
match exactly. Enum name is the same. **Expected difficulty: trivial
backport** (standard for HD-audio quirks on 6.12).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Subject grep for S5406SA / this title found nothing. Pin quirks
for ASUS ALC294 do not match this pin dump (0x12 is `0x40000000`, not
`0x90a60130`). **No existing fix for this SSID.**

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **[sound/pci/hda Realtek codec] [IMPORTANT]** — common laptop
audio, not mm/core, but HD-audio quirks are a large fraction of stable
backports. Affects users of this ASUS model.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: **Active but mature quirk table.** Recent commits are almost all
device-specific `SND_PCI_QUIRK` additions — the same class as this
patch.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver/hardware-specific** — only ASUS SSID `0x1043:0x10c4`
(Vivobook S14 S5406SA, ALC294). Other machines unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: **Every use of the 3.5mm headset mic** on that laptop. Not a
race. Unprivileged user hits it by recording from the headset. Internal
DMIC still works, so some users workaround; headset-mic users do not.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **[Headset analog capture silently fails] [MEDIUM functional /
HIGH for affected hardware]** — not a panic/UAF, but the combo-jack mic
is unusable, which is exactly what hardware-quirk stable exceptions
cover. Confirmed by a real user; second report on Arch for the same
SSID.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** High for owners of this laptop on 6.12 LTS (headset mic
  works without a modprobe model override).
- **Risk:** Very low — one table entry, existing fixup, SSID-matched,
  maintainer-applied, user-tested.
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real, user-confirmed hardware bug (GitHub #5729; model param proven on
  the same machine)
- Classic HD-audio PCI quirk — stable exception category
- One line, existing `ALC2XX_FIXUP_HEADSET_MIC` already in 6.12
- ALC294 and Lunar Lake SOF support exist here
- Isolated to one SSID; no API/feature
- Applied by Takashi Iwai; no NAKs
- Insertion context `0x10c0`/`0x10d0` matches this file

**AGAINST:**
- Upstream path is `alc269.c`; this tree still uses `patch_realtek.c`
  (trivial remap)
- Not a crash/security issue (quirks are still accepted)
- Original patch had no Cc: stable (not a negative per the rules)

**UNRESOLVED:**
- lore.kernel.org HTTP 403; stable@ discussion not fetched (thread
  recovered via b4)
- No upstream SHA in this checkout for `b4 dig -c`

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — same fixup already in tree;
   reporter confirmed `alc2xx-fixup-headset-mic`; maintainer applied it
2. Fixes a real bug that affects users? **PASS** — silent headset-mic
   capture on a shipping Lunar Lake ASUS
3. Important issue? **PASS** under the hardware-quirk exception (device
   feature broken; not cosmetic)
4. Small and contained? **PASS** — +1 line
5. No new features or APIs? **PASS** — existing quirk ID only
6. Can apply to the local tree? **PASS** — needs path change to
   `sound/pci/hda/patch_realtek.c`; context matches

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk/workaround** (and PCI-ID-style table addition
to an existing driver). Automatic YES class per the stable quirk rules.

**Step 9.4: MAKE YOUR DECISION**

This belongs on 6.12. The bug is present, the fixup infrastructure is
present, Lunar Lake audio is present, and the change is a one-line SSID
quirk that only enables headset-mic pin parsing on that laptop.

Verification:
- [Phase 1] Parsed subject/tags: Fix + GitHub issue + msgid 3/4; no
  Fixes/Cc:stable (expected)
- [Phase 1] Body: ALC294 SSID 0x104310c4 headset mic silent; quirk
  ALC2XX_FIXUP_HEADSET_MIC
- [Phase 2] Diff: +1 SND_PCI_QUIRK(0x1043, 0x10c4, ...) in
  alc269_fixup_tbl
- [Phase 2] This tree implements that ID via alc_fixup_headset_mic():
  pin 0x19 → 0x03a1103c + HDA_PINCFG_HEADSET_MIC
- [Phase 3] 1c643c600407d (alc2xx-fixup-headset-mic model) is in HEAD;
  upstream 50db91fccea0d is not an ancestor (expected 6.12 vs 6.13)
- [Phase 3] git log --grep=S5406SA -- sound/pci/hda/: no matches; quirk
  not already applied
- [Phase 3] Series 1/4–4/4 are independent quirks; 3/4 is standalone
- [Phase 4] b4 mbox 20260807125857.678297-3: Takashi Iwai applied all
  four; no NAK
- [Phase 4] GitHub #5729: reporter confirmed hda_model=alc2xx-fixup-
  headset-mic restores capture
- [Phase 4] lore.kernel.org WebFetch: 403 — UNVERIFIED via HTTP;
  recovered via b4
- [Phase 5] ALC294 → patch_alc269 →
  snd_hda_pick_fixup(alc269_fixup_tbl); caller is codec probe
- [Phase 5] ASUS ALC294 pin quirks do not match this machine (0x12 is
  0x40000000)
- [Phase 6] git describe HEAD: p-6.12-3-g710455e2077bb; make
  kernelversion 6.12.111
- [Phase 6] File is sound/pci/hda/patch_realtek.c; 0x10c0/0x10d0
  neighbors match; 0x10c4 absent
- [Phase 6] sound/soc/sof/intel/pci-lnl.c present (Lunar Lake SOF)
- [Phase 8] Failure mode: silent analog headset mic, SSID-scoped;
  severity medium functionally, high for that hardware
- UNVERIFIED: whether stable@ already discussed this commit (lore 403)

The one-line quirk is the standard stable HD-audio backport: it restores
headset-mic capture on one confirmed laptop with negligible risk.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 97ab2269dc472..8fdfe1bbe7aff 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7101,6 +7101,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10a4, "ASUS TP3407SA", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS Vivobook S14 S5406SA", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1154, "ASUS TP3607SH", ALC287_FIXUP_TAS2781_I2C),
-- 
2.53.0

