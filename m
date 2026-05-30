Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A6D263F44;
	Sat, 30 May 2026 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161448; cv=none; b=UQj2zds40I7/oE4VG3IDmIzhmc/n8rObP093j+EdhzH8/AYXDmZ9rlD4y3aerD0+W+4SoaWhXqB93iC4Hc3cmT2b8bVxVF0ovJe8vJi6CfERxa3thbEkB+6C2M8IlnDbm67M/oOE6v1WRDr9gNhhxJi89ZsmCOfmgZwy7XbEt3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161448; c=relaxed/simple;
	bh=PUmChrO0zhVyMQDt0Vgbjm0+fLQh01T0ar/rI6D7Tlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHQpT6f/eKMTOobPJNvN3GBIrt11yLY34BVXUbD0sOPmrPeVHjEfvxtZ8C/T96zVs1CR46iH5sme1B6QBtiimyQEDKQKA94G9E6f1zT48Jg4e357/V8p6SOEwIvYKvkqrG8oyWLrxVkfyEbm8i0PS+NOSwrdiws3G2FWQ0kArOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Urct9U5P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Urct9U5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BFE1F00893;
	Sat, 30 May 2026 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161446;
	bh=CMXhVPYnPLqVRPfe+7U1MD5HmqD8PoOhUqUdM13PBqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Urct9U5PSj7TH+Lyjl9fVAA5hAIcTv5mBCkLpzmBYtCtZ0db4hxezB0I1DEB43NmP
	 2viUJC2UwN6dBrN7Hus/nWYZNvSnZ3hPGk35+JFwXneXbzILNH0Vyj/EOFZHchLsXd
	 0Kf4P9w5k5byqR5Z465FYkpfd8MBNdejTXfEjLiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 626/969] pinctrl: cy8c95x0: remove duplicate error message
Date: Sat, 30 May 2026 18:02:30 +0200
Message-ID: <20260530160317.734516345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f7c8ae9808133..c60886d804ce0 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1206,6 +1206,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 {
 	struct gpio_irq_chip *girq = &chip->gpio_chip.irq;
 	DECLARE_BITMAP(pending_irqs, MAX_LINE);
+	struct device *dev = chip->dev;
 	int ret;
 
 	mutex_init(&chip->irq_lock);
@@ -1232,17 +1233,9 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
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
@@ -1258,11 +1251,7 @@ static int cy8c95x0_setup_pinctrl(struct cy8c95x0_pinctrl *chip)
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



