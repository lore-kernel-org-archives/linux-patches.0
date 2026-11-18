Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061571;
	b=2k2RbHAw9ZQkJR3b2PUKgAGtsPKIg8CalvOmiCIsY7gYxYqSI73b8P8kDPv9bXGs6y/R
	 a/y0riZJhuIGiBtLT3QFSHijFelesx7ifQaKKfM2e/hUZ1u6UctOTGc/BuqoRqk+IC+YJ
	 yyCUeVm27Iyd0q3JOyfPQbZ6VlaCklmAvPbZP77IYRHxsYQCPk+51d9cva0mXhiCLZdpK
	 nzWayuubeis8IPG6VNRTHyx2MnumO6XB28M1TwLMt3MkYP11LHUIkqMK5Bhrt0YJCMlei
	 hPIxhZg2EcROj8YgIudIUGzaoLE7JxIUcru7wkgV1BxJPWngW5GGlOYs9XPhNA+7fzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rSq4wohnvk/xJSqumbesYYFJ+xy8nRqSvlBNkqWgmPw=;
	b=wMF8ceWlxEtO3kl4qqQbqQEPDTYO9goFl8CGA/rYf3Nj/V4JsZ2iGAYef+V0itzIf4l1
	 tf52tzpHbxja68nuozj+Qr7wee9moxmLJU4kV8UxNpe1L+jXzlS5p7bhj16rkmiXWq8dd
	 nFZWDtYCS+2IJ4MTBwCRzP8encWYP8+kGLYsPxm4PUsvrxXb4artiitt7M54q1Sgpi4VS
	 izvqTk3X1SuhYlLNt4TT4wr5cq9WLOIDPKRnKYqg+NHS0vQS/hWUy6BXKlwTHTdyLHv25
	 IQMigpIpBcY3SJ0Jibuwcs4zoMOEHke1GPEnW59EhUGABVvoTkOH+7zLWvSUYDTSzHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bH+u2Fzs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AB660A261F;
	Thu, 19 Nov 2026 04:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bH+u2Fzs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0815F1F000C9;
	Thu, 19 Nov 2026 04:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061570;
	bh=rSq4wohnvk/xJSqumbesYYFJ+xy8nRqSvlBNkqWgmPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bH+u2Fzseukrc3/8IzNRECtpOWH09C9EHv8ePDp8+xTo1XTTf0fcfzgCNTjaYcFLt
	 SQzyXErL78wogxizBnhWMSq6qjovnoNN+LhKT8wTwD6/PMGtbPf7B8zqHaOQ7ErMRt
	 i7a1ewbtEy783L5v2g++dCqOxwY5J7QD1S+FqtEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	linux-rtc@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kevin P. Fleming" <kevin+linux@km6g.us>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1558/1848] rtc: abx80x: Add utility function for writing configuration key
Date: Wed, 18 Nov 2026 15:59:56 +0100
Message-ID: <20261118150024.835095928@linuxfoundation.org>
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

From: Kevin P. Fleming <kevin+linux@km6g.us>

[ Upstream commit 49dfc1f16b03a6abc17721d4600f7a0bf3d3e4ed ]

Writing one of key two values into the configuration key register
is a common operation, so a utility function has been added to
provide consistent behavior and eliminate code duplication.

Signed-off-by: Kevin P. Fleming <kevin+linux@km6g.us>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
To: linux-rtc@vger.kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20200615105113.57770-2-kevin+linux@km6g.us
Stable-dep-of: 632916c7bde3 ("rtc: abx80x: properly handle shared IRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index b4be5ad6366e3..c95fdbadbcca7 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -117,6 +117,16 @@ struct abx80x_priv {
 	struct watchdog_device wdog;
 };
 
+static int abx80x_write_config_key(struct i2c_client *client, u8 key)
+{
+	if (i2c_smbus_write_byte_data(client, ABX8XX_REG_CFG_KEY, key) < 0) {
+		dev_err(&client->dev, "Unable to write configuration key\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int abx80x_is_rc_mode(struct i2c_client *client)
 {
 	int flags = 0;
@@ -140,12 +150,8 @@ static int abx80x_enable_trickle_charger(struct i2c_client *client,
 	 * Write the configuration key register to enable access to the Trickle
 	 * register
 	 */
-	err = i2c_smbus_write_byte_data(client, ABX8XX_REG_CFG_KEY,
-					ABX8XX_CFG_KEY_MISC);
-	if (err < 0) {
-		dev_err(&client->dev, "Unable to write configuration key\n");
+	if (abx80x_write_config_key(client, ABX8XX_CFG_KEY_MISC) < 0)
 		return -EIO;
-	}
 
 	err = i2c_smbus_write_byte_data(client, ABX8XX_REG_TRICKLE,
 					ABX8XX_TRICKLE_CHARGE_ENABLE |
@@ -360,12 +366,8 @@ static int abx80x_rtc_set_autocalibration(struct device *dev,
 	}
 
 	/* Unlock write access to Oscillator Control Register */
-	retval = i2c_smbus_write_byte_data(client, ABX8XX_REG_CFG_KEY,
-					   ABX8XX_CFG_KEY_OSC);
-	if (retval < 0) {
-		dev_err(dev, "Failed to write CONFIG_KEY register\n");
-		return retval;
-	}
+	if (abx80x_write_config_key(client, ABX8XX_CFG_KEY_OSC) < 0)
+		return -EIO;
 
 	retval = i2c_smbus_write_byte_data(client, ABX8XX_REG_OSC, flags);
 
@@ -452,12 +454,8 @@ static ssize_t oscillator_store(struct device *dev,
 		flags |= (ABX8XX_OSC_OSEL);
 
 	/* Unlock write access on Oscillator Control register */
-	retval = i2c_smbus_write_byte_data(client, ABX8XX_REG_CFG_KEY,
-					   ABX8XX_CFG_KEY_OSC);
-	if (retval < 0) {
-		dev_err(dev, "Failed to write CONFIG_KEY register\n");
-		return retval;
-	}
+	if (abx80x_write_config_key(client, ABX8XX_CFG_KEY_OSC) < 0)
+		return -EIO;
 
 	retval = i2c_smbus_write_byte_data(client, ABX8XX_REG_OSC, flags);
 	if (retval < 0) {
@@ -765,13 +763,8 @@ static int abx80x_probe(struct i2c_client *client,
 		 * Write the configuration key register to enable access to
 		 * the config2 register
 		 */
-		err = i2c_smbus_write_byte_data(client, ABX8XX_REG_CFG_KEY,
-						ABX8XX_CFG_KEY_MISC);
-		if (err < 0) {
-			dev_err(&client->dev,
-				"Unable to write configuration key\n");
+		if (abx80x_write_config_key(client, ABX8XX_CFG_KEY_MISC) < 0)
 			return -EIO;
-		}
 
 		err = i2c_smbus_write_byte_data(client, ABX8XX_REG_OUT_CTRL,
 						data | ABX8XX_OUT_CTRL_EXDS);
-- 
2.53.0



