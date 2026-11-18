Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050684;
	b=UEO5yCi7seFaFzcQH+zqcaPml2ePrw9z8JOjU9IcSMFlPBJcBoVUjxPBqVXCtY9zBmTr
	 d2y/PV5AwWl15LEamY7UAuHbC6yIevv+fXW9IZKhiuHicf8hmlP+zuyhaKmRBZ6V8/4s6
	 Ri1W1ryHZ+IfmOdIbyHdNAeZL/sOJ8O8ZR5clTB1edK4/zLk6VTVxYcFTHIY5qJp+EWR9
	 Xyv4ZvDFRJ4raF5ol3pIFsDmfFacYnHhUgCixE8rN4DTkM76bl54FSPjxhhsi+8/4Eald
	 oui65u75GY7IoGtaif4DcsiiMjD+z9WkGMDZwKMqMU8ZsRi8ZUXK76uQazy5tNfP67g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DmbKvEty28UMz6I1xBvLbjse/bTuR6+zXBqvzXizdLQ=;
	b=KfbmtsSc4Jy764h6xsUlNpfTjVFLfkXJiMFf92mYCYVCGheowT0TYn/HIjyKgfOUQecn
	 M5IatEm8Pcuzlo6Tpq15zyTXRLxCs8wr0D5Ayn5g2g7bUg7cBtZBs4KFNaUN14Yaq94Wl
	 /A68wBP4sqT/0qBn9xazNNaBd0x4bFUWOSd+T9MBls3YAiXOkH8L+a2/DwD2EsvbVL+Po
	 xVVTo9pSc3tEl4yGU41jHisGTKn9MliWgc78QZJrLEDxbjq3G+LCViDXraBe3UIymS/p7
	 Kizk5+7tU83argtgDNdcR8JqOuKhXB8VEGlvForli784yTYSXx12COrhZgZ5Yv2hwZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZBuW/KLC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C1C606A32F;
	Thu, 19 Nov 2026 01:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBuW/KLC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CFB1F000C4;
	Thu, 19 Nov 2026 01:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050684;
	bh=DmbKvEty28UMz6I1xBvLbjse/bTuR6+zXBqvzXizdLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBuW/KLCSWd7cK5DmKlkIPBFjjN6fcekNEnd169pXihitmT8xkNaMVWZR9paAvxgb
	 +xz3mVpZdAsA0W/vgdTv5U+oTkC9Ry9KCWEKGFQkV8YW+A4RlcTSjCe64FF2Vg0wOq
	 gAZAGh6NpWOGqxh7myZ9J3tRsCOdO7Y5IatW7ygg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	ye xingchen <ye.xingchen@zte.com.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2793/2857] rtc: s35390a: Remove the unneeded result variable
Date: Wed, 18 Nov 2026 16:03:47 +0100
Message-ID: <20261118150342.160536525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ye xingchen <ye.xingchen@zte.com.cn>

[ Upstream commit f8513363b0b7155afaee09cca777fc608dc957e3 ]

Return the value s35390a_set_reg() directly instead of storing it in
another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Link: https://lore.kernel.org/r/20220905090119.335121-1-ye.xingchen@zte.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 6199051016cd ("rtc: s35390a: Read 24-hour mode on access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index c10765959d101..64ce8a5f96a68 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -211,7 +211,7 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct s35390a	*s35390a = i2c_get_clientdata(client);
-	int i, err;
+	int i;
 	char buf[7], status;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d mday=%d, "
@@ -234,9 +234,7 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	for (i = 0; i < 7; ++i)
 		buf[i] = bitrev8(buf[i]);
 
-	err = s35390a_set_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
-
-	return err;
+	return s35390a_set_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
 }
 
 static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
-- 
2.53.0



