Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590320;
	b=yOSNmATWhruQshwM0cZxocKCpPYwb3+/4MFIXzoDCxK6UygOgM769CyJa0yS22yvpROg
	 FhYYbg6Smwg2kSFa1JPnw+RH1QRvpcUh0LS4ZSOPpkLalE0jL5NBFPc5dEExDUMMeWAnV
	 4R9xEeKQR9Zaj4li3K10vdRgz5/W4/8LE4LYd+lz6pPEZeolnuXYNJcgmipBwOEeSXXIT
	 YvIzDY83cKPiuMM/1tzmHH0run4WQAkhVeoIbgIlxX1JQqSoS+KqcIr+c7PmM46WY0+vR
	 ijZUAVv81hseqv6C9Nc+yBaTS0CNH1ViEProtkV7bmWewsRTvmRtE5uBGF4KYO6OoHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/NWSX3CZNmifZUAaTsZarzABfOjwX+FAhr2Czq8d/rM=;
	b=UYbXbyfzFeg7uesHTGoRpzipkgHQQ8fU/gokCUW9F+RY/BhNUf92MVaU5t5+5bngW8B2
	 o13HU6OoMHCYroLRDTRtyC88BeR+0TxQhTNvCZQBRso6+XwMq4jUg5qE7aeC4Lc5bp9Vn
	 LQIyIf9zpGXSU93vwQoeZ3tzu1AkY6m5jlA0GGOKkft5IIr4vGtxZ3/DoiWaSTV+6bDYF
	 +bNJLxnQ9xMwXHuKu8jGKsp81URoZr+msSavMczpHKBNdvZvhs+nDbhrT+oWohuhfuJoB
	 vb456ZlGst/Jb2WUXwSY7cHiDMm+vUFr5VjLFBk1ToIwFbr61+Q9/OSAdQZ/wxQPG7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gLKiGQay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1E0606E214;
	Fri, 13 Nov 2026 17:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gLKiGQay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1431F000C8;
	Fri, 13 Nov 2026 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590319;
	bh=/NWSX3CZNmifZUAaTsZarzABfOjwX+FAhr2Czq8d/rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLKiGQaybeMDJiHkDORzXaY5GnMkFagKN7LXbeVHGU5FURp0XtHoLzjUeqqmpiVTX
	 ZUfkc7v6Z6VgOH4/W2Bv5HytF8TP3UmchRwPHTfZ8pm1WHZOFTXd++7AespyP3JjX7
	 hkTJWNvrpXqjkOf8R4vFbBYYSUz/JUquujoB0aMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/686] hwmon: chipcap2: defer probe when IRQs are unavailable
Date: Fri, 13 Nov 2026 10:46:48 -0500
Message-ID: <20261113153830.322105606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit b5a1412618f93b594f924cf4f3b4bb6b5dc49d41 ]

This device can work with or without interrupts, but if they
are provided and still not available, but if -EPROBE_DEFER is read,
its value must be propagated to enable probe retries.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-4-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index b7b59ca4a4f9d..34c3e26211458 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -624,6 +624,8 @@ static int cc2_request_ready_irq(struct cc2_data *data, struct device *dev)
 	int ret = 0;
 
 	data->irq_ready = fwnode_irq_get_byname(dev_fwnode(dev), "ready");
+	if (data->irq_ready == -EPROBE_DEFER)
+		return data->irq_ready;
 	if (data->irq_ready > 0) {
 		init_completion(&data->complete);
 		ret = devm_request_threaded_irq(dev, data->irq_ready, NULL,
@@ -641,6 +643,8 @@ static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
 	int ret = 0;
 
 	data->irq_low = fwnode_irq_get_byname(dev_fwnode(dev), "low");
+	if (data->irq_low == -EPROBE_DEFER)
+		return data->irq_low;
 	if (data->irq_low > 0) {
 		ret = devm_request_threaded_irq(dev, data->irq_low, NULL,
 						cc2_low_interrupt,
@@ -654,6 +658,8 @@ static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
 	}
 
 	data->irq_high = fwnode_irq_get_byname(dev_fwnode(dev), "high");
+	if (data->irq_high == -EPROBE_DEFER)
+		return data->irq_high;
 	if (data->irq_high > 0) {
 		ret = devm_request_threaded_irq(dev, data->irq_high, NULL,
 						cc2_high_interrupt,
-- 
2.53.0



