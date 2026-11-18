Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029779;
	b=XGzSR3hdtNhZ0kQvbCApgs9IJ0o543kPpINA7TxOQOTYmh0fMO+BdQSJBEf4OCmC/u05
	 20RQQH5Iy9/mBpSZv7rxI9LpbZn+4bLpF/bfn3p1SwJURinsUEYPesVDSMMrEGAYxzSfO
	 m+Sag4xR+rg1uHjy3kinA/tD0pV+PfHwPPe0mpXm7/j/yGOFq1stHqwkL9NSo30t1Ks7I
	 L+g6tmuCwl3MwqgfwsRt2SXrhwz7AmFpa0pLbWPo8y2XyGyUxOHhBpZlWxvIX0JEtEM/5
	 xYGqGiXwv8hd7v9qccX09h/3teo77ZY59MX1vLfoBpbrOYI6KFutULMl1qQ3EPbSzCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O6QvmDb7l/2hoBh1v/w6dySRrpYZSbTMWrhneObR0N8=;
	b=BpARRQO7Kr+0Jd6jGZdUfMrXo9YHvf35tRXhTy5W9APhCJtOwu0gyMRfSJtot2KIFSti
	 BZ6MsyujOwLrAX9Dl4Pkk1KObhPub+Jx0krAZsvByluUK/RRQbw8/Mb82Y9RPeOjrhsbg
	 Z/bxICbCKoyGDEchKdXAoJRWGfzZNPxCbs4UbAao7ljYqKANmApGDXh3p9d+hZJb2Lht9
	 bsfrbULxNhMphrUvi137V8h66nWj1kO32JYn13sPyTsy3eUnWQ1eai6q834unlJ5qTtB1
	 xFqkrP4pGQK/CMEyoEmOV2TJBqIhoEs2cquB9LcZ1g3lAJbi9qXR8S1ILF4zi2n+8CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qsjqCp/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378CD606A31C;
	Wed, 18 Nov 2026 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qsjqCp/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909D21F000C5;
	Wed, 18 Nov 2026 19:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029779;
	bh=O6QvmDb7l/2hoBh1v/w6dySRrpYZSbTMWrhneObR0N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qsjqCp/ur3x5E2RiR5zpDR8lqfCIyPHMKAFMzCqTgaxF8jjzvqsOaaO4BMN7JhTEp
	 yBu0JNt2ZvSSFXMRG9v9GWzGHUB8eqZAGnlhsnsxbxXWy82a6OMISJh18L29LEUWdt
	 UmhXoGEx162hFqNPR9IDRYWeOCLiCGNjY5x1XiTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Danieau <stephane.danieau@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0429/1756] pinctrl: stm32: Allow compile as module for stm32mp257
Date: Wed, 18 Nov 2026 15:42:36 +0100
Message-ID: <20261118150025.833887080@linuxfoundation.org>
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
index 6c6d11536b42e..ab77cc49b4ed7 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -308,7 +308,6 @@ config ARCH_STM32
 	bool "STMicroelectronics STM32 SoC Family"
 	select GPIOLIB
 	select PINCTRL
-	select PINCTRL_STM32MP257
 	select ARM_SMC_MBOX
 	select ARM_SCMI_PROTOCOL
 	select REGULATOR
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
index 05df641874a92..2219f31d14935 100644
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
@@ -1666,6 +1667,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	clk_bulk_disable_unprepare(banks, pctl->clks);
 	return ret;
 }
+EXPORT_SYMBOL(stm32_pctl_probe);
 
 static int __maybe_unused stm32_pinctrl_restore_gpio_regs(
 					struct stm32_pinctrl *pctl, u32 pin)
@@ -1738,6 +1740,7 @@ int __maybe_unused stm32_pinctrl_suspend(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(stm32_pinctrl_suspend);
 
 int __maybe_unused stm32_pinctrl_resume(struct device *dev)
 {
@@ -1754,3 +1757,8 @@ int __maybe_unused stm32_pinctrl_resume(struct device *dev)
 
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
index 23aebd4695e99..17cfea846dac0 100644
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
 	 SET_LATE_SYSTEM_SLEEP_PM_OPS(stm32_pinctrl_suspend, stm32_pinctrl_resume)
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



