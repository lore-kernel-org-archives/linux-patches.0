Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022483;
	b=3WE7+L5YLoTo05PbnV+h6gm95il+P331nLEIly5eRzWwR+wUnTKEaiwVr3aJ5glRhPlE
	 nK4KsGUvTCyjLZOsgQpjsKDYE/o0KMuzfr4aLOtZI7IKrpW9mlI65YhSXBou1T7lG5KeX
	 ZNpn5A2XfUU2TZtE5UIQ/bAP80jTl2HwuKLJLZRPlLhOYcyS7wWsMTuGl3Ux4TNLkf62l
	 eMTSGyKqXJnILdJdc3uHieoM0IPbNYLLb0VUi/D7ckGtsQCcpSJCePDNGqRZGCckIE75h
	 PB1SxItoU8NU8cXa5TpNbTp1x4L2F8wHEPY81cSRtjTZuxB2xzUqcPoE+PVO66IzwkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cHRGQcId369MUg/agCpG3yau2GULOcmj2iZFGJA1rc0=;
	b=2B8v5WaJV516BQBoCMCPfGIk0v8oH83F90MKMR5vsLtr/ZDWZcvC0PlLJBzYbe4404y/
	 QNHrYDdcn+5XhSpnARpR6FN/SXM8zUzhe0Tu1ELAl72EubpdF+7atlCGEgxORIu1IypxQ
	 9NDrjfa++QsEEr/kEBLv4zKPRtIH7thHa14MRdVx+VburaCVdtJJlO1WvCvF8LewBbB+s
	 ZlG+ViY4Dw7h1mChGkoXekhrOmbWSV2olK5yZp4GUA69eqPngZ7lEIK+mx671ETPY3zUJ
	 bOmI42c5mo0O0hVe6nEry4jBNntaAM+v4/ajnHgwlTUn02ND50VwHMUkYIcFjUbJsqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CsFDKFbf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FB5606A320;
	Wed, 18 Nov 2026 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CsFDKFbf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315791F000C4;
	Wed, 18 Nov 2026 17:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022483;
	bh=cHRGQcId369MUg/agCpG3yau2GULOcmj2iZFGJA1rc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsFDKFbfMlaGmbOm2cgwJWXroV+cJAFZ8Cdt75HCouRSkoitlV4jrI1H1cHWFXOR9
	 gNHmRdV250nrrxVGGdW5bdRJtzpkd4uO8ENOsSvTm9WMjQ5+8EP5K7NkKXb05XPsDn
	 HmZ94KeaYuu9+2cDQbOq5LHEX6SGRUCSecyTqd6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0029/2151] hwmon: chipcap2: fix IRQ teardown ordering
Date: Wed, 18 Nov 2026 15:29:24 +0100
Message-ID: <20261118150122.718404954@linuxfoundation.org>
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

Reuse the existing IRQ helpers for discovery and ready IRQ registration,
and request alarm IRQs directly from probe after hwmon registration. This
keeps the number of helper functions unchanged. Omit the unrelated label
property read because label support is absent.

Stable-dep-of: 4724ac5556ce ("hwmon: chipcap2: disable device after hwmon teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 69 ++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 5f4b0fd535af8..8ba706ecd4012 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -636,60 +636,41 @@ static int cc2_write(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 	}
 }
 
-static int cc2_request_ready_irq(struct cc2_data *data, struct device *dev)
+static int cc2_request_data_ready(struct cc2_data *data, struct device *dev)
 {
 	int ret = 0;
 
-	data->irq_ready = fwnode_irq_get_byname(dev_fwnode(dev), "ready");
-	if (data->irq_ready == -EPROBE_DEFER)
-		return data->irq_ready;
-	if (data->irq_ready > 0) {
-		init_completion(&data->complete);
+	if (data->irq_ready > 0)
 		ret = devm_request_threaded_irq(dev, data->irq_ready, NULL,
 						cc2_ready_interrupt,
 						IRQF_ONESHOT |
 						IRQF_TRIGGER_RISING,
 						dev_name(dev), data);
-	}
 
 	return ret;
 }
 
-static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
+static int cc2_get_irqs(struct cc2_data *data, struct device *dev)
 {
-	int ret = 0;
+	data->irq_ready = fwnode_irq_get_byname(dev_fwnode(dev), "ready");
+	if (data->irq_ready == -EPROBE_DEFER)
+		return data->irq_ready;
+	if (data->irq_ready > 0)
+		init_completion(&data->complete);
 
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
-						IRQF_ONESHOT |
-						IRQF_TRIGGER_RISING,
-						dev_name(dev), data);
-		if (ret)
-			return ret;
-
+	if (data->irq_high > 0)
 		data->rh_alarm.high_alarm_visible = true;
-	}
 
-	return ret;
+	return 0;
 }
 
 static const struct hwmon_channel_info *cc2_info[] = {
@@ -735,13 +716,13 @@ static int cc2_probe(struct i2c_client *client)
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
@@ -750,6 +731,26 @@ static int cc2_probe(struct i2c_client *client)
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



