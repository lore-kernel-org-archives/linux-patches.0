Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2556EAD0;
	Fri, 15 Nov 2024 06:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653161; cv=none; b=h8pFJbAhJNcTSwHhlJmH9pP8849rbvHPXeY/uZAa2MF7wXgB0r1Ng3QD3E6jNvR8xgNKOKVvexKwITF8Ld6S3CJS39vms1bwK/4wmKeiP2x/NiQOsoA3MU6QQgH2NX9of0XrHlNOU6FgOnl7iuSzMp0VKD6DXzFuV4ksN8lzMuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653161; c=relaxed/simple;
	bh=xRsR3zdT6ISIB9j8qHmrvVtWi/Bvsywd2zgMiT/y0pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qp2FLavCEe7EwZac6OzIS9QfOZd2418xWIQj/MVdIPvgzkxLCqB2Q5yyQqX90pMA/MD+fpzXvJY17e00kgbKqm677Y0bzTtLbPSoK1QJ2NY6xwzWA1cxln7NMmniqU++4PAnL2bA/U6rV4UlSqD3vq+vj28YZY41SLyl/HIhXuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxFfaE49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxFfaE49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EEDC4CECF;
	Fri, 15 Nov 2024 06:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653161;
	bh=xRsR3zdT6ISIB9j8qHmrvVtWi/Bvsywd2zgMiT/y0pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxFfaE49ZgMlVeUz5KZIbrwJgYAESEvXMXQPXwz0Jx81hCtJzcY6NRmAnPe2rYnV8
	 DVgxZRMvwQPQOJ8LlpFTEl9EExQuZ3fCcmF1K/UBfnVz8kWmi8ruHupP57w7oQJp5A
	 EafHCtB8V81MMUvZxDslF8V90lPBxcnQSePydgHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 53/66] ALSA: usb-audio: Add endianness annotations
Date: Fri, 15 Nov 2024 07:38:02 +0100
Message-ID: <20241115063724.755473817@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1823,7 +1823,7 @@ static int snd_soundblaster_e1_switch_cr
 static int realtek_hda_set(struct snd_usb_audio *chip, u32 cmd)
 {
 	struct usb_device *dev = chip->dev;
-	u32 buf = cpu_to_be32(cmd);
+	__be32 buf = cpu_to_be32(cmd);
 
 	return snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_HDA_SET,
 			       USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,
@@ -1834,7 +1834,7 @@ static int realtek_hda_get(struct snd_us
 {
 	struct usb_device *dev = chip->dev;
 	int err;
-	u32 buf = cpu_to_be32(cmd);
+	__be32 buf = cpu_to_be32(cmd);
 
 	err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_HDA_GET_OUT,
 			      USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,


