Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047098;
	b=uekTiTtzglzhhnwZEahGiRtimBr/GNCOlgPhO7pvV8HSCf5r8/sgsCjRF7b1K/zcKz0v
	 5VFZWtwkegDG6s4fZ5aZzPzWyu/zOUuS0PhpxO5w/bXPPbi3m6uO4MwXlaEnSfC8xxLi7
	 ZN9UrYZxFz92LfTUSwGzIsUChuKhbuJeHBh9ENYznDXumwZ0oI1KkuMF3YIAJ2vK4n2NI
	 W3TTJYL/amgS61zI8tkIeKXRrEwNH6b+5ojKb87ReFtsSPKM+5hpbI22jE+wntGsq9oES
	 KKiNfXyfhd0cberQ9v2N1gIpvzJLCN/HpKRnXSbRHaW964Md8WYUdRZzIae7Ii2belg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IUnIaOSPNDr+1hbe+vIrxRziUCxL1bbZiSUAivBR4Uw=;
	b=124mQmZxEfSSk5ruuThbFU4J2q1KKJRALxPRfjMVn37leN00BgKH6i2YcOV0Z7v1oklW
	 utlGAWwPJg3WWdbzMa/UHy6foAECBoDbunCHN1tLSSKWBG4jUElC9F7Gu6qNeuztleucr
	 23KRH8fwvFGEwEPP2jiwbqwZArUSJtq/UTU3ZOjNSnqMFLuecxG4UMDqomcg7XN1V21W5
	 wzsiRTDz6+0Qe8CRnSgRiTWv0H9GmSK1mxLOBncq92/YMlb5iHE6we4Y3kH+tKlAdRGbH
	 dH4Ka+zlyXs0YzLD260ScBAxtdeWwmxyic7JmPtxtW0UBIQeufNM6e4XALaK6x3Tlnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Rza/Ypga";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A956606A31C;
	Thu, 19 Nov 2026 00:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rza/Ypga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E011F000C4;
	Thu, 19 Nov 2026 00:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047098;
	bh=IUnIaOSPNDr+1hbe+vIrxRziUCxL1bbZiSUAivBR4Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rza/YpgauaWNbmbFT0xxIUwAgzOdhL4t+R6Nkxwv4c2YyESgkc+tc24JBVc8M4ilW
	 ICUdj/XurHwvxNQynS4JeFwh35Lig012tiXZjw8gCp12wcuQHMbyQXdwrOeksVh9DX
	 zy+L6n3JSYH67u5f1M2PRwbrXItizmwS1cXW0W4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1518/2857] gpio: pca953x: Utilise temporary variable for struct gpio_chip
Date: Wed, 18 Nov 2026 15:42:32 +0100
Message-ID: <20261118150255.985439161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9da0a75ea7ced4731b1f2c6c67dc409e40efb95a ]

We have a temporary variable to keep pointer to struct gpio_chip.
Utilise it where it makes sense.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: a0fe26929350 ("gpio: pca953x: Handle direction register read errors in IRQ paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 4ea19500fa39d..3ad235cd740be 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -692,9 +692,7 @@ static int pca953x_gpio_set_config(struct gpio_chip *gc, unsigned int offset,
 
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
-	struct gpio_chip *gc;
-
-	gc = &chip->gpio_chip;
+	struct gpio_chip *gc = &chip->gpio_chip;
 
 	gc->direction_input  = pca953x_gpio_direction_input;
 	gc->direction_output = pca953x_gpio_direction_output;
@@ -915,6 +913,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	struct i2c_client *client = chip->client;
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	DECLARE_BITMAP(irq_stat, MAX_LINE);
+	struct gpio_chip *gc = &chip->gpio_chip;
 	struct gpio_irq_chip *girq;
 	int ret;
 
@@ -943,7 +942,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	 * this purpose.
 	 */
 	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
-	bitmap_and(chip->irq_stat, irq_stat, reg_direction, chip->gpio_chip.ngpio);
+	bitmap_and(chip->irq_stat, irq_stat, reg_direction, gc->ngpio);
 	mutex_init(&chip->irq_lock);
 
 	girq = &chip->gpio_chip.irq;
-- 
2.53.0



