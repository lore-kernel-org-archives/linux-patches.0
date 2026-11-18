Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059802;
	b=Tc2CzGLGqrg2d1cZR7sLXjHAmAbQ87rmW+Cji7uqqXMRBRfQCOcrQCw9KSdh7eSonQw2
	 L4NvuxtW1yel79NP8lgeEj+/jXU51XXiDl/NbWfaT9/hQ3Tk4sWFciN2i8qjmantd1101
	 2dqP81CKCKAldZleRNzdCUvqjsbC0aUBGFuq/BIiztimrqjAXh5yIMiR0+sqhZpg0d4cT
	 +/Lyg6kYGKzD+YcDvufNvLxsqiGiOrchrG7w1RSvFGTI3mIIeRzfkRZZRaqBzpDn75a9W
	 h+wc9F2Z4mdUbHqCRFc4g/+A3AuPUlt7fZyhEtxcLZX83s5YNSDcJTvyFH2kFQxXMeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfQaLo65dsKhSXitK2YH9b4mF5mWwcIQjBw37wIj7pM=;
	b=b5YOOSShQydodUFjXMSsvtPt0By49mEF76bGZd4A7AmScLDjt5mukp8zWSEECCovAwHJ
	 vgTkpCpvLngEnDpGWHH1uzC7bRiSgO+6QbkdlDuNTHDcrtoHx4k9aMWq3M5NEQmRHjk0D
	 97UCuCKInYVaXWlWWHJ0P4AZAmuBt78qWtpRxAUkIFi1VFpp7eIlHSEo/WeHk1tUHqXPe
	 K7vbo/ktiPj/mYcHWqNtTBxx52ZJTI1tEnlNY/EOMVAh6SirS7YWGeM+KwlsThi2HPMbM
	 KUHhW2t2y702p5mOTp8/s1lWI6X3X8ig65O8NLfsQ3+9fOlS2d4sB4LIEEIht4eYY2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eRJ4Gkxh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA53606A325;
	Thu, 19 Nov 2026 03:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eRJ4Gkxh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BCA1F000C4;
	Thu, 19 Nov 2026 03:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059802;
	bh=YfQaLo65dsKhSXitK2YH9b4mF5mWwcIQjBw37wIj7pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRJ4Gkxh1/Vp1zYX3zQx0dCO5gQDL5fGgCo7OKDaIcNz9tS1VXs2kmDypKq3Gm+QW
	 OVaaBdhXxpUyUSyXhn/eZlE2b9eOsH9xCagT+VziGcWL6BaUEBZYRUjwavv1fFhkMM
	 XrUwaVvMWA+DOg5kV69zg/dxIdO2EASe0AK+dPo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0970/1848] PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register
Date: Wed, 18 Nov 2026 15:50:08 +0100
Message-ID: <20261118145957.556861158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted unified outbound iATU programming to separate viewport and unrolled paths with a numeric version check only in the viewport path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 7 +++++--
 drivers/pci/controller/dwc/pcie-designware.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 28945351da14f..27e4020ef1774 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -248,7 +248,7 @@ static void dw_pcie_prog_outbound_atu_unroll(struct dw_pcie *pci, u8 func_no,
 	dw_pcie_writel_ob_unroll(pci, index, PCIE_ATU_UNR_REGION_CTRL1,
 				 type | PCIE_ATU_FUNC_NUM(func_no));
 	dw_pcie_writel_ob_unroll(pci, index, PCIE_ATU_UNR_REGION_CTRL2,
-				 PCIE_ATU_ENABLE);
+				 PCIE_ATU_ENABLE | PCIE_ATU_DMA_BYPASS);
 
 	/*
 	 * Make sure ATU enable takes effect before any subsequent config
@@ -294,7 +294,10 @@ static void __dw_pcie_prog_outbound_atu(struct dw_pcie *pci, u8 func_no,
 			   upper_32_bits(pci_addr));
 	dw_pcie_writel_dbi(pci, PCIE_ATU_CR1, type |
 			   PCIE_ATU_FUNC_NUM(func_no));
-	dw_pcie_writel_dbi(pci, PCIE_ATU_CR2, PCIE_ATU_ENABLE);
+	val = PCIE_ATU_ENABLE;
+	if (pci->version >= 0x460A)
+		val |= PCIE_ATU_DMA_BYPASS;
+	dw_pcie_writel_dbi(pci, PCIE_ATU_CR2, val);
 
 	/*
 	 * Make sure ATU enable takes effect before any subsequent config
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 2dfeec79c6718..9766032dac942 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -92,6 +92,7 @@
 #define PCIE_ATU_CR2			0x908
 #define PCIE_ATU_ENABLE			BIT(31)
 #define PCIE_ATU_BAR_MODE_ENABLE	BIT(30)
+#define PCIE_ATU_DMA_BYPASS		BIT(27)
 #define PCIE_ATU_FUNC_NUM_MATCH_EN      BIT(19)
 #define PCIE_ATU_LOWER_BASE		0x90C
 #define PCIE_ATU_UPPER_BASE		0x910
-- 
2.53.0



