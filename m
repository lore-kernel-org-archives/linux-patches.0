Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9DC1C9B97;
	Wed, 19 Feb 2025 09:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956283; cv=none; b=jtKJT5p/mFip8X7zM5isaKhTg3NGdGp3Q4DKpU5DPu3KA1Pz/n89GpK+zxA8ufb4Q426ROwFiUr6HXgIwZWqnJUe5LYj8KcKEUZen2pIK64USMWmOLSV4WTFIyp2x+Zv6edFeT+psZ0G4fkQ4QxvjNXmwzL2mJwfkXr1vwuKi7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956283; c=relaxed/simple;
	bh=OzmE0696ugMpJ9XTwQnLF4BbvloWK7N6kUYAPh1/ZCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BULVWiXzhqVG2tqI3hnUishCo92sd9etfbJEGpHEL7iPzNWXKIfvVe0apY2YZ0gHPkVzmFCQdDQ6/Xz0z/LPiwSS4yOgkGZ4n6R5cj8BNLi/u5DHOOoxM3wz0c1lxbkrXcukqboOuqi+MgimUmacEoO9i2oFZNA1jy8Pv0HOUS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vbIIm3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vbIIm3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D811FC4CED1;
	Wed, 19 Feb 2025 09:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956283;
	bh=OzmE0696ugMpJ9XTwQnLF4BbvloWK7N6kUYAPh1/ZCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vbIIm3l43lwxtQGVKa/9ftroR9NHqMULP1VbcLQHSKajC+ekcQhJZc5uJJPQQ7Lc
	 51DxMBltMMxZHwqF1Tp+0VZV+p4j2FZm+ehMDydxhST+YTwA/Yh62TYmxKdM4gA2MO
	 6m5IDyBh4Op20CpoqEaHikHCNYc9saOjF5vaGIuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/578] ALSA: hda/realtek - Fixed headphone distorted sound on Acer Aspire A115-31 laptop
Date: Wed, 19 Feb 2025 09:22:11 +0100
Message-ID: <20250219082657.982885587@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 5cb4e5b056772e341b590755a976081776422053 ]

Sound played through headphones is distorted.

Fixes: 34ab5bbc6e82 ("ALSA: hda/realtek - Add Headset Mic supported Acer NB platform")
Closes: https://lore.kernel.org/linux-sound/e142749b-7714-4733-9452-918fbe328c8f@gmail.com/
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/0a89b6c18ed94378a105fa61e9f290e4@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index eec488aa7890d..8da964c3856fe 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9583,6 +9583,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1360, "Acer Aspire A115", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x141f, "Acer Spin SP513-54N", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
-- 
2.39.5



