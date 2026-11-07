Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060872;
	b=jipwhuACqU2JldboynU11UBeMiPIrup4QmhvSQIH7lF3yFQ5VetxiCurLSAwcgoS26r5
	 0HzgoRtExgilBNJuy+DwUXM/QwKATcqokHdJ0TPZvl+tXPQidRg5QyQKycuriOUt3WCA7
	 tE5glABepwGxKA4JFf8M+0+QP0rbqyOvyUbjDh9Zwzq8pA/rfAFxGmcYPcWnQvepQ0+rK
	 DVKJHtueqC/RCB59b4sQXjY0s9hir3FIksvccAJLuGzle3tqgJuJYzcOOnQFIFvqdtofI
	 kJSu/L9C6o2ok+VZd51LVropsDv0rkIwDrpr3itU/dCkUspmrQQOHae+NMOkzhSXpag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOQraeSGu5irunACDRykmQFb2ymKAFH0LoftzRlI2S4=;
	b=T99fcOwDplsoRfx5yXpcSYj6enmyPl9y8QO02sV6/Olx7ebxPme/Bls+J6kY6Yup/Yk7
	 AgryIpzUC1g1wd3ZOsNmkoUqxTs4wUxmYHqT4V5yI8/xe9bHCXlTXtLNPIH05VCGeuhBE
	 a/uHlUftS70cp84g9Z8XF2geIOulrMoblSPV9sOe48vuxwrsEvIFplVTekghIDCgXm9Ja
	 yLa7Zie5WzV4CCBAqigx92X3B99aUfhXLu6ekpQ7e8NL+1Ol8dV68xPegqoIodpDKrgWe
	 UqowCEN/ItfzwNDl+kacoqbJkn2rvVEpo9g6tJMv0DEIVlaRLhmltu1BEGPG9e6FDAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8TEgvOC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D92606A33C;
	Sat,  7 Nov 2026 14:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8TEgvOC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BAC1F0089F;
	Sat,  7 Nov 2026 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060872;
	bh=vOQraeSGu5irunACDRykmQFb2ymKAFH0LoftzRlI2S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8TEgvOCqrQ1bdPu8/v7kxhO6j8GKUiC8euQXeYvVstoqVxiaDQm7uF8kw96Pg9eJ
	 9WA4V3zP1gc30q58ySM57E6jg0MSEYkW+Q+PBqw46U1NcKeRE0STXnnE6GoQyH6fDB
	 WvR95lqKh3lVfhhXo4G2HVXYBC2eEDMJEf36GKFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0213/1536] pinctrl: npcm8xx: move GPIO IRQ setup into request_resources
Date: Sat,  7 Nov 2026 08:37:09 -0500
Message-ID: <20261107135003.639826176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3eb9e32f46726..49e3a5b5019cd 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -298,17 +298,33 @@ static void npcmgpio_irq_unmask(struct irq_data *d)
 
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
@@ -316,8 +332,9 @@ static struct irq_chip npcmgpio_irqchip = {
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



