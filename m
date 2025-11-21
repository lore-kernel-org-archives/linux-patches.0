Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F534BA5B;
	Fri, 21 Nov 2025 13:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732151; cv=none; b=d7QRXHZQuS+Vt+aWJxSG29gaJTmCUoa7e+ETvksohM0xiTf8UTJuRavwPX49cYPRCFlOaWODy8aFLA1vZu0jKo1FC59wRgBq98o9hwZU+f5zWAkmCXwuMYQFFx3uBuSxG2uCr1GLsaVSCqxeB07LjJjrzOkIcfpsoDT21bUllqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732151; c=relaxed/simple;
	bh=Qqc8lnP0nNW6ZR9TlqpNn9YgjyVTLaP6sA8z+RdFoCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJovyDvOIeLkMp2kPN73wIaPsGVIN+XvK9BOJXu17OTSyZIf21V8Cmw4Q4sIVDx0CVp+crMw7+hFGSy2NU6yjrBp2OV6wST9mc43iFMYeoxPPJ6dc2J/96mqOHa+i1mgT+3QSI7sGrRRSo1dDCcoWf32feHuC4chQvMYMHo0r7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXbmpQDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXbmpQDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BD7C4CEF1;
	Fri, 21 Nov 2025 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732151;
	bh=Qqc8lnP0nNW6ZR9TlqpNn9YgjyVTLaP6sA8z+RdFoCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXbmpQDbTx7bfYMQ/zlyDaQNX1uptuNTdddLy+JDvDBo7860bEE4jyHFwkfdlex0f
	 uApLyZUlh6nBwZ4rjFg5+nl6S+4LeJDLvZpf7hor2lIH+NMycgX9LrZhRCxeZur8ZL
	 4e0XDwhc8k0MQz8NdMO+2gkXIF38aJTtw3kOKZag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/529] ALSA: usb-audio: fix control pipe direction
Date: Fri, 21 Nov 2025 14:05:20 +0100
Message-ID: <20251121130231.756310849@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>

[ Upstream commit 7963891f7c9c6f759cc9ab7da71406b4234f3dd6 ]

Since the requesttype has USB_DIR_OUT the pipe should be
constructed with usb_sndctrlpipe().

Fixes: 8dc5efe3d17c ("ALSA: usb-audio: Add support for Presonus Studio 1810c")
Signed-off-by: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
Link: https://patch.msgid.link/aPPL3tBFE_oU-JHv@ark
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_s1810c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_s1810c.c b/sound/usb/mixer_s1810c.c
index fac4bbc6b2757..65bdda0841048 100644
--- a/sound/usb/mixer_s1810c.c
+++ b/sound/usb/mixer_s1810c.c
@@ -181,7 +181,7 @@ snd_sc1810c_get_status_field(struct usb_device *dev,
 
 	pkt_out.fields[SC1810C_STATE_F1_IDX] = SC1810C_SET_STATE_F1;
 	pkt_out.fields[SC1810C_STATE_F2_IDX] = SC1810C_SET_STATE_F2;
-	ret = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0),
+	ret = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
 			      SC1810C_SET_STATE_REQ,
 			      SC1810C_SET_STATE_REQTYPE,
 			      (*seqnum), 0, &pkt_out, sizeof(pkt_out));
-- 
2.51.0



