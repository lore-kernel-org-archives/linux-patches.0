Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043677;
	b=fSQ6l9RVpqQYfrQTvuOY/P6UgVlzt1ujIFgR7h3O60x+uBkXzWnVVk6vFYUxKGdBS4wW
	 SrSYwU+0+R13xuXBzh8FGcr2a2Igcd1oa1/QX8Vd1XDTyNk/SVBwGUXa4qMo+cWS4a4mL
	 yOSraa8Ch8pxEzY9RIk2Uv7IWG5+uK0PfUg+KUF9ZXWCnvFK3ekFfErsETDl64qoiJTqi
	 tQXwpOq75P0UqHlAHDEJvdhmxi3XSMzwK3jEyuwGLFUoxjw53eMRxx3zvbS5A/C9JN6+7
	 dT7w5KLxqNzzMoal5CfyMEn50YNQlSkjNA2Hr/JWwY+1wXt6VCH9foulkEexM2sZ6EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AxsYoZ4ItuL4ysxd/dbBSR3/zXpVYWbXJ20p/kTcr64=;
	b=1g5DqRkCpO3jX9KWr2Okn4+rJ6OvWGVrxeuazNqEKbAHtERFpfIOYiuv40tGVUK1D5l/
	 MB1Z0wfHYcpdBTQcxgCpHQ52ewPdUi7769xLCpyDFemhCDtGCTW+0RPoUy4PuvyjwjgRO
	 BWPU1GOSwWBRRFF2SuzBff9u6jmUuDG7WOCeXx7EyhrHWBvw5gbJAVHgLP+2M4YNUMw2w
	 OkGmh+dTsIOF0G0HLGVSNCpi3KrJuIdtSxqR31HRJzLsjtzX9iminLbvDWg5jMIvR7gP+
	 QM2KZWO7gPm4YDpmtBGUNIgTs0oEH7OF0fXH3UZBJtHomEqDDdM4cpV9VshayI19dwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsGX5Ye4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A831606A32A;
	Wed, 18 Nov 2026 23:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsGX5Ye4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F35B1F000C4;
	Wed, 18 Nov 2026 23:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043677;
	bh=AxsYoZ4ItuL4ysxd/dbBSR3/zXpVYWbXJ20p/kTcr64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsGX5Ye4/DbD3Ole+xF4C2ie9aSIon55Vcd8tf/GLQeWJcdhUxFRF6U9no4JVYqch
	 X4r0Ab6xzjXYaxYacI7qhBW7jHMKN34M+3dVaGMOSViz5uwUUrCJ37GKSIMb/c6DpF
	 LkZGZ2onOvPt8V+FrsfSFw4jo8h1KKoEsENFzcp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0295/2857] ALSA: hda/realtek: Add quirk for Acer Nitro AN515-45
Date: Wed, 18 Nov 2026 15:22:09 +0100
Message-ID: <20261118150212.041972277@linuxfoundation.org>
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

[ Upstream commit 0d90a929836344f1d3b39f22f08ccecc62378a59 ]

The Acer Nitro AN515-45 requires ALC2XX_FIXUP_HEADSET_MIC to make the
headset microphone work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221925
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260921124450.639601-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4fe3e5c7d77ed..f335051628d9f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9796,6 +9796,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
+	SND_PCI_QUIRK(0x1025, 0x151e, "Acer Nitro AN515-45", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
-- 
2.53.0



