Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF68148314;
	Fri,  6 Dec 2024 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497676; cv=none; b=Yxqto6oeWVFxpeL8oD0COeo3pJS1Dw4w8kZG5sKI4teWeE/bgZnnd3NaKXJBOjkW2Kh8bxgEyOfnM4iXTqvO4lOCkI0tDNJa7bP3UtmyoRD1h/eNWd/Xonc1C/VLMxzdzwgoIR1cRvZncnhpA+zIDtKs+zoC5/GRfxzY7l7GjyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497676; c=relaxed/simple;
	bh=ZRxK5eHidJnrajlN1yxxUo9Pw8HL2dT3ebF3KrKopeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hF0QNI+nS06GL2Vt+uo+j6F2PIbDcx134FJe1wwfGFV18RIu7daM/owWZnlvM3+WFGgUcGmW6B+egFW3TfbqrULQOO3UReAf7Sz24EfBVA4xWZC5Jn2jQpEQguQmRTCPDjBXefuQsDZ3TNCl3+IFEbk4b3h1KZO8tuxoKTPyuNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZ45fvi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZ45fvi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030FDC4CED1;
	Fri,  6 Dec 2024 15:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497676;
	bh=ZRxK5eHidJnrajlN1yxxUo9Pw8HL2dT3ebF3KrKopeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZ45fvi/pML0EAdL2Szhd1exbpmU3zhxSjJVV620go4bGgz7ag5bxyTFxNfBNuu/5
	 LH8LJCq2tiP+5JaLbTcJrJyU1VcWPcsZg7OsF3UIgTm6mNnUbl9oA/gx8d9RGkefSA
	 TW+6WJG1MPUxjTi5bpOpIEEVqHwguKU+eSSoUERk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Ranostay <mranostay@ti.com>,
	Achal Verma <a-verma1@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 360/676] PCI: j721e: Add PCIe 4x lane selection support
Date: Fri,  6 Dec 2024 15:32:59 +0100
Message-ID: <20241206143707.409859503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Ranostay <mranostay@ti.com>

[ Upstream commit 4490f559f75514d5a6f0e729e85235a7be6216bf ]

Add support for setting of two-bit field that allows selection of 4x lane
PCIe which was previously limited to only 2x lanes.

Link: https://lore.kernel.org/linux-pci/20231128054402.2155183-5-s-vadapalli@ti.com
Signed-off-by: Matt Ranostay <mranostay@ti.com>
Signed-off-by: Achal Verma <a-verma1@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Stable-dep-of: 22a9120479a4 ("PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 63c758b14314d..645597856a1d9 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -42,7 +42,6 @@ enum link_status {
 };
 
 #define J721E_MODE_RC			BIT(7)
-#define LANE_COUNT_MASK			BIT(8)
 #define LANE_COUNT(n)			((n) << 8)
 
 #define GENERATION_SEL_MASK		GENMASK(1, 0)
@@ -52,6 +51,7 @@ struct j721e_pcie {
 	struct clk		*refclk;
 	u32			mode;
 	u32			num_lanes;
+	u32			max_lanes;
 	void __iomem		*user_cfg_base;
 	void __iomem		*intd_cfg_base;
 	u32			linkdown_irq_regfield;
@@ -205,11 +205,15 @@ static int j721e_pcie_set_lane_count(struct j721e_pcie *pcie,
 {
 	struct device *dev = pcie->cdns_pcie->dev;
 	u32 lanes = pcie->num_lanes;
+	u32 mask = BIT(8);
 	u32 val = 0;
 	int ret;
 
+	if (pcie->max_lanes == 4)
+		mask = GENMASK(9, 8);
+
 	val = LANE_COUNT(lanes - 1);
-	ret = regmap_update_bits(syscon, offset, LANE_COUNT_MASK, val);
+	ret = regmap_update_bits(syscon, offset, mask, val);
 	if (ret)
 		dev_err(dev, "failed to set link count\n");
 
@@ -441,7 +445,9 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 		dev_warn(dev, "num-lanes property not provided or invalid, setting num-lanes to 1\n");
 		num_lanes = 1;
 	}
+
 	pcie->num_lanes = num_lanes;
+	pcie->max_lanes = data->max_lanes;
 
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48)))
 		return -EINVAL;
-- 
2.43.0



