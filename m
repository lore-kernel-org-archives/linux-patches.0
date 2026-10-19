Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FF6554089;
	Mon, 19 Oct 2026 13:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418125; cv=none; b=X8RiQfzrPCp2wSeTB+galzcJSPhMmqAFLZBvOOEJGEo4guJe7B0S6ucaaZ3TX/n6J7Qm6pAr2Qpjh+AKimIgAgCV+y5x0+21Knw7qKOZ39aI4xedzhnP28VDBNJQvT7np4dlaYFsxxQRAwQHuombZfgHPWzWWVPPv5twRVQ0rH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418125; c=relaxed/simple;
	bh=bP5OFjwGnwFhxNRKCKrV8InRtYrlSZbS62HCb7iAclY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHUc2FyFsK2SVIhXLpwXXlgy6InD5Kf5D6SQXWI1Q5JaVR9r0zAVZtC93qtmHGzEUDBPo3ftslRCPZpv2PI3R6wXDzmDZg+bQv3HP3arm/gyCL2bx2hUgVnKx8h1nlBxe4PBCILzxZHWrxGIDZIYPSDE9HeP/zkwwf2cyKxJN+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQLPIFsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQLPIFsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2D01F000C4;
	Mon, 19 Oct 2026 13:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418123;
	bh=ttHXu1rxmm47eN9mD6sVUiTLxtrzBGIfofEL2ZFh0XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQLPIFsn7zVOh61/nfex4W6FFDiNrc50XWakKJ9OZNz6ZUnkaF/KdQuVEoWNLxRT2
	 +rxVLREn22oCQW0WDBeQZZuSKbq+BCXxKwdQ2tF4UPmvS6CCEkhbjXnW9uccfa/Lfx
	 oQ1k5GOBGH/IkZf3HcfA763LAvdJlSB0kQZqpD9kDXc/hqlGGa3l4U3mZX0kdMCnwQ
	 RlmWDT4QUlACrSEZyJF6KkheLp9jSxdtl9eXCcL5mQG6ZwL7575OTHVECOQdna4Lvi
	 1dCkguvHn8HofWQxEkNuWXpGh1KZxV05oazOcXJJ1ZWdpxHOCza7NfZ7HEcvNeJ7yB
	 niAbndl+xVJAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmytro Moroziuk <dmorozyk1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5
Date: Mon, 19 Oct 2026 09:45:19 -0400
Message-ID: <20261019135441.1420968-28-sashal@kernel.org>
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

From: Dmytro Moroziuk <dmorozyk1@gmail.com>

[ Upstream commit 191fe151eb85ff6cb24189fc88c970745497c057 ]

The HP ProBook 440 G5 requires the CXT_FIXUP_MUTE_LED_GPIO quirk to
properly toggle the physical mute and mic-mute LEDs via the CX8200 codec.
Without this quirk, the LEDs remain permanently dark.

Signed-off-by: Dmytro Moroziuk <dmorozyk1@gmail.com>
Link: https://patch.msgid.link/20260812121856.30353-1-dmorozyk1@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line Conexant mute-LED quirk for HP ProBook 440 G5 (PCI
SSID `0x103c:0x837b`). The local tree is **6.12.111** (`pending-6.12`);
the driver and sibling G4/G5 quirks are already here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [ALSA: hda/conexant] [Add] [mute LED quirk for HP ProBook 440
G5]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Dmytro Moroziuk \<dmorozyk1@gmail.com\> (author)
- Link:
  https://patch.msgid.link/20260812121856.30353-1-dmorozyk1@gmail.com
- Signed-off-by: Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence is expected for this review)
- Ignore any pipeline-added Sasha Levin SOB / Upstream commit markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: HP ProBook 440 G5 mute and mic-mute LEDs stay off because the
  CX8200 codec is not wired to `CXT_FIXUP_MUTE_LED_GPIO`.
- Symptom: physical mute/mic-mute LEDs remain permanently dark.
- Root cause: missing `SND_PCI_QUIRK` for SSID `0x103c:0x837b`.
- No stack traces, no kernel version range, no crash.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden fix. It is an explicit hardware quirk / device-
table addition.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- Upstream file: `sound/hda/codecs/conexant.c` (+1 / −0)
- Function/table: `cxt5066_fixups[]`
- Scope: single-file, one-line table insert

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: SSID `0x103c:0x837b` matches no quirk; GPIO mute-LED setup is
  skipped.
- After: match applies `CXT_FIXUP_MUTE_LED_GPIO` →
  `cxt_fixup_mute_led_gpio()` at `HDA_FIXUP_ACT_PRE_PROBE` →
  `cxt_setup_mute_led(codec, 0x01, 0x02)`.
- Path: codec probe / initialization only; no error-path or hot-path
  change.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: [Hardware workaround / codec quirk]
