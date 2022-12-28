Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8F11C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A944C433F0;
	Wed, 28 Dec 2022 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245025;
	bh=jjhONXaIXLsVcRimHZefHlrUC2+ypBELfRTD6roQdqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8VvBNZALaEEZiKo4Ac9LopBBWnj3tu0z8ZntGOwnqd8FiOrwxfD0sk4Q8jHJavBh
	 aXVAFlNw69MuIpdcaFoUbycshQqPT0V2vfHWFHf2r/8BYhPOPTHgjTCGucayxueEUP
	 rli1FduO+fttWs1EoW35XZOmxjYcokafyZFMwf/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0780/1146] power: supply: bq25890: Convert to i2cs .probe_new()
Date: Wed, 28 Dec 2022 15:38:39 +0100
Message-Id: <20221228144351.334104748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c5cddca2351b291c8787b45cd046b1dfeb86979f ]

The probe function doesn't make use of the i2c_device_id * parameter so it
can be trivially converted.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: a7aaa80098d5 ("power: supply: bq25890: Ensure pump_express_work is cancelled on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25890_charger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index 624e466e2cfa..f212fc7cbb6d 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1219,8 +1219,7 @@ static int bq25890_fw_probe(struct bq25890_device *bq)
 	return 0;
 }
 
-static int bq25890_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+static int bq25890_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct bq25890_device *bq;
@@ -1419,7 +1418,7 @@ static struct i2c_driver bq25890_driver = {
 		.acpi_match_table = ACPI_PTR(bq25890_acpi_match),
 		.pm = &bq25890_pm,
 	},
-	.probe = bq25890_probe,
+	.probe_new = bq25890_probe,
 	.remove = bq25890_remove,
 	.shutdown = bq25890_shutdown,
 	.id_table = bq25890_i2c_ids,
-- 
2.35.1



