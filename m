Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054127;
	b=l8/yeQEbqA8BZ2Kcnqt3ZGRxEKzokfwTOYC7e8Kx+QHGeWSOuYarY+QJ77XoowunhKpk
	 33py/8t4PJDno26fckhEeoGHbuu2ueNzXMXdOatlH+Mp+Zr/OGWviPw2ja4Nb6eAiCw/E
	 HxELbC+eyVs34E1iNz5Tt6si+PQbaGb6z/Z1ICRO29fnn4gqdjZyrKehUpVYhtVXdQcM9
	 vsE5vKIipOwN/d+QFSpgor36gT9vOPnJe4gm/Vw/v1XKb+T6wMi6g9uLyHrxDxTxYpsa1
	 N1o9a1bJREFtm9ehUmRQ5doSfrOxhu1JtEMRJxokFl3Hjj5u4NCU/KSb6rCnolVD9IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dzEyNbJnS5OSCU38S1lcguyzW5k7DO+MjQa4dC2hvTI=;
	b=1P+gV1LKSXkTdxbssQjVmCa8Z0zTjO4qg+jfPGRSwyGUZf9S+cGJXuwDm2jwmPdFzG/2
	 ZYgdXHDLOV8dU5AeBunGoxB5AgjBZlmQ8Op7IkTRpzyFTxeATcUP+mrZYPTryxxABeh3b
	 NTQYNA2aVazeW6G45ezh+HhL7t4o9BrQ6IpErSvRwIiP3xvA4s9xwA8x897uXtIbtdStj
	 OECVJhMI+8Lguw4Pj7ohDoneF2Swv2mVoUv+Gt3RI7y8KNj1oX2PntpaBUCk0K+DH3aBL
	 WW0k5N6Py1RkZjdK0sSbNt5HINQ6JG/7GKbKhuRhUjiSG5/cpJJwFom9HaGAtM5fwCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUfPA0Q1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06C1606A320;
	Thu, 19 Nov 2026 02:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUfPA0Q1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7A61F000C4;
	Thu, 19 Nov 2026 02:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054127;
	bh=dzEyNbJnS5OSCU38S1lcguyzW5k7DO+MjQa4dC2hvTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUfPA0Q1jTFe35Jm3Cs9OzMq1kY2QsX1PHiv1agRk9DhKq+yznDjBY1G8srivaJDm
	 v5xpO+lDhZSxaKOGnN6duZs0iWsd84qo4/70y8lF5UUnJ2LGLEzbEOWZWzUwZsqrRa
	 IJKpdcV3wzJh6Ll+8XKPKjb/Ue2xMSxlYOSHu0fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1165/2214] PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register
Date: Wed, 18 Nov 2026 15:47:21 +0100
Message-ID: <20261118150058.625146693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted unified outbound iATU programming to the existing separate viewport and unrolled-register paths ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 11 ++++++++---
 drivers/pci/controller/dwc/pcie-designware.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 00972a7bc9768..22fc8ee305eec 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -292,8 +292,10 @@ static void dw_pcie_prog_outbound_atu_unroll(struct dw_pcie *pci, u8 func_no,
 	if (pci->version == 0x490A)
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_ob_unroll(pci, index, PCIE_ATU_UNR_REGION_CTRL1, val);
-	dw_pcie_writel_ob_unroll(pci, index, PCIE_ATU_UNR_REGION_CTRL2,
-				 PCIE_ATU_ENABLE);
+	val = PCIE_ATU_ENABLE;
+	if (pci->version >= 0x460A)
+		val |= PCIE_ATU_DMA_BYPASS;
+	dw_pcie_writel_ob_unroll(pci, index, PCIE_ATU_UNR_REGION_CTRL2, val);
 
 	/*
 	 * Make sure ATU enable takes effect before any subsequent config
@@ -350,7 +352,10 @@ static void __dw_pcie_prog_outbound_atu(struct dw_pcie *pci, u8 func_no,
 	if (pci->version == 0x490A)
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_dbi(pci, PCIE_ATU_CR1, val);
-	dw_pcie_writel_dbi(pci, PCIE_ATU_CR2, PCIE_ATU_ENABLE);
+	val = PCIE_ATU_ENABLE;
+	if (pci->version >= 0x460A)
+		val |= PCIE_ATU_DMA_BYPASS;
+	dw_pcie_writel_dbi(pci, PCIE_ATU_CR2, val);
 
 	/*
 	 * Make sure ATU enable takes effect before any subsequent config
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 5960ae40b0f2d..4807efe73f2ef 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -91,6 +91,7 @@
 #define PCIE_ATU_CR2			0x908
 #define PCIE_ATU_ENABLE			BIT(31)
 #define PCIE_ATU_BAR_MODE_ENABLE	BIT(30)
+#define PCIE_ATU_DMA_BYPASS		BIT(27)
 #define PCIE_ATU_FUNC_NUM_MATCH_EN      BIT(19)
 #define PCIE_ATU_LOWER_BASE		0x90C
 #define PCIE_ATU_UPPER_BASE		0x910
-- 
2.53.0



