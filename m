Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051399;
	b=ei5twgh1oQvIan0bNeOKO7GqY7rcpDb6mGfy+jiNihQtw6mEy9sfvSJC05wHqZPU/XOb
	 7TNiAls9PYx7NyD4l2k1iKsHbxpGkXY1Mca/waIcuPbL3ixxzegNt2/hyeU5aA0zXNPNX
	 /Ch+lplapYFxUAvkHoLVhXIkrW9xj/2PhRbqHfCYKuyTHWPDBpwcUTbDEAbfsLSAPxLXo
	 WncgA2rCbq3sQdpzEMKOypjfNMdXCJkbs8LFDzgksyrykz21c2AjCDMNDgEtgDLwgvcnY
	 LFcpFHMSMzCV4T0AXCn7FEy8HaMBtvf9oIkwC2STWSa3C7TdobAcLL7e/KADU3K4YKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4CCqYpuChICuzLKbE4Kb64WX2XugWwwH/ph3Gmp5MLQ=;
	b=LOAXR3AAsDyOHmciCCfY+sC02a/Pjt+LROr63iyX+g94gR4FhWsELhFlCI/tVqj02WiS
	 EimDv0EBckd3aUP/eEaQw2RA/EbtFKwGWPnYyGdxDajxBWyj6UrKiNrGlI/0jgSzVwXZX
	 ATDXcnTTQUE5VEd59lKM8Rzhzx7tvox+qrW2Cu88Q7a90o97hXUcGFkvx13DL6hRFKsfj
	 jePeJvxzhWD8bcGqaU9WSu55s+0PWoMQNb78YsOabepzEH5P1EQUmSPsLpN8Gt6YKueu5
	 bMQlw/WdsuIF6J088K7BKmuY42ziDq7qfFpW2VNm4cMOJS1vQc75V0pcDW+7o+XU8LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApHB67L8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CBD606A31C;
	Thu, 19 Nov 2026 01:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApHB67L8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E591F000C4;
	Thu, 19 Nov 2026 01:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051399;
	bh=4CCqYpuChICuzLKbE4Kb64WX2XugWwwH/ph3Gmp5MLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApHB67L8KjYQOlWVpqB8Bc+AbDw2CP4YqVnHOFMrZE69SAD3PmcEQFu5t3yifk/dq
	 iA1WxVL7mRbMILh4B4Y6hwp0QN0a32AigbWqdqZ6R5qnmZl7tVXG/dwPZMKYiLBgCT
	 /1d81epwS5eftjc+F7wvSY/Exo5KBwFrYJnST1Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0194/2214] ALSA: usx2y: Stop clearing urb->hcpriv before submission
Date: Wed, 18 Nov 2026 15:31:10 +0100
Message-ID: <20261118150017.957675468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a6ed4f0230b7f..b44f951f006d2 100644
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



