Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045130;
	b=UwOfph/YCagCq9lDnJBV7YsD4K45M6cK76QhzWz3D+th8N9ZBpkR9lB4mskMC9xcQA0U
	 UUUu6r5zM3IN4sJWEKJItKCJTzJhiTJBZb1+wg4WPWMWD3JaCXpIwlhK1Wy8pR6kFQGBT
	 QFvSOw8v3gThGZRXwVWgODqM6VvYqXdq9/0BSxraKmx1iDE7a8/5ACQA1rAKZYAD6Ot2o
	 ROqcWn0iXrMY+CJVzkjmyXq9N26RzklAakfyrAlGYLWsFBElFXD253zR5yYfPnixuZOY8
	 LjOktNiB/d5PibUQfjovPxUzBySvYugP/oANztGfDWbup7aKE39ilAT3RvKH9H+J0xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mKyqI1YaM456GVymLtLDnDd4cPTHfowC8hRez1ZRgBM=;
	b=Dxjm8iY7ChcSoIIn+knFUgp2r6lVMbpI87jEDHMiak7vUup/K5gMvc0RgSmZzq7rUP/3
	 URfcuErskAiVAc/W1huWrO92Aps08dKW7rsPMFmix42ebJofy0SbldURUU8cfCN/+ATiU
	 eMTAlYsMfQeuJf8D7l/VGjhR+orUF4za23D0zEvMAjKgEf6UIhpP+B+RKBv5lfTkxwD9e
	 FPam2lzv+UtH+m2iiMNqthElFNavjEFtctXpay4fC7I2L4IgqhxMDMkPi7VetwY3VXw3Z
	 bEuy3uBcvF85CgTkDPZYP6O38/YpTNdpQKJq/pDTPlYxNo76qJGDwLKcZqOJxWXpnkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrUBKx6t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDC6606A320;
	Wed, 18 Nov 2026 23:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrUBKx6t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76221F000C4;
	Wed, 18 Nov 2026 23:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045130;
	bh=mKyqI1YaM456GVymLtLDnDd4cPTHfowC8hRez1ZRgBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrUBKx6tZn5uWV9Ux2f4czRWBOTrlprBs+mOyoc0n1ykD0PvhpzQ/OPHO6JdGvfep
	 q2m8buCxXpy6/Bq3glknWL5Zv3kNfRVbEzOTKvzzl2rvpw6DX3LMFCAb/mq+XlCtLm
	 +zGegn3wbe/ZSttg/+DhQzRJrY0WEwVtAS6nLavM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0813/2857] mfd: da903x: Cancel IRQ work during teardown
Date: Wed, 18 Nov 2026 15:30:47 +0100
Message-ID: <20261118150230.847244914@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit fd2258999ecdc7164ef0cda2d4102e4558a5660f ]

The IRQ handler disables the IRQ and schedules irq_work. Releasing the
IRQ does not drain that work, which can continue to use the devm-allocated
chip and notifier state.

Manage both IRQ-work cancellation and subdevice removal with devres.
Register the subdevice-removal action before requesting the IRQ, then add
the IRQ-work action after the request. This avoids leaving a live IRQ
without work cancellation if action registration fails. Devres cleanup
then disables the IRQ and drains the work before releasing the IRQ and
removing child devices. Register both actions before creating the children
so partial probe failures use the same ordering.

This issue was found by the author's in-house static analysis tool.
The patch was reviewed by the author against the latest mainline tree.

Fixes: 26b8f5e1e2d1 ("mfd: add base support for Dialog DA9030/DA9034 PMICs")
Cc: stable@vger.kernel.org
Suggested-by: Lee Jones <lee@kernel.org>
Assisted-by: Codex:GPT-5
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260814153019.1114-1-getshell@seu.edu.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da903x.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 3f8f6ad3a98c4..3ff1a00b409c3 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -421,6 +421,14 @@ static irqreturn_t da903x_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void da903x_cancel_irq_work(void *data)
+{
+	struct da903x_chip *chip = data;
+
+	disable_irq(chip->client->irq);
+	cancel_work_sync(&chip->irq_work);
+}
+
 static const struct da903x_chip_ops da903x_ops[] = {
 	[0] = {
 		.init_chip	= da9030_init_chip,
@@ -456,6 +464,13 @@ static int da903x_remove_subdevs(struct da903x_chip *chip)
 	return device_for_each_child(chip->dev, NULL, __remove_subdev);
 }
 
+static void da903x_remove_subdevs_action(void *data)
+{
+	struct da903x_chip *chip = data;
+
+	da903x_remove_subdevs(chip);
+}
+
 static int da903x_add_subdevs(struct da903x_chip *chip,
 					struct da903x_platform_data *pdata)
 {
@@ -484,7 +499,6 @@ static int da903x_add_subdevs(struct da903x_chip *chip,
 	return 0;
 
 failed:
-	da903x_remove_subdevs(chip);
 	return ret;
 }
 
@@ -520,6 +534,11 @@ static int da903x_probe(struct i2c_client *client,
 	chip->ops->mask_events(chip, chip->events_mask);
 	chip->ops->read_events(chip, &tmp);
 
+	ret = devm_add_action_or_reset(&client->dev,
+				       da903x_remove_subdevs_action, chip);
+	if (ret)
+		return ret;
+
 	ret = devm_request_irq(&client->dev, client->irq, da903x_irq_handler,
 			IRQF_TRIGGER_FALLING,
 			"da903x", chip);
@@ -529,14 +548,12 @@ static int da903x_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	return da903x_add_subdevs(chip, pdata);
-}
-
-static void da903x_remove(struct i2c_client *client)
-{
-	struct da903x_chip *chip = i2c_get_clientdata(client);
+	ret = devm_add_action_or_reset(&client->dev, da903x_cancel_irq_work,
+				       chip);
+	if (ret)
+		return ret;
 
-	da903x_remove_subdevs(chip);
+	return da903x_add_subdevs(chip, pdata);
 }
 
 static struct i2c_driver da903x_driver = {
@@ -544,7 +561,6 @@ static struct i2c_driver da903x_driver = {
 		.name	= "da903x",
 	},
 	.probe		= da903x_probe,
-	.remove		= da903x_remove,
 	.id_table	= da903x_id_table,
 };
 
-- 
2.53.0



