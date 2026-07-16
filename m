Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0577E319601;
	Thu, 16 Jul 2026 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210780; cv=none; b=oq2p3rzjALHdhOmXfAlQb5inJzAPdDPs3tSSivQwVHTtwK9kK082jsTUN5XZtaJ6UtisMvPbrUz9G+N5g4SOljbrUqCL8q4TtWbnDaHy4o4bVltnU85UuCFDCj4Iu+wDqH3pXrmFGQjOsqNND1mrChVur/g1So78qgy1VjoXHlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210780; c=relaxed/simple;
	bh=udme3U3X6Z+u6mmOBjGGe2f3/rguonQ/BaPDZhBekXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz5vtqP3Vw5jK+4TsV3HGKk2VRxudYxtANrXkcaNqQlNkd2Uzfmm3Xg3weognC0zmFePb+4dDGTf8vRCGYkMd1YfZdhdbnQo2KR1CBYo8AwXYAnV1fYodfMRARjW/zETbqWO2zdGTHqKamaLBYYtqleTCxm5WU33mQ8FLueDdqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8HVzJzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8HVzJzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE4E1F00A3A;
	Thu, 16 Jul 2026 14:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210778;
	bh=cAfC5b1aYN0Id6XJjgUa/8MLjEBaOV+Ddy6HEfIssfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8HVzJzhpciVxF3iK6lCfLA9rzDzUs9aNsiaduPAo5ETKtWWS+f4ZqkVRFjMl3e4W
	 6iP5bOubNoM+sikIohZ4ZeA+YXRaVZ1bxQK4b601XH87glHnmklrca5GvvgVfII+kx
	 u4wH+XHFApEY/XLciEcJ2LP8yETNV70vkOrCdCn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 140/480] PCI: imx6: Fix IMX6SX_GPR12_PCIE_TEST_POWERDOWN handling
Date: Thu, 16 Jul 2026 15:28:07 +0200
Message-ID: <20260716133047.741100880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

commit aad953fb4eed0df5486cd54ccad80ac197678e01 upstream.

The IMX6SX_GPR12_PCIE_TEST_POWERDOWN bit does not control the PCIe
reference clock on i.MX6SX. Instead, it is part of i.MX6SX PCIe core
reset sequence.

Move the IMX6SX_GPR12_PCIE_TEST_POWERDOWN assertion/deassertion into
the core reset functions to properly reflect its purpose. Remove the
.enable_ref_clk() callback for i.MX6SX since it was incorrectly
manipulating this bit.

Fixes: e3c06cd063d6 ("PCI: imx6: Add initial imx6sx support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260319090844.444987-1-hongxing.zhu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -659,14 +659,6 @@ static int imx_pcie_attach_pd(struct dev
 	return 0;
 }
 
-static int imx6sx_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
-{
-	regmap_update_bits(imx_pcie->iomuxc_gpr, IOMUXC_GPR12,
-			   IMX6SX_GPR12_PCIE_TEST_POWERDOWN,
-			   enable ? 0 : IMX6SX_GPR12_PCIE_TEST_POWERDOWN);
-	return 0;
-}
-
 static int imx6q_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
 {
 	if (enable) {
@@ -765,6 +757,9 @@ static int imx6sx_pcie_core_reset(struct
 	if (assert)
 		regmap_set_bits(imx_pcie->iomuxc_gpr, IOMUXC_GPR12,
 				IMX6SX_GPR12_PCIE_TEST_POWERDOWN);
+	else
+		regmap_clear_bits(imx_pcie->iomuxc_gpr, IOMUXC_GPR12,
+				  IMX6SX_GPR12_PCIE_TEST_POWERDOWN);
 
 	/* Force PCIe PHY reset */
 	regmap_update_bits(imx_pcie->iomuxc_gpr, IOMUXC_GPR5, IMX6SX_GPR5_PCIE_BTNRST_RESET,
@@ -1852,7 +1847,6 @@ static const struct imx_pcie_drvdata drv
 		.mode_off[0] = IOMUXC_GPR12,
 		.mode_mask[0] = IMX6Q_GPR12_DEVICE_TYPE,
 		.init_phy = imx6sx_pcie_init_phy,
-		.enable_ref_clk = imx6sx_pcie_enable_ref_clk,
 		.core_reset = imx6sx_pcie_core_reset,
 		.ops = &imx_pcie_host_ops,
 	},


