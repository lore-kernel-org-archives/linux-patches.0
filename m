Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6213221A453;
	Sat, 14 Feb 2026 01:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031104; cv=none; b=h3UwwQARinKgeeMVZhhfSJjj/vHpjXS1mvLxIu0p0mZ7KWSKm5FaVrM26GspP2AYAOZmxlhs4EILB7ewfSITGXu36dId4IiCrsNxbbMNDBLWkK7or7nhztWF2SbbpoJlfZyNpdLtl0hqwh7s0xvtKrbD9hNUWP9ofBpBq11PKqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031104; c=relaxed/simple;
	bh=yi3FFoj3cTGDt6eOhcXf68S45ErfS4sWwsrSS9ZTFd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VItPappdiVnlAk1zk0DI5efyzxY9bd4dK2omdzxfVrnavKkFnXovLAk8+XjDZ3BCtunwyOA7fwNBoPgorl67ldExVMMfye6H1ZZvhGcrjG9+D3Gn1hiGrzSlsnPp6mTvBCpKlNB9ROHJIJdoXElRqLbOuvJ/ZjmQTJ2rzQm3JxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJOB5qGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJOB5qGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEBEC116C6;
	Sat, 14 Feb 2026 01:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031104;
	bh=yi3FFoj3cTGDt6eOhcXf68S45ErfS4sWwsrSS9ZTFd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJOB5qGC16HnOg9mPPHkh/2St4WZSq9T/3LYDMomVz94hQ4ExXQtLMTwlvnva08zQ
	 el9vHGdcZGTGVCpoSvJFkDh274JhfLOBrs1M2qq7L1yJ8e7IKoPf+1LeRZlyTpfm76
	 CqzbRifigVEQruKLConsCYX7wrhgll1dqFzx9QNuPwwf3Gn3BarUR13VYCkM5TbM1y
	 9SmKRkcyqUwOlCA9DJTTElXwVJxNgddqHh+y9/CaQZLsQmWxlpC9312dgaiIuBqPiD
	 YPhERSjQtR1G5k/qeUy2iWEfyOHTwd/Xqe125vPtqU0+W7XcXcqGYkbjgTzjMsXOpo
	 q1wP9Wq9LrBtg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Illia Barbashyn <04baril@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com
Subject: [PATCH AUTOSEL 6.19-6.12] ALSA: hda/realtek - Enable mute LEDs on HP ENVY x360 15-es0xxx
Date: Fri, 13 Feb 2026 19:59:03 -0500
Message-ID: <20260214010245.3671907-63-sashal@kernel.org>
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

From: Illia Barbashyn <04baril@gmail.com>

[ Upstream commit ac1ff574bbc09a6c90f4fe8f9e6b8d66c983064c ]

The mute and mic-mute LEDs on HP ENVY x360 Convertible 15-es0xxx
(PCI SSID 103c:88b3) do not work with the current driver.

This model requires a combination of COEFBIT and GPIO fixups to
correctly control the LEDs. Introduce a new fixup function
alc245_fixup_hp_envy_x360_mute_led and add a quirk to apply it.

Signed-off-by: Illia Barbashyn <04baril@gmail.com>
Link: https://patch.msgid.link/20260207221955.24132-1-04baril@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

This commit adds a hardware quirk for the HP ENVY x360 Convertible
15-es0xxx laptop (PCI SSID 103c:88b3) to enable mute and mic-mute LED
control. The commit message clearly states that the LEDs "do not work
with the current driver" — this is a real hardware issue for users of
this specific laptop model.

### Code Change Analysis

The change consists of three parts:

1. **New fixup function** (`alc245_fixup_hp_envy_x360_mute_led`): A
   trivial 6-line wrapper that calls two existing functions:
   - `alc245_fixup_hp_mute_led_v1_coefbit()` — already exists in the
     driver
   - `alc245_fixup_hp_gpio_led()` — already exists in the driver

   This is the same pattern used by other similar quirks like
`alc285_fixup_hp_spectre_x360_mute_led` (which combines
`alc285_fixup_hp_mute_led_coefbit` +
`alc285_fixup_hp_gpio_micmute_led`).

2. **New enum entry** (`ALC245_FIXUP_HP_ENVY_X360_MUTE_LED`): One-line
   addition to the fixup enum.

3. **Fixup table entries**:
   - One entry in `alc269_fixups[]` mapping the enum to the function.
   - One `SND_PCI_QUIRK` entry in `alc269_fixup_tbl[]` matching the PCI
     SSID `0x103c:0x88b3`.

### Classification: Hardware Quirk

This falls squarely into the **QUIRKS and WORKAROUNDS** exception
category for stable kernels. Audio codec quirks (specifically
`SND_PCI_QUIRK` entries in `patch_realtek.c` / `alc269.c`) are one of
the most commonly backported types of changes. They:

- Fix real hardware for real users (HP ENVY x360 owners)
- Only affect the specific device matched by the PCI SSID
- Cannot cause regressions on any other hardware
- Use well-established, proven infrastructure

### Scope and Risk Assessment

- **Lines changed**: ~15 lines of actual code (trivial)
- **Files touched**: 1 (`alc269.c`)
- **Risk**: Extremely low — the new function only calls existing, well-
  tested functions; the quirk only activates on one specific laptop
  model
- **Regression potential**: Near zero — no existing behavior is modified
  for any other device

### User Impact

Users of the HP ENVY x360 Convertible 15-es0xxx cannot control their
mute LEDs without this quirk. This is a functional deficiency — the LED
indicators don't reflect the actual mute state, which is a usability
issue.

### Dependencies

The commit depends on `alc245_fixup_hp_mute_led_v1_coefbit` and
`alc245_fixup_hp_gpio_led` existing in the driver. These are well-
established functions present in stable trees that support the ALC245
codec.

### Stability Indicators

- Accepted by Takashi Iwai (HDA subsystem maintainer)
- Follows the exact same pattern as dozens of other HP quirks in the
  driver
- Contributed by a user who tested it on their own hardware

### Conclusion

This is a textbook hardware quirk addition — small, safe, device-
specific, using existing infrastructure, fixing a real hardware issue
for real users. Audio codec quirks like this are among the most routine
and lowest-risk stable backports.

**YES**

 sound/hda/codecs/realtek/alc269.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index f26c0aaa4c705..786d31f43207f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1660,6 +1660,13 @@ static void alc285_fixup_hp_spectre_x360_mute_led(struct hda_codec *codec,
 	alc285_fixup_hp_gpio_micmute_led(codec, fix, action);
 }
 
+static void alc245_fixup_hp_envy_x360_mute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc245_fixup_hp_mute_led_v1_coefbit(codec, fix, action);
+	alc245_fixup_hp_gpio_led(codec, fix, action);
+}
+
 static void alc236_fixup_hp_mute_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -3919,6 +3926,7 @@ enum {
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED,
+	ALC245_FIXUP_HP_ENVY_X360_MUTE_LED,
 	ALC285_FIXUP_HP_BEEP_MICMUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_COEFBIT2,
 	ALC236_FIXUP_HP_GPIO_LED,
@@ -5575,6 +5583,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_spectre_x360_mute_led,
 	},
+	[ALC245_FIXUP_HP_ENVY_X360_MUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_envy_x360_mute_led,
+	},
 	[ALC285_FIXUP_HP_BEEP_MICMUTE_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_beep,
@@ -6848,6 +6860,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x103c, 0x88b3, "HP ENVY x360 Convertible 15-es0xxx", ALC245_FIXUP_HP_ENVY_X360_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
-- 
2.51.0

