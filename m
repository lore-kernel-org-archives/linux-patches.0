Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590691;
	b=rIpZdFQSgwQfBWpvBI8TJO/rug0qSb9/2pSC+DtGc7Sw++2I3WojEvh8PclRp5B2J7um
	 FkITyS82lSCw91Kfkh2Lm/NfSjUbkWJlEZe0+lt/3sQmbkJn6EJ4YE6NpJZJVy+m0Lybw
	 SbQQBBtr4s9HZJ5vc6CehujKyjfqCyvopIBn9xgl0MidjJFRN5O20Sxlunt36FG/du+oP
	 2saZ0AIh3hFxiAKJAGRC8lqb/xyfi8w6RvCVD2P7pIAJSqVb8937id4nOOH+rS8NQsNcU
	 nLegSy1Df3u8FuEv18kQtxioLy9QmSBzntJ++qNqrI6vc65p9exV9ikxS1LLAJPyz5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dZH8jmKuC7KzCEewSkiagujWTm2dcmUmGYT1VKwCuXU=;
	b=p+dYCXtkgwp2Kbfgsnq6+NRuhXLyvIz9TThU43n/amm24Y+DUZyT3wCZfVfsFLIlv3fO
	 M9boTvfNyqnKm4ppmR1M++iT2bn7ph3nI94l1tP6CuGpVXwm7a4WeSFhGn7xmamvyJzaO
	 K+JfzsHdd+VgMpuhnN5GX4jBAS16Mcr13tHwk+p8glQvrJV8CiSKzWqMCiONW3SKgFUmo
	 LUem0hNsFs3WTUOhKgEq2TpfCgHy9wK+NUVXx02B7y2B6kdmZVztqPpIRqiYLdpDU0NwR
	 57SGNXyFpBzVbhu2yHhLBLkBI9Ccl0RyYmwJ3ldlg5yaLMxAGJ11ZW+SrPrmxFXNMhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Je74W4ub;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58668606CEE0;
	Fri, 13 Nov 2026 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Je74W4ub
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057051F000C4;
	Fri, 13 Nov 2026 17:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590691;
	bh=dZH8jmKuC7KzCEewSkiagujWTm2dcmUmGYT1VKwCuXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Je74W4ub61SDjx1Kai6J927kDQoornt9hDV6ekPtuk3M/Wi1o2CDNGCxUTx74Ejzo
	 vBMJndLouZqp4LOFKVbT5MxxOZfZYFf0mAKd5OWgAMpwinhu+5KXX1C771vZh09FVo
	 5TkMsaIejZoD5ftxSWVTOhflx0CFKPggaAY2wkx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Bonello <hadobedo@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 560/686] ALSA: hda/realtek: Fix Legion 7 16ITHG6 speaker amp binding
Date: Fri, 13 Nov 2026 10:51:33 -0500
Message-ID: <20261113153840.595087602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bonello <hadobedo@gmail.com>

[ Upstream commit dd074f04e04648d89d9d10ae9846cd057c97b385 ]

The Lenovo Legion 7 16ITHG6 uses codec SSID 17aa:3855, but its PCI
SSID is 17aa:3811.  The latter is now also used by the Legion S7 15IMH05
quirk, which is matched before codec SSID fallback and incorrectly
routes Legion 7 16ITHG6 machines to ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS.

That fixup does not bind the CLSA0101 CS35L41 companion amplifiers,
making the built-in speakers silent even though playback appears to be
active.

Add a codec SSID quirk for 17aa:3855 before the conflicting PCI SSID
quirk so that the Legion 7 16ITHG6 uses ALC287_FIXUP_LEGION_16ITHG6.
This restores CS35L41 firmware loading and binds both speaker
amplifiers.

Fixes: 67f4c61a73e9 ("ALSA: hda/realtek: Add quirk for Legion S7 15IMH")
Cc: stable@vger.kernel.org
Tested-by: Nicholas Bonello <hadobedo@gmail.com>
Assisted-by: Codex:GPT-5
Signed-off-by: Nicholas Bonello <hadobedo@gmail.com>
Link: https://patch.msgid.link/20260508225507.47667-1-hadobedo@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 1c36207da794 ("ALSA: hda/realtek: Fix silent speakers on Lenovo Legion S7 15IMH05")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 5bf382eb4646e..ed76281856b1c 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7544,10 +7544,11 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3801, "Lenovo Yoga9 14IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x3802, "DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga Pro 9 14IRP8", ALC287_FIXUP_TAS2781_I2C),
-	/* Yoga Pro 9 16IMH9 shares PCI SSID 17aa:3811 with Legion S7 15IMH05;
-	 * use codec SSID to distinguish them
+	/* Yoga Pro 9 16IMH9 and Legion 7 16ITHG6 share PCI SSID 17aa:3811
+	 * with Legion S7 15IMH05; use codec SSID to distinguish them
 	 */
 	HDA_CODEC_QUIRK(0x17aa, 0x38d6, "Lenovo Yoga Pro 9 16IMH9", ALC287_FIXUP_TAS2781_I2C),
+	HDA_CODEC_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
 	SND_PCI_QUIRK(0x17aa, 0x3811, "Legion S7 15IMH05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
-- 
2.53.0



