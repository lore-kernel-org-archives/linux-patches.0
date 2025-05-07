Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF68B1DDC23;
	Wed,  7 May 2025 18:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643779; cv=none; b=C1S/F+zFsDxOo97rJ861t3JlNAM4b1PlOQr4s5r3ilF4L2DgG4IiKgzbrfAi6RxaWAQXZ5JW6/xz9xvs3XQo5wIsF5GVSdavbGSjnIWqUqNdosB2pWRZsPxS2pNrCx7RzuVwX7X/slz+bxs1F9UHGlM0VTxqe/4GhMOMvSe86Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643779; c=relaxed/simple;
	bh=LSvdmHLSJW/JToKLrA8JHNmzJOVbeCKJmgOu9P4hPcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxezTSOO09Ou/YDoUr8IxAn2YNtwW8pzrNpvQQDkN/y35YdwrqDLqIQh7fw1N+eB60sdC+fELK96tzSxXzB6d0RB69D7lsqW1kf7qNx/+9z9Sj1/7k49RKDASvXSOV7Rh8UZXRaurK0P3Stn60bgrzbz0kTNPl9EcF6G/jFQNWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUwY8/1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUwY8/1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51809C4CEE2;
	Wed,  7 May 2025 18:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643778;
	bh=LSvdmHLSJW/JToKLrA8JHNmzJOVbeCKJmgOu9P4hPcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUwY8/1wJdWiUa5Lvr0I+3AIFdy29hH9PtiWcwtJJUp6ynklJC16UM1OU7nYxxYuO
	 WUS2pPavSN8Ryyub7MO3JkrFdaVrh7+rkEvW8RK77L2U4VM91ULMvHeWd1+v0yYzfr
	 agDjGSGlLMTb15HvRdw6eNNVB+nqzJSqTllkYxf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Priesner <joachim.priesner@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.14 004/183] ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset
Date: Wed,  7 May 2025 20:37:29 +0200
Message-ID: <20250507183824.866864571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joachim Priesner <joachim.priesner@web.de>

commit 1149719442d28c96dc63cad432b5a6db7c300e1a upstream.

There seem to be multiple USB device IDs used for these;
the one I have reports as 0b0e:030c when powered on.
(When powered off, it reports as 0b0e:0311.)

Signed-off-by: Joachim Priesner <joachim.priesner@web.de>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250428053606.9237-1-joachim.priesner@web.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/format.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -260,7 +260,8 @@ static int parse_audio_format_rates_v1(s
 	}
 
 	/* Jabra Evolve 65 headset */
-	if (chip->usb_id == USB_ID(0x0b0e, 0x030b)) {
+	if (chip->usb_id == USB_ID(0x0b0e, 0x030b) ||
+	    chip->usb_id == USB_ID(0x0b0e, 0x030c)) {
 		/* only 48kHz for playback while keeping 16kHz for capture */
 		if (fp->nr_rates != 1)
 			return set_fixed_rate(fp, 48000, SNDRV_PCM_RATE_48000);


