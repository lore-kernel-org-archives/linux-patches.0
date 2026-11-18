Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060802;
	b=iOhT3apfgFJ7ao4AqZPTxpa+eXdfztA5pv+iKNdHrG84OGjTb2RymqEHyaTnKyisjNck
	 8k0dgRje/YvkjjfOf1QDpKGLQBu80iNMAEkZXDdyRu/5Eu6yjrdmqPJdSgwCgahDPWzQp
	 QEWCw4HVsHk3pwo90SQMzvCPsNuB6v3uyUr4KaRmJTpc0iH8RdOJZMHJhkK5rurjOkkx6
	 /4FwZ4eb9/s/m/RsQG5DGVYb7vCRXhv70YVK3fjgD2Jjm3elZsAj/2kNvVRRy+l64ZlPP
	 U0cjXSjVL7y+tPOsXO9K5bjukGD6sEcVe6mY/NtIfm4nOVSFBsRNSYyzxz530c+RODQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=et8v/eUUglSKijEzluZBBLiHKaX8HvKlvlmDOOr7RZ8=;
	b=q4OiMMRGhWz2Y6NklqSvDaMFWx7VBBoZXOvlfbbBEwF4gF3Ld2dEqOdg/3M8qebTSqdN
	 P3ZTPqjtZxvXsT4uqc/YgJB2T43qyvW4HUlPEsVMg3i52OFgrCIsanKSJGr01WqffVOFC
	 D+zJnPC5bpLrKz8/kd4vQFugNtZjQbxSqrVspH2aaZkAUynRgmqXS8OpdIAjC+uO6BtdI
	 Y3KovfHhlOrXE1fdFrhZ/nbYm9PPyLw8UIiHvUO7eg2bdh2zvgc4LhzmJJYrlU7eVkay9
	 J1TaMNC0fLOfmzRJ5vWeoK6TOGfwuYmPK8C8Eg2WtMre0jumsKWysO4fWqaGVxDcJ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RW4gGI5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAAF606A333;
	Thu, 19 Nov 2026 04:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RW4gGI5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5DA1F000C4;
	Thu, 19 Nov 2026 04:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060802;
	bh=et8v/eUUglSKijEzluZBBLiHKaX8HvKlvlmDOOr7RZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RW4gGI5RCy9QjAKiU5P0mOqRgdIoXMQ9y8ZCQLSX2MAcxwpAP4eI3tSXf1I/vX1/d
	 nKoJvYS1Asi99H9fGklaH5bsqJ9VP+yJkKc5SnMuy1cGmCJdU+Orup0pWff52W5NJY
	 7ztYvsi+YcjhDWk7ebtXgUy6MzlaSDi50sz73X/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1289/1848] leds: pca9532: Check i2c_smbus_read_byte_data() return value
Date: Wed, 18 Nov 2026 15:55:27 +0100
Message-ID: <20261118150013.531638321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1cf39aecaf088..d799eaaa09784 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -259,12 +259,15 @@ static enum pca9532_state pca9532_getled(struct pca9532_led *led)
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



