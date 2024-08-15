Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B487F1494C5;
	Thu, 15 Aug 2024 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729871; cv=none; b=DuBLFIqJxF4XSwioi3qvLgacN5kHAoAxm4m5BvHXewU9CRe9AZnuMETJmOjjDyD/vaPR2IJbSemqE6vbSD5+X5tsYCOG29Ki/OzXjbhCxBl8GsDHA7dplgejbVLFi9FjqsogdYJBmAiY6Tb3+iRhpClCz1bR13sHcHrrmC3d+r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729871; c=relaxed/simple;
	bh=vp34rcG1ARL/DmCdCFnGBejZOke7HJR9J8sNglwaG0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4NVDg587HGNV1xbdv/z2kzyAEH6lrJtXiQlhOavPW9FxOEBT4uW/e6V75CXWuGPohpWzUNRGUARixO1EYL4+OYDPOunN+jWypeuURNUuWRaeSXV5JEKW7bTYDAxaJcV2npdZS0pbBmtxL7oJYlQmhL/vkDC0jSuRQpFUT92ka8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTeakOWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTeakOWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C752C32786;
	Thu, 15 Aug 2024 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729871;
	bh=vp34rcG1ARL/DmCdCFnGBejZOke7HJR9J8sNglwaG0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTeakOWuNdIC7V9JKegxgMoGRQksoS5y86XFW7NEqOrutlvHjJ/1eNRv+F9Ccq2Oo
	 AYXM6WqIaPL0PMHSPVGFL5usgkLLlrbRpabfEsi2xR++v4MxOMw9aJCl1kYts5MfQl
	 c5HT2FfRSz75D9vHeN/uRXkU0mgoOZd7DE1PM9XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 202/484] ALSA: usb-audio: Move HD Webcam quirk to the right place
Date: Thu, 15 Aug 2024 15:21:00 +0200
Message-ID: <20240815131949.213231580@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 7010d9464f7ca3ee2d75095ea2e642a9009a41ff upstream.

The quirk_flags_table[] is sorted in the USB ID order, while the last
fix was put at a wrong position.  Adjust the entry at the right
position.

Fixes: 74dba2408818 ("ALSA: usb-audio: Fix microphone sound on HD webcam.")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240722080605.23481-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1850,6 +1850,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2040, 0x7200, /* Hauppauge HVR-950Q */
@@ -1904,8 +1906,6 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x534d, 0x2109, /* MacroSilicon MS2109 */
 		   QUIRK_FLAG_ALIGN_TRANSFER),
-	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
-		   QUIRK_FLAG_GET_SAMPLE_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */


