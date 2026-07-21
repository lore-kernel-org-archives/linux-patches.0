Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5383382385;
	Tue, 21 Jul 2026 22:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674630; cv=none; b=JyJM/frUden2bRZRsZbNLzoH9A1kCpCPD6QuF7Y1NP9ZhKsqw38hX4WhVbybWpZyfP04+AEj3l9e3FLDfX+kBzzgh79hPMk1KR7iJIW67WngBjLbRiRGOHB0qos6Yu1Todcs5qUj41mb3D1YfMvlluA3sNHr4x3FnkUCEOBzZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674630; c=relaxed/simple;
	bh=0L9gu0aBwPtnFugtN5e5/Cve5DHRVm8A1jizSzltHzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo6b83n0n4RtC5zaqYfYvo+WQnPg/KzQ1y9fTXZ4cIgdli/HHKa1cNLniVi8g4gDHS2VIg82Xlst8nEBBAybqyJzMKWsSQTTwilY/cT85Ddo7J3ab82w4X3T56QF+tb7ZdVzX1kMwysCZWAUxGcip92R8olgYHc32B/XG85MMzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sY2bdrIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sY2bdrIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28201F00A3A;
	Tue, 21 Jul 2026 22:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674629;
	bh=QCPBtz35UUIESaxRARsfUyr2cWwwOvE97LJLA4d/Ds0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sY2bdrIb3x7eDM1S7l8sQ/d9ubxKUOmNq0UrXctDs7HHybWOmrp96eHoT4op3VZTb
	 h0PCdjXKNc/aM1KISvTvx/QAxJsfhjKQ51+9zZGv7a+o/rzLrjnjDBL3RUMIWBm4M/
	 cnE+boe+BHLdCVmI9VaPczojNW6AoEnowDhVjS08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 613/699] PCI: imx6: Fix IMX6SX_GPR12_PCIE_TEST_POWERDOWN handling
Date: Tue, 21 Jul 2026 17:26:12 +0200
Message-ID: <20260721152409.571385795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit aad953fb4eed0df5486cd54ccad80ac197678e01 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -428,9 +428,6 @@ static int imx6_pcie_enable_ref_clk(stru
 			dev_err(dev, "unable to enable pcie_axi clock\n");
 			break;
 		}
-
-		regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR12,
-				   IMX6SX_GPR12_PCIE_TEST_POWERDOWN, 0);
 		break;
 	case IMX6QP:
 	case IMX6Q:
@@ -557,6 +554,8 @@ static void imx6_pcie_deassert_core_rese
 		imx7d_pcie_wait_for_phy_pll_lock(imx6_pcie);
 		break;
 	case IMX6SX:
+		regmap_clear_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR12,
+				  IMX6SX_GPR12_PCIE_TEST_POWERDOWN);
 		regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR5,
 				   IMX6SX_GPR5_PCIE_BTNRST_RESET, 0);
 		break;


