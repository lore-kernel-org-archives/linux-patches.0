Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024010;
	b=OxGXAoEJviNoVXl5+wiXJ75cIx0f8hTENbVlPFfIpSPbPMCfTezDHvrVbTUcXVDaRxsM
	 rKfRJCvvrZaQ0gVFXgPB9f6ijXU3jxo4QcDzzZBV2PDfY0NJ40wonz9VhXCGshMt1IekX
	 CaD+VFogLnAfe4YT0qze1j6NW1n/75qZ1r3LqoNAmbAgtZKc6jm3J0Ap3SXnV+/EnhuX4
	 WXQ7fYJ4vI0viWPqtql58qWwli2TK05Drphq7Xvp9wEvUGnDCRTKbGJqCD8UxIr61ZE73
	 P5qnFt5kYg0Wd3+SiAV2zRro2XLB4XIcVFSBG9F8K4XckLN6jQGBXWGL7VrSqTpM0jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tOzjW0CYNeGGZmWryLbKwPwSFHrKg4k9EIwTQETeEu8=;
	b=MqTUD+WIFhJrJ318uxqU0tAc0zHS6iMAeYz9P3XAlVjl1CDP9/hgcHg93L1ClN9+Xnot
	 ElKb/0udOCzJ2LG/mOMWcNfn/qK7LV6eKg1jrP9196U1kVhG+kpIa9CutsnQZmOavZpBC
	 TbuWO2mqOgfVoHnQ0kFHRfsg2hl4zzEsOmCpsRplk5Mg+Q8A/qVc2hz/OoG+fi96kSdMa
	 Oj+eWczTuT/U/J4j56XHcR0iCSCwHZC77CXxGjVhTdWYbXgJ/nY2pTpXhT03emZwstw94
	 ScxpN9vTxs+4bq85XQbYW4Z7okn2NJM0VRFkz8c5LN2MqhCz2gkgBbZJ9bX/9a+koBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tAuU0kEO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92AE606A32A;
	Wed, 18 Nov 2026 17:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tAuU0kEO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9791F000C5;
	Wed, 18 Nov 2026 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024010;
	bh=tOzjW0CYNeGGZmWryLbKwPwSFHrKg4k9EIwTQETeEu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAuU0kEOBYBw5jT/WjQ8z2q6QclsjXjsFRdk08tySKoLdbfEg0VGwk3xlCDdch6vR
	 QHqeS0xepr3yEGGBTYC3YXlE+5XAv5CrFC2PFD30KD9oFqAgdmBdFbg+LkR8q8nPHa
	 j+GL9Ob+fFeyAT1kKaZQdRQDMpqoHpaqU8LpemVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0574/2151] leds: pca9532: Check i2c_smbus_read_byte_data() return value
Date: Wed, 18 Nov 2026 15:38:29 +0100
Message-ID: <20261118150142.862258457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index ba0fea0add2b7..cdcb4ab2ee60b 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -298,12 +298,15 @@ static enum pca9532_state pca9532_getled(struct pca9532_led *led)
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



