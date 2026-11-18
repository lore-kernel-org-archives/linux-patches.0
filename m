Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028199;
	b=ysJlPQp7HiKSUaA9B22F3GPoy9CIpkdF2WwzijVxua3nTfioJ0cTEIDpi6AkTdfIPzE7
	 rAyA5Ggx2++Y2OziuH9LvpJFVDvy0EvQiN1i6NA1/9PQQUCZMaKFGVoe5EeJtETA1THWY
	 0GokXkxwgna7FNBonniwv7eWBxzCyQ98Wn7SRNEy55vn7fY6LDOWdwaZi+pugRtV0ovSA
	 uYOLa6l40mG1zguBRcfz5J/ebi9AR9lVFgmK9p0ewfc54c5ToiiPXEvmTIuFFp2RkJGEo
	 JYS5PIs2XkXh7JP6NNL+cCP88ruTDUPdlcYak6at5mbi2XIUAuI40HARuONZ+AHVnzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dze3qUt8WS/YcrzPrqZMC9ZPv3l0JhIWz15dDv+oEPM=;
	b=dTW+0W19d/RdIA9v+x6bbt1E0056BUzorM0qbuXMtG8F0uVORlCySLZgFOfdhc1+1Mhm
	 JTqLpv6sBai3wUiSq9VRFqIhts0ZfoDEtWmsZDUa7SNzTlNNBmQ8HyX7oJ0HZCkX1pKTl
	 NIQz9E9YLg8wEdUpTy34kuRnslqofhmbJUAAVzbokNFgSXetdULOfht/08YYg1TIL5GBN
	 Ft1xt/PSh94mOAXRe/4geXwCab5CpXAkcV1i7iBsg+yG8GbwF7ObxmUxC56BKh0yYHSFm
	 WtKR4Fa+zSh/fEUObd530y2tbUrTwWCWzt41niBWKQS16rvNgq3yumOltpJIMIcVIHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pXpdzno4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE1A606A32F;
	Wed, 18 Nov 2026 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pXpdzno4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5218E1F000C4;
	Wed, 18 Nov 2026 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028198;
	bh=Dze3qUt8WS/YcrzPrqZMC9ZPv3l0JhIWz15dDv+oEPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXpdzno4CSDIT/aOcXcVacP+kD6QwZt8dKFWijcgWgoTZtyhH86DuuDVXZ/+ogbn9
	 iYSiasQV4RSDZ4j/K/5ZICwHIVt3R/o7W1yM+rz+UQSFUNPrthSTM8LoNMQU68JXSW
	 RIoGiTuWURg2nSYfBDcZ3vRkSObOkvpGJyiSkemk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Huang <sef1548@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2061/2151] rtc: s35390a: use u8 instead of char for register buffer
Date: Wed, 18 Nov 2026 16:03:16 +0100
Message-ID: <20261118150236.797692657@linuxfoundation.org>
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

From: Nick Huang <sef1548@gmail.com>

[ Upstream commit 73c4638a2864e69ff2251080ce874d360fd13056 ]

The register buffer in s35390a_get_reg() was previously defined as
`char *buf`. This is not ideal since register data represents raw
binary values rather than textual data.

Switch the type to `u8 *buf` to better reflect its intended usage and
to avoid potential issues with sign extension when handling register
values on platforms where `char` is signed by default.

This change improves type safety and makes the code consistent with
other RTC drivers that operate on raw register data.

Signed-off-by: Nick Huang <sef1548@gmail.com>
Link: https://patch.msgid.link/20250920174224.108795-1-sef1548@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 6199051016cd ("rtc: s35390a: Read 24-hour mode on access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index c8fafdc64c508..0713a5afadfa6 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -66,7 +66,7 @@ struct s35390a {
 	int twentyfourhour;
 };
 
-static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
+static int s35390a_set_reg(struct s35390a *s35390a, int reg, u8  *buf, int len)
 {
 	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
@@ -83,7 +83,7 @@ static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
 	return 0;
 }
 
-static int s35390a_get_reg(struct s35390a *s35390a, int reg, char *buf, int len)
+static int s35390a_get_reg(struct s35390a *s35390a, int reg, u8 *buf, int len)
 {
 	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
@@ -168,7 +168,7 @@ static int s35390a_read_status(struct s35390a *s35390a, char *status1)
 
 static int s35390a_disable_test_mode(struct s35390a *s35390a)
 {
-	char buf[1];
+	u8 buf[1];
 
 	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf)) < 0)
 		return -EIO;
@@ -210,7 +210,7 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a	*s35390a = i2c_get_clientdata(client);
 	int i;
-	char buf[7], status;
+	u8 buf[7], status;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d mday=%d, "
 		"mon=%d, year=%d, wday=%d\n", __func__, tm->tm_sec,
@@ -239,7 +239,7 @@ static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	char buf[7], status;
+	u8 buf[7], status;
 	int i, err;
 
 	if (s35390a_read_status(s35390a, &status) == 1)
@@ -291,7 +291,7 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	char buf[3], sts = 0;
+	u8 buf[3], sts = 0;
 	int err, i;
 
 	dev_dbg(&client->dev, "%s: alm is secs=%d, mins=%d, hours=%d mday=%d, "\
@@ -344,7 +344,7 @@ static int s35390a_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	char buf[3], sts;
+	u8 buf[3], sts;
 	int i, err;
 
 	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
@@ -401,7 +401,7 @@ static int s35390a_rtc_ioctl(struct device *dev, unsigned int cmd,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	char sts;
+	u8 sts;
 	int err;
 
 	switch (cmd) {
@@ -441,7 +441,7 @@ static int s35390a_probe(struct i2c_client *client)
 	unsigned int i;
 	struct s35390a *s35390a;
 	struct rtc_device *rtc;
-	char buf, status1;
+	u8 buf, status1;
 	struct device *dev = &client->dev;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-- 
2.53.0



