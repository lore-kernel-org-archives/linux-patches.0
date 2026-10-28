Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208283;
	b=adzNEgvI/FiT42uvCPTED8otXLD4YJhCMCko4F2Qwdkbp2x20mXA015bREkvZKAlURR6
	 zpujy3iaqLrEwJagICBaDXU6oWW9cozOZaEHgUz+ClToOOiNqQThaHrAmMZOqfnrmuq7z
	 Hn6XyKfliZiqkRSuyTcFWYOqe64jxXwPYFPNwrIYhb7fMHSx+W3btxLqVaHk+UAn3JZbq
	 WzmS/maUgJBsnwBObiV7blYshyPMckjAOAzDQv/MiBd+KI0KKvJTO064T+DQmbkCz/wAp
	 UHKrvAwTwzH33KF0SqqejBDWo+/4Yd7eqm0UmkzodR4pz8QfcQvf5P3G2o5hWmZhBsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VkTmtTlf2O+FNPHVkWW1cTp2JhA7rbRd5hedqtZl2GA=;
	b=nJZjWUBMqv5L4F/saDHUxvR0EAd3Z7IRyEzH8S9ZPluuYOy0sd9IxUMhRndc1InyD98v
	 U1nCY60u4nN3l70UXyf7enzujH7cBi4jssjPkEwbSZ0qsdnoNdg2aVPIq8B8g2BA8Crsy
	 xpncgOfyh61c4/h5CsK54mBrmbslfsor11PE9Du12n38jO8D8BkkdSJ9w5qL55pTmBPGr
	 fBJWAn8d9i7GO7hhu8O8/G0fdAE7QDCc2jUzmt1dTqJPKdwCnYbwPTbYm8zUpUFuv6fEq
	 6O3J+c5WKktDVuUlM/1KEJ2xzuG2M5tWa1z1kInixjoXKLqTQAL/G0gbooUq8IvrO1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bQBYGeYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F7E606A329;
	Wed, 28 Oct 2026 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bQBYGeYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914A91F01829;
	Wed, 28 Oct 2026 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208283;
	bh=VkTmtTlf2O+FNPHVkWW1cTp2JhA7rbRd5hedqtZl2GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQBYGeYQVZQgHMaSjkC9okRGyyxd9WbTThLuryXD4r2SxypqTNOvnzJm4M8pCVFt4
	 WkCwvnqTwmXJTi0xwa11u8t+RjoHHsWgzcm6uo2nSP9r32ByL/Q7+qVVcgjQ8WU/qn
	 BodpZoOF/HUvAm78SQ5CO0OZBpBFsyAbqRoGE/C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/516] power: supply: max17040: drop incorrect I2C functionality check
Date: Wed, 28 Oct 2026 17:53:38 +0100
Message-ID: <20261028170005.089522185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
index 6816f9d5d06f5..f79eab7d7bc00 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -465,16 +465,12 @@ static const struct power_supply_desc max17040_battery_desc = {
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



