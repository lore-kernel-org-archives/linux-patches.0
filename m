Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028196;
	b=ZtQy3Stp1AMWCocBf8sMYr0XJFCLM5g/rBCXijLRSZuFxtgHHoec4p3i1gEK0rDpgg2m
	 YTYQoCTqKow73M+2iS9SvLpIdoWpyPpDzL1uwNi3C+b4wDMU67dh1JTYx1/6Kje5g/8V6
	 EQeVVWZ5bhcGf4QqWnjOGmqeXi9xivJAg/leb/nXgSfTiIkp6RfQBPohz/LYHJli3xt2G
	 i37tuy8t3ULeZ6G99eW+jGru8qN0YVWU61Boa68XXeYByhNd103WL4urrp2NP/KrJWNUE
	 IuZM9+vYFixEDoKzLUsOhoOrO/XkzEHJ6fh4sCbWDWICW6THrLWQyUqwro0ajYM/W4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HQtwU8wHRZWy4YlX5bhyQXVaAOCnFb5V5srWo2OMC9A=;
	b=5SQb5/LzQBFuILGRkJj8YfeHKz5ctdOKmScNgOiY2jGycZnbIEBA//lRBINHRLJirzm+
	 UcEjsp358QLlY1XiZf6nvg6Ivozk1Lpi5DXU3PP7U2XzbQbh0hdRue8JAzqzuBo+HFxDt
	 nbEVetoMrED6HHVoRCsUGy3FtNrjadRk6oBUc6epzlGrXcZ5jVvwWM9TWnpKPP61wTpYG
	 ADVzHpUdjhIyN/9B6nvnhdF53T/sFX9UlTm/ATQeTKmNFKRJ6s4z3Uf6HX/9nOpDJKMSI
	 u/6XFa+smkfMlf6bi+wviF6cLZsZolFKvhiI35XWv6LS12i0ztdzmY6b7IZtx6cvwDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S3tod+Xn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5BA606A31C;
	Wed, 18 Nov 2026 18:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S3tod+Xn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D66D1F000C4;
	Wed, 18 Nov 2026 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028196;
	bh=HQtwU8wHRZWy4YlX5bhyQXVaAOCnFb5V5srWo2OMC9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3tod+Xny7S8cNWMhV3FBqd3pqJVpHJ9d9yuyWVULuwcBIC1SeIFOwqdlXH7q5Xuf
	 BWkULnhI32bMNDyMnDqqisZEYTMQGgWeBnmbypXg8hMyoY6YHGBco7CEkPaIKVAq3X
	 8G4RP8AXyf11UOvzcYmu7C+0b4+DH7jV6aEIea7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2060/2151] rtc: s35390a: Fix alarm not disabling
Date: Wed, 18 Nov 2026 16:03:15 +0100
Message-ID: <20261118150236.760831315@linuxfoundation.org>
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

From: Markus Probst <markus.probst@posteo.de>

[ Upstream commit d93f29e41089bbb14637289fe77bdd72b71e9ac5 ]

Implement alarm_irq_enable callback.

Fixes: 542dd33a4925 ("drivers/rtc/rtc-s35390a.c: add wakealarm support for rtc-s35390A rtc chip")
Signed-off-by: Markus Probst <markus.probst@posteo.de>
Link: https://patch.msgid.link/20260930-rtc_s35390a_int1-v10-3-e7b1cbc50a7b@posteo.de
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 671e6e7ad7f43..c8fafdc64c508 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -269,6 +269,24 @@ static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
+static int s35390a_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct s35390a *s35390a = dev_get_drvdata(dev);
+	u8 sts;
+	int err;
+
+	if (enabled)
+		sts = S35390A_INT2_MODE_ALARM;
+	else
+		sts = S35390A_INT2_MODE_NOINTR;
+
+	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -409,11 +427,12 @@ static int s35390a_rtc_ioctl(struct device *dev, unsigned int cmd,
 }
 
 static const struct rtc_class_ops s35390a_rtc_ops = {
-	.read_time	= s35390a_rtc_read_time,
-	.set_time	= s35390a_rtc_set_time,
-	.set_alarm	= s35390a_rtc_set_alarm,
-	.read_alarm	= s35390a_rtc_read_alarm,
-	.ioctl          = s35390a_rtc_ioctl,
+	.read_time		= s35390a_rtc_read_time,
+	.set_time		= s35390a_rtc_set_time,
+	.set_alarm		= s35390a_rtc_set_alarm,
+	.read_alarm		= s35390a_rtc_read_alarm,
+	.alarm_irq_enable	= s35390a_rtc_alarm_irq_enable,
+	.ioctl			= s35390a_rtc_ioctl,
 };
 
 static int s35390a_probe(struct i2c_client *client)
-- 
2.53.0



