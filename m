Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046896;
	b=sIrljp4BSFpQr127a1G2J8z2g9UFQDfa92SMiP0Ofb1gjOeZFZ0bTFQE4pF6AVPijr75
	 ik+FfaDZQlp5r2EEiczazoe9f17ezILWh4x5tTcOHfDV2pYgXVDLKyV0pV+Yk63zpSP7c
	 KvD83/tRYXMMPb1yjdlCBX6yywbQrMU1cM6O7hv2yP8IPbTxEbCJRf+XLimXxzRmSnvae
	 KugQFoE+zBEbbJCYxNOhUukMAoQ/CwglywCiXXyvUqks1QYzAamWNwTxJpEmX1WXn7rtA
	 XDQgpANi6/IelK5/CYNoiNPg/kZabOJalUxzuYQzHQRsFOrJPY60+jav8JcZOBd5P7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E97MLsKHNad91O44qsmmhz5OR+q7jxSBSA3MpUMzqC0=;
	b=5tXurCI00CprTq9kx5C2a/egUi22j1EH6VhkUpiulihAjF6pvT7LEw1rwybdU7ES8OzG
	 V/YOA0FbxO4eo0Mgg1j045rE5A3cLlNIsOxY84Jz8FrH1Gccg0Otlw9wCY28XUZr7TU0z
	 5CeqtaEY2cjesE7dzdLBAMRSUsitPKbMPqFl+sXuxxocn8H39qx1mtRTJfVmViGnOx0v4
	 oDj47LnRWe5Za94nZpr7HyoqFEspvB1g33GA58WkAT6B00lNLoBwuZuhsKjmJzRe/X8e1
	 uQWHaAjjHrYPNDnkObljK5Xsi9zVdVLwo1m9QFV8UN+ydBN6yW2gJnq1OKvmw3UxYfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3ELxAKt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C4B606A32A;
	Thu, 19 Nov 2026 00:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3ELxAKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2071F000C5;
	Thu, 19 Nov 2026 00:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046896;
	bh=E97MLsKHNad91O44qsmmhz5OR+q7jxSBSA3MpUMzqC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3ELxAKtoEvktL/LGj/gJK1ydkcYifihYhnEyYfgoPQLvoYWvTk2/TXxqwkjcQ7l4
	 467pbT4FjBgKjsO0LqWfEFH1fZvdrm0fZdp7md2amMMNgrx0CuG+sLrTXL6Y3KQslb
	 rfeG8UchvdUAtQBS+luXvGxLY+DnJ6pxfiWsV5p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1445/2857] mfd: twl-core: Unregister the auxiliary platform device on unbind
Date: Wed, 18 Nov 2026 15:41:19 +0100
Message-ID: <20261118150253.342111150@linuxfoundation.org>
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
[ sashal: omitted the error-path update for the absent devm_mfd_add_devices() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 6c589d71df2a9..703a6ebba7003 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -752,6 +752,11 @@ static struct of_dev_auxdata twl_auxdata_lookup[] = {
 	{ /* sentinel */ },
 };
 
+static void twl_unregister_device(void *data)
+{
+	platform_device_unregister(data);
+}
+
 /* NOTE: This driver only handles a single twl4030/tps659x0 chip */
 static int
 twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -786,17 +791,22 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
@@ -820,7 +830,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					 GFP_KERNEL);
 	if (!twl_priv->twl_modules) {
 		status = -ENOMEM;
-		goto free;
+		goto out;
 	}
 
 	for (i = 0; i < num_slaves; i++) {
@@ -907,10 +917,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
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



