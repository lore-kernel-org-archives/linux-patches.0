Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C6C2556E;
	Sat, 14 Feb 2026 01:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031243; cv=none; b=O4vv+5UwyVH5oDfZHk+cRMQFMUsJK+9SyOhZy+vZcXcY+leLjpx+Z7Vw58YDQQpLXueYzNeKsLcv4/AFUqVu6ZicmVjcuoq7a3iGjwf84KMx17hOSqNafXwa1Egl1h5h7WO/1yv5PsP6sRj1c+KP1hWk03fLeQHSgopqZPbrniE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031243; c=relaxed/simple;
	bh=zgR0+w19KeuAigpzZA4mlBHR3kTKhOmhG/jOoWCG13U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e3SFcWy47KkgKyzdpn5ukRop+VsjZ1yZ9oUXVS+fpBAcRFf4HtWzji6VbNdOi1rZyZ0mRVYnlZ3to4LRrLNkQO5BmbqqX350BGcRoT32J94c4tkLqKOSam5EzoAPA9XqIY0qCQIbSPOcSTuQPM4dgA7kUYzJHodXDaY27eM8AyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cveJoaMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cveJoaMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F026C16AAE;
	Sat, 14 Feb 2026 01:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031243;
	bh=zgR0+w19KeuAigpzZA4mlBHR3kTKhOmhG/jOoWCG13U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cveJoaMwnAqwPx0pD7XCmdIbv44Q5qJ0HFuwgVdB4kCb9VeXZIySSSoR7tzeWvtMq
	 YTIXhSz15+WKRWbRk6cuV7wJZv6hzfhRN/mYlwl7SfyF2vt8dgwoIpyeaaZN+fJHZu
	 cIT+/AAt3Lc30JwWk0ZcjPv1YtH7gCvvEFjifhN6fZuDaZ36ZIO+gdBxurrA4LkACy
	 BVt9O6s6HgPKw7ub8Jl4vHNN1SUqrNTwX1NhtbqV4zilrn5JF6n+3SDLpGl+4dDXnH
	 nd9QABgVWFnPoowwHoEcqzr2NpwC8BPW0DzHEHtatzp0Aj7NcFAzTxFplYIAkSZuFm
	 aQfw7SzwkXPFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bharat Dev Burman <bharat.singh7924@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com
Subject: [PATCH AUTOSEL 6.19-6.12] ALSA: hda/realtek: add HP Victus 16-e0xxx mute LED quirk
Date: Fri, 13 Feb 2026 19:59:56 -0500
Message-ID: <20260214010245.3671907-116-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bharat Dev Burman <bharat.singh7924@gmail.com>

[ Upstream commit 72919c57a055f6d7b79d66731dc398e9b433f47c ]

HP Victus 16-e0xxx with ALC245 codec does not handle the toggling of
the mute LED.
This patch adds a quirk entry for subsystem ID 0x88eb using a new
ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT fixup, enabling correct mute LED
behavior.

Signed-off-by: Bharat Dev Burman <bharat.singh7924@gmail.com>
Link: https://patch.msgid.link/20260112184253.33376-1-bharat.singh7924@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

This commit adds a hardware quirk for the HP Victus 16-e0xxx laptop with
ALC245 codec. The mute LED does not toggle correctly without this quirk.
It adds a new `SND_PCI_QUIRK` entry (subsystem ID `0x103c:0x88eb`) and a
new fixup function `alc245_fixup_hp_mute_led_v2_coefbit`.

### Code Change Analysis

The change has three parts:

1. **New fixup function `alc245_fixup_hp_mute_led_v2_coefbit`** (~16
   lines): This is nearly identical to the existing
   `alc245_fixup_hp_mute_led_v1_coefbit`, differing only in the `mask`
   field:
   - v1: `spec->mute_led_coef.mask = 3 << 2;` (bits 2-3)
   - v2: `spec->mute_led_coef.mask = 1 << 3;` (bit 3 only)

   The `on` value (`1 << 3`) and all other fields are the same. This is
a trivial variation of an existing pattern for a different hardware
configuration.

2. **New enum value `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT`**: Added to
   the fixup enum, standard boilerplate.

3. **New quirk table entry**: `SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus
   16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT)` — a single-line
   addition to the quirk table.

### Classification

This is a **hardware quirk / workaround** — one of the explicitly
allowed exception categories for stable backports. Audio codec quirks in
`patch_realtek.c` are extremely common in stable trees. The
`SND_PCI_QUIRK` mechanism is designed exactly for this purpose: matching
specific hardware by PCI subsystem ID and applying device-specific
fixups.

### Scope and Risk Assessment

- **Size**: Small — ~20 lines of new code, all following well-
  established patterns
- **Risk**: Very low — the new quirk only activates on the specific
  subsystem ID `0x103c:0x88eb`. It cannot affect any other hardware.
- **Pattern**: The new function is a minor variation of an existing,
  proven function. The only difference is one bitmask value.
- **No behavioral changes** for any other system.

### User Impact

Users with HP Victus 16-e0xxx laptops currently have a non-functional
mute LED indicator. While not a crash or data corruption issue, mute LED
behavior is important for usability — users need visual feedback to know
whether their microphone/speakers are muted. This is a real hardware
issue affecting real users.

### Stability Indicators

- Accepted by the HDA subsystem maintainer (Takashi Iwai)
- Follows an extremely well-established pattern in the Realtek HDA
  driver
- The quirk mechanism has been stable for many years

### Dependency Check

No dependencies on other commits. The base infrastructure
(`coef_mute_led_set`, `alc_update_coef_led`, `struct coef_fw` for LED
coefficients) has existed in stable trees for a long time. The new
function uses only existing helpers and structures.

### Verdict

This is a textbook audio codec quirk addition — a new `SND_PCI_QUIRK`
entry with a minor variation fixup function for a specific HP laptop
model. These are among the most common and safest stable backport
candidates. The change is small, self-contained, risk-free to other
hardware, and fixes a real user-facing issue (broken mute LED).

**YES**

 sound/hda/codecs/realtek/alc269.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index da71237d2ccb0..0924dbf1ed334 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1551,6 +1551,22 @@ static void alc245_fixup_hp_mute_led_v1_coefbit(struct hda_codec *codec,
 	}
 }
 
+static void alc245_fixup_hp_mute_led_v2_coefbit(struct hda_codec *codec,
+					  const struct hda_fixup *fix,
+					  int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_polarity = 0;
+		spec->mute_led_coef.idx = 0x0b;
+		spec->mute_led_coef.mask = 1 << 3;
+		spec->mute_led_coef.on = 1 << 3;
+		spec->mute_led_coef.off = 0;
+		snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
+	}
+}
+
 /* turn on/off mic-mute LED per capture hook by coef bit */
 static int coef_micmute_led_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
@@ -3828,6 +3844,7 @@ enum {
 	ALC287_FIXUP_YOGA7_14ARB7_I2C,
 	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
 	ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT,
+	ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT,
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
 	ALC287_FIXUP_THINKPAD_I2S_SPK,
 	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD,
@@ -6165,6 +6182,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_v1_coefbit,
 	},
+	[ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_mute_led_v2_coefbit,
+	},
 	[ALC245_FIXUP_HP_X360_MUTE_LEDS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_coefbit,
@@ -6654,6 +6675,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.51.0

