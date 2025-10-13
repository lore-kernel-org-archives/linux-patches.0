Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606A309DC5;
	Mon, 13 Oct 2025 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367673; cv=none; b=BiJY93puwmewnHQ24lFNErKZrNRnMcJshvBwkUk4T99y+La9lIMIK0qcKKhCA/G1d1ikylXBhoF6x7CmDRi+4h836YcF8v8raO/+yfajH4/6qtXB1LY4f9KY+1E1cKlKr+rnlpXLvFvwGr6Yn95z80OqxHlGkw5dws9RotT52XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367673; c=relaxed/simple;
	bh=cvpK/uj17mORDCONLNTQ/hXzOjbVQIpePGs/CMI5ThQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caMWY34pTY34c/LlPMuijNRYJ35cX+OxzuxsNSeXEGZCk1KHffH1SY/IDGFngql/NqpUYdNBzwMyHxgbxXv2I23hPwRWLIo/AKdzOxtZ4mZbeIUwg1JDjAf/72rurAmxPRMwHdwtUhIAG5WFxFdp/nolTj9dMfKiLaL958U9rkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/a0CaAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/a0CaAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAB1C4CEE7;
	Mon, 13 Oct 2025 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367673;
	bh=cvpK/uj17mORDCONLNTQ/hXzOjbVQIpePGs/CMI5ThQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/a0CaACsqvcO+8y6t4fxfE8fpcV1RqTmgsM8Ie04pfHcWf0TSq9Ny4mL1w+P0q/U
	 tcaypIBN1pUC48Jw7I8h1rXcP3ZmSrKjLKFMiUWB4U2hkvMdBnf/g6VbkCdtSpG5WV
	 LvkJ5rFBFJVhqrxbypPMhOYUrk8vbtc30z4fwDHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/196] PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation
Date: Mon, 13 Oct 2025 16:44:44 +0200
Message-ID: <20251013144318.682030193@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit e1a8805e5d263453ad76a4f50ab3b1c18ea07560 ]

Fix incorrect argument order in devm_kcalloc() when allocating port->phys.
The original call used sizeof(phy) as the number of elements and
port->lanes as the element size, which is reversed.  While this happens to
produce the correct total allocation size with current pointer size and
lane counts, the argument order is wrong.

Fixes: 6fe7c187e026 ("PCI: tegra: Support per-lane PHYs")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
[mani: added Fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250819150436.3105973-1-alok.a.tiwari@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index 038d974a318ea..80d975dcb2ee2 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -1343,7 +1343,7 @@ static int tegra_pcie_port_get_phys(struct tegra_pcie_port *port)
 	unsigned int i;
 	int err;
 
-	port->phys = devm_kcalloc(dev, sizeof(phy), port->lanes, GFP_KERNEL);
+	port->phys = devm_kcalloc(dev, port->lanes, sizeof(phy), GFP_KERNEL);
 	if (!port->phys)
 		return -ENOMEM;
 
-- 
2.51.0



