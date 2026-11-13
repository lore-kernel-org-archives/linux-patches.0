Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590982;
	b=FOC8uiHPvha+ri24DMDi/ASrOVv9Z7bzRABFq2NbA8R71XKlR6N/AaOg38TMGzgu1Vnu
	 KCBc31f8FTsj6/Hhkd968ZCwZl0Jn6otyjk/xv/qY3ozMIwq1pCnreSXRtwM1QHHn9l6Y
	 UG6XuyTp8l1fLnG5e6hH14XxAXnV78/7Ehto4kRDz6WwvPbZOzJEOg+wx4RNq8XNfhnA3
	 5pTJSlGUEUb4ZVjXkSwv2OoxiNQON7ruwbFJNo71T4nSX9UZBaConDx8cWX6QpPo4uQ+f
	 jdUxX/KOWAqe+B4seSi3iNfiYmLfjw7cOf7dNl4QFTh8hq/pzlv8k5BAaIops5W59Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4f0Ik2mypgmQr6kZTJzePS1dP4f6aoEcKBVVB7gM0rs=;
	b=LwiYa1wLeHuR/DRxtMEgo0qUERrzFm+yi2hwsvsO5Vx1+DFaF7oPJxJuHlpoJD5Os/Cm
	 d167RVEI4e3XN/y+RsSVHVtoBh/pMTMlLZsJK5KJY0E+R4CNOLuhmG1XI6DQlESIDfTq/
	 4RNIcun/4LkbZ3Ws/3Gj74XHef0tOu8x1GT3Ux7d9lwH/d2YqT12W2GYc97iE++0zNhwV
	 0i+Vnetm7/XEqIZvtncFJ9t+TJn13Dg8gm5BLNx+BrsYG1PgrQXf8rKLzxiJQuw0thRMZ
	 //A3m3tSP0mQkYsyvhjmFNdlfbxg8bDwNj/xqW40+2oSH27uTw40wyK4UFvT1oj5zog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fht8TAoo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908AA606F73F;
	Fri, 13 Nov 2026 17:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fht8TAoo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB4D1F000C4;
	Fri, 13 Nov 2026 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590982;
	bh=4f0Ik2mypgmQr6kZTJzePS1dP4f6aoEcKBVVB7gM0rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fht8TAooXfkJpWu6dqwVCvTha6jV7uN6a5qICfpbzKv9HKEGoevREWqs3+d6lRhSm
	 NvOduasO2QUrT94j+uERUmpzrzlhYFDbh9PCkmqYFQG+podZExcc0yBihFBD36mUpl
	 ahovjuCzWh1g3tGjXSAFt7MsATbtiAlRDruILaBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/670] gpio: pca953x: Preserve wakeup accounting on parent IRQ failure
Date: Fri, 13 Nov 2026 10:45:23 -0500
Message-ID: <20261113153817.510411589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 72a1819713ede..db29342a76767 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -742,13 +742,18 @@ static int pca953x_irq_set_wake(struct irq_data *d, unsigned int on)
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



