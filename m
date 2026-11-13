Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585584;
	b=jXT5JNEd5fSZ+qsSSbje2GQTcJolkgOVvIztKr85SxDc9RYJFEoEmR0UckQdEjK8PcO4
	 rTJEzTG/sKrGXCohmweGY5qUZjAidmEdLiaL8ID8IUgILfPxEyz5s4KJXnlS2jOP2oZk4
	 3G+F9BbqNyMeKHCY4UzFOnk18RMAD9k8YCcwx46/bewttF9idZhaGkxC5PIKxLr/xyCwG
	 0BITqYRHwOTxQi1Hu2kUUsuP03OKdEhc5R6kmBo3xwPyf8f8kLDHjDl/BpUMqsk2aBlW2
	 1WgPYSihQApYp1OLG4wWeEpUI7VvwasSUpav7nE64vlcM3nVgnJi/k8+FNU7A2eQBvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ozaigTLApHiN3ww7PcaaCzdL3NwXhoBh2qCHU7zmPQI=;
	b=zlRuYLuc9pe8XD+mcsq1uEV0BT3Mmz1hfDbFP5VNiqFXUm61ROWjgSCwV0D+TIfinNtx
	 y+zYqXfNuZUMjs3hBum3LO2lRO/FGGaNRLEvNsOlfLFb3PqLp1VZ/E3g0jVGhnJm293ds
	 FozYO3KNYOdQtI3cRbL+0sX4lD1Gf9cK2AjGI/vJCB6okN2y72d+BJD1xcq9AJFGrgpuB
	 Z3+z35/PEhiU2UrAAlHAyZRI5ZstveD1OfHrnH3YDxB5D1WRuWZUEpP4LJZFZFj4oxPDe
	 k0MxtByvL9ekkq5QV2DGb2i+UQcRyqaBVdSKSGTN7ypkCoc97jupE8et5w2Yp3zv9jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Y3qJOFb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370CC606EA91;
	Fri, 13 Nov 2026 15:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Y3qJOFb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D772E1F000C9;
	Fri, 13 Nov 2026 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585584;
	bh=ozaigTLApHiN3ww7PcaaCzdL3NwXhoBh2qCHU7zmPQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Y3qJOFbPlzGJvR2Z2afi3bsO+PWJrsT2Bcpt1DWNzc91ibfrdntvAN33eQlEJz9f
	 Ll3rizLMVKl//eBQ6MTEbVDpCNIBS0NE5hTcMZ3leWxwhw8mHOeXV2u65gq11KCOY3
	 cxNjozCL2GEihFI7tIHHG4V0nZ2mc8PY9qnvivWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 188/507] hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()
Date: Fri, 13 Nov 2026 10:48:12 -0500
Message-ID: <20261113153800.890807125@linuxfoundation.org>
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
index c09074f447083..bb4e15b663557 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -606,13 +606,16 @@ static DEVICE_ATTR_RO(cpu0_vid);
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



