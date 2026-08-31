Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B1480331;
	Mon, 31 Aug 2026 13:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183470; cv=none; b=k9JkIpX+eHkJNfhfTHFbd9cHvAKJeLWvybpDalSdn7963xrBIPJkvBwYeZB9Fx5i698dTt4F0meenn6NgNZULyMLN/ZWt/669wvcaxGG8kxHKmuvTganj8A9mtAx4vGTI2x1AFK1NGCX1J7P5Zv0iKiFsh0AP0uBCc62DFsb05o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183470; c=relaxed/simple;
	bh=yB0y6x/eG74bg79zAmssU2s9XyWvKhus9LTTQi5ZpAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqSzfiqZibCz1Il2FAL6Abspj2+n9vZ0u0kzPmtuUQ4EZEpS1I2xVeDux6cXaZsKn/9dZGSjvvqo1+LpHo5/v0LS/u6uAzMN2g15CUj3javzAo2OxRKN/Q2gsBixyixYhDDnRKJ3ODFoxTGLAbkh624CegsIXV4LVnJ3vQyRMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgLtRwd7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgLtRwd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC71A1F00A3E;
	Mon, 31 Aug 2026 13:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183467;
	bh=cgXBzuGzHeoV2UauYqlOSAfeY3nkeCRzQGxYLiIDNnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgLtRwd7i/LPBlUnivdUwipDqCz45cFHPggqOAQ2O24n0PiSuBNqXuKZ4yWpssAUp
	 C7TEQp7qGXu5ZAiKxVK5K/VmrkpGBb02XqKFs5nBGnGgjxnOg8zl04eay01C/9q8md
	 ASS9sWsYplWA673A/1EZG/8F/jE7KAcUh2ProAeeTmCyFW04iisDuyYll89070o5fb
	 AQlPiZqWj/N6SuHRH92Ni3q423tgfah6WxdZ5TARbzT4d71mo+NOKcpLw3eHEBPJps
	 VEosCW6HjF2pvf2iKqTAUYN+oJZeYasp69jMX+93mi5SUmPrP8T0nZt6bLWOiiQe6F
	 ksz0ylWlCmWAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: usb-audio: Add quirk flags for SC13A
Date: Mon, 31 Aug 2026 09:22:21 -0400
Message-ID: <20260831133314.4125787-113-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ai Chao <aichao@kylinos.cn>

[ Upstream commit 8956950dab22fbaefe92ca1980728165c5da793d ]

The SC13A ( VID 0x1ff7, PID 0x0f81) not support reading the current
sample rate and results in an error message printed to kmsg. Set
QUIRK_FLAG_GET_SAMPLE_RATE to skip the sample rate check.

Quirky device sample:
  usb 3-5.2.4.1: new high-speed USB device number 11 using xhci_hcd
  usb 3-5.2.4.1: New USB device found, idVendor=1ff7, idProduct=0f81
  usb 3-5.2.4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 3-5.2.4.1: Product: SC13A
  usb 3-5.2.4.1: Manufacturer: Linux Foundation
  usb 3-5.2.4.1: SerialNumber: 000002
  usb 3-5.2.4.1: Found UVC 1.50 device SC13A (1ff7:0f81)
  usb 3-5.2.4.1: 3:1: cannot get freq at ep 0x86
  usb 3-5.2.4.1: Warning! Unlikely big volume range (=4096),
    cval->res is probably wrong.
  usb 3-5.2.4.1: [5] FU [Mic Capture Volume] ch = 1, val = 0/4096/1
  usbcore: registered new interface driver snd-usb-audio
  usb 3-5.2.4.1: 3:1: cannot get freq at ep 0x86
  usb 3-5.2.4.1: 3:1: cannot get freq at ep 0x86

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Link: https://patch.msgid.link/20260617025234.3344935-1-aichao@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: usb-audio: Add quirk flags for SC13A

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: usb-audio]` `[Add]` — Add quirk flags for SC13A USB
webcam (VID 0x1ff7, PID 0x0f81).

### Step 1.2: Parse all commit message tags
**Record:**
- **Link:**
  `https://patch.msgid.link/20260617025234.3344935-1-aichao@kylinos.cn`
