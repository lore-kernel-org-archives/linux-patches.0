Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212243;
	b=YS225dSLV0g7Gn1zQcLNW1XIpBIXKqD2o0smLsip/pMP4sf/X2dS7J7ejjP1tfXaG2Z7
	 DC/KPXyNRYSwqerSpyPzGeFTDrLoLn4J10ZLNSKi7/nRVTRInS/xvbQd+MLItggWmjqPg
	 pwZoe7C90Hok8FJcKYmkf+x+IrfEP4gJdgmYiyzvB/7qizlMDMIpQKx+08aRVdZQ7EWYI
	 LxCevQGyPqOmnHqgMyXqpusoT1TDID5coLxESwVPvONh6rcBNMMpozJFSLD/yhdoU96Vc
	 9Xj7W2t4Jqxc69CIpjK7f962y6B1Ew9N60wuKzDTks1NQ0zY0Q8tpC4Buv/gtipDJxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DCbyEFRnC9RdEf1cAboAhgH+kDaIYwV9yvwtdTDR6nQ=;
	b=bdq+yBNoI4t7GxeUKmHJfeDI35RO/XucF7ulWqzCHglDVJ0aQL0wxG+/YvrLSS0RUOHO
	 nBLLHZQzyrOVh72E6KilYKPlm3IX31jvWot44EK2bYFz4KbFHvnY3iLnsb2xWNf0cTu93
	 XrNVjX+pg5d1wzB11mDb6WiljIeSLEumxgjycD0eOzKf6H6nX5TUziS5jwnmEMK3+Pqcl
	 xlLZd3p6mhswZOC10BlDBdy8xljBlUfHnyx+jRuyy7UokBkLhyxo8HSYqDq0uhxBcuMSX
	 RvJo4hleGToCPsE2MBmrlFKRUswwmcQu/mrAG//qnHOGMZEEdJXjhFhv+ExI+DxvlTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cx+v/ndM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551C7606A31A;
	Wed, 28 Oct 2026 18:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cx+v/ndM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36E41F01825;
	Wed, 28 Oct 2026 18:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212243;
	bh=DCbyEFRnC9RdEf1cAboAhgH+kDaIYwV9yvwtdTDR6nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cx+v/ndME4XvsRDiytycTCsCogly/qGhd6X+FlCyxEt2neZEqFhfeN/NaFtN0Fkyn
	 NGitZyYPqAmN1WZBWH7tjH0vIzeJDEoeiy6PNgbBikz8CmrcQMLR9EYgTUa4tlDf2Y
	 qgrqkUpQoyw5qBN63stJnY0/6h+AHAWzXDDUw97o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0088/1887] power: supply: max17040: Convert to i2cs .probe_new()
Date: Wed, 28 Oct 2026 17:36:24 +0100
Message-ID: <20261028170501.238447151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit a07fca69378c26ea034826feb0011256e25ad237 ]

.probe_new() doesn't get the i2c_device_id * parameter, so determine
that explicitly in the probe function.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 4e4b9f5ce9df ("power: supply: max17040: drop incorrect I2C functionality check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17040_battery.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/max17040_battery.c b/drivers/power/supply/max17040_battery.c
index 04b61692da300..8e913f92af9cd 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -430,9 +430,9 @@ static const struct power_supply_desc max17040_battery_desc = {
 	.num_properties		= ARRAY_SIZE(max17040_battery_props),
 };
 
-static int max17040_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int max17040_probe(struct i2c_client *client)
 {
+	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	struct i2c_adapter *adapter = client->adapter;
 	struct power_supply_config psy_cfg = {};
 	struct max17040_chip *chip;
@@ -599,7 +599,7 @@ static struct i2c_driver max17040_i2c_driver = {
 		.of_match_table = max17040_of_match,
 		.pm	= MAX17040_PM_OPS,
 	},
-	.probe		= max17040_probe,
+	.probe_new	= max17040_probe,
 	.id_table	= max17040_id,
 };
 module_i2c_driver(max17040_i2c_driver);
-- 
2.53.0



