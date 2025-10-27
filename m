Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF162D8DB9;
	Mon, 27 Oct 2025 18:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590501; cv=none; b=I1iFRCX3uAytPgKs1iVLMTwoIPt26rFSh8egPbdD3fZN6yNxEWDfUakCC5b5UMY2yN/tiddWyGzTQntuxt2inU83Ya0Y+iLJVynMh/WcmSOm8Kq085RREK3916TZkyUEalyQYBk6EY33BtquI+ssXpiNIax5PVLnuO1VaMEqVjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590501; c=relaxed/simple;
	bh=9mtIIA0PrDsfYikZcWVJwQMlVuYNwUgK9oQYag6tV1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POkbkgHVSutQny83cGvJEsoHg2sBI/ICqwQYahuy6iqqhUuJcSoijMVyznFgVYxOViKK+u+9daCluG14uHcohyZKaSIHovg/GMJNnt3wWFWVurqfLBJ+zpwZo/0vGSwH6nOKKBhSvLkcfR/36EI6sDekPmHRfNk2JoaUtI8T9ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2mx5FvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2mx5FvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB76EC4CEF1;
	Mon, 27 Oct 2025 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590501;
	bh=9mtIIA0PrDsfYikZcWVJwQMlVuYNwUgK9oQYag6tV1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2mx5FvXtgOo+E4jPVCCRtTXC/QoIwMhzMxIoAeLgsBqiyughlDz7++x6+rJPEjC5
	 AvCEwglhLXegYJ/o2hM7MD/VxMeI3Rj4jDUyEo2FY1PrRc+TVUf5X635ovWslqFaYi
	 Wqr/Gu0RPYhusqMgGeNYdOfRdjJGZuNrUecEIlCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/224] PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation
Date: Mon, 27 Oct 2025 19:33:05 +0100
Message-ID: <20251027183510.051929710@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 74c0ddd433815..9e3588d568ce4 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -1394,7 +1394,7 @@ static int tegra_pcie_port_get_phys(struct tegra_pcie_port *port)
 	unsigned int i;
 	int err;
 
-	port->phys = devm_kcalloc(dev, sizeof(phy), port->lanes, GFP_KERNEL);
+	port->phys = devm_kcalloc(dev, port->lanes, sizeof(phy), GFP_KERNEL);
 	if (!port->phys)
 		return -ENOMEM;
 
-- 
2.51.0



