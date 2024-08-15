Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF041DFFB;
	Thu, 15 Aug 2024 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732654; cv=none; b=igar4lxyFlxLaxpn5Tftael2U3wToQXQwO454SMH1GO7tshpywC4FqoZmkFDUTDf5Br65mDmduLpAnkxIS9DkxQRzYBh1qGnQTRR+ET6LXXkGt9/f0Um5MpQ2x954giSvBXLYiZ8a5fiPSEkapAU8R4mEK4zrmifkIjspXepxgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732654; c=relaxed/simple;
	bh=46QaFxyT5daWqWfmRJ6EkbXHtl1u64zDewv5+7kxr2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzBgwo6AqRvV8tWez15EdgL7dl1b7WbX72ScRNdiKlSjz8i7hT60KIF8oH478zDYTRgmYjA66Wp2g+AkCZMsCGcmMq6C4AEp84yp88TDO1YQiAEm8xL4xndkHfT226aXVCmt6GWp9LgKENPGwEufOlNMGNxEiYKYSFL3+3nlqLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XN/SsWxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XN/SsWxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B91C32786;
	Thu, 15 Aug 2024 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732654;
	bh=46QaFxyT5daWqWfmRJ6EkbXHtl1u64zDewv5+7kxr2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XN/SsWxNQ/ZH9f8r8AKvKYpjjMbqg1UThGDbnvzosF2ibM7qunKGMTotSiWhqxybR
	 KhhIvzHlhrfTxUa1XBYoDobWi2cGkyWW8ihva2L++tHQvdyHLkvnFYJk5e5N1edqDP
	 aBl2j4Y9rKDhPjzPV8ozMKoKL+97azsUiENHJKKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mavroudis Chatzilazaridis <mavchatz@protonmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 244/352] ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G
Date: Thu, 15 Aug 2024 15:25:10 +0200
Message-ID: <20240815131928.869306615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8893,6 +8893,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
+	SND_PCI_QUIRK(0x1025, 0x100c, "Acer Aspire E5-574G", ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),


