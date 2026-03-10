Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC8938A71B;
	Tue, 10 Mar 2026 11:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142119; cv=none; b=RWugGC/g+Ngcfc1cmuNzMBlWfOlCOpvtIVAtVcIuCmScIpWU0F8P0iWlqfIFP2Upn2+wHtRlSYBvwyjxKRDI8OCdtJy8uonZSM4prwVinI1CH45LrkCDP8dN8ic1ieTEYEBGnmt7IJcaxBiMDNCUmFSfXgs04seGqo7y7yzdj/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142119; c=relaxed/simple;
	bh=G01M0Gxc/Gt9Viza0cYDj+dSAP8A//hmA+cxUN8hJMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEb1enW0tjszzrFnZ/l5J+wieCv1miGCdD9I90WqAFAUpyiThk2U07kifNKwLN61wMv1N7+psLk+I08MAmxUqMWA0pFaqMmbKCYyWxyVko7wCDTw0PXHSDxGQOmGIVKX8gdGAb40Oba8WFFcv5B8xwA9HBnIXrdF45/CGL2eSI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6npSw7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6npSw7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D333C19423;
	Tue, 10 Mar 2026 11:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142119;
	bh=G01M0Gxc/Gt9Viza0cYDj+dSAP8A//hmA+cxUN8hJMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6npSw7tfd0MENWI79mTMtfw5vwY3X2kLWJ9cJHCCmAh8wSwIjCu6PNH+zX793y3+
	 bxGKBAm+zO2XROnZk3/4a6Fp+bIvnYg3njZ6QEvc8epnZevERpC8LfAdCid+Z8HtU2
	 Z8HMRgLhwVxaYhNLEVANpGxqIYdar/ZcsJlWxNpJZrB7A2NFJnoATzVcvZ/JKOK4/i
	 qhu7kPZpBwct3wKlHWtwsPUilrFJ/kWBWG1cHTv9UX4FP6+BCn7KUU+cPeft58Ebv+
	 tzdT3wVkrFKy76OoDyCKfpChvZcUY0s70i0CXIJzzzLgPPFcIyLUBiarNgvNfco4me
	 HnOFc6JjRb2Yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hao Yu <haoyufine@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/314] hwmon: (aht10) Fix initialization commands for AHT20
Date: Tue, 10 Mar 2026 07:17:46 -0400
Message-ID: <794ac5d3ecbec529c0cb20fcacf51c8dab125cbf.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hao Yu <haoyufine@gmail.com>

[ Upstream commit b7497b5a99f54ab8dcda5b14a308385b2fb03d8d ]

According to the AHT20 datasheet (updated to V1.0 after the 2023.09
version), the initialization command for AHT20 is 0b10111110 (0xBE).
The previous sequence (0xE1) used in earlier versions is no longer
compatible with newer AHT20 sensors. Update the initialization
command to ensure the sensor is properly initialized.

While at it, use binary notation for DHT20_CMD_INIT to match the notation
used in the datasheet.

Fixes: d2abcb5cc885 ("hwmon: (aht10) Add support for compatible aht20")
Signed-off-by: Hao Yu <haoyufine@gmail.com>
Link: https://lore.kernel.org/r/20260222170332.1616-3-haoyufine@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aht10.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/aht10.c b/drivers/hwmon/aht10.c
index a153282eef6a2..7ba00bafb57d6 100644
--- a/drivers/hwmon/aht10.c
+++ b/drivers/hwmon/aht10.c
@@ -37,7 +37,9 @@
 #define AHT10_CMD_MEAS	0b10101100
 #define AHT10_CMD_RST	0b10111010
 
-#define DHT20_CMD_INIT	0x71
+#define AHT20_CMD_INIT	0b10111110
+
+#define DHT20_CMD_INIT	0b01110001
 
 /*
  * Flags in the answer byte/command
@@ -357,7 +359,7 @@ static int aht10_probe(struct i2c_client *client)
 		data->meas_size = AHT20_MEAS_SIZE;
 		data->crc8 = true;
 		crc8_populate_msb(crc8_table, AHT20_CRC8_POLY);
-		data->init_cmd = AHT10_CMD_INIT;
+		data->init_cmd = AHT20_CMD_INIT;
 		break;
 	case dht20:
 		data->meas_size = AHT20_MEAS_SIZE;
-- 
2.51.0

