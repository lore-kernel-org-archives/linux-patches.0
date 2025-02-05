Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12371519B4;
	Wed,  5 Feb 2025 15:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768161; cv=none; b=aVzrAJV7/rq6/KF5ecFyKo/Z8bZI6DNkggvEfPHsT5UTORlzywDh7faSLwz3B8k9fOi1Dej3j3vnUMnbZd7IzEHgdFvrQBLiytgeoehOGrUL35P4+MzT2amgpKos8uSLBGqcxl+kmSRZTJVbtN3QzbPXZ12iUowCKT6b+mB1QXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768161; c=relaxed/simple;
	bh=egsBEBi9krzIiVtl5fd+k1suYfEPm5mvC0bQF79Z1bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdcJFU8Lh3akepEVrbhb+sSXlwsPs7Dq4ucoVfVKVfBWJVRM/Tq0sCbCiebkFtiO0OQz6RP44Cerz7IQnBu9Lv7Yc3XEjRObNqD9q7zlsORNmchhX2JlL6kfK7fkf4QCjN5YvY/DyQTYifHYRRgnFN36hckPeGkLy4nGbsPanfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkw9uNLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkw9uNLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209DDC4CED1;
	Wed,  5 Feb 2025 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768161;
	bh=egsBEBi9krzIiVtl5fd+k1suYfEPm5mvC0bQF79Z1bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkw9uNLfPOm2UQnbKdc5WZ0gQqvg2NXRoH73UIdNco0+JUsiZk4Gffg9s2oIwQI4U
	 tgK+y5KpJq5OA44eYLIqz1yU+NMH91VcZnJvTgV2Yu+6vEn/iJxlCanxlphyqxeGP8
	 PWtX9sABzETPGHf9JfSdUQh2GxsazUPDC+wgGpTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 506/623] gpio: mxc: remove dead code after switch to DT-only
Date: Wed,  5 Feb 2025 14:44:08 +0100
Message-ID: <20250205134515.577438233@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 4cb455b2bdee7..619b6fb9d833a 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -490,8 +490,7 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 	port->gc.request = mxc_gpio_request;
 	port->gc.free = mxc_gpio_free;
 	port->gc.to_irq = mxc_gpio_to_irq;
-	port->gc.base = (pdev->id < 0) ? of_alias_get_id(np, "gpio") * 32 :
-					     pdev->id * 32;
+	port->gc.base = of_alias_get_id(np, "gpio") * 32;
 
 	err = devm_gpiochip_add_data(&pdev->dev, &port->gc, port);
 	if (err)
-- 
2.39.5



