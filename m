Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DDF1F4283;
	Tue, 21 Jan 2025 18:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482433; cv=none; b=mjkv09EjHy4gAQHk7A+0Ra/sJSLkou1nJ+vPqBrR6JBS5pEw65vuXGsSHRfMTsjmJo+cZwm9vphWQpvPFmw1VRFc3vtvSkJCxfCkAr4HSpKUYobdkzWUjsJdZxG1w01nW3TyzaLncW3A6y4x6UBEROZzper1TqejnuKr2OhvO+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482433; c=relaxed/simple;
	bh=SJgD87Ed1Kwf+CQjonBgC9iGyNZU9/muRxeyRAZWw9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8yYkvRpgt7fzIyarIjSLcQ9vwCB2X5SXKHpR+Si2N1sBsvSCmBx/U1b2sgRHbhGfm15RAgk3UupYCaPEtJZk1R0fvkpoINR+sF+oWWSIK/wXgp7OppLWGxLNeMgH+A17IEn66Rqc+IJJBI9riKJiA3z6LxhBC8oIfYrykSSxo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWTYhk21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWTYhk21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3A7C4CEDF;
	Tue, 21 Jan 2025 18:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482431;
	bh=SJgD87Ed1Kwf+CQjonBgC9iGyNZU9/muRxeyRAZWw9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWTYhk219nWkahRnriHSe9ufVDVhwpAUk4f9UqXyBLkHzw82yq9F5D+k8mwwMNqjd
	 DIXpDoEv1Al3hGupjUy1FGHDkiXJ5tbUzRKgbIxPIsBrCZKeUSWxT3mIC4kYVOtnkj
	 sKvlrTHSvA6p/0pbAc8oznMyY6GToy+W/d0IyvYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 075/122] ALSA: hda/realtek: Add support for Ayaneo System using CS35L41 HDA
Date: Tue, 21 Jan 2025 18:52:03 +0100
Message-ID: <20250121174535.883319430@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

commit de5afaddd5a7af6b9c48900741b410ca03e453ae upstream.

Add support for Ayaneo Portable Game System.

System use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250109165455.645810-1-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10979,6 +10979,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),


