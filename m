Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590295;
	b=JAOlC6Fa7C/VXNHnH+TOOhlV+CXyXwnQL59yHjHLrr6aIXtmeB+TUzv3Ej51058lmBcJ
	 fooVhrj9qcWGZKT16HqJkJ11/z5xTnVoLmFkhWA8q8FyaV7TIZDDg31TvAvL4evVNZQ++
	 7gstL2KpIgvqpHQHQdQtXdjWMvTkC4qMvLtKEAS6jVvwmyOUvmAO9IWIui0TWkx2JA5aD
	 ZJ/vVLTLTFBMwHDCqcuK9mtzOZIT1XMhODMzkcFRdHmJxRr/cjeOYB5QwdxUs9ofvmYgR
	 dawwgTbME6boO1BzRQgQ8I92dbXhaOzStNoxidLxWJLEXp/Vlxsx9m/cueYVaGYMJgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tb/aAtadypjUjpynUjJq/XftM2Je0iCdU+xToN5LELs=;
	b=bajBuTeT2kxPzXh5LbyLHiVj2aH4LFibT7QdI37TaLtCgs/y03WcaxXMZjhuIqZhC3oc
	 UsLDc8LnY8WGcnDmNfbMyhCRbCc8ujtEFKVRxvI3Wb26LcX+Ro4/Lu8N20BHUAM7Hc4BY
	 G2ZLOpBF5Jeey0o9an/6Zk3yhiQGBV/cD0JkH6+bMP2p9a24jh4JbnGAMQ70seWljxW9E
	 MXRlaLWFt4TEfWVriL5xuj/zKoSrtixYqWL+gBmZbAHmL7nbaYdJ9jCaqxPM1MIifCOs7
	 L40/1VyASOhhs5e25f8nBTMNcvspSFvvQ1OEBl3/IwjtgPhyA2HFWYSLpnDzWoTlIcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2NY6piN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F7E607B597;
	Fri, 13 Nov 2026 17:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2NY6piN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB18A1F000C5;
	Fri, 13 Nov 2026 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590294;
	bh=tb/aAtadypjUjpynUjJq/XftM2Je0iCdU+xToN5LELs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2NY6piNEWCXjuOfmD8v4RkV5XPNAlCqGjvaPmUFOsmH/VoWwi06XJZ0s3xyc/TEB
	 pZQf04jdBT+SSRyVOeZ2oLUp48U5diTl6M4rxgMB9224hJTem1o35H/U9h4K7YIrED
	 e+xaxQpEsmC9hW6KTgJFPc03oUsNVK0jNsvo2ycA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 283/686] hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()
Date: Fri, 13 Nov 2026 10:46:56 -0500
Message-ID: <20261113153830.573282862@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 5b51ff0887b9f88d042b92dd07fcdda4132f0ebc ]

When an LM87 or ADM1024 device is probed with VID support enabled, reading
from or writing to the vrm sysfs attribute triggers a driver data type
confusion in vrm_show() and vrm_store() in drivers/hwmon/lm87.c.

In lm87_probe(), the driver stores the struct lm87_data pointer on the I2C
client via i2c_set_clientdata() and passes the struct i2c_client pointer as
the drvdata argument to devm_hwmon_device_register_with_groups(), which
attaches the attribute groups to the registered hwmon device with client as
its driver_data. Unlike the other sysfs callbacks that retrieve client via
dev_get_drvdata() and then obtain data via i2c_get_clientdata(), vrm_show()
and vrm_store() assign dev_get_drvdata(dev) directly to struct lm87_data *.
Dereferencing data->vrm therefore accesses the struct i2c_client instance
at offsetof(struct lm87_data, vrm), causing vrm_show() to leak an unrelated
byte from struct i2c_client to userspace and vrm_store() to corrupt a byte
within struct i2c_client while failing to update the actual VRM value.

Fix the problem by assigning the return value from dev_get_drvdata(dev) to
struct i2c_client *client and using i2c_get_clientdata() to get the actual
client data.

Fixes: 00a0c905ab4b ("hwmon: (lm87) Use hwmon to create the sysfs groups")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm87.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lm87.c b/drivers/hwmon/lm87.c
index d2d970e73c616..bdd633feb2ba8 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -600,13 +600,16 @@ static DEVICE_ATTR_RO(cpu0_vid);
 static ssize_t vrm_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	struct lm87_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = dev_get_drvdata(dev);
+	struct lm87_data *data = i2c_get_clientdata(client);
+
 	return sprintf(buf, "%d\n", data->vrm);
 }
 static ssize_t vrm_store(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
-	struct lm87_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = dev_get_drvdata(dev);
+	struct lm87_data *data = i2c_get_clientdata(client);
 	unsigned long val;
 	int err;
 
-- 
2.53.0



