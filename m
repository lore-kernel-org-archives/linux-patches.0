Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAE32D94A7;
	Thu, 15 Jan 2026 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498987; cv=none; b=ac7ekNav2yXeigc9LNWkLhprU+eKkwO0ckh0vE8Wx7DVTLIjoJ4bZRkHgnMKKUtQTAvuvpiHU20W2Ixh/WxixuRRLqq6KE/jpgDeN6W4J9+9vkMbFowvndRSs8mAiJcu87HLXU9VckFJ1OIW8uNDt2S2MwuLuFQ6gbo1XmU8ItE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498987; c=relaxed/simple;
	bh=mcqkFsg/RX4IlVqbwKDYg37Gilagk3tdvNEz3n2gbV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMqv89WWEbZDQptj4mM4TYGo5k8+xsauNVVLiwOHTpPuA987kX3WNqgfjM8mgklYpiXAxMG92Je9H7VsezpC3L+HPTFXIEl0LjknbjTs6NHhwei4JvGxbKO998Myq0MEClAIfRj9rCyj6+hw1JhrZ1stYYLnMYSEnaKFGQo+kLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+RuOjws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+RuOjws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B1FC116D0;
	Thu, 15 Jan 2026 17:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498986;
	bh=mcqkFsg/RX4IlVqbwKDYg37Gilagk3tdvNEz3n2gbV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+RuOjwss3/rChR+hRvMKPX0caLJzi4rUcbgUAW5JLP3E5OefQQ0coHUlAaluPfao
	 Agjc1Em/wG30lS5WUGU33ustTlZZxWnqRzIjFoOni3s71eDNYWvkXISXjpcy+R5RSw
	 gH/xwlCFqOt6spDA+35MqfFv7sK5r1on0xgCTld4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/451] clk: renesas: r9a06g032: Export function to set dmamux
Date: Thu, 15 Jan 2026 17:44:30 +0100
Message-ID: <20260115164233.397731345@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 885525c1e7e27ea6207d648a8db20dfbbd9e4238 ]

The dmamux register is located within the system controller.

Without syscon, we need an extra helper in order to give write access to
this register to a dmamux driver.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220427095653.91804-5-miquel.raynal@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: f8def051bbcf ("clk: renesas: r9a06g032: Fix memory leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a06g032-clocks.c        | 35 ++++++++++++++++++-
 include/linux/soc/renesas/r9a06g032-sysctrl.h | 11 ++++++
 2 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/soc/renesas/r9a06g032-sysctrl.h

diff --git a/drivers/clk/renesas/r9a06g032-clocks.c b/drivers/clk/renesas/r9a06g032-clocks.c
index 285f6ac25372d..65cd6ed68923e 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -20,9 +20,12 @@
 #include <linux/pm_clock.h>
 #include <linux/pm_domain.h>
 #include <linux/slab.h>
+#include <linux/soc/renesas/r9a06g032-sysctrl.h>
 #include <linux/spinlock.h>
 #include <dt-bindings/clock/r9a06g032-sysctrl.h>
 
+#define R9A06G032_SYSCTRL_DMAMUX 0xA0
+
 struct r9a06g032_gate {
 	u16 gate, reset, ready, midle,
 		scon, mirack, mistat;
@@ -315,6 +318,30 @@ struct r9a06g032_priv {
 	void __iomem *reg;
 };
 
+static struct r9a06g032_priv *sysctrl_priv;
+
+/* Exported helper to access the DMAMUX register */
+int r9a06g032_sysctrl_set_dmamux(u32 mask, u32 val)
+{
+	unsigned long flags;
+	u32 dmamux;
+
+	if (!sysctrl_priv)
+		return -EPROBE_DEFER;
+
+	spin_lock_irqsave(&sysctrl_priv->lock, flags);
+
+	dmamux = readl(sysctrl_priv->reg + R9A06G032_SYSCTRL_DMAMUX);
+	dmamux &= ~mask;
+	dmamux |= val & mask;
+	writel(dmamux, sysctrl_priv->reg + R9A06G032_SYSCTRL_DMAMUX);
+
+	spin_unlock_irqrestore(&sysctrl_priv->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(r9a06g032_sysctrl_set_dmamux);
+
 /* register/bit pairs are encoded as an uint16_t */
 static void
 clk_rdesc_set(struct r9a06g032_priv *clocks,
@@ -961,7 +988,13 @@ static int __init r9a06g032_clocks_probe(struct platform_device *pdev)
 	if (error)
 		return error;
 
-	return r9a06g032_add_clk_domain(dev);
+	error = r9a06g032_add_clk_domain(dev);
+	if (error)
+		return error;
+
+	sysctrl_priv = clocks;
+
+	return 0;
 }
 
 static const struct of_device_id r9a06g032_match[] = {
diff --git a/include/linux/soc/renesas/r9a06g032-sysctrl.h b/include/linux/soc/renesas/r9a06g032-sysctrl.h
new file mode 100644
index 0000000000000..066dfb15cbddd
--- /dev/null
+++ b/include/linux/soc/renesas/r9a06g032-sysctrl.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_SOC_RENESAS_R9A06G032_SYSCTRL_H__
+#define __LINUX_SOC_RENESAS_R9A06G032_SYSCTRL_H__
+
+#ifdef CONFIG_CLK_R9A06G032
+int r9a06g032_sysctrl_set_dmamux(u32 mask, u32 val);
+#else
+static inline int r9a06g032_sysctrl_set_dmamux(u32 mask, u32 val) { return -ENODEV; }
+#endif
+
+#endif /* __LINUX_SOC_RENESAS_R9A06G032_SYSCTRL_H__ */
-- 
2.51.0



