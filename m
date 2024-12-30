Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCBD15E8B;
	Mon, 30 Dec 2024 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574144; cv=none; b=W23xmvDKx6WwILbXmPROSuhyFrO1zSnDv6bmDvhlgvxPImQ9DNNeDNRuCFLL9n0IdNI0YDGgkfbSNmioCsEaUhXybQglDSICVEI2CGufxP/12+7vlnUXKkckpcz+56dqcrSLYkgAdojLJqanBYK31uIB1nS6t4+nFlEbcSC1mTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574144; c=relaxed/simple;
	bh=RGjpyRQKth7Rh533OVVtiJ1HRNMP0/a+IV2fvfDqeBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmSU6a3D6Ko5+ZIrqAq/Q/nCqnzh3aGqv/r3Fs3qtWLY8tuigAd3KP7xyJzlS6HVwK0ggI5hjUk41CLBPiFzfufGSVcTzhmFb2UaEGb/nAVixVU3RrxRb/hKxms+G1mezLPaLZAALgXdlXdrNK7Ocng0Knjj7llacJnGnbA5jyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uu/O8A0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uu/O8A0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8074CC4CED0;
	Mon, 30 Dec 2024 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574144;
	bh=RGjpyRQKth7Rh533OVVtiJ1HRNMP0/a+IV2fvfDqeBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uu/O8A0avRBHMbVZt1yrqU0xlU1AEx0KGQ1/X0XkRuAhxawT9nTihMzyePYRwzI2h
	 ZV8GO3Rs+BE7KnsFqNpMYtyKxAvyOiLhTD+0ff4b4ENtHCKhlnqhgUZxoLw5etC5f5
	 U3ufDlZVNeLj1bfDMbYXc81pMkz0cM3JIcoaUk80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/114] Revert "watchdog: s3c2410_wdt: use exynos_get_pmu_regmap_by_phandle() for PMU regs"
Date: Mon, 30 Dec 2024 16:42:45 +0100
Message-ID: <20241230154219.906501103@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit ccfb765944bb66813398958983cb8141e2624a6b ]

This reverts commit 746f0770f916e6c48e422d6a34e67eae16707f0e.

Now that we can register a SoC specific regmap with syscon using
of_syscon_register_regmap() api we can switch back to using
syscon_regmap_lookup_by_phandle() in the client drivers.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20241029191131.2329414-1-peter.griffin@linaro.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig       | 1 +
 drivers/watchdog/s3c2410_wdt.c | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 94c96bcfefe3..0b59c669c26d 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -549,6 +549,7 @@ config S3C2410_WATCHDOG
 	tristate "S3C6410/S5Pv210/Exynos Watchdog"
 	depends on ARCH_S3C64XX || ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	select WATCHDOG_CORE
+	select MFD_SYSCON if ARCH_EXYNOS
 	help
 	  Watchdog timer block in the Samsung S3C64xx, S5Pv210 and Exynos
 	  SoCs. This will reboot the system when the timer expires with
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 686cf544d0ae..349d30462c8c 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -24,9 +24,9 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <linux/delay.h>
-#include <linux/soc/samsung/exynos-pmu.h>
 
 #define S3C2410_WTCON		0x00
 #define S3C2410_WTDAT		0x04
@@ -699,11 +699,11 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		return ret;
 
 	if (wdt->drv_data->quirks & QUIRKS_HAVE_PMUREG) {
-		wdt->pmureg = exynos_get_pmu_regmap_by_phandle(dev->of_node,
-						 "samsung,syscon-phandle");
+		wdt->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
+						"samsung,syscon-phandle");
 		if (IS_ERR(wdt->pmureg))
 			return dev_err_probe(dev, PTR_ERR(wdt->pmureg),
-					     "PMU regmap lookup failed.\n");
+					     "syscon regmap lookup failed.\n");
 	}
 
 	wdt_irq = platform_get_irq(pdev, 0);
-- 
2.39.5



