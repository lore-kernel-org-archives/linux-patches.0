Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D5C1FFC48;
	Sat, 14 Feb 2026 01:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031266; cv=none; b=ub76l/KLhMguIs0XNxOrfn5fe0bYZDUj9qdsmCVsBScdrIDVXIS2k/0JO5IFTF0xqGvXoBaWxOxMsagoLtEnXxxhUFvDmRvGrhlZcBDyXqAsnMrpQWp4Z7+EfjHZeIplA1LGEkvmy0bnW6+FqCO2YHlQTW0JvWBCDZvulubeEoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031266; c=relaxed/simple;
	bh=ZTBxF5tyoweHeED92Fj5es1N3OQ+8dCPMOqIgAPDepY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cvc/Wu0WQl/r6CGp5EuTOEGk0J1BaRQtsylt0urO2/Ez0a/PHEzArq9jym6hmy5c8yu7L77OEv3xhwdKpcvBy8b3lGlDEzyON9O94nV6DthKLmsIDz6vgKnFkHsoQV0XTyM2X2MpBG1KYgZ8CoPV+mprseku2mrNHCgADvt60Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7c8DKr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7c8DKr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5075FC16AAE;
	Sat, 14 Feb 2026 01:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031266;
	bh=ZTBxF5tyoweHeED92Fj5es1N3OQ+8dCPMOqIgAPDepY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7c8DKr6b7skACLS3XAYVsMXgSZmm1JZB7GrxZ1utLwdWB5QTivUqFwJdueDHxOgM
	 Zlp0Krq3bY3Wugqar1E4Ctr4V8MDwUSwvBi0HHfN3Hzf1+gyPK2qYeI0IGqm7CwOhL
	 oeKMuSdzp+fzyNe5OQIDwI6a5lbSwWmY7CYEwAoKZPXdOjUXAOgc+eJHoscUSjSlnJ
	 x9Ye6Y2Fc4yiSOfj9hsrX8wD527ZBFW1FTSRqQxUFtvqYkYv0bFZSp+A2WVferUvBc
	 TceJKzfT4DlRFz1AT9H3Zzhy5hZ4IOJGBfBFxaNbuZITMBWkN2p//csVyFPvI13om5
	 QlukmbwMJMntQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com
Subject: [PATCH AUTOSEL 6.19] ALSA: hda/realtek - Enable Mute LED for Lenovo platform
Date: Fri, 13 Feb 2026 20:00:06 -0500
Message-ID: <20260214010245.3671907-126-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 5de5db35350d9c4def1de2ae273e224a4eee5ed1 ]

Enable SPK Mute Led and Mic Mute Led for Lenovo platform.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://patch.msgid.link/8a99edffee044e13b6e348d1b69c2b57@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive picture. Let me summarize my analysis.

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit subject is "ALSA: hda/realtek - Enable Mute LED for Lenovo
platform" and the body says "Enable SPK Mute Led and Mic Mute Led for
Lenovo platform." It's authored by Kailang Yang (kailang@realtek.com),
who is the Realtek codec maintainer and the primary author of virtually
all Realtek HDA quirk additions. The commit was signed off by Takashi
Iwai, the ALSA subsystem maintainer.

The commit does **not** have `Cc: stable@vger.kernel.org` (which is why
it's being reviewed here). Notably, a very similar prior commit by the
same author (`f603b159231b0`, "add supported Mic Mute LED for Lenovo
platform") **did** have `Cc: stable` -- suggesting the author considers
this type of change appropriate for stable but simply forgot the tag
this time.

### 2. CODE CHANGE ANALYSIS

The commit adds three things:

**a) New function `alc233_fixup_lenovo_coef_micmute_led()`** (lines
1619-1632 in the diff):
- Sets up mic mute LED control via codec coefficient register 0x10, bit
  13
- Identical pattern to existing functions like
  `alc285_fixup_hp_coef_micmute_led()` and
  `alc236_fixup_hp_coef_micmute_led()`
- Uses the established `coef_micmute_led_set` callback which has been in
  the driver for years

**b) New function `alc233_fixup_lenovo_gpio2_mic_hotkey()`** (lines
1903-1919 in the diff):
- Combines the mic mute LED function with GPIO2-based mic mute hotkey
  detection
