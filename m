Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E467A1D8DEA;
	Tue, 15 Oct 2024 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993531; cv=none; b=KEaTDVZRTBfzPO2vaWXB8DTPWuyC5+ZVhoyHr1Lr5Rcv0dHSVCFp5Zx27gl6f0MyObDzbvpgFNciJG3xKzXnBS1sneGODB8C1ULYwHoi6I+57JrgzWURUNNPnaMgo9dHThkXKt3nNw11NkF8R/LshCC0td77bBO5uW1yUyuV4Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993531; c=relaxed/simple;
	bh=4/JVq7cVMWiHABLy5GY0TkK/wlyZ6KUS2Wh/4wKoADM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOnCB9PrB0watzJnXBuTzApa5fKN4u7OhRp8NJGVcwCbbbHRWxKOGWZEU0ArBdbXxssR+iPes8cU5t+lBjK1o1AgtSGwfjD8Y0VkzpfSn884dExLCm9kay4dlE0S6OhngGCYS1L9vrWksuj0xdwYy/fHhvbmGLJRrJiaLvk9KsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPmaPy8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPmaPy8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC66C4CEC6;
	Tue, 15 Oct 2024 11:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993530;
	bh=4/JVq7cVMWiHABLy5GY0TkK/wlyZ6KUS2Wh/4wKoADM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPmaPy8FaPiR72VHcyi7b5dp5MAnYmIkNW43t5dMUkR+XwMRrksOzAU91KZG3PeiQ
	 NtF868EheltRQCcUugmbvkZPFvsbG6IaBa1Mvagzgef7TuTFOkQmbXXgWMVtoAZWXL
	 TgSMO86seRDG8aFB4/j/WZkkU9U/gCuvvxcVNOYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Pius <joshuapius@chromium.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/691] ALSA: usb-audio: Add logitech Audio profile quirk
Date: Tue, 15 Oct 2024 13:26:27 +0200
Message-ID: <20241015112457.770154206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bebd42413fadb..bec6d41a143d2 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -382,6 +382,12 @@ static const struct usb_audio_device_name usb_audio_names[] = {
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
-- 
2.43.0



