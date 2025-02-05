Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6AE151988;
	Wed,  5 Feb 2025 14:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766145; cv=none; b=DChVkM9dMq5xQiWanu+0erTv/OZ9rjKNs4F0TO04OTDt0YLfcmC89aKuhCxnIh2J2SR7OSSqYlTOFtwmUfmGsKBTf/MZQ7QDnBNfgn7V3HzEyZKeBtDBhUWRfo44W5WvKEvOfP/75SclQ5dG8Kuu9qQ7+5u3lPWD8zvTXv5yAu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766145; c=relaxed/simple;
	bh=APqhtl95sGUHAh2OcMWabZoz1U8rZPd1xSUW2bFsnN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odG2elBf12oa+feopMg2Fw8zF7oF8NflS/ywCSdQZWt6Ne3VRzA7DmQJE69Ofdn1Aa9Mg5wXmHm4FK9/unZYabWpZ7TZjangkSJlZCgTPOEl/tR/0fAUQmB0dP4Ij+IXAV3Tgd9xE8hBnkoYfjor+/cQ/vz6Y7gVRABO3r6imJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rerQNf+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rerQNf+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A270C4CED1;
	Wed,  5 Feb 2025 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766145;
	bh=APqhtl95sGUHAh2OcMWabZoz1U8rZPd1xSUW2bFsnN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rerQNf+/EtURVEffq7UAnaK22okgRUUrRlB3eWdbsxCCBQ4yIV0SWs1wWbr0KaUbv
	 QEI+NDF+S4bRnqnvU67UJ+J/mIaqMUGjlwW+52mLzCXalftxINBbVvvN6mL8JWmaB6
	 cdJAkTiEp8cGKaGR+lG9HuCOmfSbp7sEt3pIhFdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/590] ALSA: hda/realtek - Fixed headphone distorted sound on Acer Aspire A115-31 laptop
Date: Wed,  5 Feb 2025 14:40:46 +0100
Message-ID: <20250205134506.409903069@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c4de5a253add..5d99a4ea176a1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10143,6 +10143,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1360, "Acer Aspire A115", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x141f, "Acer Spin SP513-54N", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
-- 
2.39.5



