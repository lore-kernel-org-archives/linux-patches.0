Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E38B4F3EB8;
	Thu, 17 Sep 2026 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668463; cv=none; b=kKQiRz9ZTxD/KwmGbmgWreThm0m9RQZnG2P/D1n8ciktgbt80ogUs97c+/BkPq9FsxMsZSXjDFvhn0qrpbu7uPQ4ihOnRtcTZuaZuhm6i4zjLELtfK3sK2+N2QBJDUz/V5zvBvVqt28YFfvMj5nTqlvj5tW5fcLkKRTfn/f6qaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668463; c=relaxed/simple;
	bh=s+q3+rU+e3uesyQQcbo6YrbCflwkAlrSlG+eCUUB2ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwDleJRMvyA1NBXKgMwgSzIl4S143EMt/oFQdGLuuhlaCji4UQVPBN0LFezE0j1Zjiht0rjfhY7v5qRA5pL20dmwdO+G+iYvG8DAdzsPeZZLzGbLrV4Q5utGZx1uHf/MWG6iWLZvKcjSE3mqskyTYa8wu46Nde9Unkdt6bI+278=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuUSus9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuUSus9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53671F000FF;
	Thu, 17 Sep 2026 18:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668461;
	bh=6LHBczsuWsXMWNTLo7vM6F+5fLVo9xnOFVw+tg5Gsm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FuUSus9q8wIvTvUuKLcXdmp6MEUlh7CD7qswt4xGz3vYMdlfP0C9bIES4fQJ6g5DF
	 c7nLmoIDFO8iGv86dInENuX2+90+VdUCvDCF6FvhkknOXN/2AynxWIDmAJLFiferK/
	 HgKEk48Xrs68lN1u/Kb87I1k5pyR8NaxxTdtiWsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel C. Ribeiro" <dcoutinho.96@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0433/1102] ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless
Date: Thu, 17 Sep 2026 16:06:16 +0100
Message-ID: <20260917151550.544657306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel C. Ribeiro <dcoutinho.96@gmail.com>

[ Upstream commit f6d6a4147ace0c417035f65b021027c209c75190 ]

JBL Quantum650 Wireless (0ecb:2125) requires the same workaround that
was used for JBL Quantum610 and Quantum810 for limiting the sample rate.
Without it, the capture (microphone) stream fails to work.  Setting the
QUIRK_FLAG_FIXED_RATE flag, as done for the sibling models, makes both
playback and capture work correctly.

Signed-off-by: Daniel C. Ribeiro <dcoutinho.96@gmail.com>
Link: https://patch.msgid.link/20260719090037.40149-1-dcoutinho.96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 22c2f59d953a2..0872432b8574b 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2265,6 +2265,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
+	DEVICE_FLG(0x0ecb, 0x2125, /* JBL Quantum650 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
-- 
2.53.0



