Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053808;
	b=QkwAUBWWsaR/U69LZbLD2MH4+YF7IllT4PhIkYUrT5a/78bCuSV6TnqDkfrnivJx6p6+
	 QA6lvkUy47rTwWnC9ETBms5mhsRF8JTuCC3RXb1/wJx5WIGrvYUgruX8d+xSUkWSDltie
	 4B/I4VhHPTF5ii/wi7xite3onv9hW5BtsrEqZahGOv7kp5RTfCWHnGoB6hqL3MGaDfcyD
	 U1hgjCq81stHGuHfFum1Ykbbnc70pZ3dvI3koeve7dc0qURlWfikbO/1VyBg9/i5UgW77
	 niJNUMi9tiotNt717N6TW4UF4Sbahr0lsV7Jb4vaRyRATaLLY6w/CQcnRm4t7JPJsoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JCjXTN/61JNiQkqY7k8h5geRjWoMPsuDgMv9jIezm4o=;
	b=naqbv7wY+8PXIymrUb+SphlWruePz3jyKz1OIY3wOy9Tx9Vk5IfX1m5N+fvpbnm9cZ6s
	 wi/VyOtDcFHzacyZ6eBAEs5ihQxPwfWoCkSLc0TwDda16eG9rOvGKK1RThW9Lch+203Yj
	 lLDlgqg7CujHXjP+0HiiljY+h3GeLHl+RFN8J3sUUF5Mky0j0MuifKLl1p4bcdaqEvbJ7
	 TCKA7FU/0dZ/DAwVWb+6tEIbj8nTsQG4uCimwY01/DYXyKXLKiODO0TuKKhhu/F08/igo
	 xu+GTUPPBh5EMJE2R2e/kxepIwcA8yGtof1hUUbmBJugoB/0PpnmJiUb33NT7LIf95A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXVBNrYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D32606A325;
	Thu, 19 Nov 2026 02:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXVBNrYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A5E1F000C4;
	Thu, 19 Nov 2026 02:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053808;
	bh=JCjXTN/61JNiQkqY7k8h5geRjWoMPsuDgMv9jIezm4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXVBNrYsXMmkuYmxe9irmcEri9Cm7udiSH4KmwTHQDVof0GMsujRo9tE9JAgmtk6t
	 qSPohUiyJg0yL3LUD24F7ACzisyGhZGtFz94nTlk7vQfQthhhZmXgY5OcapH1dZM8z
	 m14V5JoKpT5J0UbY8zbmMW6pwLJJQDrBPpYf/YOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1050/2214] mfd: twl-core: Unregister the auxiliary platform device on unbind
Date: Wed, 18 Nov 2026 15:45:26 +0100
Message-ID: <20261118150054.334514720@linuxfoundation.org>
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
[ sashal: omitted the goto adjustment for the absent devm_mfd_add_devices() error path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index acfc0b96b4a1a..9b1ff86632122 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -757,6 +757,11 @@ static struct of_dev_auxdata twl_auxdata_lookup[] = {
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
@@ -791,17 +796,22 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
@@ -825,7 +835,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					 GFP_KERNEL);
 	if (!twl_priv->twl_modules) {
 		status = -ENOMEM;
-		goto free;
+		goto out;
 	}
 
 	for (i = 0; i < num_slaves; i++) {
@@ -912,10 +922,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
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



