Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CBD476CF2;
	Tue, 21 Jul 2026 21:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667717; cv=none; b=UeMu1xc2zqvsb3TcJK1+si4jBUuNFWaXcUYadcqcZC9CEKoWiuXVwZuAi1TZWJlX0A2H2VHcFODTWbfnZxhKBKS4XDE2UULsgA93o5MpytazS3xp/N4R5LYm18eU8SFsYTZt3rXov2GX6gl28ZO9sNvzEqKMpppEEJ/1UmkCJZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667717; c=relaxed/simple;
	bh=VkyYh4m6SY1BSY+T1S7tvyJpDKiF0119E8hgfzjzsN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exjh2kr2ikS92YnmXzfN4oI4f0x3AXHq9eBqZaaClIBlplSR0T/B1jAYXjQqHR5xR3Wh5bFmsN/qO/VxQA2yue6H4Qnv6OJHtrgQ9dRvJ3WkDbZ8QdnLpKIEEetFQbi7v18YGJXANUxNzgZA+9aX59+6lUD3o7cfoamhwzswLEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWXg3ixR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWXg3ixR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF391F000E9;
	Tue, 21 Jul 2026 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667715;
	bh=LvNZWVS/+K3Wtkdc05ciRvwRvpJHZHJxhaJW9R5l+Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWXg3ixRlCWeZV5OmZuiQy0h0a9byXGsJ9K7dRo0Bjx0PkboNs+kXb4+vQ76e+Jvk
	 OkiDdDMsGLmQNBYuktaVtMmgNe3DFYV1ktRojOQkX7SFOCTQXRxWyPOHdBIu4rF3nf
	 4xAGjU+auz/gIcX9CBGUg3XwyDa7rNmNL/v8wqIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1167/1266] PCI: imx6: Fix IMX6SX_GPR12_PCIE_TEST_POWERDOWN handling
Date: Tue, 21 Jul 2026 17:26:44 +0200
Message-ID: <20260721152507.899055471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pci/controller/dwc/pci-imx6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -560,8 +560,6 @@ static int imx6_pcie_enable_ref_clk(stru
 
 	switch (imx6_pcie->drvdata->variant) {
 	case IMX6SX:
-		regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR12,
-				   IMX6SX_GPR12_PCIE_TEST_POWERDOWN, 0);
 		break;
 	case IMX6QP:
 	case IMX6Q:
@@ -733,6 +731,8 @@ static int imx6_pcie_deassert_core_reset
 		imx7d_pcie_wait_for_phy_pll_lock(imx6_pcie);
 		break;
 	case IMX6SX:
+		regmap_clear_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR12,
+				  IMX6SX_GPR12_PCIE_TEST_POWERDOWN);
 		regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR5,
 				   IMX6SX_GPR5_PCIE_BTNRST_RESET, 0);
 		break;


