Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060930;
	b=y0a4IMFI/vnYd0s4AtLWrxInLY9nR3/BYOiU6A3E7qDzxYDCH6fOgHjRg8kzcc4uX+vM
	 VLvjFd+UwU33tm84QoYZz+1F9ojV8QVh8lKu3mGmzz1JkIlDp+fnG4RpTQ+Bu2OSSd4a6
	 eRmGyL8JmXHbhHSNdMkdcHWkqoeWXkq379uxYOKtx33QY8g1/KKGX/Xl0VQyzVObQcJQz
	 OYX50iEzgZoWEcsbkNdYptGoV8Gh3i8tFUhSEiuoQTXO3ny2+ZLNLL3WecoBr9jGjH3Z3
	 Tvwo1VVEslC1+1RB8clieXrJyAJjz/fvjtF9dQauuWXV7y/Devh1z39BNu8XYH3hBoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f1nkpioR8Qugza+G/UDyboX8ARnSKlkX1NdvDJxY2XU=;
	b=RbGmCD/BMqIN//TzXiY0sA/MOiU/FXasmN3hUSrlRFyFkpKtzut0ru64Xg9jN+1V5eQf
	 YaOSTWStO3K9L91VoxBlLpQPA+Mz1/3cA8htQPMqA483oQsM5Bn4q4wbNaAXISCX6o3pX
	 tf1Q5ZLY7GdiUzbeohMJ+WfR1fUsqmRgBGcB5YkFAksMKKNv6M5UFucd142hIWU4uo6FX
	 Rr2opL2BmdQGqNF8vZ2DDiasM3Pei0YoHgPg8PgTPL7g5u1CvjhXjpm462DKfBpDAAFIL
	 p+j8H7EMKkeas+UGmeH4gmiGuu3oK6IjuQjfFWSNNt63VdWOQr0tzqC3k4viPDJJ7Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DFIghPBm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960B3606A320;
	Thu, 19 Nov 2026 04:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DFIghPBm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD85E1F000C4;
	Thu, 19 Nov 2026 04:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060930;
	bh=f1nkpioR8Qugza+G/UDyboX8ARnSKlkX1NdvDJxY2XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFIghPBm4ttCOAwRl8TRofJFGt7Q3Dci+nXAlvjusYw2zVok5uTauuprXNc9JkWNo
	 e6yM8XVcUROy2/6jenjFLHh54iD4OSJVTxm1BGLq/k+wKJGG3FUqjYkM4WAHqzkJjA
	 80JSivNugMrgL8YGBbVrvrEMrn5UgoI9DEtKXjgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1333/1848] =?UTF-8?q?mfd:=20intel=5Fquark=5Fi2c=5Fgpio:=20Convert=20I=C2=B2C?= =?UTF-8?q?=20to=20use=20software=20nodes?=
Date: Wed, 18 Nov 2026 15:56:11 +0100
Message-ID: <20261118150015.545780585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c58ddd297fb903e11b0fcae0c0d38106125c1b58 ]

The driver can provide a software node group instead of
passing legacy platform data. This will allow to drop
the legacy platform data structures along with unifying
a child device driver to use same interface for all
property providers, i.e. Device Tree, ACPI, and board files.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 41 +++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index 902db038c930e..7db74ec622613 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -18,7 +18,7 @@
 #include <linux/dmi.h>
 #include <linux/i2c.h>
 #include <linux/platform_data/gpio-dwapb.h>
-#include <linux/platform_data/i2c-designware.h>
+#include <linux/property.h>
 
 /* PCI BAR for register base address */
 #define MFD_I2C_BAR		0
@@ -50,24 +50,44 @@ struct intel_quark_mfd {
 	struct clk_lookup	*i2c_clk_lookup;
 };
 
+static const struct property_entry intel_quark_i2c_controller_standard_properties[] = {
+	PROPERTY_ENTRY_U32("clock-frequency", I2C_MAX_STANDARD_MODE_FREQ),
+	{ }
+};
+
+static const struct software_node intel_quark_i2c_controller_standard_node = {
+	.name = "intel-quark-i2c-controller",
+	.properties = intel_quark_i2c_controller_standard_properties,
+};
+
+static const struct property_entry intel_quark_i2c_controller_fast_properties[] = {
+	PROPERTY_ENTRY_U32("clock-frequency", I2C_MAX_FAST_MODE_FREQ),
+	{ }
+};
+
+static const struct software_node intel_quark_i2c_controller_fast_node = {
+	.name = "intel-quark-i2c-controller",
+	.properties = intel_quark_i2c_controller_fast_properties,
+};
+
 static const struct dmi_system_id dmi_platform_info[] = {
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Galileo"),
 		},
-		.driver_data = (void *)I2C_MAX_STANDARD_MODE_FREQ,
+		.driver_data = (void *)&intel_quark_i2c_controller_standard_node,
 	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "GalileoGen2"),
 		},
-		.driver_data = (void *)I2C_MAX_FAST_MODE_FREQ,
+		.driver_data = (void *)&intel_quark_i2c_controller_fast_node,
 	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "SIMATIC IOT2000"),
 		},
-		.driver_data = (void *)I2C_MAX_FAST_MODE_FREQ,
+		.driver_data = (void *)&intel_quark_i2c_controller_fast_node,
 	},
 	{}
 };
@@ -160,8 +180,6 @@ static int intel_quark_i2c_setup(struct pci_dev *pdev)
 	struct mfd_cell *cell = &intel_quark_mfd_cells[MFD_I2C_BAR];
 	struct resource *res = intel_quark_i2c_res;
 	const struct dmi_system_id *dmi_id;
-	struct dw_i2c_platform_data *pdata;
-	struct device *dev = &pdev->dev;
 
 	res[INTEL_QUARK_IORES_MEM].start = pci_resource_start(pdev, MFD_I2C_BAR);
 	res[INTEL_QUARK_IORES_MEM].end = pci_resource_end(pdev, MFD_I2C_BAR);
@@ -169,19 +187,12 @@ static int intel_quark_i2c_setup(struct pci_dev *pdev)
 	res[INTEL_QUARK_IORES_IRQ].start = pci_irq_vector(pdev, 0);
 	res[INTEL_QUARK_IORES_IRQ].end = pci_irq_vector(pdev, 0);
 
-	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return -ENOMEM;
-
 	/* Normal mode by default */
-	pdata->i2c_scl_freq = I2C_MAX_STANDARD_MODE_FREQ;
+	cell->swnode = &intel_quark_i2c_controller_standard_node;
 
 	dmi_id = dmi_first_match(dmi_platform_info);
 	if (dmi_id)
-		pdata->i2c_scl_freq = (uintptr_t)dmi_id->driver_data;
-
-	cell->platform_data = pdata;
-	cell->pdata_size = sizeof(*pdata);
+		cell->swnode = (struct software_node *)dmi_id->driver_data;
 
 	return 0;
 }
-- 
2.53.0



