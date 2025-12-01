Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE94F26AC3;
	Mon,  1 Dec 2025 01:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553370; cv=none; b=AhlFhMCOD3tg4QdSeaO7qyHW/Eb3YrL5d+t0md599KTqcq9dGwZV+/eYf5REpnAKmRhGf3DS0UPmMVCzFhvSLm8lBsu09eNoq6p93QSG9qgexCLCrawOaKtaA2uYNwqog09nUH4ABIlO1FymUBz6fynlqPbWKtNh2i+8fs16XQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553370; c=relaxed/simple;
	bh=ef5gqF6QGxkGqr/dl/A0bQymlW596I+z9Ph3YDi4l3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oibJ6ksIXs29iAA1Jmrthw1ZTUgvl1f75iFnFvxPQvssXvQnXNyhZVCAdv4QclROMdKjoRxT+UoPoKZxsWfxjBtAY9JlxhnhUTTjrAzaGNINpKLHD8Bj9xf7C0lQ7NqBI6NEkPXFM689asi2soQTwq716tz33/p8wRaLqi1CFh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfEdMtWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfEdMtWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20552C4CEFB;
	Mon,  1 Dec 2025 01:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764553368;
	bh=ef5gqF6QGxkGqr/dl/A0bQymlW596I+z9Ph3YDi4l3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfEdMtWYp7nrxX4yvTrcW+jRH3g91F61/R9qsTSjo1IwHVDQu+jO77rsz7LkXMVlh
	 MsYGaHLHvTf3Kp9OK/4dTfrR1/sGkWg0zZeIQ01MsFLUncpKIA7MW+igSgI02f7ve6
	 QPGJ/Vsd9u9bT3RsZxKeIX+MpnfEja6kYL+Y+8zvgzwVC2VKaUDEgmJDQ2Kt5DHYwL
	 5WpBxP3hZDkNcHKDs88dnABIMEtfapHsnRRWuCO1LgU3rD9Wl8AayJ6EKRjW9sHCw7
	 eFNYNfHhHxh2H+K+G0OGNYHaRUestfiv0z9iM1dvHOG56pVpVLuk+xw0sIR/ofrqNa
	 kCdSCFaDzlI3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilyas Gasanov <public@gsnoff.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.17] ALSA: hda/realtek: Add quirk for HP ProBook 450 G8
Date: Sun, 30 Nov 2025 20:42:05 -0500
Message-ID: <20251201014235.104853-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251201014235.104853-1-sashal@kernel.org>
References: <20251201014235.104853-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilyas Gasanov <public@gsnoff.com>

[ Upstream commit d041e5e748f926398ad96436a86667dea8b591e0 ]

My laptop, HP ProBook 450 G8 (32M40EA), has Realtek ALC236 codec on its
integrated sound card, and uses GPIO pins 0x2 and 0x1 for speaker mute
and mic mute LEDs correspondingly, as found out by me through hda-verb
invocations. This matches the GPIO masks used by the
alc236_fixup_hp_gpio_led() function.

PCI subsystem vendor and device IDs happen to be 0x103c and 0x8a75,
which has not been covered in the ALC2xx driver code yet.

Signed-off-by: Ilyas Gasanov <public@gsnoff.com>
Link: https://patch.msgid.link/20251125235441.53629-1-public@gsnoff.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Summary of Investigation

**Type of Change:** Hardware quirk/device ID addition - a single line
adding PCI subsystem ID 0x103c:0x8a75 to the quirk table.

**Technical Details:**
- The `alc236_fixup_hp_gpio_led()` function (lines 1320-1324) is a
  simple wrapper that sets GPIO masks 0x02 and 0x01 for mute/mic-mute
  LEDs
- This fixup is **already used by 40+ other HP laptop entries** in the
  same table
- HP ProBook 450 G8 already has one entry at device ID 0x87e7 using the
  same fixup - this adds another variant (0x8a75) of the same laptop
- The adjacent device ID 0x8a74 ("HP ProBook 440 G8") also uses this
  same fixup

**Stable Kernel Rules Compliance:**

1. **Obviously correct:** ✓ Single line addition follows a well-
   established pattern used by dozens of other entries
2. **Fixes real bug:** ✓ Enables mute/mic-mute LED functionality on
   user's actual hardware (verified via `hda-verb`)
3. **Small and contained:** ✓ One line, one file
4. **No new features:** ✓ Uses existing fixup infrastructure
5. **Exception category:** ✓ **Explicitly allowed** - Device ID/quirk
   additions are called out as permitted exceptions in stable rules

**User Impact:**
- Without this quirk, HP ProBook 450 G8 (0x8a75 variant) users have non-
  functional mute indicator LEDs
- Affects a real user who tested and verified the fix on actual hardware
- Common business laptop used in enterprise environments

**Risk Assessment:**
- **Regression risk: Negligible** - Only affects devices with exactly
  the subsystem ID 0x103c:0x8a75
- The fixup function is mature, well-tested across many devices
- Cannot affect any other hardware
- No logic changes, no API changes

**Dependencies:**
- `ALC236_FIXUP_HP_GPIO_LED` and the underlying
  `alc_fixup_hp_gpio_led()` function already exist in all maintained
  stable kernels
- No other patches required
- Should apply cleanly to stable trees

### Conclusion

This commit is a **textbook example** of a hardware quirk addition that
stable kernel rules explicitly permit. It:
- Adds a single PCI device ID to enable hardware support on a specific
  laptop variant
- Uses existing, well-tested driver infrastructure (40+ other HP laptops
  use the same fixup)
- Has been verified by the reporter on actual hardware
- Has zero regression risk for anyone not using this specific laptop
  model
- Has been reviewed and accepted by the sound maintainer (Takashi Iwai)

This matches the stable rules documentation: "NEW DEVICE IDs (Very
Common): Adding PCI IDs, USB IDs, ACPI IDs, etc. to existing drivers.
These are trivial one-line additions that enable hardware support."

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 19604352317d..2126e022848e 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6516,6 +6516,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a75, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x8aa0, "HP ProBook 440 G9 (MB 8A9E)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.51.0

