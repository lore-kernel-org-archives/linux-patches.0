Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A971E1DF6;
	Wed,  7 May 2025 19:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644868; cv=none; b=mjigySwrqydG9Li7jtRLt9h6nhy+3zb4VJke09trLZMxOq9WPXrzOxEGs/tJTwnR8y2Tb//2sdeoPQK27g1lrdWMbeaR6eoA1ohe83TPt1EGKx6VSJJzeT+V+R/EKx2vL2JIFufu2KOTZtsNS/vzgGR38TTAWEpDuluyo0u16Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644868; c=relaxed/simple;
	bh=7AzUVJrmF5erQZNpKRABd0WD2YLhO+xEzQcjA1uDud0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DawFpZy3entj8ul2S01nH4PzFeLxC18/TAzuicWtwcq9jA+wLvA81QC6i2kiLR+6AdknKNAHggxB77uaEsNTdv7bbImT54jVVm8Pr0D0nPmgIsCXRqambf6UXi1eiFlw3XzWC3UFsu8kbterPhG4P3/kBHOZTFEdVHrZHUu3/08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYZ1oQC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYZ1oQC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE307C4CEE2;
	Wed,  7 May 2025 19:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644868;
	bh=7AzUVJrmF5erQZNpKRABd0WD2YLhO+xEzQcjA1uDud0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYZ1oQC9+Nbdvevb1tgolPbl3/OwMPS6rpkwIbDH/HRfGcDBh1EHKiave8SGDz5M5
	 0lvI/VVUF1Py1wrjZ5lG64AdmNIGVXvxXpAnLAwGc8i+edx/UxAB/y9ZWHnBn4KZql
	 h5WE4yfl9SdmZ5tlqbZk9PsQolVuDgwdlI2mhib4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Priesner <joachim.priesner@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 003/129] ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset
Date: Wed,  7 May 2025 20:38:59 +0200
Message-ID: <20250507183813.646381439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


