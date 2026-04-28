Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EED5426D1E;
	Tue, 28 Apr 2026 10:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372992; cv=none; b=CiOzf0bI7Bs9f6gJtTZTR2xR9Q3ZbLkYQi5gc1cN/RB0+oLSWeMyx16ZwrjiK91PMHgvKUC57ejXxB4+gekBs9/qAmT/6PFwxTNyHP2QHHJm0/FyHOxozzOTo43bJIexClpkt49fDmLUoVGZ+cQWPLuCZBkKCWxv7F40kiIVZo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372992; c=relaxed/simple;
	bh=pnXTzg5KhppOl3PsXPt6ZfgfCnMW4wHGwL8Vj2F8zqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlCw6aR14MR60aSYJvfwxRHHC8A68xTsIS+q/27ZQEWP7I6M/Y2s2XmD8bRhEd9FuH8y51G/fI/MaL4s6pYjKdG2ZpmG+7PTtKdqkkhdZyvvtFo7YPFDvdYWyT70AFNReCJetYok0Utzv+qCrVcFKUWoMXLsoDxZDpQRrPxr0d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHpcTL6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHpcTL6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC95C2BCB8;
	Tue, 28 Apr 2026 10:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372991;
	bh=pnXTzg5KhppOl3PsXPt6ZfgfCnMW4wHGwL8Vj2F8zqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHpcTL6eMd7182h9/diwSZ2iv/CfAzQfVuddvnXHS+EmM1KWD/R+uUtlwWz9fMgCn
	 riwWXz7jDoSyVKIgYoiihc4+6v2H6fS34nxWwxUrRh/AW2eZyMGafDTDseXWnYng7L
	 9ynWX49AQ2Y5uoaqrlGTmDDe/ysFJwOlnEI8yGCmgx04bWzx04KW3ETzufYbYd4cvj
	 72GGJClor3k4vtcPlwtcZjdPdg6ykOSv5vxoLkcdKkDKgUlRAqxoCpfMxd3Jgb6I9A
	 kiq1WyvBfttRHMlSpJhiweyKgQ60OvtycWzZpJDAqxgmOtymL0IVcX/0TCkCSY6Kiw
	 oy1iz2AaYQ2vg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johnathan Penberthy <johnathan.penberthy@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: usb-audio: Add quirk entries for NexiGo N930W webcam
Date: Tue, 28 Apr 2026 06:41:19 -0400
Message-ID: <20260428104133.2858589-68-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johnathan Penberthy <johnathan.penberthy@gmail.com>

[ Upstream commit 17bc5dd49214b50c9eb6df0fad1d1aea287dd078 ]

The NexiGo N930W 60fps webcam (USB ID 3443:930d) hits the same
'cannot get freq at ep 0x84' error in snd-usb-audio as its sibling
N930AF (1bcf:2283). Without QUIRK_FLAG_GET_SAMPLE_RATE the ADC clock
is never configured and the microphone streams only zero samples.

Testing on Linux 6.17 with QUIRK_FLAG_GET_SAMPLE_RATE |
QUIRK_FLAG_MIC_RES_16 (via quirk_alias=3443930d:1bcf2283) confirmed
the microphone captures real audio after a cold USB re-enumeration.
Adding a native quirk_flags_table entry avoids the alias workaround.

Signed-off-by: Johnathan Penberthy <johnathan.penberthy@gmail.com>
Link: https://patch.msgid.link/20260417010123.3080904-1-johnathan.penberthy@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, I have all the information needed to make a
decision. Let me provide the complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line parse**
- Subsystem prefix: `ALSA: usb-audio:`
- Action verb: "Add" (quirk entries)
- Record: ALSA USB audio subsystem; adds device-specific quirk for
  NexiGo N930W webcam (USB ID 3443:930d) to fix non-functional
  microphone.

**Step 1.2 — Tags inventory**
- `Signed-off-by: Johnathan Penberthy <johnathan.penberthy@gmail.com>`
  (author)
