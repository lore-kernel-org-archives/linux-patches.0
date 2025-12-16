Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2091346A13;
	Tue, 16 Dec 2025 12:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887642; cv=none; b=gUVFH2MeVtiL2+oZwIaqGKd6Zseh32FvSY6CRw5NHWgoFDHwslZ6YzBgiWLcZvAb9IXEV4FQL29WEbhTuURDvKRkF9UmDdVfcGWwuhKqEPW/78XtZYPk8T63CIFRQCDsGFM9/hzn3hVarJ1rXqJ95Fnantklq6UOYycDbw1eUmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887642; c=relaxed/simple;
	bh=JAL+vQg4uFzg/yCH8go0HYdK0XovoKakadITfIbHkDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzpsH1fUPTlkX8mmCiiR/MESt5ChlU47X1lSyWs0csJEVmd6ouwqIYhpOMoqhklmboU/Giqe0kfabRNzhZbdGp6vpy+/zlEVpVrxu7DXaB8HOqFsNWAY0YJ2wyvrDQS2lhW9+Nmw7BixocSltXrtEIb1bQvhznI3eHGmD0fF3b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9QNdyct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9QNdyct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735D0C4CEF5;
	Tue, 16 Dec 2025 12:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887641;
	bh=JAL+vQg4uFzg/yCH8go0HYdK0XovoKakadITfIbHkDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9QNdyctz1J/+IyY8zXsIAhPudIDXa6IHw/VCMUS4gogoRdL9MpLSdb/6oF1T27RE
	 IDATrkb39LfJeai9hDCu8Awo5Xm3jw5KedJ3sU46ZdERC0oRHm7Omni0n3jefZmy8M
	 AJ7uVjCNKlDDM3sHnSoclZuuWQfDKpXRwB6RqC0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 276/614] soc: renesas: rz-sysc: Populate readable_reg/writeable_reg in regmap config
Date: Tue, 16 Dec 2025 12:10:43 +0100
Message-ID: <20251216111411.374139790@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit c432180a7d95081353a96fd6d5bd75b0fc8a27c3 ]

Not all system controller registers are accessible from Linux. Accessing
such registers generates synchronous external abort. Populate the
readable_reg and writeable_reg members of the regmap config to inform the
regmap core which registers can be accessed. The list will need to be
updated whenever new system controller functionality is exported through
regmap.

Fixes: 2da2740fb9c8 ("soc: renesas: rz-sysc: Add syscon/regmap support")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251105070526.264445-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r9a08g045-sysc.c |  69 ++++++++++++++++++
 drivers/soc/renesas/r9a09g047-sys.c  |  79 +++++++++++++++++++++
 drivers/soc/renesas/r9a09g056-sys.c  |  68 ++++++++++++++++++
 drivers/soc/renesas/r9a09g057-sys.c  | 101 +++++++++++++++++++++++++++
 drivers/soc/renesas/rz-sysc.c        |   2 +
 drivers/soc/renesas/rz-sysc.h        |   4 ++
 6 files changed, 323 insertions(+)

diff --git a/drivers/soc/renesas/r9a08g045-sysc.c b/drivers/soc/renesas/r9a08g045-sysc.c
index 0504d4e687616..03d653d5cde55 100644
--- a/drivers/soc/renesas/r9a08g045-sysc.c
+++ b/drivers/soc/renesas/r9a08g045-sysc.c
@@ -6,10 +6,29 @@
  */
 
 #include <linux/bits.h>
+#include <linux/device.h>
 #include <linux/init.h>
 
 #include "rz-sysc.h"
 
