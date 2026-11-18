Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037620;
	b=00mzgRqTkA/NATxQx7iC1L/zV6yKlTNIOPV9tfCOhljh3dUqlM/QNA/EZ9exH8eASo2g
	 qAdWHgFIY/yd+5wTiaEh/rLzhV0sOPYWZmeLBKxDE60Dm86TAI64cYscBIbm589rNQ6JC
	 39gWd54TaX4AFX1RQheWTVImdVWCyIgJaC/tgZoAQ46G4APbMyLgCnQW9ohPyHWzXHnVQ
	 7u7srlJOon0RmPevdLEo/304sw90XRCT2F9sMyBe4ph2RUl6UX3a7VPj0L0RC1IzRBY3g
	 uTrE38QT7JJD7R3ZyCYYsH/q+hkL0/eBYrCltPRp6zz806mEccirXeakbPKoVqQ9cSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcFFWdsvw/ViKqvNnfdCSZ+o2xHsmndy/ZEVHOo1lq8=;
	b=plK0yHjqFzS9ecCzdMCBt8FxUgzedfj5aJhbKpWkz/n8ewwhvCL2OvxicedQATuRax5b
	 PlkMvldJqZ/9ahdv1ZXRzJf/N3so8gg1h3mNGNTwYGBFJMzoUOnShKW6m8t/lcsHp2Evf
	 nDbBUwBHSoRkEhYqZUCi7dgum8DwqI48y/RO78kgJr1KEL4Dzn8XaTLa7sMk7iJ7pDeHo
	 qfXCTAl8ujMR+0LYxLkqkJGhjbgyZpheidn2OnPihfhMo1bqhlxsTv+L0+eufrcpkf0Ug
	 JX8UpdnVjGkj56LITNm1iPRdRNJ/UQks8l3f4s4jpO6EgOwAxn/SpI3Xfxe1buf6GBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qf+Qq29s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3BB606A320;
	Wed, 18 Nov 2026 21:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qf+Qq29s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA5B1F000C4;
	Wed, 18 Nov 2026 21:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037620;
	bh=fcFFWdsvw/ViKqvNnfdCSZ+o2xHsmndy/ZEVHOo1lq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qf+Qq29s9fHIGml7sg+tiW9CC1uj6AGR42JzMDcQTgQGoyLtxLZzhJqNp6tgZV9GZ
	 lCkzQ+9Tfp3xCNTB1pcfmelbEl8M/a+vEpi7R2HUjtxbNGqJprCESiLesPr1Ht5hT2
	 Sbe8U8VqL3KtjagWUZs0OL903krozSHL+7wAChCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1460/3318] hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()
Date: Wed, 18 Nov 2026 15:34:42 +0100
Message-ID: <20261118150404.692930103@linuxfoundation.org>
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
index 2195a735d28e0..4ca2c76b12c36 100644
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



