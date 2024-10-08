Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E081DED48;
	Tue,  8 Oct 2024 12:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390529; cv=none; b=O+TV3oooUEoKBC3mCrX1SZiUw97MnBqhCOjx/XyKo3neeUEdIkxBzrVChyxTmE8STQOvx08lRQsO2guXcd7PUaPR9bxFZ5nPM14LL6DcfqWr/nbtEiQPmthYUzErKWltUFcOpws6Z16/CZIRQmzYRTFod1ogCL8UGAhnwLq842I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390529; c=relaxed/simple;
	bh=K2RyHokKjlMOf0xi76pfDEYYEebpA/wex9thjuDH/SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwEuWlSMQy/fsKkAqLDXDAxI3RB3FNEZX5Rho4Ce98C/LoBmg72RSc6AMlBtt2gN2lXxzfQ0onfLZ7QydDYtTbvAmtt4noYMsyP2vElXLXCyLZC2fabOrAZvORWEwn+4q/pGTjLBuxdzigcvLlmjUeRhPYDWYsD4jOK8qh2YpJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Xqkf+71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Xqkf+71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC62EC4CECC;
	Tue,  8 Oct 2024 12:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390529;
	bh=K2RyHokKjlMOf0xi76pfDEYYEebpA/wex9thjuDH/SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Xqkf+71Fu/4CrzfY+7DwQrP4m1VGYbVqAQBpcgBpULJBjtEIObSmSKnJSigvvaDu
	 iMGNJAVAG6peQMNrvjMB+vmLmoWfv+PVVl4O/b2mvmRGyMeiH5H0MP4RTk53UbiwBZ
	 1lbm2VW3p0cMnUGnd0JWJ++stJAPb6cyi7cOmNUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 316/482] ALSA: usb-audio: Add delay quirk for VIVO USB-C HEADSET
Date: Tue,  8 Oct 2024 14:06:19 +0200
Message-ID: <20241008115700.868690603@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianqin Hu <hulianqin@vivo.com>

commit 73385f3e0d8088b715ae8f3f66d533c482a376ab upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB62177E629E9DEF2401333BF7D2692@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2279,6 +2279,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2d95, 0x8011, /* VIVO USB-C HEADSET */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */


