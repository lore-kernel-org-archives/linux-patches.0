Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043449;
	b=MMeW18CoBeepJ2f+b9quXOOia/710zdaUZS55wT1GvAymuZyidsDe6m/vCjTrckuVrk6
	 Baxck3wvbzrsPRT0zVTNetyzMKBqIjVfTkPdF/Zo8cGsY8CdPeEbMqLI1h4TaeKEhEQGv
	 lSLs0NrcabY6+LDZRp/IkhxKuGvSJw6pDC+bTHE3qKRj0cTtlVnZ6MgeAdmOAeXdhY98M
	 pQfzlT0GTrL+EIW3zmVpiQeF4gvSaCsS98pBg5EuWvLxxRHHl/G4ILMp0A8aFW5860MuU
	 zeltNDHFwjPrVm7ExdbUsr00sRHBPHIgwaLrODTGgh2SbjJ7hbJ9Z+D8eOezS6MXxdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L8AOGSkHyNgyGIETBAgq7IJWJH6jJaXDQaHZ468Jnos=;
	b=PCSS3S7UkhbtMmx3g+TP6QkjOogmMk5NXamCRVca1o1+2VNbu2qwikJv5Lf62llOvTs7
	 25I+fD6pQnZgYQckrVQWJRmarkNDAIZGopswud3Kw8h6i1wQKCn33DO+jG59B8laH5q33
	 VsLt7vYwXL7Cv1Lif1RDK7UGZqYrdd15Hxvnzankydfwv1ZlQFJXg0QusYOFqa1gEYwSJ
	 FvpHMtkKqbjBItw18L5Or92NCt37OujILsPl03+Rs/FQbfB6r4cwiRipznGU6O97/7C8a
	 xoPHtyZHYaENaYn4ZF+6Myq5u/cgKSo1+Y3y7sh02H9TYnJt417XhB/43gedvlT6bMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=szN+2rnd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF35D606A335;
	Wed, 18 Nov 2026 23:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=szN+2rnd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF3E1F000C7;
	Wed, 18 Nov 2026 23:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043449;
	bh=L8AOGSkHyNgyGIETBAgq7IJWJH6jJaXDQaHZ468Jnos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szN+2rndoKQvRBwjiJd7WEZwhPVe2cV2Cmfg9ggsfxEdT7s7H8liH/ZXGa6X98xkq
	 cTXrgNh29GnVdWuSBavwwLJZ3eJ+dIbRxRssAONCFxr8nlCMRK5qX/l7FX5SQm85PH
	 78IaBLVPTa4W32pv29uugE9su0EGb164fmPivKsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0214/2857] ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA
Date: Wed, 18 Nov 2026 15:20:48 +0100
Message-ID: <20261118150209.168827604@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit f2d08f3651fb12634347fef2c41687a807a7dcba ]

On the ASUS Vivobook S14 S5406SA (subsystem 0x104310c4, Lunar Lake
platform) with an ALC294 codec, the headset microphone (3.5mm jack)
fails to capture any audio. Adding the ALC2XX_FIXUP_HEADSET_MIC
quirk resolves the issue and restores proper headset mic recording.

Link: https://github.com/thesofproject/linux/issues/5729
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-3-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5fbc25888f3ac..de300e360ca93 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10132,6 +10132,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS Vivobook S14 S5406SA", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.53.0



