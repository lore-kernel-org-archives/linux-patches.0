Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CED659F14B;
	Mon, 31 Aug 2026 13:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184314; cv=none; b=UoEJwXCitkaJ+HFlMEe8SDO7zg8O3FU4QGDNcGBcbMwU6cYRSE3U87M+dhAPgHZYIVrBdyf+BaWI54trWv1BEt0isYRYC4LtCNKmI4kC27oePHiCp/5Xqrewqwd2L5Knnz6GjUj31gkap5YeM8xsoJ13rR60U6h+DaL9bJwVsF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184314; c=relaxed/simple;
	bh=LHktP810xRWC/vkHHxjul/5keAOb1nr5rQQAY4YUEtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q0+qjaG6jAa43OZnERD2rM2PnHh8AXp1h42DYkBoa1IuK6LqU0Af7vGms5MOx7Cj4YqgtaoPvLeREKMygUm7R6/BamvuJOd7fOvOsbb/Gg2riY5L6ZzoWhPM5Aj7k9K+UadNqiz88yNvKJO8nL4f4m7CO/0TllmbpYRHnBsga6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HztDklDc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HztDklDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565B51F000E9;
	Mon, 31 Aug 2026 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184312;
	bh=NQR2rsT7t21uiplqPe1NUB+qpZmBOOzBGlmjxM5hO5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HztDklDc0uwbQQolBn+9glUcFlIcYIOHF9jgMMdoBa7vMUEIgQ8/n/MC6zlVnH7zZ
	 jRReMTz0FH9WKlxV+ppwNEMs7BpByR3cyAq6S7P1bb+CVVqG64jJRyrX+rYbDpEv/p
	 z6w9tWop6nMGRf3qYJpzqppBlfYaEpb2fn0ai6oFcOsxeH+cV0x2WaYV0fPfFBWdv2
	 W5cBNOTDjScM8uYdvLZN774iL9LUNRnSMYgjIDO43DB8nhVjFBN53FzWOwPmJk15tJ
	 15N+I0jlxeQdOrz2XFUKCPpXFgh42HR/OORvisztp9o5QT373kMJy/7PK2HwQvS4TR
	 9d+Thsjfscx0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Daniel C. Ribeiro" <dcoutinho.96@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless
Date: Mon, 31 Aug 2026 09:30:45 -0400
Message-ID: <20260831133314.4125787-617-sashal@kernel.org>
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

From: "Daniel C. Ribeiro" <dcoutinho.96@gmail.com>

[ Upstream commit f6d6a4147ace0c417035f65b021027c209c75190 ]

JBL Quantum650 Wireless (0ecb:2125) requires the same workaround that
was used for JBL Quantum610 and Quantum810 for limiting the sample rate.
Without it, the capture (microphone) stream fails to work.  Setting the
QUIRK_FLAG_FIXED_RATE flag, as done for the sibling models, makes both
playback and capture work correctly.

Signed-off-by: Daniel C. Ribeiro <dcoutinho.96@gmail.com>
Link: https://patch.msgid.link/20260719090037.40149-1-dcoutinho.96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA usb-audio JBL Quantum650 FIXED_RATE
Quirk

**Local tree:** `v6.18.44` (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`, Makefile `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ALSA: usb-audio]` `[Add]` — Add a USB audio quirk flag
entry for JBL Quantum650 Wireless headset.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Daniel C. Ribeiro `<dcoutinho.96@gmail.com>`
  (author)
- **Link:**
  https://patch.msgid.link/20260719090037.40149-1-dcoutinho.96@gmail.com
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA/usb-audio
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc:
  stable@vger.kernel.org
- Notable: Maintainer SOB; no syzbot or bugzilla link (unlike
  Quantum610’s bugzilla reference)

### Step 1.3: Body Analysis
**Record:**
- **Bug:** JBL Quantum650 Wireless (USB ID `0ecb:2125`) needs
  `QUIRK_FLAG_FIXED_RATE`, same as Quantum610/810.
- **Symptom:** Without it, capture (microphone) stream fails; playback
  may work but mic does not.
- **Root cause (author):** Driver tries to set sample rate on an
  endpoint that only supports a fixed rate; skipping rate-setting fixes
  both directions.
- **Version info:** None in message.

### Step 1.4: Hidden Bug Fix?
**Record:** Not disguised — this is an explicit hardware
quirk/workaround. Functionally fixes broken microphone on a specific USB
headset.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/usb/quirks.c` (+2 lines)
- **Functions:** `quirk_flags_table[]` static table only
- **Scope:** Single-file, surgical, 2-line addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Device `0ecb:2125` not in `quirk_flags_table`; no
  `QUIRK_FLAG_FIXED_RATE` at probe.
- **After:** On probe of `0ecb:2125`, `snd_usb_init_quirk_flags_table()`
  sets `QUIRK_FLAG_FIXED_RATE` on `chip->quirk_flags`.
- **Affected path:** USB audio device probe → stream open
  (`snd_usb_hw_params`) → endpoint setup
  (`snd_usb_endpoint_set_params`).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware workaround (g)
- **Mechanism:** With `QUIRK_FLAG_FIXED_RATE`,
  `snd_usb_pcm_has_fixed_rate()` returns true; `ep->fixed_rate` is set;
  `snd_usb_init_sample_rate()` is skipped in `endpoint.c` when
  `!ep->fixed_rate` is false. Without the quirk, the driver attempts
  rate changes the firmware rejects, breaking capture.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct — identical pattern to Quantum610
  (`0x205c`) and Quantum810 (`0x2069`) already in this tree.
- **Regression risk:** Very low — only affects `0ecb:2125`.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Quantum610/810 entries blame to `5d324e5159d9e` (2025-11-28
merge). `QUIRK_FLAG_FIXED_RATE` infrastructure predates 6.18 (Quantum610
quirk upstream since 2023, backported as `36dba3f4cd36c`). Buggy
behavior (missing quirk for 650) exists whenever this hardware is used
without the entry.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related Changes
**Record:**
- Upstream commit: `f6d6a4147ace0` (mainline, Takashi Iwai, 2026-07-19)
- Stable-format commit: `5a8dda89e6e59` (same patch with upstream
  marker)
- Related: `36dba3f4cd36c` added Quantum610 quirk (backported to stable
  previously)
- Standalone v1 patch; not part of a series

### Step 3.4: Author Context
**Record:** Daniel C. Ribeiro — user reporter/contributor. Takashi Iwai
(maintainer) committed to mainline. Pattern matches maintainer-handled
device quirk additions.

### Step 3.5: Dependencies
**Record:** No dependencies. Requires only existing
`QUIRK_FLAG_FIXED_RATE` flag and `quirk_flags_table` mechanism — both
present in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260719090037.40149-1-dcoutinho.96@gmail.com
  (via `b4 dig -c f6d6a4147ace0`)
- **Revisions:** v1 only (`b4 dig -a`)
- **Reviewer feedback:** Takashi Iwai replied “Applied now. Thanks.”
- **Stable nominations:** None in thread
- **NAKs/concerns:** None

### Step 4.2: Reviewers
**Record:** (`b4 dig -w`) CC'd: Takashi Iwai, Jaroslav Kysela, linux-
sound@vger.kernel.org, linux-kernel@vger.kernel.org. Appropriate
maintainers included.

### Step 4.3: Bug Report
**Record:** No external bug report link. Author-reported hardware issue
with clear reproduction (mic fails without quirk, works with it).
Quantum610 had bugzilla #216798; Quantum650 does not.

### Step 4.4: Related Patches
**Record:** Same pattern as Quantum610/810 quirks. No other patches in
series required.

### Step 4.5: Stable List
**Record:** Not searched separately; no stable discussion found in patch
thread. WebFetch to lore blocked by bot protection; `b4 dig -m`
succeeded.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `quirk_flags_table[]`, `snd_usb_init_quirk_flags_table()`,
`snd_usb_pcm_has_fixed_rate()`, `snd_usb_hw_params()`,
`snd_usb_endpoint_set_params()`.

### Step 5.2: Callers
**Record:** `snd_usb_init_quirk_flags_table()` called from
`snd_usb_init_quirk_flags()` in `card.c` during USB audio probe
(`snd_usb_audio_probe` path). Every USB audio device probes through this
path when `CONFIG_SND_USB_AUDIO` is enabled.

### Step 5.3: Callees
**Record:** Table lookup sets `chip->quirk_flags`; downstream
`snd_usb_pcm_has_fixed_rate()` gates `fixed_rate` on endpoints;
`snd_usb_init_sample_rate()` skipped when `ep->fixed_rate` is true.

### Step 5.4: Reachability
**Record:** Triggered when user plugs in JBL Quantum650 Wireless
(`0ecb:2125`) and opens a capture stream. Reachable from normal
userspace audio use (PulseAudio/PipeWire/ALSA). No privileges required
beyond device access.

### Step 5.5: Similar Patterns
**Record:** Quantum610 (`0x205c`) and Quantum810 (`0x2069`) use
identical `QUIRK_FLAG_FIXED_RATE` in the same table at lines 2275–2278
of this tree’s `quirks.c`.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `0x0ecb:0x2125` is absent from `quirk_flags_table`.
Sibling entries for 610/810 exist. `QUIRK_FLAG_FIXED_RATE` exists in
`usbaudio.h`, `pcm.c`, `quirks.c`. Commit `f6d6a4147ace0` is **not** an
ancestor of HEAD (`merge-base --is-ancestor` exit code 1).

### Step 6.2: Backport Complications
**Record:** Upstream patch context is at line ~2346; local file has
entries at lines 2275–2278. `git apply --check` fails on line offset
only. Insertion point is unambiguous — two lines between Quantum610 and
Quantum810 entries. **Trivial manual adaptation.**

### Step 6.3: Related Fixes Already Present?
**Record:** Quantum610 and Quantum810 quirks present. No existing fix
for `0x2125`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `sound/usb` — ALSA USB audio driver. **Criticality:
IMPORTANT** (common desktop/laptop USB headset path, not core kernel).

### Step 7.2: Activity
**Record:** `quirks.c` actively maintained in 6.18.y (recent Scarlett,
NeuralDSP, MOONDROP quirk commits in log).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of JBL Quantum650 Wireless USB headset with
`CONFIG_SND_USB_AUDIO`. Driver-specific, not universal.

### Step 8.2: Trigger Conditions
**Record:** Plug in headset, open microphone/capture stream. Common
usage scenario for headset owners. Unprivileged users with audio device
access can trigger.

### Step 8.3: Failure Severity
**Record:** **MEDIUM** — microphone capture non-functional (functional
hardware breakage). No kernel crash, panic, corruption, or security
issue reported. Playback may work; capture fails.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores full headset functionality for Quantum650
  owners; proven pattern from sibling models.
- **Risk:** Minimal — 2-line table entry, device-specific.
- **Ratio:** Strong benefit for affected users, negligible risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Hardware quirk exception category (explicitly stable-appropriate)
- Real user-visible bug (broken microphone)
- 2-line, surgical, same pattern as already-backported Quantum610 quirk
- Reviewed and applied by subsystem maintainer (Takashi Iwai)
- All infrastructure present in 6.18.44 tree
- Standalone, no dependencies
- Low regression risk (device-ID-specific)

**AGAINST backport:**
- Not a crash/security/corruption issue (functional breakage only)
- Affects narrow hardware population
- Patch context line numbers differ (trivial adaptation needed)
- No explicit stable nomination or bugzilla report

**Unresolved:** None material to the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — identical to proven sibling
   quirks; maintainer applied.
2. Fixes real bug affecting users? **PASS** — broken mic capture on
   Quantum650.
3. Important issue? **PASS** (hardware functionality) — not crash-level,
   but real broken hardware; quirk category is standard stable material.
