Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB0C3546D0;
	Wed, 20 May 2026 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295459; cv=none; b=h2QDclNlx/fAPwMXK23DGymzUx0npXTuGL2acphpDjvC+YuN8xgtNg1gpmRGY7TfAtGLA4ya0s1LhqntgTD1aNbAvmoZVPWP1Y7K4ABmcwSQbBLpWB1s9oYgOCjm4YOWOiE5jYosdn4qU6VVO/mvRWTgtCnLEjlhF4oN1WDPpLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295459; c=relaxed/simple;
	bh=gRIUo5pg212Jc199vx3i0d4ltsKjBjOtJWlB5cQn6Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRTimJsmhIlIqVXX3ZT9IYB7uRlrTqwwtQZfcs1UkWffho3MXvirCLsYLCJGwnO/jSk6XKa7PkKZ+zdPe69vh8adgQCB16jQYMjiaf9LbbZ3oy6Tjt9W4C/5bVSlL8V3IL6bgeP3FH2ne+s9+rnVp5gBImlJ8l4Vub1K4EEqH74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPASWzb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPASWzb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E82E1F000E9;
	Wed, 20 May 2026 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295458;
	bh=S000xFagXmAT/zVgsX7To2bM2zFmUs30sEZTBr3IAPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPASWzb3eVp22YHX9B3xURHeEx+XMZOz5HaoIt+6I/PDTT50fnXMZd/FY5rrYzfjA
	 7rspyIE97QX1MjlLcQXwMoIXNlb1b7jvbstpbg/4l1DRWCqEGRy9+b7wrkLyjqjvJo
	 U+o4dvHfh2cb77Ls7pBtn4k+R47p1NUHJVr9XyCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vidya Sagar <vidyas@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0425/1146] PCI: tegra194: Use DWC IP core version
Date: Wed, 20 May 2026 18:11:15 +0200
Message-ID: <20260520162157.810524052@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Maddireddy <mmaddireddy@nvidia.com>

[ Upstream commit ea60ca067f0f098043610c96a915d162113c1aac ]

Tegra194 PCIe driver used custom version numbers to detect Tegra194 and
Tegra234 IPs. With version detect logic added, version check results in
mismatch warnings:

  tegra194-pcie 14100000.pcie: Versions don't match (0000562a != 3536322a)

Use HW version numbers which match to PORT_LOGIC.PCIE_VERSION_OFF in
Tegra194 driver to avoid these kernel warnings.

Fixes: a54e19073718 ("PCI: tegra194: Add Tegra234 PCIe support")
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-12-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.h | 2 ++
 drivers/pci/controller/dwc/pcie-tegra194.c   | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index b12c5334552c7..3e69ef60165b0 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -34,8 +34,10 @@
 #define DW_PCIE_VER_470A		0x3437302a
 #define DW_PCIE_VER_480A		0x3438302a
 #define DW_PCIE_VER_490A		0x3439302a
+#define DW_PCIE_VER_500A		0x3530302a
 #define DW_PCIE_VER_520A		0x3532302a
 #define DW_PCIE_VER_540A		0x3534302a
+#define DW_PCIE_VER_562A		0x3536322a
 
 #define __dw_pcie_ver_cmp(_pci, _ver, _op) \
 	((_pci)->version _op DW_PCIE_VER_ ## _ver)
diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 3527a4e82bac8..688da5a73d02e 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -35,8 +35,8 @@
 #include <soc/tegra/bpmp-abi.h>
 #include "../../pci.h"
 
-#define TEGRA194_DWC_IP_VER			0x490A
-#define TEGRA234_DWC_IP_VER			0x562A
+#define TEGRA194_DWC_IP_VER			DW_PCIE_VER_500A
+#define TEGRA234_DWC_IP_VER			DW_PCIE_VER_562A
 
 #define APPL_PINMUX				0x0
 #define APPL_PINMUX_PEX_RST			BIT(0)
-- 
2.53.0



