Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2286F2E22AF;
	Mon, 18 Aug 2025 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524634; cv=none; b=mkgcKSlMBnLJB4uhnbr44leSY2sYlKQeO4clue3soaR3ZSxCq6WUlVyyGGFzAeD9o7rMU5BY9U33JWtMwAWMBqI8J9F/XC2OabvAJFY1C8k5Nxwca1MS857L5lBRWu07hUZnTFWWaDVnvphSA6qpS62h6dBEUrtyQKjX0MCM/Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524634; c=relaxed/simple;
	bh=uGk38xlSHKiIF4pMwENR/Wxe1ecqR9AddOy/ORlpHY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fONVlpfatqxjIxsy+Yl0Y/Box15foP/SpBAAwgdQhBOd4KzuABNRr4B2IoqCLtdeHT5+nXcrz1iMRVbfJXSVEoVc+l6EsRnJhiaguu6hUtsA3q0HlqoIjuIbkUEMOKLQBLfSfj9HUoSzCFPPmfT32Np29CY3lbJly1NXyGZRLkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pD6D330C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pD6D330C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31508C4CEEB;
	Mon, 18 Aug 2025 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524633;
	bh=uGk38xlSHKiIF4pMwENR/Wxe1ecqR9AddOy/ORlpHY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD6D330CO3ATfO3xJg70/lqDtr1s6lF/5QtUct2wk7PVge0EGO7zw5mXLamnSScQM
	 m3dzFeXBv9/6spoe4BHaZV6tv4JsbdpMFVwyhB8r3NBvQEueODCaXggUonIlwqdgTI
	 iwgOSRLWb/kkEfwxIBsw1xUyv6qPg8R70e0ps/qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje@dujemihanovic.xyz>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.16 016/570] Revert "gpio: pxa: Make irq_chip immutable"
Date: Mon, 18 Aug 2025 14:40:03 +0200
Message-ID: <20250818124506.418205523@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit b644c640923b625340c603cdb8d8f456406eb4de upstream.

This reverts commit 20117cf426b6 ("gpio: pxa: Make irq_chip immutableas")
as it caused a regression on samsung coreprimevelte and we've not been
able to fix it so far.

Cc: stable@vger.kernel.org # v6.16
Fixes: 20117cf426b6 ("gpio: pxa: Make irq_chip immutableas")
Reported-by: Duje Mihanović <duje@dujemihanovic.xyz>
Closes: https://lore.kernel.org/all/3367665.aeNJFYEL58@radijator/
Tested-by: Duje Mihanović <duje@dujemihanovic.xyz>
Link: https://lore.kernel.org/r/20250801071858.7554-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pxa.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -497,8 +497,6 @@ static void pxa_mask_muxed_gpio(struct i
 	gfer = readl_relaxed(base + GFER_OFFSET) & ~GPIO_bit(gpio);
 	writel_relaxed(grer, base + GRER_OFFSET);
 	writel_relaxed(gfer, base + GFER_OFFSET);
-
-	gpiochip_disable_irq(&pchip->chip, gpio);
 }
 
 static int pxa_gpio_set_wake(struct irq_data *d, unsigned int on)
@@ -518,21 +516,17 @@ static void pxa_unmask_muxed_gpio(struct
 	unsigned int gpio = irqd_to_hwirq(d);
 	struct pxa_gpio_bank *c = gpio_to_pxabank(&pchip->chip, gpio);
 
-	gpiochip_enable_irq(&pchip->chip, gpio);
-
 	c->irq_mask |= GPIO_bit(gpio);
 	update_edge_detect(c);
 }
 
-static const struct irq_chip pxa_muxed_gpio_chip = {
+static struct irq_chip pxa_muxed_gpio_chip = {
 	.name		= "GPIO",
 	.irq_ack	= pxa_ack_muxed_gpio,
 	.irq_mask	= pxa_mask_muxed_gpio,
 	.irq_unmask	= pxa_unmask_muxed_gpio,
 	.irq_set_type	= pxa_gpio_irq_type,
 	.irq_set_wake	= pxa_gpio_set_wake,
-	.flags = IRQCHIP_IMMUTABLE,
-	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
 static int pxa_gpio_nums(struct platform_device *pdev)


