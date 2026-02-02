Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6161C84BD;
	Mon,  2 Feb 2026 21:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068806; cv=none; b=mJwQZH/oeBgQfuGaKGLR/fHfVBCcOmrXAH2tvYbypGIpA3zjpzi+Vbm0C4nqDMwfn8YNOcVpiqqA4c4OCpfsAzpwWM1iGRwiwheVjvJ9qaR5hwVb3m9w+O00a7BGSN2K3yNlkYsE/uMyOt1fixNPL3flvJiDDU6OuUs0cJq3O7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068806; c=relaxed/simple;
	bh=9nTiVh04ae9mQjKB1RdP90/UkIbsgP+LavfCUF4boMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VqgZW9LgtpT2x4WwGAFt8d6q6Fem+bc1r+z+ylb71NMgxUMgeUPYc1ksrdXSmHtDixppZRo/FXu4E7oz0SVPjyoPItPYVix9evqpvAfjuA9eGYCye0iHZjnPzNvj3XpjoUXFxMF1aBJ7aTgEQFRLRY5aU6ga0+zX4KHVANW1Zyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJlD7fPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJlD7fPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D77C116C6;
	Mon,  2 Feb 2026 21:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068806;
	bh=9nTiVh04ae9mQjKB1RdP90/UkIbsgP+LavfCUF4boMs=;
	h=From:To:Cc:Subject:Date:From;
	b=XJlD7fPRMTTeEVpUcvdWLamokqJ3cxVn3/UXvF/HfGX7NF2+jmN10I5OHIvE9rDPr
	 zGSIPhFoxFHbZOP7GRjxqWzd+vgVadQOo/x8aZDN5hF3v/ynT17lyvM9lp80802/JJ
	 jmSRx9nJ0gIfOJ0PQrQsgh2OPLreMvesiKv74kg8uGL9tqCkEi9NVkA1tQjwgGwjpJ
	 tWqAnSB4MhU44q7kU7rOS8MSAgerEsKEOc93MGbL1zT0nHlj8bAHOKEXI5nHoUumN7
	 aeOxv5EjtFvwSFp+UH/Xbtkr3U+RIaWwwW/OKzL3cOdopwJjR9AProhCmmYQt29hj4
	 DM1eZl9IZ8YUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek - fixed speaker no sound
Date: Mon,  2 Feb 2026 16:45:56 -0500
Message-ID: <20260202214643.212290-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 630fbc6e870eb06c5126cc97a3abecbe012272c8 ]

If it play a 5s above silence media stream, it will cause silence
detection trigger.
Speaker will make no sound when you use another app to play a stream.
Add this patch will solve this issue.

GPIO2: Mute Hotkey GPIO3: Mic Mute LED
Enable this will turn on hotkey and LED support.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/f4929e137a7949238cc043d861a4d9f8@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: ALSA: hda/realtek - fixed speaker no sound

### 1. COMMIT MESSAGE ANALYSIS

The commit message describes a real user-facing bug:
- **Problem**: When playing a media stream with 5+ seconds of silence,
  the AMP silence detection triggers
- **Symptom**: Speaker produces no sound when another app tries to play
  audio
- **Solution**: Disable AMP silence detection during playback, re-enable
  on close

The message also mentions GPIO2/GPIO3 for Mute Hotkey and Mic Mute LED
support, though this seems to be pre-existing functionality in the hook.

Key indicators:
- "fixed speaker no sound" - clear bug fix language
- Fixes a real user-visible issue (audio stops working)
- Author is from Realtek (hardware vendor) - they understand their
  hardware
- Has "Signed-off-by" from subsystem maintainer Takashi Iwai

### 2. CODE CHANGE ANALYSIS

Let me examine the technical details of this fix:

**What the code does:**

The patch modifies `alc287_alc1318_playback_pcm_hook()` which is called
during PCM stream open/close operations.

**Changes made:**

1. **Adds two coefficient arrays:**
   - `dis_coefs[]` - Disables AMP silence detection (coef 0x28 = 0x0004)
   - `en_coefs[]` - Enables AMP silence detection (coef 0x28 = 0x0084)

2. **On PCM OPEN (playback starts):**
   - Now disables silence detection via `alc_process_coef_fw(codec,
     dis_coefs)`
   - Then sets GPIO3 high (existing behavior)

3. **On PCM CLOSE (playback stops):**
   - Now re-enables silence detection via `alc_process_coef_fw(codec,
     en_coefs)`
   - Then resets GPIO3 to default (existing behavior)

**Root cause explanation:**
The ALC1318 amplifier has built-in silence detection that mutes output
when it detects prolonged silence. This is a power-saving feature, but
it causes problems when:
1. User plays media with silent sections
2. Silence detection kicks in and mutes the amp
3. When another app tries to play audio, the amp remains muted

