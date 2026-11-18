Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055205;
	b=N/8DTXftX+cPfIjl47V4cNyJPzo4aBpQmlNZ5Stpit6ccL6QnFD6fu/Lli/4DA6iOiPh
	 9RKB6KhYj8QYt+JmbFQPu98q4OYFfn+Pg1W1Iz/+i+VE2EpEIjqJGCF59R+GQLl19m1u4
	 WEaB93IPjW1aELN5zkclbZ4gKJYC9YYQ9ufFFklR6HBgjjLieGvF+sNbx5dFcLiDLtlZ9
	 7bfxqJKkl+DPRjwst6ePbRNnmRpL0D4ZPOEyxIRaLZJ7ktsmbKoamJs2cTqGwjS3VEyGF
	 momf2jcOCksgVLdM7kYE4AuKbc/d8Oe9/uvbD++s5y2op1nKie1H4c1FdoAbc2tyY+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XxexMMM0vq9Z73gACIuxZtklXjaIL3YMNDNnw4G01yU=;
	b=kAFIszImLmUAvkmwjC8IuukddaJKfyrlt46XlGCzpI28SMf9RpYehedqCxfxa0O6EmiW
	 HhH8y1J/ekYtSzY84Gt6yvQ2emn0WhrybzSxdlCtYF/cEJI6DkovZgZmfnJnqKPJJxB0Q
	 qAulxE9gfvG7pHFvyzZ8VuvHisEzTDya2z9fUQLgCHGfcAX2vlNDS+HDWREjNLNQg0lXG
	 11u4ParZwzK3cevrw60RoSmBqQJ9FLvd8yJstDBq9PhXeeV9wZNbxmC9cnqkVVro37+vc
	 2TWZ+riOULwxTW5ND/OwKa5Bh1cB+GIpahnSzdatPkN8OMehNbVKYofNj1MeI56mWDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pczVVmQN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE5A606A320;
	Thu, 19 Nov 2026 02:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pczVVmQN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A411F000C4;
	Thu, 19 Nov 2026 02:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055204;
	bh=XxexMMM0vq9Z73gACIuxZtklXjaIL3YMNDNnw4G01yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pczVVmQNZK50UAwK9eDSj6JT9SnhIYpd1pqSpApzMi6coSTG82qlNHtguxBLru0ed
	 Zc/dNHPCr5kUShc9FSqB8EwJMwKkL4AlVvMzVQ+Iewfl4HxmHy1lDQOuznX1VB3btd
	 7tS+Cyztflv6iQhltwa+9B8bsoj311Nnc+Jsg64M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1546/2214] leds: pca9532: Check i2c_smbus_read_byte_data() return value
Date: Wed, 18 Nov 2026 15:53:42 +0100
Message-ID: <20261118150113.976813421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b7d0aeeecfcf8..977b4419df34c 100644
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



