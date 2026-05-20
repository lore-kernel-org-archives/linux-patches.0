Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2E83C140F;
	Wed, 20 May 2026 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300621; cv=none; b=jdspuvncsIiIZ2RaJQPRxvbyWvXHsKHbk1hO8HHWbm65rN0rYRIkn69H9wyOyts0WRy7Kuu7KkqhcSa9N+yqwsCTlQwQMUc5oJvEXoUYVpoFISNZiIgf1B6VJdu+OUeeMpoj6XB8rGg8CdBcMGiINSGtPVsn36Fj47acEAhTvJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300621; c=relaxed/simple;
	bh=DZN9Jflrokius9LNcNzjjWs1HnsVs+wZal0Zyx1rMGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3g5pNMsfCQCPL2IkR4tecaChvfNIpYid1jh+i++hEPqe/zwwWpluolLCeJeeBiJW0Q3ZqCorgQMjg77yh5TXpM1CviS8e2rXQPlvEHwGzqyIxU0gGSm2Dqu/6EqSY+WG3fMnncPuN+DQaHl/eRQc2TMp4dPopWsR0cXrg3gzis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGAK0BQR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGAK0BQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CD51F000E9;
	Wed, 20 May 2026 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300619;
	bh=WXEUKwceE2bUM+csIB1W+ulgBG9q9ZQc3/A4WxhNT9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGAK0BQRoOA39yAh6SK/r1MvTD7sO40+EBSkexPPhnJG0DNeOCS6RYqUrFMid2Fv/
	 NFLcK0iwTNiPQHJ/z9Okqk/rWXGxtN2DFpPamL9tbTAkwCVn5Wj58DiU4b6IA09Tkz
	 L3G7xVRhZl84qHw5wwtdlN3rfT1yp4nf2qXDqbHM=
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
Subject: [PATCH 6.12 243/666] PCI: tegra194: Use DWC IP core version
Date: Wed, 20 May 2026 18:17:34 +0200
Message-ID: <20260520162116.485423500@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0fad7751490f5..a5f58ac8ea941 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -31,8 +31,10 @@
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
index dd08ad8d08cbd..5faac8b7190ca 100644
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



