Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D14019EEC6;
	Thu,  6 Jun 2024 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683555; cv=none; b=fR+8bOLMy627dtKl87IPczUjpeN33SWffU9Bp0mxxzcBXPEcV75ZNbqSt4AzF9oC2/TKpJK+lrbGJh5sFi79sLlqN+zVDdBOi0mB1uDEr4P7VtCEUHSwohmGQYZY2y3y6vB3o2pxCmvyQZJd2Kj5lsN6rIs04nqJkuI9EkKTvps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683555; c=relaxed/simple;
	bh=WB31M6Vs2xxfLampbPMpvsjqByiUSXfG0JOMEuvD0OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUcZy63eZaqIdI4bUla97W4qSjzeWwTMzZmEJnkgBzI8Hh6gdRZfLQUl9RROgKZdPhaxHtwv8V1fSLSBwmZQW3t0mI/AGgPq0RsAF7BIhZWjx10+0Hj7ZTwHbbm+5rdPRi0fQz2nWtHdL+cFTEj4H5Nu9wSai0rTo8KARM18K+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m22ZiuG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m22ZiuG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D805C32781;
	Thu,  6 Jun 2024 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683555;
	bh=WB31M6Vs2xxfLampbPMpvsjqByiUSXfG0JOMEuvD0OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m22ZiuG/vP+Ha+TzS5xs/eQjVpQQfIjAY2jSCgxEUnudd3GHS7GXvVJF0g166p1Ky
	 HWMkDt1AYrIOlNtIFpjxWkultASWrKADJtGEkLVNZFeIdOmLdwfzzvQwjGqMavJLZh
	 VG/Ek3BPdbn1B7+W5JGsiEpnQyW7S1HpfgijvQrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 446/473] ALSA: hda/realtek: Add quirk for ASUS ROG G634Z
Date: Thu,  6 Jun 2024 16:06:15 +0200
Message-ID: <20240606131714.462793568@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 555434fd5c6b3589d9511ab6e88faf50346e19da ]

Adds the required quirk to enable the Cirrus amp and correct pins
on the ASUS ROG G634Z series.

While this works if the related _DSD properties are made available, these
aren't included in the ACPI of these laptops (yet).

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20230619060320.1336455-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 2be46155d792 ("ALSA: hda/realtek: Adjust G814JZR to use SPI init for amp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7aa961f613f88..4d7c23b20cce0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9860,6 +9860,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1c62, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
+	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d1f, "ASUS ROG Strix G17 2023 (G713PV)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
-- 
2.43.0



