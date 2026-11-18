Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053999;
	b=ZDjbi6VYEv7ghlfvI08h87FwU5um1EJOrYR378N1y1uVqejojDCq/Jefhi6RPh1Ip4Ku
	 zQDBhBa05AHrHdhYO+IuBqPs1FCKpE1cPSqGLpU5uZAChkXOiIzaXGkbYogN9hcjqjY3R
	 h89YkKldm0ncVl8+MJmY0m4C0Ry7tVLDxLL0HWbp1j7rmuYBJqZWiLSHZ4AHtbnsmzo0E
	 P86w8pd0rIjYKBPBosYBFvW/191j1sKXxENEjEyByCOkrPdH0nDFL1+ncvzdYkPgfKJ1y
	 T6h5wC72zi7WsQOouWQAiJy93pMVPUmPys5l6xnDB6ladeJb3NIhBkj1PdiylSMyqjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NjkNrfTWpyNlApRCDaNYH1dFbyMmBrptfsgud6YLZV4=;
	b=i1Nf488LEE7imq+lbVivJXoHi+A8zOKvdnW6nETsSuAGz3g05UFjGyO7kMsyNCZ0Myg5
	 9zw7hMrXFtlNYmFSTsVmupCH+sllY1eYQmsRRFkbRjGINniEr/z5Ygqexxd+nCRrlKu0h
	 XSpgouyMyUgXot3IDnX0gmgTSzMes0iRjZsIS4fcy5W6aGPn7lrhhP5dpyyjWuove5Sef
	 iX/wVvib3nz7O3mEmBpRlU4EoO+nQGBWP+Of/9L8FOK6qheHiNa0fuVtneu7cGar94YVd
	 lggXNWqwP+gnCY1x0EqUMajxK7LXj6AuJ3Op79Tham0HrxmT9aqac0GnaTWY+kSlMtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhWUxGcb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23331606A320;
	Thu, 19 Nov 2026 02:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhWUxGcb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789CC1F000C4;
	Thu, 19 Nov 2026 02:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053999;
	bh=NjkNrfTWpyNlApRCDaNYH1dFbyMmBrptfsgud6YLZV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhWUxGcbdKeMihGxgwrGJVSSc5IdXTJjoCGHQfnHECJ+DWPi7aTS9O8OtA83EWbub
	 SR+dI4K4mMr1a5Pta1NUSBqH4lsOemQQ0rSoDdksAVt6n6hTXo8E/NUfggOgkSGlbB
	 ojVaKznaHyruJP8x9eBcrRlkyaJagfUD/zkfLvj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1120/2214] mfd: da903x: Cancel IRQ work during teardown
Date: Wed, 18 Nov 2026 15:46:36 +0100
Message-ID: <20261118150056.902871290@linuxfoundation.org>
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
[ sashal: Adjusted deletion of da903x_remove() to include the return 0; statement in the int-returning callback. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da903x.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index a818fbb559888..3ff1a00b409c3 100644
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
@@ -529,15 +548,12 @@ static int da903x_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	return da903x_add_subdevs(chip, pdata);
-}
-
-static int da903x_remove(struct i2c_client *client)
-{
-	struct da903x_chip *chip = i2c_get_clientdata(client);
+	ret = devm_add_action_or_reset(&client->dev, da903x_cancel_irq_work,
+				       chip);
+	if (ret)
+		return ret;
 
-	da903x_remove_subdevs(chip);
-	return 0;
+	return da903x_add_subdevs(chip, pdata);
 }
 
 static struct i2c_driver da903x_driver = {
@@ -545,7 +561,6 @@ static struct i2c_driver da903x_driver = {
 		.name	= "da903x",
 	},
 	.probe		= da903x_probe,
-	.remove		= da903x_remove,
 	.id_table	= da903x_id_table,
 };
 
-- 
2.53.0



