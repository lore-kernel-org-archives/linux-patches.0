Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5D51C3050;
	Mon, 14 Oct 2024 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919756; cv=none; b=jPaMfMZtN4TqmqOiJBdSHA5gqvoAFjQJbjvdMZpSBFxTvpn9etfEnXr0ytbYM8Rrnz8lY4GEWORgT8jA9w/OyuyEYkQIhgFqMX2iE2O8TVy9/e9VQvJwYBQbM0iHszn/VOrmRUZjeOWAYogtFOTXPLeDIs1ELsac3/1//hJNtOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919756; c=relaxed/simple;
	bh=H2NJSzuMmsrG+EmMCqFeAw+cz90LixF74Wu2XHCNNE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nm5pqPgPyeKgdAGn1qvOIh+3mHC126DywYVCpc1+JpbekfEPCPuYd5H63MzNgxl4jfnwc40L8HQsokmuPJMUruzM1ISNViXGWP9YwnHu9xAsfev2xiiitEUXJ2nlNeO9uq0MkL+mkHg86Mez4vpVDBmdEI86/VmjVWtTsfec4+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1bM9ocB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1bM9ocB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D5BC4CEC3;
	Mon, 14 Oct 2024 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919756;
	bh=H2NJSzuMmsrG+EmMCqFeAw+cz90LixF74Wu2XHCNNE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1bM9ocBKATQHPHEE93W/R7SzUnxrbmMnUhCKH8zfNZl9LSzSQ3Brvw51xvHgvYLr
	 0pl47liGJi8G3aRhQF6i77C7ZmIF269CtrslfbdnUUDhqicZyp/hzTzbJgrkl0//wf
	 6VKmXv80dcsWlPUyU07bDlAgfLeU7ZcKSCQyufmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jean-Lo=C3=AFc=20Charroud?= <lagiraudiere+linux@free.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 667/798] ALSA: hda/realtek: cs35l41: Fix order and duplicates in quirks table
Date: Mon, 14 Oct 2024 16:20:21 +0200
Message-ID: <20241014141244.269102266@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Loïc Charroud <lagiraudiere+linux@free.fr>

[ Upstream commit 852d432a14dbcd34e15a3a3910c5c6869a6d1929 ]

Move entry {0x1043, 0x16a3, "ASUS UX3402VA"} following device ID order.
Remove duplicate entry for device {0x1043, 0x1f62, "ASUS UX7602ZM"}.

Fixes: 51d976079976 ("ALSA: hda/realtek: Add quirks for ASUS Zenbook 2022 Models")
Signed-off-by: Jean-Loïc Charroud <lagiraudiere+linux@free.fr>
Link: https://lore.kernel.org/r/1969151851.650354669.1707867864074.JavaMail.zimbra@free.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7bb32a98f1761..279857edc0f70 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9896,6 +9896,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
@@ -9926,8 +9927,6 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM6702RA/RC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
-- 
2.43.0



