Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026102;
	b=C554hBedm6aAZjfYDzyPCYbplRHndZ4HBnmvmM1SaBc6yiag4R3eGJcAuv7ozxz4wnvD
	 H+8yWVJjatCEijcLer+EpUFj54OtYSHCFmXIVD1InsO2stAj8v1slbBHMEeu80N4n6tar
	 vopOj38HQuD0n/7dNAfNJSsYUDrVGzoGoxLQk/GJmMSPhW7+6p2Ej/Y5vSqJnYCQiaL7O
	 D7w4aU+oGNUhefj33rbb3aCNbgnm/hQU4i4voEPbZdH/zcIKYLol2uwC2vrWtS+Rd8tye
	 88LNsMhsCHQRzefNWZUeMT9g5lNEbp9o97PhouVvO6SVkMpAHynTM56fvFO5+Mk+N6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NA34dY1VgDfLT+U1w60+/2bazq5A2iUuDl6y4OUJ86Y=;
	b=l4/8uc+K7iV+c7jUw2l+LC5dFnKIAo/Tgxd+zQtbTl2BFgSWwaw1lrIYsQiEW5RufRaW
	 B6z5FFET0y7S3pw10oMhTiJXZUmJ9HUziSmPsC99h+Dl5xGZcS2lZoAB3XlthtNyQjGku
	 V3YHaKl26+dmmc77At62j6SvwjK5veEdLs5pYKuMGTzyPJduIgHwcD95f63zhrhlfbSHd
	 Z38nfy8IfJ9a8Nb4qHtgKRFN6GEqRtyGVM/zKtmic5fQGh2XuHpT/k5oxiBhxGYyBGNuM
	 CF65ns61d+i8KIztQ6zS3K9G1dlYqFLM+aAo1yfCxkhjkQ6hS42bUMv+jP3/DiL7LHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwIJdZf8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53726606A31C;
	Wed, 18 Nov 2026 18:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwIJdZf8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A306E1F000C4;
	Wed, 18 Nov 2026 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026102;
	bh=NA34dY1VgDfLT+U1w60+/2bazq5A2iUuDl6y4OUJ86Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwIJdZf8qaOnVRKKaNOhxMPzIbdkq7VfpfWGs1DoupfZmuY52Ohu/g50Nbfvd34K9
	 Jz7UavIMThaLAkjyS11D2hEZCWiPRhRO/A2W18XNrGogakMbSqh6vhA1u7tJjgUzN0
	 f4VhdDwLt4d9Lg2Y7EAiOblGQY7OSzxOfZwf1Awg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1315/2151] ALSA: hda: Add NULL check for the driver pointer at unsol event work
Date: Wed, 18 Nov 2026 15:50:50 +0100
Message-ID: <20261118150209.994090388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e9c3751a15395..814c90558f042 100644
--- a/sound/hda/core/bus.c
+++ b/sound/hda/core/bus.c
@@ -181,10 +181,13 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
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



