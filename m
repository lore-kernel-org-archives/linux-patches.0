Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BE320B20B;
	Tue, 12 Nov 2024 10:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407171; cv=none; b=E+syr1xUx2euY95ZovCNeTQxw5E+L+ACglPYBoNFpcEmhfoniTGsPbwZETFtadr8jVfkrCW+uOzv69E1pQoNMqVv2OpMCYpzVH41QXoio02LADlOjxX6sCgvGCNmYLA0SAihB/XuXyuM9woOxT+TYvwBpUn6NamIT8Im/uHBy4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407171; c=relaxed/simple;
	bh=ucK9KyWl+bI9LHx2oG2IWEX3Ahm6zkMDd0Tonx/LJTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOYAsLIV+zCVNJkiQ7VSjmdsVSoImznopZcf0H3SFZRh32udOobYQ2OXwO75pa1onJ049lwpLvZwPTF/YOsI3ToQtu74pzbbQRfnR2ZTnP3UqWR45tIWo13ePmnl4jtH4xRX9v/avQkwfBB72Nn9AjS+YuqWpVy5X+eLM081+iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEzPAFa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEzPAFa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F03C4CECD;
	Tue, 12 Nov 2024 10:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407171;
	bh=ucK9KyWl+bI9LHx2oG2IWEX3Ahm6zkMDd0Tonx/LJTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEzPAFa1rcfsS7SMRx7GfwjgV0ehtmekjKk1w9XHDp5liCrimVfZcSC9Q7OcjRVon
	 RZOnjrdmexLcT2+IiurTVVO1KI+uAUwK6siRD1QrQ0TD1BV+oEirI9xGhTL9fiPGNk
	 t/ga1KdShep6VwFdxbOtlN2+EEJK8sZJS3inPy5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 72/76] ALSA: usb-audio: Add quirks for Dell WD19 dock
Date: Tue, 12 Nov 2024 11:21:37 +0100
Message-ID: <20241112101842.520656465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schär <jan@jschaer.ch>

[ Upstream commit 4413665dd6c528b31284119e3571c25f371e1c36 ]

The WD19 family of docks has the same audio chipset as the WD15. This
change enables jack detection on the WD19.

We don't need the dell_dock_mixer_init quirk for the WD19. It is only
needed because of the dell_alc4020_map quirk for the WD15 in
mixer_maps.c, which disables the volume controls. Even for the WD15,
this quirk was apparently only needed when the dock firmware was not
updated.

Signed-off-by: Jan Schär <jan@jschaer.ch>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029221249.15661-1-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 25bad7a791d7a..e150c4ee2417d 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3441,6 +3441,9 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 			break;
 		err = dell_dock_mixer_init(mixer);
 		break;
+	case USB_ID(0x0bda, 0x402e): /* Dell WD19 dock */
+		err = dell_dock_mixer_create(mixer);
+		break;
 
 	case USB_ID(0x2a39, 0x3fd2): /* RME ADI-2 Pro */
 	case USB_ID(0x2a39, 0x3fd3): /* RME ADI-2 DAC */
-- 
2.43.0



