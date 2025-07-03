Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32972E7BD6;
	Thu,  3 Jul 2025 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555100; cv=none; b=q2Od/FS7CZTD/RTZ1O6cHCi+hh2Rn5FVC9fKiLVkh7D/XhJwH/qCZq+Tvou2Q0eVF7wYVjFIauANG+UT0BNdNsAOc4tdePkxf3Z8pHMbi95VELqTrLUujXQ2oVVJshRqaPGQeBIdzcEI/ZPtPdPXa3UF3wS4gkAGscaSIY3mtZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555100; c=relaxed/simple;
	bh=IjiQR7MHaqfZUE7R70NvZ24OLsrqv8l8fUqN7315HB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL6zmX4SZ6MxlQ6/Cm/THQJVPEoSzY+KxAmsx2EkcqdGBIFbV1Wb9AbfEDaTlkmbbGLlV5jowGH7BotI4CS+SZojtAqlJiM7WCFZ+0uoTygPPo3p+WyHNoXRJvzUQFZ60xzkrALq6HtAec6JGIO7Q0zWzIuqnQvL+XAB5iktS8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6mElV2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6mElV2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53471C4CEE3;
	Thu,  3 Jul 2025 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555099;
	bh=IjiQR7MHaqfZUE7R70NvZ24OLsrqv8l8fUqN7315HB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6mElV2kl1pe0NibHyYqbSitags09iVDxPquQd58WXkYavvPJoFb4Lu7SIfkzZZHN
	 gGl7paodJfaH0LLhlPOHpjNnwlWPHcjka5QwNkImcosg7eHQIULja24KBFKIkh0Bmg
	 BU0ORMnq0Sx4xPqPt8JOkMC8Pq25tRhnIXh921qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Tamara <igor.tamara@gmail.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 158/263] ALSA: hda/realtek: Fix built-in mic on ASUS VivoBook X507UAR
Date: Thu,  3 Jul 2025 16:41:18 +0200
Message-ID: <20250703144010.697677260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salvatore Bonaccorso <carnil@debian.org>

[ Upstream commit 7ab6847a03229e73bb7c58ca397630f699e79b53 ]

The built-in mic of ASUS VivoBook X507UAR is broken recently by the fix
of the pin sort. The fixup ALC256_FIXUP_ASUS_MIC_NO_PRESENCE is working
for addressing the regression, too.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Reported-by: Igor Tamara <igor.tamara@gmail.com>
Closes: https://bugs.debian.org/1108069
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Link: https://lore.kernel.org/CADdHDco7_o=4h_epjEAb92Dj-vUz_PoTC2-W9g5ncT2E0NzfeQ@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 02a424b7a9920..03ffaec49998d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11002,6 +11002,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1df3, "ASUS UM5606WA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1264, "ASUS UM5606KA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1e10, "ASUS VivoBook X507UAR", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e1f, "ASUS Vivobook 15 X1504VAP", ALC2XX_FIXUP_HEADSET_MIC),
-- 
2.39.5