+#define SYS_XSPI_MAP_STAADD_CS0		0x348
+#define SYS_XSPI_MAP_ENDADD_CS0		0x34c
+#define SYS_XSPI_MAP_STAADD_CS1		0x350
+#define SYS_XSPI_MAP_ENDADD_CS1		0x354
+#define SYS_GETH0_CFG			0x380
+#define SYS_GETH1_CFG			0x390
+#define SYS_PCIE_CFG			0x3a0
+#define SYS_PCIE_MON			0x3a4
+#define SYS_PCIE_ERR_MON		0x3ac
+#define SYS_PCIE_PHY			0x3b4
+#define SYS_I2C0_CFG			0x400
+#define SYS_I2C1_CFG			0x410
+#define SYS_I2C2_CFG			0x420
+#define SYS_I2C3_CFG			0x430
+#define SYS_I3C_CFG			0x440
+#define SYS_USB_PWRRDY			0xd70
+#define SYS_PCIE_RST_RSM_B		0xd74
+
 static const struct rz_sysc_soc_id_init_data rzg3s_sysc_soc_id_init_data __initconst = {
 	.family = "RZ/G3S",
 	.id = 0x85e0447,
@@ -18,7 +37,57 @@ static const struct rz_sysc_soc_id_init_data rzg3s_sysc_soc_id_init_data __initc
 	.specific_id_mask = GENMASK(27, 0),
 };
 
+static bool rzg3s_regmap_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SYS_XSPI_MAP_STAADD_CS0:
+	case SYS_XSPI_MAP_ENDADD_CS0:
+	case SYS_XSPI_MAP_STAADD_CS1:
+	case SYS_XSPI_MAP_ENDADD_CS1:
+	case SYS_GETH0_CFG:
+	case SYS_GETH1_CFG:
+	case SYS_PCIE_CFG:
+	case SYS_PCIE_MON:
+	case SYS_PCIE_ERR_MON:
+	case SYS_PCIE_PHY:
+	case SYS_I2C0_CFG:
+	case SYS_I2C1_CFG:
+	case SYS_I2C2_CFG:
+	case SYS_I2C3_CFG:
+	case SYS_I3C_CFG:
+	case SYS_USB_PWRRDY:
+	case SYS_PCIE_RST_RSM_B:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool rzg3s_regmap_writeable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SYS_XSPI_MAP_STAADD_CS0:
+	case SYS_XSPI_MAP_ENDADD_CS0:
+	case SYS_XSPI_MAP_STAADD_CS1:
+	case SYS_XSPI_MAP_ENDADD_CS1:
+	case SYS_PCIE_CFG:
+	case SYS_PCIE_PHY:
+	case SYS_I2C0_CFG:
+	case SYS_I2C1_CFG:
+	case SYS_I2C2_CFG:
+	case SYS_I2C3_CFG:
+	case SYS_I3C_CFG:
+	case SYS_USB_PWRRDY:
+	case SYS_PCIE_RST_RSM_B:
+		return true;
+	default:
+		return false;
+	}
+}
+
 const struct rz_sysc_init_data rzg3s_sysc_init_data __initconst = {
 	.soc_id_init_data = &rzg3s_sysc_soc_id_init_data,
+	.readable_reg = rzg3s_regmap_readable_reg,
+	.writeable_reg = rzg3s_regmap_writeable_reg,
 	.max_register = 0xe20,
 };
diff --git a/drivers/soc/renesas/r9a09g047-sys.c b/drivers/soc/renesas/r9a09g047-sys.c
index 2e8426c030504..e413b0eff9bfd 100644
--- a/drivers/soc/renesas/r9a09g047-sys.c
+++ b/drivers/soc/renesas/r9a09g047-sys.c
@@ -29,6 +29,27 @@
 #define SYS_LSI_PRR_CA55_DIS		BIT(8)
 #define SYS_LSI_PRR_NPU_DIS		BIT(1)
 
