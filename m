Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D7830BF4B;
	Mon, 27 Oct 2025 18:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591047; cv=none; b=VP8yHpUsCMORkaBm1A4p61ZsjhTKUUjA8MMeamG5TbIJK6jJ2Ngw6/FFzHgs3OOxQ0u7SKlsKiVpXym+m/Bl9dZGWWxBUN/Jut0eN0IyqL+rbagHoY5SD2ciJVZyxwd4Q6vNQwdLm7jDF8s1HWtwCSUdMXIbuNRSGLmmkrhNBBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591047; c=relaxed/simple;
	bh=9XC359+9F1BYOjpCyYQ9CuYGVMD6g2uAnXKSAjgUVuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZxiJkaDY2WLEmAc7uu8udFyyj2bbOHqCfSK86Q4NcvslkFfp1vD7fo76npMDRhI0s3FQVBZ5XAF3ziIOwDONhCi5nS5MEHnHzCop4zLKSLjZvoX65ECRtityyePqGwakOOVUbluKr4jm0RD3dku5G1rnaMIEJfeOxRfiLuW358=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOAZWppp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOAZWppp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629D0C4CEF1;
	Mon, 27 Oct 2025 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591047;
	bh=9XC359+9F1BYOjpCyYQ9CuYGVMD6g2uAnXKSAjgUVuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOAZWppplPgOKeUutY3Hu2kClrxb6ZbVrssdgemMZoYi+OgegKwFSzzTZheFRuvo0
	 UMarhQpL7NDnoVcK5OC+Rev7giB2oIxFAtlxplRztfKiTwqkdAizN9vCS1vZfdOswl
	 yVF8AHOou7WHL+hvQtT9a3UCHplNqfvrIV1wNnVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/332] PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation
Date: Mon, 27 Oct 2025 19:31:41 +0100
Message-ID: <20251027183525.889328817@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b4eb75f25906e..e712841ccaa3e 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -1365,7 +1365,7 @@ static int tegra_pcie_port_get_phys(struct tegra_pcie_port *port)
 	unsigned int i;
 	int err;
 
-	port->phys = devm_kcalloc(dev, sizeof(phy), port->lanes, GFP_KERNEL);
+	port->phys = devm_kcalloc(dev, port->lanes, sizeof(phy), GFP_KERNEL);
 	if (!port->phys)
 		return -ENOMEM;
 
-- 
2.51.0



