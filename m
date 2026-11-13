Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590759;
	b=R8aK1F5CKlyAx3/PyBkvq1kEK7sP2H8Q70ExrIUpLWgPz32px5G32JIRGJqRYqTdx3MW
	 776PEidzQ4ONWKVVWj+mTC6Jy6n+pfGFmCvdQUDCEnE9X5bMXUVX6QxPwUhNV4jOpT45P
	 dupJhwqMphAX14KF4d6KeBNI5eYUg2f4qWfXzQFptq6pA5KHAg3Mmk74WifxmZCN6gmCR
	 l6WzrM6rwFIDL6fJlBveIHvdu/4yIq0FWBnezJjrWjCLhawpaj91kGkSwHJZw4fdedtd5
	 FD8JNk9x7E37KpR9fxsjU0St1LWL7zJ4r7QQWghYYRXQvHE/3zfJSrHh5U5/vrKsayQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vx5TeAGMHHRXzBUv+E/YYX9NEWXNXBJZzAUhMG7EYVc=;
	b=2v/9Oob24k4dFA5Dr4+9jHMU6yWhch2ejHqQlQWX7Qe74+vjJUU2zvfqmqJYhBQbYeGd
	 416jkeKS2KqKVkHa7aGMrd1nOwAaN8P+JK6C7gMq3f4eJOsbWNEsgvn5+pPmMKpfFk2iq
	 zt9HQBLxPSbG3nStmunBWwMSXR2u9VRPyDmDtWBJ5QWBRgViLFQeBIHAqjXiWzjhyhxef
	 EAdBTve/7xCYiBNhdIjdrx8zFPMrrajKPbuKFxtOuha5/tDPzqVJ/PCqFHN/SmCM/NOfY
	 DMEFwjC7zxgklXV6RQZEJLPv2ggb/Tb0hXpKAtuhlZLe7JXhDTKd6aGJF2ZQA0SYElg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiFM0FP3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F147B607C34F;
	Fri, 13 Nov 2026 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiFM0FP3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CB71F000C4;
	Fri, 13 Nov 2026 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590758;
	bh=vx5TeAGMHHRXzBUv+E/YYX9NEWXNXBJZzAUhMG7EYVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiFM0FP3BpbKwPQyJT030MY3WsBYafo3q7NMBqoq7eSpRQypPJlttiF4J4IRzbZqb
	 i44C786Bys0bsix7ga4R6u5x9SxbR3PTVtSHHTIA6lVk0DrdNksFKdh5rF874j4Kf5
	 Ce4/ukXO0xWTrUMryzrhXYJqOED2MUT4hiv4MV7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 659/686] PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register
Date: Fri, 13 Nov 2026 10:53:12 -0500
Message-ID: <20261113153844.057592208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a77d7cde4524b..f2e2dbae050b2 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -568,6 +568,8 @@ int dw_pcie_prog_outbound_atu(struct dw_pcie *pci,
 		/* The data-less messages only for now */
 		val |= PCIE_ATU_INHIBIT_PAYLOAD | atu->code;
 	}
+	if (dw_pcie_ver_is_ge(pci, 460A))
+		val |= PCIE_ATU_DMA_BYPASS;
 	dw_pcie_writel_atu_ob(pci, atu->index, PCIE_ATU_REGION_CTRL2, val);
 
 	/*
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index aa27211b68dd1..c01634c0211fd 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -173,6 +173,7 @@
 #define PCIE_ATU_ENABLE			BIT(31)
 #define PCIE_ATU_BAR_MODE_ENABLE	BIT(30)
 #define PCIE_ATU_CFG_SHIFT_MODE_ENABLE	BIT(28)
+#define PCIE_ATU_DMA_BYPASS		BIT(27)
 #define PCIE_ATU_INHIBIT_PAYLOAD	BIT(22)
 #define PCIE_ATU_FUNC_NUM_MATCH_EN      BIT(19)
 #define PCIE_ATU_LOWER_BASE		0x008
-- 
2.53.0



