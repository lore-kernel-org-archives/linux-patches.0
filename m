Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E661C3C3C1C;
	Wed, 20 May 2026 11:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779275998; cv=none; b=OjRR7nOCdfu2zc7BhVk6Qnw3JflON3wjfQgqj5l+lalFtsKJyzS8uic/iCNidDj8JSMBEi4JjOW9Zdr474C5OLOA3AEzvYPa1It221neFltWykxXaTU4+bI+a3zJt+pa/mKfNuOLGBZu5VSyO/mWKGXYOfFGcHVmOR4c58XYhOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779275998; c=relaxed/simple;
	bh=CnTY8TCe4XhDblSh7LHCw5vJCcGfjIK7cE3NRSFm09E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eunwtrglLPyfkRRB8E/kQO3D4EpNTkbw+kEeWCJpBSHWOLkxyI0B8shDq3Dzs96vAGhdBC7ov8igUhMVRlU2ZcIznWQdSVQ1aouRJPKB7zlDqj6K7vsEN4m4cps100kL/ji/x1AUUsMzixJT2d835dypbqjUqw6RC9dbJPK+l6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oz+1FkNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oz+1FkNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07851F00897;
	Wed, 20 May 2026 11:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779275993;
	bh=2EmGlUeCTz0s9sqrvcVXILR/f6rFvrw/kcITTMO5Niw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oz+1FkNVlgES5VGnWZEWoH1eaLZ6e3ERcEgsldtbq3iG4VBv/bzLn57BACjfG6Ybt
	 tNwTDvWfkNfANItuZQZvjeSmLWW2jP3AQ7K8jO1d4SThPgCHvuON1VnPp+SHrf1DYa
	 4xNt3CRLHqY8ApwnipoCNkiN5KFLDJAEG1/ej4937Ml/41eST+WE4drTWbTrgID/YU
	 j5f1L6YhVRHUaE7+j3xuAhnv2GAuIgGMWmsXwgmOe572HphDCUln9MG83g+U1JmVbP
	 m548sHZvPJu+a9vyZKeJQAmABOiaaTVEl8Esro32wFDu5/wUeyooNO5pJ8YyXWfGF+
	 9lyF6Y8g62ltA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] ALSA: usb-audio: Add iface reset and delay quirk for TTGK Technology USB-C Audio
Date: Wed, 20 May 2026 07:18:38 -0400
Message-ID: <20260520111944.3424570-6-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit 2149c011510cbdcf183a13b26756e4a02071f0f2 ]

Setting up the interface when suspended/resumeing fail on this card.
Adding a reset and delay quirk will eliminate this problem.

usb 1-1: new full-speed USB device number 2 using xhci-hcd
usb 1-1: New USB device found, idVendor=3302, idProduct=17c2
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: USB-C Audio
usb 1-1: Manufacturer: TTGK Technology
usb 1-1: SerialNumber: 170120210706

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB621720E4E8F99A42E162FD51D23D2@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record: Subsystem is `ALSA: usb-audio`; action verb is `Add`; intent is
adding an interface reset plus interface delay quirk for TTGK Technology
USB-C Audio `3302:17c2`.

