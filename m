Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1841AAE23;
	Mon, 14 Oct 2024 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919291; cv=none; b=eA6w9O7fMEPak8aPPPXYJfvlTvxZPOvoH2xzDV9VElBTQI7q44N+JR3rx2jJDKmGDTXFxcSSVQTOhXLPbFzk/cbHHSkZJxNRvCQ/2TTOp6C9uRhPzMLucd/Pa9HAZRUaLv3XIKoTZMqSGcKdaC5jnoaToJHDpSuxWzh+mmHCu20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919291; c=relaxed/simple;
	bh=F4Zz7zh1Hk78+7CMdFFTZPN6yz8AW5OD1qYjf8rk0Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCIBKLuA8I9IcKgKjwasPtkZVfd0Vx/fdI5u3svJFwGL7MwvihWcQHLTTxDXGDiqsVs8XTZ6H1ISIbHJhj80EE6ASxQEy9mZDeV7C7+p1IYNTi7k11bsjg1rbKdH3jBp9IobgnL3henf+2Z0tthjIp7dISKetmqmFcwwkwm61FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrxsY+Xo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrxsY+Xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B2CC4CEC3;
	Mon, 14 Oct 2024 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919291;
	bh=F4Zz7zh1Hk78+7CMdFFTZPN6yz8AW5OD1qYjf8rk0Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrxsY+XoQhAIT8tln32QWsSj34RF3rFyeSHmbuwo4I+W/vzi1Krf90l1uI6+IF3uJ
	 WU2RMD4mrFj0pZjaQD/Ac72nu7wy7U2mL/rSQvveGWv6MJExCaMufYlbSXi8+dAm13
	 528nXyzkxUCBxTC0RWpWdEFP209H+OVPdimUXx2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 536/798] ALSA: usb-audio: Add delay quirk for VIVO USB-C HEADSET
Date: Mon, 14 Oct 2024 16:18:10 +0200
Message-ID: <20241014141239.055951907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2179,6 +2179,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2d95, 0x8011, /* VIVO USB-C HEADSET */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */


