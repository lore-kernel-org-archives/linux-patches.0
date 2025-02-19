Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4294E1D7E5C;
	Wed, 19 Feb 2025 09:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956643; cv=none; b=TBIXIoEUwCCo4iB2ojAou24l8MUWFwYLm9IGhUIq6FyRnnBaeANsy9rL/9iTP6ZTK4NMSarV8PDUJlwJ9xtBgPXaCJR/eT7ZG2oUuR29H71WeMyDIdKlfPGbQY8ui1a252MgWmM+/t8PO16owMJWJAhgYEQyHK1Lfx9fnBLY4pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956643; c=relaxed/simple;
	bh=JRSPpn45PfvLwa3SpUkKwr9Ec3/bg/MtY4uWNlyPhGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ts3gu0chYCmVO5k811SVCiVw6Nf2PHu9OHqHZst24jKSUBc4u6EDI3ZbzHJRf6FsiUekGUwtl44cXbErJURefIFBnkUuYk9QGPHyp5YkG6EWdpnYaCBszqtEKLCgs6Zh41BbuJNAa0QKZ7CdfUolrWkCDItAonCPfYsl9HtAV34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXCKedqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXCKedqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8E7C4CED1;
	Wed, 19 Feb 2025 09:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956642;
	bh=JRSPpn45PfvLwa3SpUkKwr9Ec3/bg/MtY4uWNlyPhGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXCKedqoLiOfBGdU3U/HbVq4Eu6ka0cQVyToAENCenCN3cjgWb0QMOcPKXtM4SzoV
	 pJENQwZUz9RSXg/tfS7MTbM2TOBp16uMW4bdHj1RDlT8wltFtWHfvrdiWmL751T1aC
	 QSBtQkyU9/He1F6METXNa5QGkEx56zFw4YEWk/Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/578] gpio: mxc: remove dead code after switch to DT-only
Date: Wed, 19 Feb 2025 09:23:42 +0100
Message-ID: <20250219082701.630791455@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



