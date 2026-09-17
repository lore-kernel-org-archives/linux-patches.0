Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669B44FDA7B;
	Thu, 17 Sep 2026 17:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664937; cv=none; b=fxpUdEeX4z3ODyBkpjiGthahCc8BanReGsu5LXargjrZ3qLP3uueummTOmy8FgKsOxp7xMcWWRP2tL70p+De7DVxnuBvhG/7g7vUTcWPCHGiSl2KmsFzoW6ECVvRilMytwelD3j0mQsLEaxmb8Stnwo70khd9OowGMJx5g04nsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664937; c=relaxed/simple;
	bh=blmltATNZ1P0nwt7j5Ab14iGFWkXZ71WI3q3KREfcuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYfaXAeQj9bIG9NnmcfpkqPS5tHPc4qw4YPmfJgPFOobbnAEdpYt3BhDJxRZPwt10yqBPhGzGfjG2A0DpxNhlaLJXB8A04gd3WrtPnPOVSs8+1xLF4EulZPjnudVvgroYkSdPovixcJXRl24eGq7BHo7L4GV1yrEne0HX7pK/JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cga7JVmZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cga7JVmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7CC1F00893;
	Thu, 17 Sep 2026 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664936;
	bh=ED1oVriaf5E02+Q2ACRpkmxIkXSaB8SFQCqZ2l8O6ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cga7JVmZAlU0yHNlrFwti6aQtTKCe52XF+ysHvNN8cKu5UmcR8WzFg7Y/VY0F9IeL
	 Hw7pXdvIy8lzdIRvAzrJ/Lqy8Tq+FyIXqQv4+q2u+iBu+9Z4x+HvzOMaSUcaTF1Cok
	 N+7ssvURGoplqnm1zDicfGEFIy2aTFP3p/BrvTj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caio Ramos <caioramos97@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0538/1250] ALSA: hda/realtek: Add HDA_CODEC_QUIRK for Samsung 750XBE/730XBE
Date: Thu, 17 Sep 2026 16:05:33 +0100
Message-ID: <20260917151606.521642918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 740b3c6780ec1f65aba2bc99a3f41d70bdb13477 ]

Add a codec SSID quirk for Samsung ELECTRONICS 750XBE/730XBE using
HDA_CODEC_QUIRK() instead of SND_PCI_QUIRK(), because the alsa-info
report from this device does not expose a PCI subsystem ID, only the
HDA codec subsystem ID (0x144d:0xc824) is available.

This applies ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET to fix sound
being very low and distorted on the headphone jack of this system.

Reported-by: Caio Ramos <caioramos97@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208663
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260720123702.799474-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a2cda3a964fee..e454e164223ed 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7271,6 +7271,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
+	HDA_CODEC_QUIRK(0x144d, 0xc824, "Samsung ELECTRONICS (750XBE/730XBE)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc876, "Samsung 730QED (NP730QED-KA2US)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-- 
2.53.0



