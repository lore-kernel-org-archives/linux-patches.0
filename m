Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046323;
	b=YQdCDAexA/kybCQLRH/ExbpBoR9r52Kxtk5IztT/L1n35WRnOeWbCFvVXRW53c40UwuX
	 XFMdosnHHZESvMAI4Si7spr0E+rDQlzXFCymHp7LwIR+e/g5cXNsZZrtZ0LRM+EapLILc
	 3+PrhsOXhBicHvDbq/KSHcPld1OmUoCARvOVOR0OPyY7tLz+NHLwCUpxqDUvGzN8U1Prf
	 /DXUv2GNXTrF+4dEYyHU6JWmJHoP094F/mSQGpFE0A1qbn0gCPN2d31WIvVL4Shd5Zrat
	 aiJf0UzcDywVlpRbmTQJgoHfTQJFu4ggsZv/VejjYhRLhjBhTyZWoLsUOBfgx1EGQmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uWQSamSvCmT4/6gHU9lBxhZ4WYXaY1Sntsny3JdG6jk=;
	b=dct2TpDh7AB3+8y5q+jygZJ7Hzbd/j76XSggoY1yQ8T7VmiNpGKbhxGT8i1Z8LeF+lJ1
	 CIUNgMf8ZdkNXJeFi0XaoAVaN0gOwhgn3sXvhjCwC1eCcO+nD9QU98NEBJMRoqN6wHwGg
	 Gnolw1ydfTenwQdx+O1zJOGBynAD24WrkS1FjlwOc9gmm61yHvAwTPDD5sNpwcbiadPRm
	 8BNsGj/DNqxzwLsxa6nFUgA72qWkij+6HppPUOfNZeSCn+Ko2UWF3Ij3CiY59XNPqBKhS
	 OzhombzsWllaUhHDALeVnrSC6kNvnmzJbwEVoBZwxZli6aamOCfRVs42UXjbWMLo0cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aWrxcUXG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC9606A325;
	Wed, 18 Nov 2026 23:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aWrxcUXG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D501F000C4;
	Wed, 18 Nov 2026 23:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046322;
	bh=uWQSamSvCmT4/6gHU9lBxhZ4WYXaY1Sntsny3JdG6jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWrxcUXG6ND1nTTpwon5fdz1Maf4V52cCfK8pHYUqvfpTCtyff/IOZ3aocs5l8JR8
	 EZ4cwnZG1sdXG9l9O5l9iYlEsoGQdwOLiGuWnwyGmUz+moixbzELqCFZ+WTbGIFBXc
	 R9vbASMjHNDIiW3TueaWZOiVglwQKZoefN7Y4tpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1239/2857] hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()
Date: Wed, 18 Nov 2026 15:37:53 +0100
Message-ID: <20261118150246.162111815@linuxfoundation.org>
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
index 818fb61952457..261dcd2cae413 100644
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



