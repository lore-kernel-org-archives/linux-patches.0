Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022185;
	b=lZOEeB2p26DXcNXyVNdkOK+0TqGu4mOo343ha1p5OdeAVGHoz50FHCIDddkKQxAINgeV
	 K6nZZFAvNvfbxT4e21XXzVkWIbONF0k+Kr3xf7azIfuG0/hGkOuyY89b9ao2SxtYrQOJg
	 sIk44a1jse/wUIW8c3EJfNMdWjnNcrRfxPgv5bVeTl6uLLn98kGXMLjj+XvNyS5Uze40S
	 XEm36uzd7393q7XGlGBNjTAPXzSn9SXYSzK6n0x6P8P6fzx7SRVD2GKPVfPWbLL51HK66
	 v0C4VR1gcUUUjvdWOjOtIFvC9Hll3o1NaKmJ/MUuNNacsWb6LoElqusyN9OhrNbvOxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wj2zd3jHvlHOMryBUOCVuBNiWLeLyRzwt642Dgw/xIc=;
	b=tSQWMGKIOcYBSlWF51aPcHJcWDwXJetl7mTV0z3POZySSSvjA9le/lX+NaqEQNZzIz0T
	 aw4eUtnwFmruEe/Qux4nDJhGGRUS5eKe5mnGA2h3eoOwnR1BW9w2xd1zmwZ35sfZfBqU6
	 nPxmLFqdvVJ2X4M6U9ElWF3MAAxOaR/IcKFjdvfT2IXBlJ62LsRHBznRRTIQe4kmBW0AC
	 9x892mT1jLMK0NckzyR9Lukak36u+zcQ2TELrGGbGg679UcB5vik9FhLyd3r6fiBNFJnS
	 21qdl9Hw31qNjbweUIlxyigPnVtVBdomch4WvIeFPMmCiF5W/FkXZkFFZN75AYPytXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="THPcK/jb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A33D606A32C;
	Wed, 18 Nov 2026 17:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THPcK/jb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEEA1F000C5;
	Wed, 18 Nov 2026 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022185;
	bh=Wj2zd3jHvlHOMryBUOCVuBNiWLeLyRzwt642Dgw/xIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THPcK/jb/DjStJArVZIYYtrqfHXy68oDcb0ASNhU9v+yDo5QFWFunrVDoylB3E4qj
	 Mk/QluZ/1oyDZpxxtNq10QYo/awUTQ0oVYiE6sGvnoGb7gkS5WbS66wsovtKBG0Jis
	 4ss2T9d5WH0lmQKBRxqU/k3wUvhKmKnHEsmdKtZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2571/2651] rtc: s35390a: Read 24-hour mode on access
Date: Wed, 18 Nov 2026 16:03:31 +0100
Message-ID: <20261118150416.940485273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Markus Probst <markus.probst@posteo.de>

[ Upstream commit 6199051016cddba920b6023a44199c5221352c44 ]

Instead of reading if the 24-hour mode is used on probe once, read it on
access. This makes it impossible for the mode to be out of sync and fixes
time corruption if resetting the chip while in 12-hour mode, as
`s35390a_init` did not update the cached value.

Fixes: 16486d0c1c65 ("rtc: s35390a: handle invalid RTC time")
Signed-off-by: Markus Probst <markus.probst@posteo.de>
Link: https://patch.msgid.link/20260930-rtc_s35390a_int1-v10-4-e7b1cbc50a7b@posteo.de
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 78 +++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 575bb256eb258..12ed504db94d8 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -64,7 +64,6 @@ MODULE_DEVICE_TABLE(of, s35390a_of_match);
 
 struct s35390a {
 	struct i2c_client *client[8];
-	int twentyfourhour;
 };
 
 static int s35390a_set_reg(struct s35390a *s35390a, int reg, u8  *buf, int len)
@@ -102,9 +101,8 @@ static int s35390a_get_reg(struct s35390a *s35390a, int reg, u8 *buf, int len)
 	return 0;
 }
 
