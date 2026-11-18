Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054605;
	b=Pf7WHQDfel/Bwp0AoIB6/4lQQnqpQGwEyaETU8qaqVPXr6LaRp5QnjLqgN66CQi2YJXe
	 JW0q/fc83cYxu7pCoB+qhNNmpclgOfAjZX/mdeeS9ks7GRKHzjoeHLLRbSpa5JG4YBqDY
	 9uGLeGV13AQtpM1yEYduLi0VUH5ZaDLUAfksfgQMuiNH/REKFTfSCGpZ0SqzTg3XKXWCU
	 ch681/ciKK0yOS4pSnHf7PaSW/wQ4gc2lKwae8OVRQWsvTHdhrPMimfX9KDc130itlXVp
	 lnEZRwGpxUJ7lWDXznt16zQqdWsEO7r8kuKLkuFS8pbkQX5dIcGn6yJayoH4fwHrxSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eqHYwnsS8ZbFesjpgURK6lKwBkNeGJJeyyKZA1TlpVE=;
	b=WrudAzefBod+x2k4+ln0xCNRJkawBEkczJQMjKBrZZK+07HKK3Lz8xjY7WoEa/1kc631
	 IjKyzwptyJkFKIWUIIqt8yfbSERI2pT+WlGNRVaFzAX53FmictalN5hmVEpIZnuaih/b/
	 Cv8A3KsjnE0HOf1WF6xgkC9yHLr1qVotdSMadT/tJ/QfNvwyL8K2+nsOpQgxhhsqheW2+
	 BdubqN1TM6SNUvVt30LtkCUlciMKmC4GWIknJ+w+rUEVs7XNxYUuQgfCmn/6X09wlH8rH
	 8a5BMWCVJ+pl8OPWNh/GjnG6GiKnj2N9ZXZNsN3MgnS+RzKNtMe+vtp5Yx1R7tS982A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AGkVZ43C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F51F606A31C;
	Thu, 19 Nov 2026 02:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AGkVZ43C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F30D1F000C4;
	Thu, 19 Nov 2026 02:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054605;
	bh=eqHYwnsS8ZbFesjpgURK6lKwBkNeGJJeyyKZA1TlpVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGkVZ43Cllk6zDwMYYgpzV+WXH/xZZK0HViYOtAI0XFq+HIbUl24d//RESEkeMTvT
	 OdOQfmTjIBGBCjBLTJsyQ7Lp82Fvn6rbY4D1BaXojFieKpsE2Sh/nsdv+Dt99CO1Oh
	 8TJ8S5ipUo/SEgv5v+Fjyldm1mksyPUTaJbBNVrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1294/2214] ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P
Date: Wed, 18 Nov 2026 15:49:30 +0100
Message-ID: <20261118150103.309566497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>

[ Upstream commit d933955c456e0573b40eae4f72a3af37ab1c15c3 ]

The Acer Aspire AL16-31P (Intel Alder Lake-N, Realtek ALC269VC,
PCI/codec SSID 2782:1718) has its internal speakers wired to pin 0x1b,
but the BIOS marks that pin as not connected (0x411111f0) and only
exposes pin 0x14 as the speaker. As a result the internal speakers are
silent while headphones, HDMI and Bluetooth work.

This is the same layout as the Infinix Y4 Max and MEDION E15433, which
share the 0x2782 subsystem vendor. Reuse their fixup, which configures
pin 0x1b as an internal speaker and limits the internal mic boost.

Tested by booting with snd-hda-intel model=2782:1705: the fixup is
picked, pin 0x1b is used as a speaker output, the internal speakers
work, and they are muted when headphones are plugged in.

Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>
Link: https://patch.msgid.link/20261017005039.9139-1-gamaerry@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: adjusted insertion context to match the existing snd_pci_quirk table ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index dc2fb0a319c1a..66ca1f6988d71 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9722,6 +9722,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
+	SND_PCI_QUIRK(0x2782, 0x1718, "Acer Aspire AL16-31P", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-- 
2.53.0



