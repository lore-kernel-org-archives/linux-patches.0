Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054469;
	b=AIRxQQHYHwq8Swmwkzhc313LisZt8ghXt6rEDlyfINMkZXPdn2xBZh01dZbZsRwEWEYL
	 QP0cPhe63QHuNRTx1hc8be4UbdI7poi8JuK/71pZq62tkvfJkaBdgq4elT8XiMyZfYr4A
	 77pIl6J74asZNYetR+26ODT0jfR3p3mRBQPj1OzM3Zp8bNjNLA/PcD7cKxe0VjdmHKbsC
	 MNanFJOKRt/SrbNxFKMlzJfdhkg37IuNyPrEn/dUPFPwy3iUKhDnvs2y+EvV7bfVzZEE+
	 B1rD7sBFOo16Z7vw83H0NYRfql0nhhLUKl/7GgPGsCF0fddCKqeX1qJELducznYPNrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtR52GgyUXVBiCgbWWmyTmlMm33ffrXGUkhDAuCS3mk=;
	b=hDvpnLTz3ThstP4VdoZgTWjTGIWe1sFa54Dnc8MPkdEoh3HQ5m6WNxfgIzJf6vnuUeTN
	 kwdxliRvPuwo0Vd5Vg7RHNaj3NunQuGeYKfTdWrdgcu/Oo6Yq2deFEjkN5Qm0+GGEdpX0
	 ky2VKedE6A+7/1G2wy7ecA3EMb/uC+b2mtToTSP0JTp7HIWVTeo6oCin4Q/xlKjvBtVho
	 zJ3F1hltTCAHEVXG37uPlA/gbvD3T2qGX8EDkc1rJX/bF++RCD7bhcENAKaQlfZCmiuXh
	 UpbN+OsKKCBgbvcMNtj+ce8S1yHhKWwffjcfyKG2Akc/2wgQlvq5hgloHJWJD6ljNCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNaY6JD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E70606A31C;
	Thu, 19 Nov 2026 02:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNaY6JD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239AC1F000C4;
	Thu, 19 Nov 2026 02:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054469;
	bh=dtR52GgyUXVBiCgbWWmyTmlMm33ffrXGUkhDAuCS3mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNaY6JD+Fdui64DfTUI/31wPsKDYj5WzTmwDfA/9+PmW3Mp5po5Nt7xjl6WwIOet+
	 GG9A4Youtw+9GNiRyOQGVMYz4MgbVpmqSCg/BbhR/s58UEcfEJGoaZM7uEjeLQCj+u
	 HLemNG4z8kx/j25PvVFfkMZz9T6v1wqn7fJpYR+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1248/2214] hwmon: (sht15) Stop deferred work before releasing its resources
Date: Wed, 18 Nov 2026 15:48:44 +0100
Message-ID: <20261118150101.620363395@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 5eab1e7f7ed12893f3864fe46ffcd5a41a752d6a ]

The IRQ handler and regulator notifier can leave work pending after a
measurement or notification completes. Neither work item is drained before
its resources are released on removal or probe failure.

Disable read_work before freeing the IRQ, since the worker can re-enable
it. Use request_irq()/free_irq() for explicit teardown. Unregister the
regulator notifier before cancelling update_supply_work and disabling the
regulator. Apply the same ordering to probe failures.

Fixes: 251eb40f5ccd ("hwmon: sht15 humidity sensor driver")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20261024014044.27853-1-mhun512@gmail.com
[groeck: Dropped obsolete 'Assisted-by: tag]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: replaced disable_work_sync() with cancel_work_sync() plus IRQ disabling and a READ_ONCE()/WRITE_ONCE() state guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht15.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index ae4d14257a11d..a0f2f1a2beb87 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -31,6 +31,7 @@
 #include <linux/bitrev.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of.h>
+#include <linux/workqueue.h>
 
 /* Commands */
 #define SHT15_MEASURE_TEMP		0x03
@@ -804,7 +805,7 @@ static irqreturn_t sht15_interrupt_fired(int irq, void *d)
 	disable_irq_nosync(irq);
 	atomic_inc(&data->interrupt_handled);
 	/* Then schedule a reading work struct */
-	if (data->state != SHT15_READING_NOTHING)
+	if (READ_ONCE(data->state) != SHT15_READING_NOTHING)
 		schedule_work(&data->read_work);
 	return IRQ_HANDLED;
 }
@@ -976,11 +977,8 @@ static int sht15_probe(struct platform_device *pdev)
 		goto err_release_reg;
 	}
 
-	ret = devm_request_irq(&pdev->dev, gpiod_to_irq(data->data),
-			       sht15_interrupt_fired,
-			       IRQF_TRIGGER_FALLING,
-			       "sht15 data",
-			       data);
+	ret = request_irq(gpiod_to_irq(data->data), sht15_interrupt_fired,
+			  IRQF_TRIGGER_FALLING, "sht15 data", data);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to get irq for data line\n");
 		goto err_release_reg;
@@ -988,15 +986,15 @@ static int sht15_probe(struct platform_device *pdev)
 	disable_irq_nosync(gpiod_to_irq(data->data));
 	ret = sht15_connection_reset(data);
 	if (ret)
-		goto err_release_reg;
+		goto err_free_irq;
 	ret = sht15_soft_reset(data);
 	if (ret)
-		goto err_release_reg;
+		goto err_free_irq;
 
 	ret = sysfs_create_group(&pdev->dev.kobj, &sht15_attr_group);
 	if (ret) {
 		dev_err(&pdev->dev, "sysfs create failed\n");
-		goto err_release_reg;
+		goto err_free_irq;
 	}
 
 	data->hwmon_dev = hwmon_device_register(data->dev);
@@ -1009,9 +1007,15 @@ static int sht15_probe(struct platform_device *pdev)
 
 err_release_sysfs_group:
 	sysfs_remove_group(&pdev->dev.kobj, &sht15_attr_group);
+err_free_irq:
+	WRITE_ONCE(data->state, SHT15_READING_NOTHING);
+	disable_irq(gpiod_to_irq(data->data));
+	cancel_work_sync(&data->read_work);
+	free_irq(gpiod_to_irq(data->data), data);
 err_release_reg:
 	if (!IS_ERR(data->reg)) {
 		regulator_unregister_notifier(data->reg, &data->nb);
+		cancel_work_sync(&data->update_supply_work);
 		regulator_disable(data->reg);
 	}
 	return ret;
@@ -1025,12 +1029,18 @@ static int sht15_remove(struct platform_device *pdev)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &sht15_attr_group);
 
+	WRITE_ONCE(data->state, SHT15_READING_NOTHING);
+	disable_irq(gpiod_to_irq(data->data));
+	cancel_work_sync(&data->read_work);
+	free_irq(gpiod_to_irq(data->data), data);
+
 	ret = sht15_soft_reset(data);
 	if (ret)
 		dev_err(&pdev->dev, "Failed to reset device (%pe)\n", ERR_PTR(ret));
 
 	if (!IS_ERR(data->reg)) {
 		regulator_unregister_notifier(data->reg, &data->nb);
+		cancel_work_sync(&data->update_supply_work);
 		regulator_disable(data->reg);
 	}
 
-- 
2.53.0