+#define SYS_LSI_OTPTSU1TRMVAL0		0x330
+#define SYS_LSI_OTPTSU1TRMVAL1		0x334
+#define SYS_SPI_STAADDCS0		0x900
+#define SYS_SPI_ENDADDCS0		0x904
+#define SYS_SPI_STAADDCS1		0x908
+#define SYS_SPI_ENDADDCS1		0x90c
+#define SYS_VSP_CLK			0xe00
+#define SYS_GBETH0_CFG			0xf00
+#define SYS_GBETH1_CFG			0xf04
+#define SYS_PCIE_INTX_CH0		0x1000
+#define SYS_PCIE_MSI1_CH0		0x1004
+#define SYS_PCIE_MSI2_CH0		0x1008
+#define SYS_PCIE_MSI3_CH0		0x100c
+#define SYS_PCIE_MSI4_CH0		0x1010
+#define SYS_PCIE_MSI5_CH0		0x1014
+#define SYS_PCIE_PME_CH0		0x1018
+#define SYS_PCIE_ACK_CH0		0x101c
+#define SYS_PCIE_MISC_CH0		0x1020
+#define SYS_PCIE_MODE_CH0		0x1024
+#define SYS_ADC_CFG			0x1600
+
 static void rzg3e_sys_print_id(struct device *dev,
 				void __iomem *sysc_base,
 				struct soc_device_attribute *soc_dev_attr)
@@ -62,7 +83,65 @@ static const struct rz_sysc_soc_id_init_data rzg3e_sys_soc_id_init_data __initco
 	.print_id = rzg3e_sys_print_id,
 };
 
+static bool rzg3e_regmap_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SYS_LSI_OTPTSU1TRMVAL0:
+	case SYS_LSI_OTPTSU1TRMVAL1:
+	case SYS_SPI_STAADDCS0:
+	case SYS_SPI_ENDADDCS0:
+	case SYS_SPI_STAADDCS1:
+	case SYS_SPI_ENDADDCS1:
+	case SYS_VSP_CLK:
+	case SYS_GBETH0_CFG:
+	case SYS_GBETH1_CFG:
+	case SYS_PCIE_INTX_CH0:
+	case SYS_PCIE_MSI1_CH0:
+	case SYS_PCIE_MSI2_CH0:
+	case SYS_PCIE_MSI3_CH0:
+	case SYS_PCIE_MSI4_CH0:
+	case SYS_PCIE_MSI5_CH0:
+	case SYS_PCIE_PME_CH0:
+	case SYS_PCIE_ACK_CH0:
+	case SYS_PCIE_MISC_CH0:
+	case SYS_PCIE_MODE_CH0:
+	case SYS_ADC_CFG:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool rzg3e_regmap_writeable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SYS_SPI_STAADDCS0:
+	case SYS_SPI_ENDADDCS0:
+	case SYS_SPI_STAADDCS1:
+	case SYS_SPI_ENDADDCS1:
+	case SYS_VSP_CLK:
+	case SYS_GBETH0_CFG:
+	case SYS_GBETH1_CFG:
+	case SYS_PCIE_INTX_CH0:
+	case SYS_PCIE_MSI1_CH0:
+	case SYS_PCIE_MSI2_CH0:
+	case SYS_PCIE_MSI3_CH0:
+	case SYS_PCIE_MSI4_CH0:
+	case SYS_PCIE_MSI5_CH0:
+	case SYS_PCIE_PME_CH0:
+	case SYS_PCIE_ACK_CH0:
+	case SYS_PCIE_MISC_CH0:
+	case SYS_PCIE_MODE_CH0:
+	case SYS_ADC_CFG:
+		return true;
+	default:
+		return false;
+	}
+}
+
 const struct rz_sysc_init_data rzg3e_sys_init_data = {
 	.soc_id_init_data = &rzg3e_sys_soc_id_init_data,
+	.readable_reg = rzg3e_regmap_readable_reg,
+	.writeable_reg = rzg3e_regmap_writeable_reg,
 	.max_register = 0x170c,
 };
