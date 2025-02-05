Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19DC149C53;
	Wed,  5 Feb 2025 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764616; cv=none; b=n0pa3+1ul3lBelzezNyEAIZpoShKnuqFaim6Cft0oiaSktomp3GGNPANpTLw0PIiX7oA8pIaNKmXl7E9eHX6l2WrKjyrdS1UVOhFTn5TSeBr0cEhFBwHc9SsuQ7FAiWMnpCD82IEkeQvjeenX3MxDOJWBDAdsevBa6xP13oUq9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764616; c=relaxed/simple;
	bh=kNPw8/XS4pgOjJkQ+9fzwDFbYbYoNmubXn8skWGXNSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvnkZAuyD2W6T14U3h9YCp00K9371qFAIIWpEJ0HIGlrhXI7ZYonm2mM6amVO6oF5TOblEBtGifg28Y85tC0d9vWM2UbgrW6vByhP/ZR2Xs6yVpHWdW0wR5j97fdnvvbG9nr51Wo3iYSvRGLyV3mQQLPtejD1KIdYx62EejEul4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxy9Pa4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxy9Pa4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BC6C4CED1;
	Wed,  5 Feb 2025 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764616;
	bh=kNPw8/XS4pgOjJkQ+9fzwDFbYbYoNmubXn8skWGXNSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxy9Pa4qS5JpgAOmLSL+pccsx3gzKhZqA+OYU4Ux6SeILjf342kSPUderSSDrE+Tp
	 gRGP630rm/BMF2Xbu/lkEZz3C3ijhaFEHb14BCELqx6dySTt/As4SUmRQ+oPTNx9OY
	 I+VnsPUkyLXDnxDZpQnEqe2LeLNvRQkccf6ZnQLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/393] ALSA: hda/realtek - Fixed headphone distorted sound on Acer Aspire A115-31 laptop
Date: Wed,  5 Feb 2025 14:41:46 +0100
Message-ID: <20250205134427.452316090@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 739f8fd1792bd..0b679fd1b82ab 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9726,6 +9726,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1360, "Acer Aspire A115", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x141f, "Acer Spin SP513-54N", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
-- 
2.39.5



