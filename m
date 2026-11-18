Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059553;
	b=OeS8nj/9/jQajzkHrKDJjAQOZc//ijAh5zyyIWdDXJhJcdB+OqwTHuA3cY5+FWg1TE8o
	 wYhCXi47IsID43HqsWfxKkOAjyKLW40Q2KTXnGhdctmqyTDzadXxLAqfDzXgNX0cJRXXd
	 CJPRbFaze6WdcXcNQn/53A3wGLbxxo5BoGpuZZD4kSsNgzDZ8oiJsig3Fh4WBDr3aggVt
	 j638ETSj5sBDx2fnxdTWm4MGeLOX5l+DcI+CqIPxHy1gJOXApexlrdH8COEB7adkQvHqd
	 N/kG54DHv2380TZf2g98MS+RCVvNvyM4TeQtZLolp6LBDzl8eDlLrN5+j7gpzQRvQ+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P/99anW0dxfzqIfD5KKFW0QyXTuHE5Tf2YRP926+A5s=;
	b=qkIyMgd5UCgAz4W//qlNvmRZZr483cCwMXFrHbiO1h7aP5lufjnTtCEeRq/RlTGUTFxS
	 V48wrOpte/WdsOW+Ky65fIjmWDvIW2OXJTOa4FosuHPXRQ5KzA8ZcSPqbrjHvqVSI71Ha
	 b2QEKO2gVhXsRGT+eaSwdG7nmwHIzOyernNq2DRQYcNWv3H57SMoTD1UJup+WCM13b0hM
	 YUQhhKfrf4AFOWrFoSXn/J2sBbxudaPawyQ6bV47LhuQKy1aQ5T/v51daDrLhfHF97y+5
	 6r5eEYR3r0vsgbjaHc70UBTE+VLwg3/Esnalk3jryzn+Ij8D6lPfl4tPQuT1zlK1siA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z20Qkvw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE555606A325;
	Thu, 19 Nov 2026 03:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z20Qkvw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2E51F000C4;
	Thu, 19 Nov 2026 03:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059553;
	bh=P/99anW0dxfzqIfD5KKFW0QyXTuHE5Tf2YRP926+A5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z20Qkvw06FNdr21lNA0UgifItEFgbHF5PczQw09+m7G6KfM+/pT7BePX8C/+udvG0
	 T8Vprc5Zi6v7FV9f7LweOtSUh8+su37dfWigKwMbbJHlCB966KC2mECg9UMcgXgwTA
	 ADv38Fm0ck7q1QztTc96vnShEwmVEWio9wflKPuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0881/1848] mfd: twl-core: Unregister the auxiliary platform device on unbind
Date: Wed, 18 Nov 2026 15:48:39 +0100
Message-ID: <20261118145953.261165398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted the devm_mfd_add_devices() error-path change because that code is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index d5e588c68c0c5..57f89771ae098 100644
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



