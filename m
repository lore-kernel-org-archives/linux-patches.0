Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8159188920;
	Fri, 15 Nov 2024 06:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652940; cv=none; b=CH3fdbsKQgGIrYfToRX8spOif+OS1DI5C3HS8Nj/ZC6RojV3+eimTnmNgVIrYt6VyZhzyG8FEgx0LMsEhq109nmaoNjq8STIfPIalQQF2Kho+UhV3vbtrNINJvvuXmdPPaa9K5LCVRZsjSq0RJgyGZJHBMpT79gsxmRFyGVUWB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652940; c=relaxed/simple;
	bh=rNDojzoC+u7v4WxWrohzTOSXhJrSL+kCtYipiyO4r/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdOmq62V9q/Qz0oQ5bpv5pTMFlWBwR9XpkWeR29hwtkZEU0V4qXfhZlKodGr682UUgF69kTTQNMF2sQ2gZs+Qpmxs6HQJOsuXPDmyibd/1TF2cWXy71SANqm7iPWDsfpzLyRboHxtulhpbaIWMhQXc+d/NFE+KV+jZ1sHTrtCVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNPAR3lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNPAR3lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA5DC4CECF;
	Fri, 15 Nov 2024 06:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652939;
	bh=rNDojzoC+u7v4WxWrohzTOSXhJrSL+kCtYipiyO4r/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNPAR3lzOeh5bcMNSaPX21M+h2Zx5rHSAxd3jc5gknHWN+sT+AOJjsrABE43AQUgI
	 9tCCKs9hZ0bQF35/xUR0yxeLjYrE53mPx0d1uHcdNXovMFSIjTw+dfNdPFjRcWVu+v
	 IlGRN1SeTkiINO+bz+MF/MESabrAoCLHKFlgQ0Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/52] ALSA: usb-audio: Add quirks for Dell WD19 dock
Date: Fri, 15 Nov 2024 07:37:54 +0100
Message-ID: <20241115063724.338994338@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d5b93a1e7d33f..93b254b723f60 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2452,6 +2452,9 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
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



