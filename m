Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41984FDA4C;
	Thu, 17 Sep 2026 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664889; cv=none; b=LnoOiaAOq+SF3GHR0EPCt+gI4GPfFksxT9Cqpv3gxpukSx5pyOxl030FBaa5I+Ph1S7y3ve/Znot+ZZpqsKFceJ4epDUZ30ATR7YTBt+FwSfX0sJwVuehNZJs4BVVI/piL1OYQvxG+Fwc7ont4GOmuALgLClocjp7ZTFyQrz1NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664889; c=relaxed/simple;
	bh=zr+/1Oonu3UQI8e2iDyditFKLHN1HpBL0dd3olSiAA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gu6wKBvC/NnUCW80UhZ864pK3C1K9O7SR2eyTK0bKzdexBXSDm/PSUL+BcwNrkQfVyq8Wa0fzSyyWReWPHCVFvb0OwcioAEUPJfoyLreGqdr/si/EP+F/Uc0JMV7+G1PI4l4yAVelUXznKF520x9oYhKBa6Q9ZRTJChK6gfPHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LI9ka23g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LI9ka23g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160EB1F000FF;
	Thu, 17 Sep 2026 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664888;
	bh=EMXPmppOHL6mCktgbCHkHdDvu6nzV7ZOEYFR2dGSy50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LI9ka23gzxy9OZbh/uxjbDEZOTj3oOf3TrjaUS5ZQBO5H9ahsSjO1Z6p0/8VMw6kq
	 caFDfPsDfuGraOHjLdmH7s362J/NJYxdP5PrSGWimhtUJEJIVS6Xq5nHKjzqKi+1AZ
	 0Y/e8sCt+cJDqcY6mfljSP1KM0cqn7zL6wwuOin0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marcel=20K=C5=82os?= <marcel@marmak.net.pl>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0523/1250] ALSA: hda/realtek: Add quirk for HP EliteBook 830 G8 (8AB8) to enable mute LEDs
Date: Thu, 17 Sep 2026 16:05:18 +0100
Message-ID: <20260917151606.120989094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Kłos <marcel@marmak.net.pl>

[ Upstream commit 728d34ebf91c0e80b63a66b237dd0dfc5a8e5b4d ]

The sound and microphone mute LEDs do not function on this newer
revision of the board (8AB8) while they do on the older 880D models.
I have verified this on another laptop which was manufactured before
the one with the issue.
Added the ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED from a G9 model, which
uses the same codec, to make it work. Tested on kernel version 7.1.3 on
the aforementioned newer revision notebook.

Signed-off-by: Marcel Kłos <marcel@marmak.net.pl>
Link: https://patch.msgid.link/4dab5622-9100-4730-8c99-b58da939549b@marmak.net.pl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index d77239a03f259..bf7d4793d8725 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6877,6 +6877,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ab8, "HP EliteBook 830 G8 Notebook PC (MB 8AB8)", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ab9, "HP EliteBook 840 G8 (MB 8AB8)", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0



