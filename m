Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10A3563D4;
	Fri, 24 Apr 2026 13:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037663; cv=none; b=m8hPGpGdIqqYNTnk9LSqLsRFczDKkLD3MycGWsHxMkZ+nVgDZgPirMKakmTXilErFcxQDOiq872tCqOZWOipw1EDLXfX7PPNtcb/bKGs9v3mUsLikDCtyHW1aQ3Mzgt9j/41ixyGE32sY251c8NMBkdAUjtwl4RKvZ/f7UhoUB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037663; c=relaxed/simple;
	bh=a+OS73dV67HOcfoZLZdL5l9mHwvlWS+CV5wHP7m1aE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btpFw7sT9vgNR4iRExIeatscKENcbNSNAzVLmVIGl1zFs2ZH/88jpArzXqQm1GvJddZxLqr3TUXgacknVI8EPEGMCya9ruxsbQNhUMOCn3X19+xF19UqFTHn9BXrMIt9dXsuaEPlvONfVMAM4DQ/BU+a9oPEyl2YXG+C/Gwk35o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6VlKvzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6VlKvzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BA2C19425;
	Fri, 24 Apr 2026 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037662;
	bh=a+OS73dV67HOcfoZLZdL5l9mHwvlWS+CV5wHP7m1aE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6VlKvzzepM7qftVdQQ54BAeNWtayJbJ1um2EXflhAb1c/+Wtju6Qf/zxUytLxPwU
	 EiVpBiY9wmczqZvaGHMt/u+24HvL4/ehTj/ierKCAA4Q2CZAfRnOsSE4vhTGIneubX
	 F32gX26Xh3alW706hL1G9Rm/EaDXZDOlq6vvHWNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Garcia Corona <fgarcor@gmail.com>,
	songxiebing <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/166] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IAH10
Date: Fri, 24 Apr 2026 15:28:56 +0200
Message-ID: <20260424132537.504784036@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: songxiebing <songxiebing@kylinos.cn>

[ Upstream commit f0541edb2e7333f320642c7b491a67912c1f65db ]

The bass speakers are not working, and add the following entry
in /etc/modprobe.d/snd.conf:
options snd-sof-intel-hda-generic hda_model=alc287-yoga9-bass-spk-pin
Fixes the bass speakers.

So add the quick ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN here.

Reported-by: Fernando Garcia Corona <fgarcor@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221317
Signed-off-by: songxiebing <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260405012651.133838-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0ac8846326abe..6ef859f59f8d1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10593,6 +10593,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
-- 
2.53.0



