Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062076;
	b=gH9m8vZaue7f0XsfIrCpQPBszC0RoPKKlUzQpqxmAd1jtyDw3Tsf9jIMIIGAJojvxYD6
	 3rsxaE6kTFmQNI7DHCP7UEddrSisoMzxBTODZrX0Fgwd7RUExjpygd+5lQhMTydcQY7TJ
	 sLN6UQkUupjPfKpeBk4bgr6GKRvtHEzvdmU8V5Vo75ceQIxefUqiuR3LbN5FKE8CwMbm4
	 SxIGHraVMRGle16y47hAEPMa1+UHiWrXqdS+27rz3AMc5Ks5fnzU0dIkdh+EGSVDioqHA
	 ejz4ky0wLcQ+gwMTRadmZek3HVbniRq10f5X2ysTv5py+jLz3Yv5pAcJvyqL9fnrTJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ktLOTddJjmae3ymGrnH9+E9XrrvMvXqahdT+BR8sIA=;
	b=zkAxCfY3z6T+QGbOfkTWQrmBcnx8dQHSgvVsx6WtRD6+VBf4/6w82ow5hEajZK+npgfg
	 NUGS41Bvgz6mXwmvK0ZD00liUmPaE5ZVpX/dBqxsJctg43bU1v+PsORIpUz3E5MesbWZ8
	 FXcMc69BCBXuk3+2QGb6J/1sQy+dbtAyhvOiO3zatFCZCR5s3hVecRytic0ZaxXRzuFrk
	 c4rlLgk7xCrQIPPIy/VqBXtIYPDFPCPhgqB4QmgbaXtaeHBUvF4900RX1lcw9PAxGF/6I
	 qhfgww/kbQB0gnRYnEQdltRXmDrgEtDwpzzqF1lOLoVjpPqO2ZfNmoJ4efm2hqhCieQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fklX+l2d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F68606EE8A;
	Sat,  7 Nov 2026 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fklX+l2d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77881F008A3;
	Sat,  7 Nov 2026 14:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062076;
	bh=/ktLOTddJjmae3ymGrnH9+E9XrrvMvXqahdT+BR8sIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fklX+l2d7DVK8dyl4chJr5mhGYYI6hvg40pHlMqwaYKxedn6h/mKd5oVxGvuw8qbh
	 SLTTSRyc7K7mpsKBgRQRVrvItKsf1pA6vcrWuRkvkRQapi8UTIMgtUbMk7ACKGlRjY
	 7QH9y4Li3bEOhoqMdmpYfhUvUD3Znv8PP1UXFOTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1053/1536] mfd: da903x: Cancel IRQ work during teardown
Date: Sat,  7 Nov 2026 08:51:09 -0500
Message-ID: <20261107135027.256913068@linuxfoundation.org>
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
index e86b39de3303a..e4ad48e1f139b 100644
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
 
@@ -520,6 +534,11 @@ static int da903x_probe(struct i2c_client *client)
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
@@ -529,14 +548,12 @@ static int da903x_probe(struct i2c_client *client)
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



