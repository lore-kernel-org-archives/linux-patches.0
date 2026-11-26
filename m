Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705035;
	b=tVvghn54q0zpGw0i1QDX1zUiSZW93MAIsorjaFlA5loytyZ6MXgi1YxBGHmn/fcu0LlS
	 ZEG9LMyJG5HoyFgUel5e1icyTBX3Yof/S3P7Qp02jw1fBUlbAIqnH68FkpbQOvBfjREQG
	 IbKSU66tQCE/PW4hzOAwdH6UEi1drMUtRNeftAEWRgKj8NqMRO2z4GisUujwHqyM7X4rM
	 wNdlNxMt1zL/2IVswNfCy2jLRkr5gcwerGu2z2Ihx1LTvG0i6T8TAIcDZJjl+KmuYSwVp
	 a6Cg6r5NjVuSeb3Gx3uI/b+ExvRxGTdoufBByjAbnn5t+A2L1VjPPjUllNdB00sljRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MnUCH2LYkQ5QUltL5ezmAvrFjVJ+IKFgFoazVuwzHus=;
	b=Ov2whVQek58fYNRh18bCITtj4FBFoKbcc5ccsNp/Gk6XfxM8sCGuJvN9UPqjJGYhJ2y0
	 fYdwfy/JZ4HWeWHyu7NRR3mreaVCL2jjmGrG+H9EiBR1ZN/C/Vym5vP/vufOpQc5p7NTV
	 oydYDhwUlITNTtLowbVWQ9qbjQLCWCihUhb6UfD8q1kJ6chZoWbEJ7tkXBLZz0hLm8ZHZ
	 jlGpCtwewQdT3KYsE9e4+yTF7N1CuL/j+LO06IFWKR9oFREfEd2kM3Y5zpOGBzgCU2i+w
	 h5+/9JE2WblkvPDJj2YS62yMhbV5Xfi5zI6K2XSloapBqq5oDQLUpYO5l6rBTmaH5YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwaoBVx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379FB606A31C;
	Thu, 26 Nov 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwaoBVx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0591F000C6;
	Thu, 26 Nov 2026 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705034;
	bh=MnUCH2LYkQ5QUltL5ezmAvrFjVJ+IKFgFoazVuwzHus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwaoBVx4jSKNvXq0jVQJCWUOP8HuN1OWCrOje2LHPZHIyENkU6o98iQA2maVDGvHc
	 cgo7oXgJKT1YtggX5kMc6PR1HyB0TbrL4cLswHqy0IosjcJVhglT7ZQ0hKzi5kQW8+
	 7GoFINXXhZz89x3lIgeVWrWEC3Z8stf827hvRJu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martyn Welch <martyn.welch@collabora.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/319] gpio: mpc8xxx: Add wake on GPIO support
Date: Thu, 26 Nov 2026 15:37:08 +0100
Message-ID: <20261126144008.092108686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Martyn Welch <martyn.welch@collabora.com>

[ Upstream commit e9482dc50ab2cb81b7735180345c48ada87205a5 ]

The mpc8xxx GPIO can generate an interrupt on state change. This
interrupt can be used to wake up the device from its sleep state if
enabled to do so. Add required support to the driver so that the GPIO
can be used in this way.

In order for the GPIO to actually function in this way, it is necessary
to also set the GPIO bit in the RCPM. This can be done via the device
tree fsl,rcpm-wakeup property.

Signed-off-by: Martyn Welch <martyn.welch@collabora.com>
Link: https://lore.kernel.org/r/20240820143328.1987442-1-martyn.welch@collabora.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 9e4b35c95fed ("gpio: mpc8xxx: Fix potential use-after-free of IRQ domain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 625e70db22b9f..de8ff2057d70f 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -415,6 +415,8 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+	device_init_wakeup(&pdev->dev, true);
+
 	return 0;
 err:
 	irq_domain_remove(mpc8xxx_gc->irq);
@@ -431,6 +433,31 @@ static void mpc8xxx_remove(struct platform_device *pdev)
 	}
 }
 
+#ifdef CONFIG_PM
+static int mpc8xxx_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct mpc8xxx_gpio_chip *mpc8xxx_gc = platform_get_drvdata(pdev);
+
+	if (mpc8xxx_gc->irqn && device_may_wakeup(&pdev->dev))
+		enable_irq_wake(mpc8xxx_gc->irqn);
+
+	return 0;
+}
+
+static int mpc8xxx_resume(struct platform_device *pdev)
+{
+	struct mpc8xxx_gpio_chip *mpc8xxx_gc = platform_get_drvdata(pdev);
+
+	if (mpc8xxx_gc->irqn && device_may_wakeup(&pdev->dev))
+		disable_irq_wake(mpc8xxx_gc->irqn);
+
+	return 0;
+}
+#else
+#define mpc8xxx_suspend NULL
+#define mpc8xxx_resume NULL
+#endif
+
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id gpio_acpi_ids[] = {
 	{"NXP0031",},
@@ -442,6 +469,8 @@ MODULE_DEVICE_TABLE(acpi, gpio_acpi_ids);
 static struct platform_driver mpc8xxx_plat_driver = {
 	.probe		= mpc8xxx_probe,
 	.remove_new	= mpc8xxx_remove,
+	.suspend	= mpc8xxx_suspend,
+	.resume		= mpc8xxx_resume,
 	.driver		= {
 		.name = "gpio-mpc8xxx",
 		.of_match_table	= mpc8xxx_gpio_ids,
-- 
2.53.0