- Nearly identical structure to the existing
  `alc280_fixup_hp_gpio2_mic_hotkey()` function
- All called functions (`alc_update_coef_idx`,
  `alc_register_micmute_input_device`, `snd_hda_codec_write_cache`,
  `snd_hda_jack_detect_enable_callback`, `gpio2_mic_hotkey_event`,
  `input_unregister_device`) are long-established in the driver

**c) Five SND_PCI_QUIRK entries** for specific Lenovo ThinkCentre
models:
- `0x17aa:0x3341` - Lenovo ThinkCentre M90 Gen4
- `0x17aa:0x3342` - Lenovo ThinkCentre M90 Gen4
- `0x17aa:0x3343` - Lenovo ThinkCentre M70 Gen4
- `0x17aa:0x3344` - Lenovo ThinkCentre M70 Gen4
- `0x17aa:0x334f` - Lenovo ThinkCentre M90a Gen5

### 3. CLASSIFICATION

This is a **hardware quirk** addition. It falls squarely into the
"QUIRKS and WORKAROUNDS" exception category for stable kernels. Without
this quirk, the mute LEDs on these specific Lenovo ThinkCentre models do
not work, meaning users have no visual feedback for mute/mic-mute
status. While not a crash or data corruption, it is a real hardware
usability issue for owners of these machines.

The commit is **not** adding a new feature in the software sense -- it's
enabling existing LED infrastructure for specific hardware. The LED
subsystem, the coef-based LED control, and the GPIO-based mic hotkey
handling all already exist. This commit just provides the device-
specific parameters.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: ~80 lines added across one file
- **Files touched**: 1 (`sound/hda/codecs/realtek/alc269.c`)
- **Complexity**: Low -- the new code follows established patterns
  exactly
- **Risk**: Very low -- the quirks are only triggered for the specific
  PCI SSIDs (vendor 0x17aa + specific device IDs). The new functions
  only execute when those specific devices are detected. No existing
  functionality is changed.
- **Subsystem maturity**: The Realtek HDA codec driver is one of the
  most heavily quirked drivers in the kernel, with hundreds of similar
  entries. This pattern has been proven safe over many years.

### 5. USER IMPACT

Owners of Lenovo ThinkCentre M90 Gen4, M70 Gen4, and M90a Gen5 computers
would benefit from having their mute LEDs work correctly. These are
business/enterprise desktop computers (ThinkCentre is Lenovo's
enterprise line), commonly deployed in corporate environments. Mute LED
feedback is an important usability feature, especially for video
conferencing.

### 6. STABILITY INDICATORS

- The author (Kailang Yang) is Realtek's own codec engineer and has
  authored hundreds of similar quirk additions
- The commit was reviewed and signed off by Takashi Iwai, the ALSA
  maintainer
- The pattern is identical to dozens of other quirk additions that have
  been in stable for years

### 7. DEPENDENCY CHECK

The commit is self-contained. All functions it calls
(`coef_micmute_led_set`, `gpio2_mic_hotkey_event`,
`alc_register_micmute_input_device`, `alc_update_coef_idx`, etc.) exist
in all actively supported stable trees. The only backport complication
is:

- **File path**: In stable trees (6.6.y, 6.1.y, etc.), the code lives in
  `sound/pci/hda/patch_realtek.c`, not
  `sound/hda/codecs/realtek/alc269.c`. This is a trivial path adjustment
  for the backport.
- **Enum ordering**: The new `ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY` enum
  must be added at the same relative position or end of the enum (the
  enum is positional in this driver and changing order would break other
  fixups). This needs care but is standard for quirk backports.

### 8. COMPARISON WITH SIMILAR COMMITS

The prior commit `f603b159231b0` by the same author, doing the same type
of change (adding Lenovo ThinkCentre mute LED support), explicitly had
`Cc: stable@vger.kernel.org`. This strongly suggests the author
considers this class of change worthy of stable backport and simply
omitted the tag this time.

### Conclusion

