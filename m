Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059046;
	b=K4dLV31vNX7VfTS6cWti+K+kigV5Dt8oIDoIyPhCOUSAH+uDBNcHiqvQSkxx4edt4Mt9
	 e1TriPMDRlVKUfXKRjFIXeT/4c1U278HZCyFtAZr6C6Qqw7Ll9Nxp6IO1twEyi+0qBVgi
	 pP1Y/Nt8EkpllbuyBSSjD5BvAalO4FPXcIN55Ho/sSHtuQlKuBv76s+Prh+ofbF6uKHSG
	 LYQ7sjl5oCvRoWMiZ7aq6mXrmwk8/Z1OjHGfdrmg2m5lgLbFgCC+VMCcUN0UVvBPgZYuQ
	 VmtOxBk21mrFGP7eEwc/NafUcW+FGXpQ9GHc0XRhNvvuSqEXdhDi+r9pHlGgLTSqV7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0oDYdi27EThRVcVvJm0hW5cG8c+KF9WCuKfqe3IYQQQ=;
	b=0lsnaZu4Z1FJYeusdhA2yDNCRzjm3evh13IHmXLFrpm8stmM4VOSZ9Px+sdFdOB1z0ZK
	 ypkoKS6w/mv/bwE2R0ZH9HdSM0kG/xxnKdhFh3KKPQjlOHACD2lqXSLyNoprLB+TiSk9o
	 AyDZ6wSp3W1ohkQbmWhGyqg6VuHWSKLhlFvNkgRPpU9NHPiVZQyZRzsEz+KNy5ZqST7EU
	 GxLchl6uYikB+ciemwBpbW2xJZdHTsQ+DojpcSIwlyTZiQ/hRA1mfufgLkp71bTp5xtAp
	 +URun+/fxKOT6vB8qNvJJnveQpCmYxCr9ILrFSzn9Gkef96zCooPdgIXntCXMutQA4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMYh822U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24EC606A31C;
	Thu, 19 Nov 2026 03:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMYh822U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075F31F000C4;
	Thu, 19 Nov 2026 03:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059046;
	bh=0oDYdi27EThRVcVvJm0hW5cG8c+KF9WCuKfqe3IYQQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMYh822UpMrBQZitUYhCh+SdkcWkHNV7EXYusQ9PHIBgt5rLtKcKFRKBBnl4XPSG/
	 BXg4+XUAeBjOjU+5ofJ1VI0d5Sxq64GtaYXpEtbJJjcgQb5exQRU4kNsIQoiDM75Hi
	 3yTfrmXZ0MFngGRnq2htYHaAa4+YXx1rta0b9U/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0701/1848] hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()
Date: Wed, 18 Nov 2026 15:45:39 +0100
Message-ID: <20261118145945.207546775@linuxfoundation.org>
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
index b2d820125bb67..4c88e866fdd6f 100644
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



