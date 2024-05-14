Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ACFF9D4;
	Tue, 14 May 2024 11:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687985; cv=none; b=RUG9ocCgSk7CGVGs+WxZVko5cBoDuIM9R2r6w5WDd1HSAwso94cR9XU+kJGXWYGwU/fINrFyT1UB+xytqg+t6XR177B9mZ1zMM0IEcFScJ4OOT3NXXVye4KiVRi6pOaNCiHA8h7VLH7U6S+YnJERh1vZRwGz83ZIP0NDhfzUDqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687985; c=relaxed/simple;
	bh=59VMYjlddIE5XZk6Xx7Aw5spS1X773IGZdB8CiwSGc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXytePSFUfCesf7COlsRGQFo2fTB8HXwT1TU1SxjPbxFRscbKheJ6DKcQ3VTfRIOqYAnS7QldlZZT60XBB8lxnNdvIywpmMj85InP4F2aJ7TjzPriqMapfI/0BQhsMgI4/uQj72F4hwfKqyfX0NJ8R5F2nfLF8x0qfsiudMBpvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSEN16RA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSEN16RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B4AC32781;
	Tue, 14 May 2024 11:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687985;
	bh=59VMYjlddIE5XZk6Xx7Aw5spS1X773IGZdB8CiwSGc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSEN16RA1Sfedm7zu3QykCdlbJHUI9qJIq+XCy9uK4j1C7zXT9sn9fmoCvDqIX6ag
	 8D9gVXn11UBavqk5kOlC0OgAV3LWdkeXiXdh3hRiCuAK43ZcZSY4rvswRK6dYAdgUU
	 kfvAQxnTguf9kXbAZs4Oh+14bhZLoH13yoHYriKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aman Dhoot <amandhoot12@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 149/168] ALSA: hda/realtek: Fix mute led of HP Laptop 15-da3001TU
Date: Tue, 14 May 2024 12:20:47 +0200
Message-ID: <20240514101012.386766394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aman Dhoot <amandhoot12@gmail.com>

commit 2d5af3ab9e6f1cf1468b2a5221b5c1f7f46c3333 upstream.

This patch simply add SND_PCI_QUIRK for HP Laptop 15-da3001TU to fixed
mute led of laptop.

Signed-off-by: Aman Dhoot <amandhoot12@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAMTp=B+3NG65Z684xMwHqdXDJhY+DJK-kuSw4adn6xwnG+b5JA@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9131,6 +9131,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),


