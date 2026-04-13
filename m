Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8BE24DCF6;
	Mon, 13 Apr 2026 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096442; cv=none; b=mnG3t2IV+WO8VLjwTgz7L59Q2mj6rbP+jiYFWBFPzyP9f5oMV/Mh2+6pxPscNvO4ekYLBbOMRBo47s0sYuHIjFKKoLEX3X0MQaaZA+NYiqwIJvQCfJirIeaQoFvg6895J2JUWUm+1NYMIUbNcj94+IcfNeLTWCEUf66DpZCBGr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096442; c=relaxed/simple;
	bh=6B4P40mrJjrR9JJq2mW1lrwsWSrwpCN6v7LxDunk/Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpfU8OZzKW/ryFKtZ72PBa0WdDIHLNE6RlGyM5UKp3nZu9iW0DkhgSSs6v94XBdPJ4dYfe0V0dU+4Y5Hf3UkI9ZiZ+tDX64zizncG63zZVJ2j1w1+ZpHMPc9n8TY0ZH7lvpmSQVXN0XzCXN+R/j5cLw4G3djUs6CCuQ8lgYmXiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihT+JYys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihT+JYys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975A6C2BCAF;
	Mon, 13 Apr 2026 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096441;
	bh=6B4P40mrJjrR9JJq2mW1lrwsWSrwpCN6v7LxDunk/Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihT+JYysPlev3OrtvfGjRho3sk/DibeLKXVlMMsLVKygSievQRe2XluxPRAA9fmaY
	 5PA5KTR83Nmgjm935vH7LcLH5+9IArrrREWKfjkJ6cfXYXhJKjJUe24VFBRRvSgSnh
	 q6tYhSE7NQWTSsFWtUV9Y7lmYJVpAKeoguMP16rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Krycki <m.krycki@gmail.com>,
	Theodoros Orfanidis <teoulas@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 05/83] Revert "ALSA: hda/realtek: Add quirk for Gigabyte Technology to fix headphone"
Date: Mon, 13 Apr 2026 17:59:33 +0200
Message-ID: <20260413155731.227064734@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8508e9118649f13f7b857e9e10147b241db615d7 upstream.

This reverts commit 56fbbe096a89ff4b52af78a21a4afd9d94bdcc80.

It caused regressions on other Gigabyte models, and looking at the
bugzilla entry again, the suggested change appears rather dubious, as
incorrectly setting the front mic pin as the headphone.

Fixes: 56fbbe096a89 ("ALSA: hda/realtek: Add quirk for Gigabyte Technology to fix headphone")
Cc: <stable@vger.kernel.org>
Reported-by: Marcin Krycki <m.krycki@gmail.com>
Reported-by: Theodoros Orfanidis <teoulas@gmail.com>
Closes: https://lore.kernel.org/CAEfRphPU_ABuVFzaHhspxgp2WAqi7kKNGo4yOOt0zeVFPSj8+Q@mail.gmail.com
Link: https://patch.msgid.link/20260407123333.171130-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc662.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/sound/hda/codecs/realtek/alc662.c
+++ b/sound/hda/codecs/realtek/alc662.c
@@ -313,7 +313,6 @@ enum {
 	ALC897_FIXUP_HEADSET_MIC_PIN2,
 	ALC897_FIXUP_UNIS_H3C_X500S,
 	ALC897_FIXUP_HEADSET_MIC_PIN3,
-	ALC897_FIXUP_H610M_HP_PIN,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -767,13 +766,6 @@ static const struct hda_fixup alc662_fix
 			{ }
 		},
 	},
-	[ALC897_FIXUP_H610M_HP_PIN] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x19, 0x0321403f }, /* HP out */
-			{ }
-		},
-	},
 };
 
 static const struct hda_quirk alc662_fixup_tbl[] = {
@@ -823,7 +815,6 @@ static const struct hda_quirk alc662_fix
 	SND_PCI_QUIRK(0x1043, 0x8469, "ASUS mobo", ALC662_FIXUP_NO_JACK_DETECT),
 	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_FIXUP_ASUS_MODE2),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
-	SND_PCI_QUIRK(0x1458, 0xa194, "H610M H V2 DDR4", ALC897_FIXUP_H610M_HP_PIN),
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
 	SND_PCI_QUIRK(0x17aa, 0x1057, "Lenovo P360", ALC897_FIXUP_HEADSET_MIC_PIN),


