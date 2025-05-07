Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD5628DF1B;
	Wed,  7 May 2025 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643285; cv=none; b=jbbFjHAY1M2tC7FYM8kiO6wAghyylT/z8iNzvx0vJkbmdl02HpADgovAS5s/2ukI3/6YmKiFKNbJHfUz7aRxcCIicCcrzlBEIXp8ko3Cxwo/mcH+CPo+9/JtTFwwRgw5/NylBt4A6OeybIbpcSKIEf+SnkXfUaXFGEbyqzSYz5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643285; c=relaxed/simple;
	bh=iO0bKtEsGPZbYFH0Hg4rL+BK0ex7cYz7G4lT2o9tPxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6lwPiVl87KF+uZ+HVhRsZ3dCapbvh8dF6PKHc2+Y4hhTURCj61g7++zFmbIJDT/OF5HHdy7zto8bGhcouih4U/TKaiNjaI9WBI5MSPgKVBeqPdhKU//IzTpapZoC0mYXqh3GabYBb4aPBujfUYdXA0co3RwV79pOPaxfHeEweI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzTvRk64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzTvRk64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8664CC4CEE2;
	Wed,  7 May 2025 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643285;
	bh=iO0bKtEsGPZbYFH0Hg4rL+BK0ex7cYz7G4lT2o9tPxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzTvRk64+jVNNc4tjmFg02+0+WNHNpSEbBhJlc0UBEu+eNmljVO0mewiZ0UcfBJbn
	 l4QxI/XRs8UvOlHmlvqJ0co3HCAHxxTUQbUkyLDGQ8fMoY++/VypPRjF+RUUwaT2Gp
	 qHm4YKFzzZDMC+9Mqccqdfmcwg3uQ0TtjIH+7YE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Priesner <joachim.priesner@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 01/55] ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset
Date: Wed,  7 May 2025 20:39:02 +0200
Message-ID: <20250507183759.109735334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -263,7 +263,8 @@ static int parse_audio_format_rates_v1(s
 	}
 
 	/* Jabra Evolve 65 headset */
-	if (chip->usb_id == USB_ID(0x0b0e, 0x030b)) {
+	if (chip->usb_id == USB_ID(0x0b0e, 0x030b) ||
+	    chip->usb_id == USB_ID(0x0b0e, 0x030c)) {
 		/* only 48kHz for playback while keeping 16kHz for capture */
 		if (fp->nr_rates != 1)
 			return set_fixed_rate(fp, 48000, SNDRV_PCM_RATE_48000);


