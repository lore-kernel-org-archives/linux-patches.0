Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590655;
	b=INWQHqAj3/gj16bsKQwDZU2f4E75RzgrEwtgnjRT87Hjn9wmv5qY/nREk/jsNBWu6O6a
	 yNG2Jdz3Zns0Fqs1Sv/6QI8cR/cVgbmjcymXx44kuOOyxJdEX/sDIvqaqxwYqAJh1M/AN
	 +D5wyOhvPfKSR4js4nyIheUcgbTnC91lryVAlVa2sefR3QeiUln4zkNFyVI6ZrhsPrzoj
	 fXnFUQCwmY+KvfryVBT+dPAztilR/PTFfJNAFUVqJ0lx6RendCpUhUcO825HdErNqwROv
	 676zcewsBh6H8QpmDolv+QiaKsrqV42j8WW4Y785UJMMZ9yqqlRImKLHgpOxuw8eRHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CyYsZNs/m9Gej2SlNi7X/1ikDXrEYNa1kUVWIUvpN3M=;
	b=c93/4qzK3WuEFkCh/umi4I+eU26yMln3qvunhn2kg2JsP0GX21FjfakOgNA4VpEMnzF8
	 kV9OjwSLlngLNFNOVtaZOUKM4SMmCtsN9lJTLK5XMkVOgycgW7YM2YDhIVoA+HszFF0KP
	 /G/t722gDyFNbzkTjGwN2zNLMDW0Y0uc+DHAxTRozu+XczpN5tbX5pTB0qEyX5izU2b+Q
	 2KgBmdQiojunPqjCRsTBYQCfk64Zy0L5TW2AM9Czb+6+YJlVPQfZQKDQabv7Y70/MAc2I
	 m48UuMp4M72KF/UQrTFCYSqtX6zZV4BHJrujDLOYuN6VMXcWeQKO+9vnVcuR/+npoeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBTD7nN+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A460776CE;
	Fri, 13 Nov 2026 17:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBTD7nN+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730E41F000C4;
	Fri, 13 Nov 2026 17:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590655;
	bh=CyYsZNs/m9Gej2SlNi7X/1ikDXrEYNa1kUVWIUvpN3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBTD7nN+5K7oLw02GeH5Ngqnt4LBDoFxzoSTPhuSjwb36JvfgH751l0i+8bLCSqhz
	 3u/ebZT3RFws9wQAKTm5wkMapgVPMwgsQUGoZONbyxN9nnydWjSopsSvUF5a5y4Mnw
	 vegZSVPZEuUoq+R6kl8PYrqp6EDi/O8qOOBbh2yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 574/686] mfd: twl-core: Unregister the auxiliary platform device on unbind
Date: Fri, 13 Nov 2026 10:51:47 -0500
Message-ID: <20261113153841.110137518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 3c5c55d979ddcb0765ce531bc7ba173c87c8712a ]

twl_probe() registers a standalone platform device named "twl", but keeps
its pointer only in a local variable. Probe errors unregister the device,
while successful probe leaves no way for twl_remove() to release it. The
platform device therefore remains registered after the I2C driver unbinds.

Register a managed action on the I2C device immediately after adding the
platform device. This unregisters it on probe failure and driver unbind,
and also handles failure to register the action itself. Remove the manual
error-path unregister to avoid releasing the device twice.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: defa6be1c821 ("mfd: Fix compile for twl-core.c by removing cpu_is_omap usage")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260913205013.54777-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index c024a28b057e3..128cd3f6c60c4 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -719,6 +719,11 @@ static const struct mfd_cell twl6032_cells[] = {
 	{ .name = "twl6032-clk" },
 };
 
+static void twl_unregister_device(void *data)
+{
+	platform_device_unregister(data);
+}
+
 /* NOTE: This driver only handles a single twl4030/tps659x0 chip */
 static int
 twl_probe(struct i2c_client *client)
@@ -754,17 +759,22 @@ twl_probe(struct i2c_client *client)
 		return status;
 	}
 
+	status = devm_add_action_or_reset(&client->dev, twl_unregister_device,
+					  pdev);
+	if (status)
+		return status;
+
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		status = -EIO;
-		goto free;
+		goto out;
 	}
 
 	twl_priv = devm_kzalloc(&client->dev, sizeof(struct twl_private),
 				GFP_KERNEL);
 	if (!twl_priv) {
 		status = -ENOMEM;
-		goto free;
+		goto out;
 	}
 
 	if ((id->driver_data) & TWL6030_CLASS) {
@@ -784,7 +794,7 @@ twl_probe(struct i2c_client *client)
 					 GFP_KERNEL);
 	if (!twl_priv->twl_modules) {
 		status = -ENOMEM;
-		goto free;
+		goto out;
 	}
 
 	for (i = 0; i < num_slaves; i++) {
@@ -880,7 +890,7 @@ twl_probe(struct i2c_client *client)
 		status = devm_mfd_add_devices(&client->dev, PLATFORM_DEVID_NONE,
 					      cells, num_cells, NULL, 0, NULL);
 		if (status < 0)
-			goto free;
+			goto out;
 
 		if (of_device_is_system_power_controller(node)) {
 			if (!pm_power_off)
@@ -896,10 +906,7 @@ twl_probe(struct i2c_client *client)
 fail:
 	if (status < 0)
 		twl_remove(client);
-free:
-	if (status < 0)
-		platform_device_unregister(pdev);
-
+out:
 	return status;
 }
 
-- 
2.53.0



