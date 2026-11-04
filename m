Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826770;
	b=EnWdf60mKbqnyOJ8zgfORY24i6rREdrC8RNzY3NzSsiye3csPapRNlcNznrYtKRKBjaY
	 sZJ8pe8RMphlbVjhNkLnekqNHhmg0vbT9DoVz8/2SIRlIZbrq0U36DaMM/q8fkLBpfS9T
	 RAKpBL2DT8a+0kSUYgnoFYHE6dSLiKqDZcRLCm5p1JoiwcXNw1HYEbRIv4wOYcGnIEjcZ
	 cA7vpMBUkhFVdN41LIO0sx/RuDCdPA7afPTHsSds1pb9Sj/Dd08Oik1hhPpfr0zjLW0kl
	 p4HrmcSlJe6D7XKmmKKTS0YpGL49zksxOqNXZMlVsjBSQ5PbUBuMBtEbO+2IEXHu26w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Jsgov8faG3YwSLxiHg4DXyg9LDtPy8S8vfu/xWne4I=;
	b=IkMlKiEzDRYw6W82r0+yWni0X0smRNInwyNHm4eELmDfYLIrhJbob2rFfD/WMB3zJ7rH
	 a7WQa/f2rBQm/iFHY9Ike5l0ghJ4Fvyg6dztoWBakpabYOF6E95ieDgC8PABaM13iKHq4
	 7YRxpUQceaCFq3p6NDzK7IfLgqtrEAkmNcE4aADoSR20evb0BQ7Zw7Z4m9J2ozGxuWyxM
	 TX6NakL7ixGq4eLojjUFniguDTYa1BLwld0V93XYrRqHjmFFr90JuB9BOtGQHEjXIJ3xA
	 ivQRql1+6isuE5yD621iZKBZUSRJUMagOBy6+rkOysu5UNo4fv8tjw04rAXrmtLylzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O4n/9DGp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442F260A5BD7;
	Wed,  4 Nov 2026 21:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O4n/9DGp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955781F00919;
	Wed,  4 Nov 2026 21:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826769;
	bh=7Jsgov8faG3YwSLxiHg4DXyg9LDtPy8S8vfu/xWne4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4n/9DGpvShEP/y1AQm5J9tcLkwqw1qgC0umDT/d3dcTQ3J7A1wt1nKzYUxPOVEl3
	 zxj/vOtSlCDhi+zOS00nHJRHpJKGlIHfQRL1yecKm86QlmtbDvQ4i8R+zxF10Q25UO
	 XXFcjlJWRjpsO+4AopS7N2PjL8GKez/PsFHgUkN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0007/1005] hwmon: (lm90) Rely on subsystem locking
Date: Wed,  4 Nov 2026 15:55:40 -0500
Message-ID: <20261104211043.738227112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

[ Upstream commit e9b64fae44be190ea21c1092e96f316f90deb663 ]

Attribute access is now serialized in the hardware monitoring core,
so locking n the driver code is no longer necessary. Drop it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index e1795ccde876c..0153160552e02 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -108,7 +108,6 @@
 #include <linux/hwmon.h>
 #include <linux/kstrtox.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
@@ -735,7 +734,6 @@ struct lm90_data {
 	struct hwmon_channel_info temp_info;
 	const struct hwmon_channel_info *info[3];
 	struct hwmon_chip_info chip;
-	struct mutex update_lock;
 	struct delayed_work alert_work;
 	struct work_struct report_work;
 	bool shutdown;		/* true if shutting down */
@@ -1230,9 +1228,9 @@ static int lm90_update_alarms(struct lm90_data *data, bool force)
 {
 	int err;
 
-	mutex_lock(&data->update_lock);
+	hwmon_lock(data->hwmon_dev);
 	err = lm90_update_alarms_locked(data, force);
-	mutex_unlock(&data->update_lock);
+	hwmon_unlock(data->hwmon_dev);
 
 	return err;
 }
@@ -1523,9 +1521,7 @@ static int lm90_temp_read(struct device *dev, u32 attr, int channel, long *val)
 	int err;
 	u16 bit;
 
-	mutex_lock(&data->update_lock);
 	err = lm90_update_device(dev);
-	mutex_unlock(&data->update_lock);
 	if (err)
 		return err;
 
@@ -1594,11 +1590,9 @@ static int lm90_temp_write(struct device *dev, u32 attr, int channel, long val)
 	struct lm90_data *data = dev_get_drvdata(dev);
 	int err;
 
-	mutex_lock(&data->update_lock);
-
 	err = lm90_update_device(dev);
 	if (err)
-		goto error;
+		return err;
 
 	switch (attr) {
 	case hwmon_temp_min:
@@ -1628,9 +1622,6 @@ static int lm90_temp_write(struct device *dev, u32 attr, int channel, long val)
 		err = -EOPNOTSUPP;
 		break;
 	}
-error:
-	mutex_unlock(&data->update_lock);
-
 	return err;
 }
 
@@ -1666,9 +1657,7 @@ static int lm90_chip_read(struct device *dev, u32 attr, int channel, long *val)
 	struct lm90_data *data = dev_get_drvdata(dev);
 	int err;
 
-	mutex_lock(&data->update_lock);
 	err = lm90_update_device(dev);
-	mutex_unlock(&data->update_lock);
 	if (err)
 		return err;
 
@@ -1714,11 +1703,9 @@ static int lm90_chip_write(struct device *dev, u32 attr, int channel, long val)
 	struct i2c_client *client = data->client;
 	int err;
 
-	mutex_lock(&data->update_lock);
-
 	err = lm90_update_device(dev);
 	if (err)
-		goto error;
+		return err;
 
 	switch (attr) {
 	case hwmon_chip_update_interval:
@@ -1732,9 +1719,6 @@ static int lm90_chip_write(struct device *dev, u32 attr, int channel, long val)
 		err = -EOPNOTSUPP;
 		break;
 	}
-error:
-	mutex_unlock(&data->update_lock);
-
 	return err;
 }
 
@@ -2805,7 +2789,6 @@ static int lm90_probe(struct i2c_client *client)
 
 	data->client = client;
 	i2c_set_clientdata(client, data);
-	mutex_init(&data->update_lock);
 	INIT_DELAYED_WORK(&data->alert_work, lm90_alert_work);
 	INIT_WORK(&data->report_work, lm90_report_alarms);
 
-- 
2.53.0



