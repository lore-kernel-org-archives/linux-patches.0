Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028640;
	b=P8qIXx06P+iGzllmbucoSJB/eKNb4ujBREzOjexnG//BrZY2IV407e63KSxoDSssj6Us
	 8pkkMBVTXPmeJFXUxTKDKSLS8BRrltUaYPkz1+LHx7O+/np3qEwYrzmbGIHqeyR28JyUP
	 9Bsy68ci6aFBpFa2VwfEf8NOfu4xu1FuSakqzmLuWvecgtD3TQ0B+AOb1NWWSOZ/ycVRt
	 fkmJNhqi//JQXgPY29kXX2P9aTV8+4e9mgdmxYtewda8vExsMKbu3R9GjaN5TgUq68Acm
	 M08oRp3IZq2pmx2BH+gMzNmaH4e3ZVij6/eeHq08Yu9tdcVocJkOw1IDPH3VmGbvIZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IPFYi522xuTwkfBxTCbVlbITXLPgUcAMprU2aTwUeqw=;
	b=xvicNiITMw1eG5dCudVjSMhg3sGnD0xF04q52OpITcUOWCU9WpnNOSvR0+D0ZsNsTj7j
	 p1chLSzrHssfVj+u8GOBfISL9bI21wnKt8VhScRfkepa+wgaLYZKayW+YRUdN0TEvY1lh
	 I+WmGgKRrtpZ6QjbjY0cdV9QzjdkLZtT92vnLz6UCXHtDjziD71R9+cBujH7qMESah6Wh
	 0zfuzG4Zhi44Hjb+MTgw5mRcD71dQvyd318OehvS6BBBTpNyQ8H1S2XtHagU90TSjyO1F
	 Rfp5Ar6eV39M5/QAVjOPyxKhRgbDaCDbWndyu7hLfVmccKkFvt+ShGuG6f4p6SkZA3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4YIbFZa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D28606A325;
	Wed, 18 Nov 2026 19:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4YIbFZa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBC21F000C4;
	Wed, 18 Nov 2026 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028640;
	bh=IPFYi522xuTwkfBxTCbVlbITXLPgUcAMprU2aTwUeqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4YIbFZafuGXJKeD6K0ca0nRWDLLFtmRcn9BGUSuZt1hOzYBmFYwUf6hx/o47KUlP
	 yx0vFQ1aLei3uEMbjGWBrQNzrpK1XD+mHofrpzcxSQMnhQ+hCGdovGJlAFINr2NyZY
	 SoAyt67yMbmb1V6tpdNwWTvq9bSSJn44eyj31Rmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0024/1756] hwmon: chipcap2: fix IRQ teardown ordering
Date: Wed, 18 Nov 2026 15:35:51 +0100
Message-ID: <20261118150008.857306968@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d2a66c515d7730fd453485ffb306c412f1f46d72 ]

The threaded IRQs are currently requested before the hwmon device
is registered. Since devres releases resources in reverse order,
the hwmon device is unregistered before the IRQs are freed during
driver teardown. An IRQ may therefore still run after the hwmon
device has been released and access the stale data->hwmon pointer.

Separate IRQ discovery from IRQ registration so that the IRQ numbers
and alarm visibility flags are initialized before registering the
hwmon device while the IRQs are released before the hwmon device
during devres cleanup.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-5-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

The label-property access is omitted because the driver has no label
support. Reuse the two existing IRQ helpers for discovery and data-ready
registration, and request alarm IRQs directly in probe after registering
hwmon. This preserves the teardown ordering without adding a helper.

Stable-dep-of: 4724ac5556ce ("hwmon: chipcap2: disable device after hwmon teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 79 ++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 46a3e22f43ade..0f7711ca6feb7 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -663,58 +663,39 @@ static int cc2_write(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 	return ret;
 }
 