This is a textbook hardware quirk addition that enables mute LED
functionality for specific Lenovo ThinkCentre enterprise desktop models.
It follows the exact same pattern as hundreds of other SND_PCI_QUIRK
entries in the Realtek driver, uses only existing infrastructure, is
self-contained, has essentially zero risk of regression (only activates
for specific hardware), and directly benefits real users of these
machines. The prior very similar commit by the same author explicitly
requested stable backport. The only downside is that it's slightly
larger than a pure one-line quirk entry because it needs new fixup
functions -- but those functions are trivial copies of existing
patterns. The backport will need a file path adjustment due to the
driver split.

**YES**

 sound/hda/codecs/realtek/alc269.c | 57 +++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b66965a521076..da71237d2ccb0 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1616,6 +1616,20 @@ static void alc295_fixup_hp_mute_led_coefbit11(struct hda_codec *codec,
 	}
 }
 
+static void alc233_fixup_lenovo_coef_micmute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mic_led_coef.idx = 0x10;
+		spec->mic_led_coef.mask = 1 << 13;
+		spec->mic_led_coef.on = 0;
+		spec->mic_led_coef.off = 1 << 13;
+		snd_hda_gen_add_micmute_led_cdev(codec, coef_micmute_led_set);
+	}
+}
+
 static void alc285_fixup_hp_mute_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -1918,6 +1932,39 @@ static void alc280_fixup_hp_gpio2_mic_hotkey(struct hda_codec *codec,
 	}
 }
 
+/* GPIO2 = mic mute hotkey
+ * GPIO3 = mic mute LED
+ */
+static void alc233_fixup_lenovo_gpio2_mic_hotkey(struct hda_codec *codec,
+					     const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	alc233_fixup_lenovo_coef_micmute_led(codec, fix, action);
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		alc_update_coef_idx(codec, 0x10, 1<<2, 1<<2);
+		if (alc_register_micmute_input_device(codec) != 0)
+			return;
+
+		spec->gpio_mask |= 0x04;
+		spec->gpio_dir |= 0x0;
+		snd_hda_codec_write_cache(codec, codec->core.afg, 0,
+					  AC_VERB_SET_GPIO_UNSOLICITED_RSP_MASK, 0x04);
+		snd_hda_jack_detect_enable_callback(codec, codec->core.afg,
+						    gpio2_mic_hotkey_event);
+		return;
+	}
+
+	if (!spec->kb_dev)
+		return;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_FREE:
+		input_unregister_device(spec->kb_dev);
+		spec->kb_dev = NULL;
+	}
+}
+
 /* Line2 = mic mute hotkey
  * GPIO2 = mic mute LED
  */
@@ -3816,6 +3863,7 @@ enum {
 	ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED,
 	ALC288_FIXUP_SURFACE_SWAP_DACS,
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO,
+	ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6306,6 +6354,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc288_fixup_surface_swap_dacs,
 	},
+        [ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY] = {
+                .type = HDA_FIXUP_FUNC,
+                .v.func = alc233_fixup_lenovo_gpio2_mic_hotkey,
+        },
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -7211,7 +7263,12 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3176, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
+	SND_PCI_QUIRK(0x17aa, 0x3341, "Lenovo ThinkCentre M90 Gen4", ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY),
+	SND_PCI_QUIRK(0x17aa, 0x3342, "Lenovo ThinkCentre M90 Gen4", ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY),
+	SND_PCI_QUIRK(0x17aa, 0x3343, "Lenovo ThinkCentre M70 Gen4", ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY),
+	SND_PCI_QUIRK(0x17aa, 0x3344, "Lenovo ThinkCentre M70 Gen4", ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x334b, "Lenovo ThinkCentre M70 Gen5", ALC283_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x334f, "Lenovo ThinkCentre M90a Gen5", ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x3384, "ThinkCentre M90a PRO", ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED),
 	SND_PCI_QUIRK(0x17aa, 0x3386, "ThinkCentre M90a Gen6", ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED),
 	SND_PCI_QUIRK(0x17aa, 0x3387, "ThinkCentre M70a Gen6", ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED),
-- 
2.51.0

