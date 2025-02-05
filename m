Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6933156C5E;
	Wed,  5 Feb 2025 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765810; cv=none; b=Ak6xjk+hfaJBtX5Uy83QuD/v2PQyYBNDZf5z3XkaIOuBCa7WBeeTZssVMhoRWquQ1kl8+K4kntWI351pDdSfZwc2MXMGRyAH/3SWQuKpUUQrFFzO4LtYINpgCzxeGsLIrfLiQsFXUr0hFAl4Dw1BQqI1opbb3GVmHH7I3pxg+8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765810; c=relaxed/simple;
	bh=HAJb84Vn4MtEkZc/RtH9DYOUdi2qgITu1RwWMCYCJDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMi+G4ncfNHiITNtCLCP4T9z0T3yB6IOvNE6/btwK5BfTRin+CPKjOOz7scPHyYva9zszFrsLuBYGHrI/c84K+hy+0W6tdMwgtrUGQvPZB//yFjdKkkqQgWZNhahsf9dZLXLhQYCmlK2e+6sUYfPP36qmSe1jZpkoDLPEVrrBRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktQ1wNhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktQ1wNhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E7AC4CED1;
	Wed,  5 Feb 2025 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765810;
	bh=HAJb84Vn4MtEkZc/RtH9DYOUdi2qgITu1RwWMCYCJDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktQ1wNhXZ/Cdu1SXqFXPJrxdcPTCPCkRsW1HKRm8Wq1WLIQ2kW7mTrD+rmABx7f7D
	 ubNR5f+PT5RawGWMjPw+ZKRlbEtJ/kHmnAYuYuXKR32SY+vI6yYDaYbDvQw1Ln/Gk9
	 CmhEJSkTx1AuBQjcncjFFFWfV8NrekPWdj9CM2u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/393] PCI: endpoint: pci-epf-test: Fix check for DMA MEMCPY test
Date: Wed,  5 Feb 2025 14:43:41 +0100
Message-ID: <20250205134431.867567583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 235c2b197a8de2887f13990094a3343d2392155b ]

Currently, if DMA MEMCPY test is requested by the host, and if the endpoint
DMA controller supports DMA_PRIVATE, the test will fail. This is not
correct since there is no check for DMA_MEMCPY capability and the DMA
controller can support both DMA_PRIVATE and DMA_MEMCPY.

Fix the check and also reword the error message.

Link: https://lore.kernel.org/r/20250116171650.33585-2-manivannan.sadhasivam@linaro.org
Fixes: 8353813c88ef ("PCI: endpoint: Enable DMA tests for endpoints with DMA capabilities")
Reported-by: Niklas Cassel <cassel@kernel.org>
Closes: https://lore.kernel.org/linux-pci/Z3QtEihbiKIGogWA@ryzen
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index fa7ae8cedb676..ac1dae113f2d9 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -361,8 +361,8 @@ static void pci_epf_test_copy(struct pci_epf_test *epf_test,
 
 	ktime_get_ts64(&start);
 	if (reg->flags & FLAG_USE_DMA) {
-		if (epf_test->dma_private) {
-			dev_err(dev, "Cannot transfer data using DMA\n");
+		if (!dma_has_cap(DMA_MEMCPY, epf_test->dma_chan_tx->device->cap_mask)) {
+			dev_err(dev, "DMA controller doesn't support MEMCPY\n");
 			ret = -EINVAL;
 			goto err_map_addr;
 		}
-- 
2.39.5



