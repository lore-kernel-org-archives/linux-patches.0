Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034379;
	b=Y6fzMDp5wdIzDSkJG0YaPJhSMwhYCODitX2MMFjruqkzBqaf5XzJghK5NSnUKqqEJqCm
	 XEdPpbELwbwjKenlsDyeMixS4f+kyl2u+7QSXCK8AiYiM8sQ5f9goeO/4K62Q0a1WjvvQ
	 EAs6CrA74xwWWxNbWqraTsLCZDEs09ADz4s84HLzRlYzG+gie+ptDSzB/fKy3ywBwCrjU
	 aIEx2k4ba8Z/qgqw+ZHwb7bGi5gBqu2P+sPlPjYuCc2J/wy9v/LY3qBIz8MbtfnUuoydJ
	 XDHtqvpEVvej4/bP0TOyHjxX+2veHp5T3lp53PuN+3KUFwLIMpXv28kejmlcr3qVcbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gop2q08By5GrrO9IR+RD8sRGEKEDbw66wZNnSrWYSPI=;
	b=33lWTkOqdfmrMhtt5QcaVy4d0Rki/APoFujz5bLBZctgjpESIq50BwBOOCqj94FOqt2a
	 XjluLvmQPT+G/KYftTNJ2LT3PXqrpjaIYySnMitcjv90x0ZjmshjWjHDraTJpUAoyJkN8
	 OcVErEZW1hXxqkBNFDKX1wkx8YcCxTZDNlqu6kfE24iwbepzux8I24UYWBhWZ4PMAMHnW
	 okg1dZ5SD5qxmr+jPPMwulfpPR4lkWjqZc6j5ZKEQuKqcdWwqmFGu3HePgc70uRAzUeB9
	 RtY0TFxGZsR0MbPcHMefE5cM4/BVf3d3ivzt83AgZxmedXu38UxWtxZ/YfTXHvsAhbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX97sjar;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046E2606A32F;
	Wed, 18 Nov 2026 20:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX97sjar
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550621F000C4;
	Wed, 18 Nov 2026 20:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034378;
	bh=gop2q08By5GrrO9IR+RD8sRGEKEDbw66wZNnSrWYSPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wX97sjarypgNqV/5D6M8DzeEN+SG2LpSCB9jHWvAP6DXfM5UAazqvpjwUpUVFqxnb
	 /TG0ni5tz4FZg3/80vFt/QE2wu9kCaVwPxqT6W07WCpC+G4clr9eqQRLYdTNcScmWU
	 IflgcIF75gJ5desDp4O6g5wXO0grJ7thWOXamgJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	renpanpan <renpanpan@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0348/3318] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 14-dv1001TU
Date: Wed, 18 Nov 2026 15:16:10 +0100
Message-ID: <20261118150326.486777773@linuxfoundation.org>
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
index 79fdf52840b84..ce5c948802307 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10232,6 +10232,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
+	SND_PCI_QUIRK(0x103c, 0x8987, "HP Pavilion 14-dv1001TU", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



