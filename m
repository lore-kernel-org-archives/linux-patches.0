Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C7A2222B2;
	Mon,  9 Feb 2026 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647426; cv=none; b=btNtoafdgI93/Vah8QfbSLy/XNDrAj9fekkokz6VGjE66g9foqJYu2O0Y1jYjW+Im39MGdk+80Recrp4hvrpYTXDzp77fGjREcaOccs9wtcOgFArmcmyNGE+HZUZT1ncpvoDB91YJdXHmm7US8oVWUD6hJP7HpUd1vdB1mGleu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647426; c=relaxed/simple;
	bh=apiU+6927U09mwqtQA0FeLB+FJu51pNcImVSmTkztaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZZzvMeS0qdKF55ThZQ7zcXwtNBGy9s9pxmxLVpN4VpbX60WUdmo/U64sC3SX/wIdpsNPmjD648pQrgE8QtJTiKzCcAhYlJL8kyR9mQyUSm/OOqdYNp+/Kfh6j5Uf/Vd8EnGDbSNr7nifT/oeJDnEziecHyU+rRrJXEIz0wljzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZ8O6LdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZ8O6LdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29946C116C6;
	Mon,  9 Feb 2026 14:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647425;
	bh=apiU+6927U09mwqtQA0FeLB+FJu51pNcImVSmTkztaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZ8O6LdKDM+ZekEECBYstgnmZdy10rlJsUa9YPt0jfFy8g7YzlAMkwLZNxs/+RvKn
	 NincmSoPhm8wnk6i+x7xcCOrUiCdekmDoenGAt6OlQQ/QEWAicP1/h+qn/5yzmdQeN
	 ESmwOe8T21qSUU3RnJPNwBJndqL0l16E4TwlWfew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/175] ALSA: usb-audio: Add delay quirk for MOONDROP Moonriver2 Ti
Date: Mon,  9 Feb 2026 15:22:50 +0100
Message-ID: <20260209142323.913610650@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit 49985bc466b51af88d534485631c8cd8c9c65f43 ]

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

usb 1-1: New USB device found, idVendor=2fc6, idProduct=f06b
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: MOONDROP Moonriver2 Ti
usb 1-1: Manufacturer: MOONDROP
usb 1-1: SerialNumber: MOONDROP Moonriver2 Ti

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Reviewed-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB6217911EFC7E9224935FA507D28DA@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 94a8fdc9c6d3c..8a646891ebb44 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2390,6 +2390,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d99, 0x0026, /* HECATE G2 GAMING HEADSET */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x2fc6, 0xf06b, /* MOONDROP Moonriver2 Ti */
+		   QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
-- 
2.51.0



