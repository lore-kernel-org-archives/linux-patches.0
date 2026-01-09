Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552D633372B;
	Fri,  9 Jan 2026 12:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962268; cv=none; b=p/Sp1bUFWD/yOtpy4dahapLY6I+UHnu8lssxAXyZR54U2URlYiVgGIxtDqkflFKvGIAp7856Ww015e+bM8F+n+Uq1vh76FiPuGwj7f2+EXKPq+1Rgg4jnu9L4CF51RISkdBWZvzUT3xIP6PBoj3PDJjb4V/g8KSdx5aSLIgSTxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962268; c=relaxed/simple;
	bh=RGOnBfNblh0yO9+dAsgQd++7rEYDHh71wEgTMG0O1yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cbg/B/HH82cnH7vWA826pNPvXOWDTeq4vBil0hvxrsl6iucoRPDNgH2UpiF2BXhWSG398m5QerMPVevoBYdeb5FJmXGAkyruVUQcf4ng9S3MswDQ+eyoHsDo84tLtsdRYeUI5bbjyK3cDnor/HyeZzlTFcAYJZpZondN6mq5YzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaXJQApj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaXJQApj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587DFC4CEF1;
	Fri,  9 Jan 2026 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962267;
	bh=RGOnBfNblh0yO9+dAsgQd++7rEYDHh71wEgTMG0O1yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaXJQApjHLmY3/WM8DZpo+j5cAqGOi2InxQZMQ8lGvrCu6ZtJ9ywk1bMwA6E6qZp2
	 pgognLDKiaHUABp6z+tioPmI85F2lX2DBmFHqlqiiO3WbkVWAzRIkM4UzshJwIATp0
	 vfgOFnkXBzgd4bitbbz7R8m1MdoMUknI+gOIyBx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 278/634] spi: cadence-quadspi: Add compatible for AMD Pensando Elba SoC
Date: Fri,  9 Jan 2026 12:39:16 +0100
Message-ID: <20260109112127.993363791@linuxfoundation.org>
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

From: Brad Larson <blarson@amd.com>

[ Upstream commit f5c2f9f9584353bc816d76a65c97dd03dc61678c ]

The AMD Pensando Elba SoC has the Cadence QSPI controller integrated.

The quirk CQSPI_NEEDS_APB_AHB_HAZARD_WAR is added and if enabled
a dummy readback from the controller is performed to ensure
synchronization.

Signed-off-by: Brad Larson <blarson@amd.com
Link: https://lore.kernel.org/r/20230515181606.65953-8-blarson@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org
Stable-dep-of: 1889dd208197 ("spi: cadence-quadspi: Fix clock disable on probe failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index fe537b8d87e5..ca393f3fcd90 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -40,6 +40,7 @@
 #define CQSPI_SUPPORT_EXTERNAL_DMA	BIT(2)
 #define CQSPI_NO_SUPPORT_WR_COMPLETION	BIT(3)
 #define CQSPI_SLOW_SRAM		BIT(4)
+#define CQSPI_NEEDS_APB_AHB_HAZARD_WAR	BIT(5)
 
 /* Capabilities */
 #define CQSPI_SUPPORTS_OCTAL		BIT(0)
@@ -89,6 +90,7 @@ struct cqspi_st {
 	u32			pd_dev_id;
 	bool			wr_completion;
 	bool			slow_sram;
+	bool			apb_ahb_hazard;
 };
 
 struct cqspi_driver_platdata {
@@ -983,6 +985,13 @@ static int cqspi_indirect_write_execute(struct cqspi_flash_pdata *f_pdata,
 	if (cqspi->wr_delay)
 		ndelay(cqspi->wr_delay);
 
+	/*
+	 * If a hazard exists between the APB and AHB interfaces, perform a
+	 * dummy readback from the controller to ensure synchronization.
+	 */
+	if (cqspi->apb_ahb_hazard)
+		readl(reg_base + CQSPI_REG_INDIRECTWR);
+
 	while (remaining > 0) {
 		size_t write_words, mod_bytes;
 
@@ -1717,6 +1726,8 @@ static int cqspi_probe(struct platform_device *pdev)
 			cqspi->wr_completion = false;
 		if (ddata->quirks & CQSPI_SLOW_SRAM)
 			cqspi->slow_sram = true;
+		if (ddata->quirks & CQSPI_NEEDS_APB_AHB_HAZARD_WAR)
+			cqspi->apb_ahb_hazard = true;
 
 		if (of_device_is_compatible(pdev->dev.of_node,
 					    "xlnx,versal-ospi-1.0")) {
@@ -1851,6 +1862,10 @@ static const struct cqspi_driver_platdata jh7110_qspi = {
 	.quirks = CQSPI_DISABLE_DAC_MODE,
 };
 
+static const struct cqspi_driver_platdata pensando_cdns_qspi = {
+	.quirks = CQSPI_NEEDS_APB_AHB_HAZARD_WAR | CQSPI_DISABLE_DAC_MODE,
+};
+
 static const struct of_device_id cqspi_dt_ids[] = {
 	{
 		.compatible = "cdns,qspi-nor",
@@ -1880,6 +1895,10 @@ static const struct of_device_id cqspi_dt_ids[] = {
 		.compatible = "starfive,jh7110-qspi",
 		.data = &jh7110_qspi,
 	},
+	{
+		.compatible = "amd,pensando-elba-qspi",
+		.data = &pensando_cdns_qspi,
+	},
 	{ /* end of table */ }
 };
 
-- 
2.51.0



