Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023F518F2FC;
	Tue, 26 Aug 2025 13:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213828; cv=none; b=r4NVdZYRoKsWpYhq0EMUahdY2gdNBOVLuWuBgu54Wc2lX0n6GA76Ag64C1oYZtTBzyx/rKgX+beY2IXJzUNIB5xkpApXf9oL5Uk2yGh+FNfH5ITvdncizKf9meTkom6eFZ4k6uy9r5FM2SeWBl5oNriVNBxFr/2NK8yWA3j+G5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213828; c=relaxed/simple;
	bh=DZR8x/4cwv41eRLIYVjrHUFNeAFadr1h/AVPBL1HXAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D290c6gr3pvNf5MomjfBZ/xQ5cdfIVyoauYK9eVlmTue0ovmy79I4o9Kre1nmV7PaKvfqDyvO7SNtTTH7RE1T8C4rR/CNlu5kgeqfsIh/LDXqIO2ebsAxPgSTpiFggBbTT9kSJSHrnXFvzRkGjXkcAuCKqzHdYnBwfkjw/cAuoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aol4da7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aol4da7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD4EC4CEF1;
	Tue, 26 Aug 2025 13:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213827;
	bh=DZR8x/4cwv41eRLIYVjrHUFNeAFadr1h/AVPBL1HXAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aol4da7JepARsXbH88ycqy2hJ7rAsPRKNfJMJ+aIRM0Z6Umbqwxk46LbXpt2BIYtB
	 izN/p6k7/1D3enRuZi3tPe6BnmT0AiCh3G6JURUpX+KMGUf1oFQZK6ByaSsE0wKyGX
	 56RA72tGgn9VW31/bejOsGsiILLFR3u/yh6EwJQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 495/587] PCI: imx6: Delay link start until configfs start written
Date: Tue, 26 Aug 2025 13:10:44 +0200
Message-ID: <20250826111005.573206186@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 2e6ea70690ddd1ffa422423fd0d4523e4dfe4b62 ]

According to Documentation/PCI/endpoint/pci-endpoint-cfs.rst, the Endpoint
controller (EPC) should only start the link when userspace writes '1' to
the '/sys/kernel/config/pci_ep/controllers/<EPC>/start' attribute, which
ultimately results in calling imx_pcie_start_link() via
pci_epc_start_store().

To align with the documented behavior, do not start the link automatically
when adding the EP controller.

Fixes: 75c2f26da03f ("PCI: imx6: Add i.MX PCIe EP mode support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded commit subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250709033722.2924372-3-hongxing.zhu@nxp.com
[ imx_pcie_ltssm_enable() => imx6_pcie_ltssm_enable() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1098,8 +1098,6 @@ static int imx6_add_pcie_ep(struct imx6_
 		dev_err(dev, "failed to initialize endpoint\n");
 		return ret;
 	}
-	/* Start LTSSM. */
-	imx6_pcie_ltssm_enable(dev);
 
 	return 0;
 }


