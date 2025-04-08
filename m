Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A3226981C;
	Tue,  8 Apr 2025 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116881; cv=none; b=QzcbLkuyXosV5lsOh326NGV56JZKKU4AhwTxzu6J7UZFj2MQAswPnRxP8FEAlnwGejjiZVw8LcTQ+DXn2IGHlCeaXUSR5ImKMJgH+QVwxcm7KwIYRwtKjqbSAoN1J51GouhHDBtbhVROax04pncbhYTB3skyY4qSuW+OUnqsob0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116881; c=relaxed/simple;
	bh=vmHgK7pPAhUyP6YjXzXmxCOtvNhzlGZk/WvJH01V8K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2gPlrYXHmaXID+yITW2mVgPLbmJOOoeSTmqinmZ4Xi2Lc9Z+tRqli8MZr++GYgCh+4PJgbAmJYt203FX/8EL2fLHRVYbRVYLaTLtukWg9fKH9RtNKKV3xJIOmXR6YMHJHKzcSDSNp6wLBjAlobii9SPvaRRuCnpSL8XsI/TWtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mn10oNh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mn10oNh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E81C4CEE5;
	Tue,  8 Apr 2025 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116881;
	bh=vmHgK7pPAhUyP6YjXzXmxCOtvNhzlGZk/WvJH01V8K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mn10oNh/H/aH0Y2LHIeZNUihhu106kvL3aEiP1T4cpm4jFW5JowktdeGu3+emkFeQ
	 pdOg9Nrnx9ZYgmpcAvb7gW8EghBNio8s5bB7uvJ+eHZO8rorp5Rv+IckWMCXyKw8lf
	 YliNysdy6TY+yA/xfg0Z2Ptqd7fSkGJ+YTVas7CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Gospodnetich <me@kylegospodneti.ch>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/423] ALSA: hda/realtek: Fix Asus Z13 2025 audio
Date: Tue,  8 Apr 2025 12:49:50 +0200
Message-ID: <20250408104851.897992833@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 12784ca33b62fd327631749e6a0cd2a10110a56c ]

Use the basic quirk for this type of amplifier. Sound works in speakers,
headphones, and microphone. Whereas none worked before.

Tested-by: Kyle Gospodnetich <me@kylegospodneti.ch>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20250227175107.33432-3-lkml@antheas.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 20b3586e4cb6f..ae6b6186c7854 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10718,6 +10718,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1f1f, "ASUS H7604JI/JV/J3D", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x31d0, "ASUS Zen AIO 27 Z272SD_A272SD", ALC274_FIXUP_ASUS_ZEN_AIO_27),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-- 
2.39.5