- **Signed-off-by:** Ai Chao `<aichao@kylinos.cn>` (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer,
  committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer sign-off from Takashi Iwai; no syzbot or multi-
  reporter signals

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** SC13A webcam does not support reading the current sample rate
  via USB audio class GET_CUR.
- **Symptom:** Repeated kernel messages: `cannot get freq at ep 0x86`
  during probe and audio setup.
- **Root cause (author):** Device firmware does not implement sample-
  rate readback; driver still attempts verification after SET.
- **Fix approach:** Set `QUIRK_FLAG_GET_SAMPLE_RATE` to skip the
  readback check.
- **Evidence:** Full dmesg excerpt showing UVC detection, volume-range
  warning, successful `snd-usb-audio` registration, and repeated freq
  errors.
- **Version info:** None stated in the message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not a hidden crash/leak/race fix. This is an explicit
**hardware quirk** entry — a well-established stable category. The
underlying code path already tolerates read failure (returns 0), so the
primary user-visible issue is **repeated error logging** and
**unnecessary failing USB control transfers**, not a kernel oops.
Similar webcam quirks (e.g. NexiGo N930AF) addressed the same `cannot
get freq` pattern and were treated as real hardware compatibility fixes.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `sound/usb/quirks.c` only (+2 lines)
- **Functions modified:** None; only `quirk_flags_table[]` static data
- **Scope:** Single-file, surgical hardware-quirk table addition

### Step 2.2: Code flow change
**Record:**
- **Before:** SC13A (1ff7:0f81) not in `quirk_flags_table[]`;
  `chip->quirk_flags` lacks `QUIRK_FLAG_GET_SAMPLE_RATE` at probe.
- **After:** Device matched at probe via
  `snd_usb_init_quirk_flags_table()` → flag set → `set_sample_rate_v1()`
  skips GET_CUR after SET.
- **Affected path:** USB audio probe (`stream.c`) and runtime sample-
  rate changes (`endpoint.c`), normal UAC1 devices with sample-rate
  control.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround (quirk table entry)
- **Mechanism:** After `UAC_SET_CUR` for sample rate,
  `set_sample_rate_v1()` in `clock.c` normally issues `UAC_GET_CUR` to
  verify. SC13A firmware rejects GET; driver logs `dev_err()` up to 3
  times per endpoint (`sample_rate_read_error` counter), then stops.
  Quirk bypasses the unsupported GET entirely.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — identical pattern to ~30 existing
  `QUIRK_FLAG_GET_SAMPLE_RATE` entries in the same table (e.g.
  0x1bcf:0x2281/0x2283 webcams right at the insertion point).
- **Minimal:** 2 lines, no logic changes.
- **Regression risk:** Very low — flag only affects post-SET
  verification read, not rate setting itself.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** No line changes to logic — only new table entry. Related
verification code in `clock.c:488-505` dates to 2015 (Joe Turner);
`QUIRK_FLAG_GET_SAMPLE_RATE` check added in `4d4dee0aefec3` (Takashi
Iwai, 2021). Long-standing infrastructure.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File history for related changes
**Record:** Recent `quirks.c` commits are similar quirk-flag
additions/fixes (`f4e23e661a259`, `66b315279b887`, `908dd5faf8169`).
Precedent commit `4a63e68a29518` ("Fix microphone sound on Nexigo
webcam") added `QUIRK_FLAG_GET_SAMPLE_RATE` for 0x1bcf:0x2283 with
nearly identical dmesg (`cannot get freq at ep 0x86`). Standalone one-
patch fix, not part of a series.

### Step 3.4: Author's other commits
**Record:** Ai Chao has ACPI/ASoC/platform commits in this tree; not a
regular ALSA contributor, but patch carries Takashi Iwai maintainer SOB.

### Step 3.5: Prerequisites
**Record:** Requires `quirk_flags_table[]`,
`QUIRK_FLAG_GET_SAMPLE_RATE`, and `snd_usb_init_quirk_flags_table()` —
all present (`git merge-base --is-ancestor 4d4dee0aefec3 HEAD` → YES).
No dependencies on other commits. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c` could not run — commit hash not in local tree.
Lore/patch.msgid.link returned 403/Anubis bot protection.
**UNVERIFIED:** full mailing-list review thread and any stable
nominations.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** (`b4 dig -w` unavailable). Commit message
shows Takashi Iwai as committer SOB (ALSA/usb-audio maintainer).

### Step 4.3: Bug report
**Record:** Commit body includes author's dmesg as reproduction
evidence. No external bugzilla/syzbot link. Severity from reporter:
kernel log noise on device plug-in; driver still binds.

### Step 4.4: Related patches/series
**Record:** Standalone quirk addition; not part of a multi-patch series.

### Step 4.5: Stable mailing list
**Record:** **UNVERIFIED** — lore search blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No functions modified. Affected at runtime:
`snd_usb_init_quirk_flags_table()`, `set_sample_rate_v1()`,
`snd_usb_init_sample_rate()`.

### Step 5.2: Callers
**Record:**
- `snd_usb_init_quirk_flags_table()` called from `card.c:728` during USB
  audio chip init.
- `snd_usb_init_sample_rate()` called from `stream.c:1259`
  (probe/interface setup) and `endpoint.c:1431` (runtime stream rate
  change).
- Common path: every USB audio device probe; SC13A users hit this on
  plug-in.

### Step 5.3: Callees
**Record:** Quirk setup sets `chip->quirk_flags`; rate path uses
`snd_usb_ctl_msg()` for USB class control transfers.

### Step 5.4: Call chain / reachability
**Record:** USB device plug-in → `snd_usb_audio_probe()` → quirk table
lookup → later `snd_usb_init_sample_rate()` → without quirk, failing GET
logged. Triggered by attaching hardware; no special privileges needed
beyond having the device.

### Step 5.5: Similar patterns
**Record:** Many identical entries in `quirk_flags_table[]`, including
adjacent webcam entries at 0x1bcf:0x2281 and 0x1bcf:0x2283 with the same
flag. Documented in `usbaudio.h:171-173`: *"Skip reading sample rate for
devices, as some devices behave inconsistently or return error"*.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does buggy code exist?
**Record:** **YES.** `QUIRK_FLAG_GET_SAMPLE_RATE` mechanism fully
present. SC13A entry **absent** (`grep 0x1ff7/0x0f81` → no matches).
Without this patch, 6.18.44 users with SC13A get the described errors.
Bug is in long-standing sample-rate verification code, not recently
introduced.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Insertion point verified between
existing entries:

```2335:2340:sound/usb/quirks.c
        DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
                   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
        DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
                   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
        DEVICE_FLG(0x2040, 0x7200, /* Hauppauge HVR-950Q */
```

### Step 6.3: Related fixes already present?
**Record:** No existing SC13A entry or equivalent fix (`git log
--grep=SC13A` → empty).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/usb/` — ALSA USB audio driver. **IMPORTANT** (common
USB webcam/audio hardware; not core kernel, but widely used).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; frequent quirk-table updates in
`quirks.c` (5 commits in recent history on that file alone).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of SC13A USB webcam (1ff7:0f81) — hardware-specific,
but a real commercial device (UVC + USB audio composite).

### Step 8.2: Trigger conditions
**Record:** Device plug-in and audio interface initialization; occurs on
every attach. Common for webcam users. Unprivileged physical access (USB
attach).

### Step 8.3: Failure mode severity
**Record:** Without fix: repeated `dev_err()` kernel messages (`cannot
get freq at ep 0x86`), unnecessary USB control traffic; audio driver
still registers and rate-set path returns 0 on read failure. **Severity:
LOW–MEDIUM** (log spam / suboptimal device handling, not crash or
corruption). With fix: clean probe, no spurious errors.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables correct handling for SC13A; eliminates error
  spam; matches established webcam quirk pattern.
- **Risk:** Minimal — 2-line table entry using existing, well-tested
  flag.
- **Ratio:** Low risk, modest but real benefit for affected hardware
  owners.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Hardware quirk — explicit stable exception category
- 2-line, surgical, obviously correct
- Uses existing `QUIRK_FLAG_GET_SAMPLE_RATE` infrastructure present
  since 2021
- Maintainer (Takashi Iwai) sign-off
- Identical pattern to NexiGo/HD webcam quirks already in tree
- Clean apply to 6.18.44 verified
- Fixes real device misbehavior (unsupported USB control op + kmsg
  errors)

**AGAINST backport:**
- Does not fix crash, data corruption, deadlock, or security issue
- Audio may function without the quirk (verification read failure is
  tolerated)
- No syzbot/user bugzilla reports; impact limited to SC13A owners

**UNRESOLVED:**
- Full lore review thread inaccessible
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard quirk pattern;
   maintainer SOB; dmesg evidence in commit message.
2. Fixes a real bug affecting users? **PASS** — real hardware
   incompatibility with repeated kernel errors on attach.
3. Important issue? **PASS (borderline)** — not CRITICAL severity, but
   hardware quirk fixes are accepted stable material per project
   practice; prevents user-visible malfunction/noise on a supported
   device class.
4. Small and contained? **PASS** — 2 lines, one file.
5. No new features or APIs? **PASS** — device ID + existing quirk flag
   only.
6. Can apply to local tree? **PASS** — all prerequisites present;
   insertion point matches.

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — adding
`QUIRK_FLAG_GET_SAMPLE_RATE` for a broken USB audio device. This is
explicitly listed as automatic YES material in stable guidelines.

### Step 9.4: Decision rationale
For **linux-6.18.y** specifically: the quirk infrastructure exists, the
SC13A entry is missing, and the patch applies cleanly. This is textbook
USB-audio hardware quirk material — the same class of fix as existing
webcam entries at 0x1bcf:0x2281/0x2283. While severity is lower than a
crash fix, stable trees routinely carry such device-specific quirk
additions, especially when signed off by the subsystem maintainer and
using established flags.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; identified hardware quirk
  intent and dmesg symptoms.
- **[Phase 2]** Diff: +2 lines in `sound/usb/quirks.c`; verified
  `QUIRK_FLAG_GET_SAMPLE_RATE` behavior in `clock.c:488-505`.
- **[Phase 3]** `git blame clock.c:488-505`: verification code from
  2015; quirk flag from `4d4dee0aefec3`. `git log --grep=SC13A`: empty.
  `4a63e68a29518`: similar Nexigo webcam quirk precedent. `git merge-
  base --is-ancestor 4d4dee0aefec3 HEAD`: YES.
- **[Phase 4]** `b4 dig`: failed (no commit in tree).
  Lore/patch.msgid.link/curl: 403/bot-blocked. **UNVERIFIED:** review
  thread, stable nominations.
- **[Phase 5]** `grep snd_usb_init_sample_rate`: callers in
  `stream.c:1259`, `endpoint.c:1431`, `quirks.c:206`. `grep
  snd_usb_init_quirk_flags_table`: `card.c:728`.
- **[Phase 6]** `git describe HEAD`: v6.18.44. `grep 0x1ff7/0x0f81`: not
  present. Insertion point at lines 2335-2339 confirmed. Clean apply
  expected.
- **[Phase 7]** Subsystem: sound/usb, actively maintained.
- **[Phase 8]** Failure mode: kmsg errors, not crash; severity
  LOW–MEDIUM; benefit modest, risk minimal.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 3d81b003a5109..c5b06374044da 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2336,6 +2336,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
+	DEVICE_FLG(0x1ff7, 0x0f81, /* SC13A Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2040, 0x7200, /* Hauppauge HVR-950Q */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x2040, 0x7201, /* Hauppauge HVR-950Q-MXL */
-- 
2.53.0

