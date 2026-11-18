Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053190;
	b=ZQcBElCptySvoSO3bH2MOrvbyHrW/0UDSt3g7mclzdlWE+sJFODomPWG4tmSipCssFmJ
	 8veV0Q2u43Lehw99wAQaUuQMvl80WpNLF+jXmTB6G7rMMiDdKD2bkyO25EEla0ENgO4Ez
	 Q3lsSCgxtqKo3sn5xGhX5k3gLzZLOaRZpEVnGR9lWDASc5k2D5tVAH9hBxQ91HjxBV02n
	 46iltDXYxzCvPuWtQPXVzh3ZpC/aQBCSHNhy7SSm2TuYF5sx5R5gpBunO1bfi6sTbNNs5
	 zmCiikCzCHb1Vg/gOoZ+KIO+s1MYHxNzWAkTRWP0YWqiH+pofYxHIezJcAX7GTh46WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I6/hEqeZBavrTY3dzErFPKnQXijwKBaEGmn34TL+0ns=;
	b=GbzKdkXYwvwP8QzxTVeF6oY5m30DqKhS2fVKce6YV5JOzh04v6f8gl3nzAcxHFk6CdIL
	 i4u3GsVmhbrbpD61+Y5B7AwZVo+JVjXnCPcNG10ROPFtDaGJhr5MsPJDMV0tiD69fg2lF
	 vxpJYVj8dOZEQuacEHgr32mPFXKArHFBD0vBnV+ryDtyP6gm0Z2kU3Il7UyrpMiuFLaCZ
	 3q4Y+hxq6g4cN3v8heIkSShZjjhVl2/rPehORG71jZIJ6v0xgpjPUCTBkcVvTS4zpNtaa
	 S1fTVfGZ35JED5BGm3gXRa1X6HTsDNtcxvviRh7ofvdcYRWSZ4kOB3T+7t7ZGlYoz9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImO5w6SL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43886606A320;
	Thu, 19 Nov 2026 01:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImO5w6SL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954D61F000C4;
	Thu, 19 Nov 2026 01:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053190;
	bh=I6/hEqeZBavrTY3dzErFPKnQXijwKBaEGmn34TL+0ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImO5w6SL/WCNjR2djPOC0OiIeyt4/254ilDBSNT4c116fjJp+7B3tqQg+HEZCJs80
	 DqCataMSKTtvXkWdZNqA+1bkBAyXOzqxjMxjzV5R2BuS8hTfb85NDP5Zx/UvUEDd7V
	 TEnfB+MeYzhH8p+RMI9lulIALNKNbrNDkyBiKpQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0829/2214] gpio: pca953x: Preserve wakeup accounting on parent IRQ failure
Date: Wed, 18 Nov 2026 15:41:45 +0100
Message-ID: <20261118150045.102926278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 94c888510243c..95a09a8daa687 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -646,13 +646,18 @@ static int pca953x_irq_set_wake(struct irq_data *d, unsigned int on)
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



