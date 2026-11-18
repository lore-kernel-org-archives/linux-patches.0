Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055432;
	b=EwuGts8rn0BlfAifq55ctZC6ycgSlA/r8r4PQOe72O7VWXO1MFK6UusCchWDIDaK5wYY
	 8Da3vkF7m7XdugYWf0JA48vzM9n2ybNhu3bxSjNH0p6MtUFaBHoIoP9nFhittvQIeEpz4
	 MkXxVyudpRS2yraUcyqHho454N+eMGI0EynqDKzcKACfhVGdFzKEkuZvkywUPAFA5zFIF
	 BLCwjPRNPKfr+83AJQAYxO3XgsOVUPhxhrjvw1bXk/XBO9aPOCvNZZ6wwaJ72dk6R/8NK
	 CyGJbcuBQtT2DDPjb27WOgaCMdK25zF9lxYbWHOPS0wrKteNPHIKhhn+ZmsbpnERm4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AN/JLaGX1WB0zTo5OxnIo636A9ml9zqEgN4jFrwtuoE=;
	b=mBzvCVlof5dFFdiIXCflWicugOjdlBOo80F/Cw0VX7R5A+N97SLeJ0d6Pbo+BGWm9b51
	 2PC3i9WTMyMLbTr4yalMY84VyIea7SMmU21XDMk+O87zxa2I8yxqXZOvKhWZgUZEWslh0
	 p6hWP0/QeQ0Qe7/OP17L+Wm3n5IDIRR+TQvZKlgP5bXUUfA52ATRXiKmpLJaSmcw9sdsk
	 /Sd/h+vktmQXbKU7sNZfw3r9FVcdi8ZCknKsDIpVxACXCOn8F4xf+kIEd6EhBTidsaLGg
	 ZWLfU4OCkEwZEfAVcpFOa0VDxZ2COpm62UUhElJbfQKPitCmej1BkF11zVxZ9RulJIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlHIVc+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A939606A320;
	Thu, 19 Nov 2026 02:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlHIVc+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F101F000C5;
	Thu, 19 Nov 2026 02:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055431;
	bh=AN/JLaGX1WB0zTo5OxnIo636A9ml9zqEgN4jFrwtuoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlHIVc+RA9R4P6GqIOL9b11HT9l4cMNB0eWw55kwoez11axzFYjrvAFZYidjwUGbz
	 MPBQN3vIzOKPDJ/3waZlNuSflZX8cNcI/uAzXqOA1+s9KOMoEKErJQy5QiWOFL2neC
	 jjfc/OzCGO92zyl82fHxs+XEFuJjeTovygomKChI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1628/2214] PCI: aardvark: Disable PHY on probe failures
Date: Wed, 18 Nov 2026 15:55:04 +0100
Message-ID: <20261118150117.088220050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 28cc5bc5a6c6cffbe7ba27c0acbfbe06747fa173 ]

advk_pcie_setup_phy() initializes and powers on the PHY before the
emulated bridge and IRQ domains are created.  If any of those later
initialization steps or pci_host_probe() fails, probe returns without
powering off or exiting the PHY.

Replace the direct returns with staged cleanup labels.  Remove IRQ
domains in reverse order, release the emulated bridge allocation only
after successful initialization, and disable the PHY on every failure
after advk_pcie_setup_phy() succeeds.  A setup_phy() failure still
returns directly, so its partial internal cleanup is not repeated.

Fixes: 366697018c9a ("PCI: aardvark: Add PHY support")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260910221725.91980-1-mhun512@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 31 ++++++++++++++++-----------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 215f7510de9a7..d41b4f3ecc77a 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1811,28 +1811,25 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	ret = advk_sw_pci_bridge_init(pcie);
 	if (ret) {
 		dev_err(dev, "Failed to register emulated root PCI bridge\n");
-		return ret;
+		goto err_disable_phy;
 	}
 
 	ret = advk_pcie_init_irq_domain(pcie);
 	if (ret) {
 		dev_err(dev, "Failed to initialize irq\n");
-		return ret;
+		goto err_cleanup_bridge;
 	}
 
 	ret = advk_pcie_init_msi_irq_domain(pcie);
 	if (ret) {
 		dev_err(dev, "Failed to initialize irq\n");
-		advk_pcie_remove_irq_domain(pcie);
-		return ret;
+		goto err_remove_irq_domain;
 	}
 
 	ret = advk_pcie_init_rp_irq_domain(pcie);
 	if (ret) {
 		dev_err(dev, "Failed to initialize irq\n");
-		advk_pcie_remove_msi_irq_domain(pcie);
-		advk_pcie_remove_irq_domain(pcie);
-		return ret;
+		goto err_remove_msi_irq_domain;
 	}
 
 	bridge->sysdata = pcie;
@@ -1840,14 +1837,22 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	bridge->map_irq = advk_pcie_map_irq;
 
 	ret = pci_host_probe(bridge);
-	if (ret < 0) {
-		advk_pcie_remove_rp_irq_domain(pcie);
-		advk_pcie_remove_msi_irq_domain(pcie);
-		advk_pcie_remove_irq_domain(pcie);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_remove_rp_irq_domain;
 
 	return 0;
+
+err_remove_rp_irq_domain:
+	advk_pcie_remove_rp_irq_domain(pcie);
+err_remove_msi_irq_domain:
+	advk_pcie_remove_msi_irq_domain(pcie);
+err_remove_irq_domain:
+	advk_pcie_remove_irq_domain(pcie);
+err_cleanup_bridge:
+	pci_bridge_emul_cleanup(&pcie->bridge);
+err_disable_phy:
+	advk_pcie_disable_phy(pcie);
+	return ret;
 }
 
 static int advk_pcie_remove(struct platform_device *pdev)
-- 
2.53.0



