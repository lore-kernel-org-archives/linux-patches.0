Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DB630C368;
	Tue, 31 Mar 2026 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974843; cv=none; b=pldn7iLU9zee/DM/Q7/XMsxIKQdEBNdd4I7pFWtMOe6g5gCQHLWPTi3yQ25nphA3qtUaAlc7Ko5b7fxO7SQ/YZWBpyxijlILPwJuu8acs6Ay047IKElakNYoXJwY0hBDgmW4pwpEy+MFInW47CK0JPY1p3B+iwEjXqdHhdOxj7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974843; c=relaxed/simple;
	bh=3Yiy82QqZAQ/qzymcuQ+vzmniCYVXY3fZXHPUlJ///s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZNSqiAauYlEjECjwM5VgosatULd4JANVjb32V3L9NJVMX9DPAeICZonPLAIHJLDZ3oV/QP9osVv9Gd+U58VN0/06SdVPjPjFMIxp8OLTT4JRLdo+1bJI5gDGqmfWP0JKu8VOfpoMs05E1Mv2TO4PIDMCFSA7y3NShGdvIVkiB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agzBFRL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agzBFRL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2224C19423;
	Tue, 31 Mar 2026 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974843;
	bh=3Yiy82QqZAQ/qzymcuQ+vzmniCYVXY3fZXHPUlJ///s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agzBFRL0wfAjG5CJ89R4+ZI4rgL5v8/I5svJvkqvQkUOent2Pqeg1T4yhK4Vcafin
	 NEI9WrOMP6Rv82Ol/LmFDRVvDgk8a/Z2pIvyQt//nsabUKLj5smo2LNtXyUWyWAGBZ
	 9M33xZhuhHEBtIGEhS6QFHr/WjwYkhKfY20ePXbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liucheng Lu <luliucheng100@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 066/342] ALSA: hda/realtek: add HP Laptop 14s-dr5xxx mute LED quirk
Date: Tue, 31 Mar 2026 18:18:19 +0200
Message-ID: <20260331161801.323287598@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liucheng Lu <luliucheng100@outlook.com>

[ Upstream commit 178dd118c0f07fd63a9ed74cfbd8c31ae50e33af ]

HP Laptop 14s-dr5xxx with ALC236 codec does not handle the toggling of
the mute LED.
This patch adds a quirk entry for subsystem ID 0x8a1f using
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 fixup, enabling correct mute LED
behavior.

Signed-off-by: Liucheng Lu <luliucheng100@outlook.com>
Link: https://patch.msgid.link/PAVPR03MB9774F3FCE9CCD181C585281AE37BA@PAVPR03MB9774.eurprd03.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4c49f1195e1bc..fcddab2cc54b3 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6940,6 +6940,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89da, "HP Spectre x360 14t-ea100", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a26, "HP Victus 16-d1xxx (MB 8A26)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.51.0



