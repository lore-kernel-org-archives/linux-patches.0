Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043848;
	b=TUKSsM3l3lTZYf/wXopdAbvgmnlCkNtllGOxxxkFeI5uplk967odONB76Os/wRzpBbdV
	 SXcvUfszqsV/q7CO2aS7TFPSzeuqkkaF75WvMvqCyp8pxYEfJyT5WW7vu2HRirUvYZ4WU
	 Uu5eDW3+94r1DXAgJgN4velTwSZq0hBQYIFh0XMFrqaqn+7rJmInPDLJ5FnKcs1+e3DnE
	 VmshwuRMyRniMFfgWXGQLDGu7tf//NAuMYClznsMjlqgKkJ0/ZDD6Eca9a2oaQWNwSQNO
	 kjHwCGg2Z1ShVcTE6QhzlRjBD3FCAc5t5fZkzqqu/rFsKYYTmX2Eq4xJo9lqp4yJNSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WpdKxaglN7uAXJuCaxiW/nk85xKMCo2zKYyUtQgN2Cs=;
	b=UoOc0N5zeA688mPV2yqdfKan0bA5LjJ3h6/OLxXU6ezSEtnhz2YDXl34zmhJchvPvDXL
	 avJk68iqOgEOulQ4/xe0aGYLUVDk38/zH3ggiopgoiTuv59GSmj6CAE27CbjzMek97Uyi
	 RCkkSkpKJ81JD/ihUd6tkikXlO1C5qGFRXOv42+9oj/zIQGmZMBQMyYuPkkV1KR29WlsL
	 Pc1jdhYlt2r7kzx5to0hXzaeF00KxVe2upYuSyl+mlZzCTD+l+v4MZFrf1H/Mlyze3q4c
	 /Kt/jxit3afxSdgrBTf6AYEDhRHPmR59VNBEHOpPIbrNv5z70OMIiChUSeTIdznkmaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOP6XCQT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A555660A2613;
	Wed, 18 Nov 2026 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOP6XCQT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAF11F000C6;
	Wed, 18 Nov 2026 23:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043848;
	bh=WpdKxaglN7uAXJuCaxiW/nk85xKMCo2zKYyUtQgN2Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOP6XCQTiQ4Jl1bpFpf57uoDkRueO6Ws8s9YAZ6sGdNEaCUWeOcM+lanjPDkpYxfl
	 h08Dz8Ay6bFCe59JeF5/N0OTZvHk37ZS5biHnu8TBi2zj2ztDjuP9H4dlmgmh2UFrp
	 A0oTl1g5L//JO6mjhOZr1NiAwYu2K9GAN/BBUARU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Batishchev <ii343hbka@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0356/2857] ALSA: hda/realtek: Enable micmute LED on HP EliteBook 6 G1a p/n: AD3Q9ET#UUG
Date: Wed, 18 Nov 2026 15:23:10 +0100
Message-ID: <20261118150214.259126703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Batishchev <ii343hbka@gmail.com>

[ Upstream commit e7da28b820d12927de30abf554c727a319f80359 ]

The HP EliteBook 6 G1a (SSID 103c:8e0d) uses a Realtek ALC236 codec.
Without a quirk no fixup is selected and the mic-mute LED stays off.
It needs the same ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk as the
already-supported 14" variant (SSID 103c:8dfb), so add it.

Signed-off-by: Denis Batishchev <ii343hbka@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260810151440.2306217-2-ii343hbka@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Added the quirk line to the single-file Realtek driver's quirk table instead of the split-out codec file, with different neighbouring entries as context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 920d2d65b0be7..e201c9705fb14 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10134,6 +10134,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8d84, "HP EliteBook X G1i", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e0d, "HP EliteBook 6 G1a 14 (AD3Q9ET#UUG)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8e18, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
-- 
2.53.0



