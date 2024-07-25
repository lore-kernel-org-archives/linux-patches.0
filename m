Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B42A19B5AA;
	Thu, 25 Jul 2024 14:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918677; cv=none; b=GZXIShRJ/6xsYtlrdCFUv4G0mvf1hAugilqe0Gv9z6JY8XXvrnlWGkT6NVlVlsInT8RY9GewpievOqBBvT3Xvl8SrRARGO41CJ4a7A8KsDbCdWRYYpGDn2JSRnzuJH5PVdk9IfMi7wqCMjaHioYwhJsL+PQPhZaiNMnRIlRtipQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918677; c=relaxed/simple;
	bh=ac/pcMdRL2+Y7ktM+sUNe8TpA1PemjUQBenQs5MtC8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVNYePz6bCgCGEDOkWUShI16dKW0UnZfX2fnnugDWruOTzZz2t6F7G+Hd2IB45/0Dnmr4bFnjDUfteWsKM0Bd8974Axa6QQRNQBL3a+5DgOVygY9p5gOtWjIlUlOOIFe7lYn2dPLsB6+2SbJwvm9Bb3yYgvITBotgmxxYDEKUis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkcdT9n4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkcdT9n4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC92C116B1;
	Thu, 25 Jul 2024 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918677;
	bh=ac/pcMdRL2+Y7ktM+sUNe8TpA1PemjUQBenQs5MtC8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkcdT9n4a7/rvpMg9obJ02PVHIGyTsHIfDHb9PjPpK9kWE3FFIcb/gKl9z3Fv7XCI
	 XdY6kdQtoVSdasSt+PA3WE6AkYimXfws27J6ldzlYN+imyDSTl2yA3vs92ez3RcXLu
	 /Bt9w0/aqHyxYs0bg+9IEvbzkvTqvPKva1pmBF10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 06/13] ALSA: hda/realtek: Enable headset mic on Positivo SU C1400
Date: Thu, 25 Jul 2024 16:37:15 +0200
Message-ID: <20240725142728.277207293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit 8fc1e8b230771442133d5cf5fa4313277aa2bb8b upstream.

Positivo SU C1400 is equipped with ALC256, and it needs
ALC269_FIXUP_ASPIRE_HEADSET_MIC quirk to make its headset mic work.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240712180642.22564-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9928,6 +9928,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
+	SND_PCI_QUIRK(0x10ec, 0x119e, "Positivo SU C1400", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x11bc, "VAIO VJFE-IL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),


