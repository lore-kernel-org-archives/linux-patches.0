Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048792;
	b=kYX+plvqOmb9COaZpPKhtuesXy0grA24SQnceRuxoSj11mrDYYL4SHzdhJMV9mS7B+Nl
	 jDytEJsVKWO6CPKEMR6apj88uUxX1sljXbusCfgujani9suUlrUs7pLyU+5ud55nvdAU5
	 DhqUfIBJ93Yb5To2jXBTSPupHnLufYvENuz2/2KgxaHPe3HajuNxEkHkN9paSbcNbJZp4
	 6+kIY8V38NCXoM1lGr4u0KE7DTYFQMK0dkzPzseZSmJM8tJf98qxzgYwbbTqlQEo6n9EY
	 gqPrm1h+bfvY3ziUHEwM2k2yAO8MddFqUFI6tE629iXs3jTKammR2kEZ1ni02C83zBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=raz28/eol5Yv9VpZPWyH3zU+iKl7hSDTOBsskU0iQd4=;
	b=VY7IQc/AMmru+4dDJD1rj9/F13Ns8t9yroDFuB+oeHjebL5BjMPVbKiPprIkBaCtz1E4
	 mY73rFO7n3/1PCcV98JqwcH1OCDNu2kCd+JMWTyziOmKH5aMb80HdF7id6/cF6S9o5mVW
	 W7Rg6HrNPd0Cshs5ezEF3Q+2k4Ttq35Z2Ib93l6WM9tmE9HfY1Ornle6b40rVddIzgajn
	 k6I0XEn6KdO3+IIjymF3U0Vb9mNQkrysjnjnuenvZZNiMVEJnzBX4hk39ry9s+1x4AFFO
	 GQvawWOjsgpWjdGvIHpfuOSmfcBLjURxxVxMi63CbOwKGu5RZej1fM9YU0rfk8ea+6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrEBeq12;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AB5606A320;
	Thu, 19 Nov 2026 00:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrEBeq12
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0291F000C4;
	Thu, 19 Nov 2026 00:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048791;
	bh=raz28/eol5Yv9VpZPWyH3zU+iKl7hSDTOBsskU0iQd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrEBeq12FqWnOI+fUl4iiGAVkZnHET+NOyLQDpY7zFFCr++0s21Xam10bxk2BOrQp
	 xeQBgQkjyD1e8JcEXEMIRybvEub3EZALgHuEivMBJNqupdKoarGjyZcqvLqKaA3rSF
	 B4KWVPg9FMfQGiNmdvK+S5r4pPnNNVTploYe6paw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2080/2857] PCI: aardvark: Disable PHY on probe failures
Date: Wed, 18 Nov 2026 15:51:54 +0100
Message-ID: <20261118150316.298875032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ba36bbc5897d0..bb9ba5e50b8d6 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1890,28 +1890,25 @@ static int advk_pcie_probe(struct platform_device *pdev)
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
@@ -1919,14 +1916,22 @@ static int advk_pcie_probe(struct platform_device *pdev)
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