- Mechanism: missing PCI SSID in the existing Conexant quirk table.
- Fix: add one `SND_PCI_QUIRK` using the same `CXT_FIXUP_MUTE_LED_GPIO`
  already used by ProBook 440 G4 (`0x822e`), 455 G5 (`0x836e`), 470 G5
  (`0x837f`), 450 G4 (`0x8231`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct; surgical; no API/locking/refcount change.
Regression risk is limited to that SSID. `0x837b` is unused in this
tree’s quirk table.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: The new line did not exist here. Adjacent entries:
- `0x836e` HP ProBook 455 G5 — present since at least Takashi Iwai 2021
  (`2e6a731296be9d`)
- `0x837f` HP ProBook 470 G5 — same
- `0x822e` HP ProBook 440 G4 — `ba92b11428797` (Kai-Heng Feng, 2017),
  originally `Cc: stable # v4.12+`
`CXT_FIXUP_MUTE_LED_GPIO` itself dates to `5cd5b1bdfb013` (HP ZBook 15u
G3, 2017).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. The “bug” is a missing table entry, not a
regression from a specific commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same-file mute-LED quirks already in this tree include 440 G4,
450 G4 (`1cce98bf41390`, backported here with `Cc: stable`), 455 G5, 470
G5, 645 G4. Standalone, not a series.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: No prior Dmytro Moroziuk commits on `sound/pci/hda/` in this
tree. ALSA maintainer Takashi Iwai applied it the same day.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `CXT_FIXUP_MUTE_LED_GPIO` / `cxt_fixup_mute_led_gpio()` /
`cxt5066_fixups[]` — all present. Standalone. Path remapped from
`sound/hda/codecs/conexant.c` (post-6.12 move) to
`sound/pci/hda/patch_conexant.c`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 191fe151eb85f` →
  https://patch.msgid.link/20260812121856.30353-1-dmorozyk1@gmail.com
- Single v1 series; no v2/v3
- Thread: author submission + Takashi Iwai: “Thanks, applied to for-next
  branch now.”
- No NAK, no requested changes, no reviewer Cc: stable (common for one-
  line quirks)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc perex@perex.cz, tiwai@suse.com, linux-
sound@vger.kernel.org. Right list and both ALSA maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. User-visible hardware issue stated in
the commit; accepted by the subsystem maintainer.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone one-patch series. Later `origin/master` conexant
commits (headset plugin, SN6140 S3) do not touch `0x837b`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable@ discussion found for this model/ID. Sibling quirks
historically went to stable with explicit Cc.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: Table `cxt5066_fixups[]`; applied fixup
`cxt_fixup_mute_led_gpio()`.

**Step 5.2: TRACE CALLERS**
Record: `patch_conexant_auto()` → `snd_hda_pick_fixup(...,
cxt5066_fixups, ...)` for codec IDs including default and CX8200
(`HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto)` at line
1305). Lookup is PCI subsystem vendor/device.

**Step 5.3: TRACE CALLEES**
Record: `cxt_fixup_mute_led_gpio` → `cxt_setup_mute_led(codec, 0x01,
0x02)` → `snd_hda_gen_add_mute_led_cdev` /
`snd_hda_gen_add_micmute_led_cdev`. Existing, stable helpers.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Codec probe on matching HP laptop. Userspace mute/mic-mute then
drives GPIO LEDs. Reachable on that hardware; not a generic syscall
crash path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same one-line pattern used for several HP ProBook G4/G5 Conexant
machines; 450 G4 already backported into this 6.12 tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: `p-6.12-3-gc504cf0baa3d8`, `make kernelversion` = 6.12.111
- `git merge-base --is-ancestor 191fe151eb85f HEAD` → not present
- File here: `sound/pci/hda/patch_conexant.c` (no
  `sound/hda/codecs/conexant.c`)
- `cxt5066_fixups[]` exists; `0x837b` / “HP ProBook 440 G5” absent
- CX8200 codec entry exists
- Bug is long-standing missing hardware enablement, not a post-6.12
  regression

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Path remap required. Context matches. `git apply --check` after
remapping to `sound/pci/hda/patch_conexant.c`: “Hunk #1 succeeded at
1105 (offset -2 lines).” Clean apply with trivial path change.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No 440 G5 / `0x837b` entry. Related G4/G5 mute-LED quirks are
already present.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [sound/pci/hda Conexant codec] [IMPORTANT for laptop audio;
quirk is machine-specific]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature table; regular quirk additions. Recent local commits
include other pin/quirk updates. Typical LTS candidate.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / platform-specific: HP ProBook 440 G5 (SSID
0x103c:0x837b) with CX8200, `CONFIG_SND_HDA_CODEC_CONEXANT`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot on that laptop. Mute/mic-mute keys do not light LEDs.
Unprivileged users see dead LEDs; not a privilege issue.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Mute/mic-mute LEDs stay dark. Severity LOW as crash/corruption,
but a real hardware bug that stable rules call out as a quirk.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: restores LED behavior on a shipping HP ProBook still used on
  6.12 LTS; matches sibling models already in this tree.
- Risk: one table line, SSID-gated, existing fixup. Very low.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Explicit hardware quirk / PCI ID addition (stable-rules exception)
- Fixes user-visible broken mute/mic-mute LEDs on HP ProBook 440 G5
- One line, existing `CXT_FIXUP_MUTE_LED_GPIO`
- Same pattern as 440 G4 / 450 G4 / 455 G5 / 470 G5 already in this tree
- 450 G4 equivalent already backported here with Cc: stable
- Applied by ALSA maintainer; no NAK
- Applies here with only a path remap
- `Documentation/process/stable-kernel-rules.rst`: “fix a real bug … or
  just add a device ID” and “hardware quirk”

AGAINST:
- Not a crash, UAF, or security issue
- No Fixes:/Cc: stable (not a negative for this pipeline)
- Author is not a regular conexant contributor (mitigated by maintainer
  apply)

UNRESOLVED:
- Independently verifying the reporter’s hardware beyond SSID +
  maintainer accept: not possible from git/lore
- lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig
  -m`

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? PASS — one-line table entry, maintainer
   applied