-static int cc2_request_ready_irq(struct cc2_data *data, struct device *dev)
+static int cc2_get_irqs(struct cc2_data *data, struct device *dev)
 {
-	int ret = 0;
-
 	data->irq_ready = fwnode_irq_get_byname(dev_fwnode(dev), "ready");
 	if (data->irq_ready == -EPROBE_DEFER)
 		return data->irq_ready;
-	if (data->irq_ready > 0) {
+	if (data->irq_ready > 0)
 		init_completion(&data->complete);
-		ret = devm_request_threaded_irq(dev, data->irq_ready, NULL,
-						cc2_ready_interrupt,
-						IRQF_ONESHOT |
-						IRQF_TRIGGER_RISING,
-						dev_name(dev), data);
-	}
-
-	return ret;
-}
-
-static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
-{
-	int ret = 0;
 
 	data->irq_low = fwnode_irq_get_byname(dev_fwnode(dev), "low");
 	if (data->irq_low == -EPROBE_DEFER)
 		return data->irq_low;
-	if (data->irq_low > 0) {
-		ret = devm_request_threaded_irq(dev, data->irq_low, NULL,
-						cc2_low_interrupt,
-						IRQF_ONESHOT |
-						IRQF_TRIGGER_RISING,
-						dev_name(dev), data);
-		if (ret)
-			return ret;
-
+	if (data->irq_low > 0)
 		data->rh_alarm.low_alarm_visible = true;
-	}
 
 	data->irq_high = fwnode_irq_get_byname(dev_fwnode(dev), "high");
 	if (data->irq_high == -EPROBE_DEFER)
 		return data->irq_high;
-	if (data->irq_high > 0) {
-		ret = devm_request_threaded_irq(dev, data->irq_high, NULL,
-						cc2_high_interrupt,
+	if (data->irq_high > 0)
+		data->rh_alarm.high_alarm_visible = true;
+
+	return 0;
+}
+
+static int cc2_request_data_ready(struct cc2_data *data, struct device *dev)
+{
+	int ret = 0;
+
+	if (data->irq_ready > 0)
+		ret = devm_request_threaded_irq(dev, data->irq_ready, NULL,
+						cc2_ready_interrupt,
 						IRQF_ONESHOT |
 						IRQF_TRIGGER_RISING,
 						dev_name(dev), data);
-		if (ret)
-			return ret;
-
-		data->rh_alarm.high_alarm_visible = true;
-	}
 
 	return ret;
 }
@@ -762,13 +743,13 @@ static int cc2_probe(struct i2c_client *client)
 		return dev_err_probe(dev, PTR_ERR(data->regulator),
 				     "Failed to get regulator\n");
 
-	ret = cc2_request_ready_irq(data, dev);
+	ret = cc2_get_irqs(data, dev);
 	if (ret)
-		return dev_err_probe(dev, ret, "Failed to request ready irq\n");
+		return dev_err_probe(dev, ret, "Failed to get IRQs\n");
 
-	ret = cc2_request_alarm_irqs(data, dev);
+	ret = cc2_request_data_ready(data, dev);
 	if (ret)
-		return dev_err_probe(dev, ret, "Failed to request alarm irqs\n");
+		return dev_err_probe(dev, ret, "Failed to request ready irq\n");
 
 	data->hwmon = devm_hwmon_device_register_with_info(dev, client->name,
 							   data, &cc2_chip_info,
@@ -777,6 +758,26 @@ static int cc2_probe(struct i2c_client *client)
 		return dev_err_probe(dev, PTR_ERR(data->hwmon),
 				     "Failed to register hwmon device\n");
 
+	if (data->irq_low > 0) {
+		ret = devm_request_threaded_irq(dev, data->irq_low, NULL,
+						cc2_low_interrupt,
+						IRQF_ONESHOT |
+						IRQF_TRIGGER_RISING,
+						dev_name(dev), data);
+		if (ret)
+			return dev_err_probe(dev, ret, "Failed to request alarm irqs\n");
+	}
+
+	if (data->irq_high > 0) {
+		ret = devm_request_threaded_irq(dev, data->irq_high, NULL,
+						cc2_high_interrupt,
+						IRQF_ONESHOT |
+						IRQF_TRIGGER_RISING,
+						dev_name(dev), data);
+		if (ret)
+			return dev_err_probe(dev, ret, "Failed to request alarm irqs\n");
+	}
+
 	return 0;
 }
 
-- 
2.53.0



