Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF041C5F37;
	Thu, 13 Feb 2025 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458981; cv=none; b=KiB+KWszPfgwLOC4ZYRM31Nh/QrKzeG9END8Inr9iXk0rLvPaeKRVPk8QLedK7hTKeSlqZRZgA0iljGhoafhP2F8Wn3AAO79bwLblxwVdpaemtxP3XEpBjm1MZB4MwdD+EggYt89TJWY14uZn9G9TV01oDjFbL16llIFyKuAUys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458981; c=relaxed/simple;
	bh=zUaf2DeDuBOW53mF/yJcAZ/9q5MSiqIkGsRFislqT64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQTY5iDzckMKcUqpxRfyEYBjvJ1cDrlmzWxL3WCsZgbz6CYc7klR8Jfzdj+hrHwsUkyJpRWLVJ8N61eM3/hb7VQLL9YQZA+6Z4KQmPyHiQvuyYtDnAo1LPh28VsoPwbJLQFjoxHCJSlO1O78be3wMp0vtHWD7pCOYdxTBAZ+boA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUWwrF5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUWwrF5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244CEC4CED1;
	Thu, 13 Feb 2025 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458981;
	bh=zUaf2DeDuBOW53mF/yJcAZ/9q5MSiqIkGsRFislqT64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUWwrF5ATovXHAwrvBIcKn6Pp6KoLDtn9T9c8QmfEjBtYzudfCrCT0z6i9y8ihR3W
	 l5LEnYLZvfb46HDNjnIzuIQyg7GbaJjJZ95pZTskchl72zGIZ1ms0JWra79kQuxrER
	 N3x+gKK1MbyuzqJFg0q4u1BE4JuN2tHRZZ9oyFD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andreas Larsson <andreas@gaisler.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 132/443] gpio: GPIO_GRGPIO should depend on OF
Date: Thu, 13 Feb 2025 15:24:57 +0100
Message-ID: <20250213142445.700635660@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5393f40a640b8c4f716bf87e7b0d4328bf1f22b2 ]

While the Aeroflex Gaisler GRGPIO driver has no build-time dependency on
gpiolib-of, it supports only DT-based configuration, and is used only on
DT systems.  Hence add a dependency on OF, to prevent asking the user
about this driver when configuring a kernel without DT support.

Fixes: bc40668def384256 ("gpio: grgpio: drop Kconfig dependency on OF_GPIO")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/db6da3d11bf850d89f199e5c740d8f133e38078d.1738760539.git.geert+renesas@glider.be
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93ee3aa092f81..1a66ca075aded 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -338,6 +338,7 @@ config GPIO_GRANITERAPIDS
 
 config GPIO_GRGPIO
 	tristate "Aeroflex Gaisler GRGPIO support"
+	depends on OF || COMPILE_TEST
 	select GPIO_GENERIC
 	select IRQ_DOMAIN
 	help
-- 
2.39.5



