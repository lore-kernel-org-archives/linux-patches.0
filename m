Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673971EA91;
	Tue, 27 May 2025 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364956; cv=none; b=S/isbkC3/ROorI4oA8DlQwFrOAuiQmiIjtkkx6bvC/L4hMaS7KkgQTkw6MVEb45lu7XDcU1XS2Y206NdETv2C6RGFl9OnapKQSie56W4Lyr8xkwZzOBQPh2cSkb4q2po83AliBFlBw3NzNY3UtB8UdauOeUsDr/FhKdfqqAicxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364956; c=relaxed/simple;
	bh=oPuFYCLND9ZixtKK42c1Dgr6sYfVtuguaecbmkOOTA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlnowQe9t2fqIWN2gL48IiXdcEweM870SpZ7XzYa0KqpUsdmQ9oCRmFv/WHcuq/wRLAJCdtoUNdU3tVeUKmYaOQ/gC8nBMzbzwT/Ufj76DxcDcbtJUrirPVKqwHG7Guw8sqjaP/33iNd60h0qCdgUeTXtQStHDUKe6+YTCw2cFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KejJHsQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KejJHsQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA638C4CEE9;
	Tue, 27 May 2025 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364956;
	bh=oPuFYCLND9ZixtKK42c1Dgr6sYfVtuguaecbmkOOTA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KejJHsQK/GK1/lCfcrF+vL07nqzLeNqxrLsyZ0nJ3cnUmCYhsf2GTRRMCH8seApzH
	 lVgm/OUajchVsYom8/hzKJ/58Rwo1gjtsmw0tmNE2tmcayipzSGdnfhy99IB3VpPqJ
	 p9CJlzX9HJTI8nOvLTDn0pLtERkVgSo9ajbiSKxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/626] soc: samsung: include linux/array_size.h where needed
Date: Tue, 27 May 2025 18:21:54 +0200
Message-ID: <20250527162453.998502407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4c57930f68d90e0d52c396d058cfa9ed8447a6c4 ]

This does not necessarily get included through asm/io.h:

drivers/soc/samsung/exynos3250-pmu.c:120:18: error: use of undeclared identifier 'ARRAY_SIZE'
  120 |         for (i = 0; i < ARRAY_SIZE(exynos3250_list_feed); i++) {
      |                         ^
drivers/soc/samsung/exynos5250-pmu.c:162:18: error: use of undeclared identifier 'ARRAY_SIZE'
  162 |         for (i = 0; i < ARRAY_SIZE(exynos5_list_both_cnt_feed); i++) {
      |                         ^

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20250305211446.43772-1-arnd@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/samsung/exynos-asv.c     | 1 +
 drivers/soc/samsung/exynos-chipid.c  | 1 +
 drivers/soc/samsung/exynos-pmu.c     | 1 +
 drivers/soc/samsung/exynos-usi.c     | 1 +
 drivers/soc/samsung/exynos3250-pmu.c | 1 +
 drivers/soc/samsung/exynos5250-pmu.c | 1 +
 drivers/soc/samsung/exynos5420-pmu.c | 1 +
 7 files changed, 7 insertions(+)

diff --git a/drivers/soc/samsung/exynos-asv.c b/drivers/soc/samsung/exynos-asv.c
index 97006cc3b9461..8e681f5195264 100644
--- a/drivers/soc/samsung/exynos-asv.c
+++ b/drivers/soc/samsung/exynos-asv.c
@@ -9,6 +9,7 @@
  * Samsung Exynos SoC Adaptive Supply Voltage support
  */
 
+#include <linux/array_size.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/energy_model.h>
diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
index bba8d86ae1bb0..dedfe6d0fb3f3 100644
--- a/drivers/soc/samsung/exynos-chipid.c
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -12,6 +12,7 @@
  * Samsung Exynos SoC Adaptive Supply Voltage and Chip ID support
  */
 
+#include <linux/array_size.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/mfd/syscon.h>
diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index dd5256e5aae1a..c40313886a012 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -5,6 +5,7 @@
 //
 // Exynos - CPU PMU(Power Management Unit) support
 
+#include <linux/array_size.h>
 #include <linux/arm-smccc.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
diff --git a/drivers/soc/samsung/exynos-usi.c b/drivers/soc/samsung/exynos-usi.c
index 114352695ac2b..5a93a68dba87f 100644
--- a/drivers/soc/samsung/exynos-usi.c
+++ b/drivers/soc/samsung/exynos-usi.c
@@ -6,6 +6,7 @@
  * Samsung Exynos USI driver (Universal Serial Interface).
  */
 
+#include <linux/array_size.h>
 #include <linux/clk.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
diff --git a/drivers/soc/samsung/exynos3250-pmu.c b/drivers/soc/samsung/exynos3250-pmu.c
index 30f230ed1769c..4bad12a995422 100644
--- a/drivers/soc/samsung/exynos3250-pmu.c
+++ b/drivers/soc/samsung/exynos3250-pmu.c
@@ -5,6 +5,7 @@
 //
 // Exynos3250 - CPU PMU (Power Management Unit) support
 
+#include <linux/array_size.h>
 #include <linux/soc/samsung/exynos-regs-pmu.h>
 #include <linux/soc/samsung/exynos-pmu.h>
 
diff --git a/drivers/soc/samsung/exynos5250-pmu.c b/drivers/soc/samsung/exynos5250-pmu.c
index 7a2d50be6b4ac..2ae5c3e1b07a3 100644
--- a/drivers/soc/samsung/exynos5250-pmu.c
+++ b/drivers/soc/samsung/exynos5250-pmu.c
@@ -5,6 +5,7 @@
 //
 // Exynos5250 - CPU PMU (Power Management Unit) support
 
+#include <linux/array_size.h>
 #include <linux/soc/samsung/exynos-regs-pmu.h>
 #include <linux/soc/samsung/exynos-pmu.h>
 
diff --git a/drivers/soc/samsung/exynos5420-pmu.c b/drivers/soc/samsung/exynos5420-pmu.c
index 6fedcd78cb451..58a2209795f78 100644
--- a/drivers/soc/samsung/exynos5420-pmu.c
+++ b/drivers/soc/samsung/exynos5420-pmu.c
@@ -5,6 +5,7 @@
 //
 // Exynos5420 - CPU PMU (Power Management Unit) support
 
+#include <linux/array_size.h>
 #include <linux/pm.h>
 #include <linux/soc/samsung/exynos-regs-pmu.h>
 #include <linux/soc/samsung/exynos-pmu.h>
-- 
2.39.5



