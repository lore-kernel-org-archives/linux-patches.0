Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D3082488;
	Wed,  7 Aug 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043089; cv=none; b=ULwAFdSz7IpUvmcUQ1GJTDtZSahO0UIlxIPiTVaXpGaAmN11UIgpjvxALolquahZF5vVarUEOe0AHSsMEiXu2s8A7GsiFFH9Th6Sry8Xd2HjlYeoHkF3xI+OvPirRpUxc0hDoCEWDprf0Hts8nm1umtP91HAzpxjAdkGHJPLAe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043089; c=relaxed/simple;
	bh=03DDsG6GwyUbQQ+SpcrSLt9bGYRNBpeQG/Oi4AwlOBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyYzjcC7YYOuCA01V75ypcefY9/K1tbg2EoDy/A7YDglR6NwQod5mzvuPwwwrceD1O6S9EYKy81U2WpDfcAnEacIiCEJ0Z+DxHhQ8CAyZZeSxzfZ8l/XYxqsd1C3OPlMobcwBghLMkENrxseznjKWItT+VSimyGPMb25ykkfUpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJQqEc4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJQqEc4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B990DC32781;
	Wed,  7 Aug 2024 15:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043089;
	bh=03DDsG6GwyUbQQ+SpcrSLt9bGYRNBpeQG/Oi4AwlOBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJQqEc4+7uqujjcb8qM31EsO60YxAE0D87DJ5JLdv9kYXGueNInAA39fIW7boen2/
	 lFds7PFx+9OdTpkLwV6/16PshwknRQMyq0IGjFacAtITUvoHaB9q1DTnbq3H2PwjM4
	 RmAs+g4Ib5odppDp9AW6SZyL0WlgHD2tqi8zeu90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mavroudis Chatzilazaridis <mavchatz@protonmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 086/123] ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G
Date: Wed,  7 Aug 2024 17:00:05 +0200
Message-ID: <20240807150023.598382345@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mavroudis Chatzilazaridis <mavchatz@protonmail.com>

commit 3c0b6f924e1259ade38587ea719b693f6f6f2f3e upstream.

ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST fixes combo jack detection and
limits the internal microphone boost that causes clipping on this model.

Signed-off-by: Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240728123601.144017-1-mavchatz@protonmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9866,6 +9866,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
+	SND_PCI_QUIRK(0x1025, 0x100c, "Acer Aspire E5-574G", ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),


