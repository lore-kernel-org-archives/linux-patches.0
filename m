Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B791D86ED;
	Thu, 17 Apr 2025 18:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915501; cv=none; b=BS9JToPkHjzTI20NYVYz68MBHAL2uyKbHX+TISLabrO7rdRO5gudteE15z/FA+Y7v59xcOpBjZlnRzQ+gScYFoFbVUfGndYWXuI8eA7a8bELWp0GypNF+kt45MnhCfv2bkEtZyeeAqtRjWiUWVIEQgaBK1mofAlMGry5dUgcPAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915501; c=relaxed/simple;
	bh=gLd35BUzjPiz02ks6iXp6Vi7nYo5RvGIOpn9BZEB+p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVCMFrGIc6AJktIFlwePbnqrq6z686kHKJSNlIBQ9mc7DjhEBchAyk7r0uP7NOlDGPkjGOXZTME5NaTpbN+EjWAfbadPExcMt3wl6SJ5e7Au2bubfKcCLtB4vTC1LU2IA7lyL51at8sjEHkxRDxn6Gnzat7zGhvBEmsUh7cTXFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5x2Tn1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5x2Tn1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD16C4CEE4;
	Thu, 17 Apr 2025 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915501;
	bh=gLd35BUzjPiz02ks6iXp6Vi7nYo5RvGIOpn9BZEB+p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5x2Tn1DiZBC3RfmV1sR616yucZIzyuBu4szr23s823VPigvTkPTD/HFr78jOz8iU
	 MBOEBkp3yxFm/pXAd9wjrJf4b3gUrPQqjyIXhXRgvetFhP/kJheA4i62jVsZUYAum6
	 TJNHxm8VWwoPKWCk4ByRoJbdmMT5u6U+vjJ31mIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Niklas Cassel <cassel@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/393] PCI: Add Rockchip Vendor ID
Date: Thu, 17 Apr 2025 19:49:16 +0200
Message-ID: <20250417175113.493174150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 20bbb083bbc9d3f8db390f2e35e168f1b23dae8a ]

Move PCI_VENDOR_ID_ROCKCHIP from pci_endpoint_test.c to pci_ids.h and
reuse it in pcie-rockchip-host.c.

Link: https://lore.kernel.org/r/20250218092120.2322784-2-cassel@kernel.org
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c            | 1 -
 drivers/pci/controller/pcie-rockchip-host.c | 2 +-
 drivers/pci/controller/pcie-rockchip.h      | 1 -
 include/linux/pci_ids.h                     | 2 ++
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 3aaaf47fa4ee2..b5c8422fd2f04 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -85,7 +85,6 @@
 #define PCI_DEVICE_ID_RENESAS_R8A774E1		0x0025
 #define PCI_DEVICE_ID_RENESAS_R8A779F0		0x0031
 
-#define PCI_VENDOR_ID_ROCKCHIP			0x1d87
 #define PCI_DEVICE_ID_ROCKCHIP_RK3588		0x3588
 
 static DEFINE_IDA(pci_endpoint_test_ida);
diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index cbec711148253..481dcc476c556 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -367,7 +367,7 @@ static int rockchip_pcie_host_init_port(struct rockchip_pcie *rockchip)
 		}
 	}
 
-	rockchip_pcie_write(rockchip, ROCKCHIP_VENDOR_ID,
+	rockchip_pcie_write(rockchip, PCI_VENDOR_ID_ROCKCHIP,
 			    PCIE_CORE_CONFIG_VENDOR);
 	rockchip_pcie_write(rockchip,
 			    PCI_CLASS_BRIDGE_PCI_NORMAL << 8,
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 15ee949f2485e..688f51d9bde63 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -188,7 +188,6 @@
 #define AXI_WRAPPER_NOR_MSG			0xc
 
 #define PCIE_RC_SEND_PME_OFF			0x11960
-#define ROCKCHIP_VENDOR_ID			0x1d87
 #define PCIE_LINK_IS_L2(x) \
 	(((x) & PCIE_CLIENT_DEBUG_LTSSM_MASK) == PCIE_CLIENT_DEBUG_LTSSM_L2)
 #define PCIE_LINK_UP(x) \
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c9dc15355f1ba..c395b3c5c05cf 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2605,6 +2605,8 @@
 
 #define PCI_VENDOR_ID_ZHAOXIN		0x1d17
 
+#define PCI_VENDOR_ID_ROCKCHIP		0x1d87
+
 #define PCI_VENDOR_ID_HYGON		0x1d94
 
 #define PCI_VENDOR_ID_META		0x1d9b
-- 
2.39.5



