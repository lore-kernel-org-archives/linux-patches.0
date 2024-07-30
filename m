Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6518918454A;
	Tue, 30 Jul 2024 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357703; cv=none; b=nq2h2yLBMt3e6Ney4XnF4/07MVyYu5x4htMy5FIwnnSCT5kkumXzKHmZnk5dgtx4uTQSXv2UCimDlrCpCxb4iUOeq3+QE4sCY2FUSP5D1te1MvTpVjn0HcLTYwb3fIgMKCBLaq/EYFs2PB1VelDyFfjegwDG0ObwK3PZlWtAl1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357703; c=relaxed/simple;
	bh=gyLp0+o5+Yf/LIEZ3QnT1DgDupbVo/LBeeVzYovVvoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7VturDLh4VQeoDzB+e2IU6+CsqRuUeHENU3dTDEQMOpAGWEPvsEkWQSbF3rCMEuZxBV+oYQxdxaZRo0MXsAFL+yBMN9OvTzO+Ir0HP4U0A8LZVew83seFbcov1bQz0tEbq1+UBdxV4GYFd9PfmHU0lEF3Ee9lrWvkBjfCjykWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoDGr8QZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoDGr8QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1610C32782;
	Tue, 30 Jul 2024 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357703;
	bh=gyLp0+o5+Yf/LIEZ3QnT1DgDupbVo/LBeeVzYovVvoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PoDGr8QZOta/0U9Aozw8BLumnK/sZs36wJbqirrNAoXHrOCmVBond3xSUTwqnTA18
	 o3+06dAFUNuRpYFHeupOwNwYKBqLE7Rj+I6ZFuWt+su9M2FhJRqv2MfRwV3XY9TwL4
	 7NAJGdvMp/fxQX3RssClZDEVuQNXZnc5XHx2yieg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 317/440] ALSA: usb-audio: Move HD Webcam quirk to the right place
Date: Tue, 30 Jul 2024 17:49:10 +0200
Message-ID: <20240730151628.202155928@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
@@ -2125,6 +2125,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2040, 0x7200, /* Hauppauge HVR-950Q */
@@ -2183,8 +2185,6 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x534d, 0x2109, /* MacroSilicon MS2109 */
 		   QUIRK_FLAG_ALIGN_TRANSFER),
-	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
-		   QUIRK_FLAG_GET_SAMPLE_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */


