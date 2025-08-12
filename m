Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8612FDC25;
	Tue, 12 Aug 2025 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020364; cv=none; b=M9m50VPHiDao+0dVrwF9/38sSsgP9T00gL/iOeQNZdLgFGWFHATmKpRzFjSoh5K3VPP/x0x9BXfDnt2POW3xJUF3fKpMoRRRx/I+sHVmTfj//4sH6GioWgCnVVbz6+KhrSWyOJ4izrTl6HXOn9MjbwJ+T5Xakn6cj6E4TaSzSUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020364; c=relaxed/simple;
	bh=Ib1OEj1NuXES9p5PS9HCHwLTLZbOaunxYJg9rr/UQag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmAcF4QSLSpA22n9t+Dewit3DvZotJrwO38DhxMJrhIHh9yQ3O7cZ3hzoVIn0m3t8OYwWOTAh/jOCx06t75uHZK0Ofj2ZJtWP0lciU5/o1NR1BaysTa4UGwInAbTB9Sp0wdRgIzddVkkiMaZr4Z20jXY7CNRaWis/jEjoIet1Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKH//ERx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKH//ERx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBE1C4CEF0;
	Tue, 12 Aug 2025 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020364;
	bh=Ib1OEj1NuXES9p5PS9HCHwLTLZbOaunxYJg9rr/UQag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKH//ERxSN0qNyBEGyq8kaMJ3nE4dq1nsQBh5cr4FJWX7bf+o429WDR/HH6z1ep8l
	 F+50yl4hJQ2h3l+k7G8U47EaePz875EbEWAt6efWm62bP+h+TBn9D3gC8813rKxMrQ
	 U1o/wUKr/foVrk5zokCVxg1Pm5AgOEVnp+IuWlZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 026/253] platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots
Date: Tue, 12 Aug 2025 19:26:54 +0200
Message-ID: <20250812172949.845785897@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1498,7 +1498,7 @@ static int ideapad_kbd_bl_init(struct id
 	priv->kbd_bl.led.max_brightness          = 1;
 	priv->kbd_bl.led.brightness_get          = ideapad_kbd_bl_led_cdev_brightness_get;
 	priv->kbd_bl.led.brightness_set_blocking = ideapad_kbd_bl_led_cdev_brightness_set;
-	priv->kbd_bl.led.flags                   = LED_BRIGHT_HW_CHANGED;
+	priv->kbd_bl.led.flags                   = LED_BRIGHT_HW_CHANGED | LED_RETAIN_AT_SHUTDOWN;
 
 	err = led_classdev_register(&priv->platform_device->dev, &priv->kbd_bl.led);
 	if (err)