diff --git a/drivers/soc/renesas/r9a09g056-sys.c b/drivers/soc/renesas/r9a09g056-sys.c
index 16b4e433c3373..42f5eff291fd1 100644
--- a/drivers/soc/renesas/r9a09g056-sys.c
+++ b/drivers/soc/renesas/r9a09g056-sys.c
@@ -34,6 +34,24 @@
 #define SYS_RZV2N_FEATURE_C55		BIT(1)
 #define SYS_RZV2N_FEATURE_SEC		BIT(2)
 
+#define SYS_LSI_OTPTSU0TRMVAL0		0x320
+#define SYS_LSI_OTPTSU0TRMVAL1		0x324
+#define SYS_LSI_OTPTSU1TRMVAL0		0x330
+#define SYS_LSI_OTPTSU1TRMVAL1		0x334
+#define SYS_GBETH0_CFG			0xf00
+#define SYS_GBETH1_CFG			0xf04
+#define SYS_PCIE_INTX_CH0		0x1000
+#define SYS_PCIE_MSI1_CH0		0x1004
+#define SYS_PCIE_MSI2_CH0		0x1008
+#define SYS_PCIE_MSI3_CH0		0x100c
+#define SYS_PCIE_MSI4_CH0		0x1010
+#define SYS_PCIE_MSI5_CH0		0x1014
+#define SYS_PCIE_PME_CH0		0x1018
+#define SYS_PCIE_ACK_CH0		0x101c
+#define SYS_PCIE_MISC_CH0		0x1020
+#define SYS_PCIE_MODE_CH0		0x1024
+#define SYS_ADC_CFG			0x1600
+
 static void rzv2n_sys_print_id(struct device *dev,
 			       void __iomem *sysc_base,
 			       struct soc_device_attribute *soc_dev_attr)
@@ -70,7 +88,57 @@ static const struct rz_sysc_soc_id_init_data rzv2n_sys_soc_id_init_data __initco
 	.print_id = rzv2n_sys_print_id,
 };
 
+static bool rzv2n_regmap_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SYS_LSI_OTPTSU0TRMVAL0:
+	case SYS_LSI_OTPTSU0TRMVAL1:
+	case SYS_LSI_OTPTSU1TRMVAL0:
+	case SYS_LSI_OTPTSU1TRMVAL1:
+	case SYS_GBETH0_CFG:
+	case SYS_GBETH1_CFG:
+	case SYS_PCIE_INTX_CH0:
+	case SYS_PCIE_MSI1_CH0:
+	case SYS_PCIE_MSI2_CH0:
+	case SYS_PCIE_MSI3_CH0:
+	case SYS_PCIE_MSI4_CH0:
+	case SYS_PCIE_MSI5_CH0:
+	case SYS_PCIE_PME_CH0:
+	case SYS_PCIE_ACK_CH0:
+	case SYS_PCIE_MISC_CH0:
+	case SYS_PCIE_MODE_CH0:
+	case SYS_ADC_CFG:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool rzv2n_regmap_writeable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SYS_GBETH0_CFG:
+	case SYS_GBETH1_CFG:
+	case SYS_PCIE_INTX_CH0:
+	case SYS_PCIE_MSI1_CH0:
+	case SYS_PCIE_MSI2_CH0:
+	case SYS_PCIE_MSI3_CH0:
+	case SYS_PCIE_MSI4_CH0:
+	case SYS_PCIE_MSI5_CH0:
+	case SYS_PCIE_PME_CH0:
+	case SYS_PCIE_ACK_CH0:
+	case SYS_PCIE_MISC_CH0:
+	case SYS_PCIE_MODE_CH0:
+	case SYS_ADC_CFG:
+		return true;
+	default:
+		return false;
+	}
+}
+
 const struct rz_sysc_init_data rzv2n_sys_init_data = {
 	.soc_id_init_data = &rzv2n_sys_soc_id_init_data,
+	.readable_reg = rzv2n_regmap_readable_reg,
+	.writeable_reg = rzv2n_regmap_writeable_reg,
 	.max_register = 0x170c,
 };