-static int s35390a_init(struct s35390a *s35390a)
+static int s35390a_init(struct s35390a *s35390a, u8 *sts)
 {
-	u8 buf;
 	int ret;
 	unsigned initcount = 0;
 
@@ -117,17 +115,17 @@ static int s35390a_init(struct s35390a *s35390a)
 	 * The 24H bit is kept over reset, so set it already here.
 	 */
 initialize:
-	buf = S35390A_FLAG_RESET | S35390A_FLAG_24H;
-	ret = s35390a_set_reg(s35390a, S35390A_CMD_STATUS1, &buf, 1);
+	*sts = S35390A_FLAG_RESET | S35390A_FLAG_24H;
+	ret = s35390a_set_reg(s35390a, S35390A_CMD_STATUS1, sts, 1);
 
 	if (ret < 0)
 		return ret;
 
-	ret = s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, &buf, 1);
+	ret = s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, sts, 1);
 	if (ret < 0)
 		return ret;
 
-	if (buf & (S35390A_FLAG_POC | S35390A_FLAG_BLD)) {
+	if (*sts & (S35390A_FLAG_POC | S35390A_FLAG_BLD)) {
 		/* Try up to five times to reset the chip */
 		if (initcount < 5) {
 			++initcount;
@@ -181,9 +179,9 @@ static int s35390a_disable_test_mode(struct s35390a *s35390a)
 	return s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf));
 }
 
-static char s35390a_hr2reg(struct s35390a *s35390a, int hour)
+static char s35390a_hr2reg(int hour, bool twentyfourhour)
 {
-	if (s35390a->twentyfourhour)
+	if (twentyfourhour)
 		return bin2bcd(hour);
 
 	if (hour < 12)
@@ -192,11 +190,11 @@ static char s35390a_hr2reg(struct s35390a *s35390a, int hour)
 	return 0x40 | bin2bcd(hour - 12);
 }
 
-static int s35390a_reg2hr(struct s35390a *s35390a, char reg)
+static int s35390a_reg2hr(char reg, bool twentyfourhour)
 {
 	unsigned hour;
 
-	if (s35390a->twentyfourhour)
+	if (twentyfourhour)
 		return bcd2bin(reg & 0x3f);
 
 	hour = bcd2bin(reg & 0x3f);
@@ -210,7 +208,7 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a	*s35390a = i2c_get_clientdata(client);
-	int i;
+	int i, err;
 	u8 buf[7], status;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d mday=%d, "
@@ -218,14 +216,18 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		tm->tm_min, tm->tm_hour, tm->tm_mday, tm->tm_mon, tm->tm_year,
 		tm->tm_wday);
 
-	if (s35390a_read_status(s35390a, &status) == 1)
-		s35390a_init(s35390a);
+	err = s35390a_read_status(s35390a, &status);
+	if (err == 1)
+		err = s35390a_init(s35390a, &status);
+
+	if (err < 0)
+		return err;
 
 	buf[S35390A_BYTE_YEAR] = bin2bcd(tm->tm_year - 100);
 	buf[S35390A_BYTE_MONTH] = bin2bcd(tm->tm_mon + 1);
 	buf[S35390A_BYTE_DAY] = bin2bcd(tm->tm_mday);
 	buf[S35390A_BYTE_WDAY] = bin2bcd(tm->tm_wday);
-	buf[S35390A_BYTE_HOURS] = s35390a_hr2reg(s35390a, tm->tm_hour);
+	buf[S35390A_BYTE_HOURS] = s35390a_hr2reg(tm->tm_hour, status & S35390A_FLAG_24H);
 	buf[S35390A_BYTE_MINS] = bin2bcd(tm->tm_min);
 	buf[S35390A_BYTE_SECS] = bin2bcd(tm->tm_sec);
 
@@ -243,8 +245,11 @@ static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	u8 buf[7], status;
 	int i, err;
 
-	if (s35390a_read_status(s35390a, &status) == 1)
+	err = s35390a_read_status(s35390a, &status);
+	if (err == 1)
 		return -EINVAL;
+	if (err < 0)
+		return err;
 
 	err = s35390a_get_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
 	if (err < 0)
@@ -256,7 +261,7 @@ static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	tm->tm_sec = bcd2bin(buf[S35390A_BYTE_SECS]);
 	tm->tm_min = bcd2bin(buf[S35390A_BYTE_MINS]);
-	tm->tm_hour = s35390a_reg2hr(s35390a, buf[S35390A_BYTE_HOURS]);
+	tm->tm_hour = s35390a_reg2hr(buf[S35390A_BYTE_HOURS], status & S35390A_FLAG_24H);
 	tm->tm_wday = bcd2bin(buf[S35390A_BYTE_WDAY]);
 	tm->tm_mday = bcd2bin(buf[S35390A_BYTE_DAY]);
 	tm->tm_mon = bcd2bin(buf[S35390A_BYTE_MONTH]) - 1;
