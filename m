Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057050;
	b=WioksYmCHa9ihSJTQ1eECMV1F4uinPUXURhQOZOeMPwbMBOktkKdr4bk/MeCvrg7qwkO
	 QwD4vV8Jo60qa6ss/eWvxBo1UKKI1tQdQkS5VB5P+ryCCmRxqYITwSlkrO0oP6b9Cr/5+
	 CxRdGIAFa6h54GpflQs185hJ8uGIqv974LusO0rbLHtkegt1i3o7VA0U28NDXI5IHNkKh
	 cbVsLpwpZvf5odcufKaDPLNWnn3Prl6z9c1hLeWrCNP2Z0ivMimnzXbs5n5EgGj4FByRl
	 SQBvneun+njFR8oGn9nReaUcB3lwOlKAWN/0M6jTH1/rIdR4QqM1k6/NI1/aqEeyaNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyk2ZBpAM6+bVFXwjaUiK+g06SOdGIciuwbblbmdwU8=;
	b=ufadzsyZfQRRDpvO+oarsOxIocLFR+McVzjh7zuzOdKR/2K/atffEIAeuRJ8jJXm3ONz
	 cG3QxLUN56I7bNHW/nQvn9x4hrJXOnhnirluVk+JqnT3kpRHQv4wGT1FyJcEp5ZzSMQjL
	 GKnDkq5eFiXkDpvoZRTT6joxf/wQabI5WXkVBZM7SZ4+8Z/vkRHD22jJqa/xyPorZfP7t
	 +vu7guHsLGbAf4mIGbBiDYCXYgaEYBzfRoJIWDtyMEU0zqCU1pt1Lw3CliitwY95Qr2mD
	 o/h1qPkKn7kEXf0zdSPlXqSEwBP1tgl6Fp4gDaoHViyx9rL+XOi9y01/JuevZjuYEAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HLl2Wr3y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B0A606A31C;
	Thu, 19 Nov 2026 02:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HLl2Wr3y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8521F000C5;
	Thu, 19 Nov 2026 02:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057050;
	bh=xyk2ZBpAM6+bVFXwjaUiK+g06SOdGIciuwbblbmdwU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLl2Wr3yQxmkwvHWlhwFSzXxX+iYzroj4OpEw7fp0Lf09pVJg/AnRgF9HXz7SIms8
	 qXkH8DGoxfg5Axn3uLH0vv62u3r5zKuFSQZ4ezFe3BGKGSxKr7oSWL55yQSjduuKV6
	 Arxr5v3BIN0ZMppHphkD1qRvoEKMhY0ljdyvh9cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	ye xingchen <ye.xingchen@zte.com.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2169/2214] rtc: s35390a: Remove the unneeded result variable
Date: Wed, 18 Nov 2026 16:04:05 +0100
Message-ID: <20261118150137.181793179@linuxfoundation.org>
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
index ced6c0497ed6e..5247d48190e4c 100644
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



