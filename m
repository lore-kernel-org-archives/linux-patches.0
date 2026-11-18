Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043680;
	b=BBl6aH/DKXUPMvahx4z9TRZJ01QtdZfHJXb8teYR2dWyyqmP/8pfodSaLG5tfJJcGCbn
	 9PxPgBdMgBo5/6So8rotf8Iw0dGR+EoclkEe8JRRqgKSEGpKW4i1KQ8cLZVHKgReSQ3QA
	 MBqj9KVwe53YAblBTA/74LuYn4nGr7iLRWgZfZ/ORSZ+8ioFRCAiL3kz6WmPZTgwQ6lzy
	 X3AVPDQ1b17s8MWZMVS4kxZsPtPBOHIua3dBgPoSGpE2+6ZVGkWS0K410gkZLtxJB17N7
	 7KvazUe2pT3vaqIyygdMzfIqnN8IHE+gtC9L2EmaHRvjqwXPZf9QKxmNS3YnqF9fPCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lb1Snd4yT1OE2qhgOX/UDSVKhlkRrplSp6E1tL183to=;
	b=v6Ax0H6/N3zZTkSO/UwBWQVLyv6S800br3a/2t9mdH520lt8LXukALj0Bfa4UFUsrhh8
	 ZEqmTSBK9Cow8U0wSpQQjAOuZw15l8t8hCHXUe9haxsK1uWmJZ1/lOOr2soyRk+rQGhCT
	 SW7F6Az9GvGFNUJU/sDIh7Si3TbfiWTpn1RzseP28ZnUa0yAL2JWLxdPlLMyxI7HD13Hh
	 VU+W1DG0xnVkHTGmbysXV5ndEGCss1crC/87RHo+Wvts7y9Fpf4+O52okxjkIEhizDai2
	 +EBtI8cQU7o218/AEu6D+SOW2T6JqinBTEK9IecKdWeNrwZOa1jirD+oWsJoCyPyheg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6lIArnk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A82606A32A;
	Wed, 18 Nov 2026 23:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6lIArnk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5894E1F000C4;
	Wed, 18 Nov 2026 23:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043679;
	bh=lb1Snd4yT1OE2qhgOX/UDSVKhlkRrplSp6E1tL183to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6lIArnkcE5NpZC56ZP4dHkCahJJzyIgtN8bfGT19RWyPdUCk5owoTP6J31RlCsmB
	 t6siN9NthWz0HC/eERdcx8WSUCC4tcNemc9SR5z/a2ZgrlJtCO+KFH13dnPbxZX2N1
	 SrnMW06/yoIKy8/z9B3uc3NULtN5PpAbhyD/jQSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	renpanpan <renpanpan@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0296/2857] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 14-dv1001TU
Date: Wed, 18 Nov 2026 15:22:10 +0100
Message-ID: <20261118150212.077651356@linuxfoundation.org>
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

From: renpanpan <renpanpan@kylinos.cn>

[ Upstream commit ece609abc95cc0f75e633d93f3d868b030d9a8fe ]

The HP Pavilion 14-dv1001TU (subsystem ID 103c:8987) uses a Realtek
ALC287 codec. The mute LED on this machine is controlled by GPIO bit
0x10, which was verified via hda-verb, but the subsystem ID is missing
from the quirk table. As a result, the ALC287_FIXUP_HP_GPIO_LED fixup
that drives GPIO 0x10 is never applied and the mute LED stays off even
though the associated LED class device toggles correctly.

Add the missing SND_PCI_QUIRK entry to map this subsystem ID to
ALC287_FIXUP_HP_GPIO_LED so the mute LED works as expected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221810
Signed-off-by: renpanpan <renpanpan@kylinos.cn>
Link: https://patch.msgid.link/20260930065504.24151-1-rppxj178543@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f335051628d9f..3d140bc5eb7bd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10037,6 +10037,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
+	SND_PCI_QUIRK(0x103c, 0x8987, "HP Pavilion 14-dv1001TU", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



