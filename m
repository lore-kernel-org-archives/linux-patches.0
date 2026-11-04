Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830870;
	b=nVdhIUUZTYkxnMbAO6go0TAURyZnx9tZVewa3pK/fGkO/aziKBvgd3sq6k4Dnc4Pi41n
	 X6rh1J0WacsfN8vCQF5c0BcDcTGxE3pklVi+ffOEBg9IGfY34zCsAQXKyG5DRyYNS9/CK
	 Wa+Y5vai+yAwpQfmkX/sQbm8QY0FpzLCHEg93SafeGZ0tkuirVxPfviz0xE+L/D14YwdD
	 GQQfFmqXhRePJnR2Jt2peRgZp2PjL9Y19i61Lk5an8YdbnuzuTc5V2+JfvYQF6LbSQ8Zy
	 RYs/SngJ3bXZ0VGQ18Qb7wxPSc/yjTp5EB3WJfp41nTzaRVZBuZ7pD9iwp7vycSw7Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yFPODIropwp9b92224xR8z+CI1NfowXoDgC38DLplic=;
	b=OnSjC4kmTB3kNmTkg/dsmdI1XImpw4AQI7/5pL01NKKU9pdxJ85/v13CUhYxoeoXSrWe
	 aA+qrUaBPHbQLrsualvCkGHrbLkieg0bJCiljdHsjYq56qrMamfIjXIxoII5eZ8mnL7uf
	 pIZ6w9XcbLpVUsHo4e3XaW0quE+41mnThxlvMpam6o91+3JtFoPbdJbqE+qCMVG2XM0Oi
	 k/9vECxnmXTAOS3JTBIEChS9zS6dJIB0OsEYYsf9K1Z4J/07oMNEK3HXCN/3NOU13KGnN
	 Td44d4MYgQ3AcBmPwK6YzVLdAQzykCuL4QnLhY7gQlx61eTQezrp68Btk6v7UuucK8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vhmK6DyA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7081F606E819;
	Wed,  4 Nov 2026 22:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vhmK6DyA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0D81F000C1;
	Wed,  4 Nov 2026 22:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830870;
	bh=yFPODIropwp9b92224xR8z+CI1NfowXoDgC38DLplic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhmK6DyA7Ii0EZ40miewowjBDt5wPqdSsJAwEBJ6cBO9U7JqpsOsi2/tM2fIMykw+
	 E0/IW8bS3w/4QW6zRRMSksR1d27VRcZ1GSVwhHencI4BGhjN+wKOAiivN2/nZ/XTBH
	 VqXLFJowxniJOivCHxkN7w2twSbs/vvbe6rsG0Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0371/1005] ALSA: usx2y: Stop clearing urb->hcpriv before submission
Date: Wed,  4 Nov 2026 16:01:44 -0500
Message-ID: <20261104211054.480419716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index c7c7ec9c228b4..1ea181e9bb283 100644
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



