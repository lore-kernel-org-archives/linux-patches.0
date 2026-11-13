Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585535;
	b=TmzUu5IvzJoGb2eBjU1qaaqNpGlZevQDwS9sebTLDjUSr0G7xOTXCOx2hnijdkgTi5iT
	 oIdKn18EzirRIOnBZn/EWc0dAYwteD6rl4N+wqASWPSNtu72En3IYaABaYb864Ent6kaD
	 xqjx1w/9vSqpSMyjQF0KF/AAMzQbH15poz+cPFzKwAkL5L63aZdbbk7GjL9vMi6F2Ll5+
	 Und5HA5YAQ+5M7CUpc94cbPFLu/ZKdJgWk6VpktkWre8Q5Z53DE8oS+kD7dISy/zFs34W
	 2J3DilCmaKrR62Xt5tRUSEvjZtVS/6hp9LYgsKwR+SB6Z9GFcWfKZlFYaQdMY8d7C3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iGtoS/4uwnJs54+bGdQNz1wJT1xazvPSOrI4AONmYt0=;
	b=5TnEQnZvNP4yFV1KJplTchXMQLNCnWaVgKHlf2N+uDx2+CicmfwMf55r0n96f7vdDQCE
	 dpB69w38n7MHu9CaJz+Ekb4lpLnu3ScZI25f+fx7nkNm2+l9pTbDyYid1iHBTNFifi7nx
	 gGlEE0vrCeT21bCmLxi1dphSMcywePS5FERrpUjE6vYLiOGakcfp+bcAkSOrm7kykIGtr
	 KIyupHx5zhM2o90wpMf/xsxoDNKk0PIYQtx7eO3ePcnyI33eazjyUf85iAlnyo+oPl3Bj
	 nMUVF510jBp9Fw27pGPpTs+kXGOlgcP+Zsa7lE5miUpUWg30kaDUp7+GeF3PiBrRkkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mxCD/vLF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA89606AE39;
	Fri, 13 Nov 2026 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxCD/vLF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B66B1F000C6;
	Fri, 13 Nov 2026 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585535;
	bh=iGtoS/4uwnJs54+bGdQNz1wJT1xazvPSOrI4AONmYt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxCD/vLFY3fjKVIKqVbh9+CZtTbYHSAIDEPszymSJXwzCqGm8mryrcrMVLy3RJZ6p
	 SC9i2kWV9j2seyujH9NBIpjsJcW4YbCLvLdMkqo9ves9QVtatZ9zwNSF/v2farW9ZX
	 hgDztKM1H3YBDD24ntK8Fnv1vTQgvLNkdmaiZRM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 175/507] hwmon: chipcap2: fix be16 handling
Date: Fri, 13 Nov 2026 10:47:59 -0500
Message-ID: <20261113153800.413716028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 36b07ddfe20b0fe06a8bc32c5e09974876fb5e42 ]

The driver currently only works correctly on little-endian
architectures when writing 16-bit register values.

Use i2c_smbus_write_word_swapped() for writes and get_unaligned_be16()
for reads to correctly handle the ChipCap 2's big-endian data format
on all architectures.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-3-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 8102b6851d3d1..aec4adf986584 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 #include <linux/regulator/consumer.h>
 #include <linux/mod_devicetable.h>
 #include <linux/property.h>
@@ -260,8 +261,7 @@ static int cc2_write_reg(struct cc2_data *data, u8 reg, u16 val)
 	if (ret < 0)
 		goto disable;
 
-	cpu_to_be16s(&val);
-	ret = i2c_smbus_write_word_data(data->client, reg, val);
+	ret = i2c_smbus_write_word_swapped(data->client, reg, val);
 	if (ret < 0)
 		goto disable;
 
@@ -311,7 +311,7 @@ static int cc2_read_reg(struct cc2_data *data, u8 reg, u16 *val)
 	if (ret != CC2_EEPROM_DATA_LEN)
 		return ret < 0 ? ret : -EIO;
 
-	*val = be16_to_cpup((__be16 *)&buf[1]);
+	*val = get_unaligned_be16(&buf[1]);
 
 	return cc2_read_command_status(data->client);
 }
@@ -351,10 +351,10 @@ static int cc2_data_fetch(struct i2c_client *client,
 
 	switch (type) {
 	case hwmon_humidity:
-		*val = cc2_rh_convert(be16_to_cpup((__be16 *)&data[0]));
+		*val = cc2_rh_convert(get_unaligned_be16(&data[0]));
 		break;
 	case hwmon_temp:
-		*val = cc2_temp_convert(be16_to_cpup((__be16 *)&data[2]));
+		*val = cc2_temp_convert(get_unaligned_be16(&data[2]));
 		break;
 	default:
 		return -EINVAL;
-- 
2.53.0