- `Link: https://patch.msgid.link/20260417010123.3080904-1-
  johnathan.penberthy@gmail.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (subsystem maintainer
  who applied it)
- No Fixes:, no Cc: stable (expected), no Reported-by/Tested-
  by/Reviewed-by tags
- Record: Single-author patch applied directly by ALSA maintainer; no
  syzbot involvement, but submitter explicitly tested on real hardware
  (Linux 6.17).

**Step 1.3 — Body analysis**
- Bug: webcam reports `cannot get freq at ep 0x84`; ADC clock never
  configured; mic streams **only zero samples** (i.e., silent
  microphone).
- Author tested with `quirk_alias=3443930d:1bcf2283` (mapping to
  existing N930AF entry), confirmed mic captures real audio after re-
  enumeration.
- Author explicitly identifies this as the same firmware bug class as
  sibling N930AF (1bcf:2283).
- Record: Concrete user-visible failure (broken microphone),
  reproducible trigger (every device use), confirmed fix on real
  hardware.

**Step 1.4 — Hidden bug fix detection**
- Subject says "Add", but this is a **hardware workaround**: it fixes a
  real broken firmware behavior in a specific webcam model.
- Record: Falls squarely into the "hardware quirk/workaround" exception
  category that is YES for stable.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
- Files: 1 (`sound/usb/quirks.c`)
- Lines: +2, -0
- Function modified: `quirk_flags_table[]` (static const table) — single
  new `DEVICE_FLG()` entry
- Record: Surgical, single-file, two-line addition to a static const
  data table.

**Step 2.2 — Code flow change**
- Before: USB device 3443:930d had no entry; falls through to default
  handling, fails `GET_SAMPLE_RATE`, mic capture volume resolution wrong
  → silent mic.
- After: matches new entry, sets `chip->quirk_flags |=
  QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16` during
  `snd_usb_init_quirk_flags()`.
- Record: Pure additive entry; affects only this exact VID:PID.

**Step 2.3 — Bug mechanism**
- Category: **Hardware workaround** (quirk table entry).
- Mechanism: `QUIRK_FLAG_GET_SAMPLE_RATE` makes
  `snd_usb_get_sample_rate()` short-circuit (return 0) so the ADC clock
  setup proceeds; `QUIRK_FLAG_MIC_RES_16` overrides the mic capture
  volume control resolution to 16 (verified at `sound/usb/mixer.c:1085`
  and `sound/usb/clock.c:490`).
- Record: Standard quirk pattern, identical to the existing sibling
  `DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */, ...)`.

**Step 2.4 — Fix quality**
- Obviously correct: only matches by exact VID:PID; both flags are pre-
  existing and battle-tested for this exact hardware family.
- Regression risk: essentially zero — only that one specific device is
  affected; cannot impact any other hardware.
- Record: Fix is minimal, surgical, zero collateral risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame on the changed area**
- Adjacent line `0x339b, 0x3a07 /* Synaptics HONOR USB-C HEADSET */` was
  introduced in commit `2cbe4ac193ed7` ("ALSA: usb-audio: Add mute TLV
  for playback volumes on more devices"), present from v6.17-rc5.
- Record: The exact textual context of the new line appears only in
  v6.17+, but the table itself exists since v5.15.

**Step 3.2 — Fixes: tag**
- No Fixes: tag (expected; this is hardware enablement, not a regression
  of a kernel commit).
- The bug is **firmware-side**: the webcam itself is misbehaving.
- Record: N/A.

**Step 3.3 — File history**
- Recent quirks.c changes are all the same kind (per-device quirk
  additions, e.g., `bc5b4e5ae1a67`, `ee6c551a7d84f`, `5182e5ec4355d`,
  etc.). This is a routine, well-understood change pattern.
- Record: Standalone fix, no series, no prerequisites.

**Step 3.4 — Author**
- Johnathan Penberthy: not a regular contributor, but the patch came
  from a real user with the broken webcam, was reviewed and applied
  directly by maintainer Takashi Iwai.
- Record: User-driven hardware enablement; the maintainer (who is the
  SOC/ALSA-USB lead) signed off.

**Step 3.5 — Dependencies**
- `QUIRK_FLAG_GET_SAMPLE_RATE`: introduced in `4d4dee0aefec3` ("ALSA:
  usb-audio: Introduce quirk_flags field"), present since **v5.15**.
- `QUIRK_FLAG_MIC_RES_16`: introduced in `d6e6b9218ced5` ("ALSA: usb-
  audio: Make mic volume workarounds globally applicable"), present
  since **v6.13** (verified via `git describe --contains`).
- Record: Both flags are pre-existing infrastructure. **Patch can apply
  to v6.13+ stable trees only** because of `QUIRK_FLAG_MIC_RES_16`.
  Earlier trees would need a partial backport (only
  `QUIRK_FLAG_GET_SAMPLE_RATE`) — but stable trees < 6.13 are
  increasingly fewer, and the pattern is well-precedented.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original patch discussion**
- Fetched mbox via `b4 mbox` for message-id
  `20260417010123.3080904-1-johnathan.penberthy@gmail.com`.
- Thread = 2 messages: the patch itself, then maintainer reply.
- Maintainer Takashi Iwai response: **"Applied now. Thanks."** — applied
  with zero requested changes.
- Record: Single revision (no v2/v3), no NAKs, no concerns raised,
  applied by the most senior subsystem maintainer immediately.

**Step 4.2 — Reviewers**
- To: Takashi Iwai (subsystem maintainer)
- Cc: Jaroslav Kysela (ALSA co-maintainer), linux-sound, linux-kernel
- Record: Sent to all the right people; the maintainer himself applied
  it.

**Step 4.3 — Bug report**
- No external bug report URL; the commit message itself contains the
  diagnostic info (kernel error message, test methodology).
- Record: User-driven report directly in the commit message.

**Step 4.4 — Related patches**
- Standalone single-patch submission (no series).
- Record: No dependencies.

**Step 4.5 — Stable list history**
- Not applicable; this is a brand-new patch (Apr 17, 2026) submitted to
  and applied by the ALSA maintainer.
- Record: N/A.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
- Modified data: `quirk_flags_table[]` array.
- The flag consumer functions: `snd_usb_get_sample_rate()` in
  `sound/usb/clock.c` and `volume_control_quirks()` in
  `sound/usb/mixer.c`.

**Step 5.2 — Callers**
- `snd_usb_get_sample_rate()` is called during USB audio probe/setup for
  every USB audio device that exposes a clock source — i.e., universal
  call path.
- The quirk table is consumed by `snd_usb_init_quirk_flags()` during
  `usb_audio_probe()`.
- Record: Reachable via USB device hotplug for any USB-audio device
  matching the VID:PID.

**Step 5.3 — Callees**
- Quirk lookup is a simple linear table match keyed by VID:PID.
- Effects of flags are localized to two well-understood code paths.

**Step 5.4 — Reachability**
- Trigger: plugging in a NexiGo N930W webcam — any user can do this.
- Record: 100% reachable for affected hardware owners; entirely inert
  for everyone else.

**Step 5.5 — Similar patterns**
- The very similar sibling entry `DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo
  N930AF FHD Webcam */, QUIRK_FLAG_GET_SAMPLE_RATE |
  QUIRK_FLAG_MIC_RES_16)` exists at line 2346/2347 (per Grep). The
  earlier `4a63e68a29518` ("ALSA: usb-audio: Fix microphone sound on
  Nexigo webcam.") established the precedent and was itself a stable-
  style hardware fix.
- Record: Same fix pattern used for sibling NexiGo model — strong
  precedent.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 — Buggy code in stable**
- The "code" here is the absence of a table entry; the framework that
  would honor the quirk has been present since v5.15
  (`QUIRK_FLAG_GET_SAMPLE_RATE`) and v6.13 (`QUIRK_FLAG_MIC_RES_16`).
- The webcam's broken firmware affects users on **all** stable trees
  that have the framework.
- Record: Applicable to v6.13.y, v6.16.y (LTS), and whatever later
  stable trees are active.

**Step 6.2 — Backport complications**
- Mainline context: new entry inserted between `0x339b, 0x3a07` and
  `0x413c, 0xa506`. The `0x339b` entry only exists in v6.17+. For
  v6.13.y/v6.16.y, the entry would land at the same logical sorted
  position (between `0x3255` and `0x413c`) but with slightly different
  surrounding context — trivial 3-way-merge fix-up.
- Record: Minor textual conflict possible on older stable; trivial to
  resolve. The semantics are identical.

**Step 6.3 — Related fixes already in stable**
- The sibling N930AF quirk (1bcf:2283) is in stable already; this is the
  cousin device.
- Record: Consistent with existing stable entries.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
- `sound/usb/` — USB audio driver. Criticality: **PERIPHERAL** in scope
  (specific device class), but the change is exactly the kind of thing
  routinely backported.

**Step 7.2 — Activity**
- `sound/usb/quirks.c` is actively maintained; quirk additions are
  routine and regularly land in stable.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Affected users**
- Specifically: owners of the NexiGo N930W 60fps webcam.
- The N930-series is a popular consumer webcam line; this is real-world
  hardware enablement.

**Step 8.2 — Trigger**
- Every plug-in / every microphone-use attempt.
- Unprivileged users hit it (just plugging in the device).

**Step 8.3 — Failure mode severity**
- Microphone effectively non-functional — only zero samples captured.
  Video works, audio does not.
- Severity: **HIGH for affected users** (mic completely silent). For
  everyone else: zero impact.

**Step 8.4 — Risk-benefit ratio**
- Benefit: enables a piece of consumer hardware that is otherwise broken
  on Linux.
- Risk: 2-line table entry, exact-match VID:PID, cannot affect any other
  hardware. Effectively zero regression risk.
- Record: Strongly favorable.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence compilation**
FOR backport:
- Two-line, surgical hardware quirk addition.
- Falls into the explicit "HARDWARE QUIRKS / DEVICE IDs" exception
  category that is canonical YES for stable.
- Identical flags as already-in-stable sibling N930AF entry.
- Real-world user-visible bug (silent microphone) reproduced and fixed
  by submitter.
- Applied immediately by ALSA subsystem maintainer with no changes.
- Zero regression risk for unrelated devices.
- Quirk infrastructure exists in v6.13+ stable trees (LTS v6.16, soon
  v6.17.y, etc.).

AGAINST backport:
- Patch context may need a small adjustment on older stable trees
  (Synaptics line above is only v6.17+) — but easily handled.
- Cannot apply to pre-v6.13 trees because `QUIRK_FLAG_MIC_RES_16`
  doesn't exist there — those would need either a partial backport or
  skip.

UNRESOLVED:
- None material to the decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct/tested: **YES** (author tested via quirk_alias
   before submission; same flags work for the sibling device).
2. Fixes a real bug: **YES** (silent microphone on real hardware).
3. Important: **YES** (hardware completely non-functional for audio).
4. Small/contained: **YES** (2 lines, single file).
5. No new features/APIs: **YES** (uses existing flags).
6. Applies to stable: **YES** for v6.13+; minor context adjustment may
   be needed.

**Step 9.3 — Exception category**
- **Hardware quirk / device ID addition** — always YES for stable.

**Step 9.4 — Decision: YES**

---

## Verification

- [Phase 1] Parsed tags: confirmed only Author SOB, Link, Maintainer
  SOB; no Fixes/CC stable/Reported-by tags (expected).
- [Phase 1] Body identifies concrete failure (`cannot get freq at ep
  0x84`, mic streams zeros) and confirms successful test via
  `quirk_alias=3443930d:1bcf2283` mapping.
- [Phase 2] Diff inventory: 1 file (`sound/usb/quirks.c`), +2/-0 lines,
  single `DEVICE_FLG()` entry verified by reading the patch.
- [Phase 2] Verified the new entry uses pre-existing flags
  `QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16` — not new
  infrastructure.
- [Phase 3] `git log -S "QUIRK_FLAG_MIC_RES_16" -- sound/usb/usbaudio.h`
  -> introduced in commit `d6e6b9218ced5`; `git describe --contains
  d6e6b9218ced5` -> `v6.13-rc1~123^2~14`. Confirmed available in v6.13+.
- [Phase 3] `git log -S "QUIRK_FLAG_GET_SAMPLE_RATE" --
  sound/usb/usbaudio.h` -> commit `4d4dee0aefec3`; `git describe
  --contains` -> `v5.15-rc1~150^2~95`. Confirmed v5.15+.
- [Phase 3] `git log -S "0x339b, 0x3a07"` -> commit `2cbe4ac193ed7`;
  `git describe --contains` -> `v6.17-rc5~26^2~7`. Confirms only the
  surrounding context (Synaptics line above) is v6.17-only — this only
  affects diff-context, not semantics.
- [Phase 3] Verified sibling entry `DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo
  N930AF */, QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16)` exists
  at quirks.c:2346-2347; matches pattern exactly.
- [Phase 4] `b4 mbox` retrieved 2-message thread; verified maintainer
  Takashi Iwai responded "Applied now. Thanks." with no requested
  revisions.
- [Phase 4] Confirmed `b4 am` produces single-revision patch (no v2/v3
  evolution).
- [Phase 5] Verified `QUIRK_FLAG_GET_SAMPLE_RATE` used in
  `sound/usb/clock.c:490` to short-circuit `snd_usb_get_sample_rate()`.
- [Phase 5] Verified `QUIRK_FLAG_MIC_RES_16` used in
  `sound/usb/mixer.c:1085` to set `cval->res = 16` for "Mic Capture
  Volume".
- [Phase 6] Quirk infrastructure confirmed present in v6.13+ stable
  trees; backport viable.
- [Phase 8] Failure mode confirmed: silent microphone (zero samples
  only). Severity HIGH for users with this webcam, NIL for others.
- UNVERIFIED: I did not directly test the patch against the actual
  v6.13.y/v6.16.y stable trees for context-merge cleanliness — minor
  textual adjustment may be needed but the entry's semantics will work
  in any tree with both flags defined.

This is a textbook hardware-quirk addition: a 2-line table entry that
enables a specific consumer webcam's microphone to actually work, using
already-deployed quirk infrastructure, applied directly by the subsystem
maintainer with no review concerns. It precisely matches the "device ID
/ hardware workaround" exception that is canonically backported to
stable.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 4cfa24c06fcdf..e9290920aea0e 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2415,6 +2415,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x339b, 0x3a07, /* Synaptics HONOR USB-C HEADSET */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x3443, 0x930d, /* NexiGo N930W 60fps Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x534d, 0x0021, /* MacroSilicon MS2100/MS2106 */
-- 
2.53.0

