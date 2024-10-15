Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3717F1C07ED;
	Tue, 15 Oct 2024 13:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997902; cv=none; b=ZtiUJcEuFWirGFuu5TY3vSDtmmnjr2xH1Lbmi8LVCv1Pnp2Zw9t3p57YrL3wwOFWcINcpfUs4FCrgkjJbGy1GYD0OUjj5vc3jG/BmDD9XeM2nD1BOEB/ZQ6FuG4kKElgEiXlhOlCJZa9r/3nX/dV02A97JXcLNbwRFKVEf/OeHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997902; c=relaxed/simple;
	bh=FO7swbQRmmZdczf1xmleBfYC2dGIxBM48xp5q56yIM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhCTaVvBF+61Zr0P1T00/X95QIz80GNl0KRoYpK/G7JiM6GmA+I43QHUiLDfd+IYd/1C1z6m41bPsX3dQwo4UdrjG9llSN94PNAWsCpksQyiRiUYYwoZO9NROBWAnkEYSY2Lhgr7yzvh4ahSA7muTB5ca7BK/m3qqwZXzzTZcCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k68x7Nlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k68x7Nlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8977C4CEC6;
	Tue, 15 Oct 2024 13:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997902;
	bh=FO7swbQRmmZdczf1xmleBfYC2dGIxBM48xp5q56yIM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k68x7NlrTwdqU66HSkbKVf8w/YQZ9jbmlecS702e+WREjbmyx/gEOdKFW0BebaeMm
	 Vg4In/VH8HF2PjvAmI2wSYnIX/GprUoPqarjws6cycXLgZjhwz8BVtO99BAitLYez/
	 ekzmeifn/CWfOWMZl3dfxlZFto7Z5srmLOmO3kSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Pius <joshuapius@chromium.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/518] ALSA: usb-audio: Add logitech Audio profile quirk
Date: Tue, 15 Oct 2024 14:43:45 +0200
Message-ID: <20241015123929.369868324@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Pius <joshuapius@chromium.org>

[ Upstream commit a51c925c11d7b855167e64b63eb4378e5adfc11d ]

Specify shortnames for the following Logitech Devices: Rally bar, Rally
bar mini, Tap, MeetUp and Huddle.

Signed-off-by: Joshua Pius <joshuapius@chromium.org>
Link: https://patch.msgid.link/20240912152635.1859737-1-joshuapius@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 6b172db58a310..476694ffc393d 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -377,6 +377,12 @@ static const struct usb_audio_device_name usb_audio_names[] = {
 	/* Creative/Toshiba Multimedia Center SB-0500 */
 	DEVICE_NAME(0x041e, 0x3048, "Toshiba", "SB-0500"),
 
+	/* Logitech Audio Devices */
+	DEVICE_NAME(0x046d, 0x0867, "Logitech, Inc.", "Logi-MeetUp"),
+	DEVICE_NAME(0x046d, 0x0874, "Logitech, Inc.", "Logi-Tap-Audio"),
+	DEVICE_NAME(0x046d, 0x087c, "Logitech, Inc.", "Logi-Huddle"),
+	DEVICE_NAME(0x046d, 0x0898, "Logitech, Inc.", "Logi-RB-Audio"),
+	DEVICE_NAME(0x046d, 0x08d2, "Logitech, Inc.", "Logi-RBM-Audio"),
 	DEVICE_NAME(0x046d, 0x0990, "Logitech, Inc.", "QuickCam Pro 9000"),
 
 	/* ASUS ROG Zenith II: this machine has also two devices, one for
-- 
2.43.0