4. Small and contained? **PASS** — 2 lines, one file.
5. No new features or APIs? **PASS** — table entry only.
6. Can apply to local tree? **PASS** — trivial insert between existing
   entries (minor line offset).

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — USB audio device ID with
existing `QUIRK_FLAG_FIXED_RATE` flag.

### Step 9.4: Decision Rationale

This commit adds a device-specific quirk for the JBL Quantum650 Wireless
headset, mirroring fixes already present for Quantum610 and Quantum810
in this 6.18.44 tree. Without it, microphone capture fails because the
driver incorrectly attempts to set the sample rate on a fixed-rate
endpoint. The fix is minimal, maintainer-reviewed, uses existing
infrastructure, and matches a well-established stable backport pattern
(Quantum610 was previously backported similarly). The patch does not
apply verbatim due to line-number drift but requires only a trivial two-
line insertion at the obvious location between sibling entries.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and `git show f6d6a4147ace0`
- **[Phase 2]** Diff analysis: +2 lines in `quirk_flags_table[]`; read
  `pcm.c:178-204`, `pcm.c:482-576`, `endpoint.c:792-844`,
  `endpoint.c:1430-1435`, `usbaudio.h:217-219`
- **[Phase 3]** `git blame` lines 2270-2285: Quantum610/810 from
  `5d324e5159d9e`; `git show 36dba3f4cd36c` (Quantum610 stable
  backport); `merge-base --is-ancestor f6d6a4147ace0 HEAD` → exit 1 (not
  in tree)
- **[Phase 4]** `b4 dig -c f6d6a4147ace0`: found thread; `b4 dig -w`:
  maintainers CC'd; `b4 dig -a`: v1 only; `b4 dig -m /tmp/jbl650.mbox`:
  maintainer “Applied now. Thanks.”
- **[Phase 5]** `grep snd_usb_init_quirk_flags_table`: called from
  `card.c:728`; traced `QUIRK_FLAG_FIXED_RATE` usage in `pcm.c`,
  `endpoint.c`, `implicit.c`
- **[Phase 6]** `git describe HEAD`: v6.18.44; `grep 0x2125
  sound/usb/quirks.c`: not present; sibling entries at 2275-2278
  confirmed; `git apply --check` on upstream diff: fails on line offset
  only
- **[Phase 7]** Subsystem: sound/usb; recent `quirks.c` activity
  confirmed via `git log --oneline -20 -- sound/usb/quirks.c`
- **[Phase 8]** Impact: Quantum650 headset users; trigger on capture
  stream open; severity MEDIUM (functional)

---

**YES**The history search for `0x2125` finished: that USB ID does not
appear anywhere in `sound/usb/quirks.c` in this tree. The only close
hits were unrelated files (e.g. `drivers/scsi/qla2xxx` debug strings),
so the Quantum650 quirk is genuinely missing here.

That matches the earlier analysis: this is a 2-line hardware quirk
addition (same `QUIRK_FLAG_FIXED_RATE` pattern as the Quantum610/810
entries already in `v6.18.44`), and it should be backported.

**YES**The ancestor check finished: `f6d6a4147ace0` (the upstream
Quantum650 quirk commit) is **not** in this tree’s HEAD (`merge-base
--is-ancestor` returned exit code 1). The fix still needs to be
backported here.The Quantum610 history search finished. In this tree,
the `0x0ecb:0x205c` entry first shows up via the `usb-6.18-rc8` merge
(`5d324e5159d9e`, 2025-11-28); `git blame` points the Quantum610/810
`QUIRK_FLAG_FIXED_RATE` lines at that merge.

The original upstream quirk was added earlier (`36dba3f4cd36c` /
`dfd5fe19db7dc`, 2023). So the infrastructure and sibling quirks are
already here — only the Quantum650 (`0x2125`) entry is missing.

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index a1bdb77843448..a06fb05e6dcd1 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2274,6 +2274,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
+	DEVICE_FLG(0x0ecb, 0x2125, /* JBL Quantum650 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
-- 
2.53.0

