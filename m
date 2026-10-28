Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213793;
	b=h5svoU+fEWPRPbpnU7JFGIjUEAD97fRZqM8La8stpg6jAi+3FpFcazQ+jHtxwbmK9TuS
	 miRQMW2zovPrODwJ+HKGWjVFlUQSohGuSAlmNkZ/KoXPp1QdtLx3aeC3jtwrQ8MbnCatx
	 2iz+1hsUK+p9ZZx9Gm0iX3S2sLqo3Pp3VGZCRN6o2j8nYCVU9H6oOegh8xiKon63kCavx
	 N/dMRhe8pr9PmrjUVW0SNmR+dbu2t9109tJc0sqsfMNpktUz97jz7AZEqcwrDTcEHjcQl
	 FMXAuqjkHJ6xC/aAZw3gPoo1yagG34vZbfEhtYFuUqV2itAAqnpuBMMqlg37DPO807Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PDJeYsofSE6atR37wnVXn3P5KmOjuOJFbAUjUfzKZ/o=;
	b=lpkuaQiZtQpUbA74ML1TtPwDMuPaXSP78l5cv91KSd6bKrsA2w+dID1nc8Y6/bVuAHwY
	 vAE/XDZjeIIU7S2UcuJPDHBbvNrJtaZeaTjTVU+koGdjk56djMNYloGBvwSA1Hf+lgkTK
	 UyMj7pMlIbpqSISAbkogU7ynJpg5kB4aXkbncdYlFL4jOdCpH91cpTg8nAf6GLavc74uM
	 U/F+EJGOQOkadXW3V0fZWM/Wtr0WF1+oriZ2QKSYWlitIdeKjmP2EJIXGeijgif4DzOPk
	 /GH0JYGcHd4PjaOkNzxHeXfTzyjaLEb6PDz1Da31qSMrPylYk8rJH7hUX6h8Vj5fuZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+P199rZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3432A606A31C;
	Wed, 28 Oct 2026 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+P199rZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824CD1F01825;
	Wed, 28 Oct 2026 18:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213793;
	bh=PDJeYsofSE6atR37wnVXn3P5KmOjuOJFbAUjUfzKZ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+P199rZOAX1GS38oOJXoPvqJkbeD1OcKbysKp4/S/c7ySmtWRozalHLkjFa8CyvE
	 YMNl1Ss/Xue9VXyIv8X6nsdi5yJFQoE+lQhJnTgcktVKXKddsc45yEVlume8dzKM+g
	 Wi9+7C4+dpQ1obaxMCU8K1pqvj1tCorI4MgnPXVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Stark <gnstark@salutedevices.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0632/1887] leds: an30259a: Use devm_mutex_init() for mutex initialization
Date: Wed, 28 Oct 2026 17:45:28 +0100
Message-ID: <20261028170513.790703942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: George Stark <gnstark@salutedevices.com>

[ Upstream commit c382e2e3eccb6b7ca8c7aff5092c1668428e7de6 ]

In this driver LEDs are registered using devm_led_classdev_register()
so they are automatically unregistered after module's remove() is done.
led_classdev_unregister() calls module's led_set_brightness() to turn off
the LEDs and that callback uses mutex which was destroyed already
in module's remove() so use devm API instead.

Signed-off-by: George Stark <gnstark@salutedevices.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20240411161032.609544-9-gnstark@salutedevices.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-an30259a.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-an30259a.c b/drivers/leds/leds-an30259a.c
index e072ee5409f7e..374011e3121e3 100644
--- a/drivers/leds/leds-an30259a.c
+++ b/drivers/leds/leds-an30259a.c
@@ -296,7 +296,10 @@ static int an30259a_probe(struct i2c_client *client)
 	if (err < 0)
 		return err;
 
-	mutex_init(&chip->mutex);
+	err = devm_mutex_init(&client->dev, &chip->mutex);
+	if (err)
+		return err;
+
 	chip->client = client;
 	i2c_set_clientdata(client, chip);
 
@@ -330,17 +333,9 @@ static int an30259a_probe(struct i2c_client *client)
 	return 0;
 
 exit:
-	mutex_destroy(&chip->mutex);
 	return err;
 }
 
-static void an30259a_remove(struct i2c_client *client)
-{
-	struct an30259a *chip = i2c_get_clientdata(client);
-
-	mutex_destroy(&chip->mutex);
-}
-
 static const struct of_device_id an30259a_match_table[] = {
 	{ .compatible = "panasonic,an30259a", },
 	{ /* sentinel */ },
@@ -360,7 +355,6 @@ static struct i2c_driver an30259a_driver = {
 		.of_match_table = of_match_ptr(an30259a_match_table),
 	},
 	.probe_new = an30259a_probe,
-	.remove = an30259a_remove,
 	.id_table = an30259a_id,
 };
 
-- 
2.53.0



