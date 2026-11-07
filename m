Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063390;
	b=i3bmiTDR7a/hDatLr4RhXTZdnX225SiDRmYF5fxU59Lb26Uh8++pa11uKkbSan1zUkQp
	 qBBm93bxcnHSRbtSOqV0nY240dNFE3rbMJl70TiOepwfS4KEBkDdnDk8VqsOrKhZfp0oc
	 t5X7vtIGFWx5vOUgVeOcfp5W58cycrrRYbEVK/evVLsQ43mar/o3TKNiih4GIXz7vlsoi
	 3gafhRp7BqMOcR725qLQ9Tqm6BKG4vcoY+phXHm2D/PR6MnhoNOgQkO4lo/AFDHtRt3Mv
	 clr9oPkPszvtGzYpIHaDIKiKWSE5lerfC7U+RLYKh8SavqqVbM7UVQYuRcD5U94ht8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIUfYfUdXU4TY8jVAuu4RmDIRvlDYnIAgGUmTQZbzfY=;
	b=mM7LOkeqGVIoAmY2zPGcgZHzMrAbgFBiwFmcgDtwlZ7ihSRGYKfZbXbXyDKAacTPc44u
	 NpvR60FDlwux4BdckTFBPdaBoCqEH2m46IsrvFXjgMgXf+cxrTU1ewbRh09nVH+D/BX48
	 4y9deSP/ppEFd65Gc0cj47YWSSSwpdjYzLmK9vFx1BWBTLFT1AVZII7mkspsiStRTS9Pj
	 4V2KAO70LXWMc//xwUr357H7gyI/5sgGgQZQw95UUuaHK74QpDQ6tVuQYKP/mYr83tGJQ
	 d1Cw58G7Q6Y3D/F63RtTZD4TX1zFQwXgaDJNDItwzSiJvlBknRQJdfbfIztdd7osGkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuPB8Vp4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6829D6082BD2;
	Sat,  7 Nov 2026 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuPB8Vp4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B30C1F0089F;
	Sat,  7 Nov 2026 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063390;
	bh=HIUfYfUdXU4TY8jVAuu4RmDIRvlDYnIAgGUmTQZbzfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuPB8Vp4kqSC8LJ40UVfUzxIFt5Wg7gNQacU+ojrxqaFlDvGEnZSJXzJfSmagrBN9
	 ZzQfAU3zTnoMOtA2b7HFiYKca4Q7IhEZXObRYufM4yDxmnqv6rOIBrQhq596Wum150
	 ekXXd9f5ZmRfv6ciHYCcRG/18VSz7WjC1FwrWCXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 524/869] PCI: rockchip-host: Do not attempt 5.0 GT/s retraining
Date: Sat,  7 Nov 2026 08:53:26 -0500
Message-ID: <20261107134911.271505313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit 2a1e6c382fb7567679c07bd6a7060fefc7a5edc9 ]

Drop the 5.0 GT/s Link Speed retraining from Rockchip PCIe Root Complex
Mode Operation, so-called host driver.

The reason is that Shawn Lin from Rockchip has reiterated that there may be
danger of "catastrophic failure" in using their PCIe with 5.0GT/s speeds.

While Rockchip has done so informally without issuing a proper errata, and
the particulars are thus unknown, this may cause data loss or worse.

This change is corroborated by RK3399 official datasheet [1], which states
maximum link speed for this platform is 2.5 GT/s.

[1] https://opensource.rock-chips.com/images/d/d7/Rockchip_RK3399_Datasheet_V2.1-20200323.pdf

Fixes: e77f847df54c ("PCI: rockchip: Add Rockchip PCIe controller support")
Reported-by: Dragan Simic <dsimic@manjaro.org>
Reported-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/all/ffd05070-9879-4468-94e3-b88968b4c21b@rock-chips.com/
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/68f6353e3a2ea4914de36c42b6906e41282adad3.1781622998.git.geraldogabriel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-host.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index d203c4876d304..0b52f2e370f41 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -328,26 +328,6 @@ static int rockchip_pcie_host_init_port(struct rockchip_pcie *rockchip)
 		goto err_power_off_phy;
 	}
 
-	if (rockchip->link_gen == 2) {
-		/*
-		 * Enable retrain for gen2. This should be configured only after
-		 * gen1 finished.
-		 */
-		status = rockchip_pcie_read(rockchip, PCIE_RC_CONFIG_CR + PCI_EXP_LNKCTL2);
-		status &= ~PCI_EXP_LNKCTL2_TLS;
-		status |= PCI_EXP_LNKCTL2_TLS_5_0GT;
-		rockchip_pcie_write(rockchip, status, PCIE_RC_CONFIG_CR + PCI_EXP_LNKCTL2);
-		status = rockchip_pcie_read(rockchip, PCIE_RC_CONFIG_CR + PCI_EXP_LNKCTL);
-		status |= PCI_EXP_LNKCTL_RL;
-		rockchip_pcie_write(rockchip, status, PCIE_RC_CONFIG_CR + PCI_EXP_LNKCTL);
-
-		err = readl_poll_timeout(rockchip->apb_base + PCIE_CORE_CTRL,
-					 status, PCIE_LINK_IS_GEN2(status), 20,
-					 500 * USEC_PER_MSEC);
-		if (err)
-			dev_dbg(dev, "PCIe link training gen2 timeout, fall back to gen1!\n");
-	}
-
 	/* Check the final link width from negotiated lane counter from MGMT */
 	status = rockchip_pcie_read(rockchip, PCIE_CORE_CTRL);
 	status = 0x1 << ((status & PCIE_CORE_PL_CONF_LANE_MASK) >>
-- 
2.53.0



