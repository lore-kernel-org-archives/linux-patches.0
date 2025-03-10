Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BF2233155;
	Mon, 10 Mar 2025 17:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628340; cv=none; b=HNKh93SCY/JWFNALVWHAQ7gDjwSBAo742BoIcSYvAg9QnrTLjQfvitrp0dF32+fZpYs0pF3aKxpAwcSj+0vyAqrqgnjX7U3IgVcz2yR6VDnBp/MouzXBY1XqW9pddbVijNyjwLxLpxgjo9g86ggMwnXcEJ1qEaYoY3DQKOaWZwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628340; c=relaxed/simple;
	bh=6tycHJHE/hD7TEe5aaDTTSuUUGZ6UUu9JTlOT4KAvXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTegxZrEXbdspmjwPNsk6ey51x8CwqOSSXZf2Keicl7mL2AyQXyV7zai237CzJxZHsrU70kJFLikla5PTLefY7MFUyTl8qP3cHbHt+Y2FedpC/N8i7xUQGXG8i1qMoTO7HAoiykbMnFtg1tDEhvaOjFKiwx9mMbtMAjgIaulDiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4So/pT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4So/pT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E021C4CEE5;
	Mon, 10 Mar 2025 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628340;
	bh=6tycHJHE/hD7TEe5aaDTTSuUUGZ6UUu9JTlOT4KAvXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4So/pT2HCSRfdh3ts5PC7GUKV8dQryUem/YZsTqYX1lLqcgZpc6lwpgZcA2QXIPv
	 4BqaLYNZPkoymI+JjeIOPt27bgpaUL9C0tAKitMw9EFgrLjnckMtenUAKxuxTg5c9l
	 BDPssfJ87/0eH1Cbu03awwcr24Sij7PTA+CIJZeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 017/109] ALSA: hda/realtek - add supported Mic Mute LED for Lenovo platform
Date: Mon, 10 Mar 2025 18:06:01 +0100
Message-ID: <20250310170428.236588688@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit f603b159231b0c58f0c27ab39348534063d38223 upstream.

Support Mic Mute LED for ThinkCentre M series.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/c211a2702f1f411e86bd7420d7eebc03@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4915,6 +4915,16 @@ static void alc269_fixup_hp_line1_mic1_l
 	}
 }
 
+static void alc233_fixup_lenovo_low_en_micmute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->micmute_led_polarity = 1;
+	alc233_fixup_lenovo_line2_mic_hotkey(codec, fix, action);
+}
+
 static void alc_hp_mute_disable(struct hda_codec *codec, unsigned int delay)
 {
 	if (delay <= 0)
@@ -7220,6 +7230,7 @@ enum {
 	ALC275_FIXUP_DELL_XPS,
 	ALC293_FIXUP_LENOVO_SPK_NOISE,
 	ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY,
+	ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED,
 	ALC255_FIXUP_DELL_SPK_NOISE,
 	ALC225_FIXUP_DISABLE_MIC_VREF,
 	ALC225_FIXUP_DELL1_MIC_NO_PRESENCE,
@@ -8180,6 +8191,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_fixup_lenovo_line2_mic_hotkey,
 	},
+	[ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc233_fixup_lenovo_low_en_micmute_led,
+	},
 	[ALC233_FIXUP_INTEL_NUC8_DMIC] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_inv_dmic,
@@ -10170,6 +10185,9 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x334b, "Lenovo ThinkCentre M70 Gen5", ALC283_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x3384, "ThinkCentre M90a PRO", ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED),
+	SND_PCI_QUIRK(0x17aa, 0x3386, "ThinkCentre M90a Gen6", ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED),
+	SND_PCI_QUIRK(0x17aa, 0x3387, "ThinkCentre M70a Gen6", ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED),
 	SND_PCI_QUIRK(0x17aa, 0x3801, "Lenovo Yoga9 14IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),


