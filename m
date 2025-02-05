Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C9E2A1BB;
	Wed,  5 Feb 2025 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767860; cv=none; b=G3TVeXuG+P3NSM/BPZBkeZEpELHhmOj1GksItMDkrzYYEG77qfPMiyUcJVUKMk9woE2bKb+y1ehhWAFlAZ1YN2mBvT0EPTY4arU4M8/8yBOKo5QuMRIzzfpEW75VJ9Si28pu0i+vl067ify+r4rqQPm4UsaNE4+GM8FKQgBU+og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767860; c=relaxed/simple;
	bh=vBkq/0vZfYXSmA0WtLU2bPEvU4kvXSKaiRNFbiOz5Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/qz2l9VNRLDbtPnq7tv4fLDzVZXtyfiCWOSMTm0UFmd/5D2f5qawhpH2kkfi6OUr9V3tV0o8+ENfgdmh2qMfhJmNwEZVFZAcI5T6GP3cEPdi0aSgKa/ZBVllYl7F5HCk+cSEUqpPAYzZzZdBo13z47CC5B5fNOLbge9UZ/CQg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isVQc+jE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isVQc+jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81073C4CED1;
	Wed,  5 Feb 2025 15:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767859;
	bh=vBkq/0vZfYXSmA0WtLU2bPEvU4kvXSKaiRNFbiOz5Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isVQc+jEFkIDpAJF06sSXJ2FfbFl5tAeq31+G0k477RqjIuk7ltHtPWM4HMeMfBMx
	 g79ewIAFjeVjDxDzEJwYKiGoNveIallov5jKMdnyPcPqzm/ENJKxgdue7J1cTu+NH0
	 ZfHHpTC2Ihf15MkRYvaE3Wa99DnvBmNwBVhzp3rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 463/623] PCI: rockchip-ep: Fix error code in rockchip_pcie_ep_init_ob_mem()
Date: Wed,  5 Feb 2025 14:43:25 +0100
Message-ID: <20250205134513.930942448@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7ca288760007cab6588dc17f5b6fecf52c83a945 ]

Return -ENOMEM if pci_epc_mem_alloc_addr() fails.  Don't return success.

Link: https://lore.kernel.org/r/Z014ylYz_xrrgI4W@stanley.mountain
Fixes: 945648019466 ("PCI: rockchip-ep: Refactor rockchip_pcie_ep_probe() memory allocations")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 4f978a17fdbba..85ea36df2f59a 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -788,6 +788,7 @@ static int rockchip_pcie_ep_init_ob_mem(struct rockchip_pcie_ep *ep)
 						  SZ_1M);
 	if (!ep->irq_cpu_addr) {
 		dev_err(dev, "failed to reserve memory space for MSI\n");
+		err = -ENOMEM;
 		goto err_epc_mem_exit;
 	}
 
-- 
2.39.5



