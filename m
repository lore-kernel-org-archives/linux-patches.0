Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1CD1DF265;
	Tue,  8 Oct 2024 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393779; cv=none; b=VqEZ08oKzC1JprtEizz8lKzV34sSM/+MdP9j3nbXVII96R+J+VIn4/qOQBj5lRySgZIVnGut1sDDLx86tL1k6pnAtTCasSFSMCZqB1I4GDT0cYc7V9CnfyCwEO3KGv15uiBcO6Sq1iQultin6tvf98Igs7BG2yMg9jjxHtsXJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393779; c=relaxed/simple;
	bh=n48daMbQ3Tbsm2ikTxk0Di+qsuuql1R3w8O9rra3gAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDPnezpiS/0/WHFnaMWcJ/5cAAVgftqP7+A0e1JMkrmmTErF5A2tmqAHwRnBmJ2WpX5sK9LrZbTuEsdA7JC5rn2f7gt3a5jNDBeb2sGths/1h3hPXFptBMz2v+UO/nW/k5BfSFTwTv0UbWqafQGSkQEXfQL1Jzm6InsvQFtWRRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPrSSaZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPrSSaZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE8AC4CEC7;
	Tue,  8 Oct 2024 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393779;
	bh=n48daMbQ3Tbsm2ikTxk0Di+qsuuql1R3w8O9rra3gAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPrSSaZ4Fkxwwjyc09CN00SQNak0XA2dvfwEtYklFj20EMOiHpDgZdKWj3rsybJZv
	 HScm9csUkChL+HB98vH3q1JRq28gxgmNwepSgRxwAIVTbOwTtX83awZN7AHKO18I7h
	 hWJojGzMQRQQg6bKi5KeKMUsJhjDuigd3X4RO8AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 226/386] ALSA: usb-audio: Add delay quirk for VIVO USB-C HEADSET
Date: Tue,  8 Oct 2024 14:07:51 +0200
Message-ID: <20241008115638.298718270@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2181,6 +2181,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2d95, 0x8011, /* VIVO USB-C HEADSET */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */


