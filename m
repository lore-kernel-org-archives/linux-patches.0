Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAE736BCE2;
	Mon,  9 Feb 2026 14:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648072; cv=none; b=gHTgMhIdDIedoRBWwBvCndyHnSr9B8pCZxXbbjUxBwbKjRYrpduHarK04ImxgepujgXVJDm02regoxbkTnE4NwBz5KCqE0RSTbPBw8JQAd+CYciFa5XKr9lIBmrPSzZBwPrG1yhxaD6iIz0GAd/zjnLNXw17/4O5cqc/piCvr7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648072; c=relaxed/simple;
	bh=B5hnpbcDyPgPpP2oH1+ZZ9deLnwPhidnehRhO5xaYbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIn9qBbjwe2Z967G/+QrkVDYumBwJkVXvv2Ph350dVoYPAAC5CKxf7bFvFDvsBWO3nlbr5+BbvNabf+OkTYX7RmBi4WLNYrd7Z78p9dv5aNa/tlKkt++8drkKtoiwBT56+zl9LpWpuxmlmEKOAWCf0FQg2DpvsoIq5JBKpmY6WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BiWREMIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiWREMIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B16C116C6;
	Mon,  9 Feb 2026 14:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648072;
	bh=B5hnpbcDyPgPpP2oH1+ZZ9deLnwPhidnehRhO5xaYbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiWREMIPY6nUH+G0vmtNpteNmC6H+DA22EGzWSE+O7sSP92jDbR+fjOTr7PtXd20Q
	 Yifbj+7QrdR4IUmF3JSjPoemb6qqRDRoNaqHhJ+3ztDwp7kDj1L54ruVvOmsz4bHz/
	 PTplopnV62ScJxyZ9Ahu1KTMvcWMSY2ipjF5jRAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 113/113] ALSA: hda/realtek: Really fix headset mic for TongFang X6AR55xU.
Date: Mon,  9 Feb 2026 15:24:22 +0100
Message-ID: <20260209142314.230860601@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit 1aaedafb21f38cb872d44f7608b4828a1e14e795 upstream.

Add a PCI quirk to enable microphone detection on the headphone jack of
TongFang X6AR55xU devices.

The former quirk entry did not acomplish this and is removed.

Fixes: b48fe9af1e60 ("ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU")
Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260123221233.28273-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11368,6 +11368,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x1409, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
@@ -11834,10 +11835,6 @@ static const struct snd_hda_pin_quirk al
 		{0x12, 0x90a60140},
 		{0x19, 0x04a11030},
 		{0x21, 0x04211020}),
-	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1d05, "TongFang", ALC274_FIXUP_HP_HEADSET_MIC,
-		{0x17, 0x90170110},
-		{0x19, 0x03a11030},
-		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0282, 0x1025, "Acer", ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 		ALC282_STANDARD_PINS,
 		{0x12, 0x90a609c0},


