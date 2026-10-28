Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208280;
	b=kRVxXUP2RlRQ/IgHtBu6qWkcDduq739zbPBtznCBEQYD7gwGIYT/wVV02bcOetXlrwuN
	 y2WYouaIOJE++CNylVQiRPGFa1SPy9YN5ZlVma0Vn1KnpmaSesKWxgzK9jjPrKSi2cmbq
	 WPqggb3vnj6orbKMQ3y/lvLtGkUuowOiZnAR97BUA9mORENruZiGmsbb6LnsJ9dkhKSyC
	 SXddXb6ivg0al5YXXnwkh8fym9VmVh+moiOhMW31k5+qEqM5RZaCJGn0SxMnBmfFBH9ro
	 ndV/n/pz5MfdjeK5Z1ArrZT1GBNY0/oddUH2tqhsAczxzPpxHlH+pWC058OJ7Gna3Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/Z8N75H3ETE+S0p3aSS6Qx5fM/crXtQKkWmYlduZ2Bo=;
	b=pUyDkVDYBrOFyhIPgS7E76lQJiST5WOxhym80VHOiTQKwZ+s4YBaMqFcJMXlyMr00fjl
	 btObjdqPkKwr+NLVPaL8M+xKp5mxJZkdj5XOHlK1dLiT4q/Dg+002HY+S9uN+jB7m61/1
	 NNxWhKAoX/nXwGJcsWP9SIGFHRFbk0Hqfo9IjgAYillyC0BbpG4WpoVIKm429A0cHe+YK
	 E+WLJzcQZQZlJC5oyI2SbyipqOxO3zZ6VolSPsctYufGwWWV+t5IrImHuLaT8ZV1WxBxW
	 qtN/PxFKA7qDwr4m/4x4H68+4shxV3npelOTaj66lth4xcuvZeqy2LoSUfFlnFMZUnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNsveCBZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A856606A31F;
	Wed, 28 Oct 2026 17:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNsveCBZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796991F01829;
	Wed, 28 Oct 2026 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208280;
	bh=/Z8N75H3ETE+S0p3aSS6Qx5fM/crXtQKkWmYlduZ2Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNsveCBZ1k7r94ioH0VHFzhFZWnJvmDqNweLe3Lf9bF/xYBrT30hbypYt5Q/QQb9Y
	 2orl3yv21hys5LDb2zIlj5T1qYmr91I/40gishfPVorICmkkjgoT85W26/ukU7MlcU
	 tZSlQ0xAazz3ZH9dYn3IoLqObb0RLG8lMVnEf1Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/516] power: supply: max17040: Convert to i2cs .probe_new()
Date: Wed, 28 Oct 2026 17:53:37 +0100
Message-ID: <20261028170005.065951979@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 696948a8a1c94..6816f9d5d06f5 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -462,9 +462,9 @@ static const struct power_supply_desc max17040_battery_desc = {
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
@@ -633,7 +633,7 @@ static struct i2c_driver max17040_i2c_driver = {
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



