Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591127;
	b=wzMWHDeTY98Pt+EADMPVjHgLnFXIrM9gu0Q5+LyVhS+GKc2ZdCrF1ZENItejaG13+/vm
	 WvCSFMA5sjJ3sHzjzEPJ9ZePIOBoicgGhUL7JnrvwfLG8Gb/krdEPmJ95Q4tCD4S/5245
	 pte8il7cPkb931sf57YPo8NVLPQpCg8o+fBf9erEE7LN7ZHYKaki5eBOWwxDu4fV2P9qV
	 R3erSkYoCVh21XIUUoqLFfDQk+AwDWvqayF99SOvam6mdPRBlX1WO7MXnHzuR15+uDnJW
	 +X45oU/Ele6Nxz0d7P26ecWA0FuqsjA/kUQNyd4DPxceP+1UEiFf6DLcoMptYyQQ4SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNigncW5UEdhrKGwI0wPE9sV47X/hwu3f6B/SiDgZfs=;
	b=rnAl2IWKmPICIovX+rRKSHnQFlqWI5c+JIhnsOHq0JKiGXLchyXqOzZoftLKTjcaMQKg
	 sy3tCfmwx1pr0EKQ+z7XgmP2ij+J1EeEUb+uwLOL827EnR7nWGpwJr7fpWvJ3TqQW1k9c
	 ZyHPQl4NHpVrYI4kBPVaRKAS7sMkr3bntER1zHPljWRqrWAsJ0D+jeJ7NNfz2i14Q+3IA
	 zrsC8+Gbyq0bcR2UTbaHKDKKcDHnkZQtS2GqBAOHju1xiHBO5bX9YnDFEvs+1MsuvytNX
	 oBMUJWu59rcJiTMxabLtPbRHyzPSfBdqbHwONvn0bK0wuUxVyzAPed0ToCJevVFxZvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+BTObg8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150A2606B379;
	Fri, 13 Nov 2026 17:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+BTObg8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58031F000C6;
	Fri, 13 Nov 2026 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591126;
	bh=CNigncW5UEdhrKGwI0wPE9sV47X/hwu3f6B/SiDgZfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+BTObg8OMjhJKYwn457xkhddd2dL/IwSTrGkucTr48s069aIDX1hi7EdQvFGkq/W
	 AWvlcU+w/yFQ2/QmhNQpHlfDYOJ9p1fZg4uJjCSWxnRlmod9HXJYZbjLpJAhNg0HjB
	 N3/0XX1WS1OVXuZxdv7z9uaIEK2eQ4rsDcygjX+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/670] hwmon: chipcap2: fix be16 handling
Date: Fri, 13 Nov 2026 10:46:52 -0500
Message-ID: <20261113153820.243239216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 148b2c27ee7ea..ede664d22b8a6 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 #include <linux/regulator/consumer.h>
 
 #define CC2_START_CM			0xA0
@@ -257,8 +258,7 @@ static int cc2_write_reg(struct cc2_data *data, u8 reg, u16 val)
 	if (ret < 0)
 		goto disable;
 
-	cpu_to_be16s(&val);
-	ret = i2c_smbus_write_word_data(data->client, reg, val);
+	ret = i2c_smbus_write_word_swapped(data->client, reg, val);
 	if (ret < 0)
 		goto disable;
 
@@ -308,7 +308,7 @@ static int cc2_read_reg(struct cc2_data *data, u8 reg, u16 *val)
 	if (ret != CC2_EEPROM_DATA_LEN)
 		return ret < 0 ? ret : -EIO;
 
-	*val = be16_to_cpup((__be16 *)&buf[1]);
+	*val = get_unaligned_be16(&buf[1]);
 
 	return cc2_read_command_status(data->client);
 }
@@ -348,10 +348,10 @@ static int cc2_data_fetch(struct i2c_client *client,
 
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



