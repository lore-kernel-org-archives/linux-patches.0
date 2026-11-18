Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042765;
	b=pr51/LFFn+FEi/44xxL5lHasuMUaNM4MyqDpJlxFKPcdxpGUIm9EFY7C81MmG7xNfDiL
	 yIRaLXaUcTEKrHQSM63jeM7niDe+DRf6XMZhlFr8EdCqu82a96+TD5OHbxLesJ/B77QvM
	 g9qBRuocxINNK7qXALOOf7r159cNiMUY34pBS9PUe3HmV8mOiMI6KSycnUDcJP4MMhzc9
	 HM6s4XfUrl3P4XdaM5b0vgXi/FXDANSnDzgf4KvdoPJsMwEdp+gG/7EBYEfHcSMn0lpY9
	 UTkmDIyK4RgAC3WiDPjsCUVeRMtXz/CtHU0zcoPxirVt4g1o1WP0kDCJ8+gMQVNL8tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFMA0/MDah2k+etGxSz5tNRdMgHr++LTsgZeL9NTb18=;
	b=kL2mlwYELH7UF1TjnSPt/Ze575O26wJO8zo0Xh9jEyvZJL3FyJ9pGYLHnEUaTIy3L+/J
	 8QH7CAXDKt/m66JFxN/g9sCSGCPO+FYUbCowAlm9zuratKMaohYikkek74iOBICvfMDa5
	 QC4c63f/KwCnwLYQ6iP3d+/nEO6rQ6XEc/5fZtX8afne+E6Hg7Q+1tqep1b1RU8mHznl+
	 UU1dmFvoQElund+P364A2pFow4PCVNjs4/f6eyFavyGmDyxxjil1OROat19qF0PtotKjG
	 Vn+4E3RZ6md3cfy4IglH7I2MVU1MEfybqlEDzCNm/dIWLeXODLW9Ljd6smSbehdfTnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VG89ErYY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B993D606A31C;
	Wed, 18 Nov 2026 22:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VG89ErYY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88EC1F000C4;
	Wed, 18 Nov 2026 22:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042765;
	bh=eFMA0/MDah2k+etGxSz5tNRdMgHr++LTsgZeL9NTb18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VG89ErYYKvp46Euq53RbjV4Lk2rjh4HoK7gOI4RSvK5GJYFbkXlrRCHfFSvJbiNrD
	 ZTId3wzso54FilwCpLSGZI857brWhZg2w4lCXB8Qc88pFDJSnvVxduiCRQniuGpQGX
	 P91rXsB9bw0S/9SoGlrB0v4+c6aS4EVjYbt7x5Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Huang <sef1548@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3247/3318] rtc: s35390a: use u8 instead of char for register buffer
Date: Wed, 18 Nov 2026 16:04:29 +0100
Message-ID: <20261118150457.066777638@linuxfoundation.org>
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
index 91bb0c2009708..7895b9f97c51b 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -67,7 +67,7 @@ struct s35390a {
 	int twentyfourhour;
 };
 
-static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
+static int s35390a_set_reg(struct s35390a *s35390a, int reg, u8  *buf, int len)
 {
 	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
@@ -84,7 +84,7 @@ static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
 	return 0;
 }
 
-static int s35390a_get_reg(struct s35390a *s35390a, int reg, char *buf, int len)
+static int s35390a_get_reg(struct s35390a *s35390a, int reg, u8 *buf, int len)
 {
 	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
@@ -169,7 +169,7 @@ static int s35390a_read_status(struct s35390a *s35390a, char *status1)
 
 static int s35390a_disable_test_mode(struct s35390a *s35390a)
 {
-	char buf[1];
+	u8 buf[1];
 
 	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf)) < 0)
 		return -EIO;
@@ -211,7 +211,7 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a	*s35390a = i2c_get_clientdata(client);
 	int i;
-	char buf[7], status;
+	u8 buf[7], status;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d mday=%d, "
 		"mon=%d, year=%d, wday=%d\n", __func__, tm->tm_sec,
@@ -240,7 +240,7 @@ static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	char buf[7], status;
+	u8 buf[7], status;
 	int i, err;
 
 	if (s35390a_read_status(s35390a, &status) == 1)
@@ -292,7 +292,7 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	char buf[3], sts = 0;
+	u8 buf[3], sts = 0;
 	int err, i;
 
 	dev_dbg(&client->dev, "%s: alm is secs=%d, mins=%d, hours=%d mday=%d, "\
@@ -345,7 +345,7 @@ static int s35390a_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	char buf[3], sts;
+	u8 buf[3], sts;
 	int i, err;
 
 	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
@@ -402,7 +402,7 @@ static int s35390a_rtc_ioctl(struct device *dev, unsigned int cmd,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a *s35390a = i2c_get_clientdata(client);
-	char sts;
+	u8 sts;
 	int err;
 
 	switch (cmd) {
@@ -442,7 +442,7 @@ static int s35390a_probe(struct i2c_client *client)
 	unsigned int i;
 	struct s35390a *s35390a;
 	struct rtc_device *rtc;
-	char buf, status1;
+	u8 buf, status1;
 	struct device *dev = &client->dev;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-- 
2.53.0



