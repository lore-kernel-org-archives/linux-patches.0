Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78514330B0D;
	Fri, 17 Oct 2025 15:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716066; cv=none; b=ukogNzfVLJWWWhuDZAs3QnP4545YCYJFjzAZfyKphcqV/iVkeDSK+qduA4tsLeDQjAhg5n6MOkEUgmYPSPyQ9JUzcCkYcBIgsWYiPiRYfb2gbir3F18CIcQGnLp5BulwflaUdu9yb9bKV7sNE7f6QUsZT9mhdZDvpQl5bXxIaR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716066; c=relaxed/simple;
	bh=7j9cXqXjRGcQbxT06AwoaITjiJgs/jjW1xcitYaXcc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOvtF1P6PtNmr6FokhWXEcPhHThN8ZFoFHiuGEhXlBgXPXvCqN9BCUQbfNVx81Xw43LipBYyMKwEdV7qrC+rEJxx9jC7VCR3niZVRjMmqUa2gWaRFF/fDyPxJopy/heDZ5obZ26FVwlw+QUFUHwW7K9qbwSMbnxCRnHXBjkD6vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7mT87PW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7mT87PW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0275FC4CEE7;
	Fri, 17 Oct 2025 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716066;
	bh=7j9cXqXjRGcQbxT06AwoaITjiJgs/jjW1xcitYaXcc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7mT87PW90JGATKeIrK6hzVZaUkpdYbcwr9x6H81xGqhrndSMIRZeXmpM8Ef9o/O4
	 zca4Hp+nFghhjkl+5enalHMODb9Dcfi+vH7EA5oKsrntG0uLzal5Gxyqj+yxbK8FaT
	 xozqSp9WzQsR6AkLLukP5/P4wVEuSwciRZRHUI6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/276] PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation
Date: Fri, 17 Oct 2025 16:52:34 +0200
Message-ID: <20251017145144.716295704@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cb0aa65d6934a..30d63ae20d8b7 100644
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



