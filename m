Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7B25111A7;
	Wed, 30 Sep 2026 17:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788916; cv=none; b=EnC8/WlMvE/EbacbAUpMDH3pxX8NCYDs9mzB/+IQBI1Vzq53FfXJhPLKWfI3lcFyhOzqwOdZ33DwrLfUohWMVjO6rPry4mh99dh92plHBEASF00O8ze+Eh9tZ8cUQvDRgzJu0s/ylX0xgsRc2/XpoI3cE98X73cOA0vtRV7QLX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788916; c=relaxed/simple;
	bh=dCVF4ZpRXtYNo8HpOXxz0SvXjw6p46k2NjZa5gWvl8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELriAfuG1Y9FzpT5pTncAbhHE4jWco7C87BcJ/+P2sSKr1NmmIAjHD09dmIqiIScPR297sJVSrZTvXwgYJ3K2FImNdZYypzBcHoRhYO3NCCiuziNQ0xiWuKsSJPePAMaKGY+thyvwFTFNLCNg4vTIR1LNRGK5sPyIP86F1Y5EAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf1GItdg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf1GItdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409711F000FF;
	Wed, 30 Sep 2026 17:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788914;
	bh=zPcmYvQilzfB/fyWj+zRXrFXLSKPZX04pvWcn5IdWIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bf1GItdg2jnOeUNlMhhf+EN/xWGRk179CAkHseQDOzAun5nAJdg1mWlEs9Bhbb9f3
	 1PgFBajRGEUpXfA2TjdPGUV+oB/V3m9Iz5s6mifyVGAmSD6zUk4WY2suxsHkfbM0Us
	 hqIV0x8XQYsAyICuOgWb8bsIN76rFWHvDGSAWM8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/877] ALSA: hda/realtek: Limit Star Labs internal mic boost
Date: Wed, 30 Sep 2026 17:20:03 +0200
Message-ID: <20260930152421.010124176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit 186d4adbb40138e7cb7cffc87a81e95630ced123 ]

The 30 dB internal mic boost is too high for laptops, especially with fans. Limit Star Labs internal mic boost to 10 dB.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/be87292613b24150d6321adac102b4b25d00e9e6.1785532385.git.sean@starlabs.systems
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4b0ccb3b48b2b..e9913767b0b84 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8243,6 +8243,7 @@ enum {
 	ALC245_FIXUP_CLEVO_NOISY_MIC,
 	ALC269_FIXUP_VAIO_VJFH52_MIC_NO_PRESENCE,
 	ALC233_FIXUP_MEDION_MTL_SPK,
+	ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST,
 	ALC233_FIXUP_STARLABS_STARFIGHTER,
 	ALC294_FIXUP_BASS_SPEAKER_15,
 	ALC283_FIXUP_DELL_HP_RESUME,
@@ -10652,6 +10653,10 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+	},
 	[ALC233_FIXUP_STARLABS_STARFIGHTER] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_fixup_starlabs_starfighter,
@@ -11770,6 +11775,7 @@ static const struct hda_quirk alc269_fixup_vendor_tbl[] = {
 	SND_PCI_QUIRK_VENDOR(0x104d, "Sony VAIO", ALC269_FIXUP_SONY_VAIO),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", ALC269_FIXUP_THINKPAD_ACPI),
 	SND_PCI_QUIRK_VENDOR(0x19e5, "Huawei Matebook", ALC255_FIXUP_MIC_MUTE_LED),
+	SND_PCI_QUIRK_VENDOR(0x2145, "Star Labs", ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST),
 	{}
 };
 
-- 
2.53.0



