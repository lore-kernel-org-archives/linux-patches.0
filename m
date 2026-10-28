Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214666;
	b=V4dDUCK2wzFDyw6mFgz4zdm8nwTlvFUlac+z12QkkOsMH1NOUADTnc42NuQMhh64mIaN
	 9IXpSMNp7GF2o03tHNxCWhk6bl/aSY2ZbUWov7kc8Zy+S8m6i2jRXgvs51GJG6Hkt3YA/
	 92iyeVfLqb2FkNR3CJQrbKLJMbApJsm35thsECY9ig60QNp7Ml8+WIWlInr186rOtyIf/
	 PACRPTmAdGMQEjq86jT82Jph1+urbtKExgBQ1QvMUy7OPTxp/svnPVj6pCo4L7qx3ioMD
	 WUC2UG6wmj5++VdkraJvuo4bn/hFQ8YXD+tQNztNFZdhLq8fbQ+Tc+AGvH4XP0/nBJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=75jBMXRtPg95vWWYfWshUujSI4OUeV/zNIK8arzUZBM=;
	b=u/ar3PPwhp6HdiRko2WdItrIg+/4YFKAu49Vz8u/d4X+lwVgmQPgcNPWZSTkPZDPe76F
	 aXKfmPb5OwunCLYo71zuDgakEBvCDLIt6CDz5mOorh0kqNxY+ABxI/XUdK72FvctCdSzO
	 9jc0bSZ2BKtmFYM2FUY1ObWF/8Z6NvoJPlf3yrk5+PalLggKgj87lJSZhJ6GIcWpGcHTG
	 uQ8QwnILPtdLU+09ePGtMHMqZIWI9ZifzFFt5HUXCPvSInNmQXGnCEIMmOUBio9SunB14
	 9jY8Cie9PKj8Deh+2nIgfSbLNMnEHm1ZrcvfFV9FUcPtZWiWB44N93Y1tdr6EnIS0Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZst8Pq8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B83B606AB18;
	Wed, 28 Oct 2026 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZst8Pq8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFEF1F01828;
	Wed, 28 Oct 2026 19:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214666;
	bh=75jBMXRtPg95vWWYfWshUujSI4OUeV/zNIK8arzUZBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZst8Pq8qE5iTb6/ko+vf8xX4gcc7o8OjHayfzl1lxqD4SredvG8DyKSGSw3B3ZU0
	 ZPSnadpvilDpDRo8qZZWiXLpZD3cykD02S/5B+09Ezpi3roGuxmeMy23L6RFOpIUzw
	 mqZQ4eyUxplFIossbzoJ4V9m38TD5rJ3ye4/PRXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0938/1887] PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry
Date: Wed, 28 Oct 2026 17:50:34 +0100
Message-ID: <20261028170520.757898827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c22533c66ccae10511ad6a7afc34bb26c47577e3 ]

Endpoint drivers use dw_pcie_ep_raise_msix_irq() to raise an MSI-X
interrupt to the host using a writel(), which generates a PCI posted write
transaction.  There's no completion for posted writes, so the writel() may
return before the PCI write completes.  dw_pcie_ep_raise_msix_irq() also
unmaps the outbound ATU entry used for the PCI write, so the write races
with the unmap.

If the PCI write loses the race with the ATU unmap, the write may corrupt
host memory or cause IOMMU errors, e.g., these when running fio with a
larger queue depth against nvmet-pci-epf:

  arm-smmu-v3 fc900000.iommu:      0x0000010000000010
  arm-smmu-v3 fc900000.iommu:      0x0000020000000000
  arm-smmu-v3 fc900000.iommu:      0x000000090000f040
  arm-smmu-v3 fc900000.iommu:      0x0000000000000000
  arm-smmu-v3 fc900000.iommu: event: F_TRANSLATION client: 0000:01:00.0 sid: 0x100 ssid: 0x0 iova: 0x90000f040 ipa: 0x0
  arm-smmu-v3 fc900000.iommu: unpriv data write s1 "Input address caused fault" stag: 0x0

Flush the write by performing a readl() of the same address to ensure that
the write has reached the destination before the ATU entry is unmapped.

The same problem was solved for dw_pcie_ep_raise_msi_irq() in commit
8719c64e76bf ("PCI: dwc: ep: Cache MSI outbound iATU mapping"), but there
it was solved by dedicating an outbound iATU only for MSI. We can't do the
same for MSI-X because each vector can have a different msg_addr and the
msg_addr may be changed while the vector is masked.

Fixes: beb4641a787d ("PCI: dwc: Add MSI-X callbacks handler")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260211175540.105677-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 32a04ff86c5c5..7a68574b90d34 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -633,6 +633,9 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 
 	writel(msg_data, ep->msi_mem + aligned_offset);
 
+	/* flush posted write before unmap */
+	readl(ep->msi_mem + aligned_offset);
+
 	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
 
 	return 0;
-- 
2.53.0



