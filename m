Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621383;
	b=1mKm/NNm8Vz8qUACb01fGROBRRnFZQPPyCyUJB+1lnu+pN7QKKcc/Z+U+CdVP/FX/kMR
	 iSa/DE9fyIlWxw8MJ5ClfULEjkhwLwgKS3aPBe4nJsCKXs+VIOvPXu0SbEMigval/bnP1
	 IbjTPtW71vIYk+jJCzzTvEKsOsnhdF0ELmnDhB+FOo4O6LFHuIix+RE7KOubjQxtpOWUG
	 K728CyizfvqKoA8tjFLmOtOhRO4tiYigcQ9jCTYJ+LwzfkC/jKDWfx4geYMC7VCdndgUD
	 EPtUXGcdbccfRYWkOrtITeY5KCp7VJqhXLmvYyPbH4WNgP62JB57LJKiR4uXZhu+VTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/IIwo4IS67A3HIENnDFwCmWrjIeYVXsBoW/fsm/I9M=;
	b=2FrfLhV8vjP8lmgjXlYuHwYAIzu3aogwTDgWD234s+feIcAwtfGD/Ifa2FzCvKA3+veB
	 EdClV04bSsEBl5ox/Vzh488iDuOKdlSM7VBe4i+bXfsz22w7xkeZGGjn7v632JBaWby86
	 nMNwWEAFu1vyDLwDhvFS4EUYebTETU+QKGsPn0ukUARqKBDxzsgCygzAgp7ntv0wbHImR
	 Q96FWrw9cmpLWxZHvFevQVO5LAG6qvNnMg/Yc2cL6wX/zrn+8BSzrPifMNpuBohkCYIrQ
	 uZ9G3FA3e4JOFQWpqibPJhu1jcMgj7agVksItprBXVaOiKELNubfm3JKNeN8eKdwMyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r/sVejAU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771C7606A6A7;
	Wed, 25 Nov 2026 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r/sVejAU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF8C1F000C0;
	Wed, 25 Nov 2026 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621383;
	bh=C/IIwo4IS67A3HIENnDFwCmWrjIeYVXsBoW/fsm/I9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r/sVejAUT8UMcTf5LmRDHg/77KjP88jmE6gENYsjcatte45VQtAKfOEYeFiWKMVMB
	 2M7g8cFjMXQIHJ6T//JBgZyIKo9khu7/vDxL/Tpuj4+ISB6CmWn/DmN9umElcAosZA
	 dT/dAj3MihlYukxnLPI/oER4h+vVPJbYluyF77ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/990] regulator: qcom_spmi: dont take a sleeping lock in the SAW IPI
Date: Wed, 25 Nov 2026 15:25:30 +0100
Message-ID: <20261125143825.912527442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 053c50a7052549aab0d310ad505947db3e211592 ]

The SAW voltage change runs on CPU 0 from an IPI, but it reaches the SAW
registers through the syscon regmap, which is protected by a spinlock_t.
That is a sleeping lock on PREEMPT_RT, and lockdep complains as soon as
VDD_APCC actually changes voltage:

  BUG: Invalid wait context
  ...
  regmap_lock_spinlock+0x18/0x30
  regmap_read+0x3c/0x78
  spmi_saw_set_vdd+0x50/0x1ac
  __flush_smp_call_function_queue+0x1ac/0x334

Map the SAW with a regmap of our own that uses a raw spinlock, and fail
the probe when that cannot be done instead of carrying an error pointer
around as the SAW regmap.

Fixes: 0caecaa87202 ("regulator: qcom_spmi: Add support for SAW")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20261019-fix-qcom-saw-v1-3-9c7ba3fc2493@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/Kconfig               |  1 +
 drivers/regulator/qcom_spmi-regulator.c | 35 +++++++++++++++++++------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index d84f3d054c59d..a504a20f994fa 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -1149,6 +1149,7 @@ config REGULATOR_QCOM_SMD_RPM
 config REGULATOR_QCOM_SPMI
 	tristate "Qualcomm SPMI regulator driver"
 	depends on SPMI || COMPILE_TEST
+	select REGMAP_MMIO
 	help
 	  If you say yes to this option, support will be included for the
 	  regulators found in Qualcomm SPMI PMICs.
diff --git a/drivers/regulator/qcom_spmi-regulator.c b/drivers/regulator/qcom_spmi-regulator.c
index c1a41ce70b363..a04ddb1eac940 100644
--- a/drivers/regulator/qcom_spmi-regulator.c
+++ b/drivers/regulator/qcom_spmi-regulator.c
@@ -12,13 +12,13 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/ktime.h>
 #include <linux/regulator/driver.h>
 #include <linux/regmap.h>
 #include <linux/list.h>
-#include <linux/mfd/syscon.h>
 #include <linux/io.h>
 
 /* Pin control enable input pins. */
@@ -1335,6 +1335,14 @@ static irqreturn_t spmi_regulator_vs_ocp_isr(int irq, void *data)
 
 static struct regmap *saw_regmap;
 
+static const struct regmap_config saw_regmap_config = {
+	.name = "saw",
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.use_raw_spinlock = true,
+};
+
 static void spmi_saw_set_vdd(void *data)
 {
 	u32 vctl, data3, avs_ctl, pmic_sts;
@@ -2504,7 +2512,8 @@ static int qcom_spmi_regulator_probe(struct platform_device *pdev)
 	const char *name;
 	struct device *dev = &pdev->dev;
 	struct device_node *node = pdev->dev.of_node;
-	struct device_node *syscon, *reg_node;
+	struct device_node *saw, *reg_node;
+	void __iomem *saw_base;
 	struct property *reg_prop;
 	int ret, lenp;
 	struct list_head *vreg_list;
@@ -2523,12 +2532,22 @@ static int qcom_spmi_regulator_probe(struct platform_device *pdev)
 	if (!reg)
 		return -ENODEV;
 
-	syscon = of_parse_phandle(node, "qcom,saw-reg", 0);
-	if (syscon) {
-		saw_regmap = syscon_node_to_regmap(syscon);
-		of_node_put(syscon);
-		if (IS_ERR(saw_regmap))
-			dev_err(dev, "ERROR reading SAW regmap\n");
+	saw = of_parse_phandle(node, "qcom,saw-reg", 0);
+	if (saw) {
+		saw_base = devm_of_iomap(dev, saw, 0, NULL);
+		of_node_put(saw);
+		if (IS_ERR(saw_base))
+			return dev_err_probe(dev, PTR_ERR(saw_base),
+					     "failed to map the SAW\n");
+
+		saw_regmap = devm_regmap_init_mmio(dev, saw_base,
+						   &saw_regmap_config);
+		if (IS_ERR(saw_regmap)) {
+			ret = PTR_ERR(saw_regmap);
+			saw_regmap = NULL;
+			return dev_err_probe(dev, ret,
+					     "failed to set the SAW regmap up\n");
+		}
 	}
 
 	for (; reg->name; reg++) {
-- 
2.53.0



