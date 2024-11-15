Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B42818870B;
	Fri, 15 Nov 2024 06:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652888; cv=none; b=pdFCtiU5PBFer6bgzlbXFVa0f8T0rUGwPaqINU9UnxJm6yQlxmEcT0w4wyK2/B3jy6mNjZdwBNFDrENj4shx7GPE9YKhR3wSweXI3BfWDJGVr32JzU7eVh1xB7BVFD+zKd5RIWBbPLAsnQihwD3IEQXNGtaPn1THiTJ3EDJUqDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652888; c=relaxed/simple;
	bh=rCkGAOzUQZjRGbXpinq3pyr9+x+2AM3OMvUNISPTadU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eqYJUwdpx5P0Ep729r+IuQ/n1QlozKnnkNhey/15lMRoZo7T+Fb+LGJ8mC00i2nkqf79YKgE/oE0YxfmSLK+eRwOva+32AwLHo09ES+11hsxrI03fQRQLZSIyVimZVmww4VNec6o/bj90ANd05E15mMC/RuWibziLKMGN0m8W9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxJBd136; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxJBd136"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15895C4CECF;
	Fri, 15 Nov 2024 06:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652885;
	bh=rCkGAOzUQZjRGbXpinq3pyr9+x+2AM3OMvUNISPTadU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxJBd136XrWLwdvjR3cH7P7s1v3mhCYAacsPY2+C//oCU8SqSwB03d1Vqmxr4JbYz
	 NQ5c0uPQl1+wSc5RNQQcPIqFIsw3PD9F6VyLAcq6mdBpE8ZtA/W3N4ix2Sje00Tds5
	 szLowL60NG632U1JSY8KPtzPfbN7Ycg3aOEI7rb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 44/52] ALSA: usb-audio: Add endianness annotations
Date: Fri, 15 Nov 2024 07:37:57 +0100
Message-ID: <20241115063724.444695377@linuxfoundation.org>
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

commit 61c606a43b6c74556e35acc645c7a1b6a67c2af9 upstream.

Fixes: 4b8ea38fabab ("ALSA: usb-audio: Support jack detection on Dell dock")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/202207051932.qUilU0am-lkp@intel.com
Signed-off-by: Jan Schär <jan@jschaer.ch>
Link: https://lore.kernel.org/r/20220705135746.13713-1-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1835,7 +1835,7 @@ static int snd_soundblaster_e1_switch_cr
 static int realtek_hda_set(struct snd_usb_audio *chip, u32 cmd)
 {
 	struct usb_device *dev = chip->dev;
-	u32 buf = cpu_to_be32(cmd);
+	__be32 buf = cpu_to_be32(cmd);
 
 	return snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_HDA_SET,
 			       USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,
@@ -1846,7 +1846,7 @@ static int realtek_hda_get(struct snd_us
 {
 	struct usb_device *dev = chip->dev;
 	int err;
-	u32 buf = cpu_to_be32(cmd);
+	__be32 buf = cpu_to_be32(cmd);
 
 	err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_HDA_GET_OUT,
 			      USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,