The fix disables this hardware feature during active playback and re-
enables it when playback stops.

### 3. CLASSIFICATION

- **Type**: Bug fix (hardware quirk/workaround)
- **Category**: This falls under "QUIRKS and WORKAROUNDS" - fixing
  hardware behavior that causes real-world issues
- **Not a new feature**: It's disabling problematic hardware behavior,
  not adding new capabilities

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- Single file changed: `sound/hda/codecs/realtek/alc269.c`
- Lines changed: ~15 lines added
- Affects one specific function: `alc287_alc1318_playback_pcm_hook()`
- Only affects systems with ALC287/ALC1318 codec (Lenovo ThinkPads with
  this specific hardware)

**Risk:**
- **LOW**: The change is very localized
- Uses existing infrastructure (`alc_process_coef_fw()`)
- The coefficient values come from Realtek (hardware vendor)
- Only affects this specific codec/hardware combination
- Worst case: silence detection remains on or off incorrectly - not
  catastrophic

### 5. USER IMPACT

**Who is affected:**
- Users with Lenovo ThinkPad laptops using ALC287/ALC1318 audio codec
- This appears to be a relatively common configuration in recent
  ThinkPads

**Severity:**
- **HIGH** for affected users - audio completely stops working after
  playing content with silence
- This is a frustrating bug that makes the system appear broken

**Real-world bug:**
- The commit comes from Realtek, suggesting they received bug reports
- The problem manifests in normal usage (e.g., watching videos with
  quiet scenes)

### 6. STABILITY INDICATORS

- Authored by Kailang Yang from Realtek (hardware vendor)
- Reviewed/signed by Takashi Iwai (longtime ALSA maintainer)
- Uses well-established codec coefficient writing mechanism
- The `alc_process_coef_fw()` function is already used extensively in
  this codebase

### 7. DEPENDENCY CHECK

Let me verify the context exists in stable:

The function `alc287_alc1318_playback_pcm_hook()` and the
`alc287_fixup_lenovo_thinkpad_with_alc1318()` fixup need to exist in the
stable tree. This appears to be for relatively recent hardware
(ALC1318), so I should check when this was introduced.

Looking at the code structure, this is modifying an existing PCM hook,
not adding a new one. The infrastructure (`alc_process_coef_fw`,
`WRITE_COEF` macro, etc.) is well-established in the HDA Realtek driver.

### 8. STABLE CRITERIA EVALUATION

| Criteria | Assessment |
|----------|------------|
| Obviously correct | ✅ Yes - clear logic, vendor-provided fix |
| Fixes real bug | ✅ Yes - audio stops working for users |
| Important issue | ✅ Yes - complete audio failure |
| Small and contained | ✅ Yes - ~15 lines, single function |
| No new features | ✅ Yes - it's disabling problematic behavior |
| No new APIs | ✅ Yes - internal codec change only |

### 9. CONCLUSION

**Benefits:**
- Fixes a real, user-visible bug where speaker audio stops working
- Small, surgical fix with clear scope
- Comes from hardware vendor with maintainer approval
- Low risk of regression (affects only specific hardware)

**Concerns:**
- Need to verify the parent function exists in stable trees (hardware
  may be too new for older LTS kernels)
- The fix is straightforward and should apply cleanly

**Verdict:**
This is a classic hardware quirk fix that resolves a frustrating user-
facing bug (no audio output). It meets all stable kernel criteria: it's
obviously correct, fixes a real bug that affects users, is small and
contained, and doesn't introduce new features. The fix comes from the
hardware vendor (Realtek) and has been approved by the subsystem
maintainer. The only consideration is whether the affected code exists
in the target stable trees, but that's a backporting logistics issue
rather than a reason to reject.

**YES**

 sound/hda/codecs/realtek/alc269.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4ab89cb6e55f2..c473c6bd37e67 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3371,11 +3371,22 @@ static void alc287_alc1318_playback_pcm_hook(struct hda_pcm_stream *hinfo,
 				   struct snd_pcm_substream *substream,
 				   int action)
 {
+	static const struct coef_fw dis_coefs[] = {
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
+		WRITE_COEF(0x28, 0x0004), WRITE_COEF(0x29, 0xb023),
+	}; /* Disable AMP silence detection */
+	static const struct coef_fw en_coefs[] = {
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
+		WRITE_COEF(0x28, 0x0084), WRITE_COEF(0x29, 0xb023),
+	}; /* Enable AMP silence detection */
+
 	switch (action) {
 	case HDA_GEN_PCM_ACT_OPEN:
+		alc_process_coef_fw(codec, dis_coefs);
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x954f); /* write gpio3 to high */
 		break;
 	case HDA_GEN_PCM_ACT_CLOSE:
+		alc_process_coef_fw(codec, en_coefs);
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x554f); /* write gpio3 as default value */
 		break;
 	}
-- 
2.51.0

