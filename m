Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022522;
	b=26hcrJz0GAUu5F0/mu5z0YjXhCV/OPfzUNzNJFMFkuUO0EQM1DkmRz6F8CqAL/e3GZyi
	 DBoo/Zhfz5hbgJuCZ4M5wB5ucfFwc8x6DQGijabXcZNzrK/3LSpaxpi7E0pMqUI42VwZx
	 wIub7ptu0AqU76m8w6mdO9R/37GinKBaGbYwS1DJ8JhAQBqFjGgn3H8gGzWya0dwYP3+b
	 ecxIIMlDZoGQlA7NxxcXDF78UQdwW7RWxiC3TJ/NLIoJhGV87tW1ZP2/bkD9tKbiypiHf
	 AjiZknsAHC1rN27TMsMYsHOvbP07R6eJaEQgZOKEaLDYfUaJcxuvfMzhFa0hzYqjFwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Be9C3zqr/c2fq88yKvc6RLqWcsiLSliu8cSvndk1h8=;
	b=oEsH6qZji8qJdGdcut9ohW6CBy7Fs3EDtXn2Oo3wLfz20uqmBbTDehDR+gNmBAEsRWBs
	 yD4TIMZN9QRHP1ODX0/uAxwqHtbGJHmjx2RPE/YpE1j6TZVM/jRs5jXO3t1UD1UbLaDNc
	 TflpkYXP7QlglWAem8zCFbHzvHK7eS8bwnJEf7EhQz3a+uiEVRiZLs8u1rA7vi9Hnv9Iz
	 Zv+8y0+HNZ/nHsw4zUavRvvX5tqfTJJ+y43UOj3ZwtPW/kV9YVpP0InvB2PRV01qfoQEq
	 RC/gYV20PgUtDc+Rtd/Y/RsrBvleYXz5jgwoBAO2i9ocsntIDZV6/53my02nk1/91rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OAev9/cb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4199606A32F;
	Wed, 18 Nov 2026 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OAev9/cb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35EC1F000C5;
	Wed, 18 Nov 2026 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022522;
	bh=5Be9C3zqr/c2fq88yKvc6RLqWcsiLSliu8cSvndk1h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAev9/cbUoapFPlUotzRBchpJhHuR+5OA8ZCqqwjweGLSoW/xtBN3D07Lhvu8F/NH
	 JCT72JCZdTMZPctv0B5xTiJbiAuNHkZlLsHLimlbkcTKCJvoa9o9R8bp9gPwedvITG
	 Z/sqKmL+VmOPqpQ2iXEnc3Ndu4IZ5yS7VfpoHVMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0042/2151] hwmon: (chipcap2) Drop unnecessary include files
Date: Wed, 18 Nov 2026 15:29:37 +0100
Message-ID: <20261118150123.231831096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit 4c8d758d4ebff3780d09599f2c8db5d6af3ca2af ]

The driver does not perform any locking, does not execute or use any sleep
related functionality, and does not allocate memory. Drop the unnecessary
include files.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 8c02722be2ca ("hwmon: chipcap2: synchronize ready IRQ state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 6026514a763d1..6d564199729ce 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -82,7 +82,6 @@ struct cc2_data {
 	struct completion complete;
 	struct device *hwmon;
 	struct i2c_client *client;
-	struct mutex dev_access_lock; /* device access lock */
 	struct regulator *regulator;
 	const char *name;
 	int irq_ready;
@@ -575,8 +574,6 @@ static int cc2_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 {
 	struct cc2_data *data = dev_get_drvdata(dev);
 
-	guard(mutex)(&data->dev_access_lock);
-
 	switch (type) {
 	case hwmon_temp:
 		return cc2_measurement(data, type, val);
@@ -617,8 +614,6 @@ static int cc2_write(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 	if (val < 0 || val > CC2_RH_MAX)
 		return -EINVAL;
 
-	guard(mutex)(&data->dev_access_lock);
-
 	switch (attr) {
 	case hwmon_humidity_min:
 		cmd = CC2_W_ALARM_L_ON;
@@ -712,8 +707,6 @@ static int cc2_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, data);
 
-	mutex_init(&data->dev_access_lock);
-
 	data->client = client;
 
 	data->regulator = devm_regulator_get_exclusive(dev, "vdd");
-- 
2.53.0



