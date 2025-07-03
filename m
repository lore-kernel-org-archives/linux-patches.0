Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478DD2F4327;
	Thu,  3 Jul 2025 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555686; cv=none; b=gg44bxCSmnmuBKjWfYy7BFzb0+iGrZ2T2nIetQwTRNi6oGFcWjBcCpXnEC8RoRcPBUYyzqTpGzOXwClolXkN05LuTVA+pqW0lN4x99l1fF2atnAzMphNhGGiGqFczHppDsjwwFScWC06xSZhDyov8DCtpZjF9Z3431h7dgBh6F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555686; c=relaxed/simple;
	bh=EEaqEVkwbBqab7MxfUPp7Joxfo7P32/eBh3q51A8850=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES89DYJvvLsR7jWOgb/J0xM3bWqIwEdDTwGP0w3SIVCXNTdoDzE9sRPS82xoJJtMju4Q5QNGohkYA+dg3bpiFkMBmJmBOWbRKp4F7XUb5u9MbvobijcHJdMLyaDX3Y1gssOOus85zJ47yTrypZoqK7xBvhSVf2N2UjsiKRam+dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6ERewvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6ERewvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A18C4CEE3;
	Thu,  3 Jul 2025 15:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555685;
	bh=EEaqEVkwbBqab7MxfUPp7Joxfo7P32/eBh3q51A8850=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6ERewvcLmnfNR+IFBROQUhy9M83K6G01dJjGQWLVUTVNZiXKcuXGVjnZf0zszPOZ
	 cpy4n0AFAA7+d7y7DHblELxQOCQM4V6ZHlZebJY5J3L5RN9EzI5H/H34QxCBIO0KeT
	 wQgQ4mo2pwmmZQRZ1uh1uSzZUdB2yZ0QZ+L0zp1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Tamara <igor.tamara@gmail.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/139] ALSA: hda/realtek: Fix built-in mic on ASUS VivoBook X507UAR
Date: Thu,  3 Jul 2025 16:42:32 +0200
Message-ID: <20250703143944.640672597@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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
index 82210b1e3b978..0d367cec03ade 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10325,6 +10325,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1e10, "ASUS VivoBook X507UAR", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
-- 
2.39.5



