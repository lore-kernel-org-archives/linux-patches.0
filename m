Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B64E9C3A;
	Thu, 17 Sep 2026 18:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668471; cv=none; b=aPW1qCk5zmIni26pQgGIzCWVGDV7QAuH3Kb33k5XVE+M1DldBlOm8RL7PtDwyEFFRTgd83Yq5pcW2XUhuyGvg1DfBoo/3ixGmz6vlMiuomgAoAmh4UkmEyIWMknSOeqp6XiFbquhao9EVPqLlYr8McUWTlaSJPE73oxyG8H1qVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668471; c=relaxed/simple;
	bh=ULQUp0s+iycodXB53mno+LVHWbLCEbgusrCRG/j/Krk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlJDxF3eDJmEQiSJnvMalTaSbOLtSRz8T2nTp6w+rKJAaAIhjN7qVr0ss1r4dIdqsGffree1iBop3TVXqkuhfHyBsnwNWrz7O6R1QTj+alLtRkTDvn7woWSSQQvFkYKuYKkh9GRujcNvNiyxCbqTYRzXFrYIY1VRMAo/bLCW11E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4gmwS0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4gmwS0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46C81F000FF;
	Thu, 17 Sep 2026 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668468;
	bh=UxeWL8m2noE780gHtg+QGiMtTXlBKNQ7qiaBFQvt1NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4gmwS0x4o16OSKdi0zxGqh8WZS9pc04SY7vbiRDcfZ5NLQxmAiNrGWJGuju0lv45
	 kLD6cZUGLAVIxCSS3zVezyD7ZUl4nJSOm7Sg6viXQnzfC3v4DOX2/mgNU+y1YtiamV
	 0JG9PQ44xnhpnExAOx9c6GZnp0NCjA5F5uOfOlT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caio Ramos <caioramos97@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0435/1102] ALSA: hda/realtek: Add HDA_CODEC_QUIRK for Samsung 750XBE/730XBE
Date: Thu, 17 Sep 2026 16:06:18 +0100
Message-ID: <20260917151550.595302854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d5282a803a19a..70cac100b2064 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11363,6 +11363,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
+	HDA_CODEC_QUIRK(0x144d, 0xc824, "Samsung ELECTRONICS (750XBE/730XBE)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
-- 
2.53.0



