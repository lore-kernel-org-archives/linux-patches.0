Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215792;
	b=3Sbfb8u976UoTU7ttfOF98AaEe756rrzbJc31rEntCv2ce76q2jjZqo8O+hXfbt5cjv+
	 T+1JrxlQfh8M+DbHz0ztFCGi70iU0oYfaVT1RN3sc4jdRpz1OpWXdmiGH/vm1a+zYel6X
	 cr0w9Jd8QjYPwOGjo2R4m8rjT49GWE/bQQ0DtO9CXxeeh12uHNf8omE9tEDxYWbKwLHiH
	 WzaQLyjnkq9FPLK9ITllzKBKZrBvDwV92GQvW6hIzP7DxpQbu2xIvZLMld+LZl917zEmJ
	 AppQfRmu3ug/wJU3JEgK5iChYPzqFU7hZOjG/cIX47bE0W+MlV+BUULLlpARNOCsCWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5sGL5CDuTtPx+J0Qlq1q0aEdfAJAvqYn10vXfcEqPA=;
	b=IO0LGga+ObW1UjBCF0s4EsUVJJLslAY1xr2Vyde2uKRfu22AsEtubS7HSi71c+NOMAVM
	 +zak11BRgKdhcpnLVRDKSgSYkYa1rhK/P/QcT2AubwG7j/Or1X2WYfTzMCDhkyWRPTg5e
	 xVaeVxczzFJC1veJ8el0TGsG7gZv7rnWs8KGB4VyZJR2YLKJpuyHghr7U9jVGJ6hIZbVh
	 GvYVvqp0uaE2bkCrYz7Ahikd1C3a9uCdDszERbeU+dNu6BDIS1zHnIiGagdCcze7pfNVN
	 dw3NJ1p2jNkCjC87tuqF1veJO0B4IFkcfOQ9XIwhKdNNYbG10s+iXrGdOB1O3jltQxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dso5WxB3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDC0606A31A;
	Wed, 28 Oct 2026 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dso5WxB3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263B11F01825;
	Wed, 28 Oct 2026 19:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215791;
	bh=d5sGL5CDuTtPx+J0Qlq1q0aEdfAJAvqYn10vXfcEqPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dso5WxB3cKLPv9E8pCqnZ60xLNm1rYi7vU+mKKIaXBaKLBacqXr4a8/HXEYMImxoU
	 XA9mOFsacxgveYpH0x1oEO2W8gpJpRFhIPZUCvixjFoJznXY14Am9KbO6HUCTpBZtn
	 krwPdyhMaEoMlac9N6nN70FBoRnmuNSqEG6Z+fwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1335/1887] hwmon: (sht3x) Fix unaligned accesses
Date: Wed, 28 Oct 2026 17:57:11 +0100
Message-ID: <20261028170529.815457940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f46d5ab43a572b84773015a76966f5da56fc1748 ]

Sashiko reports:

In sht3x_update_client(), the 16-bit temperature and humidity values are
extracted from a stack-allocated byte array using be16_to_cpup(). The
pointers passed to this function are calculated as buf and buf + 3. Since
the difference between the two pointers is an odd number of bytes, at
least one of them is guaranteed to be at an unaligned offset.

This will trigger an alignment fault on strict-alignment architectures
such as ARMv5 or SPARC, resulting in a kernel panic.

Fix the problem by using get_unaligned_be16() instead of be16_to_cpup(),
and put_unaligned_be16() instead of cpu_to_be16().

Fixes: 7c84f7f80d6f ("hwmon: add support for Sensirion SHT3x sensors")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht3x.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/sht3x.c b/drivers/hwmon/sht3x.c
index 3f279aa1cee5e..381e33c6b4a2f 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/platform_data/sht3x.h>
+#include <asm/unaligned.h>
 
 /* commands (high precision mode) */
 static const unsigned char sht3x_cmd_measure_blocking_hpm[]    = { 0x2c, 0x06 };
@@ -241,9 +242,9 @@ static struct sht3x_data *sht3x_update_client(struct device *dev)
 		if (ret)
 			goto out;
 
-		val = be16_to_cpup((__be16 *)buf);
+		val = get_unaligned_be16(buf);
 		data->temperature = sht3x_extract_temperature(val);
-		val = be16_to_cpup((__be16 *)(buf + 3));
+		val = get_unaligned_be16(buf + 3);
 		data->humidity = sht3x_extract_humidity(val);
 		data->last_update = jiffies;
 	}
@@ -302,7 +303,7 @@ static int limits_update(struct sht3x_data *data)
 		if (ret)
 			return ret;
 
-		raw = be16_to_cpup((__be16 *)buffer);
+		raw = get_unaligned_be16(buffer);
 		temperature = sht3x_extract_temperature((raw & 0x01ff) << 7);
 		humidity = sht3x_extract_humidity(raw & 0xfe00);
 		data->temperature_limits[index] = temperature;
@@ -364,7 +365,7 @@ static size_t limit_store(struct device *dev,
 	raw = ((u32)(temperature + 45000) * 24543) >> (16 + 7);
 	raw |= ((humidity * 42950) >> 16) & 0xfe00;
 
-	*((__be16 *)position) = cpu_to_be16(raw);
+	put_unaligned_be16(raw, position);
 	position += SHT3X_WORD_LEN;
 	*position = crc8(sht3x_crc8_table,
 			 position - SHT3X_WORD_LEN,
-- 
2.53.0



