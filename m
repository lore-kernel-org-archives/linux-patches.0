Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DED5349B03;
	Thu, 12 Mar 2026 20:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346968; cv=none; b=CAg8Js+8qYaBsoY18qJ3IbVUub+vuE7R3uyPw2oiArM8wz2wHRdNWtqsELAcb04nIJFPJzvxCvzn5jCABiPWzvlSh7+KOCv8//Er5YC/AT9wiD0eJWeWGDpGlbF3uZGKL8WXomZnIGT0D0IxvqS0ZqHWuFxPGngfgwuOTpzBe3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346968; c=relaxed/simple;
	bh=9b+s/3mym37CG+Tkoct/nw7ktFp6tXbJ1H7iO891zuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpRn5MeZ4Vw7lvAEGSNw7zO8eiRXjGL3PSxD78U+xmCRphUd9BnFDG9abUWCR7oJw+FHBcwx4ebLsqXJiem8/WIQqtWNw32aTdhRXokEZmuhVuQpHL/2okD8eXCmgdXH9I61JiF9eBYwC+jn/vihr3bnH0p45vYk79JlZxljgBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6wKfWkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6wKfWkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D2BC4CEF7;
	Thu, 12 Mar 2026 20:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346968;
	bh=9b+s/3mym37CG+Tkoct/nw7ktFp6tXbJ1H7iO891zuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6wKfWkvX6AkK/HDYQWfJ6mZWgGrcqMmB4rf2esfBk2QHQJny/wMIw5v/pKniFRdM
	 IkFHDi2tOjmOwnd37Eaqk4CVwCeVn5exM4wcNWa3PjcPJBC0ROzZRBnQ0724ZubkFj
	 lHQ15/sJA2AuV4L82tyJ8d8CSFv6nIvjpguu/PYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yu <haoyufine@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/265] hwmon: (aht10) Fix initialization commands for AHT20
Date: Thu, 12 Mar 2026 21:09:17 +0100
Message-ID: <20260312201024.420450098@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 231aba885beaa..4099b5ba09824 100644
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



