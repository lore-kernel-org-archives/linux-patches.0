Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059536;
	b=yELesxGx9lwDuyMyDDL8nvup0qAYizpT52HAd+muh/6nUwTpFoZU0mcporhrt9aFpI6I
	 1o05+MzH+Shxzz9Gk5V3mzIVlj3RDqNoSZvLzrh6qtRub/YmvPAEUZrGhbvh7pfeSBBDl
	 T6CDPOnnKINMo/vZwKdq2dklrGBmsLoRTtmeV3GPkLyDUVoqcjGlQMx+/PgEL5oog96AK
	 VJpNr9+nKEGQq61bztjqAlEaW7r9cph2O+FZKCPO7B14nkoQKeVYYeXiBbGQjxF94IWyO
	 fjBfZGIEAranLYDaVp/XfDK2rcC2PEDRDYD8dlwb8Z+8HEtp5+MyOkf5659sg5g6tTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lPGJRJKyEZjC7g9aWS4ofYX6n71NhXfC53VglHKF3wg=;
	b=UGZwsNqajtg52/fxBjEGphc+CRN/EU832s6elPEGpvaKegEMTYvBE0uKqyQHcLIy/r5K
	 LC+7TDyjYpz6nAKJ0LMLYiU6Hv6h3VYpGvYgIhcAQAN6HVPsSn0L/0nJH9pR5TIgRPA6B
	 V1iBW4pJ/tryAMI33EieZ9InDLBWs8xwalfZyI4CGrJws5GJml+ZpzYSmgROXS5iATMh3
	 V3Fd3mzVPFGNOqIGESo7MpqatPLcL5Lsy2fvprnn1R4vRkbTTR6WSUCsUeTw7cL45EoVm
	 Yf3Rf1ro1ee3xVI+5zvlWnAzp7HdndxR/PdVoCCVH8FVNAJb5ZCC1cq2z/UbRriMlow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CSRjqk6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62B9606A32A;
	Thu, 19 Nov 2026 03:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSRjqk6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ADC1F000C4;
	Thu, 19 Nov 2026 03:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059536;
	bh=lPGJRJKyEZjC7g9aWS4ofYX6n71NhXfC53VglHKF3wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSRjqk6/m9gUr6FfM6elV07JuJ8RiLTxRypMkQk+Ybzkis+2afPqZ+UUNjGZLRPdx
	 OsteYcky+pfNIT7dSFy2vcPn94ZTTxHg0cZmAo+sNyLvno2X5/Rr/2PV7L/dP0WSvK
	 640GbY5sVtcA8SllcMkxF/WqhHkwlhTa0OXq9SHk=
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
Subject: [PATCH 5.10 0876/1848] PCI: rockchip-host: Do not attempt 5.0 GT/s retraining
Date: Wed, 18 Nov 2026 15:48:34 +0100
Message-ID: <20261118145953.078109770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted retraining removal to the older sequence using PCIE_RC_CONFIG_LCS ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-host.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index 90f3e69b5d940..aa8e9f73478bc 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -339,22 +339,6 @@ static int rockchip_pcie_host_init_port(struct rockchip_pcie *rockchip)
 		goto err_power_off_phy;
 	}
 
-	if (rockchip->link_gen == 2) {
-		/*
-		 * Enable retrain for gen2. This should be configured only after
-		 * gen1 finished.
-		 */
-		status = rockchip_pcie_read(rockchip, PCIE_RC_CONFIG_LCS);
-		status |= PCI_EXP_LNKCTL_RL;
-		rockchip_pcie_write(rockchip, status, PCIE_RC_CONFIG_LCS);
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



