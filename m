Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A003793DB;
	Mon,  9 Feb 2026 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647853; cv=none; b=i+t1/8mYL4NShnd9q0DF+vLhMsRVqElwlOkrY4bx1bF1HE99Tx8eaH65M73NDc2wVnb1aX8qvzz3n3opD7sEotxEK2huPBUuZuYVm+mktGyjhMIDka/K9IOhZQk0QcXPGPVmlmNrSQAJiDfeoHMmTeT+CoMz/mW+99a4rGS0vdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647853; c=relaxed/simple;
	bh=KXIP3d4kUHtlzNIT0xlV4kpBbsAo/ae+MoPyaU5xvjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrmiEh5Ziw9mTNEG7l/YI7atCa9gtUJ5y9Bowim1pEot+c20pe1PylFULmWZ3FPCGvJe54v9kmZXM9ydg37BIqGmNN60H4UWDmEPry/JhGGWXHwJ1Ok+tDexO7Ns1aTU7LCzEdoRREtdyKWtC5fyzUF2Vog0fp/7PgZa3OXq5QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7KsRLya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7KsRLya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2307C116C6;
	Mon,  9 Feb 2026 14:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647853;
	bh=KXIP3d4kUHtlzNIT0xlV4kpBbsAo/ae+MoPyaU5xvjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7KsRLyaHcOHWvs+xXc4owCeGhu51UJnM0QdnImCWn3N5a6XN1Czudbt2HgfqGEkf
	 MbJU5pCse3MHzizNuxUS+kxwah6dd3ePHlMMMxjQ2fgbhoyDpYQuPBgv/rfoU4162Z
	 1wLAk743urb/yQpl2kTEDfFAhKny9ijTfHkp/QKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruslan Krupitsa <krupitsarus@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/113] ALSA: hda/realtek: add HP Laptop 15s-eq1xxx mute LED quirk
Date: Mon,  9 Feb 2026 15:23:16 +0100
Message-ID: <20260209142311.893624941@linuxfoundation.org>
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

From: Ruslan Krupitsa <krupitsarus@outlook.com>

[ Upstream commit 9ed7a28225af02b74f61e7880d460db49db83758 ]

HP Laptop 15s-eq1xxx with ALC236 codec does not enable the
mute LED automatically. This patch adds a quirk entry for
subsystem ID 0x8706 using the ALC236_FIXUP_HP_MUTE_LED_COEFBIT2
fixup, enabling correct mute LED behavior.

Signed-off-by: Ruslan Krupitsa <krupitsarus@outlook.com>
Link: https://patch.msgid.link/AS8P194MB112895B8EC2D87D53A876085BBBAA@AS8P194MB1128.EURP194.PROD.OUTLOOK.COM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index dab42dee93018..b99be4602ee7b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10601,6 +10601,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x86f9, "HP Spectre x360 13-aw0xxx", ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x8706, "HP Laptop 15s-eq1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8720, "HP EliteBook x360 1040 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
-- 
2.51.0



