Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039818;
	b=PYGtLLtU3lhk9e9K9n+ZM+XBUAKBADdcoyR5VxUTe5eiILMMplf6szusm2i0Yo4wmus2
	 e/wx4sp+Wd8jUKo2m2G/OpqrMNGu+Fa5V6CXkhcbUKio0dtAYZte8VDmlnYu4tSoPeV1X
	 DAxWqBhP1ZXXm6gJQDaS1OAacSyoozelX5EcdyB8uDJbAva3Hxnfn/NQk5giy9EB6roCg
	 Y5A4xMpngnCZ4b1lSXwjihEcYNgS93rgr0tLDqjkDQYCkj9uPHsOBoua2+8lAIPM7EH0X
	 X5+DQBeg3juBTsw6vZgbmx//u+/DKq+o8FcLQQB/PcAGaHPxZShvihmiSgfMTdXFPyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iNHZY2oGdt6iF28eBNNlh67X5zKgRz7x/OO3I4FTk7o=;
	b=mQxxEty+ws3OALGWVuTgCqKVhYX+MMZfQC8KYUT/BCntX/0MNs2X5Di1HysFmKmCjUIO
	 Cwufaz4W5Jw9gGXAMu/iGhTAYVoG5l1hKi4euCqhJQCJ9Sk3sVW2ffSXL0DqLBa+c9UUZ
	 1ItoPGb6lAgTRFTUfe11dwJdMHseEfYJDU6ZcJtjc/EG1VdEiU2LhlIkBBIPXukVYVR7u
	 bFSsSpB/0E6Kq0dCh42NZXNIXoFRgQm53Nv27pAKt+XnYdoRvGgAj98Fs//xl2YW9hGWb
	 2J6/qpybq+kIWIDi02n7YdloQXkISeuiCIVtzsZK2M/fQdqpouUbvVJvIFBq5xZ5DuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCCXqM75;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F4E606A32C;
	Wed, 18 Nov 2026 22:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCCXqM75
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604A81F000C5;
	Wed, 18 Nov 2026 22:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039817;
	bh=iNHZY2oGdt6iF28eBNNlh67X5zKgRz7x/OO3I4FTk7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCCXqM75kHRoRzEWvpIDz+SgJl/edBsdbw3LGOvNXdN59lM8pfX7kl4//0u8GKVxh
	 FTxHInvQkEMew07L+uQdmUvQ7Ge73e+fv0ZW5oQOe+z7iJYuUcs91L3eEgFl1U9VWA
	 m7UJivoGYGavTGDPW+MnOlyAaqAqLP3dxUF8J/bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Danieau <stephane.danieau@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2237/3318] pinctrl: stm32: Allow compile as module for stm32mp257
Date: Wed, 18 Nov 2026 15:47:39 +0100
Message-ID: <20261118150428.971621813@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Danieau <stephane.danieau@foss.st.com>

[ Upstream commit dba0aff2b89bd106601ed88dfda44fdd3218eb53 ]

Add ability to build pinctrl for stm32mp257 as a kernel module.
Add kernel-doc to the exported symbols.

Signed-off-by: Stephane Danieau <stephane.danieau@foss.st.com>
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Link: https://lore.kernel.org/20250610143042.295376-5-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 01f20711d044 ("pinctrl: stm32: Drop the nonexistent CONFIG_MACH_STM32MP25 from the STM32MP257 default")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig.platforms               |  1 -
 drivers/pinctrl/stm32/Kconfig              |  6 +++---
 drivers/pinctrl/stm32/pinctrl-stm32.c      |  8 ++++++++
 drivers/pinctrl/stm32/pinctrl-stm32.h      | 14 ++++++++++++++
 drivers/pinctrl/stm32/pinctrl-stm32mp257.c | 11 ++++++-----
 5 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index 6069120199bbc..d78bbab73b5cf 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -289,7 +289,6 @@ config ARCH_STM32
 	bool "STMicroelectronics STM32 SoC Family"
 	select GPIOLIB
 	select PINCTRL
-	select PINCTRL_STM32MP257
 	select ARM_SMC_MBOX
 	select ARM_SCMI_PROTOCOL
 	select COMMON_CLK_SCMI
diff --git a/drivers/pinctrl/stm32/Kconfig b/drivers/pinctrl/stm32/Kconfig
index 2656d3d3ae402..297a2f088bc1f 100644
--- a/drivers/pinctrl/stm32/Kconfig
+++ b/drivers/pinctrl/stm32/Kconfig
@@ -2,7 +2,7 @@
 if ARCH_STM32 || COMPILE_TEST
 
 config PINCTRL_STM32