@@ -292,7 +297,7 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	u8 buf[3], sts = 0;
+	u8 buf[3], status1, status2 = 0;
 	int err, i;
 
 	dev_dbg(&client->dev, "%s: alm is secs=%d, mins=%d, hours=%d mday=%d, "\
@@ -301,22 +306,22 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 		alm->time.tm_mon, alm->time.tm_year, alm->time.tm_wday);
 
 	/* disable interrupt (which deasserts the irq line) */
-	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &status2, sizeof(status2));
 	if (err < 0)
 		return err;
 
 	/* clear pending interrupt (in STATUS1 only), if any */
-	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, &sts, sizeof(sts));
+	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, &status1, sizeof(status1));
 	if (err < 0)
 		return err;
 
 	if (alm->enabled)
-		sts = S35390A_INT2_MODE_ALARM;
+		status2 = S35390A_INT2_MODE_ALARM;
 	else
-		sts = S35390A_INT2_MODE_NOINTR;
+		status2 = S35390A_INT2_MODE_NOINTR;
 
 	/* set interrupt mode*/
-	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &status2, sizeof(status2));
 	if (err < 0)
 		return err;
 
@@ -325,8 +330,8 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	else
 		buf[S35390A_ALRM_BYTE_WDAY] = 0;
 
-	buf[S35390A_ALRM_BYTE_HOURS] = s35390a_hr2reg(s35390a,
-			alm->time.tm_hour) | 0x80;
+	buf[S35390A_ALRM_BYTE_HOURS] = s35390a_hr2reg(alm->time.tm_hour,
+						      status1 & S35390A_FLAG_24H) | 0x80;
 	buf[S35390A_ALRM_BYTE_MINS] = bin2bcd(alm->time.tm_min) | 0x80;
 
 	if (alm->time.tm_hour >= 12)
@@ -345,14 +350,20 @@ static int s35390a_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	u8 buf[3], sts;
+	u8 buf[3], status1, status2;
 	int i, err;
 
-	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	err = s35390a_read_status(s35390a, &status1);
+	if (err == 1)
+		return -EINVAL;
+	if (err < 0)
+		return err;
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, &status2, sizeof(status2));
 	if (err < 0)
 		return err;
 
-	if ((sts & S35390A_INT2_MODE_MASK) != S35390A_INT2_MODE_ALARM) {
+	if ((status2 & S35390A_INT2_MODE_MASK) != S35390A_INT2_MODE_ALARM) {
 		/*
 		 * When the alarm isn't enabled, the register to configure
 		 * the alarm time isn't accessible.
@@ -381,8 +392,8 @@ static int s35390a_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 
 	if (buf[S35390A_ALRM_BYTE_HOURS] & 0x80)
 		alm->time.tm_hour =
-			s35390a_reg2hr(s35390a,
-				       buf[S35390A_ALRM_BYTE_HOURS] & ~0x80);
+			s35390a_reg2hr(buf[S35390A_ALRM_BYTE_HOURS] & ~0x80,
+				       status1 & S35390A_FLAG_24H);
 
 	if (buf[S35390A_ALRM_BYTE_MINS] & 0x80)
 		alm->time.tm_min = bcd2bin(buf[S35390A_ALRM_BYTE_MINS] & ~0x80);
@@ -416,7 +427,7 @@ static int s35390a_rtc_ioctl(struct device *dev, unsigned int cmd,
 		break;
 	case RTC_VL_CLR:
 		/* update flag and clear register */
-		err = s35390a_init(s35390a);
+		err = s35390a_init(s35390a, &sts);
 		if (err < 0)
 			return err;
 		break;
@@ -503,11 +514,6 @@ static int s35390a_probe(struct i2c_client *client)
 		return err_read;
 	}
 
-	if (status1 & S35390A_FLAG_24H)
-		s35390a->twentyfourhour = 1;
-	else
-		s35390a->twentyfourhour = 0;
-
 	if (status1 & S35390A_FLAG_INT2) {
 		/* disable alarm (and maybe test mode) */
 		buf = 0;
-- 
2.53.0



