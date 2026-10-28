Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212246;
	b=yXHPUiKyHOpO1ieVu6W+O1MIhoJwUzNgpBWoQGBc+w+KD9lZChULZd+YYAKMgqwbX4TM
	 f5tq2fp0YLARLEUl95t9rCVzTO4Zjn3YxuOjDKRUq34ssQR2fYnD577zGxa+ZJVUq4EKc
	 M3sCObKHOc3FeFjreOPUQxudd62RfgoL5kGBeYMkH6ntyciEujJaiqX/c5nKuhblUjYMY
	 V/BKdDQN/1ma++3raz3jCkqxukk8b2RTngzHPnDWgr+DknOiKzKXxAUSmtWHxrRIpkyqW
	 cxjZHoEcxAOd8QOBjDMMRgvNmXvLEh6BBNgv3IxqEd5t6rePhkcmIMNtjsqOmZW1qew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wy8jMtihy0OVPKsZBBV9naXivQ1vhHgGh0y9bUSnUC4=;
	b=jvimxfnBJ5KClMfCfyTTcdMuqPDtSAKEJ5r1S9k4qj2OoWIUFf6ca9orWgwvPLNFLq8S
	 oJ/MdXgnrL2fEyymGooszLiQ7Vxo73xXweHsQTdWp+6tv0XefVoOxphZLNSznMVCDQnt3
	 QXYnHkr7Nz6e/T3+HVsPbvFLLIpQwB6OBo7PPW93orVdHkox6teCKVhbzDAa1w9Hs1lpz
	 kp2UF/eIthdA/3yMzFSTqzfdjSFe+vOTEgE3VPKU+1qQyR8SC9EJ7uTufWrz2vOQD9TXl
	 iCkl3tx48EjMSh/72Q/+FFdOnowmfHzPJvLvedcV50VzPl7PZQmWLF/lfywakXbLDSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="quuMQt/J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F18F606A324;
	Wed, 28 Oct 2026 18:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quuMQt/J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A501F01828;
	Wed, 28 Oct 2026 18:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212246;
	bh=Wy8jMtihy0OVPKsZBBV9naXivQ1vhHgGh0y9bUSnUC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quuMQt/JjgOPfEBaDynAZp3FwAS6jhGxPqAqGHyL7GpD5pS4tB6UmHEj55cx+pUGA
	 HWm8uZJJVhUmo0QFLlxx9X2jjYR/dD1TyjLoSPAMlW56H1BU+odH+6OY06S/Y4/K6g
	 nrVU9cvPyHguMNcrdXqDAHFaRMww24rDXknHA++g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0089/1887] power: supply: max17040: drop incorrect I2C functionality check
Date: Wed, 28 Oct 2026 17:36:25 +0100
Message-ID: <20261028170501.260275535@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



