Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034118;
	b=qtR/1zPlLCY8RRjVzHUESHGRf1q20rPj1WEIDUnBzT/WjN3xv8hRmc/KC6ltNKD/xUB1
	 22llZfbiIBhk+s+s44G1DBPBxbgPfgotSd4jyGr9dGe5EijTSD0Uqzp5y/WxHzK0/HaHm
	 fTPCDfur8AtpxlSM+MJnYzCCSsXUhB6/XT5zNMZqTfdmbMeL2fQ09p+8YFZB1kd0tw/x5
	 TSBCbfNA6YS6aS4D2PaG7p3EoIx2ZO1BYLgM6pKmx0B5f1pkNZTer18n++/p1OyZaoLWl
	 FGmNjn8CUEoy6sptnrFbUnX8nOmTuPdnrunnNucQzfupqpxiZOOvvs0rWios9R+sYLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LLYQX6Tbpj0s6XOgUeXMQim4Eu7sn3dK7AodTgqm0YU=;
	b=P0cGaR5P2ujxISheYGdMJE7oPOjeOjnhpvyzH4J7eRD0Vy0QRp3HAzwJTn/tb/oPb2yv
	 4UZoTbkCLzBeFaywqFnewlSDnpokaTN6plMgnlD8HI3ZKVQ7pabIHB+VmHwCUotl/uXNV
	 pjp80m9h4azGYtej3osaUQhNVKcrkpBKKz/HphCkCs5kkPxolVSsCPnJBXDvqh8FgV9bp
	 UpG8WmU1Xq4KoOZrrE782hXzsDeEAiW4S9jSvHZollX1s8pElUp2UJlhmEMIqxyHcIZMQ
	 f6c2Uag8jl7AdgotITHkTQFAWUq8WBzqOYV8+mkxz13pnTwajm+4YPgwKV4a8SuYyVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZARZawW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF17606A31C;
	Wed, 18 Nov 2026 20:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZARZawW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D631F000C4;
	Wed, 18 Nov 2026 20:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034118;
	bh=LLYQX6Tbpj0s6XOgUeXMQim4Eu7sn3dK7AodTgqm0YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZARZawW7dMRvfcHKU1CVq3AMA3gSMMAHmxQ5zNqzzvQmpufGGri4pAa23q+atQa/T
	 kFiKuaL421YzUuA9DkhGK7jbHq0zF+wUnskx8DHlXYz5aImW+py/isNzwarqMGmLmj
	 3CcCPyzi+YxSYPWIBFJ3EYkeuNZZZUX7wkKj71p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0257/3318] ALSA: usx2y: Stop clearing urb->hcpriv before submission
Date: Wed, 18 Nov 2026 15:14:39 +0100
Message-ID: <20261118150323.056944093@linuxfoundation.org>
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
index e8c7a9ba4e51d..3a7efa57edab3 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -167,7 +167,6 @@ static int usx2y_urb_submit(struct snd_usx2y_substream *subs, struct urb *urb, i
 	if (!urb)
 		return -ENODEV;
 	urb->start_frame = frame + NRURBS * nr_of_packs();  // let hcd do rollover sanity checks
-	urb->hcpriv = NULL;
 	urb->dev = subs->usx2y->dev; /* we need to set this at each time */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-- 
2.53.0



