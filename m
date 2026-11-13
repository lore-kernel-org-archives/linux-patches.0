Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591439;
	b=utZTZkhXIlaryUC677rhwZfNmNVRjCEoRh5VmgOPB3w67iNUsRDqlv/sZGgd9RqoqKKM
	 XJYi2SpBh18d/7F35lqmmNCkPo4zhIkaNuDUbnWYteb16VM0Xp5xsMtZihU6ZDo24l9sA
	 I51aDSMabsPRCVjKEeBc9lF++FBXcEWhsoUiDvMmeKYS4fGwv1bYru3oOqPE+e0H/E7OA
	 9/LobE84mTJDnRyJSi+nnuBTr+pKzd62+e4X2ec5t9El7EV9MNSJeNOrJcojDojKGDEHL
	 9w/i1HlgzfbgJSBCAEjeJy8fY8sn+QmGkYbg6YUDy3MgrEkfUeKDLAfbO66Kbf4NQcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=67PWJ5AxxEzuIEV3LRAMiBEPVdklW8EOnRkTCA36k1g=;
	b=KZEw6BudOJdb/xCjLJaZ9X58+dNxbvkoFJ5zp/FgVzQ0Z89+KQzeMZTRt5s9YT7dbU03
	 6S9XZMNdTb88bJ9MQlrsRyiOPQuX0f8YnCV9Seh9075h0mmdx8d+RqeWoDiM9UANf+2XB
	 8RYB/NZxJ+/Y18K1dKiIftvKDw/QHw/C6XiXtOzog1gQwDZvYkqRWybU6EDToPDsAn4ER
	 zPneFp7wG2Yyd1Zwk0h154M6zo0clKI7A7i8jMIFY5+djEZ/XOVbYaoszYxQx3LfsQLWN
	 2xpQfL1hXSUj5lrZXnzi07vWrVqqBnNT1C38RHPNeznbeyNCTXvwlZRf/uKQAfXieKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHJTguT2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8FB607C354;
	Fri, 13 Nov 2026 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHJTguT2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678A01F000C4;
	Fri, 13 Nov 2026 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591439;
	bh=67PWJ5AxxEzuIEV3LRAMiBEPVdklW8EOnRkTCA36k1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHJTguT2R+nlfjPkegKv+n8DdYxvLpNQg/OELGcMHQKNiCShmgj83m18kufAxpbrD
	 LDe234K2OIPw/Dzvmpj+PB7yGQMC78eUt2XJhoT+XAi/1j2SBw9Xqgwt1RPX3yzbs5
	 ImhvB38Fsd5Z6DWb+IQurZJgLghLKSfDgfBBP/6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 531/670] mfd: twl-core: Unregister the auxiliary platform device on unbind
Date: Fri, 13 Nov 2026 10:51:35 -0500
Message-ID: <20261113153829.911817668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Adjusted context to preserve the separate TWL6032-only clock registration block. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index c53be506311a3..8334066f8e22e 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -715,6 +715,11 @@ static const struct mfd_cell twl6032_cells[] = {
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
@@ -750,17 +755,22 @@ twl_probe(struct i2c_client *client)
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
@@ -780,7 +790,7 @@ twl_probe(struct i2c_client *client)
 					 GFP_KERNEL);
 	if (!twl_priv->twl_modules) {
 		status = -ENOMEM;
-		goto free;
+		goto out;
 	}
 
 	for (i = 0; i < num_slaves; i++) {
@@ -868,7 +878,7 @@ twl_probe(struct i2c_client *client)
 					      ARRAY_SIZE(twl6032_cells),
 					      NULL, 0, NULL);
 		if (status < 0)
-			goto free;
+			goto out;
 	}
 
 	if (twl_class_is_6030()) {
@@ -886,10 +896,7 @@ twl_probe(struct i2c_client *client)
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



