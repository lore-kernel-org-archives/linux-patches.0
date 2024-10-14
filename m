Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6281D0F61;
	Mon, 14 Oct 2024 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918916; cv=none; b=Fi3SUjlsnhdceFXfeg0Mpdxfck88bgDqVwQELjJrW5jaNvPFb1D/jF8iDDN15UkVKJm8u97OzX6vsXjMJ9g/W33tRpx4saleKxvKYq+DBOukMZB8oVKGjZQBWdyr2E+0y39DYeH5ZAuI99JUcGHzj+4eASc4ypUn+gOXCduGf/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918916; c=relaxed/simple;
	bh=6ycTGgRqQzQmZgQunEhRLWmr/GmZPFqNkMJFl6KAvDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKaF/AhRkjpF11gB/Prz7dhasttPZoM8tefFe9pdZXlry/VnXHoGefATA2IiJI2tu/fFAqrMCBaptTHogf0sKO8PF13+ADF4Cgkj1nmUTSYJf0KimiscV2GTCPCjDtr+0GVAK9aqPuXMPG8dSxAN3pL75u8PYu4NBGC0FZz+BgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGIAuqz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGIAuqz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DB1C4CEC7;
	Mon, 14 Oct 2024 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918916;
	bh=6ycTGgRqQzQmZgQunEhRLWmr/GmZPFqNkMJFl6KAvDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGIAuqz0yh2PuM2kn8U85cneFT6vA7ISi7ygT/qtBznxAUxd6GCvA17oPfBdUo64Y
	 KEOY48AMi2muPnLdfy0wCbdHw7TlFRerrY8Vqw6OHvjcb9dDghKJ+u6x9y+VWDskr+
	 tLxUiVxuFPc9wfmX1csXxGgrsOvrXeUvJRVJx9no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Pius <joshuapius@chromium.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 458/798] ALSA: usb-audio: Add logitech Audio profile quirk
Date: Mon, 14 Oct 2024 16:16:52 +0200
Message-ID: <20241014141235.968624727@linuxfoundation.org>
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

From: Joshua Pius <joshuapius@chromium.org>

[ Upstream commit a51c925c11d7b855167e64b63eb4378e5adfc11d ]

Specify shortnames for the following Logitech Devices: Rally bar, Rally
bar mini, Tap, MeetUp and Huddle.

Signed-off-by: Joshua Pius <joshuapius@chromium.org>
Link: https://patch.msgid.link/20240912152635.1859737-1-joshuapius@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -382,6 +382,12 @@ static const struct usb_audio_device_nam
 	/* Creative/Toshiba Multimedia Center SB-0500 */
 	DEVICE_NAME(0x041e, 0x3048, "Toshiba", "SB-0500"),
 
+	/* Logitech Audio Devices */
+	DEVICE_NAME(0x046d, 0x0867, "Logitech, Inc.", "Logi-MeetUp"),
+	DEVICE_NAME(0x046d, 0x0874, "Logitech, Inc.", "Logi-Tap-Audio"),
+	DEVICE_NAME(0x046d, 0x087c, "Logitech, Inc.", "Logi-Huddle"),
+	DEVICE_NAME(0x046d, 0x0898, "Logitech, Inc.", "Logi-RB-Audio"),
+	DEVICE_NAME(0x046d, 0x08d2, "Logitech, Inc.", "Logi-RBM-Audio"),
 	DEVICE_NAME(0x046d, 0x0990, "Logitech, Inc.", "QuickCam Pro 9000"),
 
 	DEVICE_NAME(0x05e1, 0x0408, "Syntek", "STK1160"),


