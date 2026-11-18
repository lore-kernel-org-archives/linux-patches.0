Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028643;
	b=g3Uqw5G+xV6CtGboyHev6GLoJ0BE/WlBxOI2TwuzHhyjgML0mlBqbu1uo7KrYTGHb+g1
	 euYnJ25wGa6sXym51LKnjkP9nG/owoYVvIcPGF6bvVL+Y2e4/bnzgwUM4TUerxZRp2DBO
	 AIJJAPNLyXP8+qRaQLExaEl3lAKCjyRj7KaDILaaLqRgxmc34usD0a3ZLYWBylHrHK5FS
	 piD0YUqiZfAoMrLn5AXiuzkQA+0aBPvQuEkKEqYR4FAJHDq96OIL3kxXgEc/olYTJXVZe
	 K6ii5jzPSBsmt5dlbyAZ7l/3yEYBctwhqK+StbzlaX851vWrBo+84AbKa7pAc/LwrRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gpM9KQ9ouDcE5YAfOs+ViSi1z1zoz7lcDC+DtXo0OPI=;
	b=RCcj5BlTMBNrThLmJBhnWqD9cJXKzg/nOf+QATeBgorVVbzY0BIdZXgtpXvJzRIi9dCH
	 0NqC5sEjAsm4x3qO69Kd8iwqp12lUEpV7FUhYucCdQABgqa39nlV+v9X2HcoV2crgUEOd
	 oh3tqQAt4oVnPxnkdLS9PE2nOSkEvPJfXugqMFhBHiZjTwZ45+yhtCnQNRxaeqaA8/yos
	 AVWwax/Oa4trAqvO+xqaITiawx0rw3V0Ft2EL6IB1+/augTT4uTigQlOOurUZLYzIJQlZ
	 uuGU92YoCi1VFbNirystQgsWkmQI6cDNK/HWs70lEZcOsDFGnkc9USd//DoEW3MLZGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09uff5Dz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB91606A325;
	Wed, 18 Nov 2026 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09uff5Dz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769E81F000C4;
	Wed, 18 Nov 2026 19:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028642;
	bh=gpM9KQ9ouDcE5YAfOs+ViSi1z1zoz7lcDC+DtXo0OPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09uff5DznC1+cfJObRM9GxzFIbksWSThmX9/lrtPPjaaRVc3sNauKYf9vvRqLepSV
	 5lwaBYCpqQ7Fn9FhFlEz7jfxdPFmAvXV/VeYa7VTIfu0u9I4Xkl/gZKvbHT82eAram
	 9QguyoeC/KfiqByogBbYrS2OghtX+CYrJ9E5Lgeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0025/1756] hwmon: chipcap2: disable device after hwmon teardown
Date: Wed, 18 Nov 2026 15:35:52 +0100
Message-ID: <20261118150008.893002259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 4724ac5556ce63f01a3f5d61fc7fcc20f4ddef3f ]

cc2_remove() disables the device while the device-managed hwmon device is
still registered. A concurrent sysfs callback can then enable the device
after it has been disabled during removal.

Register a device-managed disable action before registering the hwmon
device, so devres unregisters the hwmon device before disabling the
physical device.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-6-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 0f7711ca6feb7..6a69c7699594b 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -166,6 +166,11 @@ static void cc2_disable(struct cc2_data *data)
 	data->regulator_enabled = false;
 }
 
+static void cc2_disable_action(void *data)
+{
+	cc2_disable(data);
+}
+
 static int cc2_cmd_response_diagnostic(struct device *dev, u8 status)
 {
 	int resp;
@@ -747,6 +752,10 @@ static int cc2_probe(struct i2c_client *client)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get IRQs\n");
 
+	ret = devm_add_action_or_reset(dev, cc2_disable_action, data);
+	if (ret)
+		return ret;
+
 	ret = cc2_request_data_ready(data, dev);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to request ready irq\n");
@@ -781,13 +790,6 @@ static int cc2_probe(struct i2c_client *client)
 	return 0;
 }
 
-static void cc2_remove(struct i2c_client *client)
-{
-	struct cc2_data *data = i2c_get_clientdata(client);
-
-	cc2_disable(data);
-}
-
 static const struct i2c_device_id cc2_id[] = {
 	{ "cc2d23" },
 	{ "cc2d23s" },
@@ -820,7 +822,6 @@ static struct i2c_driver cc2_driver = {
 		.of_match_table = cc2_of_match,
 	},
 	.probe		= cc2_probe,
-	.remove		= cc2_remove,
 	.id_table = cc2_id,
 };
 module_i2c_driver(cc2_driver);
-- 
2.53.0



