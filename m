Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618562;
	b=YF6L47tuVTslaWE75LdaFDtC7CzULYiL8JWmVKDpQmtgk2uzyBsA8sVeQ1l4mmIqC3cm
	 pgaQZQnAPoPHJIOGypnkIFtlrPmxXvEQk/IwqDPX2YyAveu6f1PSHk/FMqH/LWyLmyam9
	 ebd3Bl8DyMc18RiGRjdu0v5+DwLTMwkbKsZChkb9jp+1SrWxStrdKpbR21atvHvNWb0YD
	 /Q35iT62RmxOLb6s9rce9zt0RBXvQM32XU+LMgnt+Y4T9t4RHZpIqjxbGFZc1Z0vhckP+
	 r6JbAXud5cIQ0U2lcjk3Gx1gmhDkwQRgwNgCpFqLCKq8UHOUT/iY2ZLO2FdQmJsFZ4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c7/5CSR2jEdLGldzpcl/bXAcyjVxb7RfYuSs2Upu7IU=;
	b=H3FIQf0UxA4Um0ovOBMLHi94XxATNSvlRt/IrvyvFItr5Fx/VfVIA5jOpFWWB7Gdecrt
	 9uCb34+MiIGzbToP6/yJ7zHMNRrXDa/Rkou08IwnExoMUQ61E208eFJvCs+RYBKq9IZmT
	 uBiPoZd/jA9lQDhmL+facSjfHMibwFCDKV0t7sWf36gKeO+TCzzMS/b1G5sO7MLo8cVxV
	 yG7Qvjj4OeLgn0UMgb8PzxkqVzsaF9bgDNwW0vY/VsUnvggueFaDjftyIWwI1bzAQIdDR
	 gAENHD3PttjHT3/1J3VRPeWEgGYBgjZfiq7kiknbz/x6Z/CvzlUAGHUJRR75PZ1/6NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcvBcCtT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE173606A321;
	Wed, 25 Nov 2026 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcvBcCtT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D171F000C0;
	Wed, 25 Nov 2026 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618562;
	bh=c7/5CSR2jEdLGldzpcl/bXAcyjVxb7RfYuSs2Upu7IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcvBcCtTNXHUf8ZsiE8eOgVfwrB9/Yl84Un9EpTnhEYs4RX5RUtMAqjeC+3TYhRVr
	 7/ZjcArgtBePj8Naj2FMERc67u71tvpliuP8ZI5/egGasJCrfJnCLloRBIzoeJX/bq
	 ocTaLD+ebtNC4cbTOuHaDj8yz7kcCmbDQfv9jXtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Long Zhao <longzhao@ambarella.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0320/1005] gpio: regmap: free the irqchip if adding the irq domain fails
Date: Wed, 25 Nov 2026 15:27:38 +0100
Message-ID: <20261125143829.232616971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Zhao <longzhao@ambarella.com>

[ Upstream commit 80415a6ff295b03dab98ef55598c72be66945d82 ]

gpio_regmap_register() creates a regmap irqchip and then calls
gpiochip_irqchip_add_domain(). If that call fails, the error path
only removes the gpiochip, so the irqchip and its domain leak.

Free the irqchip there when this function allocated it. An external
irq domain is not affected: irq_chip_data stays NULL and the caller
owns that domain.

Fixes: 553b75d4bfe9 ("gpio: regmap: Allow to allocate regmap-irq device")
Cc: Michael Walle <mwalle@kernel.org>
Signed-off-by: Long Zhao <longzhao@ambarella.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20261103-gpio-regmap-irqchip-leak-v1-1-d038a20840f7@ambarella.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-regmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-regmap.c b/drivers/gpio/gpio-regmap.c
index fb21396e1d024..3b9ce1ac55564 100644
--- a/drivers/gpio/gpio-regmap.c
+++ b/drivers/gpio/gpio-regmap.c
@@ -504,6 +504,11 @@ struct gpio_regmap *gpio_regmap_register(const struct gpio_regmap_config *config
 
 err_remove_gpiochip:
 	gpiochip_remove(chip);
+
+#ifdef CONFIG_REGMAP_IRQ
+	if (gpio->irq_chip_data)
+		regmap_del_irq_chip(gpio->regmap_irq_line, gpio->irq_chip_data);
+#endif
 err_free_bitmap_output:
 	bitmap_free(gpio->fixed_direction_output);
 err_free_bitmap_dirmask:
-- 
2.53.0



