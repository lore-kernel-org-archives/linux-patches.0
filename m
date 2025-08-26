Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24A1F4CA9;
	Tue, 26 Aug 2025 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215585; cv=none; b=N98dFbEDR9w0k8XtF0befhAfOwKr0CBKCIJ77YRah1nmC3c1sPTWt87rRN/3sb0yoCy0idZcXWrjunzwrl23c7hCbrMu3ktwDx/TEGpFR7e6ot/8ncIv6l1u1NHHA5lRiP+0UlqXpVleiBuLaqQTx9OSt0UxGEQ4q6q8SFdyQ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215585; c=relaxed/simple;
	bh=zFZHRcp829ok8cHf4D1m0vvR5Bnm2cqpIXAjDGoT+0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SF+SPTBSikqvlt+DJjOWhEhUSz0Ui8+BFyO84iR0jyLAZ1WyF5zhhavunAh7EAVHvftgrPpEL9674SMWGXQb0xo8b3yo6y7afJZeynFUaSffi9u9DbRQCOuwoxvJ/SqfV3Zmfe2HGz8MPxBkN+POS+fQOFZPDLTgbqpqZV1DYUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKmiwC8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKmiwC8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4122C113CF;
	Tue, 26 Aug 2025 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215585;
	bh=zFZHRcp829ok8cHf4D1m0vvR5Bnm2cqpIXAjDGoT+0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKmiwC8NtLoN5oNdyIqcloNG3GHzByYhDbeJUsquoxuLrjVVQBzAiInBIoNGmxaGT
	 cJnaybi46bfHpxE72izivDwOaEC0tbcZBYe/RCdLX194SNx8QvbQwZbd/tOHkBHv2O
	 f9HbLhvFcBlJkZh3FYOclcvDh6GcHAdYAzwCfPBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 088/644] platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots
Date: Tue, 26 Aug 2025 13:02:59 +0200
Message-ID: <20250826110948.682625688@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1357,7 +1357,7 @@ static int ideapad_kbd_bl_init(struct id
 	priv->kbd_bl.led.max_brightness          = 1;
 	priv->kbd_bl.led.brightness_get          = ideapad_kbd_bl_led_cdev_brightness_get;
 	priv->kbd_bl.led.brightness_set_blocking = ideapad_kbd_bl_led_cdev_brightness_set;
-	priv->kbd_bl.led.flags                   = LED_BRIGHT_HW_CHANGED;
+	priv->kbd_bl.led.flags                   = LED_BRIGHT_HW_CHANGED | LED_RETAIN_AT_SHUTDOWN;
 
 	err = led_classdev_register(&priv->platform_device->dev, &priv->kbd_bl.led);
 	if (err)


