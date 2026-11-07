Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060944;
	b=S9eTDhcXqeOD6NNldQP4GmJ6/okTcak/6c7gyB46QFbewhCbjrbDpGu7k7/tvZBNBnQh
	 bW9c4eSFPq0mu3IEO1WwdU9g/Aq5VZcsBoWXJ5ZAxDLWzmdQCM7gLBHDfjcLwRFOJmAE6
	 va9BDm5Ot+AEFrsOF5j6Ehdek5EGb4/yekzLnC9ySJsdva0wOqNB3o2xdDKfJlEHhCzl0
	 5gcOUupdXXb+yI85TFNe+QXpWdmlBd72PjYLqoNxIPBFIWyocZXCpbX3grDz+IEsCutPf
	 m+wXZdWPbzV+KS8+u9l8jh+mDGl5aDd1nS+acfEiUGYbDHFfwNjtBZCPQMXHT1g/4fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qG+EAJZiW31Ih+oKTVX+WH8WtL70nbwrtAHQBktDJrA=;
	b=hb0WLFgTxlN8P8QZhe775QZYZ9zr47I9AFL+xD1/Su3LEUG38j847S2qqpu5be0eU4e9
	 74GsHzubJNIhsusEeqkReUOwLpL5NkW9rNZjpeMF5N7kGB76M4cx/NPFXowoJ+d+06+jp
	 oJgloIR3WqLP/zfOSNXDreDKDzSj9RhbGJhcHUtm/1BJNbqr2j2xUG3nUenf0PI4JgNai
	 abCzXOAyoQNYTCX4nvCxnhs/DYXDWoPo2YHAgBGJlJHY11UpFsel4V9u0WdGGTN8jHQJB
	 FRCaynIgHcRPU/Hjpk+O+akIiTQuRqHTQ+ZpcP5mbzA6OarSg2XjlvljeDrL8wY9wbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvKaEpSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB12606A33C;
	Sat,  7 Nov 2026 14:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvKaEpSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AC11F0089F;
	Sat,  7 Nov 2026 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060943;
	bh=qG+EAJZiW31Ih+oKTVX+WH8WtL70nbwrtAHQBktDJrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvKaEpSIO4u7tiLDUsTuthQkLEEfZEF7VChPgAVE6Nc9xzvTqPKpjKG/S/SONowkZ
	 8nIlqyWOpZVwHRGsSWC7jtdt7aDfZIVDt/FD9ECUN+8jtfwpqfkO70U9iL9pP7rS7+
	 gdsx5/I+tttqYz6o/x/B1ic1/DRMejOCkT49RpOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0306/1536] ALSA: usx2y: Stop clearing urb->hcpriv before submission
Date: Sat,  7 Nov 2026 08:38:42 -0500
Message-ID: <20261107135006.313985675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index acca8bead82e5..147dd06805288 100644
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