2. Fixes a real bug that affects users? PASS — LEDs stay dark on that
   laptop
3. Important issue? PASS as hardware quirk / device ID (not crash-level)
4. Small and contained? PASS — +1 line
5. No new features or APIs? PASS — existing fixup, new SSID only
6. Can apply to the local tree? PASS — context present; remap
   `sound/hda/codecs/conexant.c` → `sound/pci/hda/patch_conexant.c`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Hardware quirk / codec quirk table entry (also a device-ID-style
addition to an existing driver).

**Step 9.4: MAKE YOUR DECISION**
This belongs in 6.12.y. The driver, fixup, and neighboring ProBook G5
IDs are already here; only this SSID is missing. Risk is negligible.

------------------------------------------------
What the commit solves and why it matters
------------------------------------------------
Without the quirk, CX8200 GPIO mute/mic-mute LEDs on HP ProBook 440 G5
never toggle. That is a real hardware bug for owners of this 2018-era
ProBook on LTS. The fix is the same one-line SSID mapping already used
on 440 G4 and other G5 ProBooks.

Risk vs benefit: benefit is working LEDs on one laptop model; risk is
confined to SSID `0x103c:0x837b`. Backport needs only the file-path
rename from the later HDA codec shuffle.

Verification:
- [Phase 1] Parsed tags: author SOB, Link msgid, Takashi Iwai SOB; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x103c, 0x837b, "HP ProBook 440 G5",
  CXT_FIXUP_MUTE_LED_GPIO)` in `cxt5066_fixups[]`
- [Phase 2] Local `cxt_fixup_mute_led_gpio()` at
  `sound/pci/hda/patch_conexant.c:789` calls `cxt_setup_mute_led(codec,
  0x01, 0x02)`
- [Phase 3] `git blame -L 1098,1115`: sibling G4/G5 quirks present; 440
  G4 is `ba92b11428797` with original Cc: stable
- [Phase 3] `git show 1cce98bf41390`: 450 G4 mute-LED quirk already in
  this 6.12 tree from upstream
- [Phase 3] `git log --author="Dmytro Moroziuk"` on `sound/pci/hda/`: no
  prior commits
- [Phase 4] `b4 dig -c 191fe151eb85f`: lore match; v1 only; recipients
  perex/tiwai/linux-sound
- [Phase 4] mbox: Iwai “Thanks, applied to for-next branch now.”; no NAK
- [Phase 4] WebFetch lore URLs: 403; thread recovered via b4
- [Phase 4] WebSearch stable@: no discussion of this model
- [Phase 5] CX8200 `HDA_CODEC_ENTRY(0x14f12008, "CX8200",
  patch_conexant_auto)` present; `snd_hda_pick_fixup` matches PCI SSID
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111
- [Phase 6] `git merge-base --is-ancestor 191fe151eb85f HEAD` → not in
  tree
- [Phase 6] grep `0x837b` / `HP ProBook 440 G5` in conexant: no match
- [Phase 6] remapped `git apply --check`: hunk succeeded at 1105 (offset
  -2)
- [Phase 6] `git log origin/master` after the commit: later conexant
  changes do not touch `0x837b`
- [Phase 7/8] Failure mode: dark mute/mic-mute LEDs on one HP model;
  quirk exception applies
- UNVERIFIED: physical confirmation of reporter’s 440 G5/CX8200 beyond
  commit + maintainer apply
- UNVERIFIED: lore.kernel.org HTML fetch (403); b4 mbox used instead

**YES**

 sound/hda/codecs/conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index ef40f1cb1158e..862fcbe74e4f0 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -1115,6 +1115,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x837b, "HP ProBook 440 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
-- 
2.53.0

