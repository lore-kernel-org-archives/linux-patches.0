Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57224E4C27;
	Thu, 17 Sep 2026 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668526; cv=none; b=bVW7BUauSQEDZ/YJ1MPyBYQHQCpoQpgUIzJDJJKztNGC6sBEsTsnwXpnNafKdKArXtFQjkGEAlDnjfjtnTmJ9IHx7mBUzpkseyM6Dxvz7jclPyIS29L+EW9uERCpppP/kmR+6wAUVMvVeTh7N+dfGXgmH4m87ENR3TUBcvqFYGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668526; c=relaxed/simple;
	bh=r2avcuEqCY70Wqgn4eaZ2Tj8btYMGlegWU/vzdsrRMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVxzGes2PKsZMIVOTIvGN8j49IooAjFAj2NZjKjBZfMheE7PXTDiIM10zuaq9AXRGqPc9AsLUo+OswNoTXBISBTcrLp5xRZT6Xko/nGJ29c9DN25IRcydBOEl2rclVmbrQkwWCFLrvPwy4ZCHEaAHcQMLsb5I1bSicvBHbcTZ7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9pxPMH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9pxPMH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E41D1F000FF;
	Thu, 17 Sep 2026 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668525;
	bh=1qek7q2zR/Jkoj3gdslzzc+mhOgI4V1pF9B5tWmqGRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9pxPMH1oLkM/WHv1w+gEIgslh8lbVwUIE5qBEd1jtqHvFdisNydbvXVtG0rJ1geK
	 ANmzx/YSsua9PnDLDRj3OLpRDzNm49bZJkjbjBfL0XEKBGblGgrXOz0+O4kKyt2y2y
	 TNeWgGeFMLc9uHEGxptK1XJgXK6Miny22h4DjU2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Pragosa?= <pragosa512@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0452/1102] ALSA: hda/realtek: Add mute LED quirk for HP Victus 16-e0xxx (MB 88ED)
Date: Thu, 17 Sep 2026 16:06:35 +0100
Message-ID: <20260917151551.034217480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Pragosa <pragosa512@gmail.com>

[ Upstream commit 630c45e92db44b738d1e9224c5f3c032c76a33ca ]

Add subsystem ID 103c:88ed to the existing HP Victus 16-e0xxx
mute LED quirk list.

The HP Victus 16-e0xxx with subsystem ID 103c:88ed uses the same
mute LED coefficient configuration as the already supported
103c:88eb variant.

The mute LED was verified by manually toggling coefficient index
0x0b (bit 3) using hda-verb. After adding the quirk, the LED is
registered as hda::mute and follows the audio mute state.

Signed-off-by: André Pragosa <pragosa512@gmail.com>
Link: https://patch.msgid.link/20260728221129.14680-2-pragosa512@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 58729c8430273..4b0ccb3b48b2b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10967,6 +10967,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x88ed, "HP Victus 16-e0xxx (MB 88ED)",
+		      ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88ee, "HP Victus 16-e0xxx (MB 88EE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0



