Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024716;
	b=ufxEN8xvkDUROHDA+jYMOOqezphAb4ILH3gvcfpOnu86b2MHQNh/43dzy7iEDcm7hFx2
	 Kd5eTlPsu2GwuAD89rTUE7Ndp6BXlTHsH3S/3pvZHUXxYIy7qB+0KEqYw8sCm9SVNEbYd
	 jGKwrnvsMUt7HChYYF1IeiW2XoihDzPL/K6dUdeL9E2K48wr4AYe31OvXLOUsNt+uLUyu
	 6gkZYWDX6UG4119n1E9+X7/rmz931dqW9VSsNRN7ZuOi8/b8+G60nh7Em1Xxzq/ZHao4o
	 oiHPyhIixHtjnP4aflNgUwpnD2ofPEuOej+MwtDl0UVmCz7fuk25wbrLbrtdnELqtdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lWTycrzF3teinIruU5jjf/2c/bZkQ7hdXvVEu3Sxlgw=;
	b=c6CrZdjBzKqnjzmG4kY8HEYr2KqEu94DMXe5SNbQ1h4Dwq/oSMO+bFFwsalpyRGXwC8Q
	 cKG9t5pbISAmM0tikHnbtSF3EpxFkWGrUUj+UEiV0gSgEN7ryLbyPWbc+eVJ34WUpjdeg
	 va/jGMtTmc8XHWDzx9qR4ukzSZg+MgHC+hpQ4yw/KxZGufnV44/VBn+l6lJNNOi2MbF6w
	 xm1bJAkXoJexW/+Eyeb7FePhkKejSdDmr5pLPpaxV1ZrO7onIq2XAOAOR1RoVe+hmotpR
	 1iSrwQ9568a7DAVhUv0F+RMW9pQAzzpPyi+3XVdWfpTjB0C0PYe88pSdhyDX0F/NQ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erfVLSjI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6516606A320;
	Wed, 18 Nov 2026 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erfVLSjI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9AE1F000C4;
	Wed, 18 Nov 2026 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024715;
	bh=lWTycrzF3teinIruU5jjf/2c/bZkQ7hdXvVEu3Sxlgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erfVLSjIFZMN6ZKHiUWaILx61xIXyUNYIyYlBXujW0CPu4omEUa4C8Zu7MVJ9DoIZ
	 Nl8IrWpL8lY0E8Y9s8abE9iERf9aC5DYUYDqT7MX4zCJNqLursPyZ/JPWr/h+mNzb4
	 w5/hUVV7MK9XwNxgp6jUhYV0EO2xoTNzmO0xqTVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0783/2151] PCI: aardvark: Disable PHY on probe failures
Date: Wed, 18 Nov 2026 15:41:58 +0100
Message-ID: <20261118150150.632022677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e34bea1ff0ac6..bf116c957e383 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1864,28 +1864,25 @@ static int advk_pcie_probe(struct platform_device *pdev)
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
@@ -1893,14 +1890,22 @@ static int advk_pcie_probe(struct platform_device *pdev)
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
 
 static void advk_pcie_remove(struct platform_device *pdev)
-- 
2.53.0



