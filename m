Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590306;
	b=rTTH5SnqOD5k1ncY0uJsQMZ7qurM7YAWwGtoQy+A/9r2sqODxPDhuw3KHOHpxJTW0o3z
	 Wf448a5sQYBe9N+qEosY2n9rbr7HfsRAXXsx6GdiUJAbjack83UvYHcHTyLJQrCUuBivG
	 rL3e47SDbf2Cv9i4Qo6zcX8XblpzC0dBacdrnC7w1bg8RAd1F/y9hjzPlOIvqVLZhcO8W
	 KTzILnhugwN7XcyRYCg972lVM+10r5mDUjeixYUuIVLDKydcZKfOwlqwfy/6okhXRnu3X
	 u/h+hIGRbUCULE09gZqX/0zJw+wc2q7VU8hcA0pI+Terjgc6FzYlDitBwdydCIUp0lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FW1q/1LKBuvs8AbttgkbMQGZ9scyV0+HRoiDk+cdQnM=;
	b=kWFEALabyA/Ef1pvblCLZh+ZyYZefHciHXYn8iOMgYvyaUEJrtG94x4DAbcdyxQuNwd3
	 GwgQVGTQtDxv+cgTfgVYS8OniZsva+78GXCP/9TXYTh3PLTtAD0K623Z/btccFtbyVEI0
	 0+e/51zTlB42ZcNpDWGjoMsSNVPyk/mm66tea2LaC4ghRphTlXxvIrCKzjgCtdOO1CGd/
	 CZHjw0s2rTFTzMQTM+ooXfHT7WzZFLVNodEZ0fKmNudYr1xdHz+c7eqBs2nPsO9rGSlDC
	 uW8ZexhZHUCF10d2m+GjqNnrPAmX4+ugKl6zkVQA2hu6lQSJKzrSt8nIRMrxzT2nfWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQsJ10Hu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A6F607C36D;
	Fri, 13 Nov 2026 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQsJ10Hu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06551F000C4;
	Fri, 13 Nov 2026 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590306;
	bh=FW1q/1LKBuvs8AbttgkbMQGZ9scyV0+HRoiDk+cdQnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQsJ10HuAXSCEh1VwlLrcn0dqDfJ+ONaW/tTpkFDsHBLJMeWIzYzlsoGjdP46pfnX
	 BjtfxR56FP8H6iFMTc+xXy/ujFQf8e/ttkm2uqTAhecSVRNq7XULOXTQ8ka5lL+W16
	 PqTsf3jvBEczqHyNjQtfB/JBCw8lFQdByqo1ciSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/686] hwmon: chipcap2: fix be16 handling
Date: Fri, 13 Nov 2026 10:46:47 -0500
Message-ID: <20261113153830.288065306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c5b6e147467cf..b7b59ca4a4f9d 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 #include <linux/regulator/consumer.h>
 
 #define CC2_START_CM			0xA0
@@ -258,8 +259,7 @@ static int cc2_write_reg(struct cc2_data *data, u8 reg, u16 val)
 	if (ret < 0)
 		goto disable;
 
-	cpu_to_be16s(&val);
-	ret = i2c_smbus_write_word_data(data->client, reg, val);
+	ret = i2c_smbus_write_word_swapped(data->client, reg, val);
 	if (ret < 0)
 		goto disable;
 
@@ -309,7 +309,7 @@ static int cc2_read_reg(struct cc2_data *data, u8 reg, u16 *val)
 	if (ret != CC2_EEPROM_DATA_LEN)
 		return ret < 0 ? ret : -EIO;
 
-	*val = be16_to_cpup((__be16 *)&buf[1]);
+	*val = get_unaligned_be16(&buf[1]);
 
 	return cc2_read_command_status(data->client);
 }
@@ -349,10 +349,10 @@ static int cc2_data_fetch(struct i2c_client *client,
 
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



