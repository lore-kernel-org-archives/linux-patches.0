Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269AF17CA12;
	Mon, 10 Mar 2025 17:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629055; cv=none; b=YGGJJg65vQmed20DyPlh9lI1lzl3ZV8UcmQgixrgAEvGH5ZW0dgSSOnfrRPehb3svDP7ZE37P37c4/JM+32YM32VSivrgbB0/iDG/rpqa7O8Z+x2VZ7J1g+qu43mNMu8+dKIPFXJXfb8cvsPI45o6v7MvdgMgY3DcWV7vOD7KdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629055; c=relaxed/simple;
	bh=4pQ8uWNEmuz9fX+Gy/v4gMMNxHv0JeuijAC/f1RRsu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1ZjX098TIP8lnZ7jmARpC2AqvZRaHYmP/iSLhI4qJMfjlwktgYOTqir3lOI8wXIMpMhtSzpIVag46x9yAlpHuid3oi79wSAjJCJ1ogYxQx/s3/OpsUOZ3BXw5xT3bMfI5ivlJblBIK5T501i3SHxUIS3GiS5a1k3Io1uQBQgwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR4VJ5nG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR4VJ5nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964D0C4CEE5;
	Mon, 10 Mar 2025 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629055;
	bh=4pQ8uWNEmuz9fX+Gy/v4gMMNxHv0JeuijAC/f1RRsu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NR4VJ5nGi4/ov1KdEoSC4tLftqxDAiz/5yLhbyEtTREWAIBwDsIUZ0SpkzVCapGD2
	 KOMOxm7AvZ7k6KcmDI7u1fDD4qWUV26smD9yaL4x0sUusep75dw7NKGXjP1B/aMz51
	 c00NBn0md/MbiVB4cfwGbfV7ybrxESAcwxjsNFIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/620] gpio: mxc: remove dead code after switch to DT-only
Date: Mon, 10 Mar 2025 18:00:08 +0100
Message-ID: <20250310170552.015961668@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit b049e7abe9001a780d58e78e3833dcceee22f396 ]

struct platform_device::id was only set by board code, but since i.MX
became a devicetree-only platform, this will always be -1
(PLATFORM_DEVID_NONE).

Note: of_alias_get_id() returns a negative number on error and base
treats all negative errors the same, so we need not add any additional
error handling.

Fixes: 0f2c7af45d7e ("gpio: mxc: Convert the driver to DT-only")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20250113-b4-imx-gpio-base-warning-v1-3-0a28731a5cf6@pengutronix.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 853d9aa6b3b1f..d456077c74f2f 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -445,8 +445,7 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 	port->gc.request = gpiochip_generic_request;
 	port->gc.free = gpiochip_generic_free;
 	port->gc.to_irq = mxc_gpio_to_irq;
-	port->gc.base = (pdev->id < 0) ? of_alias_get_id(np, "gpio") * 32 :
-					     pdev->id * 32;
+	port->gc.base = of_alias_get_id(np, "gpio") * 32;
 
 	err = devm_gpiochip_add_data(&pdev->dev, &port->gc, port);
 	if (err)
-- 
2.39.5



