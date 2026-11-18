Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053301;
	b=xen3PEBsaKcTd/Te5MJcZ+WoWBBD+pYc3/aFM8f8OHi0OUPegYor+4LIUlqnmQ6+VX8N
	 /mgGyurU7E47QJyrnAGpH6Nh+Y4n+YP1MaMbWl5tkOsg0fhdJDIdfJ9D6QM/4Rd7G2eBx
	 K3egMUys6Ukvelu1Nmw7cu6ahirYtAm2D1TaExkdI+KBb1RMMyq/qenWYqEd9eAbjBVg0
	 i5zI6Wgp0NhWnOvonZySEOPZyjc/JbVx2fKw4OPSSTDBqve/rXMHcu2+S92aNZFluSLSl
	 R/qnk1IoDTJikhj/9zqhA3JD8+crSdbstY2NthOn1qm2GxQr4oK0zQUyVMqWK7cKD9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6n7SiccUu0m2+vnp5Qo3HQma2aODrhkgJ6zq27e09fg=;
	b=EQ2L5S65xvm+RMbjy0/DVMfonvI/oGPFjUdHbt2ph6noaW6QNnQVG14/8N9cmIAH/FAW
	 TB+ipELYICatkoZ5/L1chXywuBwM0/K2Jno1AQpJOmdt2zqFuDp01a39H60w4uuU3WTvx
	 y+1VMCFwmt5Mxcyd1pdIeFozzYt1jHirj070fxfT14fcf+LWwd5I8lpdbBjjM+UKdK59g
	 Hnifb2VxyopcAd/Umk82xTn7MltGbhodj8g2YrQnukLnAoHetKnK/OUc4wt7PwmGekDz0
	 VXtMFhOygQv4L4lai7/b4VGCslZqzgp2i17piu+uFm5fhV7vSu8RWpnmyezkAZGNSQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Doa4jjNn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15E060A260C;
	Thu, 19 Nov 2026 01:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Doa4jjNn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B181F000C7;
	Thu, 19 Nov 2026 01:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053301;
	bh=6n7SiccUu0m2+vnp5Qo3HQma2aODrhkgJ6zq27e09fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Doa4jjNn90ve1KiH0XrqhH3BbOC8ui28BbUbapmW0bwMghVkB2y9DYIWo5UoRyYBX
	 bJFLzkXn31IMWH4vgay+ivxLKTyTG0SHERoDFk9OligyXaFI8GnlCO9GDVU75poJ21
	 kzAtzw+Ryd6kn5SWZ5djKtquM3bQwVTT2PEtg4hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0870/2214] hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()
Date: Wed, 18 Nov 2026 15:42:26 +0100
Message-ID: <20261118150046.938331386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



