Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F92E280CC1;
	Tue, 17 Feb 2026 20:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361591; cv=none; b=ICshcuy57hnKhUN3ndYiQCsnrOzmqR4kT3vZmIEElUICsss2IRAGj6OYY3TwzpQG5DT9zT40YS6UR7Pe9h0Cj47cnJFPrKM8/n0QfCFbaBKREgQEUL5aEh79NcA7/u9ZKvrTk8bOpWUAXutmIAdsyoPURkyOocLuQpZj2afw5lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361591; c=relaxed/simple;
	bh=HK1q5k2w1XTnNNC4iRrHNRSJShxINFCypeHs/KpU7xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0EKY6tChujAhyJZ2EB4ltolLhcA4RpsxE9ayr89gvzeIV+KMK+O46BO41g6JqJMQgLkd9LOFj2rMa9NY04QJspLcAWi/DbbtoGT4RbGLCiHJYITnU2mv4pUMUSv3fwtYS360s+QGFw2Ua7i/sl+8R9aZgu1IjHp+g3zNovQrHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7tVf2a7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7tVf2a7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9062DC4CEF7;
	Tue, 17 Feb 2026 20:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361591;
	bh=HK1q5k2w1XTnNNC4iRrHNRSJShxINFCypeHs/KpU7xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7tVf2a7Te/5eWGTsS0l5iGy8jkc3JhgiPA90b8UtJHPpWjn0D2pRZvVJsrF48DIb
	 J4pPJaXDRhmSagBMUr6qW3YgE6n22rF44XBZ8WsFDcjyfFR8B5607W4gQKRdXeUm9J
	 Z8eLrHD246tNx1i8rarEb58aI+/IDzCsBrhyZSk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Baptista <brenomb07@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 17/42] ALSA: hda/realtek: Enable headset mic for Acer Nitro 5
Date: Tue, 17 Feb 2026 21:32:08 +0100
Message-ID: <20260217200006.664025234@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

From: Breno Baptista <brenomb07@gmail.com>

[ Upstream commit 51db05283f7c9c95a3e6853a3044cd04226551bf ]

Add quirk to support microphone input through headphone jack on Acer Nitro 5 AN515-57 (ALC295).

Signed-off-by: Breno Baptista <brenomb07@gmail.com>
Link: https://patch.msgid.link/20260205024341.26694-1-brenomb07@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6e7fa47741b0f..5c2f442fca79a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10450,6 +10450,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x1539, "Acer Nitro 5 AN515-57", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
-- 
2.51.0



