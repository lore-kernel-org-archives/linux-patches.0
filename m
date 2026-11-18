Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034160;
	b=e88RoenvkR5PmneckkOwZlyJTNICC5bYql7NzqEf+U76SGeKP62odqgeBhIB3v/vKrg3
	 lG0FYCFC6GXMRgB7Ulroud6lmJv2nWmQpDn07V1/fQYJ19j/3bxJNzFDMe86XfU1UsnPW
	 kNCzl38QLS0BwqYrgT7o0sY9PqQs6puaU3glwXFmjKSkFI9mSbxWNZUghqQAz/ANkvZza
	 zM4P4wh2J8e61/zzJuXWuSBqbMqaBnzLzdyGZzH0GtANxWnxNP7eW/dfQzUSFgCk7CWZL
	 9ajl/W9dvll6nwBX7iblZCQkurlOEOPt1ZBl1BdUcvRWMaAwLKf1QslB32AkTtuyl+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xI9Z65mybUSXghorgEYb/yAsRYputr/9hoj9zGgmm7Y=;
	b=nJ8a80RR4Cz3Aod7MfFhR/Ctq798Wbo0RDTAf//eKVwj84CSVMp1J1O3GRc5WasNPMXX
	 9yD4gEPtTUc0Etkx388AOpRBu1kAoXkZkxfN4swgpd8XLknjWZYS6GNYaMRGeYLHJ2fBu
	 s0QnRw4zIBAwwTcsvImsq+kUuo3C991flb/Zx61K/3PzEC7qSAQwPxASL8Rff9WwamEMD
	 PLZwF5lyYFLk4179H05c6GIZTjdaUk2P2ynYyTqdmvtKpDRnAF77vtiYdjVIj2voNrM6E
	 4xqAmFq28OTK2V65yd1CMMStVvVjYCxS+/5ceOiY1mjU1UNJ1lYjfnHGOdUHw3qWAzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWCV7cD3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717FE606A31C;
	Wed, 18 Nov 2026 20:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWCV7cD3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C774A1F000C4;
	Wed, 18 Nov 2026 20:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034160;
	bh=xI9Z65mybUSXghorgEYb/yAsRYputr/9hoj9zGgmm7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWCV7cD3vyEIFMF/BIXpOsxGO0qtg941gdITKlN+vkuZRPd2dPlsx0J5olwrBoaS9
	 wN87psskvEt6yvpoWJsXiuyGktEMZ+sKCSwHK9b8VNoKNOPDWHQQE88qLhMiWsoo/i
	 oFxPODg1MO6PUZPnE2kCXjZAhUYS78TmlEz+grTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Moroziuk <dmorozyk1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0271/3318] ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5
Date: Wed, 18 Nov 2026 15:14:53 +0100
Message-ID: <20261118150323.575699470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmytro Moroziuk <dmorozyk1@gmail.com>

[ Upstream commit 191fe151eb85ff6cb24189fc88c970745497c057 ]

The HP ProBook 440 G5 requires the CXT_FIXUP_MUTE_LED_GPIO quirk to
properly toggle the physical mute and mic-mute LEDs via the CX8200 codec.
Without this quirk, the LEDs remain permanently dark.

Signed-off-by: Dmytro Moroziuk <dmorozyk1@gmail.com>
Link: https://patch.msgid.link/20260812121856.30353-1-dmorozyk1@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 7000245f083d5..8674ef6edf04d 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1111,6 +1111,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x837b, "HP ProBook 440 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
-- 
2.53.0



