Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9851B37D101;
	Wed, 20 May 2026 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295989; cv=none; b=K+b9Xp8e2gng4HZVUQOIitl45qtSL15EtvD9ST5PQXt2ABvoiKdm0u4k/bm8KxijqQ5Y/1EsMY8Cmn4/IE2CTarANW7vl4wdXo6ORgj+JP4rWsjQiYOv6ixrXykuoT+5YkvJZW0oqJP0MpNyCkTQwr5HAOU8iJzur8+XmZhWmRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295989; c=relaxed/simple;
	bh=8rB5vJvhhbH2aMlHDzM8RmSZU0cMq5AlzOGwTCad4/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzBuvH59D5OU6LiHijLDNKUMcb8GOTeMHiABZAK4tgriN1EauIbFbquKkAJ+T5DE6xX8tuEelscVvFIlTtS2z3SEZtShGCpYPCUsFMRWk0CQGsOlpSk7spq5APUFxUwKhda6z2hG4iwa9MF5UO5gAZEC/YIwaJPiBf+gaHR88GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dh/FDawG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dh/FDawG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CC91F00894;
	Wed, 20 May 2026 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295986;
	bh=7RAzuAiBc+Xjm77H5rv/RkFl84ivbxJKt+3vpsAH85A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh/FDawGJRGp1ivSFAiDVxwGSgl92RzJWi9xK2F9KKuRbGyRjpf2Li/gnaDOwDatV
	 eJH4BHZKEqILkMgo2+34wLNVnrIdBdAH0NR9oAOtGNoQ4KBjjLq/yJ3ju6NfN5fOp2
	 Dv03TpQKbUEyziQGatrdWlJwkvgZ+J3vbUJudro4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0628/1146] pinctrl: cy8c95x0: remove duplicate error message
Date: Wed, 20 May 2026 18:14:38 +0200
Message-ID: <20260520162202.397131930@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 970dacb3b9f0fedbbbcfd7dbf1f4f22340b3f359 ]

The pin control core is covered to report any error via message.
The devm_request_threaded_irq() already prints an error message.
Remove the duplicates.

While at it, drop the info message as the same information about
an IRQ in use can be retrieved differently.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Stable-dep-of: 5ad32c3607cf ("pinctrl: cy8c95x0: Avoid returning positive values to user space")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 5c055d344ac9d..c0f1d964f8397 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1310,6 +1310,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 {
 	struct gpio_irq_chip *girq = &chip->gpio_chip.irq;
 	DECLARE_BITMAP(pending_irqs, MAX_LINE);
+	struct device *dev = chip->dev;
 	int ret;
 
 	mutex_init(&chip->irq_lock);
@@ -1336,17 +1337,9 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 	girq->handler = handle_simple_irq;
 	girq->threaded = true;
 
-	ret = devm_request_threaded_irq(chip->dev, irq,
-					NULL, cy8c95x0_irq_handler,
-					IRQF_ONESHOT | IRQF_SHARED,
-					dev_name(chip->dev), chip);
-	if (ret) {
-		dev_err(chip->dev, "failed to request irq %d\n", irq);
-		return ret;
-	}
-	dev_info(chip->dev, "Registered threaded IRQ\n");
-
-	return 0;
+	return devm_request_threaded_irq(dev, irq, NULL, cy8c95x0_irq_handler,
+					 IRQF_ONESHOT | IRQF_SHARED,
+					 dev_name(chip->dev), chip);
 }
 
 static int cy8c95x0_setup_pinctrl(struct cy8c95x0_pinctrl *chip)
@@ -1362,11 +1355,7 @@ static int cy8c95x0_setup_pinctrl(struct cy8c95x0_pinctrl *chip)
 	pd->owner = THIS_MODULE;
 
 	chip->pctldev = devm_pinctrl_register(chip->dev, pd, chip);
-	if (IS_ERR(chip->pctldev))
-		return dev_err_probe(chip->dev, PTR_ERR(chip->pctldev),
-			"can't register controller\n");
-
-	return 0;
+	return PTR_ERR_OR_ZERO(chip->pctldev);
 }
 
 static int cy8c95x0_detect(struct i2c_client *client,
-- 
2.53.0



