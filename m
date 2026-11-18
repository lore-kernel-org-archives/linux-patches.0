Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047020;
	b=KgxOUwInQlJ9OqlLtbzj9wScDhP5cjqZj8Vt7PDQoKCBzS8GmY1kxdyGqcECXTVG4iAj
	 avkqjt9rVKKIKmCSd6zL2rIEvMTn1J/5IuyzgXlpUZgPgZctzyxeTvsdrGDHOtwjDPTZ1
	 JfPLkB+E0CnC/eVgJJgQwtV4YtRIpFRS//GJbUhZHTfIIcZgSi3T+2QJW/fpZirMrqkDu
	 i/4xQlvHQv/c6bL6fmZUZQsWSB4j4qBBbpBEcaBFnJ1IJ+l6ih5gzAxQiIjY7dxPZFFt2
	 MEx7knpe4rerNYEDhSQMr9smyupHT5TfJ2qKOzyOcnm+S9RImFth5HGi2ZhRv6ihamw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pUQLOHW4igvO2cJfF8G31rXlfOvbNXbJ8GuMFlR85w0=;
	b=1QPCRGqofYNblI6SLxH1EEudth77XDmZ4ReBVvwyTdfav9QHWnDgkXq5vdcEi1AvPLPN
	 zcikTEJlA9aqkc9++WoAKy+JloW9C2oK63hx6rPHd/nUQyv8QqBz0XDZ6PN++JqrR8scv
	 5tGFDcOFfc+xvWu7+KCClnyQ0CW1nfj1CoxtXXoNyqORYDqyWKF93SbOiXVlMniCsVzc7
	 8rWLFqo+pUGjrBUtd0bpeMMLS09mMwpI0mQ9fC7tRwfEDHD4765Yo8yNbCY5DUNlMvjR/
	 Ybk/Og4y88OIYmWa64kmH7i3rsoOi3UJqiggPLIo5jPo5StI6tQECN5Mv1z2V7qKWyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FjvcHzNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA52F60A5BCC;
	Thu, 19 Nov 2026 00:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FjvcHzNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7A21F000C6;
	Thu, 19 Nov 2026 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047020;
	bh=pUQLOHW4igvO2cJfF8G31rXlfOvbNXbJ8GuMFlR85w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FjvcHzNdO/WS0iNgUQG+8yuORT4x+p9fUWdQXn3XZLmIv+0htbgDn1ZFqODt6tvb+
	 8AEgX8/NaEql+Mya264ZkIBzCKVcLzYCdS5y/eFliBxJZfW7aGUw2x0f7vkDLUrsEP
	 yLdRF58SL862+A+Efi6iaSNGT/Y7D3FSfqSQ1k8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1489/2857] leds: ktd2692: Pass context to regulator cleanup
Date: Wed, 18 Nov 2026 15:42:03 +0100
Message-ID: <20261118150254.933368327@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit c73e9f04445f361d5f19ca2edfde742ce18348ef ]

regulator_disable_action() retrieves the driver context from device
driver data.  However, ktd2692_parse_dt() registers the action before
ktd2692_probe() stores the context with platform_set_drvdata().

If devm_add_action_or_reset() cannot allocate the action, it invokes the
callback immediately.  A later probe failure also invokes it during
managed-resource unwinding.  Both paths dereference a NULL context.

Pass the already allocated context directly to the action and retain the
device pointer in it for error reporting.  The context is allocated before
the action is registered, so reverse-order devres unwinding keeps it alive
through the callback.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: ee78b9360e14 ("leds: ktd2692: Fix an error handling path")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260910194525.99654-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
[ sashal: adjusted context to account for missing ExpressWire properties and timing initialization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-ktd2692.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/flash/leds-ktd2692.c b/drivers/leds/flash/leds-ktd2692.c
index 670f3bf2e9062..b54220658f969 100644
--- a/drivers/leds/flash/leds-ktd2692.c
+++ b/drivers/leds/flash/leds-ktd2692.c
@@ -72,6 +72,8 @@ struct ktd2692_led_config_data {
 };
 
 struct ktd2692_context {
+	struct device *dev;
+
 	/* Related LED Flash class device */
 	struct led_classdev_flash fled_cdev;
 
@@ -258,13 +260,12 @@ static void ktd2692_setup(struct ktd2692_context *led)
 
 static void regulator_disable_action(void *_data)
 {
-	struct device *dev = _data;
-	struct ktd2692_context *led = dev_get_drvdata(dev);
+	struct ktd2692_context *led = _data;
 	int ret;
 
 	ret = regulator_disable(led->regulator);
 	if (ret)
-		dev_err(dev, "Failed to disable supply: %d\n", ret);
+		dev_err(led->dev, "Failed to disable supply: %d\n", ret);
 }
 
 static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
@@ -296,7 +297,7 @@ static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 			dev_err(dev, "Failed to enable supply: %d\n", ret);
 		} else {
 			ret = devm_add_action_or_reset(dev,
-						regulator_disable_action, dev);
+						regulator_disable_action, led);
 			if (ret)
 				return ret;
 		}
@@ -354,6 +355,7 @@ static int ktd2692_probe(struct platform_device *pdev)
 	if (!led)
 		return -ENOMEM;
 
+	led->dev = &pdev->dev;
 	fled_cdev = &led->fled_cdev;
 	led_cdev = &fled_cdev->led_cdev;
 
-- 
2.53.0



