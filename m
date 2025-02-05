Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1D51B3F3D;
	Wed,  5 Feb 2025 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768250; cv=none; b=sZcG8W9rhAnE7gYDTbrYELrKQApz9v3SHCTNyCy8hNcc99N2G78ihyjRYhfHqdkzIX9zN/06ZzM3rkhfM8TAZGzJHnpCL0r8fDbY3jzbaCbsXU12Y173QJ7nWjK92EHgeLjrOjmk6zqilzYKyzmN2u0c5/p8AvSsCuh+HmmWzis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768250; c=relaxed/simple;
	bh=8lj0flWFsNCi/U3LE7bZVR5eGUdOoOHAf+wjZsPT5Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCI02tnfYYWRpGy2ytPQih+wG2a9/S2EXr1LyQSslNSrshCSJLYhJufRKqi9xfeZBHuex6wo+0X3fdSjTH7G3k3S9WdL30QLa9Ulkv9UEj3wM2pPUdbdyEVWyXfjOMV9+WjxJodSHAMjyaWLj0oPf67a1j47AbTPA4q8vnx5h3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n625f1Re; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n625f1Re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC42C4CED1;
	Wed,  5 Feb 2025 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768249;
	bh=8lj0flWFsNCi/U3LE7bZVR5eGUdOoOHAf+wjZsPT5Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n625f1Re3xpk2qEqI4UOjwsdLl4/Dz4Ael8huG37SICEHSiy/GEFKjBV2vzHkTUug
	 mh+n1BJF2PkEuMghQcYPSmTSzaUwATcQduxBzIOi/6Yva6mljxrmatsLgqC6klx+8B
	 VIlosGa3rLoRjIrLSy/8Kq3XDiOnydSR6lX4jx4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 551/590] ALSA: usb-audio: Add delay quirk for iBasso DC07 Pro
Date: Wed,  5 Feb 2025 14:45:06 +0100
Message-ID: <20250205134516.352830637@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lianqin Hu <hulianqin@vivo.com>

commit d85fc52cbb9a719c8335d93a28d6a79d7acd419f upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

usb 1-1: New USB device found, idVendor=2fc6, idProduct=f0b7
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: iBasso DC07 Pro
usb 1-1: Manufacturer: iBasso
usb 1-1: SerialNumber: CTUA171130B

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/TYUPR06MB62174A48D04E09A37996DF84D2ED2@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2343,6 +2343,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */


