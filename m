Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C261F75B6;
	Tue,  3 Dec 2024 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239937; cv=none; b=EU0L/MPuTZiDAWiWWcihLnttr409GPRw6/o0+jlHDkhZmtvfrw56QVTM5D7m2lJIGkVlDEzfeEhdsOZPDKa6lvBIk/c9D110YZDDN2UIly1nBe2GlE3aHhpFip6QWrl++e+lFR4AOAZADLGcLoi68JgtgJnaQAr4EWyaUZPmOWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239937; c=relaxed/simple;
	bh=zjcOsR6rMimwhWPN5RCKsOk2nUpPJU0UvYgWvEkRWWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEl1oCItFVl8pQCS/k2wHaExEUS5O0q7eKJzs4oTVTXN/avK5FmkzD1Y+SHdKmOI/3Bp4ZEPZZPBdc5FBU3A3LcrIzGZM5AuwEmUpG2RXvNhgfptUUGw9fNEI1ekly1idD8YiaUtfnPcxV/kevWGPOu2EkQfngyExdxSd7tsIjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0ouJBck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0ouJBck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67C0C4CECF;
	Tue,  3 Dec 2024 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239937;
	bh=zjcOsR6rMimwhWPN5RCKsOk2nUpPJU0UvYgWvEkRWWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0ouJBckEh/aV8v+FoW4dvHbbPuvLYH93Fa5fO8dejxKhAJ6DyPqfYe1LyhsPbcYb
	 WzEThGTy9BSpSBEOZWzP4rSK1RNXV/pCage0+r/3HF+PhycbwQLWfhmQBM/d8kHil8
	 5LzTeJWRDrM+j84z5bnVTahi4/UP8u1Zj2SNUSLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 744/817] ALSA: hda/realtek: Apply quirk for Medion E15433
Date: Tue,  3 Dec 2024 15:45:16 +0100
Message-ID: <20241203144025.038871639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ca0f79f0286046f6a91c099dc941cf7afae198d6 upstream.

Medion E15433 laptop wich ALC269VC (SSID 2782:1705) needs the same
workaround for the missing speaker as another model.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1233298
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241128072646.15659-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11028,6 +11028,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
+	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),


