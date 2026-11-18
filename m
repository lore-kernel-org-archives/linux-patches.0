Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030194;
	b=KnKFGqUVoO5TeBK1856v2Oea9MHPsmr3pIRui8/sgTHAHBjppuRLgE8k1YyvnhKFIVvI
	 d7soSi1eLEV1UOZEexp6RatH4R1aQwhgqEILmVsVurC9sO6DKAfCKG6I2I6M9z9NGS5Wy
	 EnBPtRMhvwERCGs6WlHaZ2getrkh2dmk9fMoo68krH67CtrhWkD0MLivbuoBghApl02zQ
	 zgkeZ0cwXoQW31qUyVpD8vnFmVPLWq58Q29Zu8gq4iP7mhF2PPr6f1bf27RoiiQxl+gl/
	 BntmoEZdE0b2FPNzBB+0UzEDl+8vo55yQ46BOrVJCb8UvRh1WP61Uy8xLJ6/GFsb7fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ornd6BeZGrcpnuMyDi7euTqfJDJSh+fspLpzDaDUd3s=;
	b=P4jWK4QFmvhDEb0TS+EFFEXB4dS/SdL/Pb9tlgk1FMtKFFReIWQOLlFdncrPK1r/pKeB
	 iSoFWoGxgbpagqmUrcWTzA/yI5nGisn0nTq9MD++e9BpAS2VOt6APX8WEkbWbDkrqjShl
	 8aImuTxFYWj70BwN3IiZvFGzjZH01SjtEPdFIcRpHqzCz3ZzhbpBVVqi836vggPgpGxLQ
	 wDXQY52mOTjnylAhZ72/x6WDnoOSU/fjbIbNXR6rGctTa6C+ZQIZ9mCBND5AnbDaiTvLc
	 vHqnTjRweG7/jl6WNNV1OnqC5aQIFFRRYIopkjXZVD16iGvkhDOU6LlI7vz+6FqyXAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cnxj1fmE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B39606A32C;
	Wed, 18 Nov 2026 19:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cnxj1fmE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416E61F000C4;
	Wed, 18 Nov 2026 19:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030193;
	bh=ornd6BeZGrcpnuMyDi7euTqfJDJSh+fspLpzDaDUd3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cnxj1fmE6S1CXhDDmaL5kPMNFLlvPQC9TE+rTA3ZtfVxFHJxSEfckbLQuwNj1BEVm
	 BcuLdhCvL/r9HZIhCbx6jlrwE8is0tQ7aeV528v83XdV4V9TQsBIPgAXQqt6KPMlYm
	 phk3d58XP490Fps6KpYMndgKCLtEGKHuHc4lEmrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0619/1756] PCI: aardvark: Disable PHY on probe failures
Date: Wed, 18 Nov 2026 15:45:46 +0100
Message-ID: <20261118150033.553666583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a598a98247ce9..e65fe2ca2515d 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1881,28 +1881,25 @@ static int advk_pcie_probe(struct platform_device *pdev)
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
@@ -1910,14 +1907,22 @@ static int advk_pcie_probe(struct platform_device *pdev)
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



