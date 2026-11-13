Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591594;
	b=GWz996hnDipIX+Dm9iVMIl6M1nk1KZ36wAODYqbns63vJEkhIUbJEOd8CeBcXE75rvQY
	 G91JqUQPOn4DCpqClIsbu1QD7vah0gplRdXwjkF2X3ZBBnsS8xozaDJZYUJPEFKz1TzOr
	 hwNizOXkcp+FL/DOePhNb9MR9En7sdmukCIahftSJ1AMwWZRSxgtjhaPyWZBvB4j/8Bwg
	 cUlIq0R0c4w5RkksCh262aicXnyJ1v3+4hZm1LKqvK4Lp8LccLvJmEwhmy/U/WuSyTBE8
	 a75PBnA9Y1pAVxPG0Ub+uPGmM1RCSVyZ5PXY8setGPqW3WE096E38kwLybBIJry6KYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B084hnrFeWaMXjhAYgVM55ReC3HkmSueH+8EcCDBQaw=;
	b=hA0BqzdfqkxEM8ev8oIRWl+27ZwAOfxzYMXWkGpCenDIrJDyU0Q7KP/w9fnuzXqeNb+z
	 nQ3TmnutBDDshW2Cl3Ta4PYIUF8hbTrOwSHlEtS97VPxZZ76B1f9uMqJ8Gth2glytaymT
	 CnSLQs3WTHoKGrBYuh4qBAiymfH548IpySNBGLCLeiEsuEDgO7LzqL9JIwhfycZh2O30I
	 REvn7ocpXUsycFDeUNXeLh8Fi7VUYHcY19fMTDwOHGrKWbqtyqJlBNY/YAIB1YDOgw56T
	 ZWmZSwPwPP7UlToo5kmi8vgqODvcJTxHTnwbuHcfiCN32AKIG5hX5WZqUCW/ui1aD4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=epj6IQ6S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82217606A89C;
	Fri, 13 Nov 2026 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=epj6IQ6S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1301F000C4;
	Fri, 13 Nov 2026 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591594;
	bh=B084hnrFeWaMXjhAYgVM55ReC3HkmSueH+8EcCDBQaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epj6IQ6S97dD8TiResNV2/dMmqiSYSuKaNOCezNkHOg3IcFSAVbYCmcErOVpCtbSh
	 q9uEDrxegVd8hcTe9w2XQH6qh1M56tTWmxwMoaVwl22os/giwQ+2fqR8eQ4qX6SmZP
	 lxn1RpZpNWzIyKMJN1Y2+8Z+4adEM0VsmVhq7VAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 638/670] PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register
Date: Fri, 13 Nov 2026 10:53:22 -0500
Message-ID: <20261113153833.421104273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Kumar <sumit.kumar@oss.qualcomm.com>

[ Upstream commit efadda401c5c8e2390ba66508eba154dbd0db5a9 ]

An outbound iATU region matches any local (AXI/application-side)
address that falls within its Base/Limit window and rewrites it to
the PCIe-side address programmed in that region's Target Address
Registers before the transaction goes out on the link. This matching
does not distinguish CPU-initiated transactions from ones issued by
the internal DMA engine (eDMA/HDMA).

Example: outbound region 0 is programmed with Base/Limit covering
local addresses 0x8000_0000-0x8000_0FFF and Target 0x1_0000_0000, for
CPU-initiated accesses. The DMA engine is later given a descriptor
whose destination is the host address 0x8000_0080, which happens to
fall inside region 0's Base/Limit range. The iATU matches the DMA
transaction against region 0 too and rewrites it to 0x1_0000_0080
instead of passing 0x8000_0080 through unchanged. The transaction
then lands on the wrong host address, causing data corruption or an
IOMMU fault when the rewritten address has no valid mapping.

Set the DMA_BYPASS bit (bit 27) in PCIE_ATU_REGION_CTRL2 when
programming outbound iATU regions so only CPU/AXI-initiated
transactions are matched against the region; DMA engine transactions
bypass the translation and go out on the PCIe link with their
original address.

Signed-off-by: Sumit Kumar <sumit.kumar@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260908-dma_bypass-v2-1-c3c81d408c0c@oss.qualcomm.com
[ sashal: Changed ATU_DMA_BYPASS to PCIE_ATU_DMA_BYPASS to match the existing register naming convention. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 2 ++
 drivers/pci/controller/dwc/pcie-designware.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index bc3d6269f33bc..1dad7d69de910 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -514,6 +514,8 @@ int dw_pcie_prog_outbound_atu(struct dw_pcie *pci,
 		/* The data-less messages only for now */
 		val |= PCIE_ATU_INHIBIT_PAYLOAD | atu->code;
 	}
+	if (dw_pcie_ver_is_ge(pci, 460A))
+		val |= PCIE_ATU_DMA_BYPASS;
 	dw_pcie_writel_atu_ob(pci, atu->index, PCIE_ATU_REGION_CTRL2, val);
 
 	/*
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index a5f58ac8ea941..728f15cebf9e6 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -173,6 +173,7 @@
 #define PCIE_ATU_REGION_CTRL2		0x004
 #define PCIE_ATU_ENABLE			BIT(31)
 #define PCIE_ATU_BAR_MODE_ENABLE	BIT(30)
+#define PCIE_ATU_DMA_BYPASS		BIT(27)
 #define PCIE_ATU_INHIBIT_PAYLOAD	BIT(22)
 #define PCIE_ATU_FUNC_NUM_MATCH_EN      BIT(19)
 #define PCIE_ATU_LOWER_BASE		0x008
-- 
2.53.0



