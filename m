Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829642;
	b=Z/GjmH10cEc55JrvkYUNYYFgGfIuYYBYXloKkLwgfpgI9RQz0tUTlPqNp6gROdDxU1SC
	 YT2Z9rkrkhoA4nPmMyjnln1+DluaT+SZsX/Km1zLD6WwWvFQLhCfkJfb2KnRztdFTK24Q
	 J/t7hMtQscS8dMfPbpiG6rKpnULqbcV5bRNhKcvXlLMR3cQ26nTKQFX6m5K0CBYtQ2wyO
	 yA8Qnz7DjlqfkxbE0RD6ZGcZZ1JOX4mbXHt9gcu7gAJwQCRp18P2bd8S+tCvVnnJiqCTu
	 2Zv+oOSEo18L8Zfu/k/PVxSFTJ11jxczAj6Cy12Nkfuj995myoR5J88mZPxhH9Gzu3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dHKCILSkMuLjE/NclcyFIvOh+cdRjLVwf217WP+8dwg=;
	b=P+rdwzho/98/DulZ/qouKi2RyGwbz3rojMkPGHnRLp00PpPef58YfSBChs1qf1TC3rTF
	 WbHebDBwi/ZAqxvX9t3rf4pIkVHiI/eGk7FeD012Y0PTYe7xvgCPZ2xnNqLDdyQWSLffA
	 izVHBmYhK8+Pw5dSiKM+VcizFvyx48mhD+tKHNrACnK9h8JFlGArvZxAXul9U2O2y9dtt
	 ZYUlFQmGCcHkwLlou3lA2SYrBOH7COp8pCxO6vLHmmuVnJKIGnonZKVk/9zbUSiiXUb3x
	 /3OaVgWfSHVR4P2JNoNJq0f8eLsewKsTbZYn3FzjTaZk3EImxffor+5iXUrjmYYquMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtWpzxOi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9E0606AC22;
	Wed,  4 Nov 2026 22:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtWpzxOi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0704F1F000C1;
	Wed,  4 Nov 2026 22:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829642;
	bh=dHKCILSkMuLjE/NclcyFIvOh+cdRjLVwf217WP+8dwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtWpzxOiXkC1CYl4nq2+YyC46uSIjnmF0Brls8gmEnDvMIq2TISDlnUJzHu+x8zIu
	 M4afbYN2a2kVHat2hDlYmRNCQAQB7fjyDlHYIPb8GexGvxdkeXGW2bqGAHGRX3ntbn
	 wMaSfzSWGxZtBEQAEMeUgy9HPXQ4PhXWnua3A1LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0251/1005] pinctrl: npcm8xx: move GPIO IRQ setup into request_resources
Date: Wed,  4 Nov 2026 15:59:44 -0500
Message-ID: <20261104211050.889907040@linuxfoundation.org>
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

From: Tomer Maimon <tmaimon77@gmail.com>

[ Upstream commit b8edfde12e355030e708394c0fa11632559c7ac5 ]

npcmgpio_irq_startup() calls pinctrl_gpio_direction_input(), which may
sleep while taking the pinctrl core mutex. That makes IRQ startup trip
lockdep when CONFIG_PROVE_LOCKING is enabled.

Move the direction change into irq_request_resources() and keep startup
limited to the ack and unmask operations that are safe in atomic
context.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 29 ++++++++++++++++++-----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index 28464463ff833..0347a471f9226 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -295,17 +295,33 @@ static void npcmgpio_irq_unmask(struct irq_data *d)
 
 static unsigned int npcmgpio_irq_startup(struct irq_data *d)
 {
-	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
-	unsigned int gpio = irqd_to_hwirq(d);
-
-	/* active-high, input, clear interrupt, enable interrupt */
-	npcmgpio_direction_input(gc, gpio);
 	npcmgpio_irq_ack(d);
 	npcmgpio_irq_unmask(d);
 
 	return 0;
 }
 
+static int npcmgpio_irq_request_resources(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	unsigned int gpio = irqd_to_hwirq(d);
+	int ret;
+
+	ret = npcmgpio_direction_input(gc, gpio);
+	if (ret)
+		return ret;
+
+	return gpiochip_reqres_irq(gc, gpio);
+}
+
+static void npcmgpio_irq_release_resources(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	unsigned int gpio = irqd_to_hwirq(d);
+
+	gpiochip_relres_irq(gc, gpio);
+}
+
 static struct irq_chip npcmgpio_irqchip = {
 	.name = "NPCM8XX-GPIO-IRQ",
 	.irq_ack = npcmgpio_irq_ack,
@@ -313,8 +329,9 @@ static struct irq_chip npcmgpio_irqchip = {
 	.irq_mask = npcmgpio_irq_mask,
 	.irq_set_type = npcmgpio_set_irq_type,
 	.irq_startup = npcmgpio_irq_startup,
+	.irq_request_resources = npcmgpio_irq_request_resources,
+	.irq_release_resources = npcmgpio_irq_release_resources,
 	.flags =  IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_IMMUTABLE,
-	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
 static const int gpi36_pins[] = { 36 };
-- 
2.53.0



