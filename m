Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057064;
	b=H9sGch/M8K4Q4ny/wf297p9lhH3mTRSSLM1ZAik2kAox7CXz5FonU6nYk2q+oRpxE4/m
	 BCYl5XJl4bk0thTD6qhYXMHe2F3h0xgFOQ8ERzKpkr7e+oz23EzFFQhV97amDPDRshYiB
	 9AxHvfXFOh6sNlB9RYj6VgUuUeoBzY5MIX92wvfSOc+2WZ70JOyo9idnSrQapEz/naa01
	 ONjFkK8xOc1FSi9mf/BKm/wKbQXWFF49dFwlbVwGPY3VFvqJlFhZahoif1XqDjaSaUudQ
	 FTwbMgy93dOR38ZnaD7FGARLJToa7r5LkU4S5I4tutOTydwPKdCT95z4QKUliS7EdQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SlRhvRKQ7+KQt+XafHcMrV5YkH4UD3SxWxB6Piig3T0=;
	b=AxxFWwkYx+Pk+16Lbd2Sn8PagaojlGfC+8HkkiaYPG3Ha46Vzkg/2nu8OsaNgRZg+mKS
	 BXsDcuDMKZxQfLfNy9xFamjnoJx3ZDIQPbzXYYQHMFkVYJJRyLfgYxaTWbzYLXOISfndF
	 PV1dRgRUCb80H5FzMSIQje9idgZDGTecZWzKQVgRz9Se6Dm3/6nGkZU9bXbVpZH0428Uj
	 i+pECELl0XRmWWTvoIV5IfE2O+HF5dbQyg5fPYszUtAHnDVbODq8i094Q74z+kpUKW4WG
	 19Zdv/TrsDcCkx4pxIHbjf2ZJiJ6RO/cgSQuv0EXPDjLzlEb2QEO4VUcCDaLJ39p2AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA6mNCqR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F74606A332;
	Thu, 19 Nov 2026 02:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA6mNCqR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5A21F000C4;
	Thu, 19 Nov 2026 02:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057064;
	bh=SlRhvRKQ7+KQt+XafHcMrV5YkH4UD3SxWxB6Piig3T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yA6mNCqRhD5mpXSOEsw6IdIJ1EHHKLhjBSKJ67/rthHjqCaaApu9tevtCYNe7M3s7
	 1W3kHYGjafh7KirJRUYTyz0tarIBN9E7Ur1ekYwAkBj2yV5oeiSuC084aYxydNoGM0
	 Wmdpzl+TMTXavFgvLcg6lS8ITNsTY2nKRhsjsfGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2170/2214] rtc: s35390a: drop needless struct s35390a::rtc member
Date: Wed, 18 Nov 2026 16:04:06 +0100
Message-ID: <20261118150137.219746616@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5247d48190e4c..782beb03a638c 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -64,7 +64,6 @@ MODULE_DEVICE_TABLE(of, s35390a_of_match);
 
 struct s35390a {
 	struct i2c_client *client[8];
-	struct rtc_device *rtc;
 	int twentyfourhour;
 };
 
@@ -443,6 +442,7 @@ static int s35390a_probe(struct i2c_client *client,
 	int err, err_read;
 	unsigned int i;
 	struct s35390a *s35390a;
+	struct rtc_device *rtc;
 	char buf, status1;
 	struct device *dev = &client->dev;
 
@@ -468,9 +468,9 @@ static int s35390a_probe(struct i2c_client *client,
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
@@ -501,17 +501,17 @@ static int s35390a_probe(struct i2c_client *client,
 
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