diff --git a/drivers/soc/renesas/r9a09g057-sys.c b/drivers/soc/renesas/r9a09g057-sys.c
index e3390e7c7fe51..827c718ac7c54 100644
--- a/drivers/soc/renesas/r9a09g057-sys.c
+++ b/drivers/soc/renesas/r9a09g057-sys.c
@@ -29,6 +29,35 @@
 #define SYS_LSI_PRR_GPU_DIS		BIT(0)
 #define SYS_LSI_PRR_ISP_DIS		BIT(4)
 
+#define SYS_LSI_OTPTSU0TRMVAL0		0x320
+#define SYS_LSI_OTPTSU0TRMVAL1		0x324
+#define SYS_LSI_OTPTSU1TRMVAL0		0x330
+#define SYS_LSI_OTPTSU1TRMVAL1		0x334
+#define SYS_GBETH0_CFG			0xf00
+#define SYS_GBETH1_CFG			0xf04
+#define SYS_PCIE_INTX_CH0		0x1000
+#define SYS_PCIE_MSI1_CH0		0x1004
+#define SYS_PCIE_MSI2_CH0		0x1008
+#define SYS_PCIE_MSI3_CH0		0x100c
+#define SYS_PCIE_MSI4_CH0		0x1010
+#define SYS_PCIE_MSI5_CH0		0x1014
+#define SYS_PCIE_PME_CH0		0x1018
+#define SYS_PCIE_ACK_CH0		0x101c
+#define SYS_PCIE_MISC_CH0		0x1020
+#define SYS_PCIE_MODE_CH0		0x1024
+#define SYS_PCIE_INTX_CH1		0x1030
+#define SYS_PCIE_MSI1_CH1		0x1034
+#define SYS_PCIE_MSI2_CH1		0x1038
+#define SYS_PCIE_MSI3_CH1		0x103c
+#define SYS_PCIE_MSI4_CH1		0x1040
+#define SYS_PCIE_MSI5_CH1		0x1044
+#define SYS_PCIE_PME_CH1		0x1048
+#define SYS_PCIE_ACK_CH1		0x104c
+#define SYS_PCIE_MISC_CH1		0x1050
+#define SYS_PCIE_MODE_CH1		0x1054
+#define SYS_PCIE_MODE			0x1060
+#define SYS_ADC_CFG			0x1600
+
 static void rzv2h_sys_print_id(struct device *dev,
 				void __iomem *sysc_base,
 				struct soc_device_attribute *soc_dev_attr)
@@ -62,7 +91,79 @@ static const struct rz_sysc_soc_id_init_data rzv2h_sys_soc_id_init_data __initco
 	.print_id = rzv2h_sys_print_id,
 };
 
