Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28503230981;
	Wed, 30 Jul 2025 09:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869135; cv=none; b=FQd9b4jF06Yet/h0OCaJ6VL6t55C29WQ8dky5o1pmTgxcqOt6HByqr6/IGfeCcBstqITKN7sK2mxMtUamajKkSotErqUnYH6pwZBAv4M56GO4upJMRYjEp1L4YPiHpZO3lTQ5uWnLTH66vW8iU+yYYTBbzfptvprbRGTy89lxQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869135; c=relaxed/simple;
	bh=V1xmIt+oMmhG8n7eZB4qzz6DbNIsBml505dN0bQK3h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1GHbv1NMSZ/AQgMxLPqqcYZPVDwd40CZa+E6qsP9Wh9k6zH3GLlRk55xMKI6Apjn97lZyXVNtlcBZb4S8JmM/zI8ZHR7c8FBSI4cadcyp1nxoD0PTsU53WKyWAWR8mh2nI4h3ZzSZYNvlqdOuCKVeoKVG3gF2DfBxOAgZshvFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlDi+c6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlDi+c6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A01FC4CEF5;
	Wed, 30 Jul 2025 09:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869134;
	bh=V1xmIt+oMmhG8n7eZB4qzz6DbNIsBml505dN0bQK3h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlDi+c6XgwbJCF7odgCWPh07UIsLLtUUTbgY+JYwVB7QJq2ruNs9P1xmE6DC1j3PF
	 wGQpiC339vDJi9pruIn9MV511bB6eRUNwu9kNbQ2N78RpnC/jUfVc3UD+wSuOWguVz
	 MMHSK6NLMCJW6TFEQehleWzJ8BavgcT6ovN4AB1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.15 45/92] platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots
Date: Wed, 30 Jul 2025 11:35:53 +0200
Message-ID: <20250730093232.503505469@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1669,7 +1669,7 @@ static int ideapad_kbd_bl_init(struct id
 	priv->kbd_bl.led.name                    = "platform::" LED_FUNCTION_KBD_BACKLIGHT;
 	priv->kbd_bl.led.brightness_get          = ideapad_kbd_bl_led_cdev_brightness_get;
 	priv->kbd_bl.led.brightness_set_blocking = ideapad_kbd_bl_led_cdev_brightness_set;
-	priv->kbd_bl.led.flags                   = LED_BRIGHT_HW_CHANGED;
+	priv->kbd_bl.led.flags                   = LED_BRIGHT_HW_CHANGED | LED_RETAIN_AT_SHUTDOWN;
 
 	err = led_classdev_register(&priv->platform_device->dev, &priv->kbd_bl.led);
 	if (err)


