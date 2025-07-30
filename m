Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54441E25E1;
	Wed, 30 Jul 2025 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869128; cv=none; b=NIg8zAeO8HqT6uLCpr+wG1ynBshe1z4LqcSusWcyPfQ3nHFjcrAcGJNVZF2k9+Pd/TGVUsDZiyMz0TYvXrteD0eHeRuZqWKz0qzotWCmizHey+5gjxAAZ3pCHtV1JtWD2IsqCVm4HPYLqeIdp4cpXiCBdGlWMVplGdjYCSpfw4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869128; c=relaxed/simple;
	bh=AwTy3lbWb4+lwhN9cIJ+gdptl6CzXuwipru5T70nemM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bl2lLZoGJ6QGGEg4WfatsAC7RBfF4aMwd/hT/7d/WFHu/dCwtnDY+pB9U83pCbgoxm8JFrGDOGzbSPf5ijNV9n08XooFvdFqiPTvSTi9UIAIXmBCE1NZ7hdmCXDo/NDaxq3Kxo2RJvxXT9KNXWFaq1hyGJnIDC3hEBC+Tw9nQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04/htq1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04/htq1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F6FC4CEF5;
	Wed, 30 Jul 2025 09:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869127;
	bh=AwTy3lbWb4+lwhN9cIJ+gdptl6CzXuwipru5T70nemM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04/htq1wn1hH/4G+SP91eqxqOsE3BCRIOYfFteUH1OirkE1UgSh8IWdfEydVFshyX
	 cqRgI2OqEf6Wrab6pGMmMqf7wKQVKhitTUxBRazfZuSCAGlsReyzawNN5XK4BZ2L3V
	 q3gf0Jn08R+7VSQZKgk6L3/URflrgEt/NM2bsHoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.15 44/92] platform/x86: ideapad-laptop: Fix FnLock not remembered among boots
Date: Wed, 30 Jul 2025 11:35:52 +0200
Message-ID: <20250730093232.467095689@linuxfoundation.org>
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

commit 9533b789df7e8d273543a5991aec92447be043d7 upstream.

On devices supported by ideapad-laptop, the HW/FW can remember the
FnLock state among boots. However, since the introduction of the FnLock
LED class device, it is turned off while shutting down, as a side effect
of the LED class device unregistering sequence.

Many users always turn on FnLock because they use function keys much
more frequently than multimedia keys. The behavior change is
inconvenient for them. Thus, set LED_RETAIN_AT_SHUTDOWN on the LED class
device so that the FnLock state gets remembered, which also aligns with
the behavior of manufacturer utilities on Windows.

Fixes: 07f48f668fac ("platform/x86: ideapad-laptop: add FnLock LED class device")
Cc: stable@vger.kernel.org
Signed-off-by: Rong Zhang <i@rong.moe>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250707163808.155876-2-i@rong.moe
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1728,7 +1728,7 @@ static int ideapad_fn_lock_led_init(stru
 	priv->fn_lock.led.name                    = "platform::" LED_FUNCTION_FNLOCK;
 	priv->fn_lock.led.brightness_get          = ideapad_fn_lock_led_cdev_get;
 	priv->fn_lock.led.brightness_set_blocking = ideapad_fn_lock_led_cdev_set;
-	priv->fn_lock.led.flags                   = LED_BRIGHT_HW_CHANGED;
+	priv->fn_lock.led.flags                   = LED_BRIGHT_HW_CHANGED | LED_RETAIN_AT_SHUTDOWN;
 
 	err = led_classdev_register(&priv->platform_device->dev, &priv->fn_lock.led);
 	if (err)


