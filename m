Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5B61E86F;
	Tue, 30 Jul 2024 17:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359016; cv=none; b=NQS3s5m4wtkwUD5/6fq7qKRsnp4G5HOdNRxYovFh7b0xzqftlwYgHELfhTzzHpjFCMpLVWZaLZFrRCJiLC304mk4CS5FWiAD/Rpvbx5EdF/JZoGJUpwZLEY4PkUkOzlkXHBn6zWs7VA995yuZ4TQuYmixKgF9lUX6XGKAdW3O/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359016; c=relaxed/simple;
	bh=bgLdhvNMoJ93uCjOSNWjWcsGYq589yQV4/U3RQKIPRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzXGWH4g8KdY2ri7wAU1XHVbHVC8hc3sE48n21XFwvQRiG9DLm3vd0zePfURbYUgqmYDsgKA1NDmzQqyL3NzZNt/iI0NmAj5lx40k4RQEMBvBLPyVmmVayXbwmyVPDw7Sa44Sp3unAQudRFGcVexuX2BIlr+JjXHueIdrCK51+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8RtjCEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8RtjCEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5093C32782;
	Tue, 30 Jul 2024 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359016;
	bh=bgLdhvNMoJ93uCjOSNWjWcsGYq589yQV4/U3RQKIPRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8RtjCEs4Ohpc9gdMMKNNBmATzRRA1I684N186chX7gJx3VBm8YHTDlpXyEIiLZwa
	 OSRpUAUYHdE3TC5ZaPwF14Zb4Aahd7WCq6O1mPF7P9R3gLY3VL18tOevuLtG0E596i
	 hGxiETCMBl10htoWegf74fJ8eKw+oH272HGlSR/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 420/568] ALSA: usb-audio: Move HD Webcam quirk to the right place
Date: Tue, 30 Jul 2024 17:48:47 +0200
Message-ID: <20240730151656.285427913@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2127,6 +2127,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2040, 0x7200, /* Hauppauge HVR-950Q */
@@ -2185,8 +2187,6 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x534d, 0x2109, /* MacroSilicon MS2109 */
 		   QUIRK_FLAG_ALIGN_TRANSFER),
-	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
-		   QUIRK_FLAG_GET_SAMPLE_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */


