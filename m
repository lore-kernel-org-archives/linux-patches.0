Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D14F1519BF;
	Wed,  5 Feb 2025 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767727; cv=none; b=A3Ns8hYTS9JXfMqEqmkW87C5T7/EXdXLA10uPwHJKe+Z4qjmgYM7TYOwIKPcDp5shv4tKxGm9Jl3mV/qLvJzDf+71NKoSkAvCQFNcN9Ofy/wQi2HRV+vzjxO4OcE4u+XCtABy1Aqy7ABZVGzrqo8u6vpzj7xzQZ12H8sMCu9Wyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767727; c=relaxed/simple;
	bh=bMAoYTflszhsqVdTLtwzYF1j+8+p+KRRT1k8baCy+Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBedI8zrjVWPbOrfEPsHd3T0czu7wqPDcwImMRffoUOedqU1WWajBejkzEpU/d1JXuFu/zT9DFGhh/7c3TUQ5p1xIzy7oihHW+54q5cI5+p7zr6jH42bUHp0bJ751Kw0kclkV47FABWDvn/klWPMjE5/QWh+rBoE/I0fEVGfATQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FusTU2AN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FusTU2AN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93142C4CED1;
	Wed,  5 Feb 2025 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767726;
	bh=bMAoYTflszhsqVdTLtwzYF1j+8+p+KRRT1k8baCy+Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FusTU2ANr/M3hATUKUHJiYKjiq5pQhjQLcU0YPkW9GxaQPLxtYl1rB9m6sKevpx1G
	 m5XKPbJSk1Al67YGROsUDqqs9+9AW9fHMiXl3UzMnvj2Jy7ZeWLxo0FalREiHUggkC
	 flZsGZ66AzK3H5H26EGbtmyhb1GuRuYES6L/pUVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 475/590] gpio: mxc: remove dead code after switch to DT-only
Date: Wed,  5 Feb 2025 14:43:50 +0100
Message-ID: <20250205134513.431531981@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



