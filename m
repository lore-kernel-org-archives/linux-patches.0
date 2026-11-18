Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038434;
	b=0tik/cjevap0JhJ2aThp7hlNZQ10EOROBtePCLEWzLAOIy8326X/inSJg5muyEE7QgVD
	 1g+iqzbbBEn+Ow8d5rcgNNzTljHS6R4A4hIkMkdPNtCw0Pg48gzTPw0CHD5grvu4fSyKA
	 5YWwd+li6JHmd+KewvdADd/5MxUNvz7+3qu0klQ9EaeDr1fiyEt4+g7e1sQtaK9Vk673c
	 ak88bVFESC72Mc4vGlpx9Jg5UnJufe05jH6LDSbBKBUZlpwNDswP2hd9JH/tlh82UUVgg
	 EGwsgnkpaFNFDKAfxFbRNvrhgIMa2zB3+Z6hH80gKk23d4J2HNrPru+zerT59hxS4lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQPaSpyey6G/k7JQbISR4mMOlDw1X4uuxAeDi6nOK58=;
	b=RBKU3FsSsGf7jSZFRt8mjQGHQ0GidjKr8cKccVilVfr4Q4HwJJ/7HDq6uObbPJSUhUY/
	 f18cPmvEuIdI1Zg3drdMvrh2nCOdG84O6EoTFhreiEgU1cIlubMFKlvqt5LLhf2FSfpQh
	 N4EyoyAm/ktsIy27GYLQJZp5FdEkUmcjgwP+xT4Z8RytQFHD3SOuICRIo/4qdwDVgHdbf
	 BFo6vyKn8lpsEcqfDlv3+Mh7eBD3qM0ttCwaeokx0psnwYfweX5ZdDAw6Ge/QwESqtf8V
	 7cz6MbYQjSytzBzs07TLKjHT7pD9iukj6aClYJuyFfZcE/r200VmXcGUKOlqsN24ymg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rvrpz9VV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275FE606A320;
	Wed, 18 Nov 2026 21:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rvrpz9VV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FDA1F000C6;
	Wed, 18 Nov 2026 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038434;
	bh=MQPaSpyey6G/k7JQbISR4mMOlDw1X4uuxAeDi6nOK58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rvrpz9VVv/2uJwSRbpBj6+skwXLNsZ8cUHpr4W6qVTUL47IPvd7r9vIraBZITH7H8
	 2B3SBa/rXbsQ/FaciTtJOn8iJy1RyIN+Z2UA4C1q85qx3l72UBKTEA51l7RB3skglD
	 Vfz5e+8rVksH08fl1D3cgKZCX+eujk5YGe44nCmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1701/3318] mfd: twl-core: Unregister the auxiliary platform device on unbind
Date: Wed, 18 Nov 2026 15:38:43 +0100
Message-ID: <20261118150412.874968771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted the goto free to goto out change in the absent clock-device registration block. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 352a1fb88f08c..a9f5af0d54dce 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -690,6 +690,11 @@ static struct of_dev_auxdata twl_auxdata_lookup[] = {
 	{ /* sentinel */ },
 };
 
+static void twl_unregister_device(void *data)
+{
+	platform_device_unregister(data);
+}
+
 /* NOTE: This driver only handles a single twl4030/tps659x0 chip */
 static int
 twl_probe(struct i2c_client *client)
@@ -725,17 +730,22 @@ twl_probe(struct i2c_client *client)
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
@@ -755,7 +765,7 @@ twl_probe(struct i2c_client *client)
 					 GFP_KERNEL);
 	if (!twl_priv->twl_modules) {
 		status = -ENOMEM;
-		goto free;
+		goto out;
 	}
 
 	for (i = 0; i < num_slaves; i++) {
@@ -842,10 +852,7 @@ twl_probe(struct i2c_client *client)
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



