Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621652;
	b=Kk69la7UUP+nWN/wy2DCp8A+0R9IaSjZ1fqiXOHQi1rL72ageciepzuzB4SFNAkDPKA0
	 vaLTRBEPgjyYM2D1iIfBTyJYCauY55RaYf3lpQ9f2FEkxbAfyUu0mdkDBUsNq1OlfeTjO
	 6qimBFQqN4FOl8nGjf6c0pNCQKLzTh5dB4Orf5j/8I1iZ+zpA9jBTp6C4IIqVzgKAQdM6
	 S3MLePMkvPLhP6lp7zMOMV0M7AITTbzXrCtO/gtQRrXklv94ur8ywweQnwWUxzO8Mt95N
	 W/6mrm8L+VjdQ/A8E32aQQUj0OLtyefVPh0w9Brn2Aql0KNsFKlRv9jFyqCFyHaLjLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BioehEJ99NgbFtfz9S4G4FJm/DYkT1tsY4KaDZU7xUs=;
	b=YXIHMdRfNwQWjSVdiXvMeLuCqUjFVZEkn/scsj/Skjaouigw7dZXQB7Q7IjLBv7Zu+1p
	 UH4OnHv3R3GcD1fJrehNnlFJUGvldkLKh81JoPOM9Sq73ch+sgedBNiiRAw6MNEvJMdL2
	 MjYT/s5hDiV8OsZLnLYUAw0mVw5f5rFKk8H5kGWZyBhIkr6cp7FA0aox9cJKnUhDJ7cMn
	 micnUq64wrHHyqmUC1LvbgW5vgSZZrNWHBdmd2XaGuGu+pta8Xr8vKWFaMGL/btCZa45z
	 vpw9svwciQLUudWX+hjaBu4k2sQRExCyGZef5l6R0ARGfE4Eik0qkUfsY5SQQU2Bl8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrkWkprI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19894606A69A;
	Wed, 25 Nov 2026 15:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrkWkprI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C751F000CA;
	Wed, 25 Nov 2026 15:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621651;
	bh=BioehEJ99NgbFtfz9S4G4FJm/DYkT1tsY4KaDZU7xUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrkWkprI9ufO2TMXgUr7iv35Lbshcw/kpakYpWEn0HYAKBymlFFZO3DWEt+eCQ9mz
	 jmjgwvtyXcXD8x+XKuGReBMuhTgAf5TtzGfWZQ2oOex14nv0tcTQc/2Rz3T8DkHYj7
	 lI2F2GuTDA7la+upyKxB4SzBw+r6TEU7I/pRCPlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Long Zhao <longzhao@ambarella.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/990] gpio: regmap: free the irqchip if adding the irq domain fails
Date: Wed, 25 Nov 2026 15:27:39 +0100
Message-ID: <20261125143828.928321335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 4f83027ab2032..066a5be7f8e93 100644
--- a/drivers/gpio/gpio-regmap.c
+++ b/drivers/gpio/gpio-regmap.c
@@ -371,6 +371,11 @@ struct gpio_regmap *gpio_regmap_register(const struct gpio_regmap_config *config
 
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



