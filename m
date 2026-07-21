Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE44B44AB73;
	Tue, 21 Jul 2026 21:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670506; cv=none; b=RF/C9uSYVs3Mm1TkFGkEfGcDAKybdPF/q6r7LaVnSTZXzucUaKsR34/tK2Pfvy8HGrd3ZtoNmamIslLL2okho9TP1TTO0sj/GMSr4ERyy+3ijHLmFf8fWmXbV58BVWCPh41utw32v5rfpcc3PzhIF9Ne/bF2JCRGxozHcGra8dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670506; c=relaxed/simple;
	bh=rAhBJMB2rHvdsdGiIO8df2lmqH6ImfGqFvjKmCCjkTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmfTFtM/YirhOEWjyv7MHX3g2dUb9BDOar095FyxWwbpX9d0Y7aByOhSh4sNJTmbO3Iz96P8Lz2gv8LA+MY7jG/J4xsbMcLbqLqp4SLFtvPUQbDkUH7JcaHzF+GjdT98H8WXuCNjvV7o62BVDYbMZB979WNHMcxlg728kkqDLco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVF6Yjjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVF6Yjjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033C31F00A3A;
	Tue, 21 Jul 2026 21:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670505;
	bh=oK8UWlBFbq6KJTI5ohdMNyIEVgwnGQ+mB65NcbqCRAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVF6Yjjdhbl7nM+9wq8JApOBc7/joOQeu9lVFnQCG9MDNX4KVlFjYmV+q2Lr8Dyjx
	 3oWL8ZSeBe6vh29SXns4PQjhCQBUBM/xJZ+L6v/6G80d01k5rvt+yWJCeiNtIy9mif
	 qaK2AMmsQK7r0qT15jiD4qZ8VVJ7cUjLZMxKY6TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0958/1067] PCI: imx6: Fix IMX6SX_GPR12_PCIE_TEST_POWERDOWN handling
Date: Tue, 21 Jul 2026 17:25:59 +0200
Message-ID: <20260721152445.972087559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -539,9 +539,6 @@ static int imx6_pcie_enable_ref_clk(stru
 			dev_err(dev, "unable to enable pcie_axi clock\n");
 			break;
 		}
-
-		regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR12,
-				   IMX6SX_GPR12_PCIE_TEST_POWERDOWN, 0);
 		break;
 	case IMX6QP:
 	case IMX6Q:
@@ -740,6 +737,8 @@ static int imx6_pcie_deassert_core_reset
 		imx7d_pcie_wait_for_phy_pll_lock(imx6_pcie);
 		break;
 	case IMX6SX:
+		regmap_clear_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR12,
+				  IMX6SX_GPR12_PCIE_TEST_POWERDOWN);
 		regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR5,
 				   IMX6SX_GPR5_PCIE_BTNRST_RESET, 0);
 		break;


