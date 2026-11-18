Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042754;
	b=oD17RtmHpZ7y4JKYzLrJGu08JVkG7Y+95bY5LnO23WPgQy85CEtQn6JjBEoUTzNSaa6Y
	 9Zcxp0XxUWhIPMXEc2IATYW1SDlxKno1OwxVkk87c3xd/g7QAVKLV3mVNFktFmUD19jyW
	 N3bDq+QNcye6igZSuYBS7YC9uX8yUIveIEdLfJemcGJ1zbuPZlCx0z/EAbsA6z4t1UjVy
	 CEH8nqU33zB4bYqWWaVS2BZ+SUqEw3i1VZv4qTf/WEQAoRZw/uwuQGybhvVlvASGB2SrS
	 GDjADjUNBToqoNJSSurw3ImBuSq/SEu6F/UlAENY9lXNqA04XLkcRyfQua6iIYMZn9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f9TOqO0zquny7NsjXLwX62dXaIKIgVIzt9wyKU7/Re8=;
	b=gavGeHzNlLi0YMuqgqH+pOlwJfiCLorSDs6ig2mU+hNCEbTXLofV9Q+Xj3nrPxavWAda
	 SGgZiLvSjwtvPVlvSJ5EeNSR2dwkbdV1J3YWafyZXWx5odicIIt1DPlK4wrgnj3+/LVBH
	 Q6cTUriNzrHzvPcNAyyASwDBzcz443yu3AgUYwHmBTpm4HaNOLQRPBYM9NWLy3cyvPbj9
	 tGyhGiRCXmJVPlpd8gdD+f6xi+Zs5raTXyrBx4+BZ4v+WlD59QMTYbWm2RZWTnP/AyKM3
	 AzuY675eI6ohTLm+7ZoPOJTpjBgdAEzF411VvbnoVUNiuwSXNzfhG60o9aQLilHfXBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vc9QYk2F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896D4606A31C;
	Wed, 18 Nov 2026 22:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vc9QYk2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F0F1F000C4;
	Wed, 18 Nov 2026 22:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042754;
	bh=f9TOqO0zquny7NsjXLwX62dXaIKIgVIzt9wyKU7/Re8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vc9QYk2FDJngCzNYC10xYfqDiSMmqMyYDjTG2WtnkI+XQ/vFiOUzyqM6hEG5l2rQL
	 fEiGwvMrIY/lUj+w7L+dvElCqKRMINYk19Phl/l9+WNxnHXm08/67dWodBXk8v3CVT
	 OJNX/X0I5higfBRuQ8PAlIVmtNJYxdo0zY4+q0Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3246/3318] rtc: s35390a: drop needless struct s35390a::rtc member
Date: Wed, 18 Nov 2026 16:04:28 +0100
Message-ID: <20261118150457.040586616@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0c45993764a45..91bb0c2009708 100644
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



