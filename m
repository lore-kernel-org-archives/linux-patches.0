Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703763859DC;
	Tue, 10 Mar 2026 11:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141179; cv=none; b=iJ8TEnndWiXXeBt2NxSiT/TGMWXYS2+PHZBHwOo0gH1ySZH7LbvJEI4eahJB8nj+7WzpVtn7q/0QRKHUGjkrI3E0JXTEcqNSWonZR4H+2O8hJr3udSe98SoySbPx6YrAnhuwpXSnjnFx1VdiNSXMhqRrDhym3NOmT+LM96T+RXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141179; c=relaxed/simple;
	bh=yILICB01yIfGtMLITw9t304k5DaGvmknZkrOf8HLh8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXUKCpnQW2HHQfQw/7VdVm0mMUu97LU4/Q2VjNBOtrGno0ERub39dIuPXbzVT2JRRpCQLKk9OxD+x5R0Vhg+9QWkNQVJWOSc0gQUiBCT9gabPTRxMwT25e0LcQPtpbhcvpQKfrrHOKzUtKDdviemx0h7buykjW7mFkLeEQQn0fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tFYJXa+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tFYJXa+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB04BC19423;
	Tue, 10 Mar 2026 11:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141179;
	bh=yILICB01yIfGtMLITw9t304k5DaGvmknZkrOf8HLh8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFYJXa+8Tmh03DGQL0s3tJ9muRILwo+LdHmHnC528GPQF/EL96oHoKXwo65xx/U4N
	 WlCWpBf/E+VkLsml78aKEgRQkHqGGZGeQq84e8Rkn9z70zWzVMyFc5vwJfeLSEuY93
	 SJ1TtU5PVwx/X/OjfhsBWrrDWK5rtVNAxAE13o7FV+Vd2TQsRoRRvxRwZ+iyq3sG2X
	 HsPMu8U3xMr6/gxj5P1zFfTWYecFgaZ1SZlVKBgrPCoJLrWqRyhU1hPA8xiUefxFXj
	 5wjHhHFoSxjysWLYuZk5Z2IHatgDW1kApo5gBLe91Ypnw8+Hl/wt3UyFfoBFczjv5s
	 9kAoxiCR1tlLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hao Yu <haoyufine@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 180/311] hwmon: (aht10) Fix initialization commands for AHT20
Date: Tue, 10 Mar 2026 07:03:47 -0400
Message-ID: <ecb9cd8eaec5ffdf61b2b0b524047c2a38361859.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 007befdba9776..4ce019d2cc80e 100644
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
@@ -341,7 +343,7 @@ static int aht10_probe(struct i2c_client *client)
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

