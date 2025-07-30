Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FEB20E6;
	Wed, 30 Jul 2025 09:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868425; cv=none; b=NwKLYBsf+672Q2zTBNDCOsktJeF9J81b5OouS9eTI8UevTmuskGlQkckv93rGkfczFGtvxpdAFbL9Fhu4NFSN/jCEauu6JZf9kdbIp0uVnwgSV0bSya06cRIadnCjDImtmXhqV8KC0rnlXTpJWgCE5LcvXl84CxM5qUG3FXHFVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868425; c=relaxed/simple;
	bh=FiNqHJnggDOeehiB+u3Hdnf3nL5x+EmqHsrQoQmj0vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cRjrUuBm1nHDVLog83cQYdgYVrC0S5I/b17C6Huih4uLTljd+mtiwyfWLZfATd3Mn/7TE9L0K2G6sTdsx2jzFV2WY4kOTmnc0lGTVaaeSagG4+A5WVApLHB37HAUz4F5cv433OqvdyP9LyRGiNHkko5hvsi4o3wwCDyFj8JxoDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJ0quym0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJ0quym0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83411C4CEE7;
	Wed, 30 Jul 2025 09:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868424;
	bh=FiNqHJnggDOeehiB+u3Hdnf3nL5x+EmqHsrQoQmj0vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJ0quym0rRuvsYwLrcBGaKXVMSAiEv+hlXzRvvzMQce+Ld0Qn9A37jv1xZLuYaDo/
	 mtTSU6xfccKi2+ng0fOnR3VTRQd4b4bOVSht2yNREr7/Mif0Q+55u1Ijvq8eIc90Mz
	 1PXljMM8kKUvC3RIKCVRKMt4kLWAoEB+9KWrIIrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 28/76] platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots
Date: Wed, 30 Jul 2025 11:35:21 +0200
Message-ID: <20250730093227.932533301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

commit e10981075adce203eac0be866389309eeb8ef11e upstream.

On some models supported by ideapad-laptop, the HW/FW can remember the
state of keyboard backlight among boots. However, it is always turned
off while shutting down, as a side effect of the LED class device
unregistering sequence.

This is inconvenient for users who always prefer turning on the
keyboard backlight. Thus, set LED_RETAIN_AT_SHUTDOWN on the LED class
device so that the state of keyboard backlight gets remembered, which
also aligns with the behavior of manufacturer utilities on Windows.

Fixes: 503325f84bc0 ("platform/x86: ideapad-laptop: add keyboard backlight control support")
Cc: stable@vger.kernel.org
Signed-off-by: Rong Zhang <i@rong.moe>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250707163808.155876-3-i@rong.moe
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1600,7 +1600,7 @@ static int ideapad_kbd_bl_init(struct id
 	priv->kbd_bl.led.name                    = "platform::" LED_FUNCTION_KBD_BACKLIGHT;
 	priv->kbd_bl.led.brightness_get          = ideapad_kbd_bl_led_cdev_brightness_get;
 	priv->kbd_bl.led.brightness_set_blocking = ideapad_kbd_bl_led_cdev_brightness_set;
-	priv->kbd_bl.led.flags                   = LED_BRIGHT_HW_CHANGED;
+	priv->kbd_bl.led.flags                   = LED_BRIGHT_HW_CHANGED | LED_RETAIN_AT_SHUTDOWN;
 
 	err = led_classdev_register(&priv->platform_device->dev, &priv->kbd_bl.led);
 	if (err)


