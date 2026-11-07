Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061049;
	b=ew9drOVFryandLzFXCRejXbbXIVgCT6q0eUaCX1g1gVpWwp9LHnV2twlZjXih/by+Ht/
	 EZi9HPq45ul7N2gxiCor44ryRN4z+MxfZVJcweRpGWHl700JPYaXlCZ6p2lQ92NijbJfl
	 I/Ctai9B/JdlQvV6Kc+5A6UUZg7EwLwYeEzf1wFgYc7IAxCucnLt/E++DiYwKRq0j/IdZ
	 9PSlWJZdaQ9Fc3NXBiz2UnEMF4I+Iear3o/zxY8CJU0E6VAvvQxMqCCBn16FWWTQveAkG
	 pmZ99EVz75hQxJO8YkfeDiEIPHn+LPfcfLDQEnu39Dsd340v3hKwh9ZcMmRYGlCvRWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c6QezkXwlnveSdqdSJ5r1xQSUzem8nhaVME1c+NYBQ8=;
	b=r/27sfKAZL7KhDtVd2ddT5tsmRBb+de4VvX/Zb5+pHgBsZZX8D1FCT2KeFjOtkMt69c8
	 /mbRfFaKn/hNmytecpbNjOAqmX3jmQ4ejAFhMFv/YpuaeS+CLp+Ix5tnmMURDuG3tNG/3
	 4LM9RSat2NsXeKkZ2z+5Jv+VALR+ubWhP0OqfGTE2/Ud8XQDeRNWZkXjdqCJr6+LfQSIc
	 /4bX+mccz4ODgt8c6q4vK5CzT+yLCt6APTT2LS7J0SxlGceq1HESs04qhXK7P1PyFHyjf
	 KcxG5MVUpEDWDS+B3Mkgm7DVTW2Ht7+ejTVm01cX7kCcplb8pNVTTKRMyOffRaWyPag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFHb9rr5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47B4606D801;
	Sat,  7 Nov 2026 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFHb9rr5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FC11F0089F;
	Sat,  7 Nov 2026 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061048;
	bh=c6QezkXwlnveSdqdSJ5r1xQSUzem8nhaVME1c+NYBQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFHb9rr53hjEwJVYrxjdm1QT1o7MGz+aSJC/LiBqbvYxwB4K1SxpSGdcxz/0CRY7+
	 MonZEymEnnB4d0WMKsHFFjGRuWz91JatMgK0HDpi9QoAlDQWvCSWodgsrDi9jY7SHG
	 SLPZBrhK4G7/KUVwap46TG3JXw2pj/sehLPMk6S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Csaba Budai <ilyr73@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0381/1536] ALSA: hda/realtek: Fix ALC700 audio on Intel Hades Canyon
Date: Sat,  7 Nov 2026 08:39:57 -0500
Message-ID: <20261107135008.322809557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Csaba Budai <ilyr73@gmail.com>

[ Upstream commit 1fcccdc20a76b4639b00124cf2a379b837bd2bf7 ]

On Intel Hades Canyon systems with an ALC700 codec, analog audio can
become unusable after rebooting from Windows into Linux.

The affected system uses codec subsystem ID 8086:2073. In the broken
state, Realtek coefficient 0x1b has value 0x4a4b. Setting bit 0x0400
changes it to 0x4e4b and immediately restores normal analog playback.

The BIOS also sets this bit after disabling and re-enabling onboard
audio, while Windows may leave it cleared. Linux currently does not
restore it during codec initialization.

Add a machine-specific fixup for Intel Hades Canyon which sets only
bit 0x0400 of coefficient 0x1b during HDA_FIXUP_ACT_INIT.

The fix has been verified across Windows -> Linux reboots on an Intel
NUC8i7HNB with an ALC700 codec.

Signed-off-by: Csaba Budai <ilyr73@gmail.com>
Link: https://patch.msgid.link/20260821102514.11194-1-ilyr73@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 583dfa32f49fe..cb8f063345efa 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8084,6 +8084,7 @@ enum {
 	ALC225_FIXUP_DELL_WYSE_MIC_NO_PRESENCE,
 	ALC225_FIXUP_S3_POP_NOISE,
 	ALC700_FIXUP_INTEL_REFERENCE,
+	ALC700_FIXUP_INTEL_HADES_CANYON,
 	ALC274_FIXUP_DELL_BIND_DACS,
 	ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
 	ALC298_FIXUP_TPT470_DOCK_FIX,
@@ -8290,6 +8291,19 @@ static void alc287_fixup_lenovo_yoga_book_9i(struct hda_codec *codec,
 	__snd_hda_apply_fixup(codec, id, action, 0);
 }
 
+static void alc700_fixup_intel_hades_canyon(struct hda_codec *codec,
+					    const struct hda_fixup *fix,
+					    int action)
+{
+	/*
+	 * Windows may leave coef 0x1b bit 0x0400 cleared, causing broken
+	 * analog playback after rebooting into Linux.  Restore the bit
+	 * during codec initialization.
+	 */
+	if (action == HDA_FIXUP_ACT_INIT)
+		alc_update_coef_idx(codec, 0x1b, 0x0400, 0x0400);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC233_FIXUP_WUJIE_SPEAKERS] = {
 		.type = HDA_FIXUP_PINS,
@@ -9329,6 +9343,10 @@ static const struct hda_fixup alc269_fixups[] = {
 			{}
 		}
 	},
+	[ALC700_FIXUP_INTEL_HADES_CANYON] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc700_fixup_intel_hades_canyon,
+	},
 	[ALC274_FIXUP_DELL_BIND_DACS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc274_fixup_bind_dacs,
@@ -11720,6 +11738,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
+	SND_PCI_QUIRK(0x8086, 0x2073, "Intel NUC 8 Hades Canyon",
+		      ALC700_FIXUP_INTEL_HADES_CANYON),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-- 
2.53.0



