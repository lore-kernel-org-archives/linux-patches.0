Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7C91C6BE;
	Wed,  5 Feb 2025 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767853; cv=none; b=scONR8Ddz2ZHH91srL/+uprfqNfT6YH6RF78DfFdH+vyR3sW6Brzw/56Xgho0hI2ivLhr7gfXdYytKydepVpu5V7mHTsAgKLBvCZjoqLYC32gpOz13ZJa9lFiID09NqT2dBX/9R2o8I5A4Lcn74zNVQAV/YxdJbFswNf68julU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767853; c=relaxed/simple;
	bh=SVj8kNYOqZtS+NZmgK41fUXHfqaLC6JzL8FLosMOpSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BiPBWPEWMKS9TBxltqFgQf/FIm87MvVvw60JX0spiefRUZj555HWxMT4awKyiD7RKvVqYjEKVvePA78yn/TxG2Ok2aMPVF7JDM4GCbXumBdSemOkgxMgnNkS2vQDShtaRhhHCeNdOsCLbiixLGm3Gd/LBZ0xNFTaPEVIWUxbeQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nToNK/Vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nToNK/Vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75175C4CED1;
	Wed,  5 Feb 2025 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767853;
	bh=SVj8kNYOqZtS+NZmgK41fUXHfqaLC6JzL8FLosMOpSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nToNK/VdV8HZZ97oYz2rzBJY5Dxxh8VECGJECQ03RtGqQoELpSguv4/37xBrzC7i5
	 jvFZCeoXjz2u/9/tGKfi+5la4m84OUcCQIDw0MIkfBj+QnRMKU8e5sgrYmoaiJnItF
	 IuWtV0kL+V2p7pIjXtdK5ITgE19ZephKW9rcqEV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 462/623] PCI: rockchip: Add missing fields descriptions for struct rockchip_pcie_ep
Date: Wed,  5 Feb 2025 14:43:24 +0100
Message-ID: <20250205134513.892798514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit fd46bc0e0bb3c6607363bd23f2b3c2a73dc75d66 ]

When compiling the Rockchip endpoint driver with -W=1, the following
warnings can be seen in the output:

  drivers/pci/controller/pcie-rockchip-ep.c:59: warning: Function parameter or struct member 'perst_irq' not described in 'rockchip_pcie_ep'
  drivers/pci/controller/pcie-rockchip-ep.c:59: warning: Function parameter or struct member 'perst_asserted' not described in 'rockchip_pcie_ep'
  drivers/pci/controller/pcie-rockchip-ep.c:59: warning: Function parameter or struct member 'link_up' not described in 'rockchip_pcie_ep'
  drivers/pci/controller/pcie-rockchip-ep.c:59: warning: Function parameter or struct member 'link_training' not described in 'rockchip_pcie_ep'

Fix these warnings by adding the missing field descriptions in
struct rockchip_pcie_ep kernel-doc comment.

Fixes: a7137cbf6bd5 ("PCI: rockchip-ep: Handle PERST# signal in EP mode")
Fixes: bd6e61df4b2e ("PCI: rockchip-ep: Improve link training")
Link: https://lore.kernel.org/r/20241216133404.540736-1-dlemoal@kernel.org
Reported-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 1064b7b06cef6..4f978a17fdbba 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -40,6 +40,10 @@
  * @irq_pci_fn: the latest PCI function that has updated the mapping of
  *		the MSI/INTX IRQ dedicated outbound region.
  * @irq_pending: bitmask of asserted INTX IRQs.
+ * @perst_irq: IRQ used for the PERST# signal.
+ * @perst_asserted: True if the PERST# signal was asserted.
+ * @link_up: True if the PCI link is up.
+ * @link_training: Work item to execute PCI link training.
  */
 struct rockchip_pcie_ep {
 	struct rockchip_pcie	rockchip;
-- 
2.39.5



