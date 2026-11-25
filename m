Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625408;
	b=sh1hu6QlGQxPCyLlX2bCwtisesiwdjjr5XD389UqRfbLtxVfIIb96R7GV9O1Ob0sscla
	 +bvURAe+SNyH3pptJtdOrqtjRrfe8Zj82G/bgBtYDOha37uX8W8ERHyV6f3Zn/IMSZ3Z0
	 w7thX20+fMgC/OzQ2PUk49i4DKFkVTKrwQRoEVh941wMsiFnthyY4P/6+V2Ooqsa8ygbN
	 721jAoiUTE6VApQHvUJ3BT7kK0zHWULgS8kzNuFtVZPKeWnTLQeDvyTjSS16esNzK0AxS
	 LMJWPeQIcEMLR7fxeEvwy5s4aEE7oj5kW9wwnbp4Fp6OhmdWgFEcA7wSH6xYgpYTprw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Drd90u229O6Hb6fyRAQm4j7/lyLG7lZhy/IdTWpotYg=;
	b=0g3tvSL2DLImW7FgQ3RCx5woZtVBsiH3CbxxHXjIwsGl6rOlaiatp6fBhpV6rtKRJfhj
	 hm1rK8S+Lzc/ikx0qKysVlSxWk8iF5i0Me04lc1CKZOWfvjsW571Jap0MFXZ+a4M8mIAc
	 tn7UBy3HUKGqXZ3LuiFSXw9vOXyzuWQ2GZCUXXhQ/voUL5WINYao1JhR9YBYc2UQv5uCw
	 AjzQ3mI4ettHx1VwRtV5PFhaNpKEbpkE6cIxrE8narz2BtQLLdybX/D+4KlJmxHE/Dygz
	 rLtrfDx+MLjzahtvwZ389N81Zpk4otReKcbQlxFBQkdpbXRWmpbqOsqi3gVPwfjT1HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecaPuVlO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D685606A321;
	Wed, 25 Nov 2026 16:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecaPuVlO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D031F000C4;
	Wed, 25 Nov 2026 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625407;
	bh=Drd90u229O6Hb6fyRAQm4j7/lyLG7lZhy/IdTWpotYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecaPuVlO4418AIAbIxopwKAwR7vaOSWMgkQBVWMgvt6p87jOeXcOmJzKom5xDav00
	 FLZW7r1xvLFx2POGSoOuPAj0+cSPWT9YqtqvosqUfaXH9+cpoAaWI4I7O1k8t/DqGz
	 aVevBixf+hatN7NGlLJNKrwklbMuy6AizcUXOdfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Menshin <ripeeerr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 504/816] ALSA: hda/realtek: Fix hiss/crackle on Lenovo Xiaoxin 14 GT (17aa:3912)
Date: Wed, 25 Nov 2026 15:34:12 +0100
Message-ID: <20261125143900.854234601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Menshin <ripeeerr@gmail.com>

[ Upstream commit 2fc28b1186d6fce8b046e6118072cf3ca32f2960 ]

Commit 3a3e810e9108 ("ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin
14 GT") added a quirk mapping SSID 17aa:3912 to
ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN, chosen by analogy with
neighboring SSIDs (0x390d, 0x3911, 0x391a) without being verified on
hardware, as noted in that commit's own message.

I have since tested it on the actual hardware (Lenovo Xiaoxin Pro 14
ASP10, same 17aa:3912 SSID) and confirmed it does not fix the reported
issue. ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN only repoints pin 0x17
and the preferred DAC pairs for the bass speaker; it does not touch
the codec's vendor processing coefficients. The actual symptom -
constant electrical hiss/crackle on both the headphone jack and the
internal speakers, independent of volume - is unrelated to pin/DAC
routing and is also present on stock Windows before the Realtek
driver is installed, which points at those coefficients being left
at their power-on default.

To find the correct values, I passed the physical HD Audio controller
through to a Windows 10 VM (VFIO, with QEMU patched to log CORB verb
traffic) and captured the coefficient writes the vendor Realtek driver
performs at init. Replaying a single one of them on Linux via hda-verb
reproducibly eliminates the headphone jack noise:

    hda-verb /dev/snd/hwC#D0 0x20 SET_COEF_INDEX 0x36
    hda-verb /dev/snd/hwC#D0 0x20 SET_PROC_COEF  0x77d7

This has held up across reboots and kernel updates for several weeks
(applied via a small systemd oneshot unit while testing).

Add a dedicated fixup that performs this coefficient write and chains
it with the existing ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN (which may
still be relevant for the bass speaker pin wiring on this board), and
point the 17aa:3912 quirk entry at it instead.

Honesty note: this fixes the headphone jack. The internal speakers
still have noise under certain conditions (notably worse on AC power)
that I have not been able to isolate via coefficient-table replay;
that part remains open. Sending what is verified to work rather than
holding this back.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221203
Fixes: 3a3e810e9108 ("ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT")
Signed-off-by: Viktor Menshin <ripeeerr@gmail.com>
Link: https://patch.msgid.link/20261015132157.57198-1-ripeeerr@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Moved the new function to sit before alc295_fixup_dell_inspiron_top_speakers() since the upstream anchor is missing, and applied the edits to patch_realtek.c with adjusted context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b18eb7974c8eb..726fc58b17ee7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7718,6 +7718,28 @@ static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
 	}
 }
 
+/*
+ * The Lenovo Xiaoxin 14 GT (SSID 17aa:3912) uses the same bass-speaker
+ * pin wiring as its 0x390d/0x3911/0x391a siblings, but on this board the
+ * codec's vendor processing coefficients (node 0x20) are left at their
+ * power-on default instead of being programmed the way the vendor
+ * (Windows) driver programs them. That leaves audible hiss/crackle on
+ * both the headphone jack and the internal speakers, independent of
+ * volume, regardless of which pin/DAC routing is used.
+ *
+ * This single coefficient write was captured from the vendor driver's
+ * own init sequence (via a VFIO pass-through of the physical codec to a
+ * Windows VM) and confirmed to eliminate the headphone jack noise.
+ */
+static void alc287_fixup_lenovo_xiaoxin_14gt_hp_noise(struct hda_codec *codec,
+						       const struct hda_fixup *fix, int action)
+{
+	if (action != HDA_FIXUP_ACT_INIT)
+		return;
+
+	alc_write_coef_idx(codec, 0x36, 0x77d7);
+}
+
 static void alc295_fixup_dell_inspiron_top_speakers(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
 {
@@ -8225,6 +8247,7 @@ enum {
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
 	ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN,
+	ALC287_FIXUP_LENOVO_XIAOXIN_14GT_HP_NOISE,
 	ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS,
 	ALC236_FIXUP_DELL_DUAL_CODECS,
 	ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
@@ -10552,6 +10575,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2,
 	},
+	[ALC287_FIXUP_LENOVO_XIAOXIN_14GT_HP_NOISE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_lenovo_xiaoxin_14gt_hp_noise,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
+	},
 	[ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_dell_inspiron_top_speakers,
@@ -11707,7 +11736,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_LENOVO_XIAOXIN_14GT_HP_NOISE),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TAS2781_I2C),
-- 
2.53.0



