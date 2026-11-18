Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039951;
	b=bcSsquJCjHMmWvrS89MOflez8vX2lXvNUdexuCC4uXa7xnx1z7zorOZrcadFTOj4hQtx
	 nnM2EWj190D2FiBapo/9lIQWhlx8emcdcDqR/+L4tuEFcX63jc7cHr4M4vIn47SjQzE7w
	 FRp/MGAsFq6e+KPsn5G6V7YEG3W+U84XnWjaY7r9Td3HPdn6JxxPCL239IjpTVMxTQJEV
	 zEn9lb9c8Ud4rVG9h71duFfDufzVD/OvL+RCktnxIYoccRhOQMrrlgn+WJp/0FlyefOPR
	 x6YxwbejmfZT236KAZ5xFObn6PyRKOFeRpmdIzo5pqWOD6nE2zG5VdfPAC5pZnB2jFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pvYZxiPGr9YNm4nNZkUX6rvpCp013tOqGsPwcdRCqCU=;
	b=n+mp4yK2bgxHYmwuhL6SlyWxCWDhOCxSQNM786LEAkGBBwzT9kYBTAql4zxVq+BjzG31
	 m7MiKzfxrn8tu0pjnro2n0Px0BZHMhBi9BVb7JZcIqjO6e/8P/ADeTRf3tEpiDmmMDZZX
	 DUpuIiZ2cP1u+uC5tFgE74HSq3REUnseQsvGoY4p14BSqekdKnNzYBRC92cB3X66exYKs
	 GeipigGG6JTMJyxq3RiG+7Qtze4zJIk/as6PrYloijPN+YznwU320TzkVbyPAvYfbTRiU
	 wFHf2vewnpj0ykzNf281Z9UKjpMJSojr90HZ+pkP/+C7Ipy8hME2XWUl4c/Zz6yBvtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzC+VL7C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A991606A31C;
	Wed, 18 Nov 2026 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzC+VL7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AF91F000C4;
	Wed, 18 Nov 2026 22:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039950;
	bh=pvYZxiPGr9YNm4nNZkUX6rvpCp013tOqGsPwcdRCqCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzC+VL7C7j57CniJNso96YXPykmKDtsz3V8mooeYnJK5h2jptEJ6EmRFZoselM2Bg
	 M1fjt4FficdikH4dUcxW44qtgCi394EDQ9QooQVB30vppzVDfdqEKcndpBxRt6IYlu
	 bhUc7y23I2tSef+PQWq1bm0x/6ki5QkoO32vGtk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2284/3318] leds: pca9532: Check i2c_smbus_read_byte_data() return value
Date: Wed, 18 Nov 2026 15:48:26 +0100
Message-ID: <20261118150430.280925242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 1b75f038e5f71ed32ce6593b5763f9776ec58a25 ]

Coverity report INTEGER_OVERFLOW (tainted_data_return ->
cast_underflow -> overflow) in pca9532_getled().
pca9532_getled() stored the return value of i2c_smbus_read_byte_data()
into a char and used it directly to compute the LED state without
checking for an error. i2c_smbus_read_byte_data() returns a negative
error code on failure. On an I2C read error the negative value was
assigned to an unsigned type, triggering an integer underflow/overflow,
and a meaningless LED state was returned to the caller.

Read the value into an int, check for the error, and fall back to
PCA9532_OFF while emitting a warning when the read fails.

Fixes: 28c5fe99016d ("leds: pca9532: Extend pca9532 device tree support")
Assisted-by: VeroCoder:vero-1 [cli]
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260727-led-fix-v1-1-d635c5037109@nxp.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca9532.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 34eab5f547fc6..0fea8f3ea798c 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -257,12 +257,15 @@ static enum pca9532_state pca9532_getled(struct pca9532_led *led)
 	struct i2c_client *client = led->client;
 	struct pca9532_data *data = i2c_get_clientdata(client);
 	u8 maxleds = data->chip_info->num_leds;
-	char reg;
-	enum pca9532_state ret;
+	int reg;
+	enum pca9532_state ret = PCA9532_OFF;
 
 	mutex_lock(&data->update_lock);
 	reg = i2c_smbus_read_byte_data(client, LED_REG(maxleds, led->id));
-	ret = (reg & LED_MASK(led->id)) >> LED_SHIFT(led->id);
+	if (reg >= 0)
+		ret = (reg & LED_MASK(led->id)) >> LED_SHIFT(led->id);
+	else
+		dev_warn(&client->dev, "failed to read LED register: %d\n", reg);
 	mutex_unlock(&data->update_lock);
 	return ret;
 }
-- 
2.53.0



