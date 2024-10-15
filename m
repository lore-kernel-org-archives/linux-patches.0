Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9678E1D1512;
	Tue, 15 Oct 2024 12:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993734; cv=none; b=gVojRrVjFc/5QoB7Jgm+n/lyxhgzkXigSeysBmUSOmPPGjfol7nuOZab2nquDocipLpa7ARR3x0vkEv0q01bb4ey2FRYLP3GyKnftRzqQa3M8G84syDCbhLmZxaHc1LDst3Zyc0TMQ6LmFvzSLH0mZKXhSKxFuoQq98nsV2uhaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993734; c=relaxed/simple;
	bh=azDvUFarOjsijyOa96z5Rup5TtVDeNx2KgG8XZoAV5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcPWylkjhl4cBvq0gOU9ebYCrkGv3Ay9LYHfTuhbbymr9XMjgTzGlG7Ak0ZSktsahPMG+szMR8MpglVCH8uOwvUFX6/PsEAN9pxXDh6x84Xotek7HCFR8GFk1X1NtzdpvJqWxWpsDb0z50PAjOL9Ul+nGO9MflA26HdYDp3ONV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVECoh4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVECoh4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0545BC4CEC6;
	Tue, 15 Oct 2024 12:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993734;
	bh=azDvUFarOjsijyOa96z5Rup5TtVDeNx2KgG8XZoAV5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVECoh4mbhqsERFrwyUYdgOhJknYgFg+QS2XRRSRQkDDcy+aCI/ekn440SdzGJ+rJ
	 LV3/NEZ1Ha6yJ1K2JOmrROLPPy+3K71+C3NJWz85nKJ2ZHULApi1LJW3q5XeAPGmgh
	 pvvDY5JE9/5frTobohG04+fsg0xrCYDgs2+xU3Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Lalinsky <lalinsky@c4.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 500/691] ALSA: usb-audio: Add native DSD support for Luxman D-08u
Date: Tue, 15 Oct 2024 13:27:28 +0200
Message-ID: <20241015112500.189170563@linuxfoundation.org>
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

From: Jan Lalinsky <lalinsky@c4.cz>

commit 6b0bde5d8d4078ca5feec72fd2d828f0e5cf115d upstream.

Add native DSD support for Luxman D-08u DAC, by adding the PID/VID 1852:5062.
This makes DSD playback work, and also sound quality when playing PCM files
is improved, crackling sounds are gone.

Signed-off-by: Jan Lalinsky <lalinsky@c4.cz>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241003030811.2655735-1-lalinsky@c4.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1846,6 +1846,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x1852, 0x5062, /* Luxman D-08u */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1852, 0x5065, /* Luxman DA-06 */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1901, 0x0191, /* GE B850V3 CP2114 audio interface */


