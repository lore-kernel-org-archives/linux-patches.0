Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019422;
	b=HOqeY1uN1bxvX8fxy+s3BU76CizdlLuVnfzpWRzN3cReBRp9AKxwJIOuPLvOS2Y/XKPs
	 dkk1A0FFRJPmR0JIfb3D+0ZdI6xowGo9SNsfQ2YfNIUvUvLSESv5XCRYrPqRukNCIjZtl
	 65n48f/1pIaj6R0uo6IFZjl6vF+wbLoTlGTgq6ybfXxhsUuJ2DxTBLoIo5VfLCgluBTIu
	 gNwXgaxrtIqOd1YXu95EP4XtYPVRX0O6OtHReAPZrPgvHHYNwTW9XIwbCD7xJgq8y2CX9
	 BbpXTRd7jnkLNpq3c0KByKvit0rHvBqByXfSP+HNyBCmNBJONLLqD56AwHtGT7D4GdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b84qwCpJfcWNFxBIvT7tytWsr75LJCyxiWTQNDGrlx4=;
	b=zmYsZcHLcfwE3tzQhvRV7DrGvDmskbCdEuSTISnUjIBfFXee1lhHyWDUBx2w/BGHMAE1
	 oTLfCSy3RltGA+JYUMfTFbqadZ8bnm7y0gAWzSgNmhi1CSwKE/WrtCtN2xD+D+XcuLpZc
	 l9KWRHpEpTekdQxZqhEFrlajTGvvrS9n+Rmk37Z/1C0GIa3GrsqkJXshFH2E5+50G23qG
	 uBBi7o0YEFl9MI5c8WoWLz1WO4V5kTK4YcBKGT/y1TANJk/KygPAXJKQfMpZ+sr3A1hCr
	 Q07gyJtUWwFKbrGDBhuPFjlLrexdXt57Rtg984PsB8w26roL2fvniCQ7TcUdPI3VnNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhcZl6Kw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560CF60A5BC1;
	Wed, 18 Nov 2026 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhcZl6Kw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A812F1F0181B;
	Wed, 18 Nov 2026 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019422;
	bh=b84qwCpJfcWNFxBIvT7tytWsr75LJCyxiWTQNDGrlx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhcZl6KwR48mtG5eVN0PDMOdb2QBOxdxGIWOh0P6xwtg/Xfp2AXRA47Eauigr36JP
	 mb+r8YQi0qzRZ6K5JRtS78AJJL38aHoYgU/9SXd656ydwkZWtzSXFYM9V0+FFAj3s/
	 wN/bDBxg/pAJ3rblD17Y0QOJiUxpNvrFDxyXpjOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1590/2651] ALSA: hda: Add NULL check for the driver pointer at unsol event work
Date: Wed, 18 Nov 2026 15:47:10 +0100
Message-ID: <20261118150345.145166647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8cbf75d115e97b7f5ba7859d30d0ce74d1af6c19 ]

snd_hdac_bus_process_unsol_events() assumes that the codec driver is
always set when it's accessible from the codec table.  It's true in
general, but in a sheer timing, it might have been already NULLified
at the driver unbinding.

Although the codec removal should have been done properly by the
previous fixes, just for more safety, let's add a NULL check before
dereferencing and calling the driver's unsol_event callback.

Fixes: e7255c00b10e ("ALSA: hda: Skip event processing for unregistered codecs")
Link: https://patch.msgid.link/20261009133341.440917-6-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/core/bus.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/hda/core/bus.c b/sound/hda/core/bus.c
index 9613cd46bd2fe..5ccfa0b6c7ca9 100644
--- a/sound/hda/core/bus.c
+++ b/sound/hda/core/bus.c
@@ -182,10 +182,13 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 		codec = bus->caddr_tbl[caddr & 0x0f];
 		if (!codec || !codec->registered || codec->unsol_disabled)
 			continue;
-		spin_unlock_irq(&bus->reg_lock);
+		if (!codec->dev.driver)
+			continue;
 		drv = drv_to_hdac_driver(codec->dev.driver);
-		if (drv->unsol_event)
-			drv->unsol_event(codec, res);
+		if (!drv->unsol_event)
+			continue;
+		spin_unlock_irq(&bus->reg_lock);
+		drv->unsol_event(codec, res);
 		spin_lock_irq(&bus->reg_lock);
 	}
 	spin_unlock_irq(&bus->reg_lock);
-- 
2.53.0



