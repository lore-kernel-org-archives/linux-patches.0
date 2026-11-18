Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033146;
	b=lu6MWlD3+Gwe7lagvUqTciCtLuQ8bQysTZgzLilJXY61ZZJjFuQk1PP5zLMrik8eCltm
	 Ec/A70DMzyxI5hrhkN5Mn+Q2/6oBIVuCSX1su2Y14SJNq2XirpNbdThFBfx+FU54INZoY
	 mNYXEfqmnQFt++QCK7Uo0iPkNBio1m+ihu+w57ezoR81Ltywsrmsb62+oChIOfz9dNfKX
	 pXQ3mpqihXUSZ9OxOGlY3rJNQs1CueUrJCMkid10TE1xOXhjor6UZwFGWRLce+bsOTzyq
	 58dSBG9whVh8I3D6pr4V3FI1bHXnYmCwiECaXlKK5r/ZItfLA2l236J9W25B4NdAORw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zSa2OK4V7peVP9AMk+hBPR2xwzzC/YYAENGV5JvjiCA=;
	b=VA4yAg+IpIjLZeiDIbCqUwHYeDvwIN8fsUrpkqifIZFO+vsP4y8jirYoy4d44U/7XDH9
	 EeOt8DdCFogcwHXsWvUfLnAscG/Q9WPLbZQ9DyM2gl+TsGWZ65g20XKvI7lriHUYQXCFs
	 c/tBI0c0h84evkNk+rDfHx4tp3Hr4vYIDOsZKSPu49N/4C+RL4U7qgI6yiXjUS4uN5ifL
	 XlqBeFvqdLeLb43znRyYYQZCK6kN2sUBoBee4Dc9JRln3KMNpM5pSVVmQ0Ic5yzzmncYU
	 +MwB+utWzAMDBxbwu75TOpl7lV1Y2uIOze+p2rqTOMQdT6BZGVKytkr/cVmlA3nwSpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acCMNZaC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75CE606A330;
	Wed, 18 Nov 2026 20:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acCMNZaC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214661F000C4;
	Wed, 18 Nov 2026 20:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033146;
	bh=zSa2OK4V7peVP9AMk+hBPR2xwzzC/YYAENGV5JvjiCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acCMNZaCLdtfvz1cQM7fONa/n7jZUbrDQDej5NAs/voPl2/EnOImnpVPyd+AfsNNM
	 hqQNqkyXxkFmjdogKX8AmR/X/UkC/g9hwwb0qOTSBTHfyMZfhmG8fTj+pcvvGeEiEX
	 n3VPsta/IYQnpP3O3e605+0AWj2B9wxwtsNkTnhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Huang <sef1548@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1664/1756] rtc: s35390a: use u8 instead of char for register buffer
Date: Wed, 18 Nov 2026 16:03:11 +0100
Message-ID: <20261118150115.963733728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



