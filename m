Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050687;
	b=mhAtwIjpkS3hHBrI+T4aeexoLhjdqB3mVXL4latHx4lFmqq6XGUqTROFQkzVmybS8KEJ
	 MbByV/FapqiqXkoLmXSzs4THfBnsOFw1XrQzJFPKCZAFsPxeTG1a0PZHFfIjlpV/Z7o2w
	 5YnHtfsWXOhyoeDHuk85VPID+lELd7KZet0CvK+F1vG0pKfq5llmDHSGHIOgWY6ecz/88
	 2UBj6K9UwzMK7NelbAtplRRCoB/hc45wF5uzCAYJ+AUfptLep4JqYMuVGhoPpvf6sHGtB
	 3H/wOvn6bOpu0bAWIJrQz1QT4qQAkecFk1l6Q19SwQHJ7rRE+y22x2/uyTLF6nvvzpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bSYMVY5+SZ7buN5aYx0V2TcLovOG9H2mDom8I/c6Ma8=;
	b=ZNbadaVgZ5jddcfnLHiGhh15TW/Ejs49xBsZNt7s9OUKJAU2EuYlDEfgPKWFheZBrS9Z
	 SflYM2/QdA+hHLld1rdM2zspy4jXg4YqYGyAsgqhVOGJg1FDtOHcL05QIFz6GLaP9+Hz5
	 jAy9M4XDsW2TKqHJOQugk0C/ODfdi3MM860z7fjOY1u3+KBK2IZjpUlJgg4PD19vXUiVA
	 QYLTkjgmFLPjCWxtPccT1Kvl9NcrYRBBnT4bWQHAvlbbwVQY5yW5eGOansxQ9+nbQP2g+
	 rpLIPeUdj6AYxC0j0rlapusGlGOTf8FzWkyLSdo2BOGcOH2EDPTArDta8ZfjxR8ezXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aw5VQd9l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1885606A320;
	Thu, 19 Nov 2026 01:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aw5VQd9l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E031F000C4;
	Thu, 19 Nov 2026 01:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050686;
	bh=bSYMVY5+SZ7buN5aYx0V2TcLovOG9H2mDom8I/c6Ma8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aw5VQd9lNQk1BAEDoslerdX139zAUnWa4aQVrzGf0AfM7w6gVDtfF/X5t/Rtxh/A5
	 j4gvDVdZuAUa38UtgEOOERvx8KF12BYYvttlwISZ/ZkeAcBYqvQts5bwCAvJg8cEE3
	 ojBe/LQfYlcZhH/gLLwFrMxPR+4g5x4/u3E0D5c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2794/2857] rtc: s35390a: drop needless struct s35390a::rtc member
Date: Wed, 18 Nov 2026 16:03:48 +0100
Message-ID: <20261118150342.192729317@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit cd2a7052482e8a34348e30e6a6525ecb23f0d383 ]

The memory pointed to by the ::rtc member is managed via devres, and
no code in this driver uses it past _probe().

We can drop it from the structure and just use a local temporary
variable, reducing runtime memory consumption by a few bytes.

Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250304-rtc-cleanups-v2-12-d4689a71668c@linaro.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 6199051016cd ("rtc: s35390a: Read 24-hour mode on access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 64ce8a5f96a68..10646d6c41934 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -64,7 +64,6 @@ MODULE_DEVICE_TABLE(of, s35390a_of_match);
 
 struct s35390a {
 	struct i2c_client *client[8];
-	struct rtc_device *rtc;
 	int twentyfourhour;
 };
 
@@ -442,6 +441,7 @@ static int s35390a_probe(struct i2c_client *client)
 	int err, err_read;
 	unsigned int i;
 	struct s35390a *s35390a;
+	struct rtc_device *rtc;
 	char buf, status1;
 	struct device *dev = &client->dev;
 
@@ -467,9 +467,9 @@ static int s35390a_probe(struct i2c_client *client)
 		}
 	}
 
-	s35390a->rtc = devm_rtc_allocate_device(dev);
-	if (IS_ERR(s35390a->rtc))
-		return PTR_ERR(s35390a->rtc);
+	rtc = devm_rtc_allocate_device(dev);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
 	err_read = s35390a_read_status(s35390a, &status1);
 	if (err_read < 0) {
@@ -500,17 +500,17 @@ static int s35390a_probe(struct i2c_client *client)
 
 	device_set_wakeup_capable(dev, 1);
 
-	s35390a->rtc->ops = &s35390a_rtc_ops;
-	s35390a->rtc->range_min = RTC_TIMESTAMP_BEGIN_2000;
-	s35390a->rtc->range_max = RTC_TIMESTAMP_END_2099;
+	rtc->ops = &s35390a_rtc_ops;
+	rtc->range_min = RTC_TIMESTAMP_BEGIN_2000;
+	rtc->range_max = RTC_TIMESTAMP_END_2099;
 
-	set_bit(RTC_FEATURE_ALARM_RES_MINUTE, s35390a->rtc->features);
-	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, s35390a->rtc->features );
+	set_bit(RTC_FEATURE_ALARM_RES_MINUTE, rtc->features);
+	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, rtc->features);
 
 	if (status1 & S35390A_FLAG_INT2)
-		rtc_update_irq(s35390a->rtc, 1, RTC_AF);
+		rtc_update_irq(rtc, 1, RTC_AF);
 
-	return devm_rtc_register_device(s35390a->rtc);
+	return devm_rtc_register_device(rtc);
 }
 
 static struct i2c_driver s35390a_driver = {
-- 
2.53.0



