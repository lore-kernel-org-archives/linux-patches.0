Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620721;
	b=CE4eh8DFfmHnvVT7phWgvZ2rk+gdTZxRjslQFgdDCT7f6sHwRuA8Z5kC4Dqq2bOarbMi
	 LpDSj85sO75u8EbyKJiGNdAEtWnvVfcnvoLo2Maqnth9x8cFpbXEnvwUk6YZ0qKpfKDjB
	 lV1NWiHeMKrVCPcsUplGp9V7U18qKeXY+p5S+qiB7FQx4EWfxBFtkEQCND2Y8urFwxqbe
	 0oVWXI/1owcEsJ+MaH2hSwmT79eJACKbX2aJm2tbD+1/aubKVnJHfrnAfTaAQ03izt4ag
	 hmSjizY5jzaqdxzG08WVudf4drQbaAq63ghnK/u538jQ3DntN6M2qu67MQDZtFRTdQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A+kz7u8HvHYC3jdbtcR1NJ3ejWUmobVm6K/ATUYdHdk=;
	b=s7uTjdPpWFBHSXiLsBuZIqyC46cGC7gJc/lDO4FApKLu8GVieowO0PHEXmJpUZqxYjWU
	 zlstnT1F8knvv6KgiDFcpWscZbcDPe7oQG36jPQS1LVdd0mTOHFyXJsELR4k/B81HAezU
	 wTpBXuS7TnzSEt0XoxcvGbLMaa1p8ZCkKGoTpRRe9ax+N8cLFIS3RZTOKekLdk1qEe0xJ
	 JnFrU/NYd843NE5A1htZJc/c0lphaGbmyA71qNCH8KVUkcyPg6s9fe602LHuybLKEo39G
	 3rQ+O8WsAJOIWmyka/+2URhnWYs6OjxoQXowQQn0bDNVVUbMSnnPnd0KMGkvcm7DlrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWNUExOn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366AE606A31E;
	Wed, 25 Nov 2026 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWNUExOn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5416C1F000C6;
	Wed, 25 Nov 2026 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620720;
	bh=A+kz7u8HvHYC3jdbtcR1NJ3ejWUmobVm6K/ATUYdHdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWNUExOnwzLmjaIOR4G9v6Izpq4+nb40iIveeNBsB9+ZXNbD7GDMllE0kurK5g7qh
	 KLvgaLyOnS0PZWc0I7Xiv/aRsRKK3Hc1LbqIhOYwyd7GweZ1UBo/gM5ieHZIRPteNG
	 YQnbfIzEnzHNCQ9x8KWiZ5jhRg/9eTYLWGcuK3c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0988/1005] iio: proximity: hx9023s: Allocate trigger before requesting IRQ
Date: Wed, 25 Nov 2026 15:38:46 +0100
Message-ID: <20261125143844.800489853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit bfa3b177d839bb303d0187335115b572a2644920 upstream.

An IRQ handler that already read trigger_enabled can poll data->trig
after buffer disable. Detaching the virtual IRQ does not join this
physical IRQ, and trigger deselection can drop the consumer reference.
Devres may then free the trigger before joining the handler.

Allocate the trigger before requesting the IRQ so devres joins the
handler before dropping the allocation reference.

This issue was identified as part of our ongoing research while
reviewing kernel code.

Fixes: 60df548277b7 ("iio: proximity: Add driver support for TYHX's HX9023S capacitive proximity sensor")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/hx9023s.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/iio/proximity/hx9023s.c
+++ b/drivers/iio/proximity/hx9023s.c
@@ -1133,14 +1133,6 @@ static int hx9023s_probe(struct i2c_clie
 		return dev_err_probe(dev, ret, "reg config failed\n");
 
 	if (client->irq) {
-		ret = devm_request_threaded_irq(dev, client->irq,
-						hx9023s_irq_handler,
-						hx9023s_irq_thread_handler,
-						IRQF_ONESHOT,
-						"hx9023s_event", indio_dev);
-		if (ret)
-			return ret;
-
 		data->trig = devm_iio_trigger_alloc(dev, "%s-dev%d",
 						    indio_dev->name,
 						    iio_device_id(indio_dev));
@@ -1150,6 +1142,14 @@ static int hx9023s_probe(struct i2c_clie
 		data->trig->ops = &hx9023s_trigger_ops;
 		iio_trigger_set_drvdata(data->trig, indio_dev);
 
+		ret = devm_request_threaded_irq(dev, client->irq,
+						hx9023s_irq_handler,
+						hx9023s_irq_thread_handler,
+						IRQF_ONESHOT,
+						"hx9023s_event", indio_dev);
+		if (ret)
+			return ret;
+
 		ret = devm_iio_trigger_register(dev, data->trig);
 		if (ret)
 			return dev_err_probe(dev, ret,


