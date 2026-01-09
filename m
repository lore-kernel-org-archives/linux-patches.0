Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D708E335BCD;
	Fri,  9 Jan 2026 12:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962236; cv=none; b=i02CLTo+mJkIfvb/1vrjC91B4EIEEgF9tVljXvazoJhxyKGWmNtCt1h9XDHpTfACIKrrtrSjq6ln7prrDz1OO0sCkkgNpBeBBi50BWDiGiZCUJbD1Cmh0xOQYcljZO14LLBQy9kpFjJ4JOSwg75slyrUEFDlXnl+Yd4weUFLexU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962236; c=relaxed/simple;
	bh=a4joI7te4bnLkDaO4R0pjh3SRwTGE3wC/2zVOr0B5oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tys78/20qi7oNZ1/X8oGgxyeshWSnpvMy/jCHZ5zGLU+ZuSJXAz8N9CTYmsY8sErLypR9FVqP+26rClXKUj4/Yrjm6ZEGEIfGfIK5C3vjyv3sCidKB5ug1aV5J5GkCXJBuO2rhthUxacYip22ZbGwNcYDnBRLEQAvITxxn92zG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgC2a7l6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgC2a7l6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635F5C4CEF1;
	Fri,  9 Jan 2026 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962236;
	bh=a4joI7te4bnLkDaO4R0pjh3SRwTGE3wC/2zVOr0B5oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgC2a7l6R/HraUmRHzrgGyeIccLwcSvVhA1sbu8nwq+amQo7dAAgPidp4JBxakR8G
	 373pEenCad/+fochQmy1DpalfOVQDJWud9n/lUeIGpxxUwBsmRHj6XHYq/SQOQXIWD
	 G0dzI+XKdqNALI3fAp/YjLE4eLh/ia+kk7D/Vx+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziv Xu <ziv.xu@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 277/634] spi: cadence-quadspi: Add support for StarFive JH7110 QSPI
Date: Fri,  9 Jan 2026 12:39:15 +0100
Message-ID: <20260109112127.955684085@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Qiu <william.qiu@starfivetech.com>

[ Upstream commit 47fef94afeae2a125607b6b45145594713471320 ]

Add QSPI reset operation in device probe and add RISCV support to
QUAD SPI Kconfig.

Co-developed-by: Ziv Xu <ziv.xu@starfivetech.com>
Signed-off-by: Ziv Xu <ziv.xu@starfivetech.com>
Signed-off-by: William Qiu <william.qiu@starfivetech.com>
Link: https://lore.kernel.org/r/20230302105221.197421-3-william.qiu@starfivetech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1889dd208197 ("spi: cadence-quadspi: Fix clock disable on probe failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/Kconfig               |  2 +-
 drivers/spi/spi-cadence-quadspi.c | 21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 15ea11ebcbe0..834fc0b8e27e 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -230,7 +230,7 @@ config SPI_CADENCE
 
 config SPI_CADENCE_QUADSPI
 	tristate "Cadence Quad SPI controller"
-	depends on OF && (ARM || ARM64 || X86 || COMPILE_TEST)
+	depends on OF && (ARM || ARM64 || X86 || RISCV || COMPILE_TEST)
 	help
 	  Enable support for the Cadence Quad SPI Flash controller.
 
diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 3200e55136cd..fe537b8d87e5 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1586,7 +1586,7 @@ static int cqspi_setup_flash(struct cqspi_st *cqspi)
 static int cqspi_probe(struct platform_device *pdev)
 {
 	const struct cqspi_driver_platdata *ddata;
-	struct reset_control *rstc, *rstc_ocp;
+	struct reset_control *rstc, *rstc_ocp, *rstc_ref;
 	struct device *dev = &pdev->dev;
 	struct spi_master *master;
 	struct resource *res_ahb;
@@ -1679,6 +1679,17 @@ static int cqspi_probe(struct platform_device *pdev)
 		goto probe_reset_failed;
 	}
 
+	if (of_device_is_compatible(pdev->dev.of_node, "starfive,jh7110-qspi")) {
+		rstc_ref = devm_reset_control_get_optional_exclusive(dev, "rstc_ref");
+		if (IS_ERR(rstc_ref)) {
+			ret = PTR_ERR(rstc_ref);
+			dev_err(dev, "Cannot get QSPI REF reset.\n");
+			goto probe_reset_failed;
+		}
+		reset_control_assert(rstc_ref);
+		reset_control_deassert(rstc_ref);
+	}
+
 	reset_control_assert(rstc);
 	reset_control_deassert(rstc);
 
@@ -1836,6 +1847,10 @@ static const struct cqspi_driver_platdata versal_ospi = {
 	.get_dma_status = cqspi_get_versal_dma_status,
 };
 
+static const struct cqspi_driver_platdata jh7110_qspi = {
+	.quirks = CQSPI_DISABLE_DAC_MODE,
+};
+
 static const struct of_device_id cqspi_dt_ids[] = {
 	{
 		.compatible = "cdns,qspi-nor",
@@ -1861,6 +1876,10 @@ static const struct of_device_id cqspi_dt_ids[] = {
 		.compatible = "intel,socfpga-qspi",
 		.data = &socfpga_qspi,
 	},
+	{
+		.compatible = "starfive,jh7110-qspi",
+		.data = &jh7110_qspi,
+	},
 	{ /* end of table */ }
 };
 
-- 
2.51.0



