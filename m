Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC94308F32;
	Sat, 30 May 2026 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158094; cv=none; b=u7+RRJZnYfHEut24JMGJGeqCPnreTPaKVoVXqJOXDjHZDf8yyoEywXUvipPqoC+zbCMZUYkStei0toFZdIWSI/nQOWIXrL5x+gVM4KsK5Oc71TJ9hz/7ZKzyQdAQyLX2vn4HVJ5jDzFZVra1B6MISn0rmvHVeCfs0xOFv/8Ffws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158094; c=relaxed/simple;
	bh=HYaO2a1lhnq3ZFCzG6VFB1lI3ABseC2GnPNpkwD+H+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q26t6tN/V7I24Sbh5UNDbi8ARafcV6/c/zs7dgIMf1FcPXhH9obprytw1J7wOKfDtZugIssQ6oB8cWy2eK8OGxSnMFFkKbdz80foxIg3BNdf8OBgbpfQIFDwGOyKgxnfGn9WjuMqJRCvqvFTMWjhabkGCXdWXof05RAZYHrQaXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REMPlKfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REMPlKfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC311F00893;
	Sat, 30 May 2026 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158093;
	bh=zG4HcQ537h3RlfD2YuOhHXyaV7FNq+Jt4YEApvewzko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REMPlKfpykIWb0eV+YuA7WZE/A+3OycdTPX4h4L/QdHoSQmrFcYqjrmGgC0N6UnCh
	 3dR8N5THWaTQEQTpC6ipO2JPmJpOLs7LObclEpNZ1JM7Z72IOHB8fxNdL1jGlu3h0c
	 fABtP6zAOuq77fa/z9lM5YWyM1wPwzsPtpno5vTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Garcia Corona <fgarcor@gmail.com>,
	songxiebing <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/969] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IAH10
Date: Sat, 30 May 2026 17:52:23 +0200
Message-ID: <20260530160300.991969182@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 82de15e176746..0889dfd80fa44 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10396,6 +10396,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
-- 
2.53.0



