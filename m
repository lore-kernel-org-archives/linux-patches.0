Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42261C2420;
	Tue,  8 Oct 2024 12:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391733; cv=none; b=oe1STFwtrkcraACrOLsPNL/s/wXW/XQqaK+wwHAMCRKBUybLW9CPT2qhafoJiTHRs3gCaieZTeGA3+TA2Bx5MDUXYHAXMhsTCvfqulJeJN1Gn69dLjSyNdfVVSlDMiIJAdJRf+7f8x6ZREK00eAvAvvwXha027zbkmpO7DuH9L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391733; c=relaxed/simple;
	bh=R75rPz07qG1B0v3pmFv+oxD56HcFz2SSHDlf9XHPsWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUaGw+cjPazGS96jOwApCkKyFgmRsyUipORK1j08w2INVH1aB931jDyO8smCNf91XGZwxnn4kfCqVcfGf7dG1pG11KwY1yP3tHp6E5ogNBPiadhDQeaUdeNOZQrl8Q9xrryOAN0IBG4mAJWgT0OGH1dq2xrqXTzKhnqmXZ/I5NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMyH3YR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMyH3YR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C76C4CEC7;
	Tue,  8 Oct 2024 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391733;
	bh=R75rPz07qG1B0v3pmFv+oxD56HcFz2SSHDlf9XHPsWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMyH3YR9Q5JuenKChdMfMEuKyi7mct1rvkSndGZgOFfxdal8hP4CNNcqcCdBRRqhE
	 wwyIwtMnXxGbSFtd1eYnMB6bY1h2XN0XhlWVPAWv5hEzaFu74+HsuyyR2Dl+5qSyd4
	 7+0lBgffa0sAtkXTdhJLjK2hkLM1UfzKLSIlGHzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Pius <joshuapius@chromium.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 174/558] ALSA: usb-audio: Add logitech Audio profile quirk
Date: Tue,  8 Oct 2024 14:03:24 +0200
Message-ID: <20241008115709.204115487@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 778de9244f1e7..9c411b82a218d 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -384,6 +384,12 @@ static const struct usb_audio_device_name usb_audio_names[] = {
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



