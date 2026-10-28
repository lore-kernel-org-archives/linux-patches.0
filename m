Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210566;
	b=BkDrbN3pyhZXGkhE6UfiI44lWxFHvKZQDPqMDUuTCgK6W+HLxrz5Rol2E4lfSDu1ovhU
	 5hgggYSPeWKrfh0K7beLPJkAF8SM6FMHU4KY1BRz2iILSsFqEg5bzf6K4RC6GiwORMSit
	 Bfh77o4Xf4h7eKt6lVnS1K/sth6gnzNIf/oBxNpLqie6qwcWwdU2oKInbP2+MUqGC1jrU
	 +xElOhGeqblqnIyDw0Q8ptTkxegT90T8ocIJhAzm3wpAcc3pBt8lKYVqPvkXrx/uvEd+U
	 fjQm6ZaYPgszf17Nzl5zKUDewZ1GTWNdWymKJcULzICpepR/0bA5/EMZemgZ3SM91IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RRlqaoMlWjGWWDa/S46P6Qcpv53wHLe2kwYcbpJsxmE=;
	b=xvbN9CN/XTQK2ifWT7ykh5/Kys2Gjldj3yOK+yY5rtLet06ZK6sAYwkeviMapZDIldpc
	 Zd4T0rdsIk4hFcOuvdFlFFDFDRIa2t0T2dSX1QH8FEMDvuefuI70ySQo+10vnAAeejkjX
	 jRwXVzVYsk3ND/hJ9QKCjSGYRj+7haRwudNFJxM5HZtIE4NxhqydH1ul1QMiJy731AlO0
	 sspcSIqxwkm5BENjQDGQUD692CRGKPdXCudHO9f0vn+MmZP0W+KSpSy8O0RwCUJXwLz5E
	 zweDWVnOuYMGIL1ObkJ93sxQ2JkW2l+BxmY+dYN+xhjm8b1Sep6q5XqFnd48NZkxABQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1zWxzJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F225606A31C;
	Wed, 28 Oct 2026 18:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1zWxzJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3E01F01825;
	Wed, 28 Oct 2026 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210566;
	bh=RRlqaoMlWjGWWDa/S46P6Qcpv53wHLe2kwYcbpJsxmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1zWxzJZAcer77UkIoXhXKhnbfWrizFK88KA/rbXpiACcklTHaIQE6FzZJXOhuGF2
	 Vlh6Z7JnA3FFNkH5L/hyZZtfw63B9MML/LdXl2CvC0dNDNp3JkrrlAG2iEq/sIki4d
	 kyA5KyBIlblDlQ9RAacyB5kZQ0d6MhiwPO7r1r+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/571] power: supply: max17040: drop incorrect I2C functionality check
Date: Wed, 28 Oct 2026 17:53:37 +0100
Message-ID: <20261028170009.685926045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Jianing Li <m13940358460@163.com>

[ Upstream commit 4e4b9f5ce9dfb8ed4b8d1262a504b8043ac09d87 ]

max17040_probe() rejects adapters that do not advertise
I2C_FUNC_SMBUS_BYTE. The driver does not issue SMBus byte transactions,
however. Its regmap has 8-bit registers and 16-bit big-endian values, for
which regmap-i2c supports either raw I2C transfers or SMBus word-data
transactions.

Consequently, an adapter providing raw I2C transfers or SMBus word data
but not SMBus byte transactions is rejected even though regmap can access
the device. Conversely, the current check can pass an adapter that regmap
cannot use.

Drop the stale check and let devm_regmap_init_i2c() validate and select
the supported transfer method.

Fixes: 6455a8a84bdfd ("power: supply: max17040: Use regmap i2c")
Cc: stable@vger.kernel.org
Signed-off-by: Jianing Li <m13940358460@163.com>
Link: https://patch.msgid.link/20260731084259.916-1-m13940358460@163.com
[Fixed Fixes tag, so that it points to the regmap introduction instead of the initial driver addition]
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17040_battery.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/power/supply/max17040_battery.c b/drivers/power/supply/max17040_battery.c
index 8e913f92af9cd..2017acf67a32c 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -433,16 +433,12 @@ static const struct power_supply_desc max17040_battery_desc = {
 static int max17040_probe(struct i2c_client *client)
 {
 	const struct i2c_device_id *id = i2c_client_get_device_id(client);
-	struct i2c_adapter *adapter = client->adapter;
 	struct power_supply_config psy_cfg = {};
 	struct max17040_chip *chip;
 	enum chip_id chip_id;
 	bool enable_irq = false;
 	int ret;
 
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
-		return -EIO;
-
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
-- 
2.53.0



