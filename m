Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041197;
	b=dZlQztbIGP0itkd8fEzEHkB7pUhOPJQ0+8TbgkF0norYZow0FjFWWvS9IWX4dMVY70PT
	 NeBMSEjqdTXQmM5zzqwLROizVO13gQ8wNP9qa/9nDcOvnCcpQXNkAyuKOmMnhmw3qhm4S
	 H7GNb6AZdxkvF6sgZ5x9nlI/MidLbGjaRcFfCsT7UWNr0IrhOSrsCh9J1Hyd+WO874SWO
	 gSYUsB9cUXP5INEOsKxpYgd/8W4BGEUP56wGwUVEJGkDrszntD7Ypl442+dL/1VpSBZHG
	 QuNv44JQYEY93pkw1NlPMhvBypcQEhvA8z39nAo/SddRjaqIIqQFe34w4kO+Ug4XLMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ie7QDioIMJdQ1HpC+LkMALiIHWfRdiMMHezocvfnnEk=;
	b=YZdoQSOQRFnaPUyIDmuOXUBP6Y3WvHxclWXvDI6WzliyXcBjAGXt9ZQ55Yg6cjAH4KIT
	 ZCQ7+TJKr4FFzmqOPMDA/4mZ/pXBOCgDfGRKJ8qfuGAzmrWiXi8vDz63SzrhSeszXSI9Z
	 EQHHSg6kJY/Pn62f/D/ACa168fj8WbdHWrOg9T8HREcebvz7JJMt6FSA85mavIr/dRUiv
	 UCqQbnZGohSl3r2ySIjtpyW3WluYC4FwIwnGf/lIxxwwKtfQ1D0DIdkkA22slsfQxc8FY
	 T0Zjwr2kr7eWXDr0Ofp/lkbC3c870TlUiqggR4wM/jpGEz8HYhy2QIWk1SXm9ezpZkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+j9XT6o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B94E606A320;
	Wed, 18 Nov 2026 22:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+j9XT6o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF5A1F000C4;
	Wed, 18 Nov 2026 22:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041197;
	bh=ie7QDioIMJdQ1HpC+LkMALiIHWfRdiMMHezocvfnnEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+j9XT6oliR/EHdqyY+uktV2n9eHQsk+OvLczQamjdcceG4ujVNiwEDlcIrjOYpvZ
	 Mis1QrjOmibjPgMxlsZNj71f6U8v1VfhQ3UG15/dWZScSoclkFGxa44Err6HXE3y7u
	 uF5LV350lHDQPV7E4Oux2lqze4K4NEXdglfLWdqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2728/3318] ALSA: hda: Add NULL check for the driver pointer at unsol event work
Date: Wed, 18 Nov 2026 15:55:50 +0100
Message-ID: <20261118150442.667045012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/hdac_bus.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/hda/hdac_bus.c b/sound/hda/hdac_bus.c
index 9b196c915f378..ceeb8d6678a19 100644
--- a/sound/hda/hdac_bus.c
+++ b/sound/hda/hdac_bus.c
@@ -181,10 +181,13 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 		codec = bus->caddr_tbl[caddr & 0x0f];
 		if (!codec || !codec->registered)
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



