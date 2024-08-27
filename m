Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685131CE6E7;
	Tue, 27 Aug 2024 15:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772419; cv=none; b=fUYtseyRkoyc7Ngy9Jk3flS5Ucfmhr+EkkP1ZcrSHJIPqqXT9lI38iksiKg9cIluxJjMQUXVCKU+FNci2DtWjHApraG8UdRJ8gnw6X1I1jEaumk3Gi8UV5opYR+5+9QHupxF4f/M5HoNrDa9Y4USvPyZKHzsRM8W6COLSJLJ17c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772419; c=relaxed/simple;
	bh=J9at6H10dj6dGgN4IClOqheVKMzcpyDSUmwug4oyepY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OUMtThJiv1wjU+k2tpL4++ZQJMrg+8mncPlKhTtPcBmCX9/OxoUnJz4I2UkOlfnwPBGNQXf00IRx+bM46dtkcyjBsKZlgTDIiCnEwSffxPBHIZYLPHGpiClUIG6CFmTtTk+PSkVzNXxR/S0bzEJhAJEn+5O+6np3b2BpdVsunjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vId0P9wK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vId0P9wK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98815C4DE14;
	Tue, 27 Aug 2024 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772419;
	bh=J9at6H10dj6dGgN4IClOqheVKMzcpyDSUmwug4oyepY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vId0P9wKQkxz0YCaEe2yvzCU0g9oG64p5rRkWdn+WX6QV4J16LRG0yJWyIgDsNVtG
	 AQw7aP5Yn4+WbOubDDlgML9vlYw5vGKFck2u19dp+OkyoWswc080+bdTjPwARbRIEw
	 KQYW0/zjTZkYnr2/9ciipkYGhuFv5fWSSHEKKNRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Dmitry Osipenko <digetx@gmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/321] i2c: tegra: allow DVC support to be compiled out
Date: Tue, 27 Aug 2024 16:38:38 +0200
Message-ID: <20240827143846.226924961@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit a55efa7edf37dc428da7058b25c58a54dc9db4e4 ]

Save a bit of code for newer Tegra platforms by compiling out
DVC's I2C mode support that's used only for Tegra2.

$ size i2c-tegra.o
    text    data     bss     dec     hex filename
-  11381     292       8   11681    2da1 i2c-tegra.o
+  10193     292       8   10493    28fd i2c-tegra.o

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 14d069d92951 ("i2c: tegra: Do not mark ACPI devices as irq safe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index aa469b33ee2ee..cc9dfd4f6c362 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -298,6 +298,8 @@ struct tegra_i2c_dev {
 	bool is_vi;
 };
 
+#define IS_DVC(dev) (IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC) && (dev)->is_dvc)
+
 static void dvc_writel(struct tegra_i2c_dev *i2c_dev, u32 val,
 		       unsigned int reg)
 {
@@ -315,7 +317,7 @@ static u32 dvc_readl(struct tegra_i2c_dev *i2c_dev, unsigned int reg)
  */
 static u32 tegra_i2c_reg_addr(struct tegra_i2c_dev *i2c_dev, unsigned int reg)
 {
-	if (i2c_dev->is_dvc)
+	if (IS_DVC(i2c_dev))
 		reg += (reg >= I2C_TX_FIFO) ? 0x10 : 0x40;
 	else if (i2c_dev->is_vi)
 		reg = 0xc00 + (reg << 2);
@@ -639,7 +641,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 
 	WARN_ON_ONCE(err);
 
-	if (i2c_dev->is_dvc)
+	if (IS_DVC(i2c_dev))
 		tegra_dvc_init(i2c_dev);
 
 	val = I2C_CNFG_NEW_MASTER_FSM | I2C_CNFG_PACKET_MODE_EN |
@@ -703,7 +705,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 		return err;
 	}
 
-	if (!i2c_dev->is_dvc && !i2c_dev->is_vi) {
+	if (!IS_DVC(i2c_dev) && !i2c_dev->is_vi) {
 		u32 sl_cfg = i2c_readl(i2c_dev, I2C_SL_CNFG);
 
 		sl_cfg |= I2C_SL_CNFG_NACK | I2C_SL_CNFG_NEWSL;
@@ -933,7 +935,7 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 	}
 
 	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
-	if (i2c_dev->is_dvc)
+	if (IS_DVC(i2c_dev))
 		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
 
 	/*
@@ -972,7 +974,7 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 
 	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
 
-	if (i2c_dev->is_dvc)
+	if (IS_DVC(i2c_dev))
 		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
 
 	if (i2c_dev->dma_mode) {
@@ -1660,7 +1662,9 @@ static const struct of_device_id tegra_i2c_of_match[] = {
 	{ .compatible = "nvidia,tegra114-i2c", .data = &tegra114_i2c_hw, },
 	{ .compatible = "nvidia,tegra30-i2c", .data = &tegra30_i2c_hw, },
 	{ .compatible = "nvidia,tegra20-i2c", .data = &tegra20_i2c_hw, },
+#if IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC)
 	{ .compatible = "nvidia,tegra20-i2c-dvc", .data = &tegra20_i2c_hw, },
+#endif
 	{},
 };
 MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
@@ -1675,7 +1679,8 @@ static void tegra_i2c_parse_dt(struct tegra_i2c_dev *i2c_dev)
 	multi_mode = device_property_read_bool(i2c_dev->dev, "multi-master");
 	i2c_dev->multimaster_mode = multi_mode;
 
-	if (of_device_is_compatible(np, "nvidia,tegra20-i2c-dvc"))
+	if (IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC) &&
+	    of_device_is_compatible(np, "nvidia,tegra20-i2c-dvc"))
 		i2c_dev->is_dvc = true;
 
 	if (of_device_is_compatible(np, "nvidia,tegra210-i2c-vi"))
-- 
2.43.0



