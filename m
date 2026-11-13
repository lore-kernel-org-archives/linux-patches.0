Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585934;
	b=28/MiAaoqSrE2tXcnC1k2pLr2F7n7ZaE2g7EVsKO5YuoXbxnzqID0BfFKngq1Kai0R/P
	 g1ZFH0FBSIlQUXoO9WOaDJWtcIVpCuxiRplz7yZcIgk+Ar2Yzp369Y/nOSBAAwX4Npxw3
	 7SWWVuviN/5Pg6m5Mw7kDL+rNt4Hti0F2UtdDdSRoJRM//RQaNjT5CN5jtZJsdYDK3gi8
	 9RjwuqajPTVCFbFLgAhyKje9i6thanDCSVdUx6w27byARE16LQ+rfL7HnuE7hyKAGyUB4
	 iloRk5XBvqE09UqRVvI8SQNviHGSWkeYCA1rjmtmC0PzXk/jWF35RimBBjZdhWbA9iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3sqg8yRR9FCKTTNDq9piqfQSLbqqkjbpEYljIXqyDN8=;
	b=mZ0LX8F/DHVdtT1BlbUjarh8UB4opwKCWuQ8XiZn/agXR7OPb81ltzCvMU20TdnkqUhN
	 Q8JiyTutLwT3RPIzGZ8X/psVVqS6UjEcIF6gbFx22pDt5K8YEHc/dRFIG9Ss1RmQlZHv7
	 622Q8afNH2QoI6j2/8ToWW80vk9JQxFyDBca9SHZatP2Fpj9qVzGHGiIiRrSYwo+NYgFx
	 Y0wLbyHPSHjPP9YjDZQFRZ/Xa1kllCHAfTA6tSmftfHYs7yNXIN4zRhhnrwX1iqsfFLCw
	 sMItaZFrpRfIPcWyGzKWNJS7PUNCXwygMb3i3EH2h5y2tllkbDTVUipCJuU1UzLyzAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8UOnJPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013926070FC2;
	Fri, 13 Nov 2026 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8UOnJPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA6F1F000C4;
	Fri, 13 Nov 2026 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585933;
	bh=3sqg8yRR9FCKTTNDq9piqfQSLbqqkjbpEYljIXqyDN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8UOnJPEcGw8JqadUQ1TfmFxKtW+nez7sngBKxm31GglJ+rVdVw9BfMwlJ0SWubqv
	 6si2e1hHTmuRrdhobRwLYl5wcpxLWNucXuJ5Q1oy3+luPZt9WjcIrpeN01VF8ShOli
	 Enm48G4BysYbAgc97IIR+SutreM/CEPREOXMlkN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 491/507] PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register
Date: Fri, 13 Nov 2026 10:53:15 -0500
Message-ID: <20261113153813.711528927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted ATU_* register macros to the existing PCIE_ATU_* naming convention. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 2 ++
 drivers/pci/controller/dwc/pcie-designware.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 593388f29bdd4..9297d0e607e3a 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -577,6 +577,8 @@ int dw_pcie_prog_outbound_atu(struct dw_pcie *pci,
 		/* The data-less messages only for now */
 		val |= PCIE_ATU_INHIBIT_PAYLOAD | atu->code;
 	}
+	if (dw_pcie_ver_is_ge(pci, 460A))
+		val |= PCIE_ATU_DMA_BYPASS;
 	dw_pcie_writel_atu_ob(pci, atu->index, PCIE_ATU_REGION_CTRL2, val);
 
 	/*
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 0735ae9409240..668a5ba1c6f59 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -201,6 +201,7 @@
 #define PCIE_ATU_ENABLE			BIT(31)
 #define PCIE_ATU_BAR_MODE_ENABLE	BIT(30)
 #define PCIE_ATU_CFG_SHIFT_MODE_ENABLE	BIT(28)
+#define PCIE_ATU_DMA_BYPASS		BIT(27)
 #define PCIE_ATU_INHIBIT_PAYLOAD	BIT(22)
 #define PCIE_ATU_FUNC_NUM_MATCH_EN      BIT(19)
 #define PCIE_ATU_LOWER_BASE		0x008
-- 
2.53.0



