Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5033618D630;
	Thu, 15 Aug 2024 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730234; cv=none; b=NZqtPgZbB+zJNouoduwqNv9XdBrwNhOiqJG5Qo9iCqWvVnKFC9jESmaoGO73VjbinwEKrS74T919RZ5gSTHYGGVtxzX+vPBGzQIK6V2NWFoBBE3d4noN7LAm8vUTfG3TzSN+DLTaVMpm8wtJz055Y3otTu3Ck8zcJYX3E67w+c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730234; c=relaxed/simple;
	bh=FCaLqliKHeN8EHThxugciVZEWIYP1VueF7Uszz+urt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtcUI4+TnN9mGj00n3+pWFfzHJ+eULCB1CJ3gTsbAQyNFaeizmsk0UgQR8r90JEzJ1YspSWQ7OIYOXNkFOLmsB+vIvgcLRD0Dref44qIGguKfbVuVd4vF7owz+68QzoEz/uO5uKHQ3XTco68p2e8f1U7l32jR/1Q66q0x6F+lW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDoj0BXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDoj0BXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC152C32786;
	Thu, 15 Aug 2024 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730234;
	bh=FCaLqliKHeN8EHThxugciVZEWIYP1VueF7Uszz+urt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDoj0BXUCF4btRiwqB1PmR5Mdu3Q/Q27nVjgLSwAnUSY/kKtNMjOfmOBGNoNuaFHv
	 0+bziXCQYwxUuKLRj2OfufhBBfEA85xMLL5QxBUb0yEC4+2MbL1aCRD+Ob7tksX4HL
	 teLjMgVWezbbzOqe4oUcj4IP0jf8CTsF/z1utDZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mavroudis Chatzilazaridis <mavchatz@protonmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 346/484] ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G
Date: Thu, 15 Aug 2024 15:23:24 +0200
Message-ID: <20240815131954.786528128@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8958,6 +8958,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
+	SND_PCI_QUIRK(0x1025, 0x100c, "Acer Aspire E5-574G", ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),


