Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031394;
	b=x/6m3QeRKiXzjFE05+jklc7ANqNkuxTbcUNssxD/MNAC4Smb3BeE7Dt/x122T0KXHNat
	 3ncp+hBO+4U1DTFlhjdNTBQTbNmL9B8TSGra0rQ3kCPuBvPvNYfkrbWa8T7qtlT8me+Gl
	 abFNblMhSUwh2mrT4FYJ9HJhh/4fXofBtbMBIuAd1IfxLv23QbV5AHGG0s2w5OQybsw+o
	 +RSLi/72j6J9iavStturTx/viSJp1O6DJbEF+jcGz8QOZDNYdXwoFWnPFN2E0YQOdNPVD
	 m9Qkm31IvoQbdQ841lrkl6ClAtNfo5twNGJirA7WWH7zNmOVvpYnmO8r/iEYQAMBaUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xlUaCB/efALCMlAwo2SNP3MB7JRCYCi0wRCirDThFwY=;
	b=U83WFH1GPdOZwxdlq6TNvBPask4DkHrfxo5lI7/uzUheW31oggEwNKYOXey01Vwc1zGn
	 u3Ud/dlnfEEFcOjapV2CEk4W0k6yI+n/drZTjysjaFbYoxo/U+PKvn8QMXpYG4ufvAfTK
	 jt7X9sGuk3b6QNoYMt8sSFW8T7GkTxqqhz+mw7BiLAqZizvL3I+Yn1q6XQA3T9sqozqnL
	 bqoKi+nqnmWy5dpR2Qv9GD6iSLbMu+O9A9mRmLEdI7UkyKbAECUvgqlVGpxFE/aPgJbzR
	 W+asrnMO8/JXXk/cLEUBlSRgM38hMOkcFxdVy70cqqzpsm5e6lIfKEtMZv7PZcDoygw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2H6+AU4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17381606A320;
	Wed, 18 Nov 2026 19:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2H6+AU4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBC81F000C5;
	Wed, 18 Nov 2026 19:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031393;
	bh=xlUaCB/efALCMlAwo2SNP3MB7JRCYCi0wRCirDThFwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2H6+AU4ZUM/Xvpa/ofTCXxLxXbaAlbRNUyUJMAuYMiM8mJUbN3QvgdYW19NjB60WC
	 6dHQwWTZxMOzgwxAker6hBSRxwqSwE1SJZoXG+BNjgq7ZvDeMXza3rxqSArw9AIBNR
	 O5d5Pb/UY3nQPB1yGCc4CHiioOhOl/xftgSdp3Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1042/1756] ALSA: hda: Add NULL check for the driver pointer at unsol event work
Date: Wed, 18 Nov 2026 15:52:49 +0100
Message-ID: <20261118150051.531645942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



