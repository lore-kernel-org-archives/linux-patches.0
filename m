Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE4029A1;
	Tue, 17 Feb 2026 20:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361503; cv=none; b=RHdvoT/maXJ3H32xS+RxKpPUE/V3Spi4ZNRoOlDUxssX9R0EhBduPhrlyK2Q0vc5UahOMq275PS7QmEuSEJCicn+DKk6HK14ifcyWUQe2kYPCKJGU6hs4ZAOY0V6dCMBn12bBlxLNKKl1tnxwnlXimtJwchpQ1UTGcv04VY5xLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361503; c=relaxed/simple;
	bh=jiVLG+SN0+wwOhw9F6VXNUKPTplRMWx6w8bjzU4oWi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRJWRk21lQnvgG/B2g45oOVu2U+w3aEeFTLdOIttUVoy9t0v515FxNNFf/n8A0r9St+6AjnoA4hIyWMeQbsg6NUHeQw17t4uycoXg6/11SsLJ1JfKo5c+UR2YyC3DK0HRS46EvR7nsFt5dHMnBobJTyXXnnT7/fbkzCVlZZzFeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6P4Bxzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6P4Bxzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23590C4CEF7;
	Tue, 17 Feb 2026 20:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361503;
	bh=jiVLG+SN0+wwOhw9F6VXNUKPTplRMWx6w8bjzU4oWi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6P4Bxzpt5kLCBCv6e3WBgSEfej60XEXFa397POS2GmCVXKfOZhPW7TMnB8soC78L
	 sBBEDEvqbl1ZVybPsCXIIg9q2D1ShY8hQtX5/6kfsCatdCTJoX80rJ2vuzJElZlIPc
	 gmW0dvXYr4k62ge8IrjOzv/SRe/ALZVcbeJFH0NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 07/43] ALSA: hda/realtek: Add quirk for Inspur S14-G1
Date: Tue, 17 Feb 2026 21:31:47 +0100
Message-ID: <20260217200006.751257337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

[ Upstream commit 9e18920e783d0bcd4c127a7adc66565243ab9655 ]

Inspur S14-G1 is equipped with ALC256.
Enable "power saving mode" and Enable "headset jack mode".

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260126073508.3897461-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2e9efafa732fe..a77f16abc6df0 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7243,6 +7243,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.51.0



