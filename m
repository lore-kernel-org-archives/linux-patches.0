Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043474;
	b=S1ptVgB7VJkyekTF3D60um3FtTQkQPEx5y3os26g6xoJcWpcu/72cq7fuJHmOOhDOBf6
	 SQl8z/zJOjynrif6src75wIV+gBvw9irgdhi+RI+Ex701FuyRYzR3Rew1T6D/IYYuXNYZ
	 09Qso5AAlWE4n9qSf4MN8CTaJBOGH+gP1XC9c0A8bMxdNZeHIl5OrwxbA3UVVw+T8d9ll
	 Nyjy11tQVoQuNE6O5W73xRfcAeeog3M55o5evH47tyLQDNKoo+Xle5r9KodqkKOksCE9h
	 A20B2JTPt07rRMyCMEvKO/gaH1wCRDHc1G6stbsvidrTpaiQBGltfsyACfCXxSu1g6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=76AeKQGPnBGVEUNVzxUMuemWpvgUC/yVigIlEFq9q2c=;
	b=HmYVPc64ev3rwGhRN801OCBC9EeYNpe64slLJG5iAXrkZ9O2ohv1Jjms7N0tOGY6Kwul
	 XbPX3vKSy5dhkiutGqPM9QprS5kIVSOXWri8T70CJA3ulhVTUFtfc28SPJSVLL/TPE3Nd
	 jf7eF40PRExEu01YqSVB+rOYA2UqZ4pdzp2SIbieBHpTMnCmepnXk+5u7RefcloL21zhE
	 wePmxt5El3b+0crw/T/EowNmmRv4pjiBTYbt+Y8+UqcBEbkvnRyvM3pcHv/u9pd7oi2oV
	 +tcgVVp8tHj4+6wc/IoNLOx1HI1U3xz0QkTA21g9F1Fm3ozAMeD01bdc7U/lEXr5zwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G71S4+yj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476D9606A31C;
	Wed, 18 Nov 2026 23:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G71S4+yj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5350D1F000C4;
	Wed, 18 Nov 2026 23:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043473;
	bh=76AeKQGPnBGVEUNVzxUMuemWpvgUC/yVigIlEFq9q2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G71S4+yjBP0K8PuLYKz3Eurg0BpPKkYPa5ZpD8724sHwQYSuSE9EbO+m1DHhTQ9/S
	 E6doYxniZ5i+ly2AKmPaIxk5Pv1xqlmZiI8FKlModf2hLpvImnINH1egZTpYBi2CXv
	 EVbjxCTdbUDJynxdnk0tiaehDtD6rPWv55j5pvHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0222/2857] ALSA: usx2y: Stop clearing urb->hcpriv before submission
Date: Wed, 18 Nov 2026 15:20:56 +0100
Message-ID: <20261118150209.454743787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit fabae5548149ef5c8a056875d9ebdc38366db539 ]

This is managed by USB core and drivers aren't expected to touch it.

It should only be not NULL on a submitted URB, in which case clearing
defeats the "submitted while active" sanity check in usb_submit_urb()
and may crash the HCD handling the URB and panic the kernel.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Link: https://patch.msgid.link/20260810075728.483c827e.michal.pecio@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2yaudio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 98d0e8edc9832..b4a9019e4fead 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -165,7 +165,6 @@ static int usx2y_urb_submit(struct snd_usx2y_substream *subs, struct urb *urb, i
 	if (!urb)
 		return -ENODEV;
 	urb->start_frame = frame + NRURBS * nr_of_packs();  // let hcd do rollover sanity checks
-	urb->hcpriv = NULL;
 	urb->dev = subs->usx2y->dev; /* we need to set this at each time */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-- 
2.53.0



