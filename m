Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330E30BF74;
	Mon, 13 Oct 2025 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369625; cv=none; b=i0qBYar88RPAlVFaeS//OtX3/b76mHNjRnhXo6JaixkqXpfddQrzPctMS8Wik99eR1v4w0H48MrXk86nmlFzWbxguTbkVT443CGnZtGYGJJUYxAOtXSSTQhP8e8k1WqU6PMEM6CweuP1QUA6J7CBVP443uyJM/bunBl8Q/mBXkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369625; c=relaxed/simple;
	bh=VsEuiinA+v6qvF68NvSyB63p1l0h4ZRfAi3a9Q1Hog8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOmadXReL5mMC+ZE5TIf6u4LbpAOpFXaBIiY62tmoldXUZn2xQmBQE4M5LGGaudWCCqlO0M7GiVC/eU4Y/4pt4589Av751iIUwYsOvmdKGLwUEA2LgKMeIkFAFUYdpx0MXKKa3qRZYxeg6WF9v++zIVNtF1Q9kEx1OzuvoK84Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8sR165L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8sR165L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A72C4CEE7;
	Mon, 13 Oct 2025 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369625;
	bh=VsEuiinA+v6qvF68NvSyB63p1l0h4ZRfAi3a9Q1Hog8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8sR165LVMeUCW0pNjDkowcHvplWXKswH5yy2e/ADkuaHt8PgWLPjBz8+eIMugfGo
	 QcdDZPd6T+QvbhnaF+ZmMQI327XoNaaK7+pXmXVNqPksAvR84CvLA5+nhpZtRKVN2P
	 J7BqxPCH/NiISmIrx+XFuRPyI8Veaz61rMuE7S2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 313/563] PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation
Date: Mon, 13 Oct 2025 16:42:54 +0200
Message-ID: <20251013144422.603515763@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 467ddc701adce..bb88767a37979 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -1344,7 +1344,7 @@ static int tegra_pcie_port_get_phys(struct tegra_pcie_port *port)
 	unsigned int i;
 	int err;
 
-	port->phys = devm_kcalloc(dev, sizeof(phy), port->lanes, GFP_KERNEL);
+	port->phys = devm_kcalloc(dev, port->lanes, sizeof(phy), GFP_KERNEL);
 	if (!port->phys)
 		return -ENOMEM;
 
-- 
2.51.0



