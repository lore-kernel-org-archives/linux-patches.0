Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062428;
	b=AFA+X6pgDfuft9pDDZyzashUFX0OkqNPvZNK4nkZ4so1FDNBww3okRkqSa6rJbe8mpn4
	 NrCXrSbU6IfQNTsPpV+EOUyTyr+2t3c+4T+R33byXyRNs767NSOrbTHQzef07++lYqpAm
	 7L8xDZ1ezK0OwCsXE/9KSQ+pnztu45667HABrr5BZ24hPWhafVSesLjKfIodTjCiUk62e
	 AXy/eR+ZDQmnvHcGTbr+cVlphYXrPefc9gEZtlTR3yMVjkWzeWYCsVeQ03R5BdiOcwxzl
	 MypDSu9G6HgvkrIP+rYs7+QcuWkk9SttWdcMpJ79VO769PAS1KJDKHYRQx99bi6Hxtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=701SF4TKz3yp3xlcJUMykKSYJA7cY/LutGQ+QWXpLTM=;
	b=tDszKnyGugv8RAFSF+Q1MuSDRwriPedlJJnacJx5ZdZUjKoqhQaX1IfV4BqQwPZvxht5
	 fSqHqQi+P/KV8sY/s5GN6Sb4V4ecAFF5abr9mwzXzvQvZFvGcAGy6MvjLuowDZzcFe36d
	 pHTvFD0rDZ5LvZhGzUrWbIUZctIROdwJ6MzG51g5pdY8bBJwB4Rx/euP4Pnz53Pi0dQpZ
	 Pj1wSFCl8Z4oyKlANSB2qJ9PSaQB4NLKZdm7IHZrnnYg2wRMg5QAjqy45S3X+e9JsxHOw
	 pfFBvCUh3IuN6SdEocek/ETIk5KEy6v76P0HsY9jqzS897A1wbDt81YZl2ZfVU9T4Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B96prUnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C242E60A261F;
	Sat,  7 Nov 2026 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B96prUnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7162D1F0089F;
	Sat,  7 Nov 2026 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062427;
	bh=701SF4TKz3yp3xlcJUMykKSYJA7cY/LutGQ+QWXpLTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B96prUnu3Ax0k8jYa99CZ2G9wTxa4x8wRpBdFoW1+CDs9YEA0ELqnWspMxdogH7GB
	 dVgtyEzzXC4ZeLQTqQI9pz5XxI89wxo6qQVI/w+SqnkInN8UT3KdZNAY06CmFwyUWB
	 P1/mIyIyu6QZrWfGM62pivCLwpp5c65wHMZW+qZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1340/1536] ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P
Date: Sat,  7 Nov 2026 08:55:56 -0500
Message-ID: <20261107135035.453030828@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index fb79b82e2ea6e..899394885ae81 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11771,6 +11771,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
+	SND_PCI_QUIRK(0x2782, 0x1718, "Acer Aspire AL16-31P", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x8086, 0x2073, "Intel NUC 8 Hades Canyon",
-- 
2.53.0