+static bool rzv2h_regmap_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SYS_LSI_OTPTSU0TRMVAL0:
+	case SYS_LSI_OTPTSU0TRMVAL1:
+	case SYS_LSI_OTPTSU1TRMVAL0:
+	case SYS_LSI_OTPTSU1TRMVAL1:
+	case SYS_GBETH0_CFG:
+	case SYS_GBETH1_CFG:
+	case SYS_PCIE_INTX_CH0:
+	case SYS_PCIE_MSI1_CH0:
+	case SYS_PCIE_MSI2_CH0:
+	case SYS_PCIE_MSI3_CH0:
+	case SYS_PCIE_MSI4_CH0:
+	case SYS_PCIE_MSI5_CH0:
+	case SYS_PCIE_PME_CH0:
+	case SYS_PCIE_ACK_CH0:
+	case SYS_PCIE_MISC_CH0:
+	case SYS_PCIE_MODE_CH0:
+	case SYS_PCIE_INTX_CH1:
+	case SYS_PCIE_MSI1_CH1:
+	case SYS_PCIE_MSI2_CH1:
+	case SYS_PCIE_MSI3_CH1:
+	case SYS_PCIE_MSI4_CH1:
+	case SYS_PCIE_MSI5_CH1:
+	case SYS_PCIE_PME_CH1:
+	case SYS_PCIE_ACK_CH1:
+	case SYS_PCIE_MISC_CH1:
+	case SYS_PCIE_MODE_CH1:
+	case SYS_PCIE_MODE:
+	case SYS_ADC_CFG:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool rzv2h_regmap_writeable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SYS_GBETH0_CFG:
+	case SYS_GBETH1_CFG:
+	case SYS_PCIE_INTX_CH0:
+	case SYS_PCIE_MSI1_CH0:
+	case SYS_PCIE_MSI2_CH0:
+	case SYS_PCIE_MSI3_CH0:
+	case SYS_PCIE_MSI4_CH0:
+	case SYS_PCIE_MSI5_CH0:
+	case SYS_PCIE_PME_CH0:
+	case SYS_PCIE_ACK_CH0:
+	case SYS_PCIE_MISC_CH0:
+	case SYS_PCIE_MODE_CH0:
+	case SYS_PCIE_INTX_CH1:
+	case SYS_PCIE_MSI1_CH1:
+	case SYS_PCIE_MSI2_CH1:
+	case SYS_PCIE_MSI3_CH1:
+	case SYS_PCIE_MSI4_CH1:
+	case SYS_PCIE_MSI5_CH1:
+	case SYS_PCIE_PME_CH1:
+	case SYS_PCIE_ACK_CH1:
+	case SYS_PCIE_MISC_CH1:
+	case SYS_PCIE_MODE_CH1:
+	case SYS_PCIE_MODE:
+	case SYS_ADC_CFG:
+		return true;
+	default:
+		return false;
+	}
+}
+
 const struct rz_sysc_init_data rzv2h_sys_init_data = {
 	.soc_id_init_data = &rzv2h_sys_soc_id_init_data,
+	.readable_reg = rzv2h_regmap_readable_reg,
+	.writeable_reg = rzv2h_regmap_writeable_reg,
 	.max_register = 0x170c,
 };
diff --git a/drivers/soc/renesas/rz-sysc.c b/drivers/soc/renesas/rz-sysc.c
index 9f79e299e6f41..19c1e666279b7 100644
--- a/drivers/soc/renesas/rz-sysc.c
+++ b/drivers/soc/renesas/rz-sysc.c
@@ -140,6 +140,8 @@ static int rz_sysc_probe(struct platform_device *pdev)
 	regmap_cfg->val_bits = 32;
 	regmap_cfg->fast_io = true;
 	regmap_cfg->max_register = data->max_register;
+	regmap_cfg->readable_reg = data->readable_reg;
+	regmap_cfg->writeable_reg = data->writeable_reg;
 
 	regmap = devm_regmap_init_mmio(dev, sysc->base, regmap_cfg);
 	if (IS_ERR(regmap))
diff --git a/drivers/soc/renesas/rz-sysc.h b/drivers/soc/renesas/rz-sysc.h
index 8eec355d5d562..88929bf21cb11 100644
--- a/drivers/soc/renesas/rz-sysc.h
+++ b/drivers/soc/renesas/rz-sysc.h
@@ -34,10 +34,14 @@ struct rz_sysc_soc_id_init_data {
 /**
  * struct rz_sysc_init_data - RZ SYSC initialization data
  * @soc_id_init_data: RZ SYSC SoC ID initialization data
+ * @writeable_reg: Regmap writeable register check function
+ * @readable_reg: Regmap readable register check function
  * @max_register: Maximum SYSC register offset to be used by the regmap config
  */
 struct rz_sysc_init_data {
 	const struct rz_sysc_soc_id_init_data *soc_id_init_data;
+	bool (*writeable_reg)(struct device *dev, unsigned int reg);
+	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	u32 max_register;
 };
 
-- 
2.51.0



