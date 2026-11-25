Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620045;
	b=x08tfoQXW788piX2n3y+ElsidrQ7NrbOM8nec8U0xSwDzbv3Odj5P9rxjLgHluDIW+9F
	 USj6tHqx4ImbqUkZScQMfCw6UGVB31YXHKG738waKs3wcfi2CQF3JSkKACtEpxvzYntVA
	 KYZ2MfqxhIhZ4W5NRNH+W9of5c3g7W9Rp0nD3/1VHGYvM9n0rg5zOWzCu8etqFLmsfwen
	 YrdxOSi2K1GX5YXlOx/+M3HwrzbWOFySFFhUZa9I84SipD4nedmJZcjcue85bGcJEBPnB
	 uM/5Pu+3/2ZUy/syJY7YenQAGfy0rXN5nb8jFSSqRNbgfHP9UHqTHVj2nlMkbXMDfIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HekE7XQ3aS0Nyfd3HReeUoX1jpTtK7oUppHZOeZ7Fa4=;
	b=Jninn4XdWtMuKwfQlm/WDt2z6hXL5iDE2ZXRpcFl6oGiin9snJ8M8A5QBVc1GJtbi+aP
	 JbYCAxsUU0/CjQrESiYa0vwuAgXqOlV15EiSo9Gv6r0bBb2ePigYmCr0h0NYzzdJ98MW5
	 /6qpIF+fG+BVwGzcTtvdvkC+95HeERJKk5bHjL2ggQH1kJcor1sEMFkftdhbT0o5Xi99o
	 VOaXPxAyodYG/SxL+R0LPtK9ydSe/kbyYJHLIXBa9bCoIUx2aQGyh/Zb5Yu0mburL4OKm
	 y6DKKF0hhEe/nJm11L4kwJHJCPcxYaYbYefBXc+mNeoNHB65IqntYy1Pf9pnGfkRcTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07hYwTzu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CAA606A31E;
	Wed, 25 Nov 2026 15:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07hYwTzu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745CC1F000CF;
	Wed, 25 Nov 2026 15:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620045;
	bh=HekE7XQ3aS0Nyfd3HReeUoX1jpTtK7oUppHZOeZ7Fa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07hYwTzuBTEWY0MgDCSgCJGB2VLodh5RM8bWSG7kkIdn4b84m7n73gitDGXCaHi0c
	 JQdxpIAcPHcYXAG4X4bNn8lzj6HJIp/J0sW/LVTwl9a2ESVcbA7AHHZx3GIBSuSQdM
	 KCAWz3HDV4n7mKe5y6jYWabCLoX4nvyBxMfLz8x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko@sashiko.dev>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0746/1005] hwmon: (gpio-fan) Fix runtime PM imbalance in probe and teardown
Date: Wed, 25 Nov 2026 15:34:44 +0100
Message-ID: <20261125143839.226377116@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

commit 221b565a3316b1ba3a9bcd1f61238440207b3e00 upstream.

In gpio_fan_probe(), gpio_fan_stop() is registered conditionally as a
devres action before runtime PM is initialized, while gpio_fan_stop()
unconditionally calls pm_runtime_disable(). This breaks runtime PM
disable_depth and usage_count invariants across several paths:

- On alarm-only devices without control GPIOs, gpio_fan_stop() is never
  registered, leaving pm_runtime_enable() unbalanced on unbind and
  triggering "Unbalanced pm_runtime_enable!" on subsequent binds.
- When control GPIOs are present and devm_add_action_or_reset(), hwmon
  registration, or fan_alarm_init() fails, gpio_fan_stop() runs before
  pm_runtime_enable(), incrementing disable_depth to 2 (leaving runtime
  PM permanently disabled on re-probe) and, if speed_index > 0,
  underflowing usage_count via pm_runtime_put_sync().
- If pm_runtime_resume_and_get() fails when speed_index > 0, it drops
  its reference while speed_index remains non-zero, causing
  gpio_fan_stop() to call pm_runtime_put_sync() and underflow
  usage_count.
- Registering the hwmon device before enabling runtime PM exposes sysfs
  attributes that can invoke set_fan_speed() before runtime PM state is
  initialized.

Initialize runtime PM upfront with pm_runtime_set_suspended() and
devm_pm_runtime_enable(), remove pm_runtime_disable() from
gpio_fan_stop(), and acquire the initial active runtime PM reference
before registering gpio_fan_stop() and the hwmon device.

Fixes: 0d01110e6356 ("hwmon: (gpio-fan) Add regulator support")
Reported-by: Sashiko <sashiko@sashiko.dev>
Link: https://sashiko.dev/#/bug/linux-349aa3ba-30c3-4c3c-b47e-f52839af2b8d
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/gpio-fan.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -531,8 +531,6 @@ static void gpio_fan_stop(void *data)
 	mutex_lock(&fan_data->lock);
 	set_fan_speed(data, 0);
 	mutex_unlock(&fan_data->lock);
-
-	pm_runtime_disable(fan_data->dev);
 }
 
 static int gpio_fan_probe(struct platform_device *pdev)
@@ -560,6 +558,11 @@ static int gpio_fan_probe(struct platfor
 		return dev_err_probe(dev, PTR_ERR(fan_data->supply),
 				     "Failed to get fan-supply");
 
+	pm_runtime_set_suspended(dev);
+	err = devm_pm_runtime_enable(dev);
+	if (err)
+		return err;
+
 	/* Configure control GPIOs if available. */
 	if (fan_data->gpios && fan_data->num_gpios > 0) {
 		if (!fan_data->speed || fan_data->num_speed <= 1)
@@ -567,6 +570,12 @@ static int gpio_fan_probe(struct platfor
 		err = fan_ctrl_init(fan_data);
 		if (err)
 			return err;
+		/* If current GPIO state is active, mark RPM as active as well */
+		if (fan_data->speed_index > 0) {
+			err = pm_runtime_resume_and_get(dev);
+			if (err)
+				return err;
+		}
 		err = devm_add_action_or_reset(dev, gpio_fan_stop, fan_data);
 		if (err)
 			return err;
@@ -587,17 +596,6 @@ static int gpio_fan_probe(struct platfor
 			return err;
 	}
 
-	pm_runtime_set_suspended(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-	/* If current GPIO state is active, mark RPM as active as well */
-	if (fan_data->speed_index > 0) {
-		int ret;
-
-		ret = pm_runtime_resume_and_get(&pdev->dev);
-		if (ret)
-			return ret;
-	}
-
 	/* Optional cooling device register for Device tree platforms */
 	fan_data->cdev = devm_thermal_of_child_cooling_device_register(dev, np,
 								       "gpio-fan",


