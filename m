Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDF3200A0;
	Thu, 18 Jan 2024 11:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575724; cv=none; b=Zbet9jlldCNxl6JgiAWa/nz3AOv+CoMCafM7wOhiRzHGWYkn4F687ligxYXOWWrs2+EKWy285VrW4Bpfthhs0zo1XxUCmRWf0JNZJ6+MObeb8yxD7fqtP7x0OL9xWmYMvzCrZKGSnp3OYhIxa8tSxk4nphKxf/IAmG/iaAyl3V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575724; c=relaxed/simple;
	bh=SAf1bVKHbAZHSU9VvfH2ZUxLg2efcBfX8qt28z+KsZo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=VvOv0mp9mLCSmtoKSuoiFUArieMR2IdnaLg21lov0CH04hTdpb/U4561cjnWtq5WPfOMBvPa5EaubE6of2ITg961hG9qj/TKCwUy/gyJIh0DBUiH5J7QIWf12QZgKTdtR2C7Zt/86GijgBJnTbx59vw2oQVji62/Ai7YjKQhN4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuygLhKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuygLhKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89B9C43390;
	Thu, 18 Jan 2024 11:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575724;
	bh=SAf1bVKHbAZHSU9VvfH2ZUxLg2efcBfX8qt28z+KsZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuygLhKx6feWwUmpImrHpIJlHAlp3jOuVu4bC/C+flAXVQ+e0me5uf7GzbLL6u8bN
	 Na3wh67rKF48z1hWQBTuyzkdrY3bT/CREfQ3IBjY1GubOkleZmIP9JpMEHizVtqPdN
	 b5Rk9Q4ELbi9WTHjLdxmv/d5kD0jkFYJR7R4GH+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Jason Schwanke <tom@catboys.cloud>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 082/100] ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP Envy X360 13-ay0xxx
Date: Thu, 18 Jan 2024 11:49:30 +0100
Message-ID: <20240118104314.477403435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

From: Tom Jason Schwanke <tom@catboys.cloud>

commit 6b3d14b7f9b1acaf7303d8499836bf78ee9c470c upstream.

This enables the mute and mic-mute LEDs on the HP Envy X360 13-ay0xxx
convertibles.
The quirk 'ALC245_FIXUP_HP_X360_MUTE_LEDS' already exists and is now
enabled for this device.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216197
Signed-off-by: Tom Jason Schwanke <tom@catboys.cloud>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/651b26e9-e86b-45dd-aa90-3e43d6b99823@catboys.cloud
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9607,6 +9607,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8735, "HP ProBook 435 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x876e, "HP ENVY x360 Convertible 13-ay0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8780, "HP ZBook Fury 17 G7 Mobile Workstation",


