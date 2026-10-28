Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210564;
	b=VAdr7Njm+UHH58kA8Ab3bZxXX/4q1j5UJOkrgzPtDXhIHn6SibZgoN50vqv8NP6PAPzL
	 Nicq8TFFO4ICnf3UTZOlkSxWxy+ozyV7y4Nymlk4FZCh17IaoRfr0sjw+PLyF4qEk++e+
	 6VUH6xKf2ChjyCGgXOsgJDk60PGY2Ts2Le+BDTM3jBIdI1nWNBGxo4uuDmS/jjYmZJLp6
	 CD6UMGe/TUlO2qsH8FnrL3S3d40hPoVwx/T4ywc34mJ26HNqO7uLqtZV2u0cw7oXYStjf
	 vy6YCCtfx6GOHNed/G0ZcNwyGc4cyl7+ICp3SIgCtqjhZgZ5R+/OB8OE4/4SxEr+V9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=J/EuWyxXRglKvOvJzG9QgYuWauvh7JdlpDQVsO8YC/s=;
	b=pza/en8y7I1EI/owAUUOGdWuql1FSW1z5Os1p26NEfNxDhkc9bs9/Tgqw8eL9sWM9ZYd
	 izSfBeJX5JwKcdHuL2Zsvpd93awfur0j0NJY07gD7eovRlXEQZu9jUnZI7VP9ObqsFouH
	 1sYeZlEmofebNoj+4b1lYau+6bKGSOkNWozwjWoPoh8bDUGr1c7z8Qjww0jke813cr8kG
	 mcbO3PalIwvSqc+ZJaqJLYNu8Qi8Ypm2sv1TgusApbynJA1/rmV7zMcz0Zaaifo49Xqjn
	 gLRWDs02C7AGABUFc/QCbLGARzCJxb6AQgRoPBnUJ3NbphQOA2LnZYiA9i6dLdy0GgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UG7gZ/WR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B942B606A31A;
	Wed, 28 Oct 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UG7gZ/WR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153531F01825;
	Wed, 28 Oct 2026 18:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210563;
	bh=J/EuWyxXRglKvOvJzG9QgYuWauvh7JdlpDQVsO8YC/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UG7gZ/WRFJhfkT82YS4yrV2Bbpnt+JzcOpggIH5Egh6C+mIBIVYh3FA9ZNZA+nRxX
	 UJ3qkXFQBhxzCBEl84TsePwLH+ZWfiK0HgYyiC2jGAmTWirN0X1kweOav1E/+ZEpgZ
	 isQEVS2vfM24AcPGzT3b/eRKsHelUfDGt8PfE/Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/571] power: supply: max17040: Convert to i2cs .probe_new()
Date: Wed, 28 Oct 2026 17:53:36 +0100
Message-ID: <20261028170009.662666906@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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



