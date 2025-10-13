Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9961309F02;
	Mon, 13 Oct 2025 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367156; cv=none; b=AFdO0+qy4efZdLmFwuoFYlkJ3tUxxllCkU24CFH5khXJUBeq3lpxvzlUhlMDqhsQyNtdXlws4v/dVgk42YcVkN0shTC0fTTtMWGTicqytfqhiNy+PTkJJEsXIeSC43peB/5qWZgdKxTBPcxVeb98+640ZCnblNvVL9jyTdVF3hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367156; c=relaxed/simple;
	bh=UxDMh6u9RacQvk4cbDgKlV45ZLm0wn/FXB0YJHuy11g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9b9hnLfgH+szB4fSIS3Q61icdB1jPXSdhkBFKtCndvOYcHU3PJEesJDZja5IxtLjlUDIH+To92e9FEQVjg2gxUFQA5N1UX2Rgay3xORAXRgrBOnkrWrpPc5PmJz9hIOvChcgnm5ivniwDgjV6b6ZB4OA94PLbQ1nV3wc2omthg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MY9ngXx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MY9ngXx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144D4C4CEE7;
	Mon, 13 Oct 2025 14:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367155;
	bh=UxDMh6u9RacQvk4cbDgKlV45ZLm0wn/FXB0YJHuy11g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MY9ngXx+QfgUTD830s6UEsFxSDrqWyjQ7BvEIYgXRf49g7RZTLLIGcSXVvUHz1l3B
	 aBWG1zx/k3Mrib+9/lZf3l6qtitDlnF8+V9+i7ZgMo5kRSXj9dab8LRgs+UK+Pl3Er
	 n4Yf9Xgn/ghkrqVxdxZQZkF12UERJ5xVg1nKPYz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/196] PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation
Date: Mon, 13 Oct 2025 16:44:44 +0200
Message-ID: <20251013144318.715059263@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8e323e93be915..c165f69454590 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -1346,7 +1346,7 @@ static int tegra_pcie_port_get_phys(struct tegra_pcie_port *port)
 	unsigned int i;
 	int err;
 
-	port->phys = devm_kcalloc(dev, sizeof(phy), port->lanes, GFP_KERNEL);
+	port->phys = devm_kcalloc(dev, port->lanes, sizeof(phy), GFP_KERNEL);
 	if (!port->phys)
 		return -ENOMEM;
 
-- 
2.51.0



