Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829459;
	b=lUvXdOegTJ8nmHlfaY1iKN+Mhnvnkyyl35gh1d52HucDCEFPuag5kcrSQlW95K7Q4yZH
	 yeYfBVlqmWkOUTg+M0Cqz54wJpyAXkHLpPyO8atdfOWYcoOzBMCI7inWiS8MNgV9npHt6
	 kD9wsTYNTuS51r0hDUixppCZ0vekZIQwCzN9sxvnb4Mk8cr1nJL9ntNNP2JygRJVGD0EB
	 UNBC2YtMEgsSw1IgfL2EnOc1M0GvBz+P9+6Rx64cF4NXSOEqai+dUWr891zqr5KxElJ3O
	 Jf0tafvUNE1AN4wHv7Vc3+j8CJ3YphNpuUNcCBKezrK+W73/Gg3du9nvTv6HdxZ5miQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Cn+qOFl1DfnUHzA0AW05dWLvd65fwlU6miCM+qyqwE=;
	b=28d09/mb3UCrx69XhwVcCouuzzzYW/Mx4DEEK1RcNDxRbvC7PUyie6dYlNJFqeQlGJbJ
	 2sj79Pm9PpjW3v2HQuKPLu/xbbXv5QF3kNWwCnT/JJDQlsEiVhZNTzTMqXau4mZEOIv0F
	 V7qp1HxW4zrqZvPtCqVOpzPhnz1vHdC/e6Dc83aMlh/rkKcD9Nj9qiXNokP7UjooODiON
	 va4oSEb2yDH0Tt/0k3eOLRvBHZ/OWnbJVVcmRqpBQbtW0XW3C5xPix4jDF6LGImRAkZal
	 DyC8369dq7cSa4TCBbPMvJRGh3pH86N7bT71GQbD8jLoJ45Wzq6yq3oOxcLY/aTV/pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FA2k84Kl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0458B606AB0B;
	Wed,  4 Nov 2026 21:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FA2k84Kl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FE31F00A17;
	Wed,  4 Nov 2026 21:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829458;
	bh=3Cn+qOFl1DfnUHzA0AW05dWLvd65fwlU6miCM+qyqwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FA2k84KlEkqhYx4XlKGO8vAPOxQO+onrJU8G+B54Z9K2rYTHqKMvBOLEjkcjnl2Rn
	 Vv4C2ivYAriWXw6YGhZqNy3Jzs7HmGNk78UGobFS/xdtNVqKfqFVTk123McDDJ4IZL
	 H2mH/93L/JtZSHaFsoVBv2XdYL+AKzpbu1vey4hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0099/1005] gpio: sifive: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:57:12 -0500
Message-ID: <20261104211046.410794517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8fe6fa0f223f44b8b869319d1b9c383749aa147b ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704122230.75964-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sifive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index 94ef2efbd14f5..e9a992cd4b9cd 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -260,6 +260,7 @@ static const struct of_device_id sifive_gpio_match[] = {
 	{ .compatible = "sifive,fu540-c000-gpio" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, sifive_gpio_match);
 
 static struct platform_driver sifive_gpio_driver = {
 	.probe		= sifive_gpio_probe,
-- 
2.53.0



