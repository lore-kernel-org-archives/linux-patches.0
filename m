Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038632;
	b=iL4/I2f/Gbax46sly90uri/ZqI7+XzNckoKHFrOazvRyrHahGokXRrBNiwNIaN3eYB8l
	 MPzWwFO4VlsJBArw6zPVEpROEX0lpDK9ndMgNyDGSnppoLrAyT973dnQ+dyB+myoia8h5
	 aUdoU7I48gOZsRJRRyW+x7gBty154NpR3RQa19EwZ3puaXR3ATccgowK3Dhz/Zy8BMHsC
	 mScrUQlD0mbZ5txgEnV/c8Cd2LcIUjK51lMsRI8Hrt5zhsI49HOupBFC7UkIhqwAKhEwh
	 nXJcWlytNuUIL1KWJzB6yTR2AZPCsGQIXbT0o8HySbUAreLlgNyafO+39B7xTa0q6mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vWnFWAa6IXXk01aG9XZl/LDiUksfg5m0xDd6bvQqOtM=;
	b=Vqy2Q2mkuhGWsD0VWX29Hd4Lhmy/ZUqdlLV8vCWC0bMEGyB4S0Wfhytzjf9bI6XWybSF
	 IIoTzlF07D9ypY17dJX863Thni3rk7I6fPdL4OBEthWiY4cc4DT6RD4Ex0zz7dnLztAkA
	 4cvc1Wkq9/XX1cJ9MakoYPa+iEGj2WCwTvsmMy5iE0GGmtl83s9X9ZxGwIMCKHC2kpAJP
	 T62SKFAPG9zesPhR2nZ0W4Tl+ikJiQ3Gm1TbTg9ejJAJmCqvWAjpq5RMAj69/SMBNUmmV
	 FjdsLmPhw9J9EWLuaD8vgs1wkZH+qT+C5iHXtsTpvMElk+CeadtT1TOql5vP3jLudNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5RCPP5V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1974606A320;
	Wed, 18 Nov 2026 21:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5RCPP5V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339511F000C4;
	Wed, 18 Nov 2026 21:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038632;
	bh=vWnFWAa6IXXk01aG9XZl/LDiUksfg5m0xDd6bvQqOtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5RCPP5V27jOetYJRw8Uqfe0pJCVOOTERqpr0p5Nb2umljKMyWm5UM1w9Nu9PKKEb
	 CltEWWrZ8KEDmtD8Ttof5fqvws7xUzIIZKkuvZ7g+cXP/dxF92Z7eRk4HhE1pk234+
	 NXMt78nzsy7Z2OrAwT8FVyl+qD6vwkChyBI6GpJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1811/3318] PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register
Date: Wed, 18 Nov 2026 15:40:33 +0100
Message-ID: <20261118150416.184087293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the outbound control update to the older helper by initializing val from PCIE_ATU_ENABLE before writing CTRL2 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 5 ++++-
 drivers/pci/controller/dwc/pcie-designware.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 504450a8b6a45..86326116d85ca 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -506,7 +506,10 @@ static int __dw_pcie_prog_outbound_atu(struct dw_pcie *pci, u8 func_no,
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_atu_ob(pci, index, PCIE_ATU_REGION_CTRL1, val);
 
-	dw_pcie_writel_atu_ob(pci, index, PCIE_ATU_REGION_CTRL2, PCIE_ATU_ENABLE);
+	val = PCIE_ATU_ENABLE;
+	if (dw_pcie_ver_is_ge(pci, 460A))
+		val |= PCIE_ATU_DMA_BYPASS;
+	dw_pcie_writel_atu_ob(pci, index, PCIE_ATU_REGION_CTRL2, val);
 
 	/*
 	 * Make sure ATU enable takes effect before any subsequent config
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 1ffa31797a17c..bb481205e23b5 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -154,6 +154,7 @@
 #define PCIE_ATU_REGION_CTRL2		0x004
 #define PCIE_ATU_ENABLE			BIT(31)
 #define PCIE_ATU_BAR_MODE_ENABLE	BIT(30)
+#define PCIE_ATU_DMA_BYPASS		BIT(27)
 #define PCIE_ATU_FUNC_NUM_MATCH_EN      BIT(19)
 #define PCIE_ATU_LOWER_BASE		0x008
 #define PCIE_ATU_UPPER_BASE		0x00C
-- 
2.53.0



