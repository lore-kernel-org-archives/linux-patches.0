Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585539;
	b=b1EkcaZOlGqfQgHHx4V9YBYuXi5RH2LTwRV82lp99+eAdF18idtiFsjTmMDz0+pzdKAL
	 +KjuEGcg2lng+wahxTl7wPi6N17fX26Ba4mcv4R5c/zOA96tIvSBmZzDn50hhN1mSiLcZ
	 LrJAqOIXTcB7zEg0fhZvtI6qoIE+24ChMj/ft3Bn1J0TSB9/yiWWwyk7nhVVvPYJFkTDF
	 ckWFa4LfSzMhaTidzPd2QsoyHms80biXQXXd66q1bI7GZX3WwUu0ZGJ22lE4nofstaYt8
	 cC+J37B/r5pcEkvkLAJxectLPNxSpCr44c+GeCBgSmZXF9UDQe08TJ41Ah7qIx9OGhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dGMNhmC61/jbdMZG2K76OM8k6Qdk+gNtu7x5xREWyTY=;
	b=go6fgxv+iSC8ZzRmclE9LfT06eKRsIjkcbM9VHm+3Cdz4/SBW8p4PrCqzCxBlKecPsz7
	 fY+yjDqM04jOdOR8V8no8Sd975XaJwwjUxMvu64vq+9BHE9KwT0nJ8XwlYPCX9fEjv+1x
	 E9GUzfgHc7icSyk0pvfmbWcc6rPjQXpNKYfJkEbiiW/50whneT31HNOzhStdSaqAPSUN9
	 LuaXtHvKQgilducM/BnMugCsnEghelELQHbKaox03JXlBvuGf6YIv/pBT8gCJkH7Nps01
	 6rsGC7oGmpWWI6LNToPKbHijTEZi3Xu2HpKfcb1IHCs8Cbo73QyyA+u3sGSDydiu9nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=akS+sAA9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98250606D466;
	Fri, 13 Nov 2026 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=akS+sAA9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E741F000C4;
	Fri, 13 Nov 2026 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585539;
	bh=dGMNhmC61/jbdMZG2K76OM8k6Qdk+gNtu7x5xREWyTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akS+sAA9NyRp4Fxnf2ZUICMk8XMgXQPtv81cf2N0TSOed1VHItI4beicXmSw9AwCU
	 C2dMsbae6juS4DQHajMVSbDuyQqZZU8Ebw2nXuzVn56H5VdF7lc+d6sxH1RN3NJGWa
	 eJPxsWJy7MQdFHln4zFBBAeYYbGkgXFthaAmZg2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 178/507] hwmon: chipcap2: disable device after hwmon teardown
Date: Fri, 13 Nov 2026 10:48:02 -0500
Message-ID: <20261113153800.515110177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 21dc6db27c401..654f6420da7ab 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -152,6 +152,11 @@ static void cc2_disable(struct cc2_data *data)
 	}
 }
 
+static void cc2_disable_action(void *data)
+{
+	cc2_disable(data);
+}
+
 static int cc2_cmd_response_diagnostic(struct device *dev, u8 status)
 {
 	int resp;
@@ -744,6 +749,10 @@ static int cc2_probe(struct i2c_client *client)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get IRQs\n");
 
+	ret = devm_add_action_or_reset(dev, cc2_disable_action, data);
+	if (ret)
+		return ret;
+
 	ret = cc2_request_data_ready(data, dev);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to request ready irq\n");
@@ -762,13 +771,6 @@ static int cc2_probe(struct i2c_client *client)
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
 	{ .name = "cc2d23" },
 	{ .name = "cc2d23s" },
@@ -801,7 +803,6 @@ static struct i2c_driver cc2_driver = {
 		.of_match_table = cc2_of_match,
 	},
 	.probe		= cc2_probe,
-	.remove		= cc2_remove,
 	.id_table = cc2_id,
 };
 module_i2c_driver(cc2_driver);
-- 
2.53.0



