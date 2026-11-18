Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059077;
	b=DS75qe0cPowOCvezrUUdK5VTxFNHOh5F8Po0/rJtle5DtQvfzK+Isu03jq0SSF/PBecL
	 nzyCXSjvg7eVUph6cn9aI1yNmM4Xh2VCWT3FaqZh7C22MuuYewCmqycW5zvi8et5qLgJe
	 MKbf03tBCpCC6OEuMq7+rsE8eDe3kKvN7HFc/fvgXhQL/PL0HJ5Ja2cfESH5rDl7TEDSX
	 KX1Zbr0TtjFsdVlyUwpwWmfssFuuiQc4mAXSFNRskO+falvXaOBr6AulM6ELPky+04vDl
	 f6/Ga0elThaj1RR3U7EMl+avtsIdvmM8HI8USXdFD+UnGXejaVQc/JjNC2JzCH8ukpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PeYV/kIQg6xo2iC9FIkP7WM16SDlnCYlY4DLuuu7TGY=;
	b=2EGuUiudiWbWq/l+eR/H8g7q+Wsqmm23FUXhYWHHixREvR4ik4gjgbTn8DTDSPptGBy8
	 1fyqD891tFRn4EOOx0tQ+J0y6KXFCuvkASl5cYyP4UzcS6eWB0aWHdkIdPRIVe9EZoGML
	 jp2duR/2aNDfwpV+6AeqyLTpXrnQymokg95qMsQOIMBm5fS/O4nLJd6LQPwqwloK5jAH0
	 SRQCUA+MeBbYggEo9vs+DtuRag3w5NQSHhBKII9hmos1sTqII0+Sv+545ubb8Xwp2A4O/
	 NwcRRpVj3iMqnkbgPrkq3gtACuVAAE7f8e4MDZDFZ+rUKOcNynH9+6f7AAvMo1VzmHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIaYaR38;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06013606A320;
	Thu, 19 Nov 2026 03:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIaYaR38
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5091F000C5;
	Thu, 19 Nov 2026 03:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059076;
	bh=PeYV/kIQg6xo2iC9FIkP7WM16SDlnCYlY4DLuuu7TGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIaYaR38Wspvrx1SM3Waf3sriZr80y2tkMa7RirzXun5CiPPWHEQ6wrt5rchaQaRq
	 /Ih+RncVu+/RJj+3K1x3aL4pA0OKzEOKrmgb3oTRExg4vnGqXb0O3tSv3tdC7b5mv/
	 pNVnU/0OnlBsfiXTdlEXrPJmmFExSdSBK5LCJNlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0671/1848] gpio: pca953x: Preserve wakeup accounting on parent IRQ failure
Date: Wed, 18 Nov 2026 15:45:09 +0100
Message-ID: <20261118145943.954418001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahaj Chaudhari <sahaj123.sc@gmail.com>

[ Upstream commit a38bf551726a21c9bcc001b02164f30378b64b64 ]

pca953x_irq_set_wake() updates wakeup_path before asking the parent
IRQ controller to change its wake state. If irq_set_irq_wake() fails,
the IRQ core rolls back its wake state but the driver's counter remains
changed.

A failed enable can therefore leave the expander marked as part of the
wakeup path when no child IRQ has successfully enabled wakeup. A failed
disable can make the driver stop retaining power even though wakeup is
still enabled. The suspend and resume paths use this counter to decide
whether to disable or enable the regulator.

Update wakeup_path only after the parent operation succeeds, leaving it
unchanged on error.

Fixes: f70fbc15bae2 ("gpio: pca953x: Configure wake-up path when wake-up is enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Fixes: f70fbc15bae2c89f ("gpio: pca953x: Configure wake-up path when wake-up is enabled")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20261018161042.3298045-1-sahaj123.sc@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 76c0c90647f66..ef69b7a01b585 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -645,13 +645,18 @@ static int pca953x_irq_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct pca953x_chip *chip = gpiochip_get_data(gc);
+	int ret;
+
+	ret = irq_set_irq_wake(chip->client->irq, on);
+	if (ret)
+		return ret;
 
 	if (on)
 		atomic_inc(&chip->wakeup_path);
 	else
 		atomic_dec(&chip->wakeup_path);
 
-	return irq_set_irq_wake(chip->client->irq, on);
+	return 0;
 }
 
 static void pca953x_irq_bus_lock(struct irq_data *d)
-- 
2.53.0