-	bool
+	tristate
 	depends on OF
 	select PINMUX
 	select GENERIC_PINCONF
@@ -53,8 +53,8 @@ config PINCTRL_STM32MP157
 	select PINCTRL_STM32
 
 config PINCTRL_STM32MP257
-	bool "STMicroelectronics STM32MP257 pin control" if COMPILE_TEST && !MACH_STM32MP25
+	tristate "STMicroelectronics STM32MP257 pin control"
 	depends on OF && HAS_IOMEM
-	default MACH_STM32MP25
+	default MACH_STM32MP25 || (ARCH_STM32 && ARM64)
 	select PINCTRL_STM32
 endif
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index df7003ff10123..a8fbdcf640f69 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -7,6 +7,7 @@
  * Heavily based on Mediatek's pinctrl driver
  */
 #include <linux/clk.h>
+#include <linux/export.h>
 #include <linux/gpio/driver.h>
 #include <linux/hwspinlock.h>
 #include <linux/io.h>
@@ -1679,6 +1680,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	clk_bulk_disable_unprepare(banks, pctl->clks);
 	return ret;
 }
+EXPORT_SYMBOL(stm32_pctl_probe);
 
 static int __maybe_unused stm32_pinctrl_restore_gpio_regs(
 					struct stm32_pinctrl *pctl, u32 pin)
@@ -1751,6 +1753,7 @@ int __maybe_unused stm32_pinctrl_suspend(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(stm32_pinctrl_suspend);
 
 int __maybe_unused stm32_pinctrl_resume(struct device *dev)
 {
@@ -1767,3 +1770,8 @@ int __maybe_unused stm32_pinctrl_resume(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(stm32_pinctrl_resume);
+
+MODULE_AUTHOR("Alexandre Torgue <alexandre.torgue@foss.st.com>");
+MODULE_DESCRIPTION("STM32 core pinctrl driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.h b/drivers/pinctrl/stm32/pinctrl-stm32.h
index 8790fef2d58a2..170ccdde0796a 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.h
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.h
@@ -65,8 +65,22 @@ struct stm32_pinctrl_match_data {
 	bool secure_control;
 };
 
+/**
+ * stm32_pctl_probe() - Common probe for stm32 pinctrl drivers.
+ * @pdev: Pinctrl platform device.
+ */
 int stm32_pctl_probe(struct platform_device *pdev);
+
+/**
+ * stm32_pinctrl_suspend() - Common suspend for stm32 pinctrl drivers.
+ * @dev: Pinctrl device.
+ */
 int stm32_pinctrl_suspend(struct device *dev);
+
+/**
+ * stm32_pinctrl_resume() - Common resume for stm32 pinctrl drivers.
+ * @dev: Pinctrl device.
+ */
 int stm32_pinctrl_resume(struct device *dev);
 
 #endif /* __PINCTRL_STM32_H */
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32mp257.c b/drivers/pinctrl/stm32/pinctrl-stm32mp257.c
index 73f091cd827e6..de16165e69f6c 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32mp257.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32mp257.c
@@ -4,6 +4,7 @@
  * Author: Alexandre Torgue <alexandre.torgue@foss.st.com> for STMicroelectronics.
  */
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
@@ -2560,6 +2561,7 @@ static const struct of_device_id stm32mp257_pctrl_match[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(of, stm32mp257_pctrl_match);
 
 static const struct dev_pm_ops stm32_pinctrl_dev_pm_ops = {
 	 SET_LATE_SYSTEM_SLEEP_PM_OPS(NULL, stm32_pinctrl_resume)
@@ -2573,9 +2575,8 @@ static struct platform_driver stm32mp257_pinctrl_driver = {
 		.pm = &stm32_pinctrl_dev_pm_ops,
 	},
 };
+module_platform_driver(stm32mp257_pinctrl_driver);
 
-static int __init stm32mp257_pinctrl_init(void)
-{
-	return platform_driver_register(&stm32mp257_pinctrl_driver);
-}
-arch_initcall(stm32mp257_pinctrl_init);
+MODULE_AUTHOR("Alexandre Torgue <alexandre.torgue@foss.st.com>");
+MODULE_DESCRIPTION("STM32MP257 pinctrl driver");
+MODULE_LICENSE("GPL");
-- 
2.53.0