Record: Tags present in the provided commit/message: `Signed-off-by:
Lianqin Hu <hulianqin@vivo.com>`, `Signed-off-by: Takashi Iwai
<tiwai@suse.de>`, `Link: https://patch.msgid.link/TYUPR06MB621720E4E8F99
A42E162FD51D23D2@TYUPR06MB6217.apcprd06.prod.outlook.com`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc: stable`.

Record: Commit body describes a real device-specific failure: interface
setup fails when the card is suspended/resumed. The included USB
enumeration log verifies the target device ID `3302:17c2`, product
`USB-C Audio`, manufacturer `TTGK Technology`.

Record: This is not a hidden cleanup fix; it is an explicit hardware
workaround/quirk for a suspend/resume interface setup failure.

## Phase 2: Diff Analysis
Record: One file changed: `sound/usb/quirks.c`, 2 insertions. Modified
area: `quirk_flags_table[]`. Scope: single-file surgical hardware quirk.

Record: Before: device `3302:17c2` had no built-in quirk flags. After:
it gets `QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY`.

Record: Bug category is hardware workaround. Verified semantics:
`QUIRK_FLAG_IFACE_DELAY` adds 50 ms after `usb_set_interface()` in
`endpoint_set_interface()`, and `QUIRK_FLAG_FORCE_IFACE_RESET` marks
playback endpoints for re-prepare/interface setup after stop/restart.

Record: Fix quality is high: exact VID/PID match, existing flag
mechanisms, no new API, no broad behavior change. Regression risk is
very low and limited to this USB device ID.

## Phase 3: Git History Investigation
Record: `git blame` around the insertion area shows the quirk table is
established and contains many adjacent hardware-specific entries; nearby
entries are from existing ALSA USB-audio quirk commits.

Record: No `Fixes:` tag, so no introducing commit to follow.

Record: Recent file history shows many similar stable-style quirks,
including `ALSA: usb-audio: Add iface reset and delay quirk for AB17X
USB Audio`, `SPACETOUCH USB Audio`, `AB13X USB Audio`, and `GHW-123P`.

Record: Author history under `sound/usb` shows Lianqin Hu has submitted
multiple similar USB-audio delay/reset quirk patches.

Record: Dependency check: `QUIRK_FLAG_IFACE_DELAY` exists since
v5.15-era code, but `QUIRK_FLAG_FORCE_IFACE_RESET` appears from
v6.2-rc1. Therefore v6.6+ style trees have the required infrastructure;
v6.1/v5.15 do not have the reset flag without additional
prerequisite/adaptation.

## Phase 4: Mailing List And External Research
Record: No local commit hash was found on `master`, `sound-next`, or
`all-next`, so `b4 dig -c <commit>` could not be used. I used the
provided `Link:` with `b4 am`/`b4 mbox`.

Record: `b4 am` found one patch and a two-message thread. `b4 am -c`
checked for newer revisions and did not report a newer version.

Record: Full thread shows Takashi Iwai replied: “Applied now. Thanks.”
No objections, NAKs, or risk concerns were present in the fetched
thread.

Record: Original recipients included ALSA maintainers/lists: Jaroslav
Kysela, Takashi Iwai, `linux-sound@vger.kernel.org`, and `linux-
kernel@vger.kernel.org`.

Record: Stable-specific web search did not find usable stable-list
discussion; lore web pages were blocked by Anubis, and search results
did not reveal a stable objection.

## Phase 5: Code Semantic Analysis
Record: Key affected function/data is `quirk_flags_table[]`; consumers
are `snd_usb_init_quirk_flags_table()`, `endpoint_set_interface()`,
`snd_usb_endpoint_stop()`, and `snd_usb_endpoint_prepare()`.

Record: Callers: `usb_audio_probe()` creates the USB audio card, calls
`snd_usb_audio_create()`, which initializes quirk flags from the built-
in table. PCM prepare paths call `snd_usb_endpoint_prepare()`, and PCM
stop paths call `snd_usb_endpoint_stop()`.

Record: Callees/effects: `endpoint_set_interface()` calls
`usb_set_interface()` and then delays if `QUIRK_FLAG_IFACE_DELAY` is
set. `snd_usb_endpoint_stop()` sets `need_prepare`/`need_setup` for
playback endpoints if `QUIRK_FLAG_FORCE_IFACE_RESET` is set.

Record: Reachability is verified through USB device probe and normal
ALSA PCM suspend/resume/stream restart paths for this hardware.

Record: Similar patterns exist in the same table for several devices
using the same two flags, so this follows established local practice.

## Phase 6: Stable Tree Analysis
Record: The generic USB-audio quirk table exists in v5.15, v6.1, v6.6,
v6.12, and v7.0 tags checked.

Record: Required reset-flag infrastructure exists in v6.6, v6.12, and
v7.0; it is absent in v6.1/v5.15 tags checked.

Record: Textual `git apply --check` failed on v6.6, v6.12, v6.1, and
current 7.0 checkout because nearby table context differs. `git apply
--check --3way` on current 7.0 succeeded cleanly; representative
release-tag worktrees reported conflicts with three-way check, so older
backports need minor context adjustment.

Record: No related `TTGK` or `3302:17c2` entry exists locally under
`sound/usb`.

## Phase 7: Subsystem Context
Record: Subsystem is ALSA USB audio, an important driver subsystem for
USB audio peripherals.

Record: Activity level is high: recent history in `sound/usb/quirks.c`
contains multiple hardware quirk additions and USB-audio behavior fixes.

## Phase 8: Impact And Risk
Record: Affected users are owners of TTGK Technology USB-C Audio device
`3302:17c2`.

Record: Trigger condition is using this device across suspend/resume or
stream restart/interface setup paths. The commit message explicitly
reports interface setup failure in that scenario.

Record: Failure mode is device malfunction after suspend/resume, not a
kernel crash. Severity is medium for the kernel generally but high for
affected hardware users because audio can fail after power-management
transitions.

Record: Benefit is high for affected hardware and low-risk for everyone
else. Risk is very low because the change is an exact VID/PID quirk
using existing flags.

## Phase 9: Final Synthesis
Record: Evidence for backporting: real hardware failure, exact device
ID, standard quirk exception category, two-line contained patch,
existing flag behavior, maintainer applied it, no API/feature expansion
beyond a device-specific workaround.

Record: Evidence against: no external bug report or Tested-by tag found;
exact mail patch needs context adjustment for stable trees; v6.1/v5.15
lack `QUIRK_FLAG_FORCE_IFACE_RESET`, so those trees would need a
deliberate adaptation or prerequisite decision.

Record: Stable rules: obviously correct: yes; fixes a real user-visible
hardware bug: yes; important enough for affected users: yes; small and
contained: yes; no new API/feature: yes; applies cleanly: not textually
everywhere, but trivial/minor for v6.6+ style trees.

Record: Exception category: hardware quirk/workaround for a broken USB
audio device. This is a standard stable-acceptable category.

## Verification
- [Phase 1] Parsed provided subject, tags, commit body, and USB
  enumeration log.
- [Phase 2] Verified diff is two inserted lines in `sound/usb/quirks.c`.
- [Phase 2/5] Verified `QUIRK_FLAG_IFACE_DELAY` and
  `QUIRK_FLAG_FORCE_IFACE_RESET` definitions and consumers in
  `sound/usb/usbaudio.h` and `sound/usb/endpoint.c`.
- [Phase 3] Ran `git blame` around the table insertion area and recent
  `git log` for `sound/usb/quirks.c`.
- [Phase 3] Verified similar reset/delay quirk commits and Lianqin Hu’s
  related ALSA USB-audio quirk history.
- [Phase 4] `b4 am` fetched the patch from the provided message-id link;
  `b4 mbox` fetched the two-message thread.
- [Phase 4] Verified Takashi Iwai’s maintainer reply: “Applied now.
  Thanks.”
- [Phase 4] `b4 am -c` did not report newer revisions.
- [Phase 5] Traced quirk flag initialization from `usb_audio_probe()` to
  `snd_usb_audio_create()` to `snd_usb_init_quirk_flags_table()`.
- [Phase 6] Checked v5.15, v6.1, v6.6, v6.12, and v7.0 tag contents for
  flag availability.
- [Phase 6] Verified `FORCE_IFACE_RESET` absent in v6.1/v5.15 and
  present in v6.6+.
- [Phase 6] Verified plain apply fails due context; current 7.0 three-
  way apply check succeeds without modifying the worktree.
- UNVERIFIED: exact upstream commit SHA, because the commit was not
  present on checked local branches and web search did not find it.

This should be backported to stable trees that already contain the
quirk-flag infrastructure, especially v6.6+ style trees. For older
v6.1/v5.15 trees, it should not be applied verbatim unless maintainers
choose a small adapted backport or also carry the reset-flag
infrastructure.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 2ffc69b57ab49..1428a0b620d37 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2417,6 +2417,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x3255, 0x0000, /* Luxman D-10X */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
+	DEVICE_FLG(0x3302, 0x17c2, /* TTGK Technology USB-C Audio */
+		   QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x339b, 0x3a07, /* Synaptics HONOR USB-C HEADSET */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
-- 
2.53.0

